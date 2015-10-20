#!/bin/bash
source /usr/share/modules/init/bash
module load ci
echo ""
cd ${WORKSPACE}/${NAME}-${VERSION}
echo " this is just a check to trigger the first build."
echo $?
make check
make install
