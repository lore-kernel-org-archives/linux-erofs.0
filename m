From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 18 Sep 2018 22:25:32 +0800
Subject: [PATCH v2 0/8] staging: erofs: error handing and more tracepoints
Message-ID: <1537280740-122019-1-git-send-email-gaoxiang25@huawei.com>

change log v2:
  - fix a gcc warning reported by Greg for the patch
        staging: erofs: clean up z_erofs_map_blocks_iter


In order to avoid conflicts with cleanup patches, Chao and I think
it is better to send reviewed preview patches in the erofs mailing list
to the community in time.

So here is reviewed & tested patches right now, which clean up and
enhance the error handing and add some tracepoints for decompression.

Note that in this patchset, bare use of 'unsigned' and NULL comparison are
also fixed compared with the preview patches according to the previous
discussion in the staging mailing list.

Thanks,
Gao Xiang

Chen Gong (2):
  staging: erofs: add trace points for reading zipped data
  staging: erofs: replace BUG_ON with DBG_BUGON in data.c

Gao Xiang (6):
  staging: erofs: fix a missing endian conversion
  staging: erofs: clean up z_erofs_map_blocks_iter
  staging: erofs: complete error handing of z_erofs_map_blocks_iter
  staging: erofs: fix a bug when appling cache strategy
  staging: erofs: complete error handing of z_erofs_do_read_page
  staging: erofs: avoid magic constants when initializing clusterbits

 drivers/staging/erofs/data.c                       |  31 ++--
 drivers/staging/erofs/include/trace/events/erofs.h |  20 ++-
 drivers/staging/erofs/super.c                      |   5 +-
 drivers/staging/erofs/unzip_vle.c                  | 196 +++++++++++++--------
 4 files changed, 163 insertions(+), 89 deletions(-)

-- 
1.9.1
