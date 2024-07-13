#!/bin/bash
if [ ! -f "temp/installed" ]; then
 echo " "
 echo "Installing Dependencies..."
 echo " "
 apk update && apk add lm-sensors lm-sensors-detect bash htop git nano dmidecode util-linux hdparm btop smartmontools iotop ctop neofetch
 mkdir temp
 touch temp/installed
fi

while true; do
    # Get the Kernel version and Hostname
    kernel_version=$(uname -r)
    hostname=$(uname -n)
    uptime=$(uptime)
    current_time=$(date +"%Y-%m-%d %H:%M:%S")

    # Display the main menu with Kernel version and Hostname
    clear
    echo "SmartHome Server"
    echo " "
    echo "Kernel-Version: $kernel_version" "Hostname: $hostname"
    echo "Uptime: $uptime"
    echo "Aktuelle Uhrzeit: $current_time"
    echo "----------------------Main Menu----------------------"
    echo " "
    echo "-Operating System-"
    echo "1. System aktualisieren"
    echo "2. Htop"
    echo "3. Btop"
    echo "4. Build nummer"
    echo "5. Repositories"
    echo "6. Password ändern"
    echo "7. System Logs"
    echo "8. Disk Space"
    echo "9. Find File"
    echo "10. Installierte Pakete"
    echo "11. Temperatur"
    echo "12. Maintenance"
    echo "13. SMART Tool"
    echo "14. IOtop"
    echo "15. Edit Motd"
    echo "16. Change Hostname"
    echo " "
    echo "-Services-"
    echo "20. Samba Neustart"
    echo "21. Security Scan"
    echo "22. CPU Turbo Boost Off"
    echo "23. CPU Turbo Boost On"
    echo "24. Governor Ondemand"
    echo "25. Governor Perfomance"
    echo "26. Governor schedutil (Standard)"
    echo "27. Aktiver Gouvernor Info"
    echo "28. CPU Stress Test"
    echo "29. Disk Write Speed Test"
    echo "30. Y-Cruncher"
    echo " "
    echo "-Docker-"
    echo "50. Docker Install Helper"
    echo "51. Docker Container Stats"
    echo "52. Docker Connect To Container Shell"
    echo "53. Docker Verzeichnis"
    echo "54. ctop"
    echo " "
    echo "-Sonstiges-"
    echo "81. Hardware Info (dmidecode)"
    echo "82. CPU Info"
    echo "83. CPU Aktueller Takt"
    echo "84. Neofetch (Sys info)"
    echo "85. Network Interfaces"
    echo "86. Listening Ports"
    echo "87. sysctl.conf (Disable IPV6)"
    echo "88. sysctl.conf (SWAP Settings)"
    echo "89. Crontab"
    echo " "
    echo "-System-"
    echo "90. Neustart"
    echo "91. Shutdown"
    echo "92. Clear Programm Temp Folder"
    echo " "
    echo "99. Exit Programm"
    echo " "
    echo " "
    # Funktion zur Vergleich der Kernel-Versionen
    kernel_version_compare() {
        installed_version=$(ls -1 /lib/modules | tail -n1)
        loaded_version=$(uname -a | cut -d' ' -f3)
        if [[ "$installed_version" != "$loaded_version" ]]; then
            echo "(System Neustart erforderlich)"
            echo "(Neue Kernelversion installiert, aber nicht geladen)"
        fi
    }

    # Aufruf der Vergleichsfunktion
    kernel_version_compare
    echo "Triff deine Wahl:"  && read option
     case $option in
      1)
         clear
         echo "Führe 'apk update' aus..."
         apk update
            apk -u list
            # apk -s upgrade   # andere anzeige art -s simulation
            echo "Möchten Sie fortfahren? (y/n)"
            read proceed
            if [ "$proceed" != "y" ]; then
                echo "Abgebrochen."
            else
                apk upgrade
                echo " "
                echo "Drücke beliebige Taste um fortzufahren..."
                read -n 1 -s
            fi
         ;;
      2)
         echo "Führe 'htop' aus..."
         htop
         ;;
      3)
         echo "Führe 'htop' aus..."
         btop
         ;;
      4)
         clear
         echo " "
         echo " "
         uname -a
         echo " "
         echo "Kernel Version"
         uname -r
         echo " "
         echo " "
         echo " "
         echo "Drücke beliebige Taste um fortzufahren..."
         read -n 1 -s
         ;;
      5)
         nano /etc/apk/repositories
         ;;
      6)
         clear
         passwd
         ;;
      7) 
         clear
         dmesg
         exit 0
         ;;
      8)
         clear
         echo " "
         echo " "
         echo "Freier Speicherplatz"
         echo " "
         echo " "
         echo " "
         df -h
         echo " "
         echo " "
         echo "Drücke beliebige Taste um fortzufahren..."
         read -n 1 -s
         ;;
      9)
         clear
         echo " "
         echo " "
         echo "Dateiname für Suche Definieren.   (z.b.: *.pdf)"
         echo " "
         echo " "
         read file_name
         clear
         echo " "
         echo "Suche nach $file_name"
         echo " "
         find / -name "$file_name"
         echo " "
         echo "Drücke beliebige Taste um fortzufahren..."
         read -n 1 -s
         ;;
     10)
         clear
         apk info
         echo "Drücke beliebige Taste um fortzufahren..."
         read -n 1 -s
         ;;
     11)
         echo "Temperatur Sensoren werden abgerufen"
         watch -n 1 sensors
         ;;
     12) #maintenance
         clear
         echo "TRIM SSD"
         fstrim / -v
         echo "Empty ram buffers and cache"
         echo " "
         echo " "
         echo "Before Clear"
         free 
         sync 
         echo 3 > /proc/sys/vm/drop_caches
         echo " "
         echo " "
         echo "After clear"
         free
         echo "Empty SWAP"
         swapoff -a
         sleep 8
         swapon -a
         sleep 3
         ;;
     13)
         clear
         echo "from which device do you want to read smart values?"
         echo " "
         lsblk -d
         read smart
         clear
         smartctl -a -d ata /dev/$smart
         read -n 1 -s
         ;;
      14)
         echo "Führe 'iotop' aus..."
         iotop -o
         ;;
     15)
         nano /etc/motd
         ;;
     16)
         nano /etc/hostname
         ;;
     20)
         clear
         service samba restart
         ;;
     21)
         clear
         mkdir temp
         cd temp
         git clone https://github.com/CISOfy/lynis
         cd lynis && ./lynis audit system
         exit 0
         ;;
     22) #Turbo Off
         clear
         /usr/bin/flock -x -w 1 /sys/devices/system/cpu/intel_pstate/no_turbo -c 'echo "1" > /sys/devices/system/cpu/intel_pstate/no_turbo' &>/dev/null
         echo "CPU Turbo Boost Deaktiviert!, nach neustart wieder Standard!"
         echo "Drücke beliebige Taste um fortzufahren..."
         read -n 1 -s
         ;;
     23) #Turbo On
         clear
         /usr/bin/flock -x -w 1 /sys/devices/system/cpu/intel_pstate/no_turbo -c 'echo "0" > /sys/devices/system/cpu/intel_pstate/no_turbo' &>/dev/null
         echo "CPU Turbo Boost Aktiv!, nach neustart wieder Standard!"
         echo "Drücke beliebige Taste um fortzufahren..."
         read -n 1 -s
         ;;
     24) # Governor Ondemand
         clear
         # Set the governor to ondemand for all processors
         for cpu in /sys/devices/system/cpu/cpufreq/policy*; do
         echo ondemand > ${cpu}/scaling_governor              
         done
         # Reduce the boost threshold to 80%  Default 95%
         echo 80 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
         echo "Governors Ondemand Aktiv, nach neustart wieder Standard!"
         echo "Drücke beliebige Taste um fortzufahren..."
         read -n 1 -s
         ;;
     25) # Governor Performance
         clear
         for cpu in /sys/devices/system/cpu/cpufreq/policy*; do
         echo performance > ${cpu}/scaling_governor              
         done
         echo "Governors Performance Aktiv, nach neustart wieder Standard!"
         echo "Drücke beliebige Taste um fortzufahren..."
         read -n 1 -s
         ;;
     26) # Governor schedutil
         clear
         # Set the governor to ondemand for all processors
         for cpu in /sys/devices/system/cpu/cpufreq/policy*; do
         echo schedutil > ${cpu}/scaling_governor              
         done
         echo "Governors schedutil Aktiv"          
         echo "Drücke beliebige Taste um fortzufahren..."
         read -n 1 -s
         ;;
     27)
         clear
         active_governor=$(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_governor)
         echo "Aktiver Governor:"
         cat /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
         echo " "
         echo "Verfügbare Governors:"
         cat /sys/devices/system/cpu/cpufreq/policy0/scaling_available_governors
         echo " "
         if [ "$active_governor" = "ondemand" ]; then
           echo "Up Threshold:"
           cat /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
           echo " "
         fi
         echo "Scaling Driver:"
         cat /sys/devices/system/cpu/cpufreq/policy0/scaling_driver
         echo " "

         echo "Turbo  1=Off 0= ON"
         cat /sys/devices/system/cpu/intel_pstate/no_turbo
         echo " "
         echo "Drücke beliebige Taste um fortzufahren..."
         read -n 1 -s
         ;;
     28) #stress test
         clear
         echo " "
         echo " "
         echo " "
         echo "Cpu Anzahl für den Stresstest angeben"
         echo " "
         echo " "
         read cpuzahl
         clear
         echo " "
         echo " "
         echo " "
         echo "Laufzeit des Stresstest eingeben (in sekunden)"
         echo " "
         echo " "
         read dauer
         clear 
         docker run -it --rm progrium/stress --cpu $cpuzahl --io 1 --vm 2 --vm-bytes 256M --timeout $dauer
         echo " "
         echo " "
         echo " "
         echo "Drücke beliebige Taste um fortzufahren..."
         read -n 1 -s
         ;;
     29) #Disk Speed Test
         clear
         echo " "
         lsblk
         echo " "
         echo " "
         echo "Welche Platte? (default: sda)"
         echo " "
         read Disk
         clear
         echo " "
         echo " "
         echo " "
         hdparm -Tt /dev/$Disk
         echo " "
         echo " "
         echo "Drücke beliebige Taste um fortzufahren..."
         read -n 1 -s
         ;;
     30) #y-cruncher
         clear
         ycruncher=v0.8.3.9532-static
         mkdir temp
         cd temp
         if [ ! -d "y-cruncher" ]; then
          mkdir y-cruncher
          cd y-cruncher

          echo "Downloading Y-Cruncher"
          wget http://www.numberworld.org/y-cruncher/y-cruncher%20"$ycruncher".tar.xz

          echo "Installing Y-Cruncher"
          tar -xf y-cruncher%20"$ycruncher".tar.xz

         else
          # If the folder already exists, print a message
          echo "Y-Cruncher is already installed. Skipping download and installation."
          cd y-cruncher
         fi
  
          cd "y-cruncher $ycruncher"

          chmod a+x y-cruncher
          clear
          ./y-cruncher
         exit 0
         ;;
     50)
           while true; do
              clear
              echo "1. Homeassistant"
              echo "2. Node-Red"
              echo "3. MQTT"
              echo "4. Portainer Update"
              echo "5. Portainer Update Cgroup"
              echo "99. Zurück zum Hauptmenu"
              echo "Triff deine Wahl:"  && read option
               case $option in
               1)
                docker volume create homeassistant
                docker volume create homeassistant-media
                docker run -d --name homeassistant --restart=unless-stopped --net host --privileged -v /etc/localtime:/etc/localtime:ro -v homeassistant:/config -v homeassistant-media:/media -v /var/run/docker.sock:/var/run/docker.sock homeassistant/home-assistant:stable
                echo "Beliebige Taste um zum Menue zurück zu kehren"
                read -n 1 -s
                ;;
               2)
                docker volume create node-red
                docker run -d -p 1880:1880 --restart=unless-stopped -e TZ=Europe/Berlin -v /etc/localtime:/etc/localtime:ro -v node-red:/data --name nodered nodered/node-red
                echo "Beliebige Taste um zum Menue zurück zu kehren"
                read -n 1 -s
                ;;
               3)
                mkdir /var/lib/docker/volumes/mqtt
                mkdir /var/lib/docker/volumes/mqtt/data
                mkdir /var/lib/docker/volumes/mqtt/log
                docker run -d -p 1883:1883 -p 9001:9001 --restart=unless-stopped -v /var/lib/docker/volumes/mqtt/data:/mosquitto/data -v /var/lib/docker/volumes/mqtt/log:/mosquitto/log -v /var/lib/docker/volumes/mqtt/mosquitto.conf:/mosquitto/config/mosquitto.conf --name MQTT eclipse-mosquitto
                echo "Beliebige Taste um zum Menue zurück zu kehren"
                read -n 1 -s
                ;;
               4)
                #Portainer Update
                clear
                docker pull portainer/portainer-ce
                docker stop portainer
                docker rm portainer
                docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock -v /etc/localtime:/etc/localtime:ro -v portainer_data:/data portainer/portainer-ce
                ;;
               5)
                #Portainer Update
                clear
                docker pull portainer/portainer-ce
                docker stop portainer
                docker rm portainer
                docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --cgroupns host --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock -v /etc/localtime:/etc/localtime:ro -v portainer_data:/data portainer/portainer-ce
                ;;
               99)
                break
                ;;
              *)
                clear
                echo "Ungültige Option ausgewählt."
                echo " "
                echo "Drücke beliebige Taste um fortzufahren..."
                read -n 1 -s
                ;;
               esac
         done
         ;;
     51)
         while true; do
             clear
             echo " "
             echo " "
             echo " "
             echo "Docker Stats werden angezeigt. Drücken Sie 'Ctrl + C', um zu beenden."
             echo " "
             echo " "
             echo " "
             echo " "
             echo " "
             # Execute the 'docker stats' command in a loop
             docker stats --no-stream
             # Adjust the sleep interval (in seconds) to control the refresh rate
             echo " "
             echo "Beliebige Taste zum Aktualisieren"
             read -n 1 -s
         done
         ;;
     52)
         clear
         echo "Zu welchem Container verbinden?"
         read container_name

         # Check if the container exists and is running
         if docker inspect -f '{{.State.Running}}' "$container_name" 2>/dev/null; then
             while true; do
                # Execute the container's shell (bash) and replace the current shell process
                docker exec -it "$container_name" /bin/bash

                echo "Shell im Container beendet. Möchten Sie den Container-Shell erneut öffnen? (y/n)"
                read reopen

                if [ "$reopen" != "y" ]; then
                    break  # Break out of the while loop if user chooses not to reopen the shell
                fi
             done
         else
             echo "Container '$container_name' existiert nicht oder ist nicht gestartet."
             echo " "
             echo "Drücke beliebige Taste um fortzufahren..."
             read -n 1 -s
         fi
         ;;
     53)
         clear
         echo "Wechsel das Verzeichnis"
         echo "cd /var/lib/docker/volumes/"
         exit 0
         ;;
      54)
         echo "Führe 'ctop' aus..."
         ctop
         ;;
     81)
         clear
         #dmidecode | less
         dmidecode -t x
         echo " "
         echo "Triff eine Auswahl"
         echo " "
         read info_name
         clear
         dmidecode -t $info_name
         echo " "
         echo "Drücke beliebige Taste um fortzufahren..."
         read -n 1 -s
         ;;
     82)
         clear
         lscpu
         echo " "
         echo "Drücke beliebige Taste um fortzufahren..."
         read -n 1 -s
         ;;
     83)
         while true; do
             clear
             echo " "
             echo " "
             echo " "
             echo "CPU Taktrate wird angezeigt. Drücken Sie 'Ctrl + C', um zu beenden."
             echo " "
             echo " "
             echo " "
             echo " "
             echo " "
             cat /proc/cpuinfo | grep "MHz"
             sleep 3
         done
         ;;
     84)
       neofetch
       echo " "
       echo " "
       echo " "
       echo "Drücke beliebige Taste um fortzufahren..."
       read -n 1 -s     
     85)
         clear
         /sbin/ifconfig -a
         echo " "
         echo "Drücke beliebige Taste um fortzufahren..."
         read -n 1 -s
         ;;
     86)
         clear
         netstat -l
         echo " "
         echo "Drücke beliebige Taste um fortzufahren..."
         read -n 1 -s
         ;;
     87)
         clear
         # Check if the lines exist in sysctl.conf
         if grep -q '^net.ipv6.conf.all.disable_ipv6=1' /etc/sysctl.conf &&
            grep -q '^net.ipv6.conf.default.disable_ipv6=1' /etc/sysctl.conf &&
            grep -q '^net.ipv6.conf.lo.disable_ipv6=1' /etc/sysctl.conf; then
            # Lines exist, already deactivated
            echo "IPv6 is already deactivated"
         else
            # Lines don't exist, add them
            echo "net.ipv6.conf.all.disable_ipv6=1" | tee -a /etc/sysctl.conf
            echo "net.ipv6.conf.default.disable_ipv6=1" | tee -a /etc/sysctl.conf
            echo "net.ipv6.conf.lo.disable_ipv6=1" | tee -a /etc/sysctl.conf
            echo "IPv6 has been deactivated"
         fi
         # Apply changes
         echo " "
         echo "Press any key to Continue"
         read -n 1 -s
         sysctl -p
         ;;
     88) #SWAP
         clear
         echo "Current Swap Setting:"
         cat /proc/sys/vm/swappiness
         echo " "
         echo " "
         echo "auf welchen wert willst du den SWAP ändern? (in %)"
         read SWAPPINESS_VALUE
         # Check if the line exists in sysctl.conf
         if grep -q '^vm.swappiness=' /etc/sysctl.conf; then
           # Line exists, replace the value
           sed -i "s/^vm.swappiness=.*/vm.swappiness=$SWAPPINESS_VALUE/" /etc/sysctl.conf
           echo "vm.swappiness updated to $SWAPPINESS_VALUE"
         else
           # Line doesn't exist, add it
           echo "vm.swappiness=$SWAPPINESS_VALUE" | tee -a /etc/sysctl.conf
           echo "vm.swappiness set to $SWAPPINESS_VALUE"
         fi 
         sysctl -p
         echo " "
         echo " Erfolgreich geändert! "
         echo " "
         echo " kehre zum hauptmenue zurück ... "
         sleep 3
         ;;
     89)
        EDITOR=nano crontab -e 
        ;;
     90)
         clear
         echo "Möchten Sie Wirklich Neustarten? Server 1-2 Minuten unerreichbar (y/n)"
             read proceed
             if [ "$proceed" != "y" ]; then
                echo "Abgebrochen."
             exit 1
         fi
         echo "Führe einen Neustart durch. "
         reboot
         exit 0
         ;;
     91)
         clear
         echo "Möchten Sie Wirklich Herunterfahren? Server startet NICHT neu ! (y/n)"
         read proceed
         if [ "$proceed" != "y" ]; then
             echo "Abgebrochen."
             exit 1
         fi
         poweroff
         exit 0
         ;;
     92) #clear tmp
         clear
         rm -r temp
         ;;
     99)
         echo "Beenden."
         clear
         exit 0
         ;;
      *) 
         clear
         echo "Ungültige Option ausgewählt."
         echo " "
         echo "Drücke beliebige Taste um fortzufahren..."
         read -n 1 -s
         ;;
    esac
done
