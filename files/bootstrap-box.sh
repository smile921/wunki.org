#!/usr/bin/env sh
DISK=vtbd0

echo "Creating partitions"
gpart create -s gpt $DISK
gpart add -b 34 -s 94 -t freebsd-boot $DISK
gpart add -t freebsd-zfs -l disk0 $DISK
gpart bootcode -b /boot/pmbr -p /boot/gptzfsboot -i 1 $DISK

echo "Creating ZFS pool"
zpool create -o altroot=/mnt -o cachefile=/var/tmp/zpool.cache zroot /dev/gpt/disk0

echo "Export and import the pool"
zpool export zroot
zpool import -o altroot=/mnt -o cachefile=/var/tmp/zpool.cache zroot

echo "Set BootFS"
zpool set bootfs=zroot zroot

echo "Set checksum on root"
zfs set checksum=fletcher4 zroot

echo "Set appropriate settings on filesystem"
zfs create zroot/usr
zfs create zroot/usr/home
zfs create zroot/var
zfs create -o compression=on -o exec=on -o setuid=off zroot/tmp
zfs create -o compression=lzjb -o setuid=off zroot/usr/ports
zfs create -o compression=off -o exec=off -o setuid=off zroot/usr/ports/distfiles
zfs create -o compression=off -o exec=off -o setuid=off zroot/usr/ports/packages
zfs create -o compression=lzjb -o exec=off -o setuid=off zroot/usr/src
zfs create -o compression=lzjb -o exec=off -o setuid=off zroot/var/crash
zfs create -o exec=off -o setuid=off zroot/var/db
zfs create -o compression=lzjb -o exec=on -o setuid=off zroot/var/db/pkg
zfs create -o exec=off -o setuid=off zroot/var/empty
zfs create -o compression=lzjb -o exec=off -o setuid=off zroot/var/log
zfs create -o compression=gzip -o exec=off -o setuid=off zroot/var/mail
zfs create -o exec=off -o setuid=off zroot/var/run
zfs create -o compression=lzjb -o exec=on -o setuid=off zroot/var/tmp

echo "Create swap space"
zfs create -V 4G zroot/swap
zfs set org.freebsd:swap=on zroot/swap
zfs set checksum=off zroot/swap

echo "Fix home"
chmod 1777 /mnt/tmp
cd /mnt ; ln -s usr/home home
chmod 1777 /mnt/var/tmp

echo "Install FreeBSD"
cd /usr/freebsd-dist
export DESTDIR=/mnt
for file in base.txz lib32.txz kernel.txz doc.txz ports.txz src.txz;
do (cat $file | tar --unlink -xpJf - -C ${DESTDIR:-/}); done

echo "Copy zpool cache"
cp /var/tmp/zpool.cache /mnt/zpool.cache

echo "Enable ZFS in rc.conf"
echo 'zfs_enable="YES"' >> /mnt/etc/rc.conf

echo "Enable ZFS in bootloader"
echo 'zfs_load="YES"' >> /mnt/boot/loader.conf
echo 'vfs.root.mountfrom="zfs:zroot"' >> /mnt/boot/loader.conf

echo "Unmount everything..."
# zfs set readonly=on zroot/var/empty
# zfs umount -af
# zfs set mountpoint=legacy zroot
# zfs set mountpoint=/tmp zroot/tmp
# zfs set mountpoint=/usr zroot/usr
# zfs set mountpoint=/var zroot/var

echo "You are done! Reboot!"
