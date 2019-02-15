FROM centos:7

LABEL \
	org.label-schema.name="docker-centos7-rocksbuilder" \
	org.label-schema.url="https://github.com/hpcdevops/docker-centos7-rocksbuilder" \
	org.label-schema.vcs-url="https://github.com/hpcdevops/docker-centos7-rocksbuilder.git"

COPY . /

RUN \
	curl -LOR https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
	rpm -ivh epel-release-latest-7.noarch.rpm && \
	yum makecache fast && \
	yum -y update && \
	yum -y install \
	alsa-lib-devel anaconda apr apr-devel apr-util-devel atk-devel \
	audit-libs-devel autoconf autofs automake binutils-devel bison byacc \
	bzip2-devel cairo-devel cairo-gobject cairo-gobject-devel cdrecord cmake \
	compat-libf2c-34 compat-libstdc++-33.i686 cpupowerutils createrepo cups-libs \
	curl-devel cvs Cython dbus-devel device-mapper-devel dhclient dialog \
	docbook-dtds docbook-style-dsssl docbook-style-xsl docbook-utils \
	docbook-utils-pdf dstat e2fsprogs-devel eject elfutils-devel \
	elfutils-libelf-devel elinks environment-modules expat-devel expect \
	fftw-devel fftw-devel.i686 flex fontconfig-devel fontconfig.i686 freeglut \
	freeglut-devel freetype-devel freetype.i686 freetype.x86_64 gcc-c++ \
	gcc-gfortran gdk-pixbuf2-devel ghostscript ghostscript-fonts glib2-devel \
	glib2.i686 glibc-devel.i686 glibc.i686 glibc-static glibc-static.i686 grub2 \
	grub2-efi grub2-tools gtk2 gtk2-devel gtk3 gtk3-devel httpd-devel hwloc \
	hwloc-devel ImageMagick ImageMagick-devel imake intltool iptables-services \
	iscsi-initiator-utils iscsi-initiator-utils-devel isomd5sum-devel jadetex \
	java-1.8.0-openjdk java-1.8.0-openjdk-devel kernel-devel kernel-doc ladspa \
	ladspa-devel libaio-devel libarchive-devel libblkid-devel libcurl-devel \
	libgcc.i686 libgfortran libglade2-devel libICE-devel libIDL libIDL-devel \
	libjpeg-turbo libjpeg-turbo-devel libnl-devel libobjc libotf libpcap \
	libpng-devel libSM-devel libSM.i686 libstdc++-devel libstdc++-devel.i686 \
	libstdc++-devel.x86_64 libstdc++.i686 libstdc++-static.i686 libstdc++.x86_64 \
	libtool libtool-ltdl libtool-ltdl-devel libXaw libXaw-devel \
	libXcomposite-devel libXext-devel libXext.i686 libXi.i686 libxml2-devel \
	libxml2-devel.x86_64 libxml2.x86_64 libXmu libXmu-devel libXmu.i686 libXpm \
	libXpm-devel libxslt-devel libXt-devel libXxf86misc-devel libzip.i686 lsof \
	lsscsi mariadb mariadb-devel mercurial mesa-libGL.i686 mesa-libGL.x86_64 \
	mkisofs MySQL-python ncurses-devel ncurses-term netpbm netpbm-progs net-snmp \
	net-snmp-utils net-tools NetworkManager-devel NetworkManager-glib-devel \
	newt-devel nfs-utils nspr-devel nspr ntp numactl numactl-devel OpenIPMI \
	OpenIPMI-devel OpenIPMI-libs OpenIPMI-perl OpenIPMI-python OpenIPMI-tools \
	openjade openmotif openmotif-devel opensp openssh-askpass openssh-server \
	p7zip p7zip-plugins p7zip-doc \
	pam-devel pango-devel pciutils-devel perf perl-CPAN perl-CPANPLUS \
	perl-Data-Dumper perl-DBI perl-ExtUtils-ParseXS perl-GD perl-SGMLSpm \
	perl-Test-Simple perl-version perl-YAML php-mysql portmap postfix protobuf \
	pycairo-devel pygobject2 pygobject2-devel pykickstart python-devel \
	python-setuptools qt-devel rcs rdate readline-devel redhat-lsb rpm-build rpm-devel \
	ruby rubygems ruby-libs screen sharutils slang-devel snappy-devel \
	sqlite-devel squashfs-tools strace subversion subversion-perl sudo swig syslinux \
	syslinux-perl sysstat tcl tcl-devel tclx tcpdump tcp_wrappers-devel tcsh \
	telnet tex texlive texlive-ec tk-devel urw-fonts usermode wget wodim \
	xfsprogs xmlto xorg-x11-server-Xvfb xorg-x11-util-macros xorg-x11-xauth \
	zlib.i686 && \
	yum -y clean all && \
	rm -rf /var/cache/yum

RUN \
	yum makecache fast && \
	yum -y install \
		foundation-ant foundation-ant foundation-coreutils foundation-gawk \
		foundation-gawk foundation-git foundation-graphviz foundation-libxml2 \
		foundation-mysql foundation-mysql foundation-python \
		foundation-python-extras foundation-python-setuptools foundation-python-xml \
		foundation-rcs foundation-redhat foundation-tidy foundation-wget serf \
		tentakel librocks && \
	yum -y clean all && \
	rm -rf /var/cache/yum

RUN \
	yum makecache fast && \
	yum -y install \
		rocks-411 rocks-411-alert rocks-admin rocks-admin rocks-bittorrent \
		rocks-channel rocks-channel rocks-config rocks-devel rocks-devel rocks-gen \
		rocks-gen rocks-profile rocks-pylib rocks-rc-systemd rocks-restore-roll \
		rocks-sec-channel-client rocks-snmp-status rocks-sql rocks-ssl rocks-upstart \
	    && yum -y clean all \
	    && rm -rf /var/cache/yum

RUN \
	groupadd -g 500 rocksbuilder && \
	useradd -d /home/rocksbuilder -g rocksbuilder -u 500 rocksbuilder

RUN \
	patch --backup \
		/etc/sudoers \
		/opt/rocks/patches/etc-sudoers.patch && \
	patch --backup \
		/opt/rocks/share/devel/etc/Rules.mk \
		/opt/rocks/patches/opt-rocks-share-devel-etc-Rules.mk.patch && \
	patch --backup \
	  /opt/rocks/share/devel/src/roll/etc/bootstrap-functions.sh \
		/opt/rocks/patches/opt-rocks-share-devel-src-roll-etc-bootstrap-functions.sh.patch && \
	patch --backup \
		/opt/rocks/lib/python2.7/site-packages/rocks/commands/create/mirror/__init__.py \
		/opt/rocks/patches/rocks-commands-create-mirror.patch && \
	patch --backup \
		/opt/rocks/lib/python2.7/site-packages/rocks/commands/create/roll/__init__.py \
		/opt/rocks/patches/rocks-commands-create-roll.patch

HEALTHCHECK CMD exit 0

WORKDIR /export/rocks/src/roll

USER rocksbuilder

CMD ["/bin/bash"]
