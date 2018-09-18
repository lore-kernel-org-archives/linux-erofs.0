From: cgxu519@gmx.com (Chengguang Xu)
Date: Tue, 18 Sep 2018 23:10:54 +0800
Subject: [PATCH v3 0/4] staging: erofs: option validation for remount and some
 code cleanups
Message-ID: <20180918151058.25041-1-cgxu519@gmx.com>

This patch set mainly does option validation for remount and at
the same time does related code cleanups. Currently when we call
fault injection related code we have to surround it with macro
CONFIG_EROFS_FAULT_INJECTION in every calling place, after this
patch set we don't have to do that, so the code looks clean and
more understandable.

v2->v3:
- Fold related patches to one patch.
- Fix building issue.

v1->v2:
Address Chao's comments:
- Allow to set fault_injection=0.
- Keep flag bit when setting fault_injection=0.
- Show injection info in original place.
- Rebase code on latest erofs branch in Chao's linux tree.
- Fix building issue.

Hi Greg,

You may pick up rest 2-4 patches in this patch set if there
are no more comments from Chao and Xiang.

Thanks,

Chengguang Xu (4):
  staging: erofs: code cleanup for erofs_kmalloc()
  staging: erofs: code cleanup for option parsing of fault_injection
  staging: erofs: code cleanup for erofs_show_options()
  staging: erofs: option validation in remount

 drivers/staging/erofs/internal.h | 13 ++++--
 drivers/staging/erofs/super.c    | 73 +++++++++++++++++++++++++-------
 2 files changed, 67 insertions(+), 19 deletions(-)

-- 
2.17.1
