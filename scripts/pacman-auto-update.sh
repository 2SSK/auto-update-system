#!/usr/bin/env bash
set -e  # Exit on error

LOG_FILE="/var/log/auto-update.log"

log(){
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a "$LOG_FILE"
}

send_notification(){
    if [ -n "${DISPLAY:-}" ] && [ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
        notify-send "$1" "$2"
    else
        log "Skipping notify-send: no graphical session available."
    fi
}

log "Starting pacman package update..."
send_notification "Pacman Update" "Starting update of pacman packages..."

# Synchronize and upgrade
if sudo pacman -Syu --noconfirm; then
    log "pacman -Syu completed successfully."
else
    log "Failed to run pacman -Syu."
    send_notification "Pacman Update Failed" "Failed to update packages."
    exit 1
fi

log "Update completed successfully."
send_notification "Pacman Update" "All pacman packages have been updated."
