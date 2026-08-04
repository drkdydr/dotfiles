# this is a short script for syncing my config files to the folder that my dotfiles repository is attached to
# if you are not me or using my computer this will not serve you

#!/bin/bash

DOTFILES_FOLDER="$HOME/projects/dotfiles"
DEFAULT_MSG="dotfile updated."

print_help(){
cat<< EOF
usage: updot [OPTION]
pushes dotfile changes to github
options:
      -m, --message <commit_message> : specifies custom commit message
      --no-git                       : skips git operations
      --no-push                      : does not push changes

EOF
}

message=$DEFAULT_MSG

no_git=0
no_push=0

while [[ $# -gt 0 ]]; do
      case $1 in
            -h|--help)
                  print_help
                  exit 0
                  ;;
            -m|--message)
                  if [[ -z "$2" || "$2" == -* ]]; then
                        echo "updot : missing argument"
                        exit 1
                  fi

                  message=$2
                  shift 2
                  ;;
            --no-git)
                  no_git=1
                  shift 1
                  ;;
            --no-push)
                  no_push=1
                  shift 1
                  ;;
            *)
                  echo "updot : unknown argument"
                  exit 0
                  ;;
      esac
done

#check if rsync is installed
if ! command -v rsync >/dev/null 2>&1
then
    echo "updot: rsync could not be found. try "sudo dnf install -y rsync"."
    exit 1
fi

#create destination folders if not exist
mkdir -p $DOTFILES_FOLDER/hyprland/hypr
mkdir $DOTFILES_FOLDER/hyprland/kitty 
mkdir $DOTFILES_FOLDER/hyprland/picom 
mkdir $DOTFILES_FOLDER/hyprland/waybar
mkdir $DOTFILES_FOLDER/nvim 
mkdir $DOTFILES_FOLDER/fish 
mkdir $DOTFILES_FOLDER/bin 

# backup dotfiles

# nvim dotfiles
rsync -avz --delete $HOME/.config/nvim/. $DOTFILES_FOLDER/nvim

#hyprland dotfiles
rsync -avz --delete $HOME/.config/hypr/. $DOTFILES_FOLDER/hyprland/hypr/
rsync -avz --delete $HOME/.config/kitty/. $DOTFILES_FOLDER/hyprland/kitty/
rsync -avz --delete $HOME/.config/picom/. $DOTFILES_FOLDER/hyprland/picom/   #for kitty transparency
rsync -avz --delete $HOME/.config/waybar/. $DOTFILES_FOLDER/hyprland/waybar/
 

# shell dotfiles
cp $HOME/.bashrc $DOTFILES_FOLDER
cp $HOME/.zshrc $DOTFILES_FOLDER # they can stay as cp
rsync -avz --delete $HOME/.config/fish/. $DOTFILES_FOLDER/fish/
 
# backup bin folder
rsync -avz --delete $HOME/bin/my/. $DOTFILES_FOLDER/bin/

# return # remove before push

# commit & push changes

if [[ $no_git -eq 0 ]]; then
      cd $DOTFILES_FOLDER
      git add .
      git commit -m "$message"
      if [[ $no_push -eq 0 ]]; then
            git push
      fi
fi
