#!/bin/bash
# Build 3DCityDB WFS images ###################################################
# Set registry and image name
REPOSITORY="tumgis"
IMAGENAME="3dcitydb-wfs"
# Set versions to build
# v3.0.0 and v 3.2.0 currently not working, because Github release download naming
declare -a versions=("3.3.0" "3.3.1" "3.3.2")

# build all version
for i in "${versions[@]}"
do
  docker build --build-arg "citydb_wfs_version=${i}" -t "${REPOSITORY}/${IMAGENAME}:v${i}" .
done

# create tag "latest" from last position in versions array
lastelem=${versions[$((${#versions[@]}-1))]}
docker build --build-arg "citydb_wfs_version=${lastelem}" -t "${REPOSITORY}/${IMAGENAME}:latest" .
