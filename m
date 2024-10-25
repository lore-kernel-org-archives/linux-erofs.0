Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E582DD1038E
	for <linux-erofs@archiver.kernel.org>; Fri, 25 Oct 2024 01:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1729821174;
	bh=aCacTjwfF5d6wH/+jDaJeFwXQoPIzUOhS7P1E7UBZwU=;
	h=To:Subject:Date:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=CCOxBM9GImuuRlvCBiM8/s1LdhKifu1w7K3JLAd10w88sO25ZZwtkufyrP+J2phiY
	 W8xluxH3urQR78N4nyZ5/bN6hkPI7ePk+UqXJRCisrl+TzxlPkwPKJipapgV7I1SZE
	 mo9Lq7gtDtB/ILAaQHYLkWQLLqVJufS36+M2k13zs7Fj/Ulv/ApWYTBU4K7uAD4RQ+
	 C8Tc84QDfHVNWDZql9ivFmkiKZ4kqnVxdvWulVBOYiCRSe0gcCWVjBrkANbqoakP5o
	 g4ciAvaqIr+BhALN80JH46FAV2DyitTmmW8JM0jyYrhnSBbZz8UdfG4Zv7F+2TNfii
	 0DS/o/fGKrFlg==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4XZQlp1HtBz2y8g
	for <linux-erofs@archiver.kernel.org>; Fri, 25 Oct 2024 12:52:54 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=118.143.206.90
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1729821171;
	cv=none; b=ItM0b7PUngBe/Ie2isI/aNQNPttpfTq5qi4CDFyjSvYkJkInw/1XbLYZbnEJinuBELIlAUfjvsv2JGxJwS41R6IbUYlpaBlQCcE8au8bqNQqf8X1dPhcP0yWUobRB+jvtAbEZw2j2vv/IOZ4hpWFT5WUN/c/0hAsRfS7mmWIauTps7S0BegOmQ2+0gKxgHGDdFLiQSf+iEQsKfP4LysqApcXR1FqXMVKXDmIILonZAVibfYGUfWeg7AEiKzeLy2BupVoqVqwrI8L2uOY6TbNl+Lz+sviVZKNuvIMkeD7TULZLV2/tzGoN/JCmWw9t2LRwjKZW+KVOZ0UCZHPIcPtSw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1729821171; c=relaxed/relaxed;
	bh=aCacTjwfF5d6wH/+jDaJeFwXQoPIzUOhS7P1E7UBZwU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SRbR1BdTazQQkveh8niujaF9jVWFOS8RPsE+LFoHon720EnK19ughmip1fdp6vjAvX6I1w81MD3abgGDhAQUm0RxVLPffjLGfYgTUH99mf8V6O4uhn4xMojWQIvsMm4lyqnzob7vpFOc/xEGC1lDWy5dSrwB9BzSDSneuIOZKIy99izVF1fhgCLq90jAXwDskceyf+KRz6KsAE4DskqSGTxXuy4ltKRSfsAtbRorXmYbkA5VAVbuR6KeJoUzrM172jasTppDXskaU3sVUbf3XD9gnGuqw0nkYX0NPKc9whCMYxGtui7m7SN6IR6gpRIpjg7Wwm9izGDFrXqqeb9Yrw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com; spf=pass (client-ip=118.143.206.90; helo=outboundhk.mxmail.xiaomi.com; envelope-from=huangjianan@xiaomi.com; receiver=lists.ozlabs.org) smtp.mailfrom=xiaomi.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=xiaomi.com (client-ip=118.143.206.90; helo=outboundhk.mxmail.xiaomi.com; envelope-from=huangjianan@xiaomi.com; receiver=lists.ozlabs.org)
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [118.143.206.90])
	by lists.ozlabs.org (Postfix) with ESMTP id 4XZQlk2XyNz2xKh
	for <linux-erofs@lists.ozlabs.org>; Fri, 25 Oct 2024 12:52:49 +1100 (AEDT)
X-CSE-ConnectionGUID: OfqGhIngSqCNJ8LrF3ePjA==
X-CSE-MsgGUID: slA/1WHCSoWtvpXyB2sVwQ==
X-IronPort-AV: E=Sophos;i="6.11,230,1725292800"; 
   d="scan'208";a="99599575"
To: <linux-erofs@lists.ozlabs.org>
Subject: [PATCH v2] erofs-utils: avoid allocating large arrays on the stack
Date: Fri, 25 Oct 2024 09:52:46 +0800
Message-ID: <20241025015246.649209-1-huangjianan@xiaomi.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.237.8.19]
X-ClientProxiedBy: BJ-MBX05.mioffice.cn (10.237.8.125) To YZ-MBX05.mioffice.cn
 (10.237.88.125)
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
From: Jianan Huang via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Jianan Huang <huangjianan@xiaomi.com>
Cc: zhaoyifan@sjtu.edu.cn
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

The default pthread stack size of bionic is 1M. Use malloc to avoid
stack overflow.

Signed-off-by: Jianan Huang <huangjianan@xiaomi.com>
---
Changes since v1:
- Move the allocation and free tmp when exiting, which was mentioned by Sandeep.

 lib/compress.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/lib/compress.c b/lib/compress.c
index cbd4620..d75e9c3 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -451,31 +451,39 @@ static int z_erofs_fill_inline_data(struct erofs_inode *inode, void *data,
 	return len;
 }
 
-static void tryrecompress_trailing(struct z_erofs_compress_sctx *ctx,
-				   struct erofs_compress *ec,
-				   void *in, unsigned int *insize,
-				   void *out, unsigned int *compressedsize)
+static int tryrecompress_trailing(struct z_erofs_compress_sctx *ctx,
+				  struct erofs_compress *ec,
+				  void *in, unsigned int *insize,
+				  void *out, unsigned int *compressedsize)
 {
 	struct erofs_sb_info *sbi = ctx->ictx->inode->sbi;
-	char tmp[Z_EROFS_PCLUSTER_MAX_SIZE];
+	char *tmp;
 	unsigned int count;
 	int ret = *compressedsize;
 
 	/* no need to recompress */
 	if (!(ret & (erofs_blksiz(sbi) - 1)))
-		return;
+		return 0;
+
+	tmp = malloc(Z_EROFS_PCLUSTER_MAX_SIZE);
+	if (!tmp)
+		return -ENOMEM;
 
 	count = *insize;
 	ret = erofs_compress_destsize(ec, in, &count, (void *)tmp,
 				      rounddown(ret, erofs_blksiz(sbi)));
 	if (ret <= 0 || ret + (*insize - count) >=
 			roundup(*compressedsize, erofs_blksiz(sbi)))
-		return;
+		goto out;
 
 	/* replace the original compressed data if any gain */
 	memcpy(out, tmp, ret);
 	*insize = count;
 	*compressedsize = ret;
+
+out:
+	free(tmp);
+	return 0;
 }
 
 static bool z_erofs_fixup_deduped_fragment(struct z_erofs_compress_sctx *ctx,
@@ -631,9 +639,14 @@ frag_packing:
 			goto fix_dedupedfrag;
 		}
 
-		if (may_inline && len == e->length)
-			tryrecompress_trailing(ctx, h, ctx->queue + ctx->head,
-					&e->length, dst, &compressedsize);
+		if (may_inline && len == e->length) {
+			ret = tryrecompress_trailing(ctx, h,
+						     ctx->queue + ctx->head,
+						     &e->length, dst,
+						     &compressedsize);
+			if (ret)
+				return ret;
+		}
 
 		e->compressedblks = BLK_ROUND_UP(sbi, compressedsize);
 		DBG_BUGON(e->compressedblks * blksz >= e->length);
-- 
2.43.0

