#!/usr/bin/env bash
# This script updates all packages on Fedora/RHEL using dnf.

set -e  # Exit on error

LOG_FILE="/var/log/auto-update.log"

log(){
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a "$LOG_FILE"
}

log "Starting dnf package update..."
notify-send "DNF Update" "Starting update of dnf packages..."

# Refresh metadata and upgrade
if sudo dnf upgrade --refresh -y; then
    log "dnf upgrade completed successfully."
else
    log "Failed to run dnf upgrade."
    notify-send "DNF Update Failed" "Failed to upgrade packages."
    exit 1
fi

log "Update completed successfully."
notify-send "DNF Update" "All dnf packages have been updated."
