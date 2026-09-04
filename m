Return-Path: <linux-erofs+bounces-4477-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD8A7C624DE
	for <linux-erofs@archiver.kernel.org>; Fri,  4 Sep 2026 17:18:01 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hc37q6bHzz2ytT;
	Sat, 05 Sep 2026 03:17:59 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=162.62.57.210
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788542279;
	cv=none; b=Ej6RV2oFOVVw2DHvZDFmv0wfL6jprzKhVGmnuzpCpg7f8f1SsZ4kokpbqULQ4t4eEeovhKn8AF3uSg/gf8qd+78AUlNpxtcaeBvnIB60RHLkmzCXVpItUm07+KzdNV6Q0hy8FgOjf8R5s5mK5ZXXna6e1qk+BptCUpYqsIgp5KpbCW0Z7qf6j/8RmrRiOgw/C2isCNZSXM7jXmDUf4Yp/Lao7X7Z1F1p7mdgjI/IC4WzTEEXfjZnhxeQFPuiMQTjkcSnmu3wrTT1cuwE9n1sYothtzF/XiohVU0VLFa5KPQk6riFnB3z3BywTb8ZikzcmjkIpZdnXpr2j8AUd0wJlg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788542279; c=relaxed/relaxed;
	bh=W3CC9Tots1MgjhJnf7KalcseN0jSzEYXPSuvcnLittY=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=i7BPOYeYd41Gs58O24O96PaQ65ubQ/MgdQDiv9+WmIsFQ2ZMjJxjoACl2L+LhvMTvb+Ra8nEc9x2stBs6FWCgLQZ7xYiB4YgH3V3RzBD+g9HUyCaEa3F1vMgEF4HW9raLXnzGW92gxEVoWRAZInsdLE3c1zxZcQK6dBFNnyEzytYqiVS7FoHQjV9WzWL9CjzIW3LcgroBrhgX9n5b1lpK+0ItFit9CiEAdtdR6koIG5qZ9njSflgvwOY2Ng9DGzwb/7FSh66trWSsT2wmfc/BsvQWsSRB+bav9mGgQcHiR4YYHRUNuftnxQvdaKBrhVML7CtWo2A2FzDcVkSKt358w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; dkim=pass (1024-bit key; unprotected) header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=g/IzJ+Go; dkim-atps=neutral; spf=pass (client-ip=162.62.57.210; helo=out162-62-57-210.mail.qq.com; envelope-from=yifan.yfzhao@foxmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=foxmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=g/IzJ+Go;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=foxmail.com (client-ip=162.62.57.210; helo=out162-62-57-210.mail.qq.com; envelope-from=yifan.yfzhao@foxmail.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 115 seconds by postgrey-1.37 at boromir; Sat, 05 Sep 2026 03:17:52 AEST
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hc37h6M34z2yrf
	for <linux-erofs@lists.ozlabs.org>; Sat, 05 Sep 2026 03:17:51 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1788542265;
	bh=W3CC9Tots1MgjhJnf7KalcseN0jSzEYXPSuvcnLittY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g/IzJ+GoLqQ5e7/lkc6yePea8gBpl2tGJxdopK+uY7qgQ7iPAfJn0pungYRWeev4T
	 yoZlLpPGOzqeX1dNZlmHO3GOqSWcswTAQ4vlcH1SuJWkQk8iRUhbDBYnMc3a/UoZCo
	 bmKRfE1aC7An4iW/eyRKuxSBJm7WySKkwySS79dM=
Received: from ZYF-DESKTOP.localdomain ([2408:820c:b633:a5e4:4006:34be:2974:2])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 4018A8BB; Sat, 05 Sep 2026 01:16:01 +0800
X-QQ-mid: xmsmtpt1788542161tav8h6b8h
Message-ID: <tencent_6E3F963DE9659FC95D6D8AEDDBFF66BC5609@qq.com>
X-QQ-XMAILINFO: OWWJ7unoAaDKlSrgfo5Lwmhn/32xMjuJPEQH4sEktBUs8QKK7eW5IOVCCETpQP
	 GXaTu1AMQ8bNS+km65mKH+vFd9Fy66KLP9BEru4YoN/2mnA4yltuxOwghM/8K18LrLmvAkMKHKnr
	 KfA4sh8RtO+VfLMLU8t3d4n4ZGk+MK9o14x/JU1ySDZ77edWr1CTsBgHkau/sLMGCnba36xPtSHn
	 nwBtvv1zhZqolb6Qctzui3TceK6xYDd4wq4Ri4n25EjPqU6/wGtgp88twWV9tiKeVjFh2ynmqo12
	 jTNS8oUKOqO/W+iXgpxZfa8sNZ1xzGEihwQLAAANkQiDJf5Y4g8fMy1MZRw2A1zzKiSsAW79g1IV
	 vegjDsTZUNCAtEducGmZu5u+a4LvBp14d9ATVt0LorfO4lGk/LPqg7xzd6CJg9XXT58fv22XGh0z
	 Sjsj/G+VnH9qnJbxj32A3WcyoF/9s1EoSIKSnI59GgHHv85ky69muVssY8lJObOupP0YGZAG86Qz
	 g+150oqhX9KEizexpQ9XGmWARYcxYl9Vi1VxYcb76uHQhEF5e/w/S5E0zA0+Ng5zMgrHyRfph1Gb
	 utUS1hDor4Pci8WMqeFIGrPjvfWo180OM6jr0b9CyfTR04F08apaWfIQYZ6ADokgs1J8V7hK4LcY
	 wDypQwofSleZ6p6MkARLDkEYnF9+I+ZBg7Ir85K0KEYzMX65eXpKlZVqoxuG8Fgxp2IJa//tb/bL
	 Pu5s45SQ7UYdXoOKng9ql4pcvesK7MzToW24eHnfTsnhYN+CExVZgcOyiuvbfdpRMZrnnqgiiib4
	 IVGKI0BdgfW79TrGJ7Tp5m69tY8M7VsFP+fXP+ZethZMKSbRXx327U9MSepcdD3MLLreQoI/KF3t
	 2lW9tyleT/NUzwyHceK/ATXGdHBj8nQe1riBsVSZONV7nb8X/2i3mvN+wKD1/nbgjXKfVF826dbA
	 2EnUy0Zq665yV7Q1V0TmPuEeo0chAj/plSsHejcZ9p9N5zmukRT9qyDt/CcbM1r4vyHB4nR3sFnQ
	 NvqJHASCcpeW6h6VZ+m9Y3bByei8GlU06+tCZs79XsEboXmBE0vTugUJ8l6cL0SohbllPhfRaFyH
	 au1ifnTFZwzAghwQ3GvVHtcVuXkg520i/IjNrV36OtUE95xRY=
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
From: Yifan Zhao <yifan.yfzhao@foxmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>,
	Yifan Zhao <yifan.yfzhao@foxmail.com>
Subject: [PATCH v2] erofs-utils: lib: fix direct S3 writes to blob devices
Date: Sat,  5 Sep 2026 01:15:58 +0800
X-OQ-MSGID: <20260904171558.411095-1-yifan.yfzhao@foxmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904171205.403451-1-yifan.yfzhao@foxmail.com>
References: <20260904171205.403451-1-yifan.yfzhao@foxmail.com>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Direct S3 writes target the primary device and may leave the selected
blob device shorter than its allocated extent.

Write objects at device-relative offsets on the selected device
and extend it to the final block boundary.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Yifan Zhao <yifan.yfzhao@foxmail.com>
---
Changes since v1:
- Correct the author and Signed-off-by email address.

 lib/remotes/s3.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/lib/remotes/s3.c b/lib/remotes/s3.c
index 56ab808..feba9b4 100644
--- a/lib/remotes/s3.c
+++ b/lib/remotes/s3.c
@@ -15,6 +15,7 @@
 #include "erofs/internal.h"
 #include "erofs/print.h"
 #include "erofs/inode.h"
+#include "../liberofs_cache.h"
 #include "../liberofs_chunk.h"
 #include "erofs/diskbuf.h"
 #include "erofs/importer.h"
@@ -1017,6 +1018,11 @@ struct s3erofs_curl_getobject_resp {
 	erofs_off_t pos, end;
 };
 
+static bool s3erofs_could_write_directly(const struct erofs_importer *im)
+{
+	return !im->sbi->available_compr_algs && im->params->no_datainline;
+}
+
 static size_t s3erofs_remote_getobject_cb(void *contents, size_t size,
 					  size_t nmemb, void *userp)
 {
@@ -1053,16 +1059,20 @@ static int s3erofs_remote_getobject(struct erofs_importer *im,
 		return -EIO;
 
 	resp.pos = 0;
-	if (!sbi->available_compr_algs && im->params->no_datainline) {
+	if (s3erofs_could_write_directly(im)) {
+		unsigned int device_id = im->params->ddev_id_def;
+
 		inode->datalayout = EROFS_INODE_FLAT_PLAIN;
 		inode->idata_size = 0;
 		ret = erofs_allocate_inode_bh_data(inode,
 				DIV_ROUND_UP(inode->i_size, 1U << sbi->blkszbits),
-				im->params->ddev_id_def);
+				device_id);
 		if (ret)
 			return ret;
-		resp.vf = &sbi->bdev;
-		resp.pos = erofs_pos(inode->sbi, inode->u.i_blkaddr);
+		resp.vf = device_id ?
+			sbi->devs[device_id - 1].bmgr->vf : &sbi->bdev;
+		if (inode->i_size)
+			resp.pos = erofs_pos(sbi, erofs_inode_dev_baddr(inode));
 		inode->datasource = EROFS_INODE_DATA_SOURCE_NONE;
 	} else {
 		if (!inode->i_diskbuf) {
@@ -1189,6 +1199,17 @@ int s3erofs_build_trees(struct erofs_importer *im, struct erofs_s3 *s3,
 			goto err_iter;
 	}
 
+	if (!fillzero && s3erofs_could_write_directly(im) &&
+	    im->params->ddev_id_def) {
+		struct erofs_bufmgr *bmgr =
+			sbi->devs[im->params->ddev_id_def - 1].bmgr;
+
+		ret = erofs_io_ftruncate(bmgr->vf,
+				erofs_pos(sbi, erofs_mapbh(bmgr, NULL)));
+		if (ret)
+			goto err_iter;
+	}
+
 err_iter:
 	s3erofs_destroy_object_iterator(iter);
 err_global:

base-commit: 65645313de60a42d6d93389a6658317f8b1e6b8e
-- 
2.55.0


