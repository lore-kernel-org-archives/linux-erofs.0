From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 19 Aug 2019 18:34:23 +0800
Subject: [PATCH 3/6] staging: erofs: add two missing erofs_workgroup_put for
 corrupted images
In-Reply-To: <20190819103426.87579-1-gaoxiang25@huawei.com>
References: <20190819080218.GA42231@138>
 <20190819103426.87579-1-gaoxiang25@huawei.com>
Message-ID: <20190819103426.87579-4-gaoxiang25@huawei.com>

As reported by erofs-utils fuzzer, these error handling
path will be entered to handle corrupted images.

Lack of erofs_workgroup_puts will cause unmounting
unsuccessfully.

Fix these return values to EFSCORRUPTED as well.

Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Cc: <stable at vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/zdata.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/zdata.c b/drivers/staging/erofs/zdata.c
index 87b0c96caf8f..23283c97fd3b 100644
--- a/drivers/staging/erofs/zdata.c
+++ b/drivers/staging/erofs/zdata.c
@@ -357,14 +357,16 @@ static struct z_erofs_collection *cllookup(struct z_erofs_collector *clt,
 	cl = z_erofs_primarycollection(pcl);
 	if (unlikely(cl->pageofs != (map->m_la & ~PAGE_MASK))) {
 		DBG_BUGON(1);
-		return ERR_PTR(-EIO);
+		erofs_workgroup_put(grp);
+		return ERR_PTR(-EFSCORRUPTED);
 	}
 
 	length = READ_ONCE(pcl->length);
 	if (length & Z_EROFS_PCLUSTER_FULL_LENGTH) {
 		if ((map->m_llen << Z_EROFS_PCLUSTER_LENGTH_BIT) > length) {
 			DBG_BUGON(1);
-			return ERR_PTR(-EIO);
+			erofs_workgroup_put(grp);
+			return ERR_PTR(-EFSCORRUPTED);
 		}
 	} else {
 		unsigned int llen = map->m_llen << Z_EROFS_PCLUSTER_LENGTH_BIT;
-- 
2.17.1
