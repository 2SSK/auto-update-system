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

log "Starting dnf package update..."
send_notification "DNF Update" "Starting update of dnf packages..."

# Refresh metadata and upgrade
if sudo dnf upgrade --refresh -y; then
    log "dnf upgrade completed successfully."
else
    log "Failed to run dnf upgrade."
    send_notification "DNF Update Failed" "Failed to upgrade packages."
    exit 1
fi

log "Update completed successfully."
send_notification "DNF Update" "All dnf packages have been updated."
