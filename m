Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64155D49794
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Dec 2024 02:41:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Y1p2P29Zzz2yys
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Dec 2024 13:41:33 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1733107291;
	cv=none; b=FNCt5ygjpxb2peRbR5RCC1/0yS0WAnk3AyiIt7sk5HTlVEMMTlzMI1dnwDkWn29FkXEV/D66X4X2kybtk87zLtbDyRijhawjEqHYXN/kvQeDANYvS4hidhvWM8U0vXW39sgpfiD/gUCGtT3ZSaShYOZfDlDFRa464EsW9ZxRf5vWeWJEAykPoibLLlyPjPK5cBXiUKTWW7NlOV+Ms86NaT8PQdDrOpyatMYSUUgriWOw2cEQyAY4K55v9e9x3DmlAEbHxt6HEhB7LOe2o9tOBk4nU5YwGHLSRJq99CJ3YV4YmGSW2Br9X2KNokuf5Slh9JWHa5lEsVOK68RkXLks+A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1733107291; c=relaxed/relaxed;
	bh=FvK2g08vj+6KG9IXyDMz1/RzTNnqD0lw+Y9crBnUCgY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KhDx2gJQcRZvAOnP0uTdN/QE7Kccvty672q8m8L6giLsBKZhWrlaL4HD92wKpVfg5YWahRPpCqofSR6/gGko6RKApK4X5lJJU+AYq2mSrBLIxt/K+x1CDU/xSlF3ICeQMi6YzmY0wPuXTeP/ienIMTGv+W3u9jwdU9VArV78lqnovIWm3hJPKFq37xRXdIvzIBJfx0HUKIRuMr0O1fJfKf7omkGMXPv3ySrssJD2a40ivM5Ob1fD+3nbVDM4slPELs1Xwja4UaQ0FtXdkF/NFUQNnOrP08qeTEj2o1oiYKvPgEb53Ol9WiqNOYqrKRQKPqKxA+31SDxiuqIaVThxbw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=cj6wR46J; dkim-atps=neutral; spf=pass (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hongzhen@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=cj6wR46J;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hongzhen@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Y1p2G4FTdz2yVd
	for <linux-erofs@lists.ozlabs.org>; Mon,  2 Dec 2024 13:41:22 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1733107277; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=FvK2g08vj+6KG9IXyDMz1/RzTNnqD0lw+Y9crBnUCgY=;
	b=cj6wR46JoZI1NQVlDtN4kLjwBZ4H1rphGryuyeA98TYHUIaa2/9TjMQIWH9tyOemFuk0IgCdzWVrMhD21G11jrSlOmT+gCj2tCfF0jGnmkof9B4hAZACXvy6IaDI/jQP83B77tze05IlPAjP5w4m6AW1HmU3cfXEwikkxlPZIK4=
Received: from localhost(mailfrom:hongzhen@linux.alibaba.com fp:SMTPD_---0WKbbzZA_1733107275 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 02 Dec 2024 10:41:16 +0800
From: Hongzhen Luo <hongzhen@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: lib: fix user-after-free in xattr.c
Date: Mon,  2 Dec 2024 10:40:19 +0800
Message-ID: <20241202024019.85901-1-hongzhen@linux.alibaba.com>
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Currently, put_xattritem() does not remove the `item`
from the hash table after freeing it, which may lead
to a user-after-free issue.

This patch fixes it.

Fixes: 47d6895a5ff9 ("erofs-utils: introduce inline xattr support")
Signed-off-by: Hongzhen Luo <hongzhen@linux.alibaba.com>
---
 lib/xattr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/xattr.c b/lib/xattr.c
index 7fbd24bbdd75..e4207758fa62 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -169,6 +169,7 @@ static unsigned int put_xattritem(struct xattr_item *item)
 {
 	if (item->count > 1)
 		return --item->count;
+	hash_del(&item->node);
 	free(item);
 	return 0;
 }
-- 
2.43.5

