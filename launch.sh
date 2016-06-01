#/usr/bin/env bash
set -e

source import.sh

IMAGE_NAME=nginx-conjur-tutorial
docker build -t $IMAGE_NAME:latest docker

HOST_ID=my-server
API_KEY=$(conjur host rotate_api_key -h $HOST_ID)
CONJURIZE="$(echo "{\"id\": \"$HOST_ID\", \"api_key\": \"$API_KEY\"}" | conjurize)"


if [[ -z "$APPLIANCE_NAME" ]]; then
  docker ps
  echo "What is the name of your Conjur appliance container?"
  read APPLIANCE_NAME
fi

docker run -d \
  -p 8080:80 \
  -p 8081:443 \
  -e CONJURIZE="$CONJURIZE" \
  --name $IMAGE_NAME \
  --link $APPLIANCE_NAME:$APPLIANCE_NAME \
  $IMAGE_NAME