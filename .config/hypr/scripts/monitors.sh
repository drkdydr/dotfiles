#!/usr/bin/env bash
# monwin.sh — Hyprland için monitor / workspace / window yönetim scripti
#
# Kullanım:
#   monwin.sh <mode> <obj> <direction>
#     mode      : focus | move | swap
#     obj       : monitor | workspace | window
#     direction : left | right | up | down     (window ve monitor için)
#                 front | back                 (workspace focus için, aktif monitör içinde)
#
# Davranışlar (obj bazlı):
#   monitor focus       -> komşu monitöre fokusu taşı
#   monitor move        -> TÜM monitörlerin içeriğini bir yönde döndür (a b c -> c a b)
#   monitor swap        -> aktif monitör ile komşusunun TÜM workspace'lerini değiştir
#   workspace focus     -> front/back: aktif monitör içindeki workspace'ler arası gezin
#   workspace move      -> aktif workspace'i komşu monitöre taşı
#   workspace swap      -> aktif monitör ile komşusunun AKTİF workspace'lerini değiştir
#   window   focus      -> yöne göre pencere fokusu
#   window   move       -> yöne göre taşı; kenardaysa komşu monitörün aktif workspace'ine it
#   window   swap       -> yöne göre değiştir; kenardaysa komşu monitörün aktif workspace'indeki
#                          karşı kenar penceresiyle değiştir
#   (yukarı/aşağı yönlerde monitör geçişi yok — tek sıra yatay monitör düzeni varsayılıyor)
#
# NOT: "aktif monitör" her yerde imleç konumuna göre DEĞİL, activeworkspace'in
# bağlı olduğu monitöre göre hesaplanıyor (follow_mouse imleç takibinden bağımsız).
#
# Kaynaklar:
#   https://wiki.hypr.land/Configuring/Basics/Dispatchers/
#   https://wiki.hypr.land/Configuring/Advanced-and-Cool/Using-hyprctl/

set -euo pipefail

mode=${1:-}
obj=${2:-}
direction=${3:-}

usage() {
  echo "kullanım: $(basename "$0") <focus|move|swap> <monitor|workspace|window> <left|right|up|down|front|back>" >&2
  echo "       veya: $(basename "$0") new workspace <herhangi_bir_şey>   (aktif monitörde yeni workspace açar, direction yok sayılır)" >&2
  exit 1
}

[[ -z "$mode" || -z "$obj" || -z "$direction" ]] && usage

# --- isteğe bağlı "hassasiyet düşürme" (sadece MONWIN_SCROLL_THRESHOLD set edilirse aktif) ---
# Zaman tabanlı bloklama yerine SAYIM tabanlı: N scroll event'i (gerçek tık +
# chatter dahil) birikmeden workspace değiştirmez. Sadece fare bind'larından çağır:
#   MONWIN_SCROLL_THRESHOLD=3 monwin.sh focus workspace front
# Klavye kısayolları bu değişkeni set etmediği sürece hiç etkilenmez.
SCROLL_THRESHOLD=${MONWIN_SCROLL_THRESHOLD:-0}
if (( SCROLL_THRESHOLD > 0 )); then
  RESET_MS=${MONWIN_SCROLL_RESET_MS:-800}
  _cnt_file="/tmp/.monwin_scrollcount_${mode}_${obj}_${direction}"
  _now_ms=$(date +%s%3N)
  _count=0
  _last_ms=0
  [[ -f "$_cnt_file" ]] && read -r _count _last_ms < "$_cnt_file"
  (( _now_ms - _last_ms > RESET_MS )) && _count=0
  _count=$(( _count + 1 ))
  if (( _count >= SCROLL_THRESHOLD )); then
    echo "0 $_now_ms" > "$_cnt_file"
  else
    echo "$_count $_now_ms" > "$_cnt_file"
    exit 0
  fi
fi

dispatch() {
  if [[ -n "${MONWIN_DEBUG:-}" ]]; then
    echo "[dispatch] $1" >> /tmp/monwin_debug.log
    echo "[dispatch] $1" >&2
  fi
  hyprctl dispatch "$1"
}

debug_log() {
  if [[ -n "${MONWIN_DEBUG:-}" ]]; then
    echo "[debug] $*" >> /tmp/monwin_debug.log
    echo "[debug] $*" >&2
  fi
}

# --- monitörleri x konumuna göre soldan sağa sırala ---
json=$(hyprctl monitors -j)
mapfile -t mon_ids   < <(jq -r 'sort_by(.x)[].id'   <<< "$json")
mapfile -t mon_names < <(jq -r 'sort_by(.x)[].name' <<< "$json")

# "aktif monitör" = klavye/pencere odağının olduğu workspace'in monitörü
# (hyprctl monitors -j'nin .focused alanı imleç konumuna göre değişiyor, güvenilmez)
focused_id=$(jq -r '.monitorID' <<< "$(hyprctl activeworkspace -j)")

current_index=-1
for i in "${!mon_ids[@]}"; do
  if [[ "${mon_ids[$i]}" == "$focused_id" ]]; then
    current_index=$i
    break
  fi
done
(( current_index == -1 )) && { echo "aktif monitör bulunamadı" >&2; exit 1; }

mon_count=${#mon_ids[@]}

# soldaki/sağdaki komşu monitörün array index'ini döndürür
# (dairesel: en soldakinden 'left' istenirse en sağa sarar)
target_index_for() {
  local dir=$1
  case "$dir" in
    left)  echo $(( (current_index - 1 + mon_count) % mon_count )) ;;
    right) echo $(( (current_index + 1) % mon_count )) ;;
    *) echo "komşu monitör için 'left' veya 'right' gerekli" >&2; exit 1 ;;
  esac
}

# bir workspace'teki tiled (floating olmayan) pencerelerin adreslerini x'e göre sıralı döndürür
tiled_window_addrs_on_workspace() {
  local ws_id=$1
  jq -r --argjson id "$ws_id" \
    '[.[] | select(.workspace.id == $id and (.floating|not))] | sort_by(.at[0]) | .[].address' \
    <<< "$(hyprctl clients -j)"
}

# aktif monitördeki workspace'ler arasında ileri/geri gider — Hyprland'ın
# 'm+1'/'m-1' seçicisi yerine hedef workspace ID'sini kendimiz hesaplayıp
# açıkça dispatch ediyoruz (bkz. üstteki not).
focus_workspace_relative() {
  local dir=$1
  local aws active_ws_id mon_id ws_json
  aws=$(hyprctl activeworkspace -j)
  active_ws_id=$(jq -r '.id' <<< "$aws")
  mon_id=$(jq -r '.monitorID' <<< "$aws")

  ws_json=$(hyprctl workspaces -j)
  local -a ws_list
  mapfile -t ws_list < <(jq -r --argjson id "$mon_id" \
    '[.[] | select(.monitorID == $id and .id > 0) | .id] | sort_by(.) | .[]' <<< "$ws_json")

  local count=${#ws_list[@]}
  (( count == 0 )) && { echo "monitörde workspace bulunamadı" >&2; exit 1; }

  local idx=-1
  for i in "${!ws_list[@]}"; do
    [[ "${ws_list[$i]}" == "$active_ws_id" ]] && idx=$i && break
  done
  (( idx == -1 )) && idx=0

  # ID karşılaştırmalı slide animasyonu gerçek bir wrap'te (son->ilk ya da
  # ilk->son) yanlış yöne kayar (Hyprland'ın kendi kısıtı, ayarla düzelmiyor).
  # Bunu tespit edip SADECE o geçişte animasyonu kapatıp anlık geçiyoruz.
  local target_idx wrapping=0
  case "$dir" in
    front)
      (( idx == count - 1 )) && wrapping=1
      target_idx=$(( (idx + 1) % count ))
      ;;
    back)
      (( idx == 0 )) && wrapping=1
      target_idx=$(( (idx - 1 + count) % count ))
      ;;
  esac

  if (( wrapping == 1 )); then
    # NOT: aşağıdaki satırlar hyprland.lua'daki workspacesIn/workspacesOut
    # animasyon ayarlarınla birebir aynı olmalı (speed/bezier) — orayı
    # değiştirirsen burayı da güncelle. workspacesOut zaten fade olduğu için
    # ona dokunmuyoruz, sadece yön sorunu olan workspacesIn'i geçici fade yapıyoruz.
    hyprctl eval 'hl.animation({ leaf = "workspacesIn", enabled = true, speed = 2.54, bezier = "easeInOutCubic", style = "fade" })' >/dev/null
    dispatch "hl.dsp.focus({ workspace = ${ws_list[$target_idx]} })"
    hyprctl eval 'hl.animation({ leaf = "workspacesIn", enabled = true, speed = 2.54, bezier = "easeInOutCubic", style = "slidevert" })' >/dev/null
  else
    dispatch "hl.dsp.focus({ workspace = ${ws_list[$target_idx]} })"
  fi
}

# iki monitöre ait TÜM (özel/scratchpad olmayan) workspace'leri karşılıklı taşır.
# Her zaman canlı veriyi tazeler (rotate_all_monitors gibi ardışık çağrılarda
# eski/durağan veri kullanmamak için).
#
# Aktif workspace'i düz "move" ile taşırsan, yerine geleni henüz ulaşmadan
# monitör "workspace'siz" kalıp yeni BOŞ bir workspace açıyor. Bunu önlemek
# için aktif olmayanları normal move ile, aktif ikiliyi ise TEK bir atomik
# swap_monitors çağrısıyla değiştiriyoruz.
swap_all_workspaces() {
  local mon1_name=$1 mon1_id=$2 mon2_name=$3 mon2_id=$4
  local -a ws1 ws2
  local active1 active2 ws_json mon_json

  mon_json=$(hyprctl monitors -j)
  active1=$(jq -r --argjson id "$mon1_id" '.[] | select(.id == $id) | .activeWorkspace.id' <<< "$mon_json")
  active2=$(jq -r --argjson id "$mon2_id" '.[] | select(.id == $id) | .activeWorkspace.id' <<< "$mon_json")

  ws_json=$(hyprctl workspaces -j)
  mapfile -t ws1 < <(jq -r --argjson id "$mon1_id" \
    '.[] | select(.monitorID == $id and .id > 0) | .id' <<< "$ws_json")
  mapfile -t ws2 < <(jq -r --argjson id "$mon2_id" \
    '.[] | select(.monitorID == $id and .id > 0) | .id' <<< "$ws_json")

  for ws in "${ws1[@]}"; do
    [[ "$ws" == "$active1" ]] && continue
    dispatch "hl.dsp.workspace.move({ workspace = $ws, monitor = '$mon2_name' })"
  done
  for ws in "${ws2[@]}"; do
    [[ "$ws" == "$active2" ]] && continue
    dispatch "hl.dsp.workspace.move({ workspace = $ws, monitor = '$mon1_name' })"
  done

  dispatch "hl.dsp.workspace.swap_monitors({ monitor1 = '$mon1_name', monitor2 = '$mon2_name' })"
}

# TÜM monitörlerin içeriğini (workspace setlerini) bir yönde döndürür:
# right: a b c -> c a b   /   left: a b c -> b c a
# Ardışık komşu-çiftler arası atomik swap_all_workspaces çağrılarına bölünerek
# yapılır (her adım kendi içinde race-safe olduğu için tamamı da safe olur).
rotate_all_monitors() {
  local dir=$1
  (( mon_count < 2 )) && return
  if [[ "$dir" == "right" ]]; then
    for (( i = mon_count - 1; i >= 1; i-- )); do
      swap_all_workspaces "${mon_names[$i]}" "${mon_ids[$i]}" "${mon_names[$((i-1))]}" "${mon_ids[$((i-1))]}"
    done
  else
    for (( i = 0; i <= mon_count - 2; i++ )); do
      swap_all_workspaces "${mon_names[$i]}" "${mon_ids[$i]}" "${mon_names[$((i+1))]}" "${mon_ids[$((i+1))]}"
    done
  fi
}

# Kenar durumunda hedef monitörü ve (varsa) orada karşılanacak pencereyi hesaplar.
# Kural her zaman aynı (wrap olsun olmasın): sağa gidince hedefin EN SOLUNDAKİ
# penceresine girilir, sola gidince hedefin EN SAĞINDAKİ penceresine girilir —
# tüm monitörler tek bir dairesel pencere dizisi gibi düşünülüyor.
compute_edge_target() {
  local dir=$1
  local target_index
  target_index=$(target_index_for "$dir")
  EDGE_TARGET_NAME=${mon_names[$target_index]}
  EDGE_TARGET_ID=${mon_ids[$target_index]}

  local target_ws_id
  target_ws_id=$(jq -r --argjson id "$EDGE_TARGET_ID" '.[] | select(.id==$id) | .activeWorkspace.id' <<< "$(hyprctl monitors -j)")
  EDGE_TARGET_WS_ID=$target_ws_id

  local -a target_addrs
  mapfile -t target_addrs < <(tiled_window_addrs_on_workspace "$target_ws_id")

  EDGE_OTHER_ADDR=""
  if (( ${#target_addrs[@]} > 0 )); then
    if [[ "$dir" == "right" ]]; then
      EDGE_OTHER_ADDR=${target_addrs[0]}
    else
      EDGE_OTHER_ADDR=${target_addrs[-1]}
    fi
  fi

  debug_log "compute_edge_target dir=$dir target_monitor=$EDGE_TARGET_NAME(id=$EDGE_TARGET_ID) target_ws=$EDGE_TARGET_WS_ID target_addrs=[${target_addrs[*]:-}] other_addr=${EDGE_OTHER_ADDR:-<none>}"
}

# window focus/move/swap: yukarı/aşağıda her zaman normal davranış (tek sıra
# monitör düzeni varsayımı). Sol/sağda pencere zaten o yöndeki en kenardaysa,
# komşu monitörün aktif workspace'ine geç/it (focus/move) ya da oradaki uygun
# kenar penceresiyle değiştir (swap) — bkz. compute_edge_target.
window_directional() {
  local verb=$1 dir=$2

  local plain_dispatch
  if [[ "$verb" == "focus" ]]; then
    plain_dispatch="hl.dsp.focus({ direction = '$dir' })"
  else
    plain_dispatch="hl.dsp.window.${verb}({ direction = '$dir' })"
  fi

  if [[ "$dir" == "up" || "$dir" == "down" ]]; then
    dispatch "$plain_dispatch"
    return
  fi

  local aw active_addr active_ws_id
  aw=$(hyprctl activewindow -j)
  active_addr=$(jq -r '.address' <<< "$aw")
  active_ws_id=$(jq -r '.workspace.id' <<< "$aw")

  local -a addrs
  mapfile -t addrs < <(tiled_window_addrs_on_workspace "$active_ws_id")

  local n=${#addrs[@]}
  local idx=-1
  for i in "${!addrs[@]}"; do
    [[ "${addrs[$i]}" == "$active_addr" ]] && idx=$i && break
  done

  local at_edge=0
  [[ "$dir" == "left"  && $idx -eq 0 ]] && at_edge=1
  [[ "$dir" == "right" && $idx -eq $((n - 1)) ]] && at_edge=1

  debug_log "window_directional verb=$verb dir=$dir active_addr=$active_addr active_ws=$active_ws_id idx=$idx of n=$n addrs=[${addrs[*]:-}] at_edge=$at_edge"

  if (( at_edge == 0 )); then
    debug_log "kenarda değil, düz dispatch: $plain_dispatch"
    dispatch "$plain_dispatch"
    return
  fi

  compute_edge_target "$dir"

  case "$verb" in
    focus)
      if [[ -n "$EDGE_OTHER_ADDR" ]]; then
        dispatch "hl.dsp.focus({ window = 'address:$EDGE_OTHER_ADDR' })"
      else
        dispatch "hl.dsp.focus({ monitor = '$EDGE_TARGET_NAME' })"
      fi
      ;;
    move)
      if [[ -z "$EDGE_OTHER_ADDR" ]]; then
        # hedef workspace'te tiled pencere yok, çakışma riski yok -> düz taşı yeterli
        dispatch "hl.dsp.window.move({ monitor = '$EDGE_TARGET_NAME' })"
        return
      fi
      # Hyprland'ın "şu kenara ekle" diye bir primitive'i yok, sadece iki pencerenin
      # yerini garantili değiştirebiliyoruz. Bu yüzden move'un kenar davranışı da
      # swap ile aynı mekanizmayı kullanıyor (kenardaki pencereyle yer değiştir) —
      # tek farkı yok, ama en azından HANGİ kenara düştüğü artık tutarlı/garantili.
      dispatch "hl.dsp.window.move({ window = 'address:$active_addr', workspace = $EDGE_TARGET_WS_ID })"
      dispatch "hl.dsp.window.move({ window = 'address:$EDGE_OTHER_ADDR', workspace = $active_ws_id })"
      dispatch "hl.dsp.focus({ window = 'address:$active_addr' })"
      ;;
    swap)
      if [[ -z "$EDGE_OTHER_ADDR" ]]; then
        dispatch "hl.dsp.window.move({ monitor = '$EDGE_TARGET_NAME' })"
        return
      fi
      dispatch "hl.dsp.window.move({ window = 'address:$active_addr', workspace = $EDGE_TARGET_WS_ID })"
      dispatch "hl.dsp.window.move({ window = 'address:$EDGE_OTHER_ADDR', workspace = $active_ws_id })"
      dispatch "hl.dsp.focus({ window = 'address:$active_addr' })"
      ;;
  esac
}

case "$obj" in

  window)
    case "$mode" in
      focus) window_directional focus "$direction" ;;
      move)  window_directional move  "$direction" ;;
      swap)  window_directional swap  "$direction" ;;
      *) usage ;;
    esac
    ;;

  monitor)
    case "$mode" in
      focus)
        target_index=$(target_index_for "$direction")
        dispatch "hl.dsp.focus({ monitor = '${mon_names[$target_index]}' })"
        ;;
      move)
        rotate_all_monitors "$direction"
        ;;
      swap)
        target_index=$(target_index_for "$direction")
        swap_all_workspaces \
          "${mon_names[$current_index]}" "${mon_ids[$current_index]}" \
          "${mon_names[$target_index]}"  "${mon_ids[$target_index]}"
        ;;
      *) usage ;;
    esac
    ;;

  workspace)
    case "$mode" in
      focus)
        case "$direction" in
          front) focus_workspace_relative front ;;
          back)  focus_workspace_relative back ;;
          *) echo "workspace focus için 'front' veya 'back' bekleniyor" >&2; exit 1 ;;
        esac
        ;;
      move)
        target_index=$(target_index_for "$direction")
        dispatch "hl.dsp.workspace.move({ monitor = '${mon_names[$target_index]}' })"
        ;;
      swap)
        target_index=$(target_index_for "$direction")
        dispatch "hl.dsp.workspace.swap_monitors({ monitor1 = '${mon_names[$current_index]}', monitor2 = '${mon_names[$target_index]}' })"
        ;;
      new)
        # aktif monitörde ilk boş/kullanılmamış workspace'i oluşturup ona geçer
        dispatch "hl.dsp.focus({ workspace = 'empty' })"
        ;;
      *) usage ;;
    esac
    ;;

  *) usage ;;
esac
