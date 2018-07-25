From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 25 Jul 2018 10:26:13 +0800
Subject: [RFC PATCH v2 00/25] staging: erofs: introduce erofs file system
In-Reply-To: <1532399805-65674-1-git-send-email-gaoxiang25@huawei.com>
References: <1532399805-65674-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1532485598-63393-1-git-send-email-gaoxiang25@huawei.com>

Change log from v1:
 o discard all LINUX_VERSION macros
 o minor cleanup
 o add a TODO file and update MAINTAINERS

This patchset includes the full code of EROFS file system.
It is nearly completed for linux-kernel staging upstream.


These commits have been merged as a part of larger patches:
 - erofs: fix unrecognized mount option message level
 - erofs: fix the potential integer overflow
 - erofs: fix match_table with a NULL terminated pattern
 - erofs: fix erofs_module_init & exit
 - erofs: introduce parse_options()
 - erofs: remove unused EROFS_XATTR_INDEX_ADVISE
 - erofs: fix to return correct value of alloc_inode
 - erofs: fix to do endian conversion correctly
 - erofs: fix missing endian conversion
 - erofs: fix to avoid potential overflow
 - erofs: fix compile error
 - erofs: add the missing header <linux/prefetch.h>
 - erofs: fix ifnullfree.cocci warnings


Short log
=========

Chao Yu (3):
  staging: erofs: support special inode
  staging: erofs: introduce error injection infrastructure
  staging: erofs: support tracepoint

Gao Xiang (22):
  staging: erofs: add on-disk layout
  staging: erofs: add erofs in-memory stuffs
  staging: erofs: add super block operations
  staging: erofs: add raw address_space operations
  staging: erofs: add inode operations
  staging: erofs: add directory operations
  staging: erofs: add namei functions
  staging: erofs: update Kconfig and Makefile
  staging: erofs: introduce xattr & acl support
  staging: erofs: <linux/tagptr.h>: introduce tagged pointer
  staging: erofs: introduce pagevec for unzip subsystem
  staging: erofs: add erofs_map_blocks_iter
  staging: erofs: add erofs_allocpage
  staging: erofs: globalize prepare_bio and __submit_bio
  staging: erofs: introduce a customized LZ4 decompression
  staging: erofs: add a generic z_erofs VLE decompressor
  staging: erofs: introduce superblock registration
  staging: erofs: introduce erofs shrinker
  staging: erofs: introduce workstation for decompression
  staging: erofs: introduce VLE decompression support
  staging: erofs: introduce cached decompression
  staging: erofs: add a TODO and update MAINTAINERS for staging

 MAINTAINERS                                        |    7 +
 drivers/staging/Kconfig                            |    2 +
 drivers/staging/Makefile                           |    1 +
 drivers/staging/erofs/Kconfig                      |  141 ++
 drivers/staging/erofs/Makefile                     |   13 +
 drivers/staging/erofs/TODO                         |   42 +
 drivers/staging/erofs/data.c                       |  385 +++++
 drivers/staging/erofs/dir.c                        |  145 ++
 drivers/staging/erofs/erofs_fs.h                   |  266 ++++
 drivers/staging/erofs/include/linux/tagptr.h       |  110 ++
 drivers/staging/erofs/include/trace/events/erofs.h |  240 +++
 drivers/staging/erofs/inode.c                      |  283 ++++
 drivers/staging/erofs/internal.h                   |  556 +++++++
 drivers/staging/erofs/lz4defs.h                    |  227 +++
 drivers/staging/erofs/namei.c                      |  251 +++
 drivers/staging/erofs/super.c                      |  649 ++++++++
 drivers/staging/erofs/unzip_lz4.c                  |  251 +++
 drivers/staging/erofs/unzip_pagevec.h              |  172 +++
 drivers/staging/erofs/unzip_vle.c                  | 1627 ++++++++++++++++++++
 drivers/staging/erofs/unzip_vle.h                  |  239 +++
 drivers/staging/erofs/unzip_vle_lz4.c              |  209 +++
 drivers/staging/erofs/utils.c                      |  270 ++++
 drivers/staging/erofs/xattr.c                      |  579 +++++++
 drivers/staging/erofs/xattr.h                      |   93 ++
 24 files changed, 6758 insertions(+)
 create mode 100644 drivers/staging/erofs/Kconfig
 create mode 100644 drivers/staging/erofs/Makefile
 create mode 100644 drivers/staging/erofs/TODO
 create mode 100644 drivers/staging/erofs/data.c
 create mode 100644 drivers/staging/erofs/dir.c
 create mode 100644 drivers/staging/erofs/erofs_fs.h
 create mode 100644 drivers/staging/erofs/include/linux/tagptr.h
 create mode 100644 drivers/staging/erofs/include/trace/events/erofs.h
 create mode 100644 drivers/staging/erofs/inode.c
 create mode 100644 drivers/staging/erofs/internal.h
 create mode 100644 drivers/staging/erofs/lz4defs.h
 create mode 100644 drivers/staging/erofs/namei.c
 create mode 100644 drivers/staging/erofs/super.c
 create mode 100644 drivers/staging/erofs/unzip_lz4.c
 create mode 100644 drivers/staging/erofs/unzip_pagevec.h
 create mode 100644 drivers/staging/erofs/unzip_vle.c
 create mode 100644 drivers/staging/erofs/unzip_vle.h
 create mode 100644 drivers/staging/erofs/unzip_vle_lz4.c
 create mode 100644 drivers/staging/erofs/utils.c
 create mode 100644 drivers/staging/erofs/xattr.c
 create mode 100644 drivers/staging/erofs/xattr.h

-- 
1.9.1
