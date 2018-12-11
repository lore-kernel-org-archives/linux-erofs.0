From: bluce.liguifu@huawei.com (Li Guifu)
Date: Tue, 11 Dec 2018 22:27:16 +0800
Subject: [PREVIEW] [PATCH 0/5] erofs-mkfs: mkfs.erofs source code preview
Message-ID: <20181211142721.24451-1-bluce.liguifu@huawei.com>

This patchset introduces the source code for mkfs.erofs. It can build
erofs image from scratch according to a specific directory.

Currently, it can build lz4 compressed images and uncompressed images.
Regular files, directories and special files are supported.
However it can only generate erofs inode v1 format due to our product
requirements, and inode v2 format support is still under development.

This is our first attempt to release this piece of code, which isn't
clean enough. It will be cleaned up with our community development.

Comments are welcome.

Thanks,
Li Guifu

change log from v2:
 - fix coding style reported by checkpatch.pl
 - fix memory that freed
 - replace return a negative value other than exit directly

change log from v1:
 - fix coding style reported by checkpatch.pl
 - fix image size overflow when it's bigger than 4GB


Li Guifu (5):
  erofs-mkfs: add erofs on-disk layout
  erofs-mkfs: introduce mkfs basic framework
  erofs-mkfs: support to build a image from the specific root directory
  erofs-mkfs: add compression support
  erofs-mkfs: add miscellaneous files

--
2.17.1
