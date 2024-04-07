#!/bin/bash

encrypt() {
    # Prompt user for the file to encrypt
    read -p "Enter the path to the file you want to encrypt: " file_path

    # Prompt user for recipient's public key
    read -p "Enter the recipient's GPG key ID or email address: " recipient

    # Encrypt the file using recipient's public key
    gpg --encrypt --recipient "$recipient" "$file_path"
    if [ $? -eq 0 ]; then
        echo "Encryption completed successfully."
    else
        echo "Encryption failed."
    fi
}

decrypt() {
    # Prompt user for the file to decrypt
    read -p "Enter the path to the file you want to decrypt: " file_path

    # Decrypt the file
    gpg --decrypt "$file_path"
    if [ $? -eq 0 ]; then
        echo "Decryption completed successfully."
    else
        echo "Decryption failed."
    fi
}

# Main script
echo "1. Encrypt a file"
echo "2. Decrypt a file"
read -p "Choose an option (1 or 2): " option

case $option in
    1) encrypt ;;
    2) decrypt ;;
    *) echo "Invalid option." ;;
esac
