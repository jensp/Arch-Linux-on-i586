#!/bin/bash
repodir=/home/build/abs-i586
startdir=$(pwd)
cd $repodir
for repo in */
do
	echo Entering repo $repo
	cd $repo
	for package in */
	do
		cd $package
		if [ ! -e PKGBUILD ]
		then
			echo "PKGBUILD for $package does not exist"
		else
			#echo "$package :"
			eval $(grep ^pkgver PKGBUILD)
			eval $(grep ^pkgrel PKGBUILD)
			archver=$(curl http://www.archlinux.org/packages/$repo/i686/$package/ 2> /dev/null|grep '<h2 class="title">'|sed -e :a -e 's/<[^>]*>//g;/</N;//ba'|awk '{print $2}')
			if [[ $(vercmp $archver $pkgver-$pkgrel) == "1" ]]
			then
				echo $package
				echo Your version is $pkgver-$pkgrel
				echo "SVN ver is $archver"
			fi
		fi
		cd ..
	done
	cd ..
done
cd $startdir
