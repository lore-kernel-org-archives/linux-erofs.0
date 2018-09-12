From: cgxu519@gmx.com (Chengguang Xu)
Date: Wed, 12 Sep 2018 13:10:27 +0800
Subject: [PATCH 0/7] staging: erofs: option validation for remount and some
 code cleanups
Message-ID: <20180912051034.3463-1-cgxu519@gmx.com>

This patch set mainly does option validation for remount and at
the same time does related code cleanups. Currently when we call
fault injection related code we have to surround it with macro
CONFIG_EROFS_FAULT_INJECTION in every calling place, after this
patch set we don't have to that, so the code looks clean and more
understandable.


Chengguang Xu (7):
  staging: erofs: code cleanup for erofs_kmalloc()
  staging: erofs: code cleanup for option parsing of fault_injection
  staging: erofs: introduce a new helper __erofs_build_fault_attr()
  staging: erofs: return -EINVAL when specifying fault rate to 0
  staging: erofs: introduce a new helper erofs_get_fault_rate()
  staging: erofs: code cleanup for erofs_show_options()
  staging: erofs: option validation in remount

 drivers/staging/erofs/internal.h | 16 ++++---
 drivers/staging/erofs/super.c    | 74 +++++++++++++++++++++++++-------
 2 files changed, 69 insertions(+), 21 deletions(-)

-- 
2.17.1
