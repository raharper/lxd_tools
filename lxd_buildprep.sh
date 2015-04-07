#!/bin/bash

GOPATH=~/go
mkdir $GOPATH
export GOPATH=$GOPATH
sudo add-apt-repository --yes ppa:ubuntu-lxc/lxd-git-master
sudo apt-get install lxc lxc-dev mercurial git pkg-config protobuf-compiler golang-goprotobuf-dev golang xz-utils tar acl curl gettext jq sqlite3

