#!/bin/sh

VERSION=1.0.2
DISTRO=utopic
PKG_VERSION=2ppa2

BUILD_DIR="build"
NAME="pithos"
SOURCE_URL_BASE="https://github.com/pithos/pithos/archive/"
DATE=`date -R`

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/$NAME-$VERSION/debian/

cd $BUILD_DIR
wget "${SOURCE_URL_BASE}${VERSION}.tar.gz"
tar -xf ${VERSION}.tar.gz
mv ${VERSION}.tar.gz "${NAME}_${VERSION}.orig.tar.gz"
cd $NAME-$VERSION
cp -r ../../debian/* debian/

pwd
ls debian/changelog.in

sed -i \
    -e "s/@VERSION@/"${VERSION}"/g" \
    -e "s/@DISTRO@/"${DISTRO}"/g" \
    -e "s/@PKG_VERSION@/${PKG_VERSION}/g" \
    -e "s/@DATE@/${DATE}/g" \
    debian/changelog.in
mv debian/changelog.in debian/changelog

debuild -S -sa
cd ..

echo "run: cd build; dput -f ppa:gsheremeta/pithos-staging ${NAME}_${VERSION}_source.changes"
