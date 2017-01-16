#!/bin/bash -e
. /etc/profile.d/modules.sh

module add deploy
cd $WORKSPACE/$NAME-$VERSION
make distclean
./configure --prefix=$SOFT_DIR
make -j2 install

mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
puts stderr " This module does nothing but alert the user"
puts stderr " that the [module-info name] module is not available"
}
module-whatis "$NAME $VERSION."
setenv JASPER_VERSION $VERSION
setenv JASPER_DIR $::env(CVMFS_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH $::env(JASPER_DIR)/lib
prepend-path CPATH $::env(JASPER_DIR)/include/
MODULE_FILE
) > modules/${VERSION}
mkdir -p ${LIBRARIES_MODULES}/${NAME}
cp modules/${VERSION} ${LIBRARIES_MODULES}/${NAME}
