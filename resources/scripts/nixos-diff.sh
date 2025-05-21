#!/usr/bin/env bash

set -e
pushd ~/.config/nixos

git fetch
git diff "$(nixos-version --configuration-revision)"...origin

popd
