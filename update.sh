#!/bin/bash

#Aktualisierung Downloaden
apk update
apk add git
git clone https://github.com/Joey291/linux-scripts.git
echo "Beende das zu aktualisierende Skript..."

pkill -f "$(basename "$(pwd)/helper.sh")"
echo "Führe das Update-Skript aus..."

rm -f helper.sh
mv linux-scripts/helper.sh .
chmod +x helper.sh
rm -r linux-scripts
