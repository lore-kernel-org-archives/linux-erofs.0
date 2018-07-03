From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 4 Jul 2018 00:12:51 +0800
Subject: [WIP] [NOMERGE] [RFC PATCH v0.4 0/7] erofs: introduce the new unzip
 subsystem
In-Reply-To: <1530109204-7321-1-git-send-email-gaoxiang25@huawei.com>
References: <1530109204-7321-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1530634378-37220-1-git-send-email-gaoxiang25@huawei.com>

change log v0.4:
 - bugfix (runable now for small files)
 - separate into one more patch
[RESEND]
 - fix according to:
   Link: https://lists.01.org/pipermail/kbuild-all/2018-July/049774.html
 - fix compiling warning:
   Link: https://lists.01.org/pipermail/kbuild-all/2018-June/049647.html
 - rebase code

change log v0.3:
 - separate to several small patches, maybe more in the future patchset

change log v0.2:
 - use the recent introduced tagptr_t type to manage tagged pointers.
 - bugfix

Todo list:
 - spilt into more understandable patches
 - add missing functions and bugfix


The patchset is temporarily based on
Revert "erofs: introduce VLE decompression support (experimental)"

The new unzip system is still _buggy_, not for _daily_ use!


Gao Xiang (7):
  <linux/tagptr.h>: Introduce tagged pointer
  erofs: introduce pagevec for unzip subsystem
  erofs: add erofs_map_blocks_iter
  erofs: add erofs_allocpage
  erofs: globalize prepare_bio and __submit_bio
  erofs: add a generic z_erofs VLE decompressor
  erofs: introduce VLE decompression subsystem

 fs/erofs/Kconfig         |   23 +
 fs/erofs/Makefile        |    3 +-
 fs/erofs/data.c          |   41 +-
 fs/erofs/inode.c         |    6 +-
 fs/erofs/internal.h      |   77 +++
 fs/erofs/staging.h       |   42 ++
 fs/erofs/super.c         |   36 +-
 fs/erofs/unzip_pagevec.h |  172 +++++++
 fs/erofs/unzip_vle.c     | 1176 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/erofs/unzip_vle.h     |  236 ++++++++++
 fs/erofs/unzip_vle_lz4.c |  145 ++++++
 fs/erofs/utils.c         |   31 ++
 fs/file.c                |   24 +-
 include/linux/file.h     |   15 +-
 include/linux/tagptr.h   |  110 +++++
 15 files changed, 2084 insertions(+), 53 deletions(-)
 create mode 100644 fs/erofs/unzip_pagevec.h
 create mode 100644 fs/erofs/unzip_vle.c
 create mode 100644 fs/erofs/unzip_vle.h
 create mode 100644 fs/erofs/unzip_vle_lz4.c
 create mode 100644 fs/erofs/utils.c
 create mode 100644 include/linux/tagptr.h

-- 
1.9.1
