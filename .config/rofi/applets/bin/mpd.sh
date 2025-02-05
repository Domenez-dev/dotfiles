#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : MPD (music)

# Import Current Theme
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

# Theme Elements
status="$(playerctl -p spotify status 2>/dev/null)"
if [[ -z "$status" ]]; then
    prompt='Offline'
    mesg="Spotify is Offline"
else
    prompt="$(playerctl -p spotify metadata artist)"
    mesg="$(playerctl -p spotify metadata title) :: $(playerctl -p spotify status)"
fi

if [[ ( "$theme" == *'type-1'* ) || ( "$theme" == *'type-3'* ) || ( "$theme" == *'type-5'* ) ]]; then
    list_col='1'
    list_row='6'
elif [[ ( "$theme" == *'type-2'* ) || ( "$theme" == *'type-4'* ) ]]; then
    list_col='6'
    list_row='1'
fi

# Options
layout=$(grep 'USE_ICON' ${theme} | cut -d'=' -f2)
if [[ "$layout" == 'NO' ]]; then
    if [[ ${status} == *"Playing"* ]]; then
        option_1=" Pause"
    else
        option_1=" Play"
    fi
    option_2=" Stop"
    option_3=" Previous"
    option_4=" Next"
    option_5=" Repeat"
    option_6=" Random"
else
    if [[ ${status} == *"Playing"* ]]; then
        option_1=""
    else
        option_1=""
    fi
    option_2=""
    option_3=""
    option_4=""
    option_5=""
    option_6=""
fi

# Toggle Actions
active=''
urgent=''
# Repeat
# Random

# Rofi CMD
rofi_cmd() {
    rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: "";}' \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        ${active} ${urgent} \
        -markup-rows \
        -theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6" | rofi_cmd
}

# Execute Command
run_cmd() {
    if [[ "$1" == '--opt1' ]]; then
        playerctl -p spotify play-pause && notify-send -u low -t 1000 " $(playerctl -p spotify metadata title)"
    elif [[ "$1" == '--opt2' ]]; then
        playerctl -p spotify stop
    elif [[ "$1" == '--opt3' ]]; then
        playerctl -p spotify previous && notify-send -u low -t 1000 " $(playerctl -p spotify metadata title)"
    elif [[ "$1" == '--opt4' ]]; then
        playerctl -p spotify next && notify-send -u low -t 1000 " $(playerctl -p spotify metadata title)"
    elif [[ "$1" == '--opt5' ]]; then
        playerctl -p spotify loop
    elif [[ "$1" == '--opt6' ]]; then
        playerctl -p spotify shuffle
    fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
        run_cmd --opt1
        ;;
    $option_2)
        run_cmd --opt2
        ;;
    $option_3)
        run_cmd --opt3
        ;;
    $option_4)
        run_cmd --opt4
        ;;
    $option_5)
        run_cmd --opt5
        ;;
    $option_6)
        run_cmd --opt6
        ;;
esac
