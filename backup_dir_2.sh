#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0"
    echo "This script allows you to perform a backup with customization options."
}

# Prompt user for backup directories
read -p "Enter the directories you want to backup (separated by spaces): " -a backup_dirs

# Prompt user for backup destination
read -p "Enter the destination directory for backups: " destination

# Prompt user for exclusion patterns
read -p "Enter patterns for files/directories to exclude from the backup (separated by spaces, leave blank for none): " -a exclusions

# Prompt user for rotation count
read -p "Enter the number of backup archives to keep (leave blank for default of 5): " rotate
rotate=${rotate:-5}

# Backup function
backup() {
    timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
    backup_name="backup_$timestamp.tar.gz"
    tar_command="tar -czf $destination/$backup_name ${backup_dirs[@]} ${exclusions[@]/#/--exclude=}"
    eval "$tar_command"
    if [ $? -eq 0 ]; then
        echo "Backup completed successfully: $backup_name"
        # Perform rotation
        rotate_backups
    else
        echo "Backup failed: $backup_name"
        # Log the error
        echo "$(date +"%Y-%m-%d %H:%M:%S") Backup failed: $backup_name" >> "$destination/backup.log"
    fi
}

# Rotate backups
rotate_backups() {
    backups=("$destination"/*.tar.gz)
    num_backups=${#backups[@]}
    if [ "$num_backups" -gt "$rotate" ]; then
        num_to_delete=$((num_backups - rotate))
        # Sort backups by modification time (oldest first) and delete excess
        mapfile -t sorted_backups < <(printf '%s\n' "${backups[@]}" | xargs stat --format='%Y %n' | sort -n | awk '{print $2}')
        backups_to_delete=("${sorted_backups[@]:0:num_to_delete}")
        rm "${backups_to_delete[@]}"
        echo "Rotated backups: ${backups_to_delete[@]}"
    fi
}

# Main script
# Check if at least one directory is specified
if [ ${#backup_dirs[@]} -eq 0 ]; then
    echo "Error: At least one directory must be specified."
    usage
    exit 1
fi

# Create destination directory if it doesn't exist
mkdir -p "$destination"

# Perform the backup
backup
