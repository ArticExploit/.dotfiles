#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Screenshot

# Import Current Theme
theme="/home/artic/.config/rofi/app.rasi"

# Theme Elements
prompt='Screenshot'
list_col='1'
list_row='5'
win_width='520px'

# Options
layout=`cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2`
if [[ "$layout" == 'NO' ]]; then
	option_1=" Capture Desktop"
	option_2=" Capture GUI"
	option_3=" Capture & Upload"
	option_4=" Capture in 5s"
	option_5=" Clear Server Screenshots"
else
	option_1=""
	option_2=""
	option_3=""
	option_4=""
	option_5=""
fi

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "window {width: $win_width;}" \
		-theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-p "$prompt" \
		-theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

# take shots
shotfull () {
	flameshot full --clipboard
}

shot5 () {
	flameshot gui --delay 5000
}

delss () {
	ssh artic@192.168.5.190 "rm -r /var/www/html/images/*"
}

shotnup () {
    RND=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-8} | head -n 1)
	FILE=""$RND".png"
	URL="https://media.articexploit.xyz:8443/images/${FILE}"
	flameshot gui -r > /home/artic/Pictures/screenshots/$FILE
	scp -i ~/.ssh/artic /home/artic/Pictures/screenshots/$FILE artic@192.168.5.14:/var/www/html/images
	rm -r /home/artic/Pictures/screenshots/$FILE
	echo $URL | xclip -selection clipboard
}

local_shot () {
	flameshot gui
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		shotfull
	elif [[ "$1" == '--opt2' ]]; then
		local_shot
	elif [[ "$1" == '--opt3' ]]; then
		shotnup
	elif [[ "$1" == '--opt4' ]]; then
		shot5
	elif [[ "$1" == '--opt5' ]]; then
		delss
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
esac
