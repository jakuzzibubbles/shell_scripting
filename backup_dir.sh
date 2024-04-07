#!/bin/bash

# Prompt user for backup directory
read -p "Enter the directory you want to backup: " backup_dir

# Check if the backup directory exists
if [ ! -d "$backup_dir" ]; then
    echo "Error: Directory '$backup_dir' not found."
    exit 1
fi

# Prompt user for backup destination
read -p "Enter the destination directory for backups: " destination

# Create destination directory if it doesn't exist
mkdir -p "$destination"

# Create a timestamp for the backup file
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

# Create a tar archive of the backup directory
tar -czf "$destination/backup_$timestamp.tar.gz" "$backup_dir"

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Backup completed successfully."
else
    echo "Backup failed. Please check logs for details."
fi
