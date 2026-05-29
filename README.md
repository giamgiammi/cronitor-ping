# cronitor-ping

> ⚠️ This is a **personal project** that I built for myself. It is shared as-is and tailored to my own needs.

A small utility that periodically pings a [Cronitor](https://cronitor.io/) (or any compatible) heartbeat URL using a `systemd` timer. Each ping reports the machine's uptime and an incrementing run counter, so you can keep an eye on whether a host is alive and how many times the job has run.

## Features

- 🔁 Runs automatically every 5 minutes via a `systemd` timer
- 📊 Sends host **uptime** and a persistent **run counter** with every ping
- 🔐 Reads the target URL securely through systemd's credential mechanism (`LoadCredential`)
- 👤 Runs sandboxed under a `DynamicUser` with no extra privileges
- 📦 Includes a `Makefile` and a script to build a `.deb` package

## Disclaimer on AI usage
I used generative AIs for this readme, the Makefile and create-deb.sh script.

## How It Works

The core is a single Bash script (`cronitor-ping.sh`) executed by a systemd service:

1. The ping URL is loaded from a credential file (`/etc/cronitor.url`) exposed via systemd's `CREDENTIALS_DIRECTORY`.
2. A run counter is stored in the service's `RUNTIME_DIRECTORY` and incremented on each run.
3. The current uptime is collected via `uptime -p`.
4. `curl` performs a GET request to the URL, attaching:
    - `msg=uptime: <uptime>`
    - `metric=count:<counter>`

A companion `systemd` timer triggers the service on the schedule `*:0/5:00` (every 5 minutes) and is `Persistent`, so missed runs are caught up after downtime.

## Project Structure
```. 
├── Makefile # install / uninstall targets 
├── create-deb.sh # builds a .deb package 
└── src 
   ├── bash 
      │ 
      └── cronitor-ping.sh # the ping script 
   └── systemd 
      ├── cronitor-ping.service # systemd service unit 
      └── cronitor-ping.timer # systemd timer unit
```

## Requirements

- `bash`
- `curl`
- `procps` (for `uptime`)
- A Linux system using `systemd`

## Installation

### From source (Makefile)
```sudo make install```

This installs:

- The script to `$(PREFIX)/bin/cronitor-ping.sh` (default `PREFIX` is `/usr/local`)
- The service and timer units to `/lib/systemd/system`

You can customize the install location:

To uninstall:
```sudo make uninstall```


### As a Debian package

Build a `.deb` and install it:

```bash
./create-deb.sh
sudo dpkg -i cronitor-ping_1.0_all.deb
```

### Configuration & Usage
1. Create the credential file with the URL to ping:
   ```
   echo 'https://cronitor.link/p/<your-key>/<monitor>' | sudo tee /etc/cronitor.url
   sudo chmod 600 /etc/cronitor.url
   ```
2. Enable and start the timer:
   ```sudo systemctl enable --now cronitor-ping.timer```
3. Check status / logs:
   ```
   sudo systemctl status cronitor-ping.timer
   journalctl -u cronitor-ping.service
   ```
4. Optional tuning:
   - MAX_TIME — curl timeout in seconds (defaults to 60). Set it in the service environment if you need a different value.