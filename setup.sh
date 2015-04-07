#!/bin/bash -x

sudo apt-get install -y git socat parallel

# get pylxd and apply my patch
[ ! -d "pylxd" ] && {
    git clone https://github.com/zulcss/pylxd
    (cd pylxd && patch -p1 < ../pylxd_rharper.patch)
}

# spawn a socat instance
if ! screen -ls socat | grep -q socat; then
    screen -S socat -dm socat -d -d TCP-LISTEN:8080,fork UNIX:/var/lib/lxd/unix.socket
fi

# import trusty image
lxd-images import lxc ubuntu trusty amd64 --alias ubuntu-trusty

# launch and stop it; we want the instantiated rootfs
lxc launch ubuntu-trusty trusty-template
lxc stop --force trusty-template 

echo 
echo "Now run:"
echo "  sudo ./create_and_delete_pylxd test1 trusty-template/rootfs"
echo 
