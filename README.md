# ros2-poc
ROS2 Proof of concept

## Set up navigation stack with ROS2 crystal

### Build

Create docker image:
```
docker build . # Run in folder containing Dockerfile
```

Create a ROS2 workspace:
```
mkdir -p ~/turtlebot3_ws/src
cd ~/turtlebot3_ws
```

Get repositories:

Copy turtlebot3.repos into your workspace

```
vcs import src < turtlebot3.repos
colcon build --symlink-install
```

Get yourself a beverage while waiting until everything compiled


### Start mapping
Note: In every new terminal ROS2 and the workspace should be sourced and the turtlebot3 model selected
```
source /opt/ros/crystal/setup.bash
source install/local_setup.bash # within the workspace
export TURTLEBOT3_MODEL=burger
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


## Miscallaneous

### Save map
```
ros2 service call /write_state cartographer_ros_msgs/WriteState "filename: 'map.pbstream'"
```
