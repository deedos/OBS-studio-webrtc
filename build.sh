#!/usr/bin/env bash

./CI/before-script-osx.sh $1

cd build

cmake --build .
