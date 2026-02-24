Return-Path: <linux-erofs+bounces-2376-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 624CFEFB806
	for <linux-erofs@archiver.kernel.org>; Tue, 24 Feb 2026 06:02:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fKnDp5n7vz3cG3;
	Tue, 24 Feb 2026 17:02:18 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1771912938;
	cv=none; b=PNr1sjkQqq6CKgSiK8Gb3Yb+RoQhc/gWPuOx/g5DMvoPpXtSo2Z3X2kCfzC+AGARBGlhO8bkXzenarCyB5K4Nl3dsgHEqCD0He97nLzyXsDByKUGYm4WtUa0u8xGH59OuZLEOffPMJREKVYP3duuDcNAjBBbbZp5AiN1+hWGvIVlWvOhKtRbBEZcax2caTCbutnnICQmVbtrOBRbI/mEqw1BlYm+V3h0jlkKs33kyh8QXtJUYKPRFpZJiV13rili0wWWDE2L/hoEA7RgyZlJU2A2QXLGNh/WlCy846uh66HiZpnH0zZC+Le7xIpJMeaLn1lJtwdy2pYKBecS8GJVrA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1771912938; c=relaxed/relaxed;
	bh=d72IK8FD94v5oIf73JuzwpLlGHhcGU66mMANzUwm5/8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OLiZFfWID6eRzseKV8jbeJnC4VeY36y8DjejHcwfQx4/o0NN6pceTXp1lyaMcXyg2ilrZMi3fD9ZyjcrmaFlpAFbaF5m8ECtNdwo82JEzMYzEFNrInhh/qiWrpb580dULgQw5I7rfpRYazhhF8y7MR6KEePPZ3va91vVQLyijX2d+Ug+PQzmPRY74S69ynOuJRHNmOTQUr/z67zurGRc28p8vX+rO+4V5oARryqEqrrW6Pv71Wx0MYsDxITFKV92m9j23DUYm8ljJ8DY18uCov63YF9gzsUq75s4Bpe9mZ8RVFoxxDPSbkhKssRQ2KPfEL4PDBrepqbc7ONQyL0R1A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=bsmGw0R0; dkim-atps=neutral; spf=pass (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=mengferry@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=bsmGw0R0;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=mengferry@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fKnDn2MvMz3cFM
	for <linux-erofs@lists.ozlabs.org>; Tue, 24 Feb 2026 17:02:16 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1771912932; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=d72IK8FD94v5oIf73JuzwpLlGHhcGU66mMANzUwm5/8=;
	b=bsmGw0R0kpAgTkk3Qxh+rYIYl4HTnHQzyCxuGnegFMVoAOPJLdB/mg6wk5iyTGH8bQRa08Tu9wjkwsWWmF4/bfwdDTMgNy+iHFIP4C4teB7DxXpbrcOgq1tqtzVNgo/ZE/VfBUWJ1f+w7+DnPSx3jQBngmCHVcPAncmOAKHL2S0=
Received: from localhost(mailfrom:mengferry@linux.alibaba.com fp:SMTPD_---0WziVzAR_1771912928 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Feb 2026 14:02:11 +0800
From: Ferry Meng <mengferry@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Ferry Meng <mengferry@linux.alibaba.com>
Subject: [PATCH] erofs: remove more unnecessary #ifdefs
Date: Tue, 24 Feb 2026 14:02:07 +0800
Message-Id: <20260224060207.49649-1-mengferry@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
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

Many #ifdefs can be replaced with IS_ENABLED() to improve code
readability.  No functional changes.

Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
---
 fs/erofs/super.c | 85 ++++++++++++++++++++----------------------------
 1 file changed, 36 insertions(+), 49 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 7827e61424b7..961ab6552d31 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -424,26 +424,23 @@ static const struct fs_parameter_spec erofs_fs_parameters[] = {
 
 static bool erofs_fc_set_dax_mode(struct fs_context *fc, unsigned int mode)
 {
-#ifdef CONFIG_FS_DAX
-	struct erofs_sb_info *sbi = fc->s_fs_info;
-
-	switch (mode) {
-	case EROFS_MOUNT_DAX_ALWAYS:
-		set_opt(&sbi->opt, DAX_ALWAYS);
-		clear_opt(&sbi->opt, DAX_NEVER);
-		return true;
-	case EROFS_MOUNT_DAX_NEVER:
-		set_opt(&sbi->opt, DAX_NEVER);
-		clear_opt(&sbi->opt, DAX_ALWAYS);
-		return true;
-	default:
+	if (IS_ENABLED(CONFIG_FS_DAX)) {
+		struct erofs_sb_info *sbi = fc->s_fs_info;
+
+		if (mode == EROFS_MOUNT_DAX_ALWAYS) {
+			set_opt(&sbi->opt, DAX_ALWAYS);
+			clear_opt(&sbi->opt, DAX_NEVER);
+			return true;
+		} else if (mode == EROFS_MOUNT_DAX_NEVER) {
+			set_opt(&sbi->opt, DAX_NEVER);
+			clear_opt(&sbi->opt, DAX_ALWAYS);
+			return true;
+		}
 		DBG_BUGON(1);
 		return false;
 	}
-#else
 	errorfc(fc, "dax options not supported");
 	return false;
-#endif
 }
 
 static int erofs_fc_parse_param(struct fs_context *fc,
@@ -460,31 +457,26 @@ static int erofs_fc_parse_param(struct fs_context *fc,
 
 	switch (opt) {
 	case Opt_user_xattr:
-#ifdef CONFIG_EROFS_FS_XATTR
-		if (result.boolean)
+		if (!IS_ENABLED(CONFIG_EROFS_FS_XATTR))
+			errorfc(fc, "{,no}user_xattr options not supported");
+		else if (result.boolean)
 			set_opt(&sbi->opt, XATTR_USER);
 		else
 			clear_opt(&sbi->opt, XATTR_USER);
-#else
-		errorfc(fc, "{,no}user_xattr options not supported");
-#endif
 		break;
 	case Opt_acl:
-#ifdef CONFIG_EROFS_FS_POSIX_ACL
-		if (result.boolean)
+		if (!IS_ENABLED(CONFIG_EROFS_FS_POSIX_ACL))
+			errorfc(fc, "{,no}acl options not supported");
+		else if (result.boolean)
 			set_opt(&sbi->opt, POSIX_ACL);
 		else
 			clear_opt(&sbi->opt, POSIX_ACL);
-#else
-		errorfc(fc, "{,no}acl options not supported");
-#endif
 		break;
 	case Opt_cache_strategy:
-#ifdef CONFIG_EROFS_FS_ZIP
-		sbi->opt.cache_strategy = result.uint_32;
-#else
-		errorfc(fc, "compression not supported, cache_strategy ignored");
-#endif
+		if (!IS_ENABLED(CONFIG_EROFS_FS_ZIP))
+			errorfc(fc, "compression not supported, cache_strategy ignored");
+		else
+			sbi->opt.cache_strategy = result.uint_32;
 		break;
 	case Opt_dax:
 		if (!erofs_fc_set_dax_mode(fc, EROFS_MOUNT_DAX_ALWAYS))
@@ -533,24 +525,21 @@ static int erofs_fc_parse_param(struct fs_context *fc,
 		break;
 #endif
 	case Opt_directio:
-#ifdef CONFIG_EROFS_FS_BACKED_BY_FILE
-		if (result.boolean)
+		if (!IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE))
+			errorfc(fc, "%s option not supported", erofs_fs_parameters[opt].name);
+		else if (result.boolean)
 			set_opt(&sbi->opt, DIRECT_IO);
 		else
 			clear_opt(&sbi->opt, DIRECT_IO);
-#else
-		errorfc(fc, "%s option not supported", erofs_fs_parameters[opt].name);
-#endif
 		break;
 	case Opt_fsoffset:
 		sbi->dif0.fsoff = result.uint_64;
 		break;
 	case Opt_inode_share:
-#ifdef CONFIG_EROFS_FS_PAGE_CACHE_SHARE
-		set_opt(&sbi->opt, INODE_SHARE);
-#else
-		errorfc(fc, "%s option not supported", erofs_fs_parameters[opt].name);
-#endif
+		if (!IS_ENABLED(CONFIG_EROFS_FS_PAGE_CACHE_SHARE))
+			errorfc(fc, "%s option not supported", erofs_fs_parameters[opt].name);
+		else
+			set_opt(&sbi->opt, INODE_SHARE);
 		break;
 	}
 	return 0;
@@ -809,8 +798,7 @@ static int erofs_fc_get_tree(struct fs_context *fc)
 	ret = get_tree_bdev_flags(fc, erofs_fc_fill_super,
 		IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) ?
 			GET_TREE_BDEV_QUIET_LOOKUP : 0);
-#ifdef CONFIG_EROFS_FS_BACKED_BY_FILE
-	if (ret == -ENOTBLK) {
+	if (IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) && ret == -ENOTBLK) {
 		struct file *file;
 
 		if (!fc->source)
@@ -824,7 +812,6 @@ static int erofs_fc_get_tree(struct fs_context *fc)
 		    sbi->dif0.file->f_mapping->a_ops->read_folio)
 			return get_tree_nodev(fc, erofs_fc_fill_super);
 	}
-#endif
 	return ret;
 }
 
@@ -1108,12 +1095,12 @@ static int erofs_show_options(struct seq_file *seq, struct dentry *root)
 		seq_puts(seq, ",dax=never");
 	if (erofs_is_fileio_mode(sbi) && test_opt(opt, DIRECT_IO))
 		seq_puts(seq, ",directio");
-#ifdef CONFIG_EROFS_FS_ONDEMAND
-	if (sbi->fsid)
-		seq_printf(seq, ",fsid=%s", sbi->fsid);
-	if (sbi->domain_id)
-		seq_printf(seq, ",domain_id=%s", sbi->domain_id);
-#endif
+	if (IS_ENABLED(CONFIG_EROFS_FS_ONDEMAND)) {
+		if (sbi->fsid)
+			seq_printf(seq, ",fsid=%s", sbi->fsid);
+		if (sbi->domain_id)
+			seq_printf(seq, ",domain_id=%s", sbi->domain_id);
+	}
 	if (sbi->dif0.fsoff)
 		seq_printf(seq, ",fsoffset=%llu", sbi->dif0.fsoff);
 	if (test_opt(opt, INODE_SHARE))
-- 
2.43.5


