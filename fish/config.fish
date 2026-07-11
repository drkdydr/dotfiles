# left hand side 
function fish_prompt
    # Klasör ismi rengi (Görseldeki gibi soluk camgöbeği/yeşil)
    set_color c9ccca 
    echo -n (prompt_pwd)
    
    # Ok işareti rengi
    set_color FFFFFF
    echo -n " > "
    
    # Yazı rengini normale döndür
    set_color normal
end

# right hand side (time)
function fish_right_prompt
    # Görseldeki soluk/gri saat rengi
    set_color 767676
    date "+%H:%M:%S"
    set_color normal
end

# disable greeting
set -g fish_greeting ""
# show fullpath
set -g fish_prompt_pwd_dir_length 0

# custom theme
fish_config theme choose my
