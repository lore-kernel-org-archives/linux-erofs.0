Return-Path: <linux-erofs+bounces-3776-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 858C7C43458
	for <linux-erofs@archiver.kernel.org>; Mon, 29 Jun 2026 04:48:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gpYgf3krZz2ySS;
	Mon, 29 Jun 2026 14:48:14 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782708494;
	cv=none; b=SLnUC0/Ddidic8HmRcZCD7CqLYk7IXW3V44uHB7Dq0vBsNfNXsEqFlc+gkrWB2Yu6j7OouZr4yC8whaLyoeIsaGWxwBbxesNGbanaeIkWuq/2mYbPoBVHsMPbRS7OhkSpSlDb1/2xTl3RIQ0pv+7C3XNWSrX+jipSxc8BGEcvItOyITLELEEi2JBk0czEIio7ZlspZXE8CmtiXwjv8xlujTkIEmG0hIce/wWucJxTW9GXU40HXoDxCendh3AadXpWtKjAoXjX60zyFdZ1DjVXnJeQzOUWyCfDrDHipoe/ejTJC4Te8mep3mkscdAXXV7OXdnzK5IaqmPkz8L5YI0GA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782708494; c=relaxed/relaxed;
	bh=RMhGS0VX4wyeR2jhDi8YOuFhu1ZhlZQnxqKkIBJ3p0g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G4MKpat2qegWEd0GLOOiaa7IPLh5j8N9gobk7DXliSNHnxZujuzxp6k4QtZTR+8xyCam74EnOFnqdy//q/yx3vGp+VAG88QkDPfgTR/y6+jkpAqNiFi+9QhU1C7Q57cwugqBFeSybTgnDiEdCJ+gTsYwC59tcoR8zafPah+axEogGNeVAibTh2iK21yUv903YPl89bgZ47lUTtLbkxadm62xYP+H40vzh/EwYKZZcnrGPkfP3eQEeBfLMqcqUtmi/8xFmTyowP9Kv0UZl5rV4CIvIkM95Ne1lnfnJ0aQpgcPYa3izBy+hzWILTRDlWG1YJQWOcJaM+xocVL1It+vaA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=DxgHeXwI; dkim-atps=neutral; spf=pass (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=DxgHeXwI;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gpYgb5V3Dz2ySJ
	for <linux-erofs@lists.ozlabs.org>; Mon, 29 Jun 2026 14:48:09 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782708485; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=RMhGS0VX4wyeR2jhDi8YOuFhu1ZhlZQnxqKkIBJ3p0g=;
	b=DxgHeXwIV40RrrwOJcsQ6wLVwnLLmrRTxYLnhqmTmc/2jRyGVXP3H4PRyS4iWf6jGwG2JeLhf4SSfDECfmLXGVI5jIXq9NZeHzThP1biK97hPd01xdd2EJNB69/x3rou7LI8cYsdLZqLnt4HjHOsjQQAHdo+ZX9ukhSvKBvsits=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R501e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X5mesO2_1782708480;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5mesO2_1782708480 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 29 Jun 2026 12:48:04 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>,
	Tristan <TristanInSec@gmail.com>
Subject: [PATCH] erofs-utils: lib: switch ZSTD decompression to streaming API
Date: Mon, 29 Jun 2026 12:47:59 +0800
Message-ID: <20260629044759.2166171-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
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

Currently, the ZSTD decompressor uses ZSTD_getFrameContentSize()
to get the untrusted on-disk ZSTD frame size, which can cause
heap OOB read.

Use streaming API ZSTD_decompressStream() instead.

Reported-by: Tristan <TristanInSec@gmail.com>
Closes: https://lore.kernel.org/r/CAA1XrhPMekMqAnRkC-jV9rTsO4LHjzh=kxn6zQKMgBrqfrnp8A@mail.gmail.com/4-zstd-decomp-oob-read.txt
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/decompress.c | 81 ++++++++++++++++++++++++++++++------------------
 1 file changed, 51 insertions(+), 30 deletions(-)

diff --git a/lib/decompress.c b/lib/decompress.c
index 81b855f61b4c..de5ec970d10c 100644
--- a/lib/decompress.c
+++ b/lib/decompress.c
@@ -28,57 +28,78 @@ static unsigned int z_erofs_fixup_insize(const u8 *padbuf, unsigned int padbufsi
 /* also a very preliminary userspace version */
 static int z_erofs_decompress_zstd(struct z_erofs_decompress_req *rq)
 {
-	int ret = 0;
+	ZSTD_DStream *dstream;
+	ZSTD_inBuffer in;
+	ZSTD_outBuffer out;
 	char *dest = rq->out;
 	char *src = rq->in;
 	char *buff = NULL;
-	unsigned int inputmargin = 0;
-	unsigned long long total;
+	unsigned int inputmargin;
+	int err = 0;
+	size_t ret;
 
 	inputmargin = z_erofs_fixup_insize((u8 *)src, rq->inputsize);
 	if (inputmargin >= rq->inputsize)
 		return -EFSCORRUPTED;
 
-#ifdef HAVE_ZSTD_GETFRAMECONTENTSIZE
-	total = ZSTD_getFrameContentSize(src + inputmargin,
-					 rq->inputsize - inputmargin);
-	if (total == ZSTD_CONTENTSIZE_UNKNOWN ||
-	    total == ZSTD_CONTENTSIZE_ERROR)
-		return -EFSCORRUPTED;
-#else
-	total = ZSTD_getDecompressedSize(src + inputmargin,
-					 rq->inputsize - inputmargin);
-#endif
-	if (rq->decodedskip || total != rq->decodedlength) {
-		buff = malloc(total);
+	if (rq->decodedskip) {
+		buff = malloc(rq->decodedlength);
 		if (!buff)
 			return -ENOMEM;
 		dest = buff;
 	}
 
-	ret = ZSTD_decompress(dest, total,
-			      src + inputmargin, rq->inputsize - inputmargin);
+	dstream = ZSTD_createDStream();
+	if (!dstream) {
+		err = -ENOMEM;
+		goto out_free_buff;
+	}
+
+	ZSTD_initDStream(dstream);
+	in = (ZSTD_inBuffer) {
+		.src = src + inputmargin,
+		.size = rq->inputsize - inputmargin,
+	};
+	out = (ZSTD_outBuffer) {
+		.dst = dest,
+		.size = rq->decodedlength,
+	};
+
+	ret = ZSTD_decompressStream(dstream, &out, &in);
 	if (ZSTD_isError(ret)) {
-		erofs_err("ZSTD decompress failed %d: %s", ZSTD_getErrorCode(ret),
-			  ZSTD_getErrorName(ret));
-		ret = -EIO;
-		goto out;
+		erofs_err("ZSTD decompress failed: %s", ZSTD_getErrorName(ret));
+		err = -EFSCORRUPTED;
+		goto out_free_dstream;
 	}
 
-	if (ret != (int)total) {
-		erofs_err("ZSTD decompress length mismatch %d, expected %d",
-			  ret, total);
-		ret = -EIO;
-		goto out;
+	if (rq->partial_decoding) {
+		if (out.pos < rq->decodedlength) {
+			erofs_err("ZSTD decompress length mismatch: got %zu, expected %u",
+				  out.pos, rq->decodedlength);
+			err = -EFSCORRUPTED;
+			goto out_free_dstream;
+		}
+	} else if (ret != 0) {
+		erofs_err("ZSTD frame not fully decoded");
+		err = -EFSCORRUPTED;
+		goto out_free_dstream;
+	} else if (out.pos != rq->decodedlength) {
+		erofs_err("ZSTD decompress length mismatch: got %zu, expected %u",
+			  out.pos, rq->decodedlength);
+		err = -EFSCORRUPTED;
+		goto out_free_dstream;
 	}
-	if (rq->decodedskip || total != rq->decodedlength)
+
+	if (buff)
 		memcpy(rq->out, dest + rq->decodedskip,
 		       rq->decodedlength - rq->decodedskip);
-	ret = 0;
-out:
+
+out_free_dstream:
+	ZSTD_freeDStream(dstream);
+out_free_buff:
 	if (buff)
 		free(buff);
-	return ret;
+	return err;
 }
 #endif
 
-- 
2.43.5


