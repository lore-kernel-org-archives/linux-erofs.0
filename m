From: chao@kernel.org (Chao Yu)
Date: Sun, 12 Aug 2018 22:01:42 +0800
Subject: [PATCH 0/8] staging: erofs: fix some issues and clean up codes
Message-ID: <20180812140150.13397-1-chao@kernel.org>

From: Chao Yu <yuchao0@huawei.com>

This patchset mainly adds error handing code for erofs xattr subsystem.
In addition, some code cleanups are also included in this patchset.

P.S. Some other patches are still previewing in the linux-erofs mailing
list, which will be posted in the 2nd part later.

Gao Xiang (8):
  staging: erofs: introduce erofs_grab_bio
  staging: erofs: separate erofs_get_meta_page
  staging: erofs: add error handling for xattr submodule
  staging: erofs: cleanup z_erofs_vle_work_{lookup, register}
  staging: erofs: rearrange vle clustertype definitions
  staging: erofs: fix vle_decompressed_index_clusterofs
  staging: erofs: fix integer overflow on 32-bit platform
  staging: erofs: fix compression mapping beyond EOF

 drivers/staging/erofs/Kconfig     |   9 ++
 drivers/staging/erofs/data.c      |  62 +++++++++----
 drivers/staging/erofs/erofs_fs.h  |  11 +++
 drivers/staging/erofs/internal.h  |  64 ++++++++-----
 drivers/staging/erofs/unzip_vle.c | 149 +++++++++++++++---------------
 drivers/staging/erofs/xattr.c     | 125 +++++++++++++++++--------
 6 files changed, 266 insertions(+), 154 deletions(-)

-- 
2.18.0
