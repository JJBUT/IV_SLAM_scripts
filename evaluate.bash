#!/bin/bash

txtred=$(tput setaf 1) # Red
txtgrn=$(tput setaf 2)
txtrst=$(tput sgr0) # Text reset

echo -n "eval/postproc/viz? (hint: 1/2/3): "
read MODE

source ../CONFIG/setup.bash


BASE_DIR=\
$IV_SLAM_DATA_DIR

EVAL_PATHS


if [ $MODE = "1" ]; then
	echo ""
	echo ${txtgrn}"**************************** Eval ****************************"${txtrst} 
	echo ${txtgrn}"**************************** Eval ****************************"${txtrst}
	echo ""

elif [ $MODE = "2" ]; then
	echo ""
	echo ${txtgrn}"**************************** Postproc ****************************"${txtrst}
	echo ${txtgrn}"**************************** Postproc ****************************"${txtrst}
	echo ""

elif [ $MODE = "3" ]; then
	echo ""
	echo ${txtgrn}"**************************** Viz ****************************"${txtrst}
	echo ${txtgrn}"**************************** Viz ****************************"${txtrst}

else
	echo ${txtred}"Neither eval or postproc or viz specified! EXITING"${txtrst}
	exit
fi
