#!/usr/bin/env bash
set -e # Exit on error (if any command fails)

LOG_FILE="/var/log/auto-update.log"

log(){
    echo -e "$(date +'%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a "$LOG_FILE"
}

send_notification(){
    if [ -n "${DISPLAY:-}" ] && [ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
        notify-send "$1" "$2"
    else
        log "Skipping notify-send: no graphical session available."
    fi
}

log "Starting AUR package update..."
send_notification "AUR Update" "Starting update of AUR packages..."

# Update AUR packages
if yay -Sy --noconfirm --needed; then
    log "AUR packages updated successfully."
else
    log "Failed to update AUR packages."
    send_notification "AUR Update Failed" "There was an error updating AUR packages."
    exit 1
fi

# Update system packages
if yay -Syu --noconfirm; then
    log "System packages updated successfully."
else
    log "Failed to update system packages."
    send_notification "System Update Failed" "There was an error updating system packages."
    exit 1
fi

log "Update completed."
send_notification "System Update" "AUR and system packages have been updated successfully."
