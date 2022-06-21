# syntax=docker/dockerfile:1
FROM docker.io/rockylinux/rockylinux:8

# Run the core initialization script
## Updates the OS, creates the 'steam' user, installs necessary packages, and install 'steamcmd'.
COPY ./init.sh /tmp/init.sh
RUN chmod +x /tmp/init.sh; \
    /tmp/init.sh; \
    rm /tmp/init.sh

# Set the executing user to 'steam' for all remaining operations (Including the entry point)
USER steam

# Run the initialization script for the 'steam' user
COPY ./steamuser-init.sh /home/steam/steamuser-init.sh
RUN /home/steam/steamuser-init.sh; \
    rm /home/steam/steamuser-init.sh

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
# -- Uncomment the line below if you want to expose the admin panel --
# EXPOSE 8080