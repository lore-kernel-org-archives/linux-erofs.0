From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 29 Jul 2019 14:51:37 +0800
Subject: [PATCH 00/22] staging: erofs: updates according to erofs-outofstaging
 v4
Message-ID: <20190729065159.62378-1-gaoxiang25@huawei.com>

This patchset includes all meaningful modifications till now according
to erofs-outofstaging v4:
https://lore.kernel.org/linux-fsdevel/20190725095658.155779-1-gaoxiang25 at huawei.com/

Some empty lines which were add or delete are not included in this
patchset, I will send erofs-outofstaging v5 later in order to keep
main code bit-for-bit identical with this staging patchset.

Thanks,
Gao Xiang

Gao Xiang (22):
  staging: erofs: update source file headers
  staging: erofs: rename source files for better understanding
  staging: erofs: fix dummy functions erofs_{get,list}xattr
  staging: erofs: keep up erofs_fs.h with erofs-outofstaging patchset
  staging: erofs: sunset erofs_workstn_{lock,unlock}
  staging: erofs: clean up internal.h
  staging: erofs: remove redundant #include "internal.h"
  staging: erofs: kill CONFIG_EROFS_FS_IO_MAX_RETRIES
  staging: erofs: clean up shrinker stuffs
  staging: erofs: kill sbi->dev_name
  staging: erofs: kill all failure handling in fill_super()
  staging: erofs: refine erofs_allocpage()
  staging: erofs: kill CONFIG_EROFS_FS_USE_VM_MAP_RAM
  staging: erofs: tidy up zpvec.h
  staging: erofs: remove redundant braces in inode.c
  staging: erofs: tidy up decompression frontend
  staging: erofs: remove clusterbits in sbi
  staging: erofs: turn cache strategies into mount options
  staging: erofs: tidy up utils.c
  staging: erofs: tidy up internal.h
  staging: erofs: update super.c
  staging: erofs: update Kconfig

 .../erofs/Documentation/filesystems/erofs.txt |   10 +
 drivers/staging/erofs/Kconfig                 |  111 +-
 drivers/staging/erofs/Makefile                |    4 +-
 drivers/staging/erofs/compress.h              |    2 +-
 drivers/staging/erofs/data.c                  |    8 +-
 drivers/staging/erofs/decompressor.c          |   44 +-
 drivers/staging/erofs/dir.c                   |    6 +-
 drivers/staging/erofs/erofs_fs.h              |   47 +-
 .../erofs/include/trace/events/erofs.h        |    2 +-
 drivers/staging/erofs/inode.c                 |   24 +-
 drivers/staging/erofs/internal.h              |  244 +--
 drivers/staging/erofs/namei.c                 |    7 +-
 drivers/staging/erofs/super.c                 |  268 ++-
 .../erofs/{include/linux => }/tagptr.h        |   12 +-
 drivers/staging/erofs/unzip_vle.c             | 1591 -----------------
 drivers/staging/erofs/utils.c                 |  112 +-
 drivers/staging/erofs/xattr.c                 |    6 +-
 drivers/staging/erofs/xattr.h                 |   22 +-
 drivers/staging/erofs/zdata.c                 | 1408 +++++++++++++++
 .../staging/erofs/{unzip_vle.h => zdata.h}    |  119 +-
 drivers/staging/erofs/zmap.c                  |    5 +-
 .../erofs/{unzip_pagevec.h => zpvec.h}        |   41 +-
 22 files changed, 1853 insertions(+), 2240 deletions(-)
 rename drivers/staging/erofs/{include/linux => }/tagptr.h (94%)
 delete mode 100644 drivers/staging/erofs/unzip_vle.c
 create mode 100644 drivers/staging/erofs/zdata.c
 rename drivers/staging/erofs/{unzip_vle.h => zdata.h} (56%)
 rename drivers/staging/erofs/{unzip_pagevec.h => zpvec.h} (78%)

-- 
2.17.1
