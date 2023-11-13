#!/usr/bin/env bash
# Based on https://gist.github.com/bobmaerten/9329752

##########################
##### CONFIG SECTION #####

CONTAINER_NAME="weathermoss-dev-postgres"
CONTAINER_PORT="51423"
CONTAINER_PG_PASSWORD="weathermossdeveloper"
DEV_DATABASE_NAME="weathermoss_dev"
# Uncomment if you have both podman and docker installed and which to force docker.
# (Will default to podman otherwise)
# CONTAINER_ENGINE="docker"

##### END CONFIG SECTION #####
##############################




if [[ -z $CONTAINER_ENGINE ]] ; then
  if ! command -v podman &> /dev/null; then
    if ! command -v docker &> /dev/null; then
      echo "Neither podman nor docker could be found, aborting."
      exit 1
    else
      CONTAINER_ENGINE="docker"
    fi
  else
    CONTAINER_ENGINE="podman"
  fi
fi


function getContainerStatus(){
  CONTAINER_ID=$($CONTAINER_ENGINE ps -a | grep -v Exit | grep $CONTAINER_NAME | awk '{print $1}')
  if [[ -z $CONTAINER_ID ]] ; then
    echo "Not running."
    return 1
  else
    echo "$CONTAINER_NAME ($CONTAINER_ID) running on $CONTAINER_PORT"
    return 0
  fi
}

case "$1" in
  start)
    $CONTAINER_ENGINE ps -a | grep -v Exit | grep -q $CONTAINER_NAME
    if [ $? -ne 0 ]; then
      # Podman doesn't create the mount folder if it doesn't exist, so we have to make sure it's there.
      if [ ! -d /tmp/$CONTAINER_NAME-data ]; then
        mkdir /tmp/$CONTAINER_NAME-data
      fi
      $CONTAINER_ENGINE run --rm -p $CONTAINER_PORT:5432 -v "/tmp/$CONTAINER_NAME-data:/var/lib/postgresql/data:Z" -e POSTGRES_PASSWORD=$CONTAINER_PG_PASSWORD --name $CONTAINER_NAME -d postgres:13
    fi
    getContainerStatus
    ;;
  stop)
    CONTAINER_ID=$($CONTAINER_ENGINE ps -a | grep -v Exit | grep $CONTAINER_NAME | awk '{print $1}')
    if [[ -n $CONTAINER_ID ]] ; then
      SRV=$($CONTAINER_ENGINE stop $CONTAINER_ID)
      if [ $? -eq 0 ] ; then
        echo 'Stopped.'
      fi
    fi
    ;;
  dev-console)
    $CONTAINER_ENGINE exec -it $CONTAINER_NAME psql -U postgres $DEV_DATABASE_NAME
    ;;
  *)
    printf "Usage: `basename $0` {start|stop|dev-console} \nStarts (or stops and deletes) a postegres docker container named $CONTAINER_NAME on port $CONTAINER_PORT, which the dev environment is expecting to find.\nAlso provides a convenient way to access a psql console.\n\n"
    exit 1
    ;;
esac

exit 0
