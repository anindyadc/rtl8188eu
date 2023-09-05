# DO NOT PUT THE WIFI DONGLE IN THE DEVICE BEFORE MENTIONED EXPLICITLY BELOW

# Brief note, after this the UI will not show the usb dongle, 
# the wifi does work and I get an IP address, so all works,
# but I don't go into detail of making it show on the Raspbian UI.
# (for this purpose I don't care about the UI)

# For the use of this I connected my device to an ethernet connection and through the Router could see the IP which I can SSH into.

## STEP 1: Prepare machine and install packages needed

# Make sure the system is up to date and all that needs to be installed is installed
`sudo apt-get update && sudo apt-get install -f`

# I also upgrade my distro, but this step can be skipped
`sudo apt-get dist-upgrade`

# Install some necessary packages as we will build the source firmware ourselves
`sudo apt-get install -y build-essential git`

# There is a package for raspberry pi to add the kernel headers, so you can pick one here (if one doesn't work, use the other)
`sudo apt-get install -y linux-headers`
`sudo apt-get install -y raspberrypi-kernel-headers`

# reboot for changes to take effect
`sudo reboot`


## STEP 2: Get and install the firmware for TP-Link-WN725N Nano

# Download the Github package (for best support use git clone instead of zip)
# I just put this on my home folder as I am not using this RPI for any other purpose than a livecam
`git clone https://github.com/lwfinger/rtl8188eu.git`

# Go into the new folder
`cd rtl8188eu`

# Make the source for your machine
`make`

# Install the firmware that was just build for your machine
`sudo make install`

# Reboot for changes to take effect
`sudo reboot`

# Shutdown now as we need to have the usb dongle in the RPI on startup
`sudo shutdown -h now`

## STEP 3: (INSERT USB DONGLE BEFORE CONTINUING) Check if dongle is recognized by the system

# After starting your rpi check if it now recognizes your wifi dongle
`lsusb`
# This should show something like `BUS 00X .... REALTEK... RTL8188EUS... Wireless Network Adapter`

# Great your wifi dongle is now recognised. If not, you probably don't have this dongle or you need to repeat the above steps.

# Check if modules are being loaded
`lsmod`
# Search for something like `8188eu ... 0`

# Check if wlan0 is present
`ifconfig -a`
# There should be quite some output next to and under `wlan0`, if there's an IP address already visible, skip all next steps it's working.

## STEP 4: Setup wifi settings

# Add wifi settings
`sudo vi /etc/network/interfaces`
# Search for `auto wlan0` at the start, if it's not there, add it and keep the file open

# Make sure it knows where to find the wpa config
# Add these lines to the bottom of the same file:
```
allow-hotplug wlan0
iface wlan0 inet dhcp
wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
iface default inet dhcp
```

## STEP 5: Connect to wifi

# The file `wpa_supplicant.conf` might already exist and might have some lines, add these below:
```
network={
ssid="YOUR_NETWORK_NAME"
psk="YOUR_NETWORK_PASSWORD"
proto=RSN
key_mgmt=WPA-PSK
pairwise=CCMP
auth_alg=OPEN
}
```
# Replace `YOUR_NETWORK_NAME` & `YOUR_NETWORK_PASSWORD` with your own credentials.

# Reboot and connect
`sudo reboot`

# To test after reboot if your wifi is working, you can open the browser or go to the terminal
`ifconfig -a`
# This will now have an ip-address next to `wlan0` which you can use for ssh or whatever.

# Congrats!


## Resources used:
# The dongle on Amazon: https://www.amazon.de/TP-Link-TL-WN725N-Adapter-Suitable-10-9-10-13/dp/B008IFXQFU/
# The Firmware: https://github.com/lwfinger/rtl8188eu
# Troubleshooting on RPI: https://www.raspberrypi.org/forums/viewtopic.php?t=44044
# Wifi auto connect on RPI: https://weworkweplay.com/play/automatically-connect-a-raspberry-pi-to-a-wifi-network/
# Extra resource for rpi-source: https://blog.samat.org/2014/12/15/realtek-8188eu-based-wi-fi-adapters-on-the-raspberry-pi/


