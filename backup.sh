#!/bin/bash

CONFIG_FILE="backup.config"
backup_location="/var/lib/docker/volumes/backup"
MAX_DAYS=60  # Maximum number of days to keep archives

# Function to check if a container is running
is_container_running() {
    local container_name=$1
    docker inspect -f '{{.State.Running}}' "$container_name" 2>/dev/null
}

# Function to stop, backup, and start a container
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

    echo "Creating archive for $container_name..." && tar -cf "$backup_file" $config_folder

    if [ "$stopped" = true ]; then
        echo "Starting container $container_name..." && docker start "$container_name"
    fi
    echo "--------moving to next container"
}

# Function to clean up old archives
cleanup_old_archives() {
    find "$backup_location" -name "*.tar" -type f -mtime +"$MAX_DAYS" -exec rm {} \;
}

# Main script
# Check if the backup location exists
if [ ! -d "$backup_location" ]; then
    echo Directory does not exist, create it
    mkdir "$backup_location"
fi

echo "Checking containers..."

# Loop through entries in the configuration file
while IFS= read -r line; do
    container_name=$(echo "$line" | cut -d ':' -f 1)
    config_folder=$(echo "$line" | cut -d ':' -f 2)
    stop_backup_start "$container_name" "$config_folder"
done < "$CONFIG_FILE"

# Clean up old archives
echo "Cleaning up old archives..."
cleanup_old_archives

echo "Script executed successfully."