# Ros2 Humble dev image

This is a ros2 humble developement ade image. 

## Base image
It is based on an augmented `osrf/ros:humble-desktop-full` docker image (see https://github.com/osrf/docker_images/tree/master/ros/humble/ubuntu/jammy) with:

* Upgrading the ros package to the last sync (the osrf docker image update is not nescessarly released at the same time as the sync)
* Installing classical build, test and development packages (and plotjuggler!)
* Updating rosdep so it is immediatly usable
* Installing Gazebo Ignition (Fortress)
* Installing Cyclone DDS along with iproute2 (for enabling multicast on lo)

## env.sh config
The env.sh includes the sourcing of the ros2 binary, the variables to restrict DDS communication to local only and the selection of Cyclone as the DDS. Plus some variable for console formating:

```
# ROS2 bin sourcing
source /opt/ros/humble/setup.bash

# DDS configuration (more on that below)
export ROS_LOCALHOST_ONLY=1 # Isolate DDS com (avoid same LAN crosstalk)
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp # Force usage of Cyclone instead of Fast DDS

## Bonus stuff
# Ros log console formatting
export RCUTILS_CONSOLE_OUTPUT_FORMAT='[{severity}] [{time}] [{name}]: {message}'
export RCUTILS_COLORIZED_OUTPUT=1

```
## entrypoint config
`sudo ip link set lo multicast on` was added to the entrypoint to for enabling multicast on lo)

## .aderc file
```
export ADE_DOCKER_RUN_ARGS="
  --cap-add=SYS_PTRACE
  --cap-add=SYS_ADMIN
  --cap-add=NET_ADMIN # needed for enabling multicast on lo
  --ulimit rtprio=100:100
  --ulimit memlock=-1:-1
  --shm-size 4G
"

export ADE_IMAGES="
  # use image built from this repo Dockerfile and stored on github (alternatively, you can build it locally
  ghcr.io/doisyg/ade-ros2-humble-dev:04-10-2022 
  # Optional tools volume
  ghcr.io/doisyg/ade-qtcreator-ros:8.0.1
"
```

## Docker image building
The base image is build with this repo Dockerfile. It was built locally with
> docker build -t ghcr.io/doisyg/ade-ros2-humble-dev:04-10-2022 .

And was then uploaded to the github registry with
> echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin
> docker push ghcr.io/doisyg/ade-ros2-humble-dev:04-10-2022

Where `CR_PAT` is your github token

No github action is set yet to do it directely on github.
