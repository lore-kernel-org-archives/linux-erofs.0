From: hsiangkao@aol.com (Gao Xiang)
Date: Fri, 31 May 2019 08:50:34 +0800
Subject: [PATCH 00/13] erofs_utils: new mkfs framework
Message-ID: <20190531005047.22093-1-hsiangkao@aol.com>

Hi all,
I spent nearly a month to make big changes to erofs-mkfs,
which mainly introduces a new mkfs framework.

I personally think it is much cleaner and more scalable than
the old one, which is hack and not clean enough.

In-place compression is still work-in-progress, thus it isn't
included in this series.

Comments are welcome!

Thanks,
Gao Xiang

Gao Xiang (8):
  erofs-utils: introduce buffer cache
  erofs-utils: introduce inode operations
  erofs-utils: introduce generic compression framework
  erofs-utils: introduce lz4/lz4hc compression algorithm
  erofs-utils: introduce compression for regular files
  erofs-utils: propagate compressed size to its callers
  erofs-utils: add a README
  erofs-utils: fix potential erofs_bh_balloon failure

Li Guifu (5):
  erofs-utils: add erofs on-disk layout
  erofs-utils: introduce erofs-utils basic headers
  erofs-utils: introduce miscellaneous files
  erofs-utils: add input/output functions
  erofs-utils: introduce mkfs support

-- 
2.17.1
