#!/bin/sh
#
# Short build script.

local_version=2.8-ox5.3
local_sakai=2.8.x

git submodule init
git submodule sync
git submodule update

MAVEN_OPTS="-Xms168m -Xmx512m -XX:PermSize=128m -XX:NewSize=64m -Dmaven.test.skip=true"

export MAVEN_OPTS

rm -rf build
(cd indie/kernel; mvn clean install -Dmaven.test.skip=true)
mvn clean install sakai:deploy -Pfull,oxford -Dlocal.service=$local_version -Dlocal.sakai=$local_sakai -Dmaven.tomcat.home=$(pwd)/build/ || exit 1
(cd build && tar zcf ../sakai-${local_version}.tgz .)
