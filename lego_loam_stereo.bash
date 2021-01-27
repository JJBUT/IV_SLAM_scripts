#!/bin/bash

echo -n "Please enter session ID (hint: five digits): "
read SESSION

ROSBAG=$(find ../BAGS -name $SESSION'_*.bag')

source ../CONFIG/setup.bash

BASE_DIR=\
$IV_SLAM_DATA_DIR

TARGET_DATASET_BASE_DIR=\
$BASE_DIR/"LEGO_LOAM_OUTPUT"/$SESSION

LIDAR_TOPIC="/velodyne_points"

echo ""
echo "**************************** LeGO_LOAM Script Parameters ****************************"
echo "SESSION: " $SESSION
echo "ROSBAG: " $(basename $ROSBAG)
echo "BASE_DIR: " $BASE_DIR
echo "TARGET_DATASET_BASE_DIR: " $TARGET_DATASET_BASE_DIR
echo "**************************** LeGO_LOAM Script Parameters ****************************"
echo ""

mkdir -p $TARGET_DATASET_BASE_DIR
mkdir -p $TARGET_DATASET_BASE_DIR/"sequences"
mkdir -p $TARGET_DATASET_BASE_DIR/"maps"
mkdir -p $TARGET_DATASET_BASE_DIR/"poses"

source /home/administrator/WS/slam_ws/devel/setup.bash

roslaunch lego_loam_bor run_custom.launch \
	bagfile_id:=$SESSION  \
	rosbag:=$BASE_DIR/"BAGS"/$(basename $ROSBAG) \
	output_base_path:=$TARGET_DATASET_BASE_DIR \
	lidar_topic:=$LIDAR_TOPIC 
	
