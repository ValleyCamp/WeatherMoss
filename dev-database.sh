#!/usr/bin/env bash
# Based on https://gist.github.com/bobmaerten/9329752

CONTAINER_NAME="weathermoss-dev-mysql"

function getStatus(){
  CONTAINER_ID=$(docker ps -a | grep -v Exit | grep $CONTAINER_NAME | awk '{print $1}')
  if [[ -z $CONTAINER_ID ]] ; then
    echo "Not running."
    return 1
  else
    echo "Running in container: $CONTAINER_ID"
    return 0
  fi
}

case "$1" in
  start)
    docker ps -a | grep -v Exit | grep -q $CONTAINER_NAME
    if [ $? -ne 0 ]; then
      docker run -d -p 23306:3306 -v "$PWD/.weathermoss-dev-mysql-data:/var/lib/mysql" -e MYSQL_ROOT_PASSWORD=weathermossdeveloper --name $CONTAINER_NAME mariadb:10
    fi
    getStatus
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
  *)
    printf "Usage: `basename $0` {start|stop} \nRuns a mariadb docker container named weathermoss-dev-mysql on port 23306, which the dev environment is expecting to find.\n\n"
    exit 1
    ;;
esac

exit 0
