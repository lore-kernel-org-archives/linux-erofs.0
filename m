From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 20 Nov 2018 22:34:15 +0800
Subject: [PATCH 00/10] staging: erofs: decompression stability enhancement
Message-ID: <20181120143425.43637-1-gaoxiang25@huawei.com>

Hi,

This patchset mainly focuses on erofs decompression stability, most of
them are found in the internal beta test. Some patches which are still
in testing or reviewing aren't included in this patchset and will be
sent after carefully testing.

Thanks,
Gao Xiang

Gao Xiang (10):
  staging: erofs: fix `trace_erofs_readpage' position
  staging: erofs: fix race when the managed cache is enabled
  staging: erofs: atomic_cond_read_relaxed on ref-locked workgroup
  staging: erofs: fix `erofs_workgroup_{try_to_freeze, unfreeze}'
  staging: erofs: add a full barrier in erofs_workgroup_unfreeze
  staging: erofs: fix the definition of DBG_BUGON
  staging: erofs: separate into init_once / always
  staging: erofs: locked before registering for all new workgroups
  staging: erofs: decompress asynchronously if PG_readahead page at
    first
  staging: erofs: rename strange variable names in z_erofs_vle_frontend

 drivers/staging/erofs/internal.h  |  69 ++++++++++++--------
 drivers/staging/erofs/unzip_vle.c |  78 ++++++++++++++++-------
 drivers/staging/erofs/utils.c     | 131 ++++++++++++++++++++++++++------------
 3 files changed, 190 insertions(+), 88 deletions(-)

-- 
2.14.4
