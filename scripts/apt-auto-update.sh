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

log "Starting apt package update..."
send_notification "APT Update" "Starting update of apt packages..."

# Refresh package lists
if sudo apt-get update -y; then
    log "apt-get update completed successfully."
else
    log "Failed to run apt-get update."
    send_notification "APT Update Failed" "Failed to update package lists."
    exit 1
fi

# Upgrade packages
if sudo apt-get upgrade -y; then
    log "apt-get upgrade completed successfully."
else
    log "Failed to run apt-get upgrade."
    send_notification "APT Upgrade Failed" "Failed to upgrade packages."
    exit 1
fi

log "Update completed successfully."
send_notification "APT Update" "All apt packages have been updated."
