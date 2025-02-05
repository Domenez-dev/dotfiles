#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Power Menu
#
## Available Styles
#
## style-1   style-2   style-3   style-4   style-5
## style-6   style-7   style-8   style-9   style-10

# Current Theme
dir="$HOME/.config/rofi/powermenu"
theme='style-5'

# CMDs
uptime="`uptime -p | sed -e 's/up //g'`"
host=`hostname`

# Options
shutdown=''
reboot=''
lock=''
suspend=''
logout=''
yes=''
no=''

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p "Uptime: $uptime" \
		-mesg "Uptime: $uptime" \
		-theme ${dir}/${theme}.rasi
}

# Confirmation CMD
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?' \
		-theme ${dir}/${theme}.rasi
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
    selected="$(confirm_exit)"
    if [[ "$selected" == "$yes" ]]; then
        if [[ $1 == '--shutdown' ]]; then
            systemctl poweroff
        elif [[ $1 == '--reboot' ]]; then
            systemctl reboot
        elif [[ $1 == '--suspend' ]]; then
            systemctl suspend
        elif [[ $1 == '--logout' ]]; then
            if [[ "$XDG_SESSION_TYPE" == 'wayland' ]]; then
                if pgrep -x "sway" > /dev/null; then
                    swaymsg exit
                elif pgrep -x "Hyprland" > /dev/null; then
                    hyprctl dispatch exit
                else
                    echo "Unknown Wayland compositor"
                    exit 1
                fi
            elif [[ "$XDG_SESSION_TYPE" == 'x11' ]]; then
                if pgrep -x "i3" > /dev/null; then
                    i3-msg exit
                else
                    echo "Unsupported X11 window manager"
                    exit 1
                fi
            else
                echo "Unknown session type"
                exit 1
            fi
        fi
    else
        exit 0
    fi
}

# Lock screen function
lock_screen() {
    if [[ "$XDG_SESSION_TYPE" == 'wayland' ]]; then
        if command -v swaylock &> /dev/null; then
            swaylock
        else
            echo "swaylock not found"
        fi
    elif [[ "$XDG_SESSION_TYPE" == 'x11' ]]; then
        if command -v i3lock &> /dev/null; then
            i3lock
        else
            echo "i3lock not found"
        fi
    else
        echo "Unknown session type"
    fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
        run_cmd --shutdown
        ;;
    $reboot)
        run_cmd --reboot
        ;;
    $lock)
        lock_screen
        ;;
    $suspend)
        run_cmd --suspend
        ;;
    $logout)
        run_cmd --logout
        ;;
esac
