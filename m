Return-Path: <linux-erofs+bounces-4105-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D487C55172
	for <linux-erofs@archiver.kernel.org>; Tue,  4 Aug 2026 06:05:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDjhG2Nydz2yMl;
	Tue, 04 Aug 2026 16:05:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785823534;
	cv=none; b=BGjmMmYQ1hoM9P46XmPUnULcIBCy98+fSs9NKKhjwwlVfiG8VdJWjclctp4fsCT3qca+552vpj4ZrA6RheLEMdOW7I2L8OD6zAjLxao0IoMEfhkQ70pRmf+VqynZHw57JMteocCYs2Lzh9mjMfQqYZtP6wlC8+1afKWTNjXIzVRd/psEKs94lH24Gt7WYWC6Z6F7+bVE1zRmIdtGQs/GtzOA4WbS5Bm5UkFaUdadAMlWwn8EEj3rANnOcEX23493LhGuBG+W55awb+XdRAJ8DhsyaKeSEn/twxJb6RH5gc8B713FOhFRbyTHwzNzVWwRYP9q1sGize9d7gRh1UpPJw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785823534; c=relaxed/relaxed;
	bh=Ld1IWfsDofcJAlwJ7WeO2nFDFcn1W39EOr0BnDNkosI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=aqN3gcXextoL7IsjBcwtx4yhKXEMvLdt7RqD8QTQziWrvryirvrRxTzkai2KAL68H/PX3HuXiXRjha8AXSHlZd3bIC6sBSjIXgGCbozrXyUKCwDjLOXwCqJmeW3KllwIFC6af1mbpWnKa/BYNyBUUQHtI65t0EuMOM4UHrKEi04If5tBz7qPycxSYR4M4coixIyTkHmWt3qOC/DbnHsh1eblpesJrxkRvoEXgF9Ii4IJ5YDoORKoYLmtpCQ5m0bMcUgXnbmD8Z8qOPxfD0Jj9qQUW1+og4++6w3i0sTqTsP/eyueyN4hL2w0EDpp0QQu55IEVkvz3pV+EAri5rFReA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=J2pNcy1z; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=APikB6Zw; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=J2pNcy1z;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=APikB6Zw;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hDjhD52KMz2y1Y
	for <linux-erofs@lists.ozlabs.org>; Tue, 04 Aug 2026 16:05:31 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785823527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ld1IWfsDofcJAlwJ7WeO2nFDFcn1W39EOr0BnDNkosI=;
	b=J2pNcy1zH7knfnJWq+sSy21xh/Nhtujj9HLkpHQryr+aPXJAutdQVA7aKuwAkem6d5+u/3
	Nlvs/81Rtqu5dWcVLk9YiJhmevNMyoTs4t1CA7/XRahS/o96y+6sLf0iqSfdUTI2+/SCPq
	+zrKffpWUDCirQHcVVyfFIORMvKZxaQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785823528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ld1IWfsDofcJAlwJ7WeO2nFDFcn1W39EOr0BnDNkosI=;
	b=APikB6Zwb6G9CRc0jdGbiMfjpNEbYrHaGa28ij/X4dltWwSHzMxxgqCLytj5V9LyhJuH/t
	KC8A0g6h87D9yDMfY7JawC3BkpvVPfoh7wC7Mxw0vOyI84+w8y45fat4uO8q5lld1jOUJt
	DhNZXWkC/ooTlf+tIidaNSY2v2yvKR8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-90-bmDggH0QOaihrKTq-Yj28g-1; Tue,
 04 Aug 2026 02:05:12 -0400
X-MC-Unique: bmDggH0QOaihrKTq-Yj28g-1
X-Mimecast-MFC-AGG-ID: bmDggH0QOaihrKTq-Yj28g_1785823511
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D195D1954B05;
	Tue,  4 Aug 2026 06:05:10 +0000 (UTC)
Received: from oxygen.redhat.com (unknown [10.44.48.84])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A1C11414;
	Tue,  4 Aug 2026 06:05:08 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	linux-fsdevel@vger.kernel.org,
	amir73il@gmail.com,
	gscrivan@redhat.com,
	brauner@kernel.org
Subject: [PATCH v4] erofs: reuse superblock for file-backed mounts
Date: Tue,  4 Aug 2026 08:00:27 +0200
Message-ID: <20260804060455.2928514-1-gscrivan@redhat.com>
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
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: tamWtuUzxXoWH4ZaEw_zhPL1CgncaId4t5CJgAWd1T0_1785823511
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When the same file-backed image is mounted multiple times (via path or
fd) with the superblock_share mount option, reuse the existing
superblock instead of creating a new one.  This allows multiple mounts
of the same image to share in-kernel data structures more efficiently.

The backing file is identified by its inode and fsoffset.  If mount
options conflict or extra devices are used, a separate superblock
is created transparently as a fallback.  Remount is not allowed on
shared superblocks.

Tested by mounting a 177M Fedora EROFS image 20 times with full
traversal:

  #!/bin/sh
  IMG=${1:-/root/fedora.erofs}
  OPTS=${2:+-o $2}
  N=20
  DIR=$(mktemp -d)
  trap "umount $DIR/m* 2>/dev/null; rm -rf $DIR" EXIT

  sync; echo 3 > /proc/sys/vm/drop_caches
  INODES_BEFORE=$(grep erofs_inode /proc/slabinfo | awk '{print $2}')
  MEM_BEFORE=$(grep ^Slab: /proc/meminfo | awk '{print $2}')

  for i in $(seq 1 $N); do
      mkdir $DIR/m$i
      mount -t erofs $OPTS "$IMG" $DIR/m$i
      find $DIR/m$i > /dev/null
  done

  echo "Superblocks: $(grep $DIR /proc/self/mountinfo | \
      awk '{print $3}' | sort -u | wc -l)"
  echo "erofs_inode delta: +$(( $(grep erofs_inode /proc/slabinfo | \
      awk '{print $2}') - INODES_BEFORE ))"
  echo "Slab delta: +$(( $(grep ^Slab: /proc/meminfo | \
      awk '{print $2}') - MEM_BEFORE )) kB"

without superblock_share:

  # time ./test.sh /root/fedora.erofs
  Superblocks: 20
  erofs_inode delta: +45864
  Slab delta: +37448 kB
  real	0m2.311s
  user	0m0.222s
  sys	0m1.998s

with superblock_share:

  # time ./test.sh /root/fedora.erofs superblock_share
  Superblocks: 1
  erofs_inode delta: +2044
  Slab delta: +284 kB
  real	0m0.679s
  user	0m0.157s
  sys	0m0.469s

The time difference shows that sharing the superblock also benefits
the page cache and inode cache, as subsequent mounts of the same image
avoid re-reading the backing file.  This is particularly useful for
container hosts running multiple containers from the same base image.

Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
---
v3: https://lore.kernel.org/linux-fsdevel/20260801075446.2508805-1-gscrivan@redhat.com/
v2: https://lore.kernel.org/linux-fsdevel/20260731160901.2276832-1-gscrivan@redhat.com/
v1: https://lore.kernel.org/linux-fsdevel/20260730124120.1501126-1-gscrivan@redhat.com/
Needs: https://lore.kernel.org/linux-fsdevel/20260804055949.2927896-1-gscrivan@redhat.com/

 Documentation/filesystems/erofs.rst |  8 ++++
 fs/erofs/internal.h                 |  1 +
 fs/erofs/super.c                    | 73 +++++++++++++++++++++++++++--
 3 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/erofs.rst b/Documentation/filesystems/erofs.rst
index d301d9ac946a..49c4e7dbc5d6 100644
--- a/Documentation/filesystems/erofs.rst
+++ b/Documentation/filesystems/erofs.rst
@@ -139,6 +139,9 @@ inode_share            Enable inode page sharing for this filesystem.  Inodes wi
                        page cache.
 source=%s              (For file-backed mounts) Specify the backing image as a path
                        or as an already-opened file descriptor.
+superblock_share       (For file-backed mounts) Share the superblock when the same
+                       backing file is mounted more than once with compatible
+                       options.  Remount is not allowed on shared superblocks.
 ===================    =========================================================
 
 File-backed mounts
@@ -156,6 +159,11 @@ Only regular files are accepted as backing files; to mount an image that
 resides on a block device, use the traditional block device mount path
 instead.
 
+When superblock_share is specified and the same backing file (identified
+by inode and fsoffset) is mounted more than once with compatible mount
+options, the kernel reuses the existing superblock instead of creating a
+new one.  Remount is not allowed on shared superblocks.
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
index d40961248a49..a8dd880da630 100644
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
 
@@ -560,6 +561,12 @@ static int erofs_fc_parse_param(struct fs_context *fc,
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
@@ -663,6 +670,17 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 		errorfc(fc, "FSDAX is not allowed when inode_share is on");
 		return -EINVAL;
 	}
+	if (test_opt(&sbi->opt, SUPERBLOCK_SHARE) &&
+	    test_opt(&sbi->opt, INODE_SHARE)) {
+		errorfc(fc, "superblock_share is not allowed when inode_share is on");
+		return -EINVAL;
+	}
+	/* Extra devices are not yet supported with superblock sharing.  */
+	if (test_opt(&sbi->opt, SUPERBLOCK_SHARE) &&
+	    sbi->devs->extra_devices) {
+		errorfc(fc, "superblock_share does not support extra devices");
+		return -EINVAL;
+	}
 
 	sbi->blkszbits = PAGE_SHIFT;
 	if (!sb->s_bdev) {
@@ -788,6 +806,51 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
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
+	return file_inode(sbi->dif0.file) == file_inode(new_sbi->dif0.file) &&
+	       sbi->dif0.fsoff == new_sbi->dif0.fsoff &&
+	       !memcmp(&sbi->opt, &new_sbi->opt, sizeof(sbi->opt));
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
@@ -803,7 +866,7 @@ static int erofs_fc_get_tree(struct fs_context *fc)
 			errorfc(fc, "source is unsupported");
 			return -EINVAL;
 		}
-		return get_tree_nodev(fc, erofs_fc_fill_super);
+		return erofs_fc_get_tree_file(fc);
 	}
 
 	ret = get_tree_bdev_flags(fc, erofs_fc_fill_super,
@@ -821,7 +884,7 @@ static int erofs_fc_get_tree(struct fs_context *fc)
 
 		if (S_ISREG(file_inode(sbi->dif0.file)->i_mode) &&
 		    sbi->dif0.file->f_mapping->a_ops->read_folio)
-			return get_tree_nodev(fc, erofs_fc_fill_super);
+			return erofs_fc_get_tree_file(fc);
 	}
 	return ret;
 }
@@ -834,6 +897,10 @@ static int erofs_fc_reconfigure(struct fs_context *fc)
 
 	DBG_BUGON(!sb_rdonly(sb));
 
+	/* Shared superblocks must not be reconfigured.  */
+	if (test_opt(&sbi->opt, SUPERBLOCK_SHARE))
+		return -EBUSY;
+
 	if (new_sbi->domain_id)
 		erofs_info(sb, "ignoring reconfiguration for domain_id.");
 
-- 
2.55.0


