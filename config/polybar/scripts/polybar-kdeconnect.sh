#!/usr/bin/env bash

# Color Settings of Icon shown in Polybar
COLOR_DISCONNECTED='#000'       # Device Disconnected
COLOR_NEWDEVICE='#ff0'          # New Device
COLOR_BATTERY_90='#6c71c4'      # Battery >= 90
COLOR_BATTERY_70='#268bd2'      # Battery >= 70
COLOR_BATTERY_50='#859900'      # Battery >= 50
COLOR_BATTERY_30='#b58900'      # Battery >= 30
COLOR_BATTERY_10='#cb4b16'      # Battery >= 10
COLOR_BATTERY_LOW='#dc322f'     # Battery <  10
COLOR_FOREGROUND='#eee8d5'

# Icons shown in Polybar
icon=''
SEPERATOR='|'

DEV_ID=$(kdeconnect-cli -a --id-only)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

show_devices (){
    IFS=$','
    devices=""
    for deviceid in $(kdeconnect-cli -a --id-only); do
        devicename=$(kdeconnect-cli -a --name-only)
        devicetype=$(qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$deviceid" org.kde.kdeconnect.device.type)
        isreach="$(qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$deviceid" org.kde.kdeconnect.device.isReachable)"
        istrust="$(qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$deviceid" org.kde.kdeconnect.device.isTrusted)"
        if [ "$isreach" = "true" ] && [ "$istrust" = "true" ]
        then
            battery="$(qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$deviceid/battery" org.kde.kdeconnect.device.battery.charge)"
            icon=$(get_icon "$battery" "$devicetype")
            devices+="%{A1:$DIR/polybar-kdeconnect.sh -n '$devicename' -i $deviceid -b $battery -m:}$icon%{A}$SEPERATOR"
        elif [ "$isreach" = "false" ] && [ "$istrust" = "true" ]
        then
            devices+="$(get_icon -1 "$devicetype")$SEPERATOR"
        else
            haspairing="$(qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$deviceid" org.kde.kdeconnect.device.hasPairingRequests)"
            if [ "$haspairing" = "true" ]
            then
                show_pmenu2 "$devicename" "$deviceid"
            fi
            icon=$(get_icon -2 "$devicetype")
            devices+="%{A1:$DIR/polybar-kdeconnect.sh -n $devicename -i $deviceid -p:}$icon%{A}$SEPERATOR"

        fi
    done
    echo "${devices::-1}"
}

show_menu () {
    menu="$(rofi -sep "|" -dmenu -config /home/artic/.config/rofi.artic/kdeconnect.rasi -p "$DEV_NAME" -hide-scrollbar -lines 5 <<< "Battery: $DEV_BATTERY%|Ping|Find Device|Send File|Browse Files|Unpair")"
                case "$menu" in
                    *Ping) qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID/ping" org.kde.kdeconnect.device.ping.sendPing ;;
                    *'Find Device') qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID/findmyphone" org.kde.kdeconnect.device.findmyphone.ring ;;
                    *'Send File') qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID/share" org.kde.kdeconnect.device.share.shareUrl "file://$(zenity --file-selection)" ;;
                    *'Browse Files')
                        if "$(qdbus --literal org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID/sftp" org.kde.kdeconnect.device.sftp.isMounted)" == "false"; then
                            qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID/sftp" org.kde.kdeconnect.device.sftp.mount
                        fi
                        qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID/sftp" org.kde.kdeconnect.device.sftp.startBrowsing
                        ;;
                    *'Unpair' ) qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID" org.kde.kdeconnect.device.unpair
                esac
}

show_pmenu () {
    menu="$(rofi -sep "|" -dmenu -config /home/artic/.config/rofi.artic/kdeconnect.rasi -p "$DEV_NAME" -hide-scrollbar -lines 109<<<"Pair Device")"
                case "$menu" in
                    *'Pair Device') qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID" org.kde.kdeconnect.device.requestPair
                esac
}

show_pmenu2 () {
    menu="$(rofi -sep "|" -dmenu -config /home/artic/.config/rofi.artic/kdeconnect.rasi -p "$DEV_NAME" -hide-scrollbar -lines 2 <<< "Accept|Reject")"
                case "$menu" in
                    *'Accept') qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$2" org.kde.kdeconnect.device.acceptPairing ;;
                    *) qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$2" org.kde.kdeconnect.device.rejectPairing
                esac

}
get_icon () {
    case $battery in
    "-1")     ICON="%{F$COLOR_DISCONNECTED}$icon%{F-}" ;;
    "-2")     ICON="%{F$COLOR_NEWDEVICE}$icon%{F-}" ;;
    1*|2*)     ICON="%{T8}%{F$COLOR_FOREGROUND}$icon%{F-} %{F$COLOR_BATTERY_10}$battery%%{F-}%{T-}" ;;
    3*|4*)     ICON="%{T8}%{F$COLOR_FOREGROUND}$icon%{F-} %{F$COLOR_BATTERY_30}$battery%%{F-}%{T-}" ;;
    5*|6*)     ICON="%{T8}%{F$COLOR_FOREGROUND}$icon%{F-} %{F$COLOR_BATTERY_50}$battery%%{F-}%{T-}" ;;
    7*|8*)     ICON="%{T8}%{F$COLOR_FOREGROUND}$icon%{F-} %{F$COLOR_BATTERY_70}$battery%%{F-}%{T-}" ;;
    9*|100) ICON="%{T8}%{F$COLOR_FOREGROUND}$icon%{F-} %{F$COLOR_BATTERY_90}$battery%%{F-}%{T-}" ;;
    *)      ICON="%{T8}%{F$COLOR_FOREGROUND}$icon%{F-} %{F$COLOR_BATTERY_LOW}$battery%%{F-}%{T-}" ;;
    esac
    echo $ICON
}

unset DEV_ID DEV_NAME DEV_BATTERY
while getopts 'di:n:b:mp' c
do
    # shellcheck disable=SC2220
    case $c in
        d) show_devices ;;
        i) DEV_ID=$OPTARG ;;
        n) DEV_NAME=$OPTARG ;;
        b) DEV_BATTERY=$OPTARG ;;
        m) show_menu  ;;
        p) show_pmenu ;;
    esac
done
