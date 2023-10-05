#!/usr/bin/env bash
# Based on https://gist.github.com/bobmaerten/9329752

CONTAINER_IMAGE="mariadb:10"
CONTAINER_NAME="weathermoss-dev-mysql"
CONTAINER_PORT="23306"

function getContainerStatus(){
  CONTAINER_ID=$(docker ps -a | grep -v Exit | grep $CONTAINER_NAME | awk '{print $1}')
  if [[ -z $CONTAINER_ID ]] ; then
    echo "Not running."
    return 1
  else
    echo "$CONTAINER_NAME ($CONTAINER_ID) is running (should be on $CONTAINER_PORT)"
    return 0
  fi
}

case "$1" in
  start)
    docker ps -a | grep -v Exit | grep -q $CONTAINER_NAME
    if [ $? -ne 0 ]; then
      # Podman doesn't create the mount folder if it doesn't exist, so we have to make sure it's there.
      if [ ! -d /tmp/$CONTAINER_NAME-data ]; then
        mkdir /tmp/$CONTAINER_NAME-data
      fi
      docker run --rm -d -p $CONTAINER_PORT:3306 -v "/tmp/$CONTAINER_NAME-data:/var/lib/mysql:z" -e MYSQL_ROOT_PASSWORD=weathermossdeveloper --name $CONTAINER_NAME $CONTAINER_IMAGE
    fi
    getContainerStatus
    ;;
  stop)
    CONTAINER_ID=$(docker ps -a | grep -v Exit | grep $CONTAINER_NAME | awk '{print $1}')
    if [[ -n $CONTAINER_ID ]] ; then
      SRV=$(docker stop $CONTAINER_ID)
      SRV=$(docker rm $CONTAINER_ID)
      if [ $? -eq 0 ] ; then
        echo 'Stopped.'
      fi
    fi
    ;;
  status)
    getContainerStatus
    ;;
  *)
    printf "Usage: `basename $0` {start|stop|status} \nRuns a $CONTAINER_IMAGE docker container named weathermoss-dev-mysql on port $CONTAINER_PORT, which the dev environment is expecting to find.\n\n"
    exit 1
    ;;
esac

exit 0
