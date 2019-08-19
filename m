From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 19 Aug 2019 18:34:24 +0800
Subject: [PATCH 4/6] staging: erofs: avoid loop in submit chains
In-Reply-To: <20190819103426.87579-1-gaoxiang25@huawei.com>
References: <20190819080218.GA42231@138>
 <20190819103426.87579-1-gaoxiang25@huawei.com>
Message-ID: <20190819103426.87579-5-gaoxiang25@huawei.com>

As reported by erofs-utils fuzzer, 2 conditions
can happen in corrupted images, which can cause
unexpected behaviors.
 - access the same pcluster one more time;
 - access the tail end pcluster again, e.g.
            _ access again (will trigger tail merging)
           |
     1 2 3 1 2             ->   1 2 3 1
     |_ tail end of the chain    \___/ (unexpected behavior)
Let's detect and avoid them now.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/zdata.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/zdata.c b/drivers/staging/erofs/zdata.c
index 23283c97fd3b..aae2f2b8353f 100644
--- a/drivers/staging/erofs/zdata.c
+++ b/drivers/staging/erofs/zdata.c
@@ -132,7 +132,7 @@ enum z_erofs_collectmode {
 struct z_erofs_collector {
 	struct z_erofs_pagevec_ctor vector;
 
-	struct z_erofs_pcluster *pcl;
+	struct z_erofs_pcluster *pcl, *tailpcl;
 	struct z_erofs_collection *cl;
 	struct page **compressedpages;
 	z_erofs_next_pcluster_t owned_head;
@@ -353,6 +353,11 @@ static struct z_erofs_collection *cllookup(struct z_erofs_collector *clt,
 		return NULL;
 
 	pcl = container_of(grp, struct z_erofs_pcluster, obj);
+	if (clt->owned_head == &pcl->next || pcl == clt->tailpcl) {
+		DBG_BUGON(1);
+		erofs_workgroup_put(grp);
+		return ERR_PTR(-EFSCORRUPTED);
+	}
 
 	cl = z_erofs_primarycollection(pcl);
 	if (unlikely(cl->pageofs != (map->m_la & ~PAGE_MASK))) {
@@ -381,6 +386,9 @@ static struct z_erofs_collection *cllookup(struct z_erofs_collector *clt,
 		}
 	}
 	mutex_lock(&cl->lock);
+	/* used to check tail merging loop due to corrupted images */
+	if (clt->owned_head == Z_EROFS_PCLUSTER_TAIL)
+		clt->tailpcl = pcl;
 	clt->mode = try_to_claim_pcluster(pcl, &clt->owned_head);
 	clt->pcl = pcl;
 	clt->cl = cl;
@@ -434,6 +442,9 @@ static struct z_erofs_collection *clregister(struct z_erofs_collector *clt,
 		kmem_cache_free(pcluster_cachep, pcl);
 		return ERR_PTR(-EAGAIN);
 	}
+	/* used to check tail merging loop due to corrupted images */
+	if (clt->owned_head == Z_EROFS_PCLUSTER_TAIL)
+		clt->tailpcl = pcl;
 	clt->owned_head = &pcl->next;
 	clt->pcl = pcl;
 	clt->cl = cl;
-- 
2.17.1
