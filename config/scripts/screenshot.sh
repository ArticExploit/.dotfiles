#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Screenshot

# Import Current Theme
theme="/home/artic/.config/rofi/app.rasi"

# Theme Elements
list_col='1'
list_row='5'
win_width='520px'

option_1="Capture GUI"
option_2="Capture & Upload"
option_3="Capture in 5s"
option_4="Capture Desktop"
option_5="Clear Server Screenshots"

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "window {width: $win_width;}" \
		-theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-dmenu \
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
	ssh artic@10.3.44.10 "rm -r /home/artic/docker-compose/q-apache/html/img/*.png"
}

shotnup () {
    RND=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-8} | head -n 1)
	FILE=""$RND".png"
	URL="https://articexploit.xyz:8443/img/${FILE}"
	flameshot gui -r > /home/artic/Pictures/screenshots/$FILE
	scp -i ~/.ssh/artic /home/artic/Pictures/screenshots/$FILE artic@10.3.44.10:/home/artic/docker-compose/q-apache/html/img
	rm -r /home/artic/Pictures/screenshots/$FILE
	echo $URL | xclip -selection clipboard
}

local_shot () {
	flameshot gui
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		local_shot
	elif [[ "$1" == '--opt2' ]]; then
		shotnup
	elif [[ "$1" == '--opt3' ]]; then
		shot5
	elif [[ "$1" == '--opt4' ]]; then
		shotfull
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
