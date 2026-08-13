# flatpak-autoupdate

A systemd timer that runs `flatpak update` on system Flatpaks once a day
(5 min after boot, then every 24h), then prunes unused runtimes.

- Status:   `systemctl status flatpak-update.timer`
- Next run: `systemctl list-timers flatpak-update.timer`
- Run now:  `sudo systemctl start flatpak-update.service`
- Logs:     `journalctl -u flatpak-update.service`

Note: only updates SYSTEM flatpaks (run as root). Per-user (`--user`) installs
are not touched. Removing the package disables the timer.
