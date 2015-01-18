FROM ubuntu:12.04
ENV WORKSPACE /build

RUN apt-get update && apt-get install -y build-essential libncurses5-dev u-boot-tools qemu-user-static debootstrap git binfmt-support libusb-1.0-0-dev pkg-config
RUN apt-get update && apt-get install -y gcc-arm-linux-gnueabihf && ldconfig

RUN mkdir $WORKSPACE && cd /build && git clone https://github.com/bananapi-dev/sunxi-bsp
RUN cd /build/sunxi-bsp && /bin/bash bpi_env.sh
RUN cd /build/sunxi-bsp && make
RUN cd /build/sunxi-bsp && make update
RUN cd /build/sunxi-bsp && make clean

RUN cd /build/sunxi-bsp && ./configure Bananapi
RUN cd /build/sunxi-bsp && make
RUN cd /build/sunxi-bsp && make update


RUN cd /build && wget https://releases.linaro.org/12.11/ubuntu/precise-images/ubuntu-desktop/linaro-precise-ubuntu-desktop-20121124-560.tar.gz
RUN cd /build && mkdir ROOTFS_DIR && tar --strip-components=3 -pzxvf linaro-precise-ubuntu-desktop-20121124-560.tar.gz -C ROOTFS_DIR
RUN cp /build/sunxi-bsp/build/Bananapi_hwpack/kernel/script.bin /build/ROOTFS_DIR/boot \
 && cp /build/sunxi-bsp/build/Bananapi_hwpack/kernel/uImage /build/ROOTFS_DIR/boot
ADD uEnv.txt /build/uEnv.txt
RUN cat /build/uEnv.txt >> /build/ROOTFS_DIR/boot/uEnv.txt
RUN cp -r /build/sunxi-bsp/build/Bananapi_hwpack/rootfs/* /build/ROOTFS_DIR

ADD interfaces /build/interfaces
RUN cat /build/interfaces >> /build/ROOTFS_DIR/etc/network/interfaces

ADD NetworkManager.conf /build/NetworkManager.conf
RUN cat /build/NetworkManager.conf >> /build/ROOTFS_DIR/etc/NetworkManager/NetworkManager.conf
