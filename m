Return-Path: <linux-erofs+bounces-4089-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 425E6C55179
	for <linux-erofs@archiver.kernel.org>; Mon,  3 Aug 2026 11:52:45 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDFRF14h1z30F3;
	Mon, 03 Aug 2026 21:52:41 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=37.120.164.117
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785757961;
	cv=none; b=XOvdGLVzJxv9SBng9ojNrXhRF1cPHHSwdLu7Bi/zRqP0z8wk46Kip41jKavSeQXk6QwA4e6YDusJswj6mL2HZxMRMd6lPJa/BYf32IB7MqEmhxgZxWMfuitzQ3dsHmFRVCnFprpsZ6O5FbwoAha/L0v2S/6PcAsQgUTramJIvkU6pXHnm1rY7bQ7yT4Ia60QAqqtk6TTjyz6pRIerdhrZfXPCLrXs5snG1qCVV7DTr4DJqMIQrAV9d4fB7G5Lu06Cys+W97CsXV8guQsao+IKvzbVt8M03WLRWx8SXVgRClyN/CV3fKzTVW5oEcZ4+KcUD41lETkfBG+bvFieV26ng==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785757961; c=relaxed/relaxed;
	bh=t7S0PKkjdXY65OgGDSaFsWJkFn5Kx+3DiznMLPgFcQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mj/+jfBp5H/hxhtZvxyANRZ9clqV1f60K5QLYyawS4lug25CQAyIsr5Myx4KYlUdeHaj7fAarNaCkJudO8HBvy0GzVujRjyqf99i7vwkwxxQfDGFn6HuOKzWP3REKgBm7dENnKMFhUUngot/rr0XsJ4eMlz8foOF8PoqwG2aVFC9L0E1jOXFtN7uv3c/ah+6NpaT9432rj3ftUddmwitrZ9/0bu/sgBwiNpysLx0wfm5WgQJ+lLFfqLYLVxcwbXF6soUAAzaD7sReVYgupnW7w1OcumQLhVlfS9I1BwVtoiEiD45mKlux1bJml3hqKslJTn8N/gzGSph9zuWKUM2Zg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=piware.de; dkim=pass (2048-bit key; unprotected) header.d=piware.de header.i=@piware.de header.a=rsa-sha256 header.s=2025 header.b=k+SLorcJ; dkim-atps=neutral; spf=pass (client-ip=37.120.164.117; helo=mail.piware.de; envelope-from=martin@piware.de; receiver=lists.ozlabs.org) smtp.mailfrom=piware.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=piware.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=piware.de header.i=@piware.de header.a=rsa-sha256 header.s=2025 header.b=k+SLorcJ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=piware.de (client-ip=37.120.164.117; helo=mail.piware.de; envelope-from=martin@piware.de; receiver=lists.ozlabs.org)
Received: from mail.piware.de (mail.piware.de [37.120.164.117])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDFRD3Bcdz30Dq
	for <linux-erofs@lists.ozlabs.org>; Mon, 03 Aug 2026 21:52:40 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=piware.de; s=2025;
	t=1785757958; bh=wEfYaKLNY8AbR8sRcSC3xZ/xywPu6mZ0Ah1c2r7t4jw=;
	h=Date:From:To:Cc:Subject:From;
	b=k+SLorcJuEyiW9Tvx+Joux0fH8NU4I4laCwDQ9WwHCsBANFInkT6I1l//B5A8el6S
	 9q6VpWHsvMLA5Ei+IpdencoGC3qxGyoxrJQl3bcYRKT9esOVfGwhKtEGBV3DbG7YYY
	 0KTQqD/Dp4eUpVdEIiLL19n1VVngsWrqivKmRghzcTPvYUuubOiVordAjalbtRK9+I
	 FsCeDQpRWoHsuTDz6WSM921ROV+BGJRUoinvXUkcdaNopFRRI1EmR6y8Qo6mZjwqW/
	 Mqj8v67X8ML9IGD4tswtrduDpJ2dh4gXDHJiEpEDpq8dxbXeQTet56P2ag1/E7TsvB
	 xb87Ne6XDTM7A==
Received: from piware.de (localhost [127.0.0.1])
	by mail.piware.de (Postfix) with SMTP id 9A3F9FF866;
	Mon, 03 Aug 2026 13:52:38 +0200 (CEST)
Date: Mon, 3 Aug 2026 13:52:37 +0200
From: Martin Pitt <martin@piware.de>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>, Yifan Zhao <zhaoyifan28@huawei.com>
Subject: [PATCH v2] erofs-utils: mkfs: emit an inode's xattrs in a canonical
 order
Message-ID: <anCBBdM7yw9Mm3xg@piware.de>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

listxattr(2) makes no promise about the order it reports, and
filesystems disagree: tmpfs reports them in insertion order on recent
kernels (or in a random order on older ones), while ext4 and btrfs
report their own on-disk order.

mkfs.erofs stored an inode's attributes in exactly the order it received
them, so staging the same tree on different filesystems (or on older
kernels merely twice in the same place) produced images that differed
byte for byte. That made EROFS images unreproducible.

Insert into the inode's list ordered by attribute name instead, and move
inline attributes onto the on-stack list with list_add_tail() so the
emitted order matches. The shared attribute pool already sorts by the
same key, so generalize comp_shared_xattritem() into
erofs_comp_xattritem() and use it for both.

The length tiebreak previously returned only 0 or 1, never a negative
value; make it a proper three-way comparison with cmpsgn().

Suggested-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Martin Pitt <martin@amutable.com>
---
v1: https://lore.kernel.org/linux-erofs/ampZ6MVV1nN3YzQ_@piware.de

v2:
 - Reuse the shared pool's comparator for the per-inode list, as suggested by
   Gao Xiang, instead of adding a separate comp_inode_xattritem().
 - Use cmpsgn() for the length tiebreak, which returned only 0 or 1 before.
 - Reword the commit message: the order differs between filesystems, it is not
   specific to tmpfs varying it per inode. Measured with Fedora kernels,
   7.1.4-204.fc44 reports a random order per inode on tmpfs while
   7.1.5-201.fc44 reports insertion order.

Verified with a script that stages the same tree, with ten user.validatefs.*
attributes on the root inode, in /tmp (tmpfs) and /var/tmp (disk backed), and
compares the resulting images: 1.9.2 produces four distinct images from six
identical trees, this patch produces one. Three attributes are not enough to
expose an ordering bug, which is why the script sets ten.

 lib/xattr.c | 54 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 23 deletions(-)

diff --git a/lib/xattr.c b/lib/xattr.c
index 051fdd8..f6bd8de 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -400,17 +400,43 @@ static struct erofs_xattritem *erofs_get_selabel_xattr(struct erofs_sb_info *sbi
 	return NULL;
 }
 
+static int erofs_comp_xattritem(const void *a, const void *b)
+{
+	const struct erofs_xattritem *ia, *ib;
+	unsigned int la, lb;
+	int ret;
+
+	ia = *((const struct erofs_xattritem **)a);
+	ib = *((const struct erofs_xattritem **)b);
+	la = EROFS_XATTR_KVSIZE(ia->len);
+	lb = EROFS_XATTR_KVSIZE(ib->len);
+
+	ret = memcmp(ia->kvbuf, ib->kvbuf, min(la, lb));
+	if (ret != 0)
+		return ret;
+	return cmpsgn(la, lb);
+}
+
 static int erofs_inode_xattr_add(struct list_head *hlist,
 				 struct erofs_xattritem *item)
 {
-	struct erofs_inode_xattr_node *node;
+	struct erofs_inode_xattr_node *node, *pos;
 
 	node = malloc(sizeof(*node));
 	if (!node)
 		return -ENOMEM;
 	init_list_head(&node->list);
 	node->item = item;
-	list_add(&node->list, hlist);
+
+	/*
+	 * Order each inode's xattrs by name so that images stay reproducible.
+	 * listxattr(2) makes no promise about the order it reports, and
+	 * filesystems disagree: insertion order, on-disk order, or random.
+	 */
+	list_for_each_entry(pos, hlist, list)
+		if (erofs_comp_xattritem(&item, &pos->item) < 0)
+			break;
+	list_add_tail(&node->list, &pos->list);
 	return 0;
 }
 
@@ -843,24 +869,6 @@ static unsigned int erofs_cleanxattrs(struct erofs_xattrmgr *xamgr,
 	return count;
 }
 
-static int comp_shared_xattritem(const void *a, const void *b)
-{
-	const struct erofs_xattritem *ia, *ib;
-	unsigned int la, lb;
-	int ret;
-
-	ia = *((const struct erofs_xattritem **)a);
-	ib = *((const struct erofs_xattritem **)b);
-	la = EROFS_XATTR_KVSIZE(ia->len);
-	lb = EROFS_XATTR_KVSIZE(ib->len);
-
-	ret = memcmp(ia->kvbuf, ib->kvbuf, min(la, lb));
-	if (ret != 0)
-		return ret;
-
-	return la > lb;
-}
-
 int erofs_xattr_flush_name_prefixes(struct erofs_importer *im, bool plain)
 {
 	const struct erofs_importer_params *params = im->params;
@@ -1010,7 +1018,7 @@ int erofs_load_shared_xattrs_from_path(struct erofs_sb_info *sbi, const char *pa
 	}
 	DBG_BUGON(i != sharedxattr_count);
 	sorted_n[i] = NULL;
-	qsort(sorted_n, sharedxattr_count, sizeof(n), comp_shared_xattritem);
+	qsort(sorted_n, sharedxattr_count, sizeof(n), erofs_comp_xattritem);
 
 	buf = calloc(1, shared_xattrs_size);
 	if (!buf) {
@@ -1091,10 +1099,10 @@ char *erofs_export_xattr_ibody(struct erofs_inode *inode)
 		item = node->item;
 		list_del(&node->list);
 
-		/* move inline xattrs to the onstack list */
+		/* move inline xattrs to the onstack list, order preserved */
 		if (item->shared_xattr_id < 0 ||
 		    header->h_shared_count >= UCHAR_MAX) {
-			list_add(&node->list, &ilst);
+			list_add_tail(&node->list, &ilst);
 			continue;
 		}
 
-- 
2.55.0


