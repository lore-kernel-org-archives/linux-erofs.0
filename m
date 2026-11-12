Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF6F606A31C
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Nov 2026 02:54:57 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQ4k71888z2xwP;
	Thu, 12 Nov 2026 13:54:55 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.28.59
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794452095;
	cv=none; b=il2vmOB9TMW/mwhexC0wUZcPqG9mlBkGwGi7A2vP7B8C2nvMf7zK82aLljQ6uiR6aruDLCbq8X5jq/IIo4cGyK9/E9E+0iFwSXQhAZlPtcs2jztNgBHUPAKxGrGi+Zg0nhUg1JaaabTPoGSkW5C/gkGi+N+FXcgbAVKEWt75Eb6Lf6qdukyyO7Dq2uDCE8JAJdBFt0cbLNrV+dnz3hrJsyhOuidJV9tiemd3fw/7FZD9ueHcTHxIgafopO9kmh4czuCBrcaeTFjf5uGcg/gQL4Cwq3UpS8ON9v9AHG8FPlN/Ve8alWG8SxFhxbLK/NHrUDomXuC5MWIEF+txvcfDDw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794452095; c=relaxed/relaxed;
	bh=LY4IbTlsDKwstQ/Ji+g9YsxYH/6gH5OwIjVh5q8yA6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b0b/krUDP1VAHh3Kfvf5gUBi7VR0QOnervSlQEfOinNOesjHLQQ312N2s2hj/pNjeKKZWKXByYZ8SD/ouN60bcY3hAzn4T+swLMAr8j5VZl3kUR+b9S/dRPsm7i2crbxwG0eE02SAWGOehgYCQ6a7V1Zneo2Z2MgVhBY/sR90JqjF1UHWULEXnDMjzyeroXkcar11HTwuDy7AfrGTnq9zXPiqi2Jw0BtY9rRAl7nNQy5lI6vKJr83W0ctJcoGgxdZ5cxPRD/KuG16/uczN/3yaoBAs/ZGP/Eg37HeXTxUt7q5lfr7RhPjjtwZGU8yd+xFohZFZdXlWQC+NhshALl8Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=cyzhu.com; spf=pass (client-ip=115.124.28.59; helo=out28-59.mail.aliyun.com; envelope-from=hudson@cyzhu.com; receiver=lists.ozlabs.org) smtp.mailfrom=cyzhu.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=cyzhu.com
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=cyzhu.com (client-ip=115.124.28.59; helo=out28-59.mail.aliyun.com; envelope-from=hudson@cyzhu.com; receiver=lists.ozlabs.org)
Received: from out28-59.mail.aliyun.com (out28-59.mail.aliyun.com [115.124.28.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQ4k54vSbz2xsW
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 13:54:51 +1100 (AEDT)
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.07436489|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00128123-0.000149513-0.998569;FP=64031267379611383|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037028158;MF=hudson@cyzhu.com;NM=1;PH=DS;RN=3;RT=3;SR=0;TI=SMTPD_---.k0DM-hG_1794452083;
Received: from HUDSONZHU-MC1.tencent.com(mailfrom:hudson@cyzhu.com fp:SMTPD_---.k0DM-hG_1794452083 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 12 Nov 2026 10:54:43 +0800
From: ChengyuZhu6 <hudson@cyzhu.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	Chengyu Zhu <hudsonzhu@tencent.com>
Subject: [PATCH] erofs: accept file descriptors for extra devices
Date: Thu, 12 Nov 2026 10:54:39 +0800
Message-ID: <20261112025439.62511-1-hudson@cyzhu.com>
X-Mailer: git-send-email 2.51.0
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chengyu Zhu <hudsonzhu@tencent.com>

Allow device parameters to accept readable regular-file or block-device
FDs through FSCONFIG_SET_FD, while preserving path-based inputs.

Transfer file references for file-backed mounts. For block-backed mounts,
open by device number and track registration for correct cleanup.

AI-assisted by ChatGPT (gpt-6.1-sol).
Signed-off-by: Chengyu Zhu <hudsonzhu@tencent.com>
---
 fs/erofs/internal.h |  1 +
 fs/erofs/super.c    | 30 ++++++++++++++++++++++++++----
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 8363c0c051f6..1cc113409d77 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -45,6 +45,7 @@ struct erofs_device_info {
 	char *path;
 	struct file *file;
 	struct dax_device *dax_dev;
+	bool bdev_claimed;
 	u64 fsoff, dax_part_off;
 
 	erofs_blk_t blocks;
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index ce05557bd998..e08dc1622651 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -145,10 +145,18 @@ static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
 	}
 
 	if (!sbi->devs->flatdev) {
-		file = erofs_is_fileio_mode(sbi) ?
+		if (!dif->file)
+			file = erofs_is_fileio_mode(sbi) ?
 				filp_open(dif->path, O_RDONLY | O_LARGEFILE, 0) :
 				fs_bdev_file_open_by_path(dif->path,
 						BLK_OPEN_READ, sb->s_type, sb);
+		else if (erofs_is_fileio_mode(sbi))
+			file = no_free_ptr(dif->file);
+		else if (S_ISBLK(file_inode(dif->file)->i_mode))
+			file = fs_bdev_file_open_by_dev(file_inode(dif->file)->i_rdev,
+						BLK_OPEN_READ, sb->s_type, sb);
+		else
+			return -EINVAL;
 		if (IS_ERR(file)) {
 			if (file == ERR_PTR(-ENOTBLK))
 				return -EINVAL;
@@ -167,7 +175,10 @@ static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
 				   dif->path);
 			clear_opt(&sbi->opt, DAX_ALWAYS);
 		}
+		if (dif->file)
+			fput(dif->file);
 		dif->file = file;
+		dif->bdev_claimed = !erofs_is_fileio_mode(sbi);
 	}
 
 	_48bit = erofs_sb_has_48bit(sbi);
@@ -409,7 +420,7 @@ static const struct fs_parameter_spec erofs_fs_parameters[] = {
 		     erofs_param_cache_strategy),
 	fsparam_flag("dax",			Opt_dax),
 	fsparam_enum("dax",			Opt_dax_enum, erofs_dax_param_enums),
-	fsparam_string("device",		Opt_device),
+	fsparam_file_or_string("device",	Opt_device),
 	fsparam_string("domain_id",		Opt_domain_id),
 	fsparam_flag_no("directio",		Opt_directio),
 	fsparam_u64("fsoffset",			Opt_fsoffset),
@@ -518,10 +529,19 @@ static int erofs_fc_parse_param(struct fs_context *fc,
 			return -EINVAL;
 		break;
 	case Opt_device:
+		if (param->type == fs_value_is_file) {
+			if (!(param->file->f_mode & FMODE_READ))
+				return -EBADF;
+			if (!S_ISREG(file_inode(param->file)->i_mode) &&
+			    !S_ISBLK(file_inode(param->file)->i_mode))
+				return invalf(fc, "unsupported device fd type");
+		}
 		dif = kzalloc_obj(*dif);
 		if (!dif)
 			return -ENOMEM;
-		dif->path = kstrdup(param->string, GFP_KERNEL);
+		dif->path = param->type == fs_value_is_file ?
+			kasprintf(GFP_KERNEL, "%pD", param->file) :
+			kstrdup(param->string, GFP_KERNEL);
 		if (!dif->path) {
 			kfree(dif);
 			return -ENOMEM;
@@ -535,6 +555,8 @@ static int erofs_fc_parse_param(struct fs_context *fc,
 			return ret;
 		}
 		++sbi->devs->extra_devices;
+		if (param->type == fs_value_is_file)
+			dif->file = no_free_ptr(param->file);
 		break;
 	case Opt_domain_id:
 		if (!IS_ENABLED(CONFIG_EROFS_FS_PAGE_CACHE_SHARE)) {
@@ -910,7 +932,7 @@ static int erofs_release_device_info(int id, void *ptr, void *data)
 
 	fs_put_dax(dif->dax_dev, NULL);
 	if (dif->file) {
-		if (S_ISBLK(file_inode(dif->file)->i_mode))
+		if (dif->bdev_claimed)
 			fs_bdev_file_release(dif->file, sb);
 		else
 			fput(dif->file);
-- 
2.51.0


