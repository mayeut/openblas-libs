# Build gfortran binary against OpenBLAS

set -e

rm -rf for_test
mkdir for_test
cd for_test

repo_path=$(cygpath "$START_DIR")
OBP=$(cygpath $OPENBLAS_ROOT\\$BUILD_BITS)

static_libname=$(find $OBP/lib -maxdepth 1 -type f -name '*.a' \! -name '*.dll.a' | tail -1)
dynamic_libname=$(find $OBP/lib -maxdepth 1 -type f -name '*.dll.a' | tail -1)
dll_name=$(echo $dynamic_libname | sed 's#/lib/#/bin/#' | sed 's/.a$//')

cp $dll_name .

if [ "$INTERFACE64" == "1" ]; then
  gfortran -I $OBP/include -fdefault-integer-8 -o test.exe ${repo_path}/test64_.f90 $static_libname
  gfortran -I $OBP/include -fdefault-integer-8 -o test_dyn.exe ${repo_path}/test64_.f90 $dynamic_libname
else
  gfortran -I $OBP/include -o test.exe ${repo_path}/test.f90 $static_libname
  gfortran -I $OBP/include -o test_dyn.exe ${repo_path}/test.f90 $dynamic_libname
fi
