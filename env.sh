#!/usr/bin/env bash
#
# Copyright 2017 - 2018 Ternaris
# SPDX-License-Identifier: Apache 2.0

for x in /opt/*; do
    if [[ -e "$x/.env.sh" ]]; then
	source "$x/.env.sh"
    fi
done

# ROS2 bin and workspace sourcing
source /opt/ros/humble/setup.bash

# DDS configuration (more on that below)
export ROS_LOCALHOST_ONLY=1 # Isolate DDS com (avoid same LAN crosstalk)
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp # Force usage of Cyclone instead of Fast DDS

## Bonus stuff
# Ros log console formatting
export RCUTILS_CONSOLE_OUTPUT_FORMAT='[{severity}] [{time}] [{name}]: {message}'
export RCUTILS_COLORIZED_OUTPUT=1

cd

