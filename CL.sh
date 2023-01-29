#!/bin/sh
echo "\n================ ENVIROMENT ========================\n"
env

echo "\n================ openssl COMPILING =============\n"
mkdir ./openssl
tar -xzvf ./openssl-1.0.2q.tar.gz -C ./openssl
cd ./openssl && ./Configure linux-mips32 && make
ls -lt *.a

echo "\n================ shellinabox COMPILING =============\n"
cp $QEMU_LD_PREFIX/user/lib/libutil.a .
cp $QEMU_LD_PREFIX/user/lib/libc.a .
cp $QEMU_LD_PREFIX/user/lib/libdl.a .
./configure --enable-static=yes --enable-shared=no CFLAGS="-Wall -W -O2" LDFLAGS="-static -static-libgcc -L. -L./openssl -lutil -lssl -lcrypto -ldl -lc" --with-gnu-ld --host=$ENV_HOST && make

echo "\n================ shellinabox BINARY STRIPPED =============\n"
/usr/xcc/$ENV_HOST/bin/$ENV_HOST-strip ./shellinaboxd

echo "\n================ Release =============================\n"
mkdir ./$ENV_HOST
cp ./shellinaboxd ./$ENV_HOST/
ls -lt ./$ENV_HOST/
