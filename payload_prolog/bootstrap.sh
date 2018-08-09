#!/bin/sh
# version 2.0

yum -y install gcc glibc.i686 gcc-c++ 


WORK_DIR=`pwd`

PROLOG_PACKAGE_NAME=$(sed 's/PROLOG_PACKAGE_NAME=//' $WORK_DIR/package_metadata.txt)
mv $WORK_DIR/$PROLOG_PACKAGE_NAME /opt
cd /opt

mkdir gprolog_dist
tar -zxvf $PROLOG_PACKAGE_NAME -C ./gprolog_dist

cd ./gprolog_dist/gprolog-*/src
./configure --with-install-dir=/opt
make
make install

cd $WORK_DIR
