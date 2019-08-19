From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 19 Aug 2019 18:34:20 +0800
Subject: [PATCH 0/6] staging: erofs: first stage of corrupted compressed images
In-Reply-To: <20190819080218.GA42231@138>
References: <20190819080218.GA42231@138>
Message-ID: <20190819103426.87579-1-gaoxiang25@huawei.com>

Hi all,

I have fuzzed EROFS for about a day and observed the following
issues due to corrupted compression images by my first fuzzer
(It seems ok for uncompressed images for now). Now it can survive
for 10+ minutes on my PC (Let me send out what I'm done and
I will dig it more deeply...)

All the fixes are trivial.

Note that those have dependency on EFSCORRUPTED, so for-next
is needed and I will manually backport them by hand due to
many cleanup patches...

Thanks,
Gao Xiang

Gao Xiang (6):
  staging: erofs: some compressed cluster should be submitted for
    corrupted images
  staging: erofs: cannot set EROFS_V_Z_INITED_BIT if fill_inode_lazy
    fails
  staging: erofs: add two missing erofs_workgroup_put for corrupted
    images
  staging: erofs: avoid loop in submit chains
  staging: erofs: detect potential multiref due to corrupted images
  staging: erofs: avoid endless loop of invalid lookback distance 0

 drivers/staging/erofs/zdata.c | 46 ++++++++++++++++++++++++++---------
 drivers/staging/erofs/zmap.c  |  9 +++++--
 2 files changed, 42 insertions(+), 13 deletions(-)

-- 
2.17.1
