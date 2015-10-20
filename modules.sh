#!/bin/bash
source /usr/share/modules/init/bash
module add ci

cd ${WORKSPACE}/${NAME}-${VERSION}
echo "Making the ${NAME} modulefile
mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}

module-whatis   "$NAME $VERSION."
setenv       HDF5_VERSION       $VERSION
setenv       JASPER_DIR           /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/${NAME}/${VERSION}
prepend-path LD_LIBRARY_PATH   $::env(JASPER_DIR)/lib
prepend-path HDF5_INCLUDE_DIR   $::env(JASPER_DIR)/include
prepend-path CPATH             $::env(JASPER_DIR)/include
MODULE_FILE
) > modules/${VERSION}

mkdir -p ${LIBRARIES_MODULES}/${NAME}
cp modules/${VERSION} ${LIBRARIES_MODULES}/${NAME}

module avail

module add ${NAME}/${VERSION}
