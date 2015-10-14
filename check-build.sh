module load ci
echo ""
cd $WORKSPACE/$NAME-$VERSION
echo " this is just a check to trigger the first build."
echo $?
make install
