#!/bin/bash

THEME_DIR="$HOME/.config/themes"
CACHE_FILE="$HOME/.cache/current_theme"

mapfile -t THEMES < <(basename -a "$THEME_DIR"/* 2>/dev/null)

if [ ${#THEMES[@]} -eq 0 ]; then
    echo "Error: No topics found in $THEME_DIR"
    exit 1
fi

CURRENT_THEME=$(cat "$CACHE_FILE" 2>/dev/null)
CURRENT_INDEX=-1

for i in "${!THEMES[@]}"; do
    if [ "${THEMES[$i]}" = "$CURRENT_THEME" ]; then
        CURRENT_INDEX=$i
        break
    fi
done

NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#THEMES[@]} ))
NEXT_THEME="${THEMES[$NEXT_INDEX]}"

source <(sed 's/\r$//' "$THEME_DIR/$NEXT_THEME")

echo "$NEXT_THEME" > "$CACHE_FILE"


# WALL
if [ -n "$WALLPAPER" ] && [ -f "$WALLPAPER" ]; then
    CURRENT_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"

    if ! pgrep -x "awww-daemon" > /dev/null; then
        awww-daemon --namespace "$CURRENT_DISPLAY" > /dev/null 2>&1 &
        sleep 0.4
    fi

    CURSOR_POS=$(hyprctl cursorpos | tr -d '[:space:]')
    
    awww img --namespace "$CURRENT_DISPLAY" "$WALLPAPER" \
        --transition-type grow \
        --transition-pos "$CURSOR_POS" \
        --transition-duration 0.6 \
        --transition-bezier .42,0,.58,1 \
        --invert-y > /dev/null 2>&1
fi


# FISH IMG
if [ -n "$FISH_PHOTO" ] && [ -f "$FISH_PHOTO" ]; then
    ln -sf "$FISH_PHOTO" "$HOME/.config/fish/current_photo.jpg"
else
    echo "Warning: Variable FISH_PHOTO is empty or file not found in topic $NEXT_THEME"
fi


# FISH Powerline
cat <<EOF > "$HOME/.config/fish/colors.fish"
set -g dark_color '$DARK_COLOR'
set -g muted_color '$MUTED_COLOR'
set -g vidrant_color '$MID_COLOR'
set -g light_color '#$LIGHT_COLOR'
EOF


# WAYBAR
cat <<EOF > "$HOME/.config/waybar/global_colors.css"
@define-color dark_color #$DARK_COLOR;
@define-color muted_color #$MUTED_COLOR;
@define-color mid_color #$MID_COLOR;
@define-color vidrant_color #$VIDRANT_COLOR;
@define-color light_color #$LIGHT_COLOR;
EOF

killall waybar 2>/dev/null
sleep 0.1
waybar & disown 2>/dev/null


# CAVA
cat <<EOF > "$HOME/.config/cava/themes/colors"
[color]
background = default

gradient = 1
gradient_color_1 = '#$CAVA_GR_1'
gradient_color_2 = '#$CAVA_GR_2'
gradient_color_3 = '#$CAVA_GR_3'
gradient_color_4 = '#$CAVA_GR_4'
gradient_color_5 = '#$CAVA_GR_5'
EOF

killall -USR2 cava 2>/dev/null


# HYPRLAND
ACTIVE_CLEAN=$(echo "$VIDRANT_COLOR" | tr -d '#')
INACTIVE_CLEAN=$(echo "$DARK_COLOR" | tr -d '#')

cat <<EOF > "$HOME/.config/hypr/theme.tmp"
\$wallpaper_path = $WALLPAPER
\$lock_color_1 = $MID_COLOR
\$lock_color_2 = $LIGHT_COLOR

\$active_border = 0xff$ACTIVE_CLEAN
\$inactive_border = 0xff$INACTIVE_CLEAN
EOF

mv "$HOME/.config/hypr/theme.tmp" "$HOME/.config/hypr/theme"


# WOFI
WOFI_CSS="$HOME/.config/wofi/style.css"
mkdir -p "$(dirname "$WOFI_CSS")"
touch "$WOFI_CSS"

WOFI_COLORS=(
    "wofi_vidrant_color:#$VIDRANT_COLOR"
    "wofi_light_color:#$LIGHT_COLOR"
    "wofi_dark_color:#$DARK_COLOR"
)

for item in "${WOFI_COLORS[@]}"; do
    NAME="${item%%:*}"
    VALUE="${item#*:}"
    COLOR_LINE="@define-color $NAME $VALUE;"

    if grep -q "@define-color $NAME" "$WOFI_CSS"; then
        sed -i "s|@define-color $NAME.*|$COLOR_LINE|" "$WOFI_CSS"
    else
        TEMP_CSS=$(mktemp)
        echo -e "$COLOR_LINE\n$(cat "$WOFI_CSS")" > "$TEMP_CSS"
        mv "$TEMP_CSS" "$WOFI_CSS"
    fi
done


# KITTY
cat <<EOF > "$HOME/.config/kitty/theme.conf"
foreground #$TERM_FG
background #$TERM_BG

background_opacity $BG_OPACITY

# Black
color0 #$TERM_COLOR_0
color8 #$TERM_COLOR_8

# Red
color1 #$TERM_COLOR_1
color9 #$TERM_COLOR_9

# Green
color2  #$TERM_COLOR_2
color10 #$TERM_COLOR_10

# Yellow
color3  #$TERM_COLOR_3
color11 #$TERM_COLOR_11

# Blue
color4  #$TERM_COLOR_4
color12 #$TERM_COLOR_12

# Magenta
color5  #$TERM_COLOR_5
color13 #$TERM_COLOR_13

# Cyan
color6  #$TERM_COLOR_6
color14 #$TERM_COLOR_14

# White
color7  #$TERM_COLOR_7
color15 #$TERM_COLOR_15

# Cursor
cursor #$CURSOR_COLOR
cursor_text_color #$CURSOR_TEXT_COLOR

# URL
url_color #$URL_COLOR
EOF
