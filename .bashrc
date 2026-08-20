# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

export PATH="$JAVA_HOME/bin:$PATH"; 
export PATH="/opt/idea-IU-252.26199.169/bin:$PATH";
export PATH="$HOME/.local/bin/my-scripts:$PATH";

alias zen="flatpak run app.zen_browser.zen";
alias whereami="pwd";

# oha script folder:
export PATH="/etc/oha-script:$PATH"

alias reboot="sudo reboot";
alias shutdown="sudo shutdown";

export PATH="/etc/ookla-speedtest:$PATH";

#bitwarden password:
alias bitwarden="sudo cat ~/Desktop/main/drk/bitwarden.txt | wl-copy ; echo \"password copied successfully.\"";
alias ali="alias"
. "$HOME/.cargo/env"

alias ethernetRefresh="sudo dkms remove -m r8168 -v all --all 2>/dev/null || true; sudo rm -rf /var/lib/dkms/r8168; sudo dkms add -m r8168 -v 8.055.00-1; sudo dkms build -m r8168 -v 8.055.00-1; sudo dkms install --force -m r8168 -v 8.055.00-1; sudo modprobe -r 8169 2>/dev/null; sudo modprobe r8168"

export EDITOR=/usr/bin/vim;

alias close="exit";

#gtk
export PKG_CONFIG_PATH="/opt/gtk/lib64/pkgconfig:/opt/gtk/lib/pkgconfig:$PKG_CONFIG_PATH";
export LD_LIBRARY_PATH="/opt/gtk/lib64:/opt/gtk/lib:$LD_LIBRARY_PATH";

export PATH="$HOME/bin:$PATH"

DOTTEMP="$HOME/Desktop/project/.temp/"
