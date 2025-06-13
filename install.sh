#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail # Exit on error, unset variable, or pipe failure

LOG_FILE="/var/log/auto-update.log"

# Move auto-update script to /usr/local/bin
function moveAutoUpdateScript() {
    local script_path=$1

    # Check if the script file exists
    if [ ! -f "$script_path" ]; then
        echo "Error: Script $script_path does not exist."
        exit 1
    fi

    # Add the update script and make it executable
    sudo cp "$script_path" /usr/local/bin/update
    sudo chmod +x /usr/local/bin/update

    # Log the installation
    echo "[$(date)] Installed $script_path as /usr/local/bin/update via install.sh" | tee -a "$LOG_FILE"
}

# Check package manager and select appropriate update script
function checkPackageManager(){
    if command -v apt-get &> /dev/null; then
        moveAutoUpdateScript "./scripts/apt-auto-update.sh"
    elif command -v dnf &> /dev/null; then
        moveAutoUpdateScript "./scripts/dnf-auto-update.sh"
    elif command -v pacman &> /dev/null; then
        if command -v yay &> /dev/null; then
            moveAutoUpdateScript "./scripts/yay-auto-update.sh"
        else
            moveAutoUpdateScript "./scripts/pacman-auto-update.sh"
        fi
    else
        echo "unknown package manager"
        exit 1
    fi
}

function verifySystemdFiles(){
    # Check the presence of systemd service and timer files
    if [ ! -f "./systemd_service_file/auto-update.service" ] || [ ! -f "./systemd_service_file/auto-update.timer" ]; then
        echo "Systemd service or timer files are missing."
        exit 1
    fi
}

# Setupd systemd service and timer
function setupSystemd(){
    sudo cp ./systemd_service_file/auto-update.service /etc/systemd/system/auto-update.service
    sudo cp ./systemd_service_file/auto-update.timer /etc/systemd/system/auto-update.timer

    # Reload systemd to recognize the new service and timer
    sudo systemctl daemon-reload

    # Enable and start the auto-update timer
    if sudo systemctl enable --now auto-update.timer;then
        echo "Auto-update timer enabled and started successfully."
    else
        echo "Failed to enable or start the auto-update timer."
        exit 1
    fi
}

# Setup logrotate configuration
function setupLogrotate(){
    # Log the completion of the installation
    sudo cp "./logrotate/auto-update" "/etc/logrotate.d/auto-update"
    echo "Logrotate configuration installed."
}

# Main script execution
checkPackageManager
verifySystemdFiles
setupSystemd
setupLogrotate
