From: laumann.thomas@gmail.com (Thomas Jespersen)
Date: Sun,  9 Dec 2018 16:59:00 +0100
Subject: [PATCH] staging: erofs: Add braces to do-while statements
Message-ID: <20181209155900.10164-1-laumann.thomas@gmail.com>

This fixes warning reported by sparse (with -Wsparse-all).

Signed-off-by: Thomas Jespersen <laumann.thomas at gmail.com>
---
 drivers/staging/erofs/internal.h | 4 ++--
 drivers/staging/erofs/utils.c    | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 57575c7f5635..bf180a803446 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -232,9 +232,9 @@ static inline bool erofs_workgroup_get(struct erofs_workgroup *grp, int *ocnt)
 	/* spin if it is temporarily locked at the reclaim path */
 	if (unlikely(o == locked)) {
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
-		do
+		do {
 			cpu_relax();
-		while (atomic_read(&grp->refcount) == locked);
+		} while (atomic_read(&grp->refcount) == locked);
 #endif
 		goto repeat;
 	}
diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index ea8a962e5c95..cd76df4a48c7 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -217,9 +217,9 @@ unsigned long erofs_shrink_scan(struct shrinker *shrink,
 	unsigned long freed = 0;
 
 	spin_lock(&erofs_sb_list_lock);
-	do
+	do {
 		run_no = ++shrinker_run_no;
-	while (run_no == 0);
+	} while (run_no == 0);
 
 	/* Iterate over all mounted superblocks and try to shrink them */
 	p = erofs_sb_list.next;
-- 
2.19.2
