#!/usr/bin/env bash

_BUILD_TYPE=${1:-RELEASE}
export BUILD_TYPE=${BUILD_TYPE:-${_BUILD_TYPE}}

./CI/before-deploy-osx.sh
