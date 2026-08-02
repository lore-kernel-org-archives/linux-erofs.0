Return-Path: <linux-erofs+bounces-4081-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28AEEC55162
	for <linux-erofs@archiver.kernel.org>; Sun,  2 Aug 2026 13:30:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hCgfP32Qfz2yhD;
	Sun, 02 Aug 2026 23:30:21 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785677421;
	cv=none; b=GcoclCELHeAmBJMJCcXuha6diEjcG60u3o7AdPjq+hEc8ShR3JvfAOC/UH9xIyIgn3yXqrbes+STmkb+zH3y1ecpku07A6SAcGH2ZXHwYzsqz/8WdlJsxC6ymKEug4lzBA5+8FO7ntJuqba3gvCoTY0TgUgmWv47fLlpvnBQNgeaZFYbdiWGcOpuEcb25pGV1tg5X7CFt/4X1sUC/1lfoQjqiHm4whi6HiNVERK8P0x58qAoKCiIHcJQGJNR7b61qHgSD9/prg6oPI4qVVhh/dMvGze+hHhnmfeWt1rD1yoJMcnMLlq5DJbiO+soSTe5yIX4NFRDGlKrRSQl41Kk5g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785677421; c=relaxed/relaxed;
	bh=32WFtoJYrT1ev5zp+qz9lc1y5HRwtO/8VuA8v9ZZbnk=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TGQm9he+HLMoYzZym+YgEujv0QD1Eyp2xL0cS5/8/eocuH0xGUzwfW3TwrusFHOobD2RRKS+AXXRU/JtPPF+unyczDWAajJdsMKKSazBpK1EFFJWYcdVFGv/zma1E2nwCgtrkcHUT4uXechYEguPZ+t1sXmA8VFCIYomEXaxLXT/cQGmk6Pfj8omWUEK7ylR0YwOt2OvP1sABZRxtnEDrc2OCMzpyVsawVAPsVHmomE/WDn6rSPL0NHOg2Ga2nEZnWAtAbEjmh1Hc4P4UIUbpm14jeeIo1v0Z88Cr4OJHARa5R6N3mllqFJTDmp00dThdeannr640XjKEmhFKF7kvQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l3ZQY98U; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l3ZQY98U;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hCgfN4JSvz2ygp
	for <linux-erofs@lists.ozlabs.org>; Sun, 02 Aug 2026 23:30:20 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8434060DC3;
	Sun,  2 Aug 2026 13:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429871F000E9;
	Sun,  2 Aug 2026 13:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785677418;
	bh=32WFtoJYrT1ev5zp+qz9lc1y5HRwtO/8VuA8v9ZZbnk=;
	h=Date:From:To:Subject:References:In-Reply-To;
	b=l3ZQY98UR1w6IsG78BEzfolgUFoLdwioCFfo99JaLO2tirBxaLwPJ7Q1lliXEbjCr
	 UeuLtJotZMGaA6g8H4SQe5Bl1l1ISfQfEk3/BXByjdVsy2mF0eYr2nQMnwwicD6Pvc
	 NTb8Pu4sj4ZlDhVltSVsm/u9X6AzcZGq9uhw//UTjvd7Tm7euw5oLeqRPDY1yeO+hG
	 B5UOkuadzRSMswUwgkrIzhPY1zMQu4QXWZgMhd0OOk98P+vz4uS04KRCmFnuq5G0UU
	 hH9CGU50bg5m1DjF+K0HqKiwT4UYYlZpYzpXGOGCSoQGpUZNCSVLlOwkGlR8UQTKpw
	 6fbVJHW4SX8bg==
Date: Sun, 2 Aug 2026 21:30:12 +0800
From: Gao Xiang <xiang@kernel.org>
To: Martin Pitt <martin@piware.de>, linux-erofs@lists.ozlabs.org,
	Gao Xiang <xiang@kernel.org>, Yifan Zhao <zhaoyifan28@huawei.com>
Subject: Re: [PATCH] erofs-utils: mkfs: emit an inode's xattrs in a canonical
 order
Message-ID: <am9GZFlgLYn9HFci@XiangdeMacBook-Pro.local>
Mail-Followup-To: Martin Pitt <martin@piware.de>,
	linux-erofs@lists.ozlabs.org, Gao Xiang <xiang@kernel.org>,
	Yifan Zhao <zhaoyifan28@huawei.com>
References: <ampZ6MVV1nN3YzQ_@piware.de>
 <am9FM_v9vAAzlR5H@XiangdeMacBook-Pro.local>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <am9FM_v9vAAzlR5H@XiangdeMacBook-Pro.local>

On Sun, Aug 02, 2026 at 09:25:07PM +0800, Gao Xiang wrote:
> Hi Martin,
> 
> On Wed, Jul 29, 2026 at 09:52:08PM +0200, Martin Pitt wrote:
> > listxattr(2) makes no promise about the order it reports: while e.g.
> > ext4 returns a reproducible order, tmpfs varies it from inode to inode,
> > so building the same tree twice can lay the same set of xattrs out
> > differently and yield images that differ byte for byte. This makes the
> > erofs images unreproducible.
> > 
> > Insert into the inode's list ordered by attribute name instead, and move
> > inline attributes onto the on-stack list with list_add_tail() so the
> > emitted order matches. This is the same approach as the shared attribute
> > pool already does with comp_shared_xattritem().
> > 
> > Signed-off-by: Martin Pitt <martin@amutable.com>
> 
> Thanks for the patch!
> 
> I wonder if the following diff works too (but untested):
> 

...

> 
> Since I'd like to unify comp_shared_xattritem, if yes, could you resend
> a new version (or if some bug happens) as this so I could merge this.
> 

Sorry... It should be 

diff --git a/lib/xattr.c b/lib/xattr.c
index a9486e4..6a8775b 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -400,17 +400,44 @@ static struct erofs_xattritem *erofs_get_selabel_xattr(struct erofs_sb_info *sbi
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
+	 * Keep each inode's xattrs ordered by name.  listxattr(2) makes no
+	 * promise about the order it reports, and tmpfs varies it from inode
+	 * to inode, so appending in listing order would emit the same set of
+	 * xattrs differently from run to run and make images unreproducible.
+	 */
+	list_for_each_entry(pos, hlist, list)
+		if (erofs_comp_xattritem(item, pos->item) < 0)
+			break;
+	list_add_tail(&node->list, &pos->list);
 	return 0;
 }
 
@@ -848,24 +875,6 @@ static unsigned int erofs_cleanxattrs(struct erofs_xattrmgr *xamgr,
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
@@ -1015,7 +1024,7 @@ int erofs_load_shared_xattrs_from_path(struct erofs_sb_info *sbi, const char *pa
 	}
 	DBG_BUGON(i != sharedxattr_count);
 	sorted_n[i] = NULL;
-	qsort(sorted_n, sharedxattr_count, sizeof(n), comp_shared_xattritem);
+	qsort(sorted_n, sharedxattr_count, sizeof(n), erofs_comp_xattritem);
 
 	buf = calloc(1, shared_xattrs_size);
 	if (!buf) {
@@ -1096,10 +1105,10 @@ char *erofs_export_xattr_ibody(struct erofs_inode *inode)
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
 

