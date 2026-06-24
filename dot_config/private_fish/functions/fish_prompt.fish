function fish_prompt
    source ~/.config/fish/colors.fish

    set -l corner_top_left \u256D
    set -l corner_bottom_left \u2570
    set -l line_horizontal \u2500
    set -l arrow_right \uE0B0

    set_color -b normal
    set_color $dark_color
    echo -n $corner_top_left
    echo -n $line_horizontal

    set_color -b $dark_color $light_color
    echo -n "    "
    set_color -b $muted_color $dark_color
    echo -n $arrow_right

    set_color -b $muted_color $light_color
    echo -n " "(whoami)" "

    set_color -b $vidrant_color $muted_color
    echo -n $arrow_right

    set_color -b $vidrant_color $light_color
    echo -n "  "
    echo -n " "
    echo -n (prompt_pwd)
    echo -n " "

    set_color -b normal $vidrant_color
    echo $arrow_right
    
    set_color -b normal
    set_color $dark_color
    echo -n $corner_bottom_left
    echo -n $line_horizontal
    
    set_color normal
end
