#!/bin/bash

echo -n "Please enter the description (hint: "ahg_husky"): "
read DESCRIPTION

source setup.bash

CONFIG_FILE_NAME=$ml_model_params_stereo_CONFIG_FILE_NAME

BASE_DIR=\
$IV_SLAM_DATA_DIR/

CONFIG_FILE_PATH=\
$BASE_DIR/"MODEL"/$DESCRIPTION

eval "$(conda shell.bash hook)"
conda activate ivslam-env

# TODO There is some bug that forces us to clean out the PYTHONPATH env var
export PYTHONPATH=

mkdir $BASE_DIR/"MODEL"/$DESCRIPTION/"exported_model"

cd $BASE_DIR/"MODEL"/$DESCRIPTION/"exported_model"

python \
$IV_SLAM_DIR/introspection_function/training/export_model_light.py \
 --cfg $CONFIG_FILE_PATH/$ml_model_params_stereo_CONFIG_FILE_NAME \
 --output_model "iv_"$DESCRIPTION"_mobilenet_c1deepsup_light.pt"
