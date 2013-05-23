#!/bin/bash
# Generate a very minimal filesystem based on busybox-static,
# and load it into the local docker under the name "busybox".

BUSYBOX=$(which busybox)
[ "$BUSYBOX" ] || {
    echo "Sorry, I could not locate busybox."
    echo "Try 'apt-get install busybox-static'?"
    exit 1
}

HELLO=$(which hello)
[ "$HELLO" ] || {
    echo "Sorry, I could not locate hello."
    exit 1
}

set -e
ROOTFS=/tmp/rootfs-busybox-$$-$RANDOM
mkdir $ROOTFS
cd $ROOTFS

mkdir bin etc dev dev/pts lib proc sys tmp
touch etc/resolv.conf
cp /etc/nsswitch.conf etc/nsswitch.conf
echo root:x:0:0:root:/:/bin/sh > etc/passwd
echo root:x:0: > etc/group
ln -s lib lib64
ln -s bin sbin
cp $BUSYBOX bin
cp $HELLO bin
for X in $(busybox --list)
do
    ln -s busybox bin/$X
done
rm bin/init
ln bin/busybox bin/init
cp /lib/x86_64-linux-gnu/lib{pthread,c,dl,nsl,nss_*}.so.* lib
cp /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 lib
for X in console null ptmx random stdin stdout stderr tty urandom zero
do
    sudo cp -a /dev/$X dev
done

tar -cf- . | docker import - hello
docker run -i -u root hello /bin/echo Success.
