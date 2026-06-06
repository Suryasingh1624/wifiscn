#!/bin/bash

# Set interface (e.g., wlan0)
INTERFACE="wlan0"

# Check if root
if [ "$EUID" -ne 0 ]; then
 echo "Please run as root."
 exit 1
fi

# Kill any existing scans to ensure fresh results
killall -9 wpa_supplicant &> /dev/null

echo "Scanning WiFi networks on $INTERFACE..."
iwlist $INTERFACE scanning | grep -E 'ESSID|Channel|Encryption key' | sed 's/.*: //g'

echo "Detailed scan (takes longer):"
for NET in $(iwlist $INTERFACE scanning | grep ESSID | cut -d':' -f2-); do
 SIGNAL=$(iwconfig $INTERFACE | grep Quality= | cut -d'=' -f2-)
 CHANNEL=$(iwlist $INTERFACE channel | grep Current)
 ENCRYPTION=$(iwlist $INTERFACE encryption | grep Encryption)

 echo "$NET"
 echo "  Channel: ${CHANNEL##*:}"
 echo "  Encryption: ${ENCRYPTION##*:}"
 echo "  Signal Quality: $SIGNAL"
done
