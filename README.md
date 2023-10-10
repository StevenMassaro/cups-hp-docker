# cups-hp-docker
CUPS server running in a docker container, automatically configured to work with HP Printers.

## Motivation
I have an HP LaserJet 1018 printer, and wanted it to be automatically configured on my server to run inside CUPS, so that I could wireless print from my laptop to my Linux server (where the printer is plugged in via USB). Additionally, I needed the docker container to automatically reconfigure the printer upon server restarts.

## Archival
I found a printer that has an ethernet port on the side of the road shortly after making this. The new printer works so I'm archiving this repo. A note for future visitors here, this repo did work for me. As I recall though, I had to use the plain cups image that this one is based on to set up the printer, then switch to this image after it was set up.

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
    user: '1000:1000'
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
2. Click `Administration` > `Find New Printers`
3. Click `HP_LaserJet_1018_USB_<serial>_HPLIP` (the one with the serial number at the end, it might not matter, but this worked for me)
4. Click `Share this printer` and click `Continue`
5. In the driver select page, I used this driver: `HP LaserJet 1018, hpcups 3.22.10, requires proprietary plugin (en)` (I selected the first one, there are many duplicates in the list)
6. Then click `Add Printer` and print a test page.

### Add remote printer to Windows

1. Go to the add new printer window and click add
2. The printer won't be found immediately, so click that it wasn't listed
3. Select a shared printer by name with entry `http://<IP/hostname>:631/printers/HP_LaserJet_1018_USB_<serial>_HPLIP`
4. Use the `MS Publisher Imagesetter` driver under the `Generic` manufacturer
5. Print a test page from Windows.

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
- Unplugging and replugging the printer (or any action which gives it a new USB ID) would probably render this solution non-working. This might require some kind of uninstallation in the `startup.sh` script. [helpful link 1](https://askubuntu.com/questions/1056077/how-to-install-latest-hplip-on-my-ubuntu-to-support-my-hp-printer-and-or-scanner) [helpful link 2](https://developers.hp.com/hp-linux-imaging-and-printing/howtos/install#howtocheck7)

