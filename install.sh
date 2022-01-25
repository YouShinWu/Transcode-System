#!/bin/bash
echo "cd /nv-codec-headers"
cd /nv-codec-headers
echo "make"
make
echo "make install"
make install

echo "cd /ffmpeg"
cd /ffmpeg/
echo "./config"
./configure --prefix=/usr/local/ --enable-gpl --enable-libx264 --enable-libx265 --enable-libvpx --enable-libfdk-aac --enable-nonfree --enable-libmp3lame --enable-shared --enable-pthreads --enable-pic --enable-openssl --enable-shared --enable-static --enable-cuvid
echo "make"
make
echo "make install"
make install
