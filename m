From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 5 Nov 2018 18:45:02 +0800
Subject: [PATCH 4.20-rc1 rebased 09/10] staging: erofs: locked before
 registering for all new workgroups
In-Reply-To: <20181105104503.45627-1-gaoxiang25@huawei.com>
References: <20181105104503.45627-1-gaoxiang25@huawei.com>
Message-ID: <20181105104503.45627-9-gaoxiang25@huawei.com>

Let's make sure that the one registering a workgroup will also
take the primary work lock at first for two reasons:
  1) There's no need to introduce such a race window (and consequently
     overhead) between registering and locking, other tasks could break
     in by chance, and the race seems unnecessary (no benefit at all);

  2) It's better to take the primary work when a workgroup
     is registered to apply the cache managed policy, for example,
     if some other tasks break in, it could turn into the in-place
     decompression rather than use as the cached decompression.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index a71e699774dc..5100cf7733ba 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -419,18 +419,21 @@ z_erofs_vle_work_register(const struct z_erofs_vle_work_finder *f,
 	work = z_erofs_vle_grab_primary_work(grp);
 	work->pageofs = f->pageofs;
 
+	/* lock all primary followed works before visible to others */
+	if (unlikely(!mutex_trylock(&work->lock)))
+		BUG_ON(1);
+
 	if (gnew) {
 		int err = erofs_register_workgroup(f->sb, &grp->obj, 0);
 
 		if (err) {
+			mutex_unlock(&work->lock);
 			kmem_cache_free(z_erofs_workgroup_cachep, grp);
 			return ERR_PTR(-EAGAIN);
 		}
 	}
 
 	*f->owned_head = *f->grp_ret = grp;
-
-	mutex_lock(&work->lock);
 	return work;
 }
 
-- 
2.14.4
