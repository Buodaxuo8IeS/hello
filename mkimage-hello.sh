#!/bin/bash

set -e

IMG_ID=$(docker build - < Dockerfile.hello | grep "image id:" | sed 's/.*image id: \(.*\)/\1/')
echo IMG_ID: $IMG_ID
docker rmi hello
docker tag $IMG_ID hello

