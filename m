From: cgxu519@gmx.com (Chengguang Xu)
Date: Mon, 17 Sep 2018 23:34:20 +0800
Subject: [PATCH v2 0/6] staging: erofs: option validation for remount and some
 code cleanups
Message-ID: <20180917153426.16880-1-cgxu519@gmx.com>

This patch set mainly does option validation for remount and at
the same time does related code cleanups. Currently when we call
fault injection related code we have to surround it with macro
CONFIG_EROFS_FAULT_INJECTION in every calling place, after this
patch set we don't have to do that, so the code looks clean and
more understandable.

v1->v2:
Address Chao's comments:
- Allow to set fault_injection=0.
- Keep flag bit when setting fault_injection=0.
- Show injection info in original place.
- Rebase code on latest erofs branch in Chao's linux tree.
- Fix building issue.


Chengguang Xu (6):
  staging: erofs: code cleanup for erofs_kmalloc()
  staging: erofs: code cleanup for option parsing of fault_injection
  staging: erofs: introduce a new helper __erofs_build_fault_attr()
  staging: erofs: introduce a new helper erofs_get_fault_rate()
  staging: erofs: code cleanup for erofs_show_options()
  staging: erofs: option validation in remount

 drivers/staging/erofs/internal.h | 13 ++++--
 drivers/staging/erofs/super.c    | 73 +++++++++++++++++++++++++-------
 2 files changed, 67 insertions(+), 19 deletions(-)

-- 
2.17.1
