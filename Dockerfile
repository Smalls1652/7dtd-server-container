# syntax=docker/dockerfile:1
FROM docker.io/rockylinux/rockylinux:8

# Create 'steam' user account
RUN useradd -m steam

# Update any existing packages, install necessary packages, and cleanup (To reduce image size)
RUN dnf upgrade --refresh -y; \
    dnf install -y glibc.i686 libstdc++.i686 tar curl util-linux sudo telnet; \
    dnf autoremove -y; \
    dnf clean all

# Download 'steamcmd', extract it, move it to the 'steam' user's home directory, and ensure it's owned by the 'steam' user.
RUN mkdir /tmp/steamcmd && cd /tmp/steamcmd; \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -; \
    cd /; \
    mv /tmp/steamcmd/ /home/steam/; \
    chown --recursive steam:steam /home/steam/steamcmd; \
    chmod --recursive +x /home/steam/steamcmd

# Set the executing user to 'steam' for all remaining operations (Including the entry point)
USER steam

# Install the '7 Days to Die server'
RUN mkdir /home/steam/7dtd-server/; \
    /home/steam/steamcmd/steamcmd.sh +force_install_dir /home/steam/7dtd-server/ +login anonymous +app_update 294420 +quit; \
    chmod --recursive +x /home/steam/7dtd-server/

# Remove the default 'serverconfig.xml' file.
RUN rm /home/steam/7dtd-server/serverconfig.xml

# Create the directory to store user/save files
RUN mkdir /home/steam/7dtd-files

# Copy the 'serverconfig.xml' to the '7 Days to Die server' directory
COPY --chown=steam:steam ./serverconfig.xml /home/steam/7dtd-server/serverconfig.xml

# Set the entry point
WORKDIR /home/steam/7dtd-server
ENTRYPOINT [ "/bin/bash", "./startserver.sh", "-configfile=serverconfig.xml" ]

# Expose the port that players will connect to (By default it's 26900)
EXPOSE 26900

# Expose the port for the admin panel (By default it's 8080)
EXPOSE 8080