Return-Path: <linux-erofs+bounces-3934-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1418C44520
	for <linux-erofs@archiver.kernel.org>; Fri, 17 Jul 2026 13:42:32 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h1rgp4HDSz2yXj;
	Fri, 17 Jul 2026 23:42:30 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784295750;
	cv=none; b=klANoKFEif7HZvCGukBXj+5P++wWPPEXXAVoLz8V5cz8zXbd5EPb+iITkXZCFS/PzOXgLzOHUlKVoGA4nZy0Xfxv/NJX7uc8tqp0Jo8cXVXjq80lfk0Talu0RZ5fj0FSDHBw8DK3+aHHpnP5WU+3kpj1GV9olCB2Lay/aD14nhlm41AJG1Fbg336D/Ljd5eaMiJ8qz4xji+L4zbzvyNhYxDQMV/DV9T05fgI1TnpAmMtRcT72b2HusJ/DFac0jQhHqcQdM1Ehy5qnl7aDR/2NAKWYzHE223L8iraYUOx8Y9v0eaJkeBy+0Nw8wikJTVIgnaLDRHijX9tm8TehO4gfg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784295750; c=relaxed/relaxed;
	bh=Oqnwk+Ww73hw4SwNzeOMk3YCD7GJsJkOlNNaA2vZRuo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=lmKTawS2Qi9PeeTrU/EbvNkNepK1uifBav4cxk8A5V/nCyBJKtw0sIVrvZEn7BEPFD0u8Z3ZMCwIPppmOLwUwiq3u5V3UpC+xHWJJy3/agZAljECWOCCHSAjyDXhd9Ztcc+7jzDLXxHzupL0G/H3vZRZuBoRqfKiWzClifaDPLoK0MfvL2SGuMcl7miYoH+sCx+McpRQ1YbxrTxKWcyiShOMYgU1Vmcjg9c9p2B1rWOD5IX6OflaWGGzMxgLmongjdBGg+po2LLuRS+/AIHlZC/dTAKoTwrJlP2alLiWahG0JEA83ddoZTSogxyiE3dL2Ed6Td8/ky9/MdV6u0E84w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cTPGPmy5; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=f1kcA3Xq; dkim-atps=neutral; spf=permerror (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cTPGPmy5;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=f1kcA3Xq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=permerror (SPF Permanent Error: Void lookup limit of 2 exceeded) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h1rgn0kpjz2yR5
	for <linux-erofs@lists.ozlabs.org>; Fri, 17 Jul 2026 23:42:26 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784295741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Oqnwk+Ww73hw4SwNzeOMk3YCD7GJsJkOlNNaA2vZRuo=;
	b=cTPGPmy5U6CI+AID8waO4kp7M2lYnMmCb9ON24ZjHC8pVZLCeQQmi0TDoEHGIl9G+BcFSh
	hEPVXJtbYIJHc7i2p9GxlCiw2BUiHHtoyzHdqcwTLYQdnflIoA/EcFWf1/r+Q5Z48PICzQ
	lxRZmTsQrnVKhkwEn2J4zLtzkhXVV5E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784295742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Oqnwk+Ww73hw4SwNzeOMk3YCD7GJsJkOlNNaA2vZRuo=;
	b=f1kcA3XqeaYnKQBMrdDtBlXle0t0TeNJhfVRc6PuE00C7sYX5uhmXnMmcxMzjaA2/Z0Bkr
	ztiuFbR/2Qo+dhZOKQJHiHh6esxCwdb7h4TxpFP6KkWkATiCg+KdCBV6DVDuyJthPaaFvV
	GwjKzpufoIoKRQhc12lPl4hcsfneraU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-PKyWmbRXNYyarkCzcoCWqA-1; Fri,
 17 Jul 2026 09:42:01 -0400
X-MC-Unique: PKyWmbRXNYyarkCzcoCWqA-1
X-Mimecast-MFC-AGG-ID: PKyWmbRXNYyarkCzcoCWqA_1784295720
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D909F195D00E;
	Fri, 17 Jul 2026 13:41:59 +0000 (UTC)
Received: from oxygen.redhat.com (unknown [10.44.33.219])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E5906180058F;
	Fri, 17 Jul 2026 13:41:57 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: linux-erofs@lists.ozlabs.org
Cc: cyphar@cyphar.com,
	hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org,
	gscrivan@redhat.com
Subject: [PATCH v4] erofs: accept source file descriptor via fsconfig
Date: Fri, 17 Jul 2026 15:41:27 +0200
Message-ID: <20260717134147.1602735-1-gscrivan@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: xO-9xEWJNhBVpPEkknushEWKMejotMxMdoiSlxF6KAE_1784295720
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Allow userspace to pass an already-opened file descriptor as the mount
source instead of a path string.  This is useful for tools that already
hold an fd to the image, such as composefs reusing an existing erofs
backing file.

Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
---
v3: https://lore.kernel.org/linux-fsdevel/20260714154917.489993-1-gscrivan@redhat.com/
v2: https://lore.kernel.org/linux-fsdevel/20260711071137.4130824-1-gscrivan@redhat.com/
v1: https://lore.kernel.org/linux-fsdevel/ak5GfvVfWLJU1EwK@debian/

 fs/erofs/super.c | 73 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 62 insertions(+), 11 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 86fa5c6a0c70..558041011398 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -386,6 +386,7 @@ static void erofs_default_options(struct erofs_sb_info *sbi)
 enum {
 	Opt_user_xattr, Opt_acl, Opt_cache_strategy, Opt_dax, Opt_dax_enum,
 	Opt_device, Opt_domain_id, Opt_directio, Opt_fsoffset, Opt_inode_share,
+	Opt_source,
 };
 
 static const struct constant_table erofs_param_cache_strategy[] = {
@@ -402,17 +403,18 @@ static const struct constant_table erofs_dax_param_enums[] = {
 };
 
 static const struct fs_parameter_spec erofs_fs_parameters[] = {
-	fsparam_flag_no("user_xattr",	Opt_user_xattr),
-	fsparam_flag_no("acl",		Opt_acl),
-	fsparam_enum("cache_strategy",	Opt_cache_strategy,
+	fsparam_flag_no("user_xattr",		Opt_user_xattr),
+	fsparam_flag_no("acl",			Opt_acl),
+	fsparam_enum("cache_strategy",		Opt_cache_strategy,
 		     erofs_param_cache_strategy),
-	fsparam_flag("dax",             Opt_dax),
-	fsparam_enum("dax",		Opt_dax_enum, erofs_dax_param_enums),
-	fsparam_string("device",	Opt_device),
-	fsparam_string("domain_id",	Opt_domain_id),
-	fsparam_flag_no("directio",	Opt_directio),
-	fsparam_u64("fsoffset",		Opt_fsoffset),
-	fsparam_flag("inode_share",	Opt_inode_share),
+	fsparam_flag("dax",			Opt_dax),
+	fsparam_enum("dax",			Opt_dax_enum, erofs_dax_param_enums),
+	fsparam_string("device",		Opt_device),
+	fsparam_string("domain_id",		Opt_domain_id),
+	fsparam_flag_no("directio",		Opt_directio),
+	fsparam_u64("fsoffset",			Opt_fsoffset),
+	fsparam_flag("inode_share",		Opt_inode_share),
+	fsparam_file_or_string("source",	Opt_source),
 	{}
 };
 
@@ -437,6 +439,40 @@ static bool erofs_fc_set_dax_mode(struct fs_context *fc, unsigned int mode)
 	return false;
 }
 
+static int erofs_fc_parse_source(struct fs_context *fc,
+				 struct fs_parameter *param)
+{
+	struct erofs_sb_info *sbi = fc->s_fs_info;
+
+	if (fc->source || sbi->dif0.file)
+		return invalf(fc, "Multiple sources");
+
+	switch (param->type) {
+	case fs_value_is_string:
+		fc->source = param->string;
+		param->string = NULL;
+		return 0;
+	case fs_value_is_file: {
+		char *buf __free(kfree) = kmalloc(PATH_MAX, GFP_KERNEL);
+		char *p;
+
+		if (!buf)
+			return -ENOMEM;
+		p = file_path(param->file, buf, PATH_MAX);
+		if (IS_ERR(p))
+			return PTR_ERR(p);
+		fc->source = kstrdup(p, GFP_KERNEL);
+		if (!fc->source)
+			return -ENOMEM;
+		sbi->dif0.file = no_free_ptr(param->file);
+		return 0;
+	}
+	default:
+		WARN_ON_ONCE(true);
+		return -EINVAL;
+	}
+}
+
 static int erofs_fc_parse_param(struct fs_context *fc,
 				struct fs_parameter *param)
 {
@@ -524,6 +560,8 @@ static int erofs_fc_parse_param(struct fs_context *fc,
 		else
 			set_opt(&sbi->opt, INODE_SHARE);
 		break;
+	case Opt_source:
+		return erofs_fc_parse_source(fc, param);
 	}
 	return 0;
 }
@@ -752,13 +790,26 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 
 static int erofs_fc_get_tree(struct fs_context *fc)
 {
+	struct erofs_sb_info *sbi = fc->s_fs_info;
 	int ret;
 
+	if (sbi->dif0.file) {
+		if (!IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE)) {
+			errorfc(fc, "source fd option not supported");
+			return -EINVAL;
+		}
+		if (!S_ISREG(file_inode(sbi->dif0.file)->i_mode) ||
+		    !sbi->dif0.file->f_mapping->a_ops->read_folio) {
+			errorfc(fc, "source is unsupported");
+			return -EINVAL;
+		}
+		return get_tree_nodev(fc, erofs_fc_fill_super);
+	}
+
 	ret = get_tree_bdev_flags(fc, erofs_fc_fill_super,
 		IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) ?
 			GET_TREE_BDEV_QUIET_LOOKUP : 0);
 	if (IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) && ret == -ENOTBLK) {
-		struct erofs_sb_info *sbi = fc->s_fs_info;
 		struct file *file;
 
 		if (!fc->source)
-- 
2.55.0


