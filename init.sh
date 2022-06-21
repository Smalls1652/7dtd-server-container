#!/bin/bash

# Create the user account for running 'steamcmd'.
# For simplicity's sake, it'll just aptly be named 'steam'. :P
echo "- Creating 'steam' user"
useradd -m steam

# Update the base system.
echo "- Updating installed packages"
dnf update -y

# Install necessary dependencies for 'steamcmd' to run.
# These two dependencies are:
#   - glibc.i686
#   - libstdc++.i686
echo "- Installing necessary dependencies"
dnf install -y glibc.i686 libstdc++.i686 tar curl util-linux sudo

# Cleanup all obsolete packages.
echo "- Cleaning up packages"
dnf autoremove -y
dnf clean all

# Download and extract the 'steamcmd' client.
echo "- Downloading steamcmd"
mkdir /tmp/steamcmd && cd /tmp/steamcmd
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
cd /

# Move the extracted folder to '/home/steam/'.
echo "- Moving steamcmd to home directory for 'steam'"
mv /tmp/steamcmd/ /home/steam/

# Set the ownership of the files to the 'steam' user and grant execution permissions.
echo "- Modifying steamcmd file ownership and permissions"
chown --recursive steam:steam /home/steam/steamcmd
chmod --recursive +x /home/steam/steamcmd

# Set the open files limit for the 'steam' user
# Note:
## This might not be needed and probably won't fix the underlying problem (Or lack thereof).
## The 'steamcmd.sh' script outputs a warning saying:
### > ulimit: open files: cannot modify limit: Operation not permitted
## Even with the following changes, the warning is still shown.
echo "- Setting open files limit for 'steam' user"
echo "steam soft nofile 4096" >> /etc/security/limits.conf
echo "steam hard nofile 10240" >> /etc/security/limits.conf
echo "session required pam_limits.so" >> /etc/pam.d/login

echo "- Finished"