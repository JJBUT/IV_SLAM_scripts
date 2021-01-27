#!/bin/bash


echo -n "Please enter session ID (hint: five digits): "
read SESSION

source ../CONFIG/setup.bash

CONFIG_FILE_NAME=$legoloam2kitti_CONFIG_FILE_NAME

BASE_DIR=\
$IV_SLAM_DATA_DIR

CONFIG_FILE_PATH=\
$BASE_DIR/"CONFIG"/$SESSION

TARGET_RESULT_BASE_DIR=\
$BASE_DIR/"KITTI_FORMAT"/$SESSION

echo ""
echo "**************************** legoloam2kitti Script Parameters ****************************"
echo "SESSION: " $SESSION
echo "CONFIG_FILE_NAME: " $CONFIG_FILE_NAME
echo "BASE_DIR: " $BASE_DIR
echo "CONFIG_FILE_PATH: " $CONFIG_FILE_PATH
echo "TARGET_RESULT_BASE_DIR: " $TARGET_RESULT_BASE_DIR
echo "**************************** legoloam2kitti Script Parameters ****************************"
echo ""

mkdir -p $TARGET_RESULT_BASE_DIR
mkdir -p $TARGET_RESULT_BASE_DIR/"sequences/image_0"
mkdir -p $TARGET_RESULT_BASE_DIR/"sequences/image_1"

/home/administrator/SLAM/introspective_SLAM/ROS/introspective_SLAM/bin/legoloam2kitti \
	--config_path $CONFIG_FILE_PATH/$CONFIG_FILE_NAME
