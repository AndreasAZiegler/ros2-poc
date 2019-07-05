# ros2-poc
ROS2 Proof of concept

## Set up navigation stack with ROS2 dashing

### Build

Create docker image:
```
docker build . # Run in folder containing Dockerfile
```

Get yourself a beverage while waiting until everything compiled

Tag docker image:
```
docker tag <docker hash number> turtlebot3-gazebo-ros2
```

Start the docker:
```
nvidia-docker run -it --rm --net=host --add-host=AndreasZiegler:127.0.0.1 --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --security-opt apparmor=unconfined --user="1000:1000" --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" --workdir="/home/$USER" --volume="/home/$USER:/home/$USER" --volume="/etc/group:/etc/group:ro" --volume="/etc/passwd:/etc/passwd:ro" --volume="/etc/shadow:/etc/shadow:ro" --volume="/etc/sudoers.d:/etc/sudoers.d:ro" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --env="XAUTHORITY=$XAUTH" --volume="$XAUTH:$XAUTH" --device="/dev/dri:/dev/dri" --volume="/home/andreasziegler/ros:/ros" --runtime="nvidia" turtlebot3-gazebo-ros2
```

Create a ROS2 workspace:
```
mkdir -p ~/turtlebot3_ws/src
cd ~/turtlebot3_ws
```

Get repositories:

Copy turtlebot3.repos into your workspace

Within docker run:
```
vcs import src < turtlebot3.repos
source /opt/ros/crystal/setup.bash
colcon build --symlink-install --packages-select behaviortree_cpp
source install/local_setup.bash
colcon build --symlink-install
```

Get yourself another beverage while waiting until everything compiled


### Start mapping

**Note**: In every new terminal ROS2 and the workspace should be sourced and the turtlebot3 model selected

```
source /opt/ros/crystal/setup.bash
source install/local_setup.bash # within the workspace
export TURTLEBOT3_MODEL=burger
export GAZEBO_MODEL_PATH=~/ros/turtlebot3_ws/src/turtlebot3/turtlebot3_simulations/turtlebot3_gazebo/models/:$GAZEBO_MODEL_PATH
```

Start gazebo:
```
ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py
```

Activate simulation time:
```
ros2 param set /gazebo use_sim_time True
```

Start cartographer:
```
ros2 launch turtlebot3_cartographer cartographer.launch.py use_sim_time:=True
```

Start teleoperation node:
```
ros2 run turtlebot3_teleop teleop_keyboard
```

Move the robot around to map the whole environment

Save tha map:
```
ros2 run nav2_map_server map_saver -f ~/map
```

### Start navigation

**Note**: In every new terminal ROS2 and the workspace should be sourced and the turtlebot3 model selected

Start gazebo:
```
ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py
```

Activate simulation time:
```
ros2 param set /gazebo use_sim_time True
```

Start navigation stack (This will load the map you saved in the previous step):
```
ros2 launch nav2_bringup nav2_bringup_launch.py use_sim_time:=True autostart:=True map:=/home/andreasziegler/map.yaml
```

Start rviz:
```
ros2 run rviz2 rviz2 -d $(ros2 pkg prefix nav2_bringup)/share/nav2_bringup/launch/nav2_default_view.rviz
```

Localize robot:

In rviz click on "2D Pose Estimate" and localize robot.

Navigate:

IN riviz click on "Navigation 2 Goal" and select a goal.


## Miscallaneous

### Save map for Google Cartographer
```
ros2 service call /write_state cartographer_ros_msgs/WriteState "filename: 'map.pbstream'"
```
