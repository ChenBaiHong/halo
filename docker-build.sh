#!/bin/bash

hub_url="swr.cn-north-1.myhuaweicloud.com"
hub_user="ap-southeast-1@XSFMSFYAW5J7PYHUC89J"
hub_pwd="1ff5fcd2aa0de1883aaea602a00be9d0b1a4c833d62918c2ffe5d138d67b5913"
hub_reps="baihoo"

# shellcheck disable=SC2046
docker rmi $(docker images | grep "$hub_reps/halo" | awk '{print $3}')

gradle clean build

VERSION=$(ls build/libs | sed 's/.*halo-//' | sed 's/.jar$//')

echo "Halo version: $VERSION"

mv "build/libs/halo-$VERSION.jar" "build/libs/halo.jar"

docker build -t "$hub_url/$hub_reps/halo:$VERSION" ./

docker login -u "$hub_user" -p "$hub_pwd" "$hub_url"

docker push "$hub_url/$hub_reps/halo:$VERSION"
