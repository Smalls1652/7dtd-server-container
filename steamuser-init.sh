#!/bin/bash

# Create the directory for the '7 Days to Die server'
echo "- Creating '7 Days to Die server' directory"
mkdir /home/steam/7dtd-server/

# Install the '7 Days to Die server' using 'steamcmd'
echo "- Installing '7 Days to Die server'"
/home/steam/steamcmd/steamcmd.sh +force_install_dir /home/steam/7dtd-server/ +login anonymous +app_update 294420 +quit

# Remove the default 'serverconfig.xml' file
rm /home/steam/7dtd-server/serverconfig.xml

# Ensure that "execute" permissions are set on the '7 Days to Die server' files
chmod --recursive +x /home/steam/7dtd-server/