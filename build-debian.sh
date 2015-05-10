#!/bin/bash


BUILD_DIR="build"
NAME="pithos"
VERSION=1.1.0


rm -rf $BUILD_DIR
rm -rf pithos.egg-info

python3 setup.py egg_info

mkdir -p $BUILD_DIR/$NAME-$VERSION/data/pithos.egg-info
cp data/$NAME.desktop $BUILD_DIR/$NAME-$VERSION/data
cp data/$NAME $BUILD_DIR/$NAME-$VERSION/data
cp -r pithos.egg-info/* $BUILD_DIR/$NAME-$VERSION/data/pithos.egg-info

mkdir -p $BUILD_DIR/$NAME-$VERSION/pithos
cp -r pithos/* $BUILD_DIR/$NAME-$VERSION/pithos
find $BUILD_DIR/$NAME-$VERSION/pithos -name __pycache__ -exec rm -rf {} \;
find $BUILD_DIR/$NAME-$VERSION/pithos -name *.pyc -exec rm -rf {} \;

mkdir -p $BUILD_DIR/$NAME-$VERSION/data/icons/hicolor/scalable
mkdir -p $BUILD_DIR/$NAME-$VERSION/data/icons/hicolor/48
cp data/icons/hicolor/pithos.svg $BUILD_DIR/$NAME-$VERSION/data/icons/hicolor/scalable
cp data/icons/hicolor/pithos-tray-icon.png $BUILD_DIR/$NAME-$VERSION/data/icons/hicolor/48

mkdir -p $BUILD_DIR/$NAME-$VERSION/data/icons/ubuntu-mono-dark
cp data/icons/ubuntu-mono-dark/*.svg $BUILD_DIR/$NAME-$VERSION/data/icons/ubuntu-mono-dark

mkdir -p $BUILD_DIR/$NAME-$VERSION/data/icons/ubuntu-mono-light
cp data/icons/ubuntu-mono-light/*.svg $BUILD_DIR/$NAME-$VERSION/data/icons/ubuntu-mono-light

cd $BUILD_DIR
tar -czf "${NAME}_${VERSION}.orig.tar.gz" $NAME-$VERSION
cd ..

mkdir -p $BUILD_DIR/$NAME-$VERSION/debian
cp -r debian/* $BUILD_DIR/$NAME-$VERSION/debian

cd $BUILD_DIR/$NAME-$VERSION
debuild -S -sa
cd ..
rm -rf $NAME-$VERSION

echo "if build successful, run from the build directory: dput -f ppa:gsheremeta/pithos-staging ${NAME}_${VERSION}_source.changes"
