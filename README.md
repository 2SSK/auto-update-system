# Auto System Updater

A collection of scripts and systemd units to automatically update your Linux system (including AUR packages) on boot and on a daily basis. This project supports Debina/Ubuntu, Fedorra, Arch and Arch-based distributions.

## 📜 Features

- **Automated Updates:** Updates official and Aur packages non-interactively using `yay` or the native package manager.
- **Systemd Integration:** A service (`auto-update.service`) and timer (`auto-update.timer`) to run updates on boot and once daily.
- **Notification**: Desktop notifications via `notify-send`
- **Logging**: Logs update output to `/var/log/auto-update.log`
- **Log Rotation:** Built-in `logrotate` configuration to prevent log growth.
- **Idempotent installer:** `install.sh` safely installs or updates the service, timer, update script, and logrotate configuration.

## 🚀 Installation

1. Clone or download this repository.
2. Make the installer executable:

```bash
chmod +x install.sh
```

3. Run the installer:

```bash
   chmod +x install.sh
```

4. Verify that the service and timer are enabled:

```bash
systemctl list-timers | grep auto-update
```

## ⚙️ Usage

- **On Boot:** The updater runs 1 minute after every system start.
- **Daily:** The updatr runs once every 24 hours.
- **Logs:** Check `/var/log/auto-update.log` for details.

## 🔧 Customization

- To adjust the schedule, edit `/etc/systemd/system/auto-update.timer` and reload:

```bash
sudo system daemon-reload
sudo systemctl restart auto-update.timer
```

- Modify logrotate settings in `/etc/logrotate.d/auto-update` to change log retention.

# 🤝 Contributing

Feel free to submit issues or pull requests for new package manager, support, notificaion methods, or features.

## 📄 License

This project is released under the `MIT License`.
