#!/usr/bin/env bash
# This script updates all packages on Debian/Ubuntu using apt-get.

set -e  # Exit on error

LOG_FILE="/var/log/auto-update.log"

log(){
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a "$LOG_FILE"
}

log "Starting apt package update..."
notify-send "APT Update" "Starting update of apt packages..."

# Refresh package lists
if sudo apt-get update -y; then
    log "apt-get update completed successfully."
else
    log "Failed to run apt-get update."
    notify-send "APT Update Failed" "Failed to update package lists."
    exit 1
fi

# Upgrade packages
if sudo apt-get upgrade -y; then
    log "apt-get upgrade completed successfully."
else
    log "Failed to run apt-get upgrade."
    notify-send "APT Upgrade Failed" "Failed to upgrade packages."
    exit 1
fi

log "Update completed successfully."
notify-send "APT Update" "All apt packages have been updated."
