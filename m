From: jgross@suse.com (Juergen Gross)
Date: Mon, 27 May 2019 12:32:04 +0200
Subject: [PATCH 0/3] remove tmem and code depending on it
Message-ID: <20190527103207.13287-1-jgross@suse.com>

Tmem has been an experimental Xen feature which has been dropped
recently due to security problems and lack of maintainership.

So it is time now to drop it in Linux kernel, too.

Juergen Gross (3):
  xen: remove tmem driver
  mm: remove cleancache.c
  mm: remove tmem specifics from frontswap

 Documentation/admin-guide/kernel-parameters.txt |  21 -
 Documentation/vm/cleancache.rst                 | 296 ------------
 Documentation/vm/frontswap.rst                  |  27 +-
 Documentation/vm/index.rst                      |   1 -
 MAINTAINERS                                     |   7 -
 drivers/staging/erofs/data.c                    |   6 -
 drivers/staging/erofs/internal.h                |   1 -
 drivers/xen/Kconfig                             |  23 -
 drivers/xen/Makefile                            |   2 -
 drivers/xen/tmem.c                              | 419 -----------------
 drivers/xen/xen-balloon.c                       |   2 -
 drivers/xen/xen-selfballoon.c                   | 579 ------------------------
 fs/block_dev.c                                  |   5 -
 fs/btrfs/extent_io.c                            |   9 -
 fs/btrfs/super.c                                |   2 -
 fs/ext4/readpage.c                              |   6 -
 fs/ext4/super.c                                 |   2 -
 fs/f2fs/data.c                                  |   3 +-
 fs/mpage.c                                      |   7 -
 fs/ocfs2/super.c                                |   2 -
 fs/super.c                                      |   3 -
 include/linux/cleancache.h                      | 124 -----
 include/linux/frontswap.h                       |   5 -
 include/linux/fs.h                              |   5 -
 include/xen/balloon.h                           |   8 -
 include/xen/tmem.h                              |  18 -
 mm/Kconfig                                      |  38 +-
 mm/Makefile                                     |   1 -
 mm/cleancache.c                                 | 317 -------------
 mm/filemap.c                                    |  11 -
 mm/frontswap.c                                  | 156 +------
 mm/truncate.c                                   |  15 +-
 32 files changed, 17 insertions(+), 2104 deletions(-)
 delete mode 100644 Documentation/vm/cleancache.rst
 delete mode 100644 drivers/xen/tmem.c
 delete mode 100644 drivers/xen/xen-selfballoon.c
 delete mode 100644 include/linux/cleancache.h
 delete mode 100644 include/xen/tmem.h
 delete mode 100644 mm/cleancache.c

-- 
2.16.4
