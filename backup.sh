#!/bin/bash

CONFIG_FILE="backup.config"
backup_location="/var/lib/docker/volumes/backup"
MAX_DAYS=30  # Maximale Anzahl der Aufbewahrungstage
COMPRESS_OPTION=""  # Setze auf "y" für gzip-Kompression, leer für keine Kompression. Backup dauert deutlich länger !

is_container_running() {
    local container_name=$1
    docker inspect -f '{{.State.Running}}' "$container_name" 2>/dev/null
}

stop_backup_start() {
    local container_name=$1
    local config_folder=$2
    local backup_file="$backup_location/$(date +"%Y-%m-%d")_$container_name.tar"

    local stopped=false

    if [ "$(is_container_running "$container_name")" == "true" ]; then
        echo "Stopping container $container_name..." && docker stop "$container_name" && stopped=true
    else
        echo "Container $container_name is already stopped."
    fi

    create_backup() {
        if [ "$COMPRESS_OPTION" == "y" ]; then
            # Mit Kompression
            cd /var/lib/docker/volumes && tar -czf "$backup_file" $(ls -d $config_folder)
        else
            # Ohne Kompression
            cd /var/lib/docker/volumes && tar -cf "$backup_file" $(ls -d $config_folder)
        fi
    }
    
    echo "Creating archive for $container_name..."
    create_backup

    if [ "$stopped" = true ]; then
        echo "Starting container $container_name..." && docker start "$container_name"
    fi
    echo "--------moving to next container"
}

cleanup_old_archives() {
    find "$backup_location" -name "*.tar" -type f -mtime +"$MAX_DAYS" -exec rm {} \;
}

# Main script
if [ ! -d "$backup_location" ]; then
    echo Directory does not exist, create it
    mkdir "$backup_location"
fi

echo "Checking containers..."

# Loop through entries in the configuration file
while IFS= read -r line; do
    # Überspringen von Kommentarzeilen
    [[ $line =~ ^\s*# ]] && continue
    container_name=$(echo "$line" | cut -d ':' -f 1)
    config_folder=$(echo "$line" | cut -d ':' -f 2)
    stop_backup_start "$container_name" "$config_folder"
done < "$CONFIG_FILE"

# Clean up old archives
echo "Cleaning up old archives..."
cleanup_old_archives

echo "Script executed successfully."
