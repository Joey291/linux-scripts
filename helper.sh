#!/bin/bash
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
    echo "51. Docker Container Stats"
    echo "52. Docker Connect To Container Shell"
    echo "53. Docker Verzeichnis"
    echo "54. Portainer Update"
    echo " "
    echo "-Sonstiges-"
    echo "80. Alle Abhänigkeiten für dieses Script installieren"
    echo "81. Hardware Info (dmidecode)"
    echo "82. CPU Info"
    echo "83. CPU Aktueller Takt"
    echo "85. Network Interfaces"
    echo "86. Listening Ports"
    echo "87. sysctl.conf (Disable IPV6)"
    echo " "
    echo "-System-"
    echo "90. Neustart"
    echo "91. Shutdown"
    echo " "
    echo "99. Exit Programm"
    echo " "
    echo " "

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
         # Füge hier den Befehl für 'reboot' ein
         htop
         ;;
      3)
         echo "Führe 'htop' aus..."
         # Füge hier den Befehl für 'reboot' ein
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
     20)
         clear
         service samba restart
         ;;
     21)
         clear
         git clone https://github.com/CISOfy/lynis
         cd lynis && ./lynis audit system
         cd .. && rm -r lynis
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
         echo "Downloading Y-Cruncher"
         mkdir y-cruncher
         cd y-cruncher
         wget http://www.numberworld.org/y-cruncher/y-cruncher%20v0.8.2.9524-static.tar.xz
         echo "Installing Y-Cruncher"
         tar -xf y-cruncher%20v0.8.2.9524-static.tar.xz
         cd y-cruncher\ v0.8.2.9524-static
         chmod a+x y-cruncher
         clear
         ./y-cruncher
         cd /home
         rm -r y-cruncher
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
         #Portainer Update
         clear
         docker pull portainer/portainer-ce
         docker stop portainer
         docker rm portainer
         docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock -v /etc/localtime:/etc/localtime:ro -v portainer_data:/data portainer/portainer-ce
         ;;
     80) # Alle Abhänigkeiten installieren
         clear
         apk add lm-sensors lm-sensors-detect bash htop git nano dmidecode util-linux hdparm btop
         echo " "
         echo "Drücke beliebige Taste um fortzufahren..."
         read -n 1 -s
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
     85)
         clear
         /sbin/ifconfig -a
         echo " "
         echo "Drücke beliebige Taste um fortzufahren..."
         read -n 1 -s
         ;;
     87)
         clear
         echo " "
         echo "Copy and add the following lines to Disable IPV6"
         echo "net.ipv6.conf.all.disable_ipv6=1"
         echo "net.ipv6.conf.default.disable_ipv6=1"
         echo "net.ipv6.conf.lo.disable_ipv6=1"
         echo " "
         echo "Dücke beliebige Taste um fortzufahren..."
         read -n 1 -s
         nano /etc/sysctl.conf
         ;;
     86)
         clear
         netstat -l
         echo " "
         echo "Drücke beliebige Taste um fortzufahren..."
         read -n 1 -s
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
