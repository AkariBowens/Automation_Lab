#!/bin/bash
# Script to automate user creation

# Checks for or creates logs directory
mkdir -p logs
# Checks for or creates a log
LOG_FILE = "logs/user_creation_log.log"

# Checks for an input file
if [ -z "$1"]; then 
  echo "Usage: $0 users.txt"
  exit 1
fi

echo "Starting user creation: $(date)" >> "$log_file"

# Reads each line in file, separates last name and first name in each line by ","
while IFS=, read -r last first; do

# Removes trailing and leading space
  first=$(echo "$first" | xargs)
  last=$(echo "$last" | xargs)

# Create a lowercase username with the first initial + last name
  username=$(echo "${first:0:1}${last}" | tr '[:upper:]' '[:lower:]')

# Checks if the username already exists
  if id "$username" &>/dev/null; then 
    echo "User $username already exists. Skipping" >> "$log_file"
  else 
    #Creates user and home directory
    sudo useradd -m "$username"
    echo "User $username created."

    # Set default password
    echo "$username:password123" | sudo chpasswd
    echo "Set default password for $username." >> "$log_file"
  fi
done < "$1"

echo "User creation finished: $(date)" >> "$log_file"
