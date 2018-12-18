#!/bin/bash

set -e

docker build --squash -t pklaus/pytrbnet .

#docker tag local-image:tagname new-repo:tagname
#docker push pklaus/pytrbnet:latest
docker push pklaus/pytrbnet
