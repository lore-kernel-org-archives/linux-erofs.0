From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 14 Jan 2019 19:40:21 +0800
Subject: [PATCH 0/5] staging: erofs: document, bugfix and cleanups
Message-ID: <20190114114026.11728-1-gaoxiang25@huawei.com>

Hi,
This is the first EROFS patchset for this new round.

An initial document describing the details of EROFS is added in this
patchset and it was previewed in
https://lists.ozlabs.org/pipermail/linux-erofs/2019-January/001227.html

In addition, Li Guifu found an unexpected crash related to fast symlink
in our internal test, this patchset also addresses this issue:
https://lists.ozlabs.org/pipermail/linux-erofs/2019-January/001190.html

and the rest patches are all cleanups, nothing special.

Thanks,
Gao Xiang

Chao Yu (1):
  staging: erofs: clean up erofs_map_blocks_iter

Gao Xiang (4):
  staging: erofs: add document
  staging: erofs: fix fast symlink w/o xattr when fs xattr is on
  staging: erofs: remove unneeded inode_operations
  staging: erofs: move erofs_xattr_handlers to xattr.h

 .../erofs/Documentation/filesystems/erofs.txt      | 195 +++++++++++++++++++++
 drivers/staging/erofs/data.c                       |  31 +---
 drivers/staging/erofs/inode.c                      |  38 ++--
 drivers/staging/erofs/internal.h                   |  67 +++----
 drivers/staging/erofs/namei.c                      |   4 -
 drivers/staging/erofs/super.c                      |   1 +
 drivers/staging/erofs/unzip_vle.c                  |  30 ++--
 drivers/staging/erofs/xattr.c                      |  25 ++-
 drivers/staging/erofs/xattr.h                      |   4 +-
 9 files changed, 278 insertions(+), 117 deletions(-)
 create mode 100644 drivers/staging/erofs/Documentation/filesystems/erofs.txt

-- 
2.14.4
