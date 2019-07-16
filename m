From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 16 Jul 2019 15:04:02 +0800
Subject: [PATCH v2 00/17] erofs-utils: new mkfs framework
Message-ID: <20190716070419.30203-1-gaoxiang25@huawei.com>

This is patchset v2 of new mkfs framework, decompression
inplace and compacted indexes supports are added in this
version.

The latest code can be gotten at

git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git -b dev

as well. The 1st release will be finalized after kernel
implementation has been reviewed.

Comments are welcome. :)


Thanks,
Gao Xiang


Gao Xiang (12):
  erofs-utils: introduce buffer cache
  erofs-utils: introduce inode operations
  erofs-utils: introduce generic compression framework
  erofs-utils: introduce lz4/lz4hc compression algorithm
  erofs-utils: introduce compression for regular files
  erofs-utils: propagate compressed size to its callers
  erofs-utils: add README
  erofs-utils: introduce dev_fillzero
  erofs-utils: non-inline tail-end block should be zeroed beyond EOF
  erofs-utils: introduce compacted compression indexes
  erofs-utils: support decompress in-place
  erofs-utils: introduce extented options setting

Li Guifu (5):
  erofs-utils: add erofs on-disk layout
  erofs-utils: introduce erofs-utils basic headers
  erofs-utils: introduce miscellaneous files
  erofs-utils: add input/output functions
  erofs-utils: introduce mkfs support

-- 
2.17.1
