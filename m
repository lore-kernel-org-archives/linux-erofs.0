From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sat, 8 Dec 2018 00:19:11 +0800
Subject: [PATCH 0/7] staging: erofs: decompression fixes & cleanups
Message-ID: <20181207161918.20747-1-gaoxiang25@huawei.com>

Hi,

This patchset has been pending in the erofs mailing list for months.
It mainly focuses on cleaning up io submission flow in the decompression
subsystem in order to remove #ifdefs in related functions, which
were used to differentiate whether cached decompression is enabled
(rather than do in-place decompression only).

These patches has been tested by our Android beta users for these months,
no new issue reported.

Thanks,
Gao Xiang

Gao Xiang (7):
  staging: erofs: fix use-after-free of on-stack `z_erofs_vle_unzip_io'
  staging: erofs: introduce MNGD_MAPPING helper
  staging: erofs: localize UNALLOCATED_CACHED_PAGE placeholder
  staging: erofs: revisit the page submission flow
  staging: erofs: refine compressed pages preload flow
  staging: erofs: redefine where `owned_workgrp_t' points
  staging: erofs: simplify `z_erofs_vle_submit_all'

 drivers/staging/erofs/internal.h  |   6 +-
 drivers/staging/erofs/unzip_vle.c | 580 ++++++++++++++++++++++++--------------
 drivers/staging/erofs/unzip_vle.h |   4 +-
 3 files changed, 377 insertions(+), 213 deletions(-)

-- 
2.14.4
