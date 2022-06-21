# 7 Days to Die server container

Run a **7 Days to Die** server in a container.

## Uses

- [RockyLinux 8](https://hub.docker.com/r/rockylinux/rockylinux)

## Building and running

> **⚠️Note**
>  
> I'm personally using `podman` instead of `docker`, so change what's different for you (Typically it's just replacing `podman` with `docker`).

> **⚠️Note**
>  
> Make sure you modify the `serverconfig.xml` file to meet your needs.

### Using the compose file

```bash
# Build/create all resources and start the container
## The '--detach' parameter will help prevent locking inputs in your shell. 
podman-compose up --detach
```

### Manually 

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
7dtdserver-image:latest

# Start the container
podman start 7dtd-server
```

## Shutting down the container cleanly

> **❗Warning**
>  
> If you're going to stop the server from running, make sure to shut it down cleanly.

### Through Telnet

If you have the ability to interact with the host OS that runs the container, the Telnet interface is available within the container itself. You can do the following:

```bash
# Run `telnet` interactively inside the container
podman exec --interactive 7dtd-server telnet localhost 8081

Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
*** Connected with 7DTD server.
*** Server version: Alpha 20.5 (b2) Compatibility Version: Alpha 20.5
*** Dedicated server only build

Server IP:   x.x.x.x
Server port: 26900
Max players: 8
Game mode:   GameModeSurvival
World:       Navezgane
Game name:   My Game
Difficulty:  2

Press 'help' to get a list of all commands. Press 'exit' to end session.

# Type in 'shutdown' and press the enter key
shutdown

2022-06-21T22:14:10 750.940 INF Executing command 'shutdown' by Telnet from 127.0.0.1:43964
Shutting server down...
2022-06-21T22:14:10 750.988 INF Preparing quit
2022-06-21T22:14:10 750.988 INF Disconnect
2022-06-21T22:14:10 750.989 INF [NET] ServerShutdown
2022-06-21T22:14:10 750.989 INF NET: Stopping server protocols
2022-06-21T22:14:10 751.077 INF NET: LiteNetLib server stopped
2022-06-21T22:14:10 751.079 INF SaveAndCleanupWorld
2022-06-21T22:14:10 751.103 INF Saving 0 of chunks took 20ms
2022-06-21T22:14:10 751.123 INF [DECO] written 77054, in 19ms
2022-06-21T22:14:10 751.125 INF [DECO] write thread 1ms
2022-06-21T22:14:10 751.126 INF [EOS] Unregistering server
2022-06-21T22:14:10 751.128 INF [Steamworks.NET] Stopping server
2022-06-21T22:14:10 751.432 INF [Steamworks.NET] Exiting Lobby
2022-06-21T22:14:10 751.565 INF AstarManager Cleanup
2022-06-21T22:14:10 751.649 INF Clearing queues.
2022-06-21T22:14:10 751.649 INF Cleared queues.
2022-06-21T22:14:11 752.569 INF Clearing queues.
2022-06-21T22:14:11 752.570 INF Cleared queues.
2022-06-21T22:14:11 752.571 INF Clear LOD Disabled Prefabs
2022-06-21T22:14:11 752.575 INF World.Unload
2022-06-21T22:14:11 752.585 INF Exited thread GenerateChunks
2022-06-21T22:14:11 752.587 INF Exited thread SaveChunks /home/steam/7dtd-files/save//Navezgane/My Game/Region
2022-06-21T22:14:11 752.596 INF World.Cleanup
2022-06-21T22:14:11 752.598 INF Exited thread ChunkRegeneration
2022-06-21T22:14:11 752.603 INF Exited thread ChunkCalc
2022-06-21T22:14:11 752.604 INF Exited thread ChunkMeshBake
2022-06-21T22:14:11 752.607 INF VehicleManager saving 0 (0 + 0)
2022-06-21T22:14:11 752.609 INF VehicleManager saved 9 bytes
2022-06-21T22:14:11 752.610 INF DroneManager saving 0 (0 + 0)
2022-06-21T22:14:11 752.611 INF DroneManager saved 9 bytes
Connection closed by foreign host.
```
