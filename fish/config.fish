
# ========= CONFIGS ==========

# disable greeting
set -g fish_greeting ""
# show fullpath
set -g fish_prompt_pwd_dir_length 0

# custom theme
fish_config theme choose my

# ========= VARIABLES ==========

set -g JAVA_HOME "/usr/bin/jvm/jdk-21.0.2"
# equivalent to JAVA_HOME="/usr/lib/jvm/jdk-21.0.2"
set -g DOTTEMP "$HOME/projects/.temp"
set -g EDITOR "nvim"
set -g VISUAL "nvim"
set -g SHELL "/usr/bin/fish"

set -g PKG_CONFIG_PATH /usr/local/lib64/pkgconfig 
set -gx PKG_CONFIG_PATH /opt/gtk/lib64/pkgconfig /opt/gtk/lib/pkgconfig $PKG_CONFIG_PATH

# set -gx LD_LIBRARY_PATH $LD_LIBRARY_PATH

# ========= PATHS ==========

# maybe later you can write a script for automatically get paths from a file and add (file named .paths)
fish_add_path $HOME/bin
fish_add_path $HOME/bin/my
fish_add_path $HOME/devel/flutter/bin
fish_add_path /etc/oha-script # oha
fish_add_path $JAVA_HOME/bin:$PATH; 
fish_add_path /opt/idea-IU-252.26199.169/bin:$PATH;
fish_add_path $HOME/.local/bin/my-scripts:$PATH;
fish_add_path $HOME/.cargo/bin/
fish_add_path /etc/ookla-speedtest

# ========= ALIASES ==========

abbr shutdown "sudo shutdown now"
abbr reboot "sudo reboot"
abbr zen "flatpak run app.zen_browser.zen"
abbr fih "fish"
alias whereami "pwd"
alias close "exit"
alias fixkbspeed "xset r rate 200 40" # solves long press detection issue
alias python "python3"
abbr h "help"
abbr ali "alias"

# ========= FUNCTIONS ==========

function mkcwd -d "creates directory and sets cwd"
      command mkdir $argv
      if test $status = 0
            switch $argv[(count $argv)]
                  case '-*'

                  case '*'
                        cd $argv[(count $argv)]
                        return
            end
      end
end

function rmcwd -d "deletes cwd recursively"
      set cwd (pwd)
      cd ..
      rm -r $cwd
end

function bitwarden --description "copies bitwarden password to your clipboard"
      set password_file_loc $HOME/Desktop/main/drk/bitwarden.txt
      sudo cat $password_file_loc | wl-copy && echo -ne "password copied to your clipboard!\n"
end

function help --description "overrided version of help"
      # no args
    if test (count $argv) -eq 0
        fish -c "help"
        return
    end

    # my own programs list
    set my_programs legame fuck tudu projects

    if contains $argv[1] $my_programs
        eval $argv[1] --help
    else
        fish -c "help $argv"
    end
end

# ========= LOOK AND FEEL ==========

# left hand side 
function fish_prompt
    # directory name
    set_color c9ccca 
    echo -n (prompt_pwd)
    
    # user char 
    set_color FFFFFF
    set -l user_char '>'
    if fish_is_root_user
        set user_char '#' # this will never be displayed because root shell is bash
    end
    echo -n " $user_char "
    
    # set color back to normal
    set_color normal
end

# right hand side (time)
function fish_right_prompt
    set_color 767676
    date "+%H:%M:%S"
    set_color normal
end
