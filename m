From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 19 Aug 2019 18:34:22 +0800
Subject: [PATCH 2/6] staging: erofs: cannot set EROFS_V_Z_INITED_BIT if
 fill_inode_lazy fails
In-Reply-To: <20190819103426.87579-1-gaoxiang25@huawei.com>
References: <20190819080218.GA42231@138>
 <20190819103426.87579-1-gaoxiang25@huawei.com>
Message-ID: <20190819103426.87579-3-gaoxiang25@huawei.com>

As reported by erofs-utils fuzzer, unsupported compressed
clustersize will make fill_inode_lazy fail, for such case
we cannot set EROFS_V_Z_INITED_BIT since we need return
failure for each z_erofs_map_blocks_iter().

Fixes: 152a333a5895 ("staging: erofs: add compacted compression indexes support")
Cc: <stable at vger.kernel.org> # 5.3+
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/zmap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/zmap.c b/drivers/staging/erofs/zmap.c
index b61b9b5950ac..7408e86823a4 100644
--- a/drivers/staging/erofs/zmap.c
+++ b/drivers/staging/erofs/zmap.c
@@ -85,12 +85,11 @@ static int fill_inode_lazy(struct inode *inode)
 
 	vi->z_physical_clusterbits[1] = vi->z_logical_clusterbits +
 					((h->h_clusterbits >> 5) & 7);
+	set_bit(EROFS_V_Z_INITED_BIT, &vi->flags);
 unmap_done:
 	kunmap_atomic(kaddr);
 	unlock_page(page);
 	put_page(page);
-
-	set_bit(EROFS_V_Z_INITED_BIT, &vi->flags);
 out_unlock:
 	clear_and_wake_up_bit(EROFS_V_BL_Z_BIT, &vi->flags);
 	return err;
-- 
2.17.1
