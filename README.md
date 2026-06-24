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
├── App/
│   ├── Syncthing/
│   │   ├── config.json
│   │   ├── launch.sh
│   │   └── syncthing (Executable)
│   └── SyncThinkQuickKill/ (Optional kill-switch app)
│       ├── config.json
│       └── launch.sh
└── .tmp_update/
    └── startup/
        └── syncthing.sh

```

## Setup Instructions

1. Copy the `App` and `.tmp_update` folders to the root of your SD card.
2. Insert the SD card into your Miyoo and turn it on.
3. Ensure Wi-Fi is enabled.
4. Navigate to **Apps** and run **Syncthing**.
5. The script will generate your configuration, bind your IP, and display a prompt with your GUI IP address (e.g., `192.168.1.X:8384`).
6. On a PC or smartphone connected to the same network, navigate to that IP address in a web browser to complete your folder syncing setup.

## How it Works

* **Auto-Start:** Because of the `syncthing.sh` script in the `startup` folder, Syncthing will silently boot in the background every time you turn on your device. You do not need to launch the app again.
* **The App Icon:** Relaunching the Syncthing app from the menu will simply display your current Web GUI IP address.
* **Killing the Process:** If you need to free up memory for heavy emulation, run the included `SyncThinkQuickKill` app to terminate the background sync for the current session.