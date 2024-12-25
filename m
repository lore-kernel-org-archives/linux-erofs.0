Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDB12E7718B
	for <linux-erofs@archiver.kernel.org>; Wed, 25 Dec 2024 07:05:17 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4YJ2p34Rszz30TG
	for <linux-erofs@archiver.kernel.org>; Wed, 25 Dec 2024 18:05:15 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.130
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1735110314;
	cv=none; b=GqVSk0s09zCuHLm3VI7praSu55NndskM2wYlHL0aVru7pHQaR2ReDBW6CRG7z/TlvRbSCQbr3PzenS7Jm1Ut8KCd5b+R9kRkQNezwRZlQf7LqwbcQIvzO9M5ieKom+2zvLrKTgFiFuhi/A4Tcg6wjT3ZPSvoN3EVveZ0ioPwcQYkIWHCHuJLIA6ov6xVB/Q+a6jexKunsE+WTXIVXuAy8gVhN5kqXDo5J5XF+9+cROwpqnBsTjYqEi1yA054GyrOUvDiM7FRP4m/5zdYEAHCp7SYulL7ccbBfXv1GNQKvFOXhoIgDnA87rRqefKrsuOydJxcxka5PNY9RPuhrYSYRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1735110314; c=relaxed/relaxed;
	bh=uFA+Uoi5WGXB+V9sy8WPkjCh92j4KWNrpkS2BK1o5XM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bpjhl44SUeiCGxXOnSPFkd8/42g9HhxZOjlD+TWFcaCTShbZ+55v1JT/YfvU3G5zL0HxFBpCIXJOaoxXwp1WE5j78tTYeb0ijNX2FgHYHcf4Ae6iUlZUjSNe9GgK1fiyxvC6UePbLmE8YRYEkfuwRT+hwpGck7PXUdBH6PVmJzSWbxCnVPMRR7naKpteaYWJ5EiEWfRby+YguxD+3EqnUhmyJRZ1sq5C5WB+B5UNiHEu37tmvd9BvdUHdN3aXlYFeZsHZy2MmHhg2I+waFSrgQYFNfz9G3aiOpgD5ndteZjHnB/nMpZrGudVym/gzRkEk4fKpGM97WuzVcc+1IK0xQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Y/dksVPO; dkim-atps=neutral; spf=pass (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Y/dksVPO;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4YJ2nz4P4Zz2yGT
	for <linux-erofs@lists.ozlabs.org>; Wed, 25 Dec 2024 18:05:09 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1735110304; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=uFA+Uoi5WGXB+V9sy8WPkjCh92j4KWNrpkS2BK1o5XM=;
	b=Y/dksVPOzsKqJ5oO79cCBSevlVktosqgU47b4wfxgZm58l4yuyzBxXNJHQGIXNn/BUQXAPpC9Eb++QhKdjLcxwC+GuskMihnKayyxl4OKqeaPpiGv+NNfPGwyHKG8XJAE4K82NcRhjtD2z6cZvaRTAjQksFu49aVwSGhzfR7b6E=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WMEIRdi_1735110295 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 25 Dec 2024 15:05:00 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: lib: fix btype for the data tails of directories
Date: Wed, 25 Dec 2024 15:04:54 +0800
Message-ID: <20241225070454.750271-1-hsiangkao@linux.alibaba.com>
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

It should be DIRA instead of DATA for directories.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/inode.c b/lib/inode.c
index de6d020..7ee5d78 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -870,7 +870,8 @@ static int erofs_write_tail_end(struct erofs_inode *inode)
 		erofs_off_t pos, zero_pos;
 
 		if (!bh) {
-			bh = erofs_balloc(sbi->bmgr, DATA,
+			bh = erofs_balloc(sbi->bmgr,
+					  S_ISDIR(inode->i_mode) ? DIRA: DATA,
 					  erofs_blksiz(sbi), 0);
 			if (IS_ERR(bh))
 				return PTR_ERR(bh);
-- 
2.43.5

