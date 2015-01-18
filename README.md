Build a Banana Pi Image from Source
-----------------------------------


This is just a quick-and-dirty Dockerfile setup of the instructions here:
http://www.bananapi.org/p/blog-page_20.html

Build Instructions
------------------

   $ docker build -t bananapi/build .

This will build the docker and if all goes well leave you with a folder
inside the docker called `/build/ROOTFS_DIR` which you can then extract
from the container in a myriad of ways to follow step **8** of the guide
linked above:

```
8. Format the sdcard (assume the sdcard mounted at /dev/sdb) // Recommend to use 8G/Class 10 sdcard for better BPi experience
  $ sudo umount /dev/sdb1
  $ sudo dd if=/dev/zero of=/dev/sdb bs=1k count=1024
  $ sudo dd if=sunxi-bsp/build/Bananapi_hwpack/bootloader/u-boot-sunxi-with-spl.bin of=/dev/sdb bs=1024 seek=8
  $ sudo fdisk /dev/sdb
  Create a partition
  $ sudo mkfs.ext4 /dev/sdb1

9. Copy ROOTFS_DIR into sdcard
  $ mkdir mnt
  $ sudo mount /dev/sdb1 mnt
  $ sudo cp -a ROOTFS_DIR/* mnt
  $ sudo sync
```
