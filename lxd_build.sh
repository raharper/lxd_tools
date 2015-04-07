#!/bin/bash

export GOPATH=~/go
go get github.com/lxc/lxd
cd $GOPATH/src/github.com/lxc/lxd
go get -v -d ./...
make
