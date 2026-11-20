Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5FE606A325
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Nov 2026 09:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=K1G4WrMZ
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jW9hJ535Bz2yQn;
	Fri, 20 Nov 2026 20:56:00 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=103.209.128.69
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795168560;
	cv=none; b=asnPg8Tumekn2VeKSLGxo94NQXHo9/Php1PzDZElXmbX2CZkUwVMQ6UToN201uFHgXFFk3KlRxCJnwTa3pElquB0UZpwNyQr+Y4bIlDRwKj9JbFT857LryP0vFtjOLSnflPDYw521TByla8YPvH0O3ENuIg0kCVW8fjoO5gPD4qQJYyDFV7psq3YwGG4TLl27m+DfQ13Gd6nJPVRT/TOTaqDZmYnxjVRfDK5suMaWP2P6as11hcGDSArH4tEPUfaIMM9RPQZBmqvkpMmXk6zGgP+VMGRY0l7eipernfB6CCDL8frTWS3rXyfH+PMQiZ9mEnxadjX4ajzy6dZgJU87g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795168560; c=relaxed/relaxed;
	bh=PstZ4F2kJr9nVqBfqqiLypyeX5bKaIn6aBPlf582RAQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=XfloW+p12CjJGD9VZbZvX0BVQLI59Yx1wdlz3u3k9MuwnIuAnY55mLQQ4K4cbXVY4NGS96bviHOyjIMAryP2lZ4L6Qa1mRSwDVZyFAOuwkJAMMN5VvK9J1HUw98BNHB7gXGear9xWG+GGCUfOdMiw7cJrVrCm4DlJaYtuBjSOMn2cR0tZMpREckvPg1dq2/mdyPSfsNOH76P3MefFBhzoE7ybipeyGwZymNKSMEttGJVtNY0SjU+nsBzoX34ulcVu3uQSsHNBCjw9e4ieXJ0fhBnNK+YSnoJPOa49+Mogf1O31Ce61sU3M5RYKkRdXXMH/vNCK3EovCNGAM3rbIg1A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com; dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=K1G4WrMZ; dkim-atps=neutral; spf=pass (client-ip=103.209.128.69; helo=mail-m12869.netease.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org) smtp.mailfrom=deepseek.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=K1G4WrMZ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=deepseek.com (client-ip=103.209.128.69; helo=mail-m12869.netease.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org)
Received: from mail-m12869.netease.com (mail-m12869.netease.com [103.209.128.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jW9hF5Hqwz2xpt
	for <linux-erofs@lists.ozlabs.org>; Fri, 20 Nov 2026 20:55:54 +1100 (AEDT)
Received: from localhost.localdomain (unknown [124.243.154.139])
	by smtp.qiye.163.com (Hmail) with ESMTP id 556b0cbfa;
	Fri, 20 Nov 2026 17:55:47 +0800 (GMT+08:00)
From: Wenyuan Xu <sereno.xu@deepseek.com>
To: xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH 1/2] erofs-utils: lib: persist opaque xattrs for rebuilt merged dirs
Date: Fri, 20 Nov 2026 09:55:42 +0000
Message-ID: <20261120095543.2927739-1-sereno.xu@deepseek.com>
X-Mailer: git-send-email 2.43.0
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
X-HM-Tid: 0aa1f862322503a3kunm115447d663c4e6
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZTh1JVkhJQk9JGkJLHRhJHlYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKSU9VSU9IVUpOT1VKSEJZV1kWGg8SFR0UWUFZT0tIVU
	pLSUJNSktVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=K1G4WrMZ+E23/wAGtohbC394ebAQioqMPrAVljCapkmeIXmobQ2L3yGLfwcNvFa/KRoKnT+/pWNuAt5HSjVu8IQp6+r2V6oKNt2QHpg2j58gmhYH8aBUyaTh2qTxABCkVdjO4e5iMGxKAhGWV8CrzKzDuvsGI+dcVHXALiVCPs0=; c=relaxed/relaxed; s=default; d=deepseek.com; v=1;
	bh=PstZ4F2kJr9nVqBfqqiLypyeX5bKaIn6aBPlf582RAQ=;
	h=date:mime-version:subject:message-id:from;
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When rebuilding EROFS layers, an upper directory that overrides a
lower whiteout or an opaque lower directory can lose its
trusted.overlay.opaque marker.  If the rebuilt image is later stacked
with even older layers as additional overlayfs lower dirs, those
layers become visible again.

For example, consider three layers (oldest to newest):

  base:     dir/old
  delete:   dir is a 0:0 whiteout
  recreate: dir/new

After rebuilding the two upper layers:

  mkfs.erofs --clean=data --ovlfs-strip=0 merged.erofs \
             delete.erofs recreate.erofs

and mounting base and merged as lower dirs:

  lowerdir=merged:base

dir/old reappears because the merged dir has no opaque marker.

Fix this by persisting opaque extended attribute for merged directories.

Fixes: 39147b48b76d ("erofs-utils: lib: add erofs_rebuild_load_tree() helper")
Assisted-by: LLM
Signed-off-by: Wenyuan Xu <sereno.xu@deepseek.com>
---
 lib/rebuild.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/lib/rebuild.c b/lib/rebuild.c
index 2fa8feb..44b72ff 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -481,14 +481,30 @@ static int erofs_rebuild_dirent_iter(struct erofs_dir_context *ctx)
 			goto out;
 		mergedir = d->inode;
 		if (erofs_inode_is_whiteout(&src)) {
-			mergedir->opaque = true;
+			/*
+			 * The upper directory hides this whiteout, but older
+			 * layers must stay hidden as well.  Mark the merged
+			 * directory opaque to stop both the current tree merge
+			 * and a later overlayfs merge.
+			 */
+			ret = erofs_set_ovl_xattr(mergedir,
+						  EROFS_OVL_XATTR_OPAQUE,
+						  "y", 1);
 			goto out;
 		}
 		if (!S_ISDIR(src.i_mode))
 			goto out;
-		mergedir->opaque |= erofs_has_ovl_xattr(&src,
-							EROFS_OVL_XATTR_OPAQUE);
+		/*
+		 * The lower directory is opaque, so layers below it must stay
+		 * hidden.  Preserve that property on the merged directory.
+		 */
+		if (erofs_has_ovl_xattr(&src, EROFS_OVL_XATTR_OPAQUE))
+			ret = erofs_set_ovl_xattr(mergedir,
+						  EROFS_OVL_XATTR_OPAQUE,
+						  "y", 1);
 		erofs_inode_free_xattrs(&src);
+		if (ret)
+			goto out;
 		inode = dir = &src;
 	} else {
 		u64 nid;
-- 
2.43.0


