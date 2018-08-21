From: chao@kernel.org (Chao Yu)
Date: Tue, 21 Aug 2018 22:49:28 +0800
Subject: [PATCH v2 0/9] staging: erofs: fix some issues and clean up codes
Message-ID: <20180821144937.20555-1-chao@kernel.org>

From: Chao Yu <yuchao0@huawei.com>

This patchset mainly adds error handing code for erofs xattr subsystem.
In addition, some code cleanups are also included in this patchset.

P.S. Some other patches are still previewing in the linux-erofs mailing
list, which will be posted in the 2nd part later.

[changelog]
v1 -> v2:
[PATCH 2/9] staging: erofs: separate erofs_get_meta_page
- Put err_out stuff at the bottom of the function.
- Drop the question mark in the "truncated by others?".
  Pointed out by Dan Carpenter <dan.carpenter at oracle.com>
- fix `PTR_ERR applied after initialization to constant'.
  Reported by kbuild test robot <lkp at intel.com>
- fix compilation error (erofs is bypassed by BROKEN...).

[PATCH 3/9] staging: erofs: add error handling for xattr submodule
- drop all likely/unlikely hints in this patch.
- fix bare use of 'unsigned *' at drivers/staging/erofs/xattr.c:168.
  Pointed out by Dan Carpenter <dan.carpenter at oracle.com>

[PATCH 6/9] staging: erofs: fix vle_decompressed_index_clusterofs
- don't make functions inline
  Pointed out by Dan Carpenter <dan.carpenter at oracle.com> 

[PATCH 9/9] staging: erofs: fix potential overflow in erofs_grab_bio()
- in addition, we add one more patch above to fix potential overflow
in this series.

Chao Yu (1):
  staging: erofs: fix potential overflow in erofs_grab_bio()

Gao Xiang (8):
  staging: erofs: introduce erofs_grab_bio
  staging: erofs: separate erofs_get_meta_page
  staging: erofs: add error handling for xattr submodule
  staging: erofs: cleanup z_erofs_vle_work_{lookup, register}
  staging: erofs: rearrange vle clustertype definitions
  staging: erofs: fix vle_decompressed_index_clusterofs
  staging: erofs: fix integer overflow on 32-bit platform
  staging: erofs: fix compression mapping beyond EOF

 drivers/staging/erofs/Kconfig     |   9 ++
 drivers/staging/erofs/data.c      |  68 +++++++++-----
 drivers/staging/erofs/erofs_fs.h  |  11 +++
 drivers/staging/erofs/internal.h  |  66 ++++++++-----
 drivers/staging/erofs/unzip_vle.c | 149 +++++++++++++++---------------
 drivers/staging/erofs/xattr.c     | 127 +++++++++++++++++--------
 6 files changed, 273 insertions(+), 157 deletions(-)

-- 
2.18.0
