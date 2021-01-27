# IV-SLAM Scripts
Described here are the scripts in the `DATA` folder that are used for the entire IV-SLAM workflow from acquisition to inference.

## Data Directory
In order to directly use the provided scripts the directory structure and labeling should follow this structure:

    /DATA
        /calibrations
            left.yaml
            right.yaml
        /scripts
            lego_loam_stereo.bash
            legoloam2kitti_stereo.bash
            iv_slam_stereo.bash
            export_model.bash 
            evaluate_model.bash 
        /00001
        /00002
        /00003
        /0000X
            0000X_202x_xx_xx_xx_xx_xx.bag
            setup.bash
            /config
                0000X_legoloam2kitti_stereo.lua
                0000X_ml_model_params_stereo.yaml
                0000X_orb_iv_camera_params_generation_stereo.yaml
                0000X_orb_iv_camera_params_inference_stereo.yaml
                0000X_orb_iv_camera_params_inference_w_introspection_stereo.yaml
Each data acquisition session (read: every bag file) has a unique 5 digit ID (e.g. 00001, 00002, 0000X) that is interchangably called the "ID", "session ID", "session", or "session number". This session ID is used to access, describe, and group the data for processing and training. 

After all the scripts, executing the entire IV-SLAM pipeline, have been run the session directory will have the the following structure:

    \0000X
        00001_202x_xx_xx_xx_xx_xx.bag
        setup.bash
        \config
        \LeGO_LOAM_output
        \KITTI_format
        \training_data
        \model

### The ROS Bag File
The `0000X_202x_xx_xx_xx_xx_xx.bag` bag found in the each session directory should have the following topics:

1. `/stereo/left/camera_info` of type `sensor_msgs/CameraInfo`     
1. `/stereo/left/image_raw/compressed`  of type  `sensor_msgs/CompressedImage`
1. `/stereo/right/camera_info` of type  `sensor_msgs/CameraInfo`     
1. `/stereo/right/image_raw/compressed` of type  `sensor_msgs/CompressedImage`
1. `/velodyne_points` of type `sensor_msgs/PointCloud2`

If the cameras have not been calibrated then then the `camera_info` topics will probably be empty and you do not need to record them.

Note that the image topics must be ***compressed***! Uncompressed recorded image streams take up so much space that you cannot record a bag file for more than a couple minutes before it becomes unworkable.

### The Setup Script
The `setup.bash` script found in each session directory exports some environmental variables that the top level scripts need to process each session with its custom configuration files.

    # IV_SLAM -- DO NOT CHANGE
    export IV_SLAM_DIR="/home/administrator/SLAM/IV_SLAM"
    export IV_SLAM_DATA_DIR="/home/administrator/DATA"

    # CONFIG FILES -- PLEASE CHANGE SESSION ID
    SESSION="00001"
    export legoloam2kitti_CONFIG_FILE_NAME=$SESSION"_xxx
    export orb_iv_camera_params_generation_CONFIG_FILE_NAME=$SESSION"_xxx
    export orb_iv_camera_params_inference_CONFIG_FILE_NAME=$SESSION"_xxx
    export orb_iv_camera_params_inference_w_introspection_CONFIG_FILE_NAME=$SESSION"_xxx
    export ml_model_params_stereo_CONFIG_FILE_NAME=$SESSION"_xxx

## lego_loam_stereo.bash
This script is responsible for running LeGO-LOAM which we use to produce our ground truth pose estimate for IV-SLAM. It creates the output directories, locates the bag file, and launches the ROS node. After the `lego_loam_stereo.bash` script has been executed the `\LeGO_LOAM_output` output directory should look like:

    \LeGO_LOAM_output
        \maps
            0000X.pcd
        \poses
            0000X_poses.txt
        \sequences
            0000X_sequences.txt

## legoloam2kitti_stereo.bash
This script is responsible for converting the output of LeGO-LOAM into KITTI formatted data. It creates the output directories, loads the `0000X_legoloam2kitti_stereo.lua` config file, and runs the `legoloam2kitti` executable. After the `legoloam2kitti_stereo.bash` script has been executed the `\KITTI_format` output directory should look like:

    \KITTI_format
        \poses
            0000X_poses.txt
        \sequences
            0000X_times.txt
            /image_0
                *.png
            /image_1
                *.png

## iv_slam_stereo.bash
This script is responsible for running the main IV-SLAM executable in one of its 3 modes:

1. Training Data Generation
1. Inference (ORB-SLAM)
1. Inference with Introspection (IV-SLAM)

 Based on user input in the terminal (e.g. 1 -> training data generation, 2 -> inference, 3 -> inference with introspection) the script will load the correct configuration file and pass the appropriate command line arguments to the `stereo_kitti` executable. The command line args are configured as:

| Mode                              |   1   |   2   |   3   |
| :---:   | :-: | :-: | :-: |
| IVSLAM_ENABLED                    | true  | false | true  |
| CREATE_IVSLAM_DATASET             | true  | false | false |
| INFERENCE_MODE                    | false | true  | true  |
| INTROSPECTION_FUNCTION_ENABLED    | false | false | true  |
| ENABLE_VIEWER                     | false | true  | true  |
| USE_GPU                           | false | false | true  |


### Training Data Generation (TDG)
TDG requires the properly organized `KITTI_format` directory to operate. The output of the TDG is the `training_data` directory which should look like:

    \training_data
        \generated_training_data
            img_name.json
            keypoints.json
            \bad_region_heatmap
                *.png
            \bad_region_heatmap_mask
                *.png
        \diagnostics


If at least 50% of the total picture count is flagged as "good" for TDG (read: it is included in the `generated_training_data` directory) then the system is considered to be working well.

Use the `--minloglevel` flag to toggle the diagnostic data creation. The `\diagnostics` directory contains an array of folders, some of which are populated and some of which are not, that contain data potentially useful for debugging purposes. 