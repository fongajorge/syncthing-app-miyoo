# Syncthing for Onion OS (V4.3+)

A lightweight, native background implementation of Syncthing for Miyoo Mini / Mini Plus running Onion OS V4.3 and newer. 

This updated version utilizes Onion OS's native `startup` hooks to run Syncthing safely in the background, eliminating the need to inject scripts into the system boot files. It is OTA-update safe and completely crash-proof.

## Prerequisites
* **Onion OS V4.3.0 or higher** (Required for the `.tmp_update/startup/` directory hook).
* A Wi-Fi connection.

## Installation Structure
Ensure your SD card is structured exactly like this:

```text
SDCARD/
└── App/
    ├── Syncthing/ (Manual startup)
    │   ├── config.json
    │   ├── launch.sh
    │   └── syncthing (Executable)
    └── SyncThinkQuickKill/ (Optional kill-switch app)
        ├── config.json
        └── launch.sh
```

### Automatic startup
If you want Syncthing to start from boot, you must copy the `.tmp_update/` folder too:

```text
SDCARD/
├── App/
│   ├── Syncthing/ (Manual startup)
│   │   ├── config.json
│   │   ├── launch.sh
│   │   └── syncthing (Executable)
│   └── SyncThinkQuickKill/ (Optional kill-switch app)
│       ├── config.json
│       └── launch.sh
└── .tmp_update/ (Automatic startup)
    └── startup/
        └── syncthing.sh
```

## Setup Instructions

1. Copy the `App` folder to the root of your SD card.
3. Insert the SD card into your Miyoo and turn it on.
4. Ensure Wi-Fi is enabled.
5. Navigate to **Apps** and run **Syncthing**.
6. The script will generate your configuration, bind your IP, and display a prompt with your GUI IP address (e.g., `192.168.1.X:8384`).
7. On a PC or smartphone connected to the same network, navigate to that IP address in a web browser to complete your folder syncing setup.

### Setup for Automatic Startup

> **CAUTION**: If both the .tmp_update/ and App/Syncthing are in the SD Card, you **MUST NOT** start Syncthing manually. This creates a bug in which the web GUI is not shown. (You may check the IP in Onion's WIFI settings)

1. Copy the `App` and `.tmp_update` folders to the root of your SD card.
2. Insert the SD card into your Miyoo and turn it on.
3. Ensure Wi-Fi is enabled.
4. It is **NOT** necessary to manually start the Syncthing app. If you do, the web GUI will not show.
6. On a PC or smartphone connected to the same network, navigate to that IP address in a web browser to complete your folder syncing setup.

## How it Works

* **Auto-Start:** Because of the `syncthing.sh` script in the `startup` folder, Syncthing will silently boot in the background every time you turn on your device. You do not need to launch the app again.
* **The App Icon:** Relaunching the Syncthing app from the menu will simply display your current Web GUI IP address.
* **Killing the Process:** If you need to free up memory for heavy emulation, run the included `SyncThinkQuickKill` app to terminate the background sync for the current session.
