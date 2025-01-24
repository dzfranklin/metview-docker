#!/usr/bin/env bash
set -euox pipefail

# The last gdal docker image based on ubuntu 22, which as of MetviewBundle-2024.11.0 was the latest version metview built on
gdal_version=3.8.5

# Usage
#
# Environment variables
# - DRY_RUN: If set the image will not be pushed
# - LOCAL: The image will only be built for the local platform and it will be loaded into the local docker
#          Implies DRY_RUN

if [[ -n ${LOCAL+x} ]]; then
  DRY_RUN=1
fi

function fatal {
  printf "publish.sh: %s\n" "$@" >&2
  exit 1
}

bundle_pattern='MetviewBundle*.tar.gz'
if [[ $(find . -maxdepth 1 -type f -name "$bundle_pattern" -exec printf %c {} + | wc -c) != "1" ]]; then
  fatal "expected exactly one bundle file"
fi
bundle=$(find . -maxdepth 1 -type f -name "$bundle_pattern" | sed -r 's/^.\/(.*)\.tar\.gz$/\1/')
version=$(tar xzfO "$bundle".tar.gz "$bundle"/metview/VERSION)

# Publish

function publish() {
  tag_suffix="$1"
  base_image="$2"
  # shellcheck disable=SC2046
  docker build \
      --build-arg BASE_IMAGE="$base_image" \
      --build-arg METVIEWBUNDLE="$bundle" \
      --build-arg PARALLELISM=$(if [[ -z ${LOCAL+x} ]]; then echo $(($(nproc) / 2)); else nproc; fi) \
      $(if [[ -z ${LOCAL+x} ]]; then echo "--platform linux/amd64,linux/arm64"; fi) \
      $(if [[ -n ${LOCAL+x} ]]; then echo "--load"; fi) \
      --tag "ghcr.io/dzfranklin/metview:${version}${tag_suffix}" \
      --tag "ghcr.io/dzfranklin/metview:latest${tag_suffix}" \
      $(if [[ -z ${DRY_RUN+x} ]]; then echo "--push"; fi) \
      .
}

publish "" "ubuntu:22.04"
publish "-gdal" "ghcr.io/osgeo/gdal:ubuntu-small-${gdal_version}"
publish "-gdal-full" "ghcr.io/osgeo/gdal:ubuntu-full-${gdal_version}"
