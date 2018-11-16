From: bluce.liguifu@huawei.com (bluce.liguifu@huawei.com)
Date: Fri, 16 Nov 2018 11:30:15 +0800
Subject: [PREVIEW] [RFC PATCH 0/5] erofs-mkfs: mkfs.erofs source code first
 preview
Message-ID: <20181116033020.20004-1-bluce.liguifu@huawei.com>

From: Li Guifu <bluce.liguifu@huawei.com>

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


Li Guifu (5):
  erofs-mkfs: add erofs on-disk layout
  erofs-mkfs: introduce mkfs basic framework
  erofs-mkfs: support to build a image from the specfic root directory
  erofs-mkfs: add compression support
  erofs-mkfs: add miscellaneous files

-- 
2.17.1
