#!/usr/bin/env bash
set -euox pipefail

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

# shellcheck disable=SC2046
docker build \
    --build-arg METVIEWBUNDLE="$bundle" \
    --build-arg PARALLELISM=$(($(nproc) / 2)) \
    $(if [[ -z ${LOCAL+x} ]]; then echo "--platform linux/amd64,linux/arm64"; fi) \
    $(if [[ -n ${LOCAL+x} ]]; then echo "--load"; fi) \
    --tag "ghcr.io/dzfranklin/metview:$version" \
    --tag "ghcr.io/dzfranklin/metview:latest" \
    $(if [[ -z ${DRY_RUN+x} ]]; then echo "--push"; fi) \
    .
