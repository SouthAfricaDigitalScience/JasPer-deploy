#!/bin/bash -e
# Copyright 2016 C.S.I.R. Meraka Institute
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

. /etc/profile.d/modules.sh

module add deploy
module add  jpeg
cd ${WORKSPACE}/${NAME}-version-${VERSION}/build-${BUILD_NUMBER}
rm -rf *
cmake -G "Unix Makefiles" \
-H${WORKSPACE}/${NAME}-version-${VERSION} \
-B${PWD} \
-DCMAKE_INSTALL_PREFIX=${SOFT_DIR} \
-DJAS_ENABLE_LIBJPEG=true \
-DJAS_ENABLE_SHARED=true \
-DJAS_ENABLE_OPENGL=false \
-DJPEG_LIBRARY=${JPEG_DIR}/lib/libjpeg.so \
-DJPEG_INCLUDE_DIR=${JPEG_DIR}/include
make
make install
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
setenv JASPER_DIR                         $::env(CVMFS_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH $::env(JASPER_DIR)/lib
prepend-path CPATH                       $::env(JASPER_DIR)/include/
MODULE_FILE
) > modules/${VERSION}
mkdir -p ${LIBRARIES}/${NAME}
cp modules/${VERSION} ${LIBRARIES}/${NAME}

module  avail ${NAME}
module add ${NAME}/${VERSION}
