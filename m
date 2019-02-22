From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 22 Feb 2019 23:46:30 +0800
Subject: [PATCH for-4.20 0/7] erofs fixes for linux-4.20.y
Message-ID: <20190222154637.22785-1-gaoxiang25@huawei.com>

This series backports bugfixes already merged in linux upstream
which we found these issues in our commercial products, which
are serious and should be fixed immediately.

Note that it also includes some xarray modification since
upcoming patches heavily needs it, which can reduce more
conflicts later.

All patches have been tested again as a whole.

Thanks,
Gao Xiang

Gao Xiang (7):
  staging: erofs: remove the redundant d_rehash() for the root dentry
  staging: erofs: atomic_cond_read_relaxed on ref-locked workgroup
  staging: erofs: fix `erofs_workgroup_{try_to_freeze, unfreeze}'
  staging: erofs: add a full barrier in erofs_workgroup_unfreeze
  staging: erofs: {dir,inode,super}.c: rectify BUG_ONs
  staging: erofs: unzip_{pagevec.h,vle.c}: rectify BUG_ONs
  staging: erofs: unzip_vle_lz4.c,utils.c: rectify BUG_ONs

 drivers/staging/erofs/dir.c           |  7 +++-
 drivers/staging/erofs/inode.c         | 10 ++++-
 drivers/staging/erofs/internal.h      | 70 ++++++++++++++++++++++-------------
 drivers/staging/erofs/super.c         | 19 +++-------
 drivers/staging/erofs/unzip_pagevec.h |  2 +-
 drivers/staging/erofs/unzip_vle.c     | 35 +++++++-----------
 drivers/staging/erofs/unzip_vle_lz4.c |  2 +-
 drivers/staging/erofs/utils.c         | 12 +++---
 8 files changed, 86 insertions(+), 71 deletions(-)

-- 
2.14.5
