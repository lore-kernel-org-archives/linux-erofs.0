From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 30 Jul 2018 11:34:52 +0800
Subject: [FOR INTERNAL REVIEW] [PATCH RESEND 1/3] staging: erofs: fix
 incorrect code in erofs_shrink_scan
In-Reply-To: <5a396128-822f-5232-f3ee-1c5ac6524380@huawei.com>
References: <5a396128-822f-5232-f3ee-1c5ac6524380@huawei.com>
Message-ID: <1532921694-23526-1-git-send-email-gaoxiang25@huawei.com>

From: Gao Xiang <hsiangkao@aol.com>

This patch actually fixes incorrect code snippets due to spilt code
into small patches by mistake, which can cause a compile error without
built-in decompression support and potential abnormal runtime shrinking.

Link: https://lists.01.org/pipermail/kbuild-all/2018-July/050747.html
Link: https://lists.01.org/pipermail/kbuild-all/2018-July/050750.html
Reported-by: kbuild test robot <lkp at intel.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
RESEND:
 - spilt into two patches according to Chao's suggestion

 drivers/staging/erofs/utils.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index ee70bb9..1d06b5f 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -247,7 +247,9 @@ unsigned long erofs_shrink_scan(struct shrinker *shrink,
 		spin_unlock(&erofs_sb_list_lock);
 		sbi->shrinker_run_no = run_no;
 
-		/* add scan handlers here */
+#ifdef CONFIG_EROFS_FS_ZIP
+		freed += erofs_shrink_workstation(sbi, nr, false);
+#endif
 
 		spin_lock(&erofs_sb_list_lock);
 		/* Get the next list element before we move this one */
@@ -260,7 +262,6 @@ unsigned long erofs_shrink_scan(struct shrinker *shrink,
 		list_move_tail(&sbi->list, &erofs_sb_list);
 		mutex_unlock(&sbi->umount_mutex);
 
-		freed += erofs_shrink_workstation(sbi, nr, false);
 		if (freed >= nr)
 			break;
 	}
-- 
1.9.1
