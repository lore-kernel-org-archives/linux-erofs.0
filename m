From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 20 Feb 2019 17:18:42 +0800
Subject: [PATCH for-4.19 00/12] erofs fixes for linux-4.19.y
Message-ID: <20190220091854.19242-1-gaoxiang25@huawei.com>

This series backports bugfixes already merged in linux upstream
which we found these issues in our commerical products, which
are serious and should be fixed immediately.

Note that it also includes some xarray modification since
upcoming patches heavily needs it, which can reduce more
conflicts later.

All patches have been tested again as a whole.

Thanks,
Gao Xiang

Chen Gong (1):
  staging: erofs: replace BUG_ON with DBG_BUGON in data.c

Gao Xiang (11):
  staging: erofs: fix a bug when appling cache strategy
  staging: erofs: complete error handing of z_erofs_do_read_page
  staging: erofs: drop multiref support temporarily
  staging: erofs: remove the redundant d_rehash() for the root dentry
  staging: erofs: fix race when the managed cache is enabled
  staging: erofs: atomic_cond_read_relaxed on ref-locked workgroup
  staging: erofs: fix `erofs_workgroup_{try_to_freeze, unfreeze}'
  staging: erofs: add a full barrier in erofs_workgroup_unfreeze
  staging: erofs: {dir,inode,super}.c: rectify BUG_ONs
  staging: erofs: unzip_{pagevec.h,vle.c}: rectify BUG_ONs
  staging: erofs: unzip_vle_lz4.c,utils.c: rectify BUG_ONs

 drivers/staging/erofs/data.c          |  31 ++++---
 drivers/staging/erofs/dir.c           |   7 +-
 drivers/staging/erofs/inode.c         |  10 ++-
 drivers/staging/erofs/internal.h      |  71 ++++++++++------
 drivers/staging/erofs/super.c         |  19 ++---
 drivers/staging/erofs/unzip_pagevec.h |   2 +-
 drivers/staging/erofs/unzip_vle.c     |  97 ++++++++--------------
 drivers/staging/erofs/unzip_vle.h     |  12 +--
 drivers/staging/erofs/unzip_vle_lz4.c |   2 +-
 drivers/staging/erofs/utils.c         | 150 +++++++++++++++++++++++-----------
 include/linux/xarray.h                |  48 +++++++++++
 11 files changed, 271 insertions(+), 178 deletions(-)

-- 
2.14.4
