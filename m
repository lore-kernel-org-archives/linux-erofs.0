Return-Path: <linux-erofs+bounces-4104-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EDD5C55172
	for <linux-erofs@archiver.kernel.org>; Tue,  4 Aug 2026 06:00:11 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDjZ13RQPz30B0;
	Tue, 04 Aug 2026 16:00:09 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785823209;
	cv=none; b=RXvQiWsZ6bCRCLpQAAIKNS3xPjzQYUnXEJ58o1GHk+DoOnb3D/86QKBb1mkrf7JuMJ9Yn7DgBAs6y4Sk65kNE8TRKy5Xdn6KhSINfzSEZz5tEBfikN+cqHOKYjAyXvWCN24qvDeejPnUb4YKEp+JFMsHv1jyn5NwTd9bCYt8hMJzWqwJfczyK5EOmITfPMdLGdmeHeKr1DcMCRtBPwa2svbuNB7A5p8LKSKU5wHsyPjoaJuZllTV3vf+oulN6CJICQKeQlbos1I4vvjr/33xHFEwFY6e/shjOMABGb5/kET1hFAeAvOfAwsLFEzjlkEQeLjjQk9grxJi7UKtrvddlg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785823209; c=relaxed/relaxed;
	bh=nqj8Qxuj4PaU5i4QdVpLQG/TB7fOUrL15E/tCKEo5Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=I7/9wlYSoIo/ugW7ucdFaGkEWoLyunGhPwxOmKtk8av8A9PCfukVOnTJOZRkrJQxXEFJ5sCEU0AiHIH1SpRc15BZtxnW6R2VT1dS8vzi7QiuvVR37YJ5qG5uma6qCFsvqmyKuePp21raL0CIwVQacOBJfasw7XmP9ncbVjF3G1nvcU2/pUODuLIK/FQuMY7YPe2RIwNliMCRk4yXyzo0W8JPFVGHjSQFfBNJU6PoCaoQg2YhK2KFYQn18zTQ4ZybtesSKZ1CEgo19BDg+7UJPAjEbYo/nBb3nNk4dNog+038M69TyF00G+P2OwYYqwRvVpAv9h6KF7teKUlrNCRYsg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MM2FIL6J; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MM2FIL6J; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MM2FIL6J;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MM2FIL6J;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hDjYz4Q28z3092
	for <linux-erofs@lists.ozlabs.org>; Tue, 04 Aug 2026 16:00:06 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785823203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nqj8Qxuj4PaU5i4QdVpLQG/TB7fOUrL15E/tCKEo5Vg=;
	b=MM2FIL6JiSXrkHsa5H/Lc5itKzlJBWBaV05oBmSA6Xj6UbYQbwV5wVnC1XcQzlwCQ1jtOx
	ccHlh0FMnIdvW4ysmqg/E11/JGYbR62FN+a/8PN3el807+reCSmhD1QF5dlFKyuEVk39RK
	BLur9iAj4r3CcrsDQvWyR0MG6mewQw4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785823203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nqj8Qxuj4PaU5i4QdVpLQG/TB7fOUrL15E/tCKEo5Vg=;
	b=MM2FIL6JiSXrkHsa5H/Lc5itKzlJBWBaV05oBmSA6Xj6UbYQbwV5wVnC1XcQzlwCQ1jtOx
	ccHlh0FMnIdvW4ysmqg/E11/JGYbR62FN+a/8PN3el807+reCSmhD1QF5dlFKyuEVk39RK
	BLur9iAj4r3CcrsDQvWyR0MG6mewQw4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-6-TI00wMDjNoeskEpNxjjDjQ-1; Tue,
 04 Aug 2026 01:59:59 -0400
X-MC-Unique: TI00wMDjNoeskEpNxjjDjQ-1
X-Mimecast-MFC-AGG-ID: TI00wMDjNoeskEpNxjjDjQ_1785823198
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B784419560AF;
	Tue,  4 Aug 2026 05:59:57 +0000 (UTC)
Received: from oxygen.redhat.com (unknown [10.44.48.84])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EA5521956087;
	Tue,  4 Aug 2026 05:59:55 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	linux-fsdevel@vger.kernel.org,
	gscrivan@redhat.com
Subject: [PATCH v6] erofs: accept source file descriptor via fsconfig
Date: Tue,  4 Aug 2026 07:58:42 +0200
Message-ID: <20260804055949.2927896-1-gscrivan@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: cJL1IO653PoWswei8nbew8jgMmofynbvLorZDOHW2pE_1785823198
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Allow userspace to pass an already-opened file descriptor as the mount
source instead of a path string.  This is useful for tools that already
hold an fd to the image, such as composefs reusing an existing erofs
backing file.

Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Acked-by: Christian Brauner (Amutable) <brauner@kernel.org>
Acked-by: Jan Kara <jack@suse.cz>
---
v5: https://lore.kernel.org/linux-fsdevel/20260728160619.853924-1-gscrivan@redhat.com/
v4: https://lore.kernel.org/linux-fsdevel/20260717134147.1602735-1-gscrivan@redhat.com/
v3: https://lore.kernel.org/linux-fsdevel/20260714154917.489993-1-gscrivan@redhat.com/
v2: https://lore.kernel.org/linux-fsdevel/20260711071137.4130824-1-gscrivan@redhat.com/
v1: https://lore.kernel.org/linux-fsdevel/ak5GfvVfWLJU1EwK@debian/

 Documentation/filesystems/erofs.rst | 17 +++++++
 fs/erofs/super.c                    | 73 ++++++++++++++++++++++++-----
 2 files changed, 79 insertions(+), 11 deletions(-)

diff --git a/Documentation/filesystems/erofs.rst b/Documentation/filesystems/erofs.rst
index 4230884fb359..d301d9ac946a 100644
--- a/Documentation/filesystems/erofs.rst
+++ b/Documentation/filesystems/erofs.rst
@@ -137,8 +137,25 @@ fsoffset=%llu          Specify block-aligned filesystem offset for the primary d
 inode_share            Enable inode page sharing for this filesystem.  Inodes with
                        identical content within the same domain ID can share the
                        page cache.
+source=%s              (For file-backed mounts) Specify the backing image as a path
+                       or as an already-opened file descriptor.
 ===================    =========================================================
 
+File-backed mounts
+==================
+
+When CONFIG_EROFS_FS_BACKED_BY_FILE is enabled, EROFS file-backed images
+can be mounted directly without a loopback block device.  The backing file
+can be given either as a path, or as an already-opened file descriptor.
+
+When a file descriptor is used, the kernel resolves its path and records it
+so that /proc/mounts and similar interfaces can still report the mount
+source.
+
+Only regular files are accepted as backing files; to mount an image that
+resides on a block device, use the traditional block device mount path
+instead.
+
 Sysfs Entries
 =============
 
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 03d108a7a3e5..d40961248a49 100644
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


