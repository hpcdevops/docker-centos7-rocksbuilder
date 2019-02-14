--- /opt/rocks/share/devel/src/roll/etc/bootstrap-functions.sh	2017-12-02 01:31:46.000000000 +0000
+++ /opt/rocks/share/devel/src/roll/etc/bootstrap-functions.sh	2019-02-13 23:28:43.111748573 +0000
@@ -145,14 +145,14 @@

 function install_linux_oldstyle() {
 	find /usr/src/redhat/RPMS -name "$1-[0-9]*.*.rpm" \
-		-exec rpm -Uhv --force --nodeps {} \;
+		-exec sudo rpm -Uhv --force --nodeps {} \;
 	find RPMS -name "$1-[0-9]*.*.rpm" \
-		-exec rpm -Uhv --force --nodeps {} \;
+		-exec sudo rpm -Uhv --force --nodeps {} \;
 }

 function install_linux() {
 	gmake createlocalrepo
-	yum -y -c yum.conf install $1
+	sudo yum -y -c yum.conf install $1
 }

 function compile_linux() {
@@ -170,7 +170,7 @@
 	pkgs=`/opt/rocks/bin/rocks list node xml $1 basedir=$PWD | \
 		/opt/rocks/sbin/kgen --section packages | grep "^[a-zA-Z]"`
 	make createlocalrepo
-	yum -y -c yum.conf install $pkgs
+	sudo yum -y -c yum.conf install $pkgs
 }

 ## Use a rocks-created repo to install
