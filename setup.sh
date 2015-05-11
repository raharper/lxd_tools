#!/bin/bash -x
case `uname -m` in
  aarch64)  ARCH='arm64';;
  ppc64le)  ARCH='ppc64el';;
  *) ARCH=`uname -m`;;
esac
RELEASE=${1:-'vivid'}

sudo apt-get install -y git screen socat parallel

# get pylxd and apply my patch
[ ! -d "pylxd" ] && {
    https_proxy=$https_proxy git clone https://github.com/zulcss/pylxd
    (cd pylxd && patch -p1 < ../pylxd_rharper.patch)
}

# spawn a socat instance
if ! screen -ls socat | grep -q socat; then
    screen -S socat -dm socat -d -d TCP-LISTEN:8080,fork UNIX:/var/lib/lxd/unix.socket
fi

# import trusty image
if ! lxc image list | grep -q ubuntu-vivid; then
    https_proxy=$https_proxy lxd-images import lxc ubuntu $RELEASE $ARCH --alias ubuntu-$RELEASE
fi

# launch and stop it; we want the instantiated rootfs
if ! lxc list | grep -q $RELEASE-template; then
   lxc launch ubuntu-$RELEASE $RELEASE-template
   lxc stop --force $RELEASE-template 
fi

echo 
echo "Now run:"
echo "  sudo ./create_and_delete_pylxd test1 $RELEASE-template/rootfs"
echo 
