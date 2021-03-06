#!/bin/bash -evx

if [ $(id -u) -eq 0 ]; then
	echo "root bro... rolling out"
else
	echo "not root bro - stop here"
	exit 1
fi

if [ ! $# -eq 2 ]; then
	location=$1
	echo "location is $location"
else
	echo "no location is given"
	exit 2
fi

# wipe the target with no mercy (if it exists)
if [ -d $location ]; then
	echo "removing... $location"
	rm -rf $location
fi

packages_list=$(cat 'packages.config' | grep -v '#' | sort -u | tr '\n' ' ')

#fakechroot_engage_cmd='fakechroot fakeroot'

# fakechroot with minbase variant is vital only when rolling out distro into home directory where user has full access
# rights
# CAUTION: do not use fakeroot for chroots or u might get ambiguity of access right in chroot fs
# install your chroot into /srv by default; do not use home dirs to avoid fs loops
$fakechroot_engage_cmd debootstrap --verbose --variant=minbase --arch=amd64 --components=main,universe --include="$packages_list" xenial "$location"

