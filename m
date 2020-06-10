Return-Path: <SRS0=Rf/i=7X=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7645CC433E0
	for <linux-erofs@archiver.kernel.org>; Wed, 10 Jun 2020 17:17:52 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2A90620734
	for <linux-erofs@archiver.kernel.org>; Wed, 10 Jun 2020 17:17:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="nQbeXdt0";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="bBbQnwrM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A90620734
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 49htwZ1wVgzDqld
	for <linux-erofs@archiver.kernel.org>; Thu, 11 Jun 2020 03:17:50 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1591809470;
	bh=wyBe8SWYiQXrM+Pfciz6JIxBK4q1b1+aEsgW4YtWsgg=;
	h=To:Subject:Date:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=nQbeXdt04kVpObRWtQ1pPxK9x1w1X9e+xsD+kUsy4NVY/gveOW1BwXPjMAaXkudHF
	 LQlilPdpGi+ET4x0QpYz2AR4eUhiHQdkRPbFdU/+5RVPMsFB2JvEe7d5Xw6qAkDQfh
	 a/b+scDxvPGIvBW0piuFFbs7+LfgKr1sxCTmpIZLpaqTMDbdgqzJYnVnHL0ZBaSFkl
	 6JAwFWSeGqj1/ejPD5K2QwKi/hkZoXVJ7hP1xMChHt28jiAIM1VBJjKAWVKRDAXrz6
	 WFJ3ix/jP8R3/h0Fss5aF0L201rLCI+oOuuo25FJjwYHlaMRNBTzn90Mp8HRmyJyec
	 sQSA6DHNjG7Kw==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.5;
 helo=out30-5.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none)
 header.from=aliyun.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=bBbQnwrM; dkim-atps=neutral
Received: from out30-5.freemail.mail.aliyun.com
 (out30-5.freemail.mail.aliyun.com [115.124.30.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 49htwM212QzDqjW
 for <linux-erofs@lists.ozlabs.org>; Thu, 11 Jun 2020 03:17:38 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1591809452; h=From:To:Subject:Date:Message-Id;
 bh=Biy5C8CKWXJhiFJq1K4bmwKkrKTvxSVxWKs3+E8lbp8=;
 b=bBbQnwrMcknUNNfvMhr7kk3YpSKWyBGajBT+DZxAqK/CoVA/XJFExugxpP+INAv7tQI8Cez1Y7HHncT3xZARAf4wOLmluPM9Z9nF5fqwDGjcP3neTf0qG2HkDNSVJW3OZCd+FkgtGUaXe2EDVwASv4hCbpbkFFUBnklYaC9QJ6s=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.07357959|-1; CH=green;
 DM=|CONTINUE|false|;
 DS=CONTINUE|ham_system_inform|0.0305189-0.00170529-0.967776;
 FP=0|0|0|0|0|-1|-1|-1; HT=e01e04407; MF=bluce.lee@aliyun.com; NM=1; PH=DS;
 RN=3; RT=3; SR=0; TI=SMTPD_---0U.CCo97_1591809451; 
Received: from localhost(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0U.CCo97_1591809451) by smtp.aliyun-inc.com(127.0.0.1);
 Thu, 11 Jun 2020 01:17:31 +0800
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH v3] erofs-utils: introduce segment size to limit the max input
 stream
Date: Thu, 11 Jun 2020 01:17:28 +0800
Message-Id: <20200610171728.7303-1-bluce.lee@aliyun.com>
X-Mailer: git-send-email 2.17.1
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
From: Li Guifu via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Li Guifu <bluce.lee@aliyun.com>
Cc: Li Guifu <bluce.lee@aliyun.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Limit the max input stream size by adding segment compression
(e.g. 4M segment size), it will benefits:
 - more friendly to block diff (and more details about this);
 - it can also be used for parallel compression in the same file.

Signed-off-by: Li Guifu <bluce.lee@aliyun.com>
---
 include/erofs/config.h |  1 +
 lib/compress.c         | 11 +++++++++++
 lib/config.c           |  1 +
 3 files changed, 13 insertions(+)

diff --git a/include/erofs/config.h b/include/erofs/config.h
index 2f09749..9125c1e 100644
--- a/include/erofs/config.h
+++ b/include/erofs/config.h
@@ -36,6 +36,7 @@ struct erofs_configure {
 	char *c_src_path;
 	char *c_compr_alg_master;
 	int c_compr_level_master;
+	unsigned int c_compr_seg_size;	/* max segment compress size */
 	int c_force_inodeversion;
 	/* < 0, xattr disabled and INT_MAX, always use inline xattrs */
 	int c_inline_xattr_tolerance;
diff --git a/lib/compress.c b/lib/compress.c
index 6cc68ed..8fdbfb2 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -32,6 +32,8 @@ struct z_erofs_vle_compress_ctx {
 
 	erofs_blk_t blkaddr;	/* pointing to the next blkaddr */
 	u16 clusterofs;
+	unsigned int comprlimits;
+	unsigned int comr_seg_size;
 };
 
 #define Z_EROFS_LEGACY_MAP_HEADER_SIZE	\
@@ -158,6 +160,12 @@ static int vle_compress_one(struct erofs_inode *inode,
 	while (len) {
 		bool raw;
 
+		if (ctx->comprlimits >= ctx->comr_seg_size ||
+			ctx->comprlimits + EROFS_BLKSIZ >= ctx->comr_seg_size) {
+			ctx->comprlimits = 0;
+			goto nocompression;
+		}
+
 		if (len <= EROFS_BLKSIZ) {
 			if (final)
 				goto nocompression;
@@ -202,6 +210,7 @@ nocompression:
 
 		++ctx->blkaddr;
 		len -= count;
+		ctx->comprlimits += count;
 
 		if (!final && ctx->head >= EROFS_CONFIG_COMPR_MAX_SZ) {
 			const unsigned int qh_aligned =
@@ -422,6 +431,8 @@ int erofs_write_compressed_file(struct erofs_inode *inode)
 	ctx.head = ctx.tail = 0;
 	ctx.clusterofs = 0;
 	remaining = inode->i_size;
+	ctx.comprlimits = 0;
+	ctx.comr_seg_size = cfg.c_compr_seg_size;
 
 	while (remaining) {
 		const u64 readcount = min_t(u64, remaining,
diff --git a/lib/config.c b/lib/config.c
index da0c260..1c39403 100644
--- a/lib/config.c
+++ b/lib/config.c
@@ -23,6 +23,7 @@ void erofs_init_configure(void)
 	cfg.c_force_inodeversion = 0;
 	cfg.c_inline_xattr_tolerance = 2;
 	cfg.c_unix_timestamp = -1;
+	cfg.c_compr_seg_size = 1024U * EROFS_BLKSIZ;
 }
 
 void erofs_show_config(void)
-- 
2.17.1

