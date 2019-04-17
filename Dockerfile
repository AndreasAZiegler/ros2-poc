# This is an auto generated Dockerfile for ros:desktop-full
# generated from docker_images/create_ros_image.Dockerfile.em
FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

# nvidia-docker hooks
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

RUN apt-get update && apt-get install -q -y tzdata && rm -rf /var/lib/apt/lists/*

# Set the locale
RUN apt-get clean && apt-get update && apt-get install -y locales apt-utils
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# install packages
RUN apt update && apt install -y curl gnupg2 lsb-release

RUN curl http://repo.ros2.org/repos.key | apt-key add -

RUN sh -c 'echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list'

RUN apt-get update && apt-get install -f -y \
  git cmake cmake-curses-gui vim pkg-config gcc g++ gdb clang clang-tidy clang-tools \
  sudo unzip wget build-essential \
  ros-crystal-desktop ros-crystal-rqt* ros-crystal-tf2-sensor-msgs \
  python3-colcon-common-extensions \
  python3-argcomplete \
  python3-vcstool \
  build-essential \
  libgtest-dev \
  lcov \
  libgoogle-glog-dev \
  google-mock \
  libceres-dev \
  liblua5.3-dev \
  libboost-dev \
  libboost-iostreams-dev \
  libprotobuf-dev \
  protobuf-compiler \
  libcairo2-dev \
  libpcl-dev \
  python3-sphinx

# Install Gazebo9
RUN curl -sSL http://get.gazebosim.org | sh
# Install Navigation2 dependencies
RUN apt-get install -y \
  libsdl-image1.2 \
  libsdl-image1.2-dev \
  libsdl1.2debian \
  libsdl1.2-dev
