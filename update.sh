#!/bin/bash

#Aktualisierung Downloaden
if [ ! -f "temp/installed" ]; then
 apk update
 apk add git
fi

rm -r temp

git clone https://github.com/Joey291/linux-scripts.git
echo "Beende das zu aktualisierende Skript..."

pkill -f "$(basename "$(pwd)/helper.sh")"
echo "Führe das Update-Skript aus..."

rm -f helper.sh
mv linux-scripts/helper.sh .
rm -f update.sh
mv linux-scripts/update.sh .
chmod +x helper.sh
chmod +x update.sh
rm -r linux-scripts
