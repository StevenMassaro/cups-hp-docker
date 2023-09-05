# cups-hp-docker
CUPS server running in a docker container, automatically configured to work with HP Printers.

## Motivation
I have an HP LaserJet 1018 printer, and wanted it to be automatically configured on my server to run inside CUPS. Additionally, I needed the docker container to automatically reconfigure the printer upon server restarts.

## Compatibility

| Printer | Connectivity | Notes |
| ----------- | ----------- | ----------- |
| HP LaserJet 1018 | USB | Working |

## Usage

```
services:
  cups:
    container_name: cups
    image: stevenmassaro/cups-hp-docker
    ports:
      - '631:631'
    devices:
      - /dev/bus/usb
    environment:
      - CUPSADMIN=admin
      - CUPSPASSWORD=admin
      - TZ=America/New_York
    volumes:
      - '<local_path>/cups:/etc/cups'
```

### Add printer to CUPS

1. Go to the cups admin page
2. Click Administration > Find New Printers
3. Click "HP LaserJet 1018" (the one with the serial number at the end, it might not matter, but this worked for me)
4. Click "Share this printer" and click "Continue"
5. In the driver select page, I used this driver: "HP LaserJet 1018, hpcups 3.22.10, requires proprietary plugin (en)" (I selected the first one, there are many duplicates in the list)
6. Then click "Add Printer" and print a test page.

### Add remote printer to Windows

1. Go to the add new printer window and click add
2. The printer won't be found immediately, so click that it wasn't listed
3. Select a shared printer by name with entry `http://<IP/hostname>:631/printers/HP_LaserJet_1018`
4. Use the `MS Publisher Imagesetter` driver under the `Generic` manufacturer

### Other useful commands

`hp-check` checks to make sure the printer is installed correctly, output (truncated) looks like this:

```
--------------------------
| DISCOVERED USB DEVICES |
--------------------------

  Device URI                               Model
  ---------------------------------------  --------------------------------------
  hp:/usb/HP_LaserJet_1018?serial=<serial>  HP LaserJet 1018

---------------------------------
| INSTALLED CUPS PRINTER QUEUES |
---------------------------------


HP_LaserJet_1018
----------------
Type: Printer
Device URI: hp:/usb/HP_LaserJet_1018?serial=<serial>
PPD: /etc/cups/ppd/HP_LaserJet_1018.ppd
PPD Description: HP LaserJet 1018, hpcups 3.22.10, requires proprietary plugin
Printer status: printer HP_LaserJet_1018 is idle.  enabled since Tue Sep  5 11:41:29 2023
Required plug-in status: Installed
Communication status: Good
```

## Potential issues
- Unplugging and replugging the printer (or any action which gives it a new USB ID) would probably render this solution non-working.

