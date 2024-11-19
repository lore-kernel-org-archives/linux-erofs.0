Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CE8DD6007E
	for <linux-erofs@archiver.kernel.org>; Tue, 19 Nov 2024 08:54:54 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Xsyx86Gnyz3bYq
	for <linux-erofs@archiver.kernel.org>; Tue, 19 Nov 2024 19:54:52 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1732006491;
	cv=none; b=k3o72208Gi3o7G2vZ34Ol3SVLyCroVNROWaqIpYKswLB4d/ePRge8bQTOfCWgUt8tGJmVhaLnaTIWQIAdgHhfyHEuQFKRsk6mCNPxrza3Ck/4P5Ydp4QQ2U6lBimOKgRNqqtVQTl+6iKDnVym2xacuB/c8227tbDyzH7WK6EaARjhj/yaWzH119xlc2G0kfcIeALToNAC6pWwDt2oBA732gdtyv/75Mw5bfh1qI9GEiDKwFlNKIzZ4NTECreM1IKjSaqrL9N4pqNLqTTjNYIBxz8AuVVFj6gjucCOYW15skZPOYl3vFNNZotuRGybc/Rfnrm4tAs0uvLy/mf67b8kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1732006491; c=relaxed/relaxed;
	bh=tiZUj1bycmMjw42cmzYE75DZDYhKm2W7iOoKZTukzeU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eOCxVWcfRX/3kHizWjUBNS0iPHVgeyEGqwX6oHsd135IvNItQZAwpBW+nzyNMfa8ZEJTGTwtik3e0YS2Kon0v/j/7iCLWptp4kcO4OM4HNPBHvNmyh41e9IK9YrhSkUIoZMU/iOziUhOUu6mz9hu0jUjWNnOm/3krzQx4o//1uQH/k5YdKqe380YXgWzSXq+6iT6Djm1GQsaHGPhPdDPxBI8MN1ezSfK0vypt8/+dMvAZp+umMEaUhZA3lMzCONwmeQ+oB5oYm1yyy5BS3+aWeSvV1aSL8BNTw4jeWMs4OTUIEQjyNTa43amErQstwO/pIDU9oBC3KzdZ15di4EZPg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=PO0UuaeA; dkim-atps=neutral; spf=pass (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=PO0UuaeA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Xsyx41qCTz2xvR
	for <linux-erofs@lists.ozlabs.org>; Tue, 19 Nov 2024 19:54:45 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1732006479; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=tiZUj1bycmMjw42cmzYE75DZDYhKm2W7iOoKZTukzeU=;
	b=PO0UuaeAHzQK6gqjtbjy0Wc7bA1I7YJqhx9HER5RYB4vr6Y5jmjYF5XIMfJqSc061Itj8IgOFymOTlQCg6Tky06fTa4qnoDX6dN8jcCkwBz22C7GgpH1m4qWpUoA8S+hwuOTFujLC/Y4Pfy+o9Mz/dcLcfrhKQ+foulI7xrVNAk=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WJniw1j_1732006470 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 19 Nov 2024 16:54:38 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH 1/2] erofs-utils: lib: clean up zmap.c
Date: Tue, 19 Nov 2024 16:54:26 +0800
Message-ID: <20241119085427.1672789-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Let's keep in sync with kernel commit 8241fdd3cdfe ("erofs: clean up
zmap.c").

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/zmap.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/lib/zmap.c b/lib/zmap.c
index a5c5b00..e04a99a 100644
--- a/lib/zmap.c
+++ b/lib/zmap.c
@@ -142,8 +142,8 @@ static int z_erofs_reload_indexes(struct z_erofs_maprecorder *m,
 	return 0;
 }
 
-static int legacy_load_cluster_from_disk(struct z_erofs_maprecorder *m,
-					 unsigned long lcn)
+static int z_erofs_load_full_lcluster(struct z_erofs_maprecorder *m,
+				      unsigned long lcn)
 {
 	struct erofs_inode *const vi = m->inode;
 	struct erofs_sb_info *sbi = vi->sbi;
@@ -337,8 +337,8 @@ static int unpack_compacted_index(struct z_erofs_maprecorder *m,
 	return 0;
 }
 
-static int compacted_load_cluster_from_disk(struct z_erofs_maprecorder *m,
-					    unsigned long lcn, bool lookahead)
+static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
+					 unsigned long lcn, bool lookahead)
 {
 	struct erofs_inode *const vi = m->inode;
 	struct erofs_sb_info *sbi = vi->sbi;
@@ -389,18 +389,17 @@ out:
 	return unpack_compacted_index(m, amortizedshift, pos, lookahead);
 }
 
-static int z_erofs_load_cluster_from_disk(struct z_erofs_maprecorder *m,
-					  unsigned int lcn, bool lookahead)
+static int z_erofs_load_lcluster_from_disk(struct z_erofs_maprecorder *m,
+					   unsigned int lcn, bool lookahead)
 {
-	const unsigned int datamode = m->inode->datalayout;
-
-	if (datamode == EROFS_INODE_COMPRESSED_FULL)
-		return legacy_load_cluster_from_disk(m, lcn);
-
-	if (datamode == EROFS_INODE_COMPRESSED_COMPACT)
-		return compacted_load_cluster_from_disk(m, lcn, lookahead);
-
-	return -EINVAL;
+	switch (m->inode->datalayout) {
+	case EROFS_INODE_COMPRESSED_FULL:
+		return z_erofs_load_full_lcluster(m, lcn);
+	case EROFS_INODE_COMPRESSED_COMPACT:
+		return z_erofs_load_compact_lcluster(m, lcn, lookahead);
+	default:
+		return -EINVAL;
+	}
 }
 
 static int z_erofs_extent_lookback(struct z_erofs_maprecorder *m,
@@ -421,7 +420,7 @@ static int z_erofs_extent_lookback(struct z_erofs_maprecorder *m,
 
 	/* load extent head logical cluster if needed */
 	lcn -= lookback_distance;
-	err = z_erofs_load_cluster_from_disk(m, lcn, false);
+	err = z_erofs_load_lcluster_from_disk(m, lcn, false);
 	if (err)
 		return err;
 
@@ -471,7 +470,7 @@ static int z_erofs_get_extent_compressedlen(struct z_erofs_maprecorder *m,
 	if (m->compressedblks)
 		goto out;
 
-	err = z_erofs_load_cluster_from_disk(m, lcn, false);
+	err = z_erofs_load_lcluster_from_disk(m, lcn, false);
 	if (err)
 		return err;
 
@@ -532,7 +531,7 @@ static int z_erofs_get_extent_decompressedlen(struct z_erofs_maprecorder *m)
 			return 0;
 		}
 
-		err = z_erofs_load_cluster_from_disk(m, lcn, true);
+		err = z_erofs_load_lcluster_from_disk(m, lcn, true);
 		if (err)
 			return err;
 
@@ -581,7 +580,7 @@ static int z_erofs_do_map_blocks(struct erofs_inode *vi,
 	initial_lcn = ofs >> lclusterbits;
 	endoff = ofs & ((1 << lclusterbits) - 1);
 
-	err = z_erofs_load_cluster_from_disk(&m, initial_lcn, false);
+	err = z_erofs_load_lcluster_from_disk(&m, initial_lcn, false);
 	if (err)
 		goto out;
 
-- 
2.43.5

