# 7 Days to Die server container

Run a **7 Days to Die** server in a container.

## Uses

- [RockyLinux 8](https://hub.docker.com/r/rockylinux/rockylinux)

## Building and running

>> **⚠️Note**
>>  
>> I'm personally using `podman` instead of `docker`, so change what's different for you (Typically it's just replacing `podman` with `docker`).

>> **⚠️Note**
>>  
>> Make sure you modify the `serverconfig.xml` file to meet your needs.

```bash
# Create a volume to store user/save data
podman volume create 7dtd-files

# Build the image
podman build -t 7dtdserver-image .

# Create the container
podman create \
--name 7dtd-server \
--mount type=volume,source=7dtd-files,destination=/home/steam/7dtd-files \
--publish 26900:26900 \
--publish 8080:8080 \
--publish 8081:8081 \
7dtdserver-image:latest

# Start the container
podman start 7dtd-server
```

>> **⚠️Note**
>>  
>> If you're going to stop the server from running, make sure to shut it down cleanly through the web panel or the telnet interface by running the command `shutdown`.
