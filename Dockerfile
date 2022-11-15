FROM osrf/ros:rolling-desktop-full

RUN apt-get update

# Taken from Apex.io base dev image: https://gitlab.apex.ai/apex.ai-public/ros2-ade/-/blob/master/humble/Dockerfile
RUN apt-get install -y  \
        bash-completion \
        build-essential \
        cmake \
        git \
        libbullet-dev \
        python3-colcon-common-extensions \
        python3-flake8 \
        python3-pip \
        python3-pytest-cov \
        python3-rosdep \
        python3-setuptools \
        python3-vcstool \
        acl \
        libacl1-dev \
        vim \
        wget && \
    apt-get install --no-install-recommends -y \
        libasio-dev \
        libtinyxml2-dev \
        libcunit1-dev && \
    python3 -m pip install -U \
        argcomplete \
        flake8-blind-except \
        flake8-builtins \
        flake8-class-newline \
        flake8-comprehensions \
        flake8-deprecated \
        flake8-docstrings \
        flake8-import-order \
        flake8-quotes \
        pytest-repeat \
        pytest-rerunfailures \
        pytest
        
# Ignition Gazebo
RUN wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
RUN apt-get install -y ignition-fortress
   
# Upgrade to get last ros sync, the osrf/ros:humble-desktop-full docker image is sometime late
RUN apt-get upgrade -y

# G additions	
RUN apt-get install -y \
        ros-rolling-plotjuggler-ros \
        ros-rolling-rmw-cyclonedds-cpp \
        htop \
        iproute2

# rosdep update
RUN rosdep update --rosdistro=humble

# After apt install sudo
RUN echo 'ALL ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY env.sh /etc/profile.d/ade_env.sh
COPY entrypoint /ade_entrypoint
ENTRYPOINT ["/ade_entrypoint"]
CMD ["/bin/sh", "-c", "trap 'exit 147' TERM; tail -f /dev/null & while wait ${!}; [ $? -ge 128 ]; do true; done"]

