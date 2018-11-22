From: hsiangkao@aol.com (Gao Xiang)
Date: Fri, 23 Nov 2018 01:15:57 +0800
Subject: [PATCH v2 00/10] staging: erofs: decompression stability enhancement
Message-ID: <1542906967-249-1-git-send-email-hsiangkao@aol.com>

Hi,

This patchset mainly focuses on erofs decompression stability, most of
them are found in the internal beta test. Some patches which are still
in testing or reviewing aren't included in this patchset and will be
sent after carefully testing.

Thanks,
Gao Xiang

Changelog from v1
===
  o fix a redundant BUG_ON suggested by Greg since it never happens at all;
  o add more description suggested by Greg in commit message of 
      [01/10] staging: erofs: fix `trace_erofs_readpage' position
  o add some description suggested by Greg of a memory barrier occurred in
      [06/10] staging: erofs: add a full barrier in erofs_workgroup_unfreeze 

Shortlog
===
Gao Xiang (10):
  staging: erofs: fix `trace_erofs_readpage' position
  staging: erofs: fix the definition of DBG_BUGON
  staging: erofs: fix race when the managed cache is enabled
  staging: erofs: atomic_cond_read_relaxed on ref-locked workgroup
  staging: erofs: fix `erofs_workgroup_{try_to_freeze, unfreeze}'
  staging: erofs: add a full barrier in erofs_workgroup_unfreeze
  staging: erofs: separate into init_once / always
  staging: erofs: locked before registering for all new workgroups
  staging: erofs: decompress asynchronously if PG_readahead page at
    first
  staging: erofs: rename strange variable names in z_erofs_vle_frontend

 drivers/staging/erofs/internal.h  |  73 +++++++++++++--------
 drivers/staging/erofs/unzip_vle.c |  79 +++++++++++++++-------
 drivers/staging/erofs/utils.c     | 135 +++++++++++++++++++++++++++-----------
 3 files changed, 199 insertions(+), 88 deletions(-)

-- 
2.11.0
