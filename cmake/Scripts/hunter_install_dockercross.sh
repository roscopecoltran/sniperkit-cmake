#!/bin/bash

################################################################################
#
# Copyright (c) 2017, Luc Michalski
# All rights reserved.
#
# DOCKERCROSS Plugin
# Repository: https://github.com/dockcross/dockcross.git
#
################################################################################

clear

CURRENT_DIR=$(pwd)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BIN_DIR="${DIR}/../../bin"
DOCKERCROSS_PATH="${BIN_DIR}/dockercross"
DOCKER_VOLUME_DIR="${DIR}/../.."

echo 
echo "CURRENT_DIR: ${CURRENT_DIR}"
echo "DIR: ${DIR}"
echo "BIN_DIR: ${BIN_DIR}"
echo "BIN_DIR: ${BIN_DIR}"
echo "DOCKER_VOLUME_DIR: ${DOCKER_VOLUME_DIR}"
echo 

################################################################################
# install dockercross dependencies (Docker)
################################################################################

  #######################
  # for Mac 
  #######################
  # brew install docker

  #######################
  # for Ubuntu  
  #######################
  # apt-get install docker

################################################################################
# install dockercross locally
################################################################################

	# dockercross paths settings
	DOCKERCROSS_SHARED_VOLUME=${DOCKER_VOLUME_DIR}
	echo "DOCKERCROSS_SHARED_VOLUME: ${DOCKERCROSS_SHARED_VOLUME}"
	echo 

	# dockercross shared volume (required by docker-machine, docker-unison, crane)
	mkdir -p ${DOCKERCROSS_SHARED_VOLUME}
	DOCKERCROSS_INSTALL_PREFIX=${DOCKERCROSS_PATH}
	DOCKERCROSS_TESTS_PREFIX_PATH="${DOCKER_VOLUME_DIR}/tests/dockercross"

	mkdir -p ${DOCKERCROSS_TESTS_PREFIX_PATH}

	mkdir -p ${DOCKERCROSS_INSTALL_PREFIX}
	ls -l $DOCKERCROSS_INSTALL_PREFIX

	mkdir -p $DOCKERCROSS_TESTS_PREFIX_PATH
	ls -l $DOCKERCROSS_TESTS_PREFIX_PATH

	echo 
	echo "DOCKERCROSS_SHARED_VOLUME: ${DOCKERCROSS_SHARED_VOLUME}"
	echo "DOCKERCROSS_INSTALL_PREFIX: ${DOCKERCROSS_INSTALL_PREFIX}"
	echo "DOCKERCROSS_TESTS_PREFIX_PATH: ${DOCKERCROSS_TESTS_PREFIX_PATH}"
	echo 

# ┌──────────────────────────────────────────────────────────────────┐
# │  Download all images                                             │
# └──────────────────────────────────────────────────────────────────┘

  # These images are built using the "build implicit rule"
  DOCKERCROSS_STANDARD_IMAGES="android-arm linux-x86 linux-x64 linux-arm64 linux-armv5 linux-armv6 linux-armv7 linux-mipsel linux-ppc64le windows-x86 windows-x64"

  # These images are expected to have explicit rules for *both* build and testing
  DOCKERCROSS_NON_STANDARD_IMAGES="browser-asmjs manylinux-x64 manylinux-x86"

  echo 
  echo "Download all dockercross images"
  echo "DOCKERCROSS_STANDARD_IMAGES: ${DOCKERCROSS_STANDARD_IMAGES[*]}"
  echo "DOCKERCROSS_NON_STANDARD_IMAGES: ${DOCKERCROSS_NON_STANDARD_IMAGES[*]}"
  echo 

  curl -s https://raw.githubusercontent.com/dockcross/dockcross/master/Makefile -o dockcross-Makefile
  for image in $(make -f dockcross-Makefile display_images); do
    echo "Pulling dockcross/$image"
    docker pull dockcross/$image
  done

# ┌──────────────────────────────────────────────────────────────────┐
# │  Install all dockcross scripts                                   │
# └──────────────────────────────────────────────────────────────────┘

  echo
  echo "Install all dockcross scripts"
  echo 

  curl -s https://raw.githubusercontent.com/dockcross/dockcross/master/Makefile -o dockcross-Makefile
  #cat dockcross-Makefile
  for image in $(make -f dockcross-Makefile display_images); do
    if [[ $(docker images -q dockcross/$image) == "" ]]; then
      echo "${DOCKERCROSS_INSTALL_PREFIX}/dockcross-$image skipping: image not found locally"
      continue
    fi
    echo "${DOCKERCROSS_INSTALL_PREFIX}/dockcross-$image ok"
    docker run dockcross/$image > ${DOCKERCROSS_INSTALL_PREFIX}/dockcross-$image && \
    chmod u+x ${DOCKERCROSS_INSTALL_PREFIX}/dockcross-$image
  done
