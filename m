From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 17 Jul 2018 22:18:46 +0800
Subject: [RFC PATCH v1 00/11] erofs: introduce the new unzip subsystem
In-Reply-To: <1530109204-7321-1-git-send-email-gaoxiang25@huawei.com>
References: <1530109204-7321-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1531837137-129079-1-git-send-email-gaoxiang25@huawei.com>

TODO List:
 - further minor cleanup
 - bugfix
 - will be stable this week

change log v1:
 - introduce cached decompression in order to boost random read
 - several bugfix
 *******************************************************************
 * In this version, we have an amazing seq & rand read performance *
 *******************************************************************
change log v0.7:
 - several bugfix ( buffer overflow, shrinker, ownership, etc... )
 - all features available
 - it works now, and need do more for the random read compared
   with the old decompression version.

change log v0.6:
 - preliminary works (could boot into launcher)
 - still have minor buges to fix

change log v0.5:
 - add reclaim path
 - almost work, still debugging

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


Gao Xiang (11):
  <linux/tagptr.h>: Introduce tagged pointer
  erofs: introduce pagevec for unzip subsystem
  erofs: add erofs_map_blocks_iter
  erofs: add erofs_allocpage
  erofs: globalize prepare_bio and __submit_bio
  erofs: add a generic z_erofs VLE decompressor
  erofs: introduce superblock registration
  erofs: introduce erofs shrinker
  erofs: introduce workstation for decompression
  erofs: introduce VLE decompression support
  erofs: introduce cached decompression

 fs/erofs/Kconfig         |   62 ++
 fs/erofs/Makefile        |    3 +-
 fs/erofs/data.c          |   41 +-
 fs/erofs/inode.c         |    6 +-
 fs/erofs/internal.h      |  200 ++++++
 fs/erofs/staging.h       |   50 ++
 fs/erofs/super.c         |  132 +++-
 fs/erofs/unzip_pagevec.h |  172 +++++
 fs/erofs/unzip_vle.c     | 1572 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/erofs/unzip_vle.h     |  219 +++++++
 fs/erofs/unzip_vle_lz4.c |  209 ++++++
 fs/erofs/utils.c         |  270 ++++++++
 fs/file.c                |   24 +-
 include/linux/file.h     |   15 +-
 include/linux/tagptr.h   |  110 ++++
 15 files changed, 3034 insertions(+), 51 deletions(-)
 create mode 100644 fs/erofs/unzip_pagevec.h
 create mode 100644 fs/erofs/unzip_vle.c
 create mode 100644 fs/erofs/unzip_vle.h
 create mode 100644 fs/erofs/unzip_vle_lz4.c
 create mode 100644 fs/erofs/utils.c
 create mode 100644 include/linux/tagptr.h

-- 
1.9.1
