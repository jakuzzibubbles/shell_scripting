#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0"
    echo "This script uploads files from a local directory to an S3 bucket."
}

# Prompt user for local directory
read -p "Enter the local directory to back up: " local_dir

# Prompt user for S3 bucket name
read -p "Enter the name of the S3 bucket: " s3_bucket

# Function to upload files to S3 bucket
upload_to_s3() {
    local local_dir="$1"
    local s3_bucket="$2"

    # Check if the specified local directory exists
    if [ ! -d "$local_dir" ]; then
        echo "Error: Directory '$local_dir' not found."
        exit 1
    fi

    # Upload files to S3 bucket
    aws s3 sync "$local_dir" "s3://$s3_bucket/"
    if [ $? -eq 0 ]; then
        echo "Upload completed successfully."
    else
        echo "Upload failed."
    fi
}

# Main script
# Check if AWS CLI is installed
if ! command -v aws &>/dev/null; then
    echo "Error: AWS CLI is not installed. Please install it and configure your credentials."
    exit 1
fi

# Upload files to S3 bucket
upload_to_s3 "$local_dir" "$s3_bucket"
