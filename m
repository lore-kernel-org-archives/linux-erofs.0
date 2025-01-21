Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A7EFC0218B
	for <linux-erofs@archiver.kernel.org>; Tue, 21 Jan 2025 16:56:44 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Yctf20gsbz30gv
	for <linux-erofs@archiver.kernel.org>; Wed, 22 Jan 2025 03:56:42 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1737478600;
	cv=none; b=CWGL5++nhAFbexLur7NbhpLHEUn7G6Csd0Vi5fIt/X/IgfVe4F4oxyJR/P+D+CwtMKbAZI2rEmpfEEBNOR0ofpME+rXVQVE7FUanIc4CucU3DCqbq0Ly/EeLEBhVwZ++qaPc88Vupo17Xyvgnp/mh/TBUdNHXOqAN2WZnMZ6sI77e45OROmQIZ+tRbpuAoc8sEoqmzgVt1mUfUuZCnJ1heFcCZfI7dy86feZ7vd7pO4mw86PtzXh+CSpNQkuqJMz23RkVwX7O6i9ZyIK23G3MCZejAF1uCGYVLHfHvfal4Zjzasy3RMepGiqKmNoFG7V+jPSVOnw7zuF8WYKEFGO1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1737478600; c=relaxed/relaxed;
	bh=aYCzigHjBXd6jwCFHy27yg8mLNZ4vSXxl+gmflSo8Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HT78WyJx21879zruTUquDiho3fCW/GZ/IelCKLymtwr5yTpEO7dIYSkcjn0fa3AH5synUEnbogt/RXX1SlY9+gkh4amq2dDRBFtiNA1BOePEWYpKTRAuRj44WA5e6xuNuSL7KiX8M7tEO1b5nQvCk1QwQZZo/wc9UzG/ubohfsMwGltJZJ6pyHNKkKt0UPKhfYcyE46yjK2SsKWbe6ukR19zPRD9vC1k2jL3Y+D0jb2Ltqxkuh8WfsjaO+CaohXPp3/WbUuGXuknMFObEyneN2BJDpD7ScecaCthI7exl05f6mSR/bb+YUBh1WNf1mgA4t8wa6Kjy7WF0C/lfpB9Pg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=qyywRfR0; dkim-atps=neutral; spf=pass (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=qyywRfR0;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Yctdz0KGrz30WB
	for <linux-erofs@lists.ozlabs.org>; Wed, 22 Jan 2025 03:56:37 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1737478592; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=aYCzigHjBXd6jwCFHy27yg8mLNZ4vSXxl+gmflSo8Kg=;
	b=qyywRfR0PMI8GV2igvNxz3Bsn0l50knJIxSVB03uQcPZ+TjiNMfUr1S2p7kFAjwj6Zf6gPj92A07byy+RNFkN+JXDMlOXnESmXao+2hWBDwPLyZHPuhFtoBdUWFrwjbIj0O0Nf0xw+xyAzUpRLuIz8+C4P2fjnpr3ML9Bh38JN4=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WO5xK.N_1737478583 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Jan 2025 00:56:31 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: mkfs: keep one-block uncompressed data for deduplication
Date: Wed, 22 Jan 2025 00:56:22 +0800
Message-ID: <20250121165622.2095470-1-hsiangkao@linux.alibaba.com>
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

Otherwise, the deduplication rate will be impacted, but it doesn't
mattersince `-Ededupe` is still single-threaded.

Fixes: 341d23a878a2 ("erofs-utils: mkfs: speed up uncompressed data handling")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/compress.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/compress.c b/lib/compress.c
index 5c9c051..604a04c 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -376,6 +376,7 @@ out:
 	return 0;
 }
 
+/* TODO: reset clusterofs to 0 if permitted */
 static int write_uncompressed_block(struct z_erofs_compress_sctx *ctx,
 				    unsigned int len, char *dst)
 {
@@ -616,9 +617,11 @@ static int __z_erofs_compress_one(struct z_erofs_compress_sctx *ctx,
 			may_packing = false;
 			e->length = min_t(u32, e->length, ret);
 nocompression:
-			/* TODO: reset clusterofs to 0 if permitted */
-			ret = write_uncompressed_extents(ctx, len,
-							 e->length, dst);
+			if (cfg.c_dedupe)
+				ret = write_uncompressed_block(ctx, len, dst);
+			else
+				ret = write_uncompressed_extents(ctx, len,
+							e->length, dst);
 			if (ret < 0)
 				return ret;
 		}
-- 
2.43.5

