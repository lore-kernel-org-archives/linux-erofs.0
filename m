Return-Path: <linux-erofs+bounces-2534-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7941FEA8542
	for <linux-erofs@archiver.kernel.org>; Mon,  9 Mar 2026 02:33:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fTgzf2DJ7z3bnm;
	Mon, 09 Mar 2026 13:33:18 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773023598;
	cv=none; b=jAcBOsjsw/v0iDhFuEFODHKLMzQgPMtv7DCsBYtMIKmVT1+FJKP/wf3CB2DbspOkw5lWHQi2Nnmxx5de26KibnTrO7nGlxykdcL3s9xc3Ru49Nq35JyokWY459DFYV6D0b0YV1bXGTnsVIOViUxTINwgYnmS2/NTUd/UVuQ0GQNL6fxM9TBwrqmwRQ4zoRNZsI5zKYk+AfaGiODN005+1dmrukp4RCdpxHtygvz3IRs+40hBZdW4cWwT+sAUDfsprzdCasLQE+wd0Vcq6zthTf8GEiA1+2gavOcPDFA4Qd5Fi9nfO2f+UhuSduZAdP8oFC6jPIeMlQcS5itipnIJSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773023598; c=relaxed/relaxed;
	bh=Sw7G+FAJvQoL5iq5LVrP56rZpu1xJ282zNbZHOs2M70=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jJ02l69aFfbN5yXehsYMK8j4X7yV7y0qALsLAklTimzQy6IJPVuspj6Eq8Er0Uyw5wXtP0oQt6cBFe0/zKxZFV3kzT+4bzt0IrBWA+v8xPgg9RKzhObwXI2JYS4o4H38cTxW5vuqlZOjj09kfg0kBDkf0NXBLNgXdlN7OeQr89Nb+6yyE/IeHZ+SAAE2zrvlraJlllPJv9ELZEZ4zd0GzLWNGEm6rakqlcsoUK1cpLnv3Jv3Ozurlx8vOxKPcpDrRrAMd8zvLVIASh9kdcVyvdpJxmxEWCYweojs8MWh0LtOTTEt3ZTjv8V7tp6rWVBJehxyvzO96Blhov7MqZDJaA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=XFcW3XHB; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=XFcW3XHB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fTgzd0VKlz2xdL
	for <linux-erofs@lists.ozlabs.org>; Mon, 09 Mar 2026 13:33:16 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BDD7841849;
	Mon,  9 Mar 2026 02:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4815CC116C6;
	Mon,  9 Mar 2026 02:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773023594;
	bh=UHRXakrTsc1OnCQv6OjdV+IhrIi1MUaKGJuHYt9KXeQ=;
	h=From:To:Cc:Subject:Date:From;
	b=XFcW3XHBvVitVs7wcNZ8765c72X8hjCd4D5CzQ8WC3T746MqJmVcsCtmfUd33VqLv
	 229Pqj3TQOGPpxJ8QXHfXm/IxFwQge1Q/qeuHdRunZxT3yFNkHSwcAtAxOlvJHm3c0
	 dw3dwKyurfPEB42cXSemghcQnh9TjdL6qlC3ndg3CXqDb6lRFVaFk3KoQPo/yiawaK
	 sDbm3mzVyq45k44Jq1IuB49ipYjyBshejPimx0L/OL9bOaIfPn5l5fwwO/SwAsjP8c
	 ciljk3QR06ekuRJgrk7bHeGZKL30xhowx9KU4uZXSRfSH3x/lx1TxcCF/oSlgtkm/e
	 bNPLTGnLq2zQw==
From: Chao Yu <chao@kernel.org>
To: xiang@kernel.org
Cc: linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chao Yu <chao@kernel.org>
Subject: [PATCH] erofs: introduce nolargefolio mount option
Date: Mon,  9 Mar 2026 02:30:53 +0000
Message-ID: <20260309023053.1685839-1-chao@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
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

This patch introduces a new mount option 'nolargefolio' for EROFS.
When this option is specified, large folio will be disabled by
default for all inodes, this option can be used for environments
where large folio resources are limited, it's necessary to only
let specified user to allocate large folios on demand.

Signed-off-by: Chao Yu <chao@kernel.org>
---
 Documentation/filesystems/erofs.rst | 1 +
 fs/erofs/inode.c                    | 3 ++-
 fs/erofs/internal.h                 | 1 +
 fs/erofs/super.c                    | 8 +++++++-
 4 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/erofs.rst b/Documentation/filesystems/erofs.rst
index fe06308e546c..d692a1d9f32c 100644
--- a/Documentation/filesystems/erofs.rst
+++ b/Documentation/filesystems/erofs.rst
@@ -137,6 +137,7 @@ fsoffset=%llu          Specify block-aligned filesystem offset for the primary d
 inode_share            Enable inode page sharing for this filesystem.  Inodes with
                        identical content within the same domain ID can share the
                        page cache.
+nolargefolio           Disable large folio support for all files.
 ===================    =========================================================
 
 Sysfs Entries
diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index 4b3d21402e10..26361e86a354 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -254,7 +254,8 @@ static int erofs_fill_inode(struct inode *inode)
 		return 0;
 	}
 
-	mapping_set_large_folios(inode->i_mapping);
+	if (!test_opt(&EROFS_SB(inode->i_sb)->opt, NO_LARGE_FOLIO))
+		mapping_set_large_folios(inode->i_mapping);
 	aops = erofs_get_aops(inode, false);
 	if (IS_ERR(aops))
 		return PTR_ERR(aops);
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index a4f0a42cf8c3..b5d98410c699 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -177,6 +177,7 @@ struct erofs_sb_info {
 #define EROFS_MOUNT_DAX_NEVER		0x00000080
 #define EROFS_MOUNT_DIRECT_IO		0x00000100
 #define EROFS_MOUNT_INODE_SHARE		0x00000200
+#define EROFS_MOUNT_NO_LARGE_FOLIO	0x00000400
 
 #define clear_opt(opt, option)	((opt)->mount_opt &= ~EROFS_MOUNT_##option)
 #define set_opt(opt, option)	((opt)->mount_opt |= EROFS_MOUNT_##option)
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 972a0c82198d..a353369d4db8 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -390,7 +390,7 @@ static void erofs_default_options(struct erofs_sb_info *sbi)
 enum {
 	Opt_user_xattr, Opt_acl, Opt_cache_strategy, Opt_dax, Opt_dax_enum,
 	Opt_device, Opt_fsid, Opt_domain_id, Opt_directio, Opt_fsoffset,
-	Opt_inode_share,
+	Opt_inode_share, Opt_nolargefolio,
 };
 
 static const struct constant_table erofs_param_cache_strategy[] = {
@@ -419,6 +419,7 @@ static const struct fs_parameter_spec erofs_fs_parameters[] = {
 	fsparam_flag_no("directio",	Opt_directio),
 	fsparam_u64("fsoffset",		Opt_fsoffset),
 	fsparam_flag("inode_share",	Opt_inode_share),
+	fsparam_flag("nolargefolio",	Opt_nolargefolio),
 	{}
 };
 
@@ -541,6 +542,9 @@ static int erofs_fc_parse_param(struct fs_context *fc,
 		else
 			set_opt(&sbi->opt, INODE_SHARE);
 		break;
+	case Opt_nolargefolio:
+		set_opt(&sbi->opt, NO_LARGE_FOLIO);
+		break;
 	}
 	return 0;
 }
@@ -1105,6 +1109,8 @@ static int erofs_show_options(struct seq_file *seq, struct dentry *root)
 		seq_printf(seq, ",fsoffset=%llu", sbi->dif0.fsoff);
 	if (test_opt(opt, INODE_SHARE))
 		seq_puts(seq, ",inode_share");
+	if (test_opt(opt, NO_LARGE_FOLIO))
+		seq_puts(seq, ",nolargefolio");
 	return 0;
 }
 
-- 
2.49.0


