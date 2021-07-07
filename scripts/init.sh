#!/usr/bin/env bash

DOCKER_IMAGE='mysql'
DOCKER_IMAGE_TAG='latest'
DOCKER_CONTAINER='gb-ai-mysql'

MYSQL_ROOT_PASSWORD='Ifgrfc1Q'

docker run -d -u root --name ${DOCKER_CONTAINER} \
  -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
  -v $(pwd)/.my.cnf:/root/.my.cnf \
  -v $(pwd)/datadir:/var/lib/mysql \
  -v $(pwd):/mnt/host \
  -p 3306:3306 -p 33060:33060 \
  ${DOCKER_IMAGE}:${DOCKER_IMAGE_TAG}
