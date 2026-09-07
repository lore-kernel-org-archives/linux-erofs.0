Return-Path: <linux-erofs+bounces-4486-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38578C79FAB
	for <linux-erofs@archiver.kernel.org>; Mon,  7 Sep 2026 08:31:30 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hdgJw4qKsz2yvY;
	Mon, 07 Sep 2026 18:31:28 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788769888;
	cv=none; b=JG9oUIk0N0bppVQ4KCHsAM8ob0sXXMAy8jFqXykPCWgOGu01GiMSK0kcWZk5CpDiKtE3RM25wVlVa2bFo/CvZdOsOBjuyA1icUiEG3pAM4kwEKEiTw2nPZFIWjKwfIULIaf1I9e7e4BgSTNUsW7T6zclPplAbOseZrEfpihmqLIiIZdNfXIN4cZF9BdX/LsPvtIgF65GEQv3iN2v9kYbymTj3l8hevnorfDyeTMrvEgj1o9AxDCiIsKXxQOoGbZEjOS9bokuvaD1bVwwDff5gnfgTlqh5ibWxCdi43rZd7nbqJQD7EuovRs9MPEAd/BSDgZTdV9BETeOBBXHFi/pfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788769888; c=relaxed/relaxed;
	bh=/+Rpotpp07r4mfUKgAyUQ1qqA7gGdrbmwbMtE4ZcMu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jD4ty6vDhlRvCWTN6SdeLF1ZpGF25afWoIV0xnbKXn3LmJgKn8BEISsFGH9aRZGvEgo3d0yXKBpq12BWv3aJHfQhlDIgksE+oFTuWt6e4KDSPvyUWsGw1Bcl8XRAGfRQ0X8aPjjHGoPZPeNVkTuo0kYZmlZ5HvwO267LXrd2xKKPm7txJ9NmMfS+w8/Q/TjZpeXEupdQoDtGhTjwf7RI8pNwv/3kyLZkJvvePbI5pP74B9um79sd266ngAOKapkaZg4mBfsFVPcz5/f671hmQur3LmO9KgGCG9/dMIgO5Sona0zL/yvvkjWN+D4dV68hRjJLJJAOW3BMvUjaF3SFEg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dSMocdgf; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dSMocdgf;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hdgJw0b4Sz2xpv
	for <linux-erofs@lists.ozlabs.org>; Mon, 07 Sep 2026 18:31:28 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 90FD5411E7;
	Mon,  7 Sep 2026 08:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAE61F00A3A;
	Mon,  7 Sep 2026 08:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788769886;
	bh=/+Rpotpp07r4mfUKgAyUQ1qqA7gGdrbmwbMtE4ZcMu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dSMocdgfjey+ps9vlJ+qQ/E4kQFABsh4qHUYvY7SiUTQ6dm152Ez/RmaXHQYZa5zx
	 lRibI8CJq1K/HUxozZOx3SZEpzqG3AIxK0Wjm6KPuiw/U/kHEGqRsdODlr7X9hopZn
	 Gy0KNxcVOdrby1RLpcKQcoYOYKPbCKAJILRRoLH56l9op/4rzprOaLJgD/dXxZ8t2t
	 uj3H7yQGFHOtN8ZeOmCYRPG3RME8uB2Dbhi8dHC+7Z/7oAUZIVg3T9JkmCbOvC3kPq
	 YvfuBa5SRjHAeZ6aYNMkxmllO8JFOrTA5JAjMa3ScgnNMaSsLnUM75xdKlExjs5Z+W
	 GOyTvx/83VmdQ==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Yifan Zhao <yifan.yfzhao@foxmail.com>,
	Gao Xiang <xiang@kernel.org>
Subject: [PATCH 2/2] erofs-utils: lib: fix direct S3 writes to blob devices
Date: Mon,  7 Sep 2026 16:30:27 +0800
Message-ID: <20260907083027.13793-2-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907083027.13793-1-xiang@kernel.org>
References: <20260907083027.13793-1-xiang@kernel.org>
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

From: Yifan Zhao <yifan.yfzhao@foxmail.com>

Direct S3 writes target the primary device and may leave the selected
blob device shorter than its allocated extent.

Write objects at device-relative offsets on the selected device.
and extend it to the final block boundary.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Yifan Zhao <yifan.yfzhao@foxmail.com>
Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 lib/remotes/s3.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/lib/remotes/s3.c b/lib/remotes/s3.c
index 56ab808..01dd1ff 100644
--- a/lib/remotes/s3.c
+++ b/lib/remotes/s3.c
@@ -1054,15 +1054,19 @@ static int s3erofs_remote_getobject(struct erofs_importer *im,
 
 	resp.pos = 0;
 	if (!sbi->available_compr_algs && im->params->no_datainline) {
+		unsigned int device_id = im->params->ddev_id_def;
+
 		inode->datalayout = EROFS_INODE_FLAT_PLAIN;
 		inode->idata_size = 0;
 		ret = erofs_allocate_inode_bh_data(inode,
 				DIV_ROUND_UP(inode->i_size, 1U << sbi->blkszbits),
-				im->params->ddev_id_def);
+				device_id);
 		if (ret)
 			return ret;
-		resp.vf = &sbi->bdev;
-		resp.pos = erofs_pos(inode->sbi, inode->u.i_blkaddr);
+
+		resp.vf = device_id ?
+			sbi->devs[device_id - 1].bmgr->vf : &sbi->bdev;
+		resp.pos = erofs_pos(sbi, erofs_inode_dev_baddr(inode));
 		inode->datasource = EROFS_INODE_DATA_SOURCE_NONE;
 	} else {
 		if (!inode->i_diskbuf) {
@@ -1179,7 +1183,7 @@ int s3erofs_build_trees(struct erofs_importer *im, struct erofs_s3 *s3,
 		ret = __erofs_fill_inode(im, inode, &st, obj->key);
 		if (!ret && S_ISREG(inode->i_mode)) {
 			inode->i_size = obj->size;
-			if (fillzero)
+			if (fillzero || !inode->i_size)
 				ret = erofs_write_zero_inode(inode);
 			else
 				ret = s3erofs_remote_getobject(im, s3, inode,
-- 
2.47.3


