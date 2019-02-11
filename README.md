# Rocks Builder for Rocks/CentOS 7

[![Docker Build Status](https://img.shields.io/docker/build/hpcdevops/docker-centos7-rocksbuilder.svg)](https://hub.docker.com/r/hpcdevops/docker-centos7-rocksbuilder/builds/)
[![Docker Automated build](https://img.shields.io/docker/automated/hpcdevops/docker-centos7-rocksbuilder.svg)](https://hub.docker.com/r/hpcdevops/docker-centos7-rocksbuilder/)
[![Docker Pulls](https://img.shields.io/docker/pulls/hpcdevops/docker-centos7-rocksbuilder.svg)](https://hub.docker.com/r/hpcdevops/docker-centos7-rocksbuilder/)


The Rocks Builder for Rocks/CentOS 7 is Docker container that encapsulates the 
capabilities of a [Rocks](https://rocksclusters.org/) development appliance of
Rocks 7.0 (Manzanita).

The container provides a base install of the required software and configuration
required to build Rocks application rolls for Rocks/CentOS 7.

It does not support building Rocks system rolls.

## Running Rocks Builder for Rocks/CentOS 7

The docker-centos7-rocksbuilder is packaged to be able to build Rocks 
application rolls primarily for the purpose of integration into a Continuous
Integration system like Travis/CI that is integrated with a version control
system like Github.

The default behavior of Rocks was modified slightly to allow building as
a non-root user using this container. As such, some Rocks application roll
build semantics (like BIND mounting the INSTALL dir) are not supported in
this version of the builder.

The easiest way to run the Rocks Builder for Rocks/CentOS 7 is by running
with our pre-built container as shown here...

	$ docker run --rm -it \
		-e "container=docker" \
		-h rocksbuilder \
		-v "$(pwd):/export/rocks/src/roll" \
		-v "/tmp:/tmp" \
		-w "/export/rocks/src/roll" \
		hpcdevops/docker-centos7-rocksbuilder:latest \
		bash -exc '\
			. $HOME/.bash_profile && \
			rollbuild_sequence.sh sdsc-roll' 2>&1 | \
		tee docker-centos7-rocksbuilder.sdsc-roll.build.log

...where `$(pwd)` is a directory containing the source of a Rocks
application roll such as that created by cloning an SDSC Rocks
Application roll like this...

	$ git clone --depth=50 https://github.com/sdsc/sdsc-roll.git
	Cloning into 'sdsc-roll'...
	remote: Enumerating objects: 480, done.
	remote: Counting objects: 100% (480/480), done.
	remote: Compressing objects: 100% (207/207), done.
	remote: Total 480 (delta 299), reused 432 (delta 266), pack-reused 0
	Receiving objects: 100% (480/480), 84.60 KiB | 0 bytes/s, done.
	Resolving deltas: 100% (299/299), done.

	$ chmod -R g+rwX,o+rwX ./sdsc-roll

The container will copy the roll source to /tmp, run the roll `bootstrap.sh`
if one exists, then `make` the default target in the top level `Makefile`.

The start and end of output of an example run is shown below...

	++ PATH=/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/rocks/bin:/opt/rocks/sbin:/home/rocksbuilder/bin
	++ export PATH
	+ rollbuild_sequence.sh sdsc-roll
	+ ROLL_TO_BUILD=sdsc-roll
	++ date
	+ echo '=-=-=- Build of sdsc-roll started at Sat Feb  9 01:36:42 UTC 2019 -=-=-='
	=-=-=- Build of sdsc-roll started at Sat Feb  9 01:36:42 UTC 2019 -=-=-=
	++ pwd
	+ mkdir -p /tmp//export/rocks/src/roll
	+ '[' -d sdsc-roll ']'
	+ tar -cf - ./sdsc-roll
	++ pwd
	+ cd /tmp//export/rocks/src/roll
	+ tar -xf -
	++ pwd
	+ cd /tmp//export/rocks/src/roll
	+ pushd sdsc-roll
	/tmp/export/rocks/src/roll/sdsc-roll /tmp/export/rocks/src/roll
	+ '[' -f ./bootstrap.sh ']'
	+ grep -q yum ./bootstrap.sh
	+ chmod +x ./bootstrap.sh
	+ ./bootstrap.sh
	
		...<snip>...
	
	env GNUPGHOME=/opt/rocks/share/devel/../.gnupg \
			Kickstart_Lang= \
			Kickstart_Langsupport= \
			rocks create roll roll-sdsc.xml
	sdsc-roll-test-1-4: 70d278eebac9af44c0ab7df9f62a4fa3
	sdsc-devel-3-12: 0305bce172ff00a36704ad2f480100f7
	roll-sdsc-kickstart-7.0-60.g8c1fc07: f5fb0793adb1100f4eabe0cea83cc05e
	sdsc-etc-profile-3-1: bff9c67ce1ede8317689bbdd7118c4fa
	Creating disk1 (0.04MB)...
	Building ISO image for disk1 ...
	++ find . -name '*.iso'
	+ for f in '$(find . -name "*.iso")'
	+ isoinfo -R -f -i ./sdsc-7.0-60.g8c1fc07.x86_64.disk1.iso
	/sdsc
	/TRANS.TBL
	/.discinfo
	/sdsc/7.0
	/sdsc/TRANS.TBL
	/sdsc/7.0/TRANS.TBL
	/sdsc/7.0/x86_64
	/sdsc/7.0/x86_64/RedHat
	/sdsc/7.0/x86_64/roll-sdsc.xml
	/sdsc/7.0/x86_64/SRPMS
	/sdsc/7.0/x86_64/TRANS.TBL
	/sdsc/7.0/x86_64/RedHat/RPMS
	/sdsc/7.0/x86_64/RedHat/TRANS.TBL
	/sdsc/7.0/x86_64/RedHat/RPMS/roll-sdsc-kickstart-7.0-60.g8c1fc07.noarch.rpm
	/sdsc/7.0/x86_64/RedHat/RPMS/sdsc-devel-3-12.x86_64.rpm
	/sdsc/7.0/x86_64/RedHat/RPMS/sdsc-etc-profile-3-1.x86_64.rpm
	/sdsc/7.0/x86_64/RedHat/RPMS/sdsc-roll-test-1-4.x86_64.rpm
	/sdsc/7.0/x86_64/RedHat/RPMS/TRANS.TBL
	+ popd
	/tmp/export/rocks/src/roll
	++ du -s --block-size=1k sdsc-roll
	++ awk '{printf "%'\''d KB\n", $1}'
	+ echo '=-=-=- Build of sdsc-roll required 1,860' 'KB -=-=-='
	=-=-=- Build of sdsc-roll required 1,860 KB -=-=-=
	+ pushd sdsc-roll
	/tmp/export/rocks/src/roll/sdsc-roll /tmp/export/rocks/src/roll
	++ find . -name '*.iso'
	+ for f in '$(find . -name "*.iso")'
	+ mv -v ./sdsc-7.0-60.g8c1fc07.x86_64.disk1.iso ../
	`./sdsc-7.0-60.g8c1fc07.x86_64.disk1.iso' -> `../sdsc-7.0-60.g8c1fc07.x86_64.disk1.iso'
	+ popd
	/tmp/export/rocks/src/roll
	+ rm -rf sdsc-roll
	++ date
	+ echo '=-=-=- Build of sdsc-roll finished at Sat Feb  9 01:36:58 UTC 2019 -=-=-='
	=-=-=- Build of sdsc-roll finished at Sat Feb  9 01:36:58 UTC 2019 -=-=-=

A summary of the build timing and space used on the build host can be extracted
from the output...

	$ egrep "^=-=-=- " docker-centos7-rocksbuilder.sdsc-roll.build.log
	=-=-=- Build of sdsc-roll started at Sat Feb  9 01:36:42 UTC 2019 -=-=-=
	=-=-=- Build of sdsc-roll required 1,860 KB -=-=-=
	=-=-=- Build of sdsc-roll finished at Sat Feb  9 01:36:58 UTC 2019 -=-=-=

And if run with the bind mounts suggested above the generated Rocks roll ISO
file can be found at the following location...

	$ ls -l /tmp/export/rocks/src/roll/sdsc-7.0-60.g8c1fc07.x86_64.disk1.iso
	-rw-rw-r-- 1 150500 150500 430080 Feb  8 17:36 /tmp/export/rocks/src/roll/sdsc-7.0-60.g8c1fc07.x86_64.disk1.iso


## Notes

> **Important Note**: This image is used for testing and development.  It is
> not suited for any production use.

