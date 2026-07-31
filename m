Return-Path: <linux-erofs+bounces-4067-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E000C5516F
	for <linux-erofs@archiver.kernel.org>; Fri, 31 Jul 2026 16:09:24 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hBWGp2s0fz2yY1;
	Sat, 01 Aug 2026 02:09:22 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785514162;
	cv=none; b=eORQj1/APpBvy4OkD1mBpkSpnj4rUi7GMI4yRZTsmPNYm4c0OZbXrCN7uUW1NvX/BQVFivSqJjlP25sjVBjXdJhKO0RT34s5/E12AF0QgDYFXEMpgsAHoplAFBKkT+vNq3sDYPkjSgfu+ivQERKskV2GVBPlF14o2NNgfQlr5Xl1KXT3f+faCsn1wqR4L/c1/AL+rouFg8hxLvQrOEftxM5xgbgH4fPlXyVBb9Ajrdxg5wXy5W94uhCGXkTjir9IBUDBNPiXmabpobVQyxGsMP/YPZfentqE4zdgjRXW08LVlRv9EDJiWIGN5O9f0+dJOxYT/ygZqjyiX1vQhrUyiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785514162; c=relaxed/relaxed;
	bh=P+bNtzXVDeA/ry87X/juqVQEZC25ldZuMU3im96lPR0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=c+CZZjDdkHprtg0IguHLnvjmoRCd8G4n1g7Dii1s5N0qp1V1up1OMMx3m4IGD6s9CQEFpE/MZtkiVoiHw95yeEX0uSrYsBAew14bI0jb4Swoe/vUfY+0mbKGqA2VkTwgbZT6fqJayUsDQFRPVVuCwPNuH2VbP0wSOOmGOdPYyaZElxvT0K8hZQ+YuiKNobR+kkk5KN5KHXVXO5i0RBrnFY2IkF4WV3fOyaCMvI14dhazRXfgxxw4jWiuRm9V1WGl90xtCKeLMEvXSXALYIsBa7+269t+5LCQ5qqtj5KjvPDspFOmm9ftEP1PpCOl8frY0kvhmviCoe6K1WGHjoWNGA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HHkLb0e5; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=WdCFq3f9; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HHkLb0e5;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=WdCFq3f9;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hBWGn2Czvz2y1F
	for <linux-erofs@lists.ozlabs.org>; Sat, 01 Aug 2026 02:09:20 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785514157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=P+bNtzXVDeA/ry87X/juqVQEZC25ldZuMU3im96lPR0=;
	b=HHkLb0e5rOt924sSaxqubNFiGutTlDejkK13D0m/0pETgDvNbNccvEhiegekaqV5NIk4eO
	jkOfkHZHcN8kfq1CMdGo4Pu3jtd2iejOaNSbTG7c3pUEybTY40HWYFapM94umE+KjQsmYb
	fQlyiUx6R9XtZ1rwP7QG7rTtuIr6iCs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785514158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=P+bNtzXVDeA/ry87X/juqVQEZC25ldZuMU3im96lPR0=;
	b=WdCFq3f9rssst2to5PflJ6NMDR2H5s4iv1FOClfg+PoIURzJF6gmW1pn14DGk0YSxmvvb9
	rKPlxDqWg77mPhFwvBeXCINduimZD2B+hlOC+CgfsmedX4bbC/fRqqWZ/w8RRzoOKXRhxI
	rMIS/6lTqj/9Nkrwqp0tnw0rQL8jV9A=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-647-giwr8x4fPAWrLudAP1QkVA-1; Fri,
 31 Jul 2026 12:09:11 -0400
X-MC-Unique: giwr8x4fPAWrLudAP1QkVA-1
X-Mimecast-MFC-AGG-ID: giwr8x4fPAWrLudAP1QkVA_1785514150
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 322C119560A2;
	Fri, 31 Jul 2026 16:09:10 +0000 (UTC)
Received: from oxygen.redhat.com (unknown [10.44.32.120])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E5B421956089;
	Fri, 31 Jul 2026 16:09:07 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	linux-fsdevel@vger.kernel.org,
	amir73il@gmail.com,
	gscrivan@redhat.com,
	brauner@kernel.org
Subject: [PATCH v2] erofs: reuse superblock for file-backed mounts
Date: Fri, 31 Jul 2026 18:08:21 +0200
Message-ID: <20260731160901.2276832-1-gscrivan@redhat.com>
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
X-Mimecast-MFC-PROC-ID: R8S-xS3R0Cv8GHTcL6CZXSryq_M_BCT8DyHizYfoHAA_1785514150
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When the same file-backed image is mounted multiple times (via path or
fd) with the superblock_share mount option and matching domain_id, reuse
the existing superblock instead of creating a new one.  This allows
multiple mounts of the same image to share in-kernel data structures
more efficiently.

Superblock sharing requires both superblock_share and domain_id to be
specified, following the same pattern as inode_share.  The backing file
is identified by its inode and fsoffset.  If mount options conflict, a
separate superblock is created transparently as a fallback.  Remount is
not allowed on shared superblocks.

Tested by mounting a 177M Fedora EROFS image 20 times with full
traversal:

  #!/bin/sh
  IMG=${1:-/root/fedora.erofs}
  N=20
  DIR=$(mktemp -d)
  trap "umount $DIR/m* 2>/dev/null; rm -rf $DIR" EXIT

  sync; echo 3 > /proc/sys/vm/drop_caches
  INODES_BEFORE=$(grep erofs_inode /proc/slabinfo | awk '{print $2}')
  MEM_BEFORE=$(grep ^Slab: /proc/meminfo | awk '{print $2}')

  for i in $(seq 1 $N); do
      mkdir $DIR/m$i
      mount -t erofs -o domain_id=test,superblock_share "$IMG" $DIR/m$i
      find $DIR/m$i > /dev/null
  done

  echo "Superblocks: $(grep $DIR /proc/self/mountinfo | \
      awk '{print $3}' | sort -u | wc -l)"
  echo "erofs_inode delta: +$(( $(grep erofs_inode /proc/slabinfo | \
      awk '{print $2}') - INODES_BEFORE ))"
  echo "Slab delta: +$(( $(grep ^Slab: /proc/meminfo | \
      awk '{print $2}') - MEM_BEFORE )) kB"

unpatched kernel:

  Superblocks: 20
  erofs_inode delta: +46368
  Slab delta: +39952 kB
  0.08user 0.82system 0:00.98elapsed

patched kernel:

  Superblocks: 1
  erofs_inode delta: +2044
  Slab delta: +1088 kB
  0.07user 0.21system 0:00.31elapsed

The time difference shows that sharing the superblock also benefits
the page cache and inode cache, as subsequent mounts of the same image
avoid re-reading the backing file.  This is particularly useful for
container hosts running multiple containers from the same base image.

Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
---
v1: https://lore.kernel.org/linux-fsdevel/20260730124120.1501126-1-gscrivan@redhat.com/
Needs: https://lore.kernel.org/linux-fsdevel/20260728160619.853924-1-gscrivan@redhat.com/

 Documentation/filesystems/erofs.rst | 16 ++++++-
 fs/erofs/internal.h                 |  1 +
 fs/erofs/super.c                    | 72 +++++++++++++++++++++++++++--
 3 files changed, 83 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/erofs.rst b/Documentation/filesystems/erofs.rst
index 774e8b236d09..517c526163e2 100644
--- a/Documentation/filesystems/erofs.rst
+++ b/Documentation/filesystems/erofs.rst
@@ -131,12 +131,17 @@ device=%s              Specify a path to an extra device to be used together.
 directio               (For file-backed mounts) Use direct I/O to access backing
                        files, and asynchronous I/O will be enabled if supported.
 domain_id=%s           Specify a trusted domain ID. Filesystems sharing the same
-                       domain ID can share page cache across mounts when inode
-                       page sharing is enabled. (not shown in mountinfo output)
+                       domain ID can share page cache across mounts when
+                       inode_share is enabled, and share superblocks when
+                       superblock_share is enabled. (not shown in mountinfo
+                       output)
 fsoffset=%llu          Specify block-aligned filesystem offset for the primary device.
 inode_share            Enable inode page sharing for this filesystem.  Inodes with
                        identical content within the same domain ID can share the
                        page cache.
+superblock_share       Share the superblock when the same backing file is mounted
+                       more than once with the same domain_id and compatible
+                       options.  Remount is not allowed on shared superblocks.
 ===================    =========================================================
 
 File-backed mounts
@@ -154,6 +159,13 @@ Only regular files are accepted as backing files; to mount an image that
 resides on a block device, use the traditional block device mount path
 instead.
 
+When domain_id and superblock_share are both specified and the same
+backing file (identified by inode and fsoffset) is mounted more than
+once with the same domain_id and compatible mount options, the kernel
+reuses the existing superblock instead of creating a new one.
+
+Remount is not allowed on shared superblocks.
+
 Sysfs Entries
 =============
 
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 580f8d9f14e7..8d65cac35702 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -156,6 +156,7 @@ struct erofs_sb_info {
 #define EROFS_MOUNT_DAX_NEVER		0x00000080
 #define EROFS_MOUNT_DIRECT_IO		0x00000100
 #define EROFS_MOUNT_INODE_SHARE		0x00000200
+#define EROFS_MOUNT_SUPERBLOCK_SHARE	0x00000400
 
 #define clear_opt(opt, option)	((opt)->mount_opt &= ~EROFS_MOUNT_##option)
 #define set_opt(opt, option)	((opt)->mount_opt |= EROFS_MOUNT_##option)
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 558041011398..23fee43de1d1 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -386,7 +386,7 @@ static void erofs_default_options(struct erofs_sb_info *sbi)
 enum {
 	Opt_user_xattr, Opt_acl, Opt_cache_strategy, Opt_dax, Opt_dax_enum,
 	Opt_device, Opt_domain_id, Opt_directio, Opt_fsoffset, Opt_inode_share,
-	Opt_source,
+	Opt_source, Opt_superblock_share,
 };
 
 static const struct constant_table erofs_param_cache_strategy[] = {
@@ -415,6 +415,7 @@ static const struct fs_parameter_spec erofs_fs_parameters[] = {
 	fsparam_u64("fsoffset",			Opt_fsoffset),
 	fsparam_flag("inode_share",		Opt_inode_share),
 	fsparam_file_or_string("source",	Opt_source),
+	fsparam_flag("superblock_share",	Opt_superblock_share),
 	{}
 };
 
@@ -536,7 +537,8 @@ static int erofs_fc_parse_param(struct fs_context *fc,
 		++sbi->devs->extra_devices;
 		break;
 	case Opt_domain_id:
-		if (!IS_ENABLED(CONFIG_EROFS_FS_PAGE_CACHE_SHARE)) {
+		if (!IS_ENABLED(CONFIG_EROFS_FS_PAGE_CACHE_SHARE) &&
+		    !IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE)) {
 			errorfc(fc, "%s option not supported", erofs_fs_parameters[opt].name);
 		} else {
 			kfree_sensitive(sbi->domain_id);
@@ -560,6 +562,12 @@ static int erofs_fc_parse_param(struct fs_context *fc,
 		else
 			set_opt(&sbi->opt, INODE_SHARE);
 		break;
+	case Opt_superblock_share:
+		if (!IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE))
+			errorfc(fc, "%s option not supported", erofs_fs_parameters[opt].name);
+		else
+			set_opt(&sbi->opt, SUPERBLOCK_SHARE);
+		break;
 	case Opt_source:
 		return erofs_fc_parse_source(fc, param);
 	}
@@ -659,6 +667,10 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 		errorfc(fc, "domain_id is needed when inode_ishare is on");
 		return -EINVAL;
 	}
+	if (!sbi->domain_id && test_opt(&sbi->opt, SUPERBLOCK_SHARE)) {
+		errorfc(fc, "domain_id is needed when superblock_share is on");
+		return -EINVAL;
+	}
 	if (test_opt(&sbi->opt, DAX_ALWAYS) && test_opt(&sbi->opt, INODE_SHARE)) {
 		errorfc(fc, "FSDAX is not allowed when inode_ishare is on");
 		return -EINVAL;
@@ -788,6 +800,55 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 	return 0;
 }
 
+static int erofs_fc_test_file_super(struct super_block *sb,
+				    struct fs_context *fc)
+{
+	struct erofs_sb_info *sbi = EROFS_SB(sb);
+	struct erofs_sb_info *new_sbi = fc->s_fs_info;
+
+	if (sb->s_iflags & SB_I_RETIRED)
+		return 0;
+	if (!sbi->dif0.file || !new_sbi->dif0.file)
+		return 0;
+	if (!test_opt(&new_sbi->opt, SUPERBLOCK_SHARE))
+		return 0;
+	if (!sbi->domain_id || !new_sbi->domain_id ||
+	    strcmp(sbi->domain_id, new_sbi->domain_id))
+		return 0;
+	return file_inode(sbi->dif0.file) == file_inode(new_sbi->dif0.file) &&
+	       sbi->dif0.fsoff == new_sbi->dif0.fsoff &&
+	       sbi->opt.mount_opt == new_sbi->opt.mount_opt &&
+	       sbi->opt.cache_strategy == new_sbi->opt.cache_strategy;
+}
+
+static int erofs_fc_get_tree_file(struct fs_context *fc)
+{
+	struct erofs_sb_info *sbi = fc->s_fs_info;
+	struct super_block *sb;
+	int err;
+
+	if (!test_opt(&sbi->opt, SUPERBLOCK_SHARE))
+		return get_tree_nodev(fc, erofs_fc_fill_super);
+
+	sb = sget_fc(fc, erofs_fc_test_file_super, set_anon_super_fc);
+	if (IS_ERR(sb))
+		return PTR_ERR(sb);
+
+	if (sb->s_root) {
+		erofs_info(sb, "sharing superblock for the same backing file");
+	} else {
+		err = erofs_fc_fill_super(sb, fc);
+		if (err) {
+			deactivate_locked_super(sb);
+			return err;
+		}
+		sb->s_flags |= SB_ACTIVE;
+	}
+
+	fc->root = dget(sb->s_root);
+	return 0;
+}
+
 static int erofs_fc_get_tree(struct fs_context *fc)
 {
 	struct erofs_sb_info *sbi = fc->s_fs_info;
@@ -803,7 +864,7 @@ static int erofs_fc_get_tree(struct fs_context *fc)
 			errorfc(fc, "source is unsupported");
 			return -EINVAL;
 		}
-		return get_tree_nodev(fc, erofs_fc_fill_super);
+		return erofs_fc_get_tree_file(fc);
 	}
 
 	ret = get_tree_bdev_flags(fc, erofs_fc_fill_super,
@@ -821,7 +882,7 @@ static int erofs_fc_get_tree(struct fs_context *fc)
 
 		if (S_ISREG(file_inode(sbi->dif0.file)->i_mode) &&
 		    sbi->dif0.file->f_mapping->a_ops->read_folio)
-			return get_tree_nodev(fc, erofs_fc_fill_super);
+			return erofs_fc_get_tree_file(fc);
 	}
 	return ret;
 }
@@ -834,6 +895,9 @@ static int erofs_fc_reconfigure(struct fs_context *fc)
 
 	DBG_BUGON(!sb_rdonly(sb));
 
+	if (sbi->domain_id && test_opt(&sbi->opt, SUPERBLOCK_SHARE))
+		return -EBUSY;
+
 	if (new_sbi->domain_id)
 		erofs_info(sb, "ignoring reconfiguration for domain_id.");
 
-- 
2.55.0


