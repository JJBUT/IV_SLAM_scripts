#!/bin/bash

txtred=$(tput setaf 1) # Red
txtgrn=$(tput setaf 2)
txtrst=$(tput sgr0) # Text reset


echo -n "Config setup? (hint: 2021_jan): "
read CONFIG_MONTH

SESSIONS="6 7 8 9 10 11 12 13 14"
DESCRIPTION="speedway_24th_cross"
INTROSPECTION_MODEL_PATH="


source ../CONFIG/setup.bash


BASE_DIR=\
$IV_SLAM_DATA_DIR

CONFIG_FILE_PATH=\
$BASE_DIR/"CONFIG"/$CONFIG_MONTH


IVSLAM_ENABLED="true"
CREATE_IVSLAM_DATASET="false"
INFERENCE_MODE="true"
INTROSPECTION_FUNCTION_ENABLED="true"
USE_GPU="true"
CONFIG_FILE_NAME=$orb_iv_camera_params_inference_w_introspection_CONFIG_FILE_NAME
	
TARGET_DATASET_BASE_DIR=""

PREDICTED_IMAGE_QUAL_BASE_DIR=""


START_FRAME="0" 
RECTIFY_IMGS="true"
UNDISTORT_IMGS="true"
ENABLE_VIEWER="false"

RUN_SINGLE_THREADED="false"
LOAD_IMG_QUAL_HEATMAPS_FROM_FILE="false"
LOAD_REL_POSE_UNCERTAINTY="false"
IVSLAM_PROPAGATE_KEYPT_QUAL="false"

MAP_DRAWER_VISUALIZE_GT_POSE="true"

OPTIMIZER_RUN_EXTRA_ITERATIONS="true"
OPTIMIZER_POSE_OPT_ITER_COUNT="4" # def: 4
TRACKING_BA_RATE="1" # def: 1


for session in $SESSIONS; do
  	printf -v SESSION_NUM_STR '%05d' "$session"
  
  	echo "*********************************"
  	echo "Running on $SESSION_NUM_STR"
  	echo "*********************************"
 
	SOURCE_DATASET_BASE_DIR=$BASE_DIR/"KITTI_FORMAT"/$SESSION_NUM_STR
	SEQUENCE_PATH=$SOURCE_DATASET_BASE_DIR/"sequences"
	GROUND_TRUTH_PATH=$SOURCE_DATASET_BASE_DIR/"poses"
	LIDAR_POSE_UNC_PATH=$SOURCE_DATASET_BASE_DIR/"lidar_poses"

	TARGET_RESULT_BASE_DIR=$BASE_DIR/"MODEL"/$DESCRIPTION/"evaluate_model"/$SESSION_NUM_STR/"IV_SLAM"
	mkdir -p $TARGET_RESULT_BASE_DIR
	mkdir -p $TARGET_DATASET_BASE_DIR


	$IV_SLAM_DIR/introspective_ORB_SLAM/Examples/Stereo/stereo_kitti \
  		--vocab_path=$IV_SLAM_DIR/"introspective_ORB_SLAM/Vocabulary/ORBvoc.txt" \
  		--settings_path=$CONFIG_FILE_PATH/$CONFIG_FILE_NAME \
  		--data_path=$SEQUENCE_PATH \
  		--minloglevel="1" \
  		--ground_truth_path=$GROUND_TRUTH_PATH/"poses.txt" \
  		--img_qual_path=$PREDICTED_IMAGE_QUAL_BASE_DIR/$SESSION_NUM_STR/ \
  		--introspection_model_path=$INTROSPECTION_MODEL_PATH \
  		--out_visualization_path=$TARGET_RESULT_BASE_DIR \
  		--out_dataset_path=$TARGET_DATASET_BASE_DIR \
  		--rel_pose_uncertainty_path=$LIDAR_POSE_UNC_PATH/$SESSION_NUM_STR"_pred_unc.txt" \
  		--start_frame=$START_FRAME \
  		--introspection_func_enabled=$INTROSPECTION_FUNCTION_ENABLED \
  		--load_img_qual_heatmaps=$LOAD_IMG_QUAL_HEATMAPS_FROM_FILE \
  		--load_rel_pose_uncertainty=$LOAD_REL_POSE_UNCERTAINTY \
  		--run_single_threaded=$RUN_SINGLE_THREADED \
  		--create_ivslam_dataset=$CREATE_IVSLAM_DATASET \
  		--ivslam_enabled=$IVSLAM_ENABLED \
  		--inference_mode=$INFERENCE_MODE \
  		--enable_viewer=$ENABLE_VIEWER \
  		--use_gpu=$USE_GPU \
  		--rectify_images=$RECTIFY_IMGS \
  		--undistort_images=$UNDISTORT_IMGS \
  		--optimizer_run_extra_iter=$OPTIMIZER_RUN_EXTRA_ITERATIONS \
  		--optimizer_pose_opt_iter_count=$OPTIMIZER_POSE_OPT_ITER_COUNT \
  		--tracking_ba_rate=$TRACKING_BA_RATE \
  		--map_drawer_visualize_gt_pose=$MAP_DRAWER_VISUALIZE_GT_POSE \
  		--ivslam_propagate_keyptqual=$IVSLAM_PROPAGATE_KEYPT_QUAL 
done



