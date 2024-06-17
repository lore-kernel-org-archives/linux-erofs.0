Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF9C8C27C77
	for <linux-erofs@archiver.kernel.org>; Mon, 17 Jun 2024 02:34:57 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=bhIp0fqt;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4W2YrH1cvjz3cRc
	for <linux-erofs@archiver.kernel.org>; Mon, 17 Jun 2024 12:34:55 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=bhIp0fqt;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.118; helo=out30-118.freemail.mail.aliyun.com; envelope-from=hongzhen@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4W2Yr30hFRz301T
	for <linux-erofs@lists.ozlabs.org>; Mon, 17 Jun 2024 12:34:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1718591676; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=CdMh3kzXs7sr/YY2mnnp2GGBbeAYSxcYwIkcyAGdC/I=;
	b=bhIp0fqtbGqxFo/5KDceH9mIX+tX6DlYOr/F8Y0FALea/3XHsxDdHN+d5oha+3K6MOY0pPSJbGPgIIkjmA3kAS2lbW0awH+hBIA4ISk6foR5YaJ/4lirtnrHlLYgGLAYuNghktLIAlG4jUcGLJBLuzBZXYEQyeOAKYm8wtajQbg=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032014031;MF=hongzhen@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0W8X5ff6_1718591674;
Received: from localhost(mailfrom:hongzhen@linux.alibaba.com fp:SMTPD_---0W8X5ff6_1718591674)
          by smtp.aliyun-inc.com;
          Mon, 17 Jun 2024 10:34:35 +0800
From: Hongzhen Luo <hongzhen@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: fix the erofs_io_pread and erofs_io_pwrite
Date: Mon, 17 Jun 2024 10:34:33 +0800
Message-Id: <20240617023433.3446706-1-hongzhen@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: Hongzhen Luo <hongzhen@linux.alibaba.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

When `vf->ops` is not null, `vf->ops->pread` returns the
number of bytes successfully read, which is inconsistent
with the semantics of `erofs_io_pread`. Similar situation
occurs in `erofs_io_pwrite`. This fixes this issue.

Signed-off-by: Hongzhen Luo <hongzhen@linux.alibaba.com>
---
 lib/io.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/lib/io.c b/lib/io.c
index c523f00..52a74dc 100644
--- a/lib/io.c
+++ b/lib/io.c
@@ -34,15 +34,18 @@ ssize_t erofs_io_pwrite(struct erofs_vfile *vf, const void *buf,
 	if (unlikely(cfg.c_dry_run))
 		return 0;
 
-	if (vf->ops)
-		return vf->ops->pwrite(vf, buf, pos, len);
-
 	pos += vf->offset;
 	do {
 #ifdef HAVE_PWRITE64
-		ret = pwrite64(vf->fd, buf, len, (off64_t)pos);
+		if (vf->ops)
+			ret = vf->ops->pwrite(vf, buf, pos, len);
+		else
+			ret = pwrite64(vf->fd, buf, len, (off64_t)pos);
 #else
-		ret = pwrite(vf->fd, buf, len, (off_t)pos);
+		if (vf->ops)
+			ret = vf->ops->pwrite(vf, buf, pos, len);
+		else
+			ret = pwrite(vf->fd, buf, len, (off_t)pos);
 #endif
 		if (ret <= 0) {
 			erofs_err("failed to write: %s", strerror(errno));
@@ -130,15 +133,18 @@ ssize_t erofs_io_pread(struct erofs_vfile *vf, void *buf, u64 pos, size_t len)
 	if (unlikely(cfg.c_dry_run))
 		return 0;
 
-	if (vf->ops)
-		return vf->ops->pread(vf, buf, pos, len);
-
 	pos += vf->offset;
 	do {
 #ifdef HAVE_PREAD64
-		ret = pread64(vf->fd, buf, len, (off64_t)pos);
+		if (vf->ops)
+			ret = vf->ops->pread(vf, buf, pos, len);
+		else
+			ret = pread64(vf->fd, buf, len, (off64_t)pos);
 #else
-		ret = pread(vf->fd, buf, len, (off_t)pos);
+		if (vf->ops)
+			ret = vf->ops->pread(vf, buf, pos, len);
+		else
+			ret = pread(vf->fd, buf, len, (off_t)pos);
 #endif
 		if (ret <= 0) {
 			if (!ret) {
-- 
2.39.3

