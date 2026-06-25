#!/bin/sh
cd "$appdir/"
sysdir=/mnt/SDCARD/.tmp_update
miyoodir=/mnt/SDCARD/miyoo
LD_LIBRARY_PATH="$appdir/lib:/lib:/config/lib:$miyoodir/lib:$sysdir/lib:$sysdir/lib/parasyte"
PATH="$sysdir/bin:$PATH"
appdir=/mnt/SDCARD/App/Syncthing
skiplast=0

build_infoPanel() {
    local message="$1"
	local title="Syncthing Setup"
	infoPanel --title "$title" --message "$message" --persistent &
	touch /tmp/dismiss_info_panel
	sync
	sleep 1
}

syncthingpid() {
	pgrep "syncthing" > /dev/null
}

repair_config() {
    local config="$appdir/config/config.xml"

    if grep -q "<listenAddress>dynamic+https://relays.syncthing.net/endpoint</listenAddress>" "$config"; then
        build_infoPanel "Config not generated correctly, \n Manually repairing"
        
        sed -i '/<listenAddress>dynamic+https:\/\/relays.syncthing.net\/endpoint<\/listenAddress>/d' "$config"
        sed -i '/<listenAddress>quic:\/\/0.0.0.0:41383<\/listenAddress>/d' "$config"
        
        sed -i 's|<listenAddress>tcp://0.0.0.0:41383</listenAddress>|<listenAddress>default</listenAddress>|' "$config"
        sed -i 's|<address>127.0.0.1:40379</address>|<address>0.0.0.0:8384</address>|' "$config"
    fi
}

changeguiip() {
	sync
    IP=$(ip route get 1 2>/dev/null | awk '{print $NF;exit}')
    if [ -z "$IP" ]; then
        IP="127.0.0.1" 
    fi
    
    if grep -q "<address>0.0.0.0:8384</address>" "$appdir/config/config.xml"; then
        if [ "$IP" = "127.0.0.1" ]; then
            build_infoPanel "Connect to WiFi to access GUI! \n The app will close automatically."
            sleep 5
        else
            build_infoPanel "GUI IP is $IP:8384 \n The app will close automatically."
            sleep 10
        fi
        skiplast=1
        return
    fi

    build_infoPanel "Changing GUI IP to $IP:8384"
    sed -i "s|<address>127.0.0.1:8384</address>|<address>0.0.0.0:8384</address>|g" "$appdir/config/config.xml"
}

########################## GO TIME

if [ ! -f "$appdir/config/config.xml" ]; then
    build_infoPanel "Initial Setup: Generating Config..."
    "$appdir/bin/syncthing" generate --no-default-folder --home="$appdir/config/" > "$appdir/generate.log" 2>&1 &
    sleep 5
    repair_config
    pkill syncthing
fi

changeguiip

if ! syncthingpid; then
    build_infoPanel "Starting Syncthing manually..."
    "$appdir/bin/syncthing" serve --home="$appdir/config/" > "$appdir/serve.log" 2>&1 &
fi

if [ "$skiplast" -ne 1 ] && [ "$IP" != "127.0.0.1" ]; then
    build_infoPanel "Browse to $IP:8384 on PC to setup! \n The app will close automatically."
    sleep 10
fi