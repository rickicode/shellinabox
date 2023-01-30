#!/bin/sh
echo "\n================ ENVIROMENT ========================\n"
env

echo "\n================ openssl COMPILING =============\n"
mkdir ./openssl
tar -xzvf ./openssl-1.0.2q.tar.gz -C ./openssl
platform=
if [ ! -z $(echo "$ENV_HOST" | grep "mips") ]; then
  platform="linux-mips32"
fi
if [ ! -z $(echo "$ENV_HOST" | grep "arm") ]; then
  platform="linux-armv4"
fi
if [ ! -z $(echo "$ENV_HOST" | grep "x86_64") ]; then
  platform="linux-x86_64"
fi
cd ./openssl && ./Configure $platform && make
ls -lt *.a
cp libssl.a ../
cp libcrypto.a ../
cd ..

echo "\n================ shellinabox COMPILING =============\n"
cp $QEMU_LD_PREFIX/usr/lib/libutil.a .
cp $QEMU_LD_PREFIX/usr/lib/libc.a .
cp $QEMU_LD_PREFIX/usr/lib/libdl.a .
cp $QEMU_LD_PREFIX/usr/lib/libpthread.a .
autoreconf -i && 
#./configure --enable-static=yes --enable-shared=no CFLAGS="-Wall -W -O2" LDFLAGS="-static -static-libgcc -L. -lutil -lssl -lcrypto -ldl -lc" --with-gnu-ld --host=$ENV_HOST && 
./configure --enable-static CFLAGS="-Wall -W -O2" CPPFLAGS="-I./openssl/include" LDFLAGS="-static -static-libgcc -L." LIBS="-lssl -lcrypto -lpthread -ldl -lutil -lc" --with-gnu-ld --host=$ENV_HOST &&
make
ls -lt shellinaboxd

echo "\n================ shellinabox BINARY STRIPPED =============\n"
/usr/xcc/$ENV_HOST/bin/$ENV_HOST-strip ./shellinaboxd
ls -lt shellinaboxd

echo "\n================ Release =============================\n"
mkdir ./$ENV_HOST
cp ./shellinaboxd ./$ENV_HOST/
ls -lt ./$ENV_HOST/
