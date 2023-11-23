#!/bin/bash

echo "Beende das zu aktualisierende Skript..."
git clone https://github.com/Joey291/linux-scripts.git

pkill -f "$(basename "/home/helper.sh")"

echo "Führe das Update-Skript aus..."
rm helper.sh
mv linux-scripts/helper.sh /home/
chmod +x helper.sh
rm -r LinuxScripts
