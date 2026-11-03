Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473BA606A332
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Nov 2026 06:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X6aCophM
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jJdw22L6Gz2xXB;
	Tue, 03 Nov 2026 17:29:38 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip=172.234.252.31 arc.chain=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793687378;
	cv=pass; b=gWl2JOK2RgjwN/NmrK2BvsBXG8HWZSfSfbVStNxSDnTcnL3ORmZd0n4iuZGjaZcZISTqkLyv9Ub6vxNPFgDbxdhkFlwbGL+/MKk10vK5zerECpGDGheFSDJJ/Xp7Wzxf7wNYpmd76+CtpAY/b9K0zTrgvyLZjrdqLVT6h68R+hWXc01mHrxgL9LgS3euAZY9SfuQ09Awgy/BsXlQG2XMyZ+Qo36x/XuohHYvHyIAvxJN9lPcBrNrken3YVf68kbKzMHZwe2e324xl7f9FiTc/EEgmP+s12buRM2j07IZ3xEoyEYm18xCp3J2VxeZUDNHsi4PShkiGoIvj/67StVzgw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793687378; c=relaxed/relaxed;
	bh=7UPmuk4TFC5ZpEEeEBchAtDv38dC4JEqbtSylYNe2BE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XBdFQ4Nr+KZNjOqq0LCS39Yqe3tijQ/Ncpx2xiCC+FpfvaZNG0nzA4zekeMH1ItfF5DGYjZQIfkc8IWddnlhe0SVHtCmZHs7RuYRMk8nxVRVOvllgDshUtcVWNmVkrVc4xhcgJiGeOK/jzRcaZ4X8R+vJDpcJvfH2QG3Dc+Of6BPW2hwPey1JiHTHTSpJPa8zWbaF56J4G6hI6XHf0ATS2pv0I5T4AAsWpgEcGFfNX+oa3j0RP0TkFbUsFG8WIORw2Q3+XYVGj1P3FIcP/n2J82mLX3OkPyod4CT+CoBkteaxkuN/HDvebxQDcUMuSeOBIfD3pgPmY3j4PiaLAgySw==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X6aCophM; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=devnull+daejun7.park.samsung.com@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X6aCophM;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=devnull+daejun7.park.samsung.com@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jJdvz6wR1z2xMQ
	for <linux-erofs@lists.ozlabs.org>; Tue, 03 Nov 2026 17:29:35 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D005843B4B;
	Tue,  3 Nov 2026 06:29:32 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793687372;
	b=ApRbXla/LMwvJrpLG6ExGmVcncQiY+gAw4x882xiVEyaVcv09a2dxOVP1G3zQRvZ/BkI
	 9GAZpmlu/FVx+7uj7rt8T9KDtlqLmW4Ry8/Wj5zoXYovXdaVZ2eadOIpbNWrBPj3j8/RX
	 7cVODPUNicsMR775E6+KmmZvVtZYWgja5YmwNOJXPvMDJGmLRi7A8tW20hy6JSNrcGJiO
	 rZmZduZQ2g/xm063yE/nJx9sW7Jihj6mNe8JXz64oQRtoDqqhD6JsmJn24uqdPisbe3r8
	 8BRLxWIN+hxjHdSalon5YbDtRX76s0GuEqPEckfIXgm+UyOYKxjLltL5DW5rMOzPNCw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793687372;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=7UPmuk4TFC5ZpEEeEBchAtDv38dC4JEqbtSylYNe2BE=;
	b=mrLG+7nREFFDEvWNbOxbpxiJdQb7lNAD/7pYL5UMzxYJvDqCESqfgFSCJtDuD7iCn2nf
	 502sp+ZJnmIKeOm39jZqJPTOPL+pEw6gYSjQngEdROq2RNkv1rzmLjdoo59FmM07GJDap
	 ksxuanLqDPBogtFV/dTXqwHT9ITzdd+eMveVX5cdv8I8P6jXreW6rJq2jMWcSbwNVGp4m
	 c/doAEz+jQp3RKxd151vIYD6F8EUNX+BzWr/jR/Ww0LN1mIR7V9lyI4q9DkHpTBrAzxPW
	 oT1P/NqfFeRO6zB5wZBexF9/bvoLmPBo6oXOgDIvcIwhqF7FtZDMAsWj5C6zwoUFi1A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BB4ED1F00A18;
	Tue,  3 Nov 2026 06:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793687372;
	bh=7UPmuk4TFC5ZpEEeEBchAtDv38dC4JEqbtSylYNe2BE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=X6aCophMR1lsAYRXpxIlT6YvzgeyFEYvVR8t/b+S32DH+2qf9kW6AtldiTFJB7PUe
	 07KYjM+WxUzRcY16aaRYcsI4HugwIx4245ktCr66E1HukjaGFFnjd4IAyTaQqNzkiJ
	 9Tbe1a6iiGWESFEiS7Bdl23L92ortgPqEkdYVB+xbt9N67wHUqZBnCvvcCNoILLRJ5
	 ZXRt0wO+lloDVJ+t2O5x5+IglVHmg5rj6nOTOFhkvj6llNNoLLC/somyZInl6NsnVc
	 z8ExXcYG3v/YooJtjP0J/o5dBlWALdQmJsIyyZlJEmHuA99flJeRVKZKxe9799e1kx
	 AVtqvTMsoKrMg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3C8CA467E2;
	Tue,  3 Nov 2026 06:29:31 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Tue, 03 Nov 2026 15:29:32 +0900
Subject: [PATCH v2 2/3] erofs: treat files shared by inode_share as stacked
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
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261103-erofs-fileio-bioset-v2-2-5b91af423f72@samsung.com>
References: <20261103-erofs-fileio-bioset-v2-0-5b91af423f72@samsung.com>
In-Reply-To: <20261103-erofs-fileio-bioset-v2-0-5b91af423f72@samsung.com>
To: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>
Cc: Yue Hu <zbestahu@gmail.com>, Jingbo Xu <jefflexu@163.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793687370; l=2096;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=KxcTgYYaPu5ba+F2AtFEMVGnO9mL8oKwwj4AMcUNn08=;
 b=S2n4lwsiv48b8UmHOXyIuZvRI8taOqLM2WUyGaIMQkzTKbeosLWqY2VLTTxtt3lXybxjk8GeO
 tfdGCvnzh0AAsqQdRw3rYVFSDUmFZHEXvR9Rr4zYg0qWgt80rOcwHju
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Daejun Park <daejun7.park@samsung.com>

A file-backed mount whose image or extra device is on a block-backed
EROFS passes erofs_is_stacked_file(). If inode_share shares that file,
erofs_real_inode() may pick an inode of a file-backed EROFS in the same
domain to read it. File-backed reads then nest in the same task.

Treat files that use erofs_ishare_fops as stacked.

Fixes: 34096ba919fd ("erofs: support unencoded inodes for page cache share")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20261030-erofs-fileio-bioset-v1-1-caf47adbb3a3@samsung.com
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 fs/erofs/super.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index ee01a5ef85..e92a7fa90a 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -125,9 +125,12 @@ void *erofs_read_metadata(struct super_block *sb, struct erofs_buf *buf,
 /* see the comment in erofs_fc_fill_super() */
 static bool erofs_is_stacked_file(struct file *file)
 {
-	struct super_block *sb = file_inode(file)->i_sb;
+	struct inode *inode = file_inode(file);
+	struct super_block *sb = inode->i_sb;
 
-	return (sb->s_op == &erofs_sops && !sb->s_bdev) || sb->s_stack_depth;
+	return (sb->s_op == &erofs_sops && !sb->s_bdev) || sb->s_stack_depth ||
+	       (IS_ENABLED(CONFIG_EROFS_FS_PAGE_CACHE_SHARE) &&
+		inode->i_fop == &erofs_ishare_fops);
 }
 
 static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
@@ -713,6 +716,9 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 		 * EROFS is the only fs supporting file-backed mounts for now.
 		 * It MUST change if another fs plans to support them, which
 		 * may also require adjusting FILESYSTEM_MAX_STACK_DEPTH.
+		 * Files shared by inode_share may be read through a
+		 * file-backed EROFS in the same domain, so treat them as
+		 * stacked too.
 		 */
 		if (erofs_is_stacked_file(sbi->dif0.file)) {
 			erofs_err(sb, "file-backed mounts cannot be applied to stacked fses");

-- 
2.43.0



