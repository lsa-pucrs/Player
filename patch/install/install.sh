#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color


apt-get update
apt-get install -y build-essential

# update VBoX Additions - Only if used on VirtualBox VM
#apt-get install -y module-assistant
#sudo m-a prepare

# nice to have, not mandatory
apt-get install -y geany
#apt-get install -y google-chrome-stable
#apt-get install -y oracle-java7-installer

#compilation utils
echo -e "${GREEN}Installing Compilation Utils ... ${NC}\n"
apt-get install -y autoconf
apt-get install -y cmake
apt-get install -y cmake-curses-gui
apt-get install -y git
apt-get install -y pkg-config

# Player/Stage depedencies
echo -e "${GREEN}Installing Player/Stage Dependencies ... ${NC}\n"
apt-get install -y libfltk1.1-dev 
apt-get install -y freeglut3-dev 
apt-get install -y libpng12-dev 
apt-get install -y libltdl-dev 
#libltdl7 
apt-get install -y libdb5.1-stl
apt-get install -y libgnomecanvasmm-2.6-dev
apt-get install -y python-gnome2
apt-get install -y libboost-all-dev  # overkill, the actually required libraries are boostthread, boostsignal, boostsystem
# old OpenCV for older Player drivers
apt-get install -y libopencv-core-dev libcv-dev libcvaux-dev libhighgui-dev
# alsa - sound player
# http://player-stage-gazebo.10965.n7.nabble.com/CCmake-cannot-find-the-existing-asoundlib-h-for-ALSA-driver-td11198.html
apt-get install -y libasound2-dev
# alsa alsa-tools  alsa-utils
# for pmap
apt-get install -y libgsl0-dev libxmu-dev
# for python bindings for Player clients - 
# It is not recommended to use python due to limitations in the bindings. 
# Things that work on a C/C++ client might not work on a Python client.
apt-get install -y python-dev swig
# PostGIS for a Player driver
apt-get install -y libpq-dev libpqxx-dev
# festival TTS - Spanish voice
apt-get install festvox-ellpc11k

export LD_LIBRARY_PATH=/usr/lib:/usr/local/lib/:/usr/lib/x86_64-linux-gnu/:$LD_LIBRARY_PATH

cd ../..
echo -e "${GREEN}Patching Player for Lubuntu 14.04 ... ${NC}\n"
patch -p1 < patch/festival/festival.patch
patch -p1 < patch/install/player_3.0.2_14.04.patch
mkdir build
cd build
# Mandatory
# DEBUG_LEVEL=NONE <==== important !!!
# Recommended: Build the Python bindings for the C client library
# BUILD_PYTHONCPP_BINDINGS:BOOL=ON
# BUILD_PYTHONC_BINDINGS:BOOL=ON
echo -e "${GREEN}Configuring Player for Lubuntu 14.04 ... ${NC}\n"
cmake -DDEBUG_LEVEL=NONE -BUILD_PYTHONC_BINDINGS:BOOL=ON ..
echo -e "${GREEN}Compiling Player for Lubuntu 14.04 ... ${NC}\n"
make
make install
