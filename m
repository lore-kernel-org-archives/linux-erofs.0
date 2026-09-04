Return-Path: <linux-erofs+bounces-4478-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 022E4C79F82
	for <linux-erofs@archiver.kernel.org>; Fri,  4 Sep 2026 17:20:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hc3BD4FjPz2y2b;
	Sat, 05 Sep 2026 03:20:04 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=203.205.221.240
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788542404;
	cv=none; b=S4NGbhmHAX1QMa6W87zKfORAyUmEMQ+l3hoSYKc3CXR5G/OeZZSw6VsbSUASKC2GWoUV1oHvOa+eLUgtW0PD6uN/C6bu4SfuJ5Qq15N8/WKsqLe67VZ9l86iNlZkdEkANjUdzJzCCjvT2gmuEzh5r1gRq5ROO+lI92UW2bp4v+rKIn4VaFqZbOFRPkImhrGak/zFr1lX++vP8pCxRUL89RIWdFpqY4nk0/tFOC9FQZiB9VaSakdPNhvU2/e92bpe/fco37fVWuv57D9xrXhm1zEAl4/3LUtUU5GJGK4fXwbNg+sHHajevnKYm8YAhIPrAT3ld05aHg7lBuRhKYgqeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788542404; c=relaxed/relaxed;
	bh=JEg0BuQSNgfLnE7kcYHL11gsNpdj6w6X84biOUNjL5c=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=YyjwKcooV/s00CsxE8cEZFa/lKAG1ZFdBjd14UOwoPsmgpmftRBISXe7FQAP4GZWwAiCuaZ9/XOqBdp2BwbLMIf/rrIfSYvCmghbsig7JR8+ycr4dT4pQGwU02z9Ev0GO2jl7beTHRFDbIj2Wi9yxDrB04UvnwA93dk3FbP8hkCm+QtpVAcfVm83clpYhHYL+c1kJmBxDuZeJCpMkf8qIubh5BxSJPsHiPOOmXsBKV7/5pTSgSv5qdtcrpEku4aCWXB83Lf2VHNl0s291yU1yAYYLFx6+AmPuIHAu9TliXjJdohjtktQf/jzy2lpoZ9R9kb50/yR9jKAw1nNLy67CQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; dkim=pass (1024-bit key; unprotected) header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=YvBox9Tb; dkim-atps=neutral; spf=pass (client-ip=203.205.221.240; helo=out203-205-221-240.mail.qq.com; envelope-from=yifan.yfzhao@foxmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=foxmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=YvBox9Tb;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=foxmail.com (client-ip=203.205.221.240; helo=out203-205-221-240.mail.qq.com; envelope-from=yifan.yfzhao@foxmail.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 372 seconds by postgrey-1.37 at boromir; Sat, 05 Sep 2026 03:20:02 AEST
Received: from out203-205-221-240.mail.qq.com (out203-205-221-240.mail.qq.com [203.205.221.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hc3BB1vhSz2y22
	for <linux-erofs@lists.ozlabs.org>; Sat, 05 Sep 2026 03:20:01 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1788542398;
	bh=JEg0BuQSNgfLnE7kcYHL11gsNpdj6w6X84biOUNjL5c=;
	h=From:To:Cc:Subject:Date;
	b=YvBox9TbIIus1Zy6HrW2WUHVqOcLZjXDLS/ijxfBG/ymZIEche5z5YRLPdjBR2kWa
	 vnhFJ8pBRRtVGzHlXAZ+ZXQcmOSorWwNJ+CoOfvhH4o6PPSlPt56+H10od8yHNlyH5
	 EF3OktOS/2mx6fCTiesDSXak/NO9Zb6EfN561kwo=
Received: from ZYF-DESKTOP.localdomain ([2408:820c:b633:a5e4:4006:34be:2974:2])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id 30915E94; Sat, 05 Sep 2026 01:12:09 +0800
X-QQ-mid: xmsmtpt1788541929tyoy6bqa7
Message-ID: <tencent_60DEE459DA35A0D8B27D792668B56F198605@qq.com>
X-QQ-XMAILINFO: Od8VqZhFMB3NlC89LgcuhXm7UxZ7TYSjSzwH6apMLdeEuKwjaCI4SQNShfZWH0
	 z07rMgncsVhAU53SNDunT9oVaqseEts4ZvWDxOeEVl1pKq5XU+xodGlVswbjmH+NCIhYuGcc3oZk
	 QvtNSgg032MM0tyQVBmUwDZ3z8fM6P+LLaMyAi05bnxniaMFsPYqyuC+7jx9pIPSFjKD49k0n6da
	 XEE8LxRyyXE9PxKsukm3hDDgH2cxNA8QD3IEl+0Q94V+y9z+PM63vmMQAI/QQsDLHWKRlXzBC1uI
	 bqU+z3/RXIBmg/NTotzBmlbb5BO4HLds3jfpMLuLi8qLx0WybTxNi0NjE6S+w8zQs0xOYAEi8Ns7
	 y3VHG8Ai0t3Lk1XQ4umgt0bDtrsB0vEU5L7nfGIe6bDmd0BOquRdPzBL2Aw2Cc7PWbpUuHvn/KK9
	 m+Y37oGY8az2mQzhQTCoQ6TWynSYuF8QVHx4zFDJjCP2yn67sSAzsxGV6Qahq4cBg3iNuR15MelF
	 1PFP0TOHmiOgc+F4ywoCT8CDY8Vex6cuVavkh+Z4PpH6mbo+bmZ7abhOByijf98P0EDWjuoWTaIi
	 TgxDFiMH6lJZem+/wj0Oel/FP5k3RpKHkGUl6KJoSK7aDMrMBvGysVPZC1XUJQ9Bp/6gQSh2Aevg
	 A3YGn7Y++dfSH9Gxto3qZsNOn32ddL1cFQ/6eU2oWqTCUM0hDUmJkYsFWzPsne5Pr5M+tZxgXyKt
	 lHb2hDMSRzfpoa6P+moyEqWbB3IEz1fiug4E9oYXI51wMGIfZs1dRAGa4ViYa5nFaqLlbTBpA4Nf
	 RW8aeI4Ic599gVWfuLouXV5efGR3H69VL8UgxoXpiSgQUGCPQ6pcAJUwrKPiIqJN/giEPthObHZo
	 YRNR0T4YspmybG9zhqXHM/o23vsa7kvFr2KUHAyRK2gcBDlw0Isp2CIV88dBBf5A7WToULx8k1SS
	 esqz90gMVlu5y2svarrI4/bh5TauWHALv9F4idTV4yDXzNLKCJKmhmVLqoXBWQM+dqf2Fc7Zuc1A
	 V7xW+6Is7SkylwOuHo
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: Yifan Zhao <yifan.yfzhao@foxmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>,
	Yifan Zhao <stopire@gmail.com>
Subject: [PATCH] erofs-utils: lib: fix direct S3 writes to blob devices
Date: Sat,  5 Sep 2026 01:12:05 +0800
X-OQ-MSGID: <20260904171205.403451-1-yifan.yfzhao@foxmail.com>
X-Mailer: git-send-email 2.55.0
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

From: Yifan Zhao <stopire@gmail.com>

Direct S3 writes target the primary device and may leave the selected
blob device shorter than its allocated extent.

Write objects at device-relative offsets on the selected device
and extend it to the final block boundary.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
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


