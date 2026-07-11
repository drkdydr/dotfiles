# Defined via `source`
function neofetch --wraps='clear;fastfetch --disable-linewrap true --pipe false|lolcat' --description 'alias neofetch clear;fastfetch --disable-linewrap true --pipe false|lolcat'
    clear;fastfetch --disable-linewrap true --pipe false|lolcat $argv
end
