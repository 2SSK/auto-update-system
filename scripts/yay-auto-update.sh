#!/usr/bin/env bash
# This script updates all AUR packages using yay and then runs a system update.

set -e # Exit on error (if any command fails)

LOG_FILE="/var/log/auto-update.log"

log(){
    echo -e "$(date +'%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a "$LOG_FILE"
}

log "Starting AUR package update..."
notify-send "AUR Update" "Starting update of AUR packages..."

# Update AUR packages
if yay -Sy --noconfirm --needed; then
    log "AUR packages updated successfully."
else
    log "Failed to update AUR packages."
    notify-send "AUR Update Failed" "There was an error updating AUR packages."
    exit 1
fi

# Update system packages
if yay -Syu --noconfirm; then
    log "System packages updated successfully."
else
    log "Failed to update system packages."
    notify-send "System Update Failed" "There was an error updating system packages."
    exit 1
fi

log "Update completed."
notify-send "System Update" "AUR and system packages have been updated successfully."
