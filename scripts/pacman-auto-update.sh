#!/usr/bin/env bash
# This script updates all official repo packages on Arch using pacman.

set -e  # Exit on error

LOG_FILE="/var/log/auto-update.log"

log(){
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a "$LOG_FILE"
}

log "Starting pacman package update..."
notify-send "Pacman Update" "Starting update of pacman packages..."

# Synchronize and upgrade
if sudo pacman -Syu --noconfirm; then
    log "pacman -Syu completed successfully."
else
    log "Failed to run pacman -Syu."
    notify-send "Pacman Update Failed" "Failed to update packages."
    exit 1
fi

log "Update completed successfully."
notify-send "Pacman Update" "All pacman packages have been updated."
