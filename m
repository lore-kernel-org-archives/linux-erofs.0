From: cgxu519@gmx.com (Chengguang Xu)
Date: Wed, 12 Sep 2018 13:10:31 +0800
Subject: [PATCH 4/7] staging: erofs: return -EINVAL when specifying fault rate
 to 0
In-Reply-To: <20180912051034.3463-1-cgxu519@gmx.com>
References: <20180912051034.3463-1-cgxu519@gmx.com>
Message-ID: <20180912051034.3463-5-cgxu519@gmx.com>

Set fault rate to 0 is useless and confusable, so add check to
avoid it.

Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
---
 drivers/staging/erofs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index d2dbc1fd3abb..8df680aee55a 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -166,6 +166,8 @@ static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
 
 	if (args->from && match_int(args, &rate))
 		return -EINVAL;
+	if (!rate)
+		return -EINVAL;
 
 	__erofs_build_fault_attr(sbi, rate);
 	return 0;
-- 
2.17.1
