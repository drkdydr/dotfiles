#!/bin/bash

DOTFILES_FOLDER="$HOME/projects/dotfiles/"
DEFAULT_MSG="dotfile updated."

print_help(){
cat<< EOF
usage: updot [OPTION]
pushes dotfile changes to github
options:
      -m, --message <commit_message> : specifies custom commit message

EOF
}

message=$DEFAULT_MSG

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
            *)
                  echo "updot : unknown argument"
                  exit 0
                  ;;
      esac
done

# backup dotfiles

# nvim dotfiles
cp -r $HOME/.config/nvim $DOTFILES_FOLDER

#hyprland dotfiles
cp -r $HOME/.config/hypr $DOTFILES_FOLDER

# shell dotfiles
cp $HOME/.bashrc $DOTFILES_FOLDER
cp $HOME/.zshrc $DOTFILES_FOLDER

# backup bin folder
cp -r $HOME/bin $DOTFILES_FOLDER

# commit & push changes

cd $DOTFILES_FOLDER
git add .
git commit -m "$message"
git push
