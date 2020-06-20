#! /bin/sh

mkdir build || true
rm -rf build/* || true

GOOS=linux go build -o build/main src/cmd/lambdatest/main.go 
cd build && zip main.zip main


