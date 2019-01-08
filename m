From: jeremy@azazel.net (Jeremy Sowden)
Date: Tue,  8 Jan 2019 11:31:47 +0000
Subject: [PATCH v2 1/2] staging: erofs: fixed -Wmissing-prototype warnings by
 making functions static.
In-Reply-To: <20190108113148.31166-1-jeremy@azazel.net>
References: <20190108113148.31166-1-jeremy@azazel.net>
Message-ID: <20190108113148.31166-2-jeremy@azazel.net>

Define three functions which are not used outside their own
translation-units as static in order to fix the following warnings:

  drivers/staging/erofs/utils.c:134:6: warning: no previous prototype for ?erofs_try_to_release_workgroup? [-Wmissing-prototypes]
   bool erofs_try_to_release_workgroup(struct erofs_sb_info *sbi,
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  drivers/staging/erofs/unzip_vle.c:592:6: warning: no previous prototype for ?z_erofs_vle_work_release? [-Wmissing-prototypes]
   void z_erofs_vle_work_release(struct z_erofs_vle_work *work)
        ^~~~~~~~~~~~~~~~~~~~~~~~

  drivers/staging/erofs/unzip_vle_lz4.c:16:5: warning: no previous prototype for ?z_erofs_unzip_lz4? [-Wmissing-prototypes]
   int z_erofs_unzip_lz4(void *in, void *out, size_t inlen, size_t outlen)
       ^~~~~~~~~~~~~~~~~

Signed-off-by: Jeremy Sowden <jeremy at azazel.net>
---
 drivers/staging/erofs/unzip_vle.c     |  2 +-
 drivers/staging/erofs/unzip_vle_lz4.c |  2 +-
 drivers/staging/erofs/utils.c         | 12 ++++++------
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 4ac1099a39c6..584612b47369 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -589,7 +589,7 @@ static void __z_erofs_vle_work_release(struct z_erofs_vle_workgroup *grp,
 	erofs_workgroup_put(&grp->obj);
 }
 
-void z_erofs_vle_work_release(struct z_erofs_vle_work *work)
+static void z_erofs_vle_work_release(struct z_erofs_vle_work *work)
 {
 	struct z_erofs_vle_workgroup *grp =
 		z_erofs_vle_work_workgroup(work, true);
diff --git a/drivers/staging/erofs/unzip_vle_lz4.c b/drivers/staging/erofs/unzip_vle_lz4.c
index 52797bd89da1..8e8d705a6861 100644
--- a/drivers/staging/erofs/unzip_vle_lz4.c
+++ b/drivers/staging/erofs/unzip_vle_lz4.c
@@ -13,7 +13,7 @@
 #include "unzip_vle.h"
 #include <linux/lz4.h>
 
-int z_erofs_unzip_lz4(void *in, void *out, size_t inlen, size_t outlen)
+static int z_erofs_unzip_lz4(void *in, void *out, size_t inlen, size_t outlen)
 {
 	int ret = LZ4_decompress_safe_partial(in, out, inlen, outlen, outlen);
 
diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index b535898ca753..fc30025ef101 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -131,9 +131,9 @@ static void erofs_workgroup_unfreeze_final(struct erofs_workgroup *grp)
 	__erofs_workgroup_free(grp);
 }
 
-bool erofs_try_to_release_workgroup(struct erofs_sb_info *sbi,
-				    struct erofs_workgroup *grp,
-				    bool cleanup)
+static bool erofs_try_to_release_workgroup(struct erofs_sb_info *sbi,
+					   struct erofs_workgroup *grp,
+					   bool cleanup)
 {
 	/*
 	 * for managed cache enabled, the refcount of workgroups
@@ -172,9 +172,9 @@ bool erofs_try_to_release_workgroup(struct erofs_sb_info *sbi,
 
 #else
 /* for nocache case, no customized reclaim path at all */
-bool erofs_try_to_release_workgroup(struct erofs_sb_info *sbi,
-				    struct erofs_workgroup *grp,
-				    bool cleanup)
+static bool erofs_try_to_release_workgroup(struct erofs_sb_info *sbi,
+					   struct erofs_workgroup *grp,
+					   bool cleanup)
 {
 	int cnt = atomic_read(&grp->refcount);
 
-- 
2.20.1
