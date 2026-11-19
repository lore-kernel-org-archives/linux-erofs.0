Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31C4606A32F
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Nov 2026 00:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=KfXFkcKq
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jVKQr17CCz2xkr;
	Thu, 19 Nov 2026 11:41:24 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::62b"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795048884;
	cv=none; b=Y7uP7+BFFxZbJgfP6yv2FuYWhcwc6SAlqiVEQrp9iz+jK35qSymnIQt9JMGhMe+dgeecvqCR9umv3kIZYa2oTMl1AiB4EPWJ4fJOc/0YBB5T0Sgb9S4kcHanCMNC/oZLSnzqmK6uN2ffFO5jkGzDi6J31DqtGGiNIo5mPU1FHxyhcMbwrqteNUqNr5QztquzfHEN2OSAbYexRcDxnJm3L7lDzqtKdqUjjcdVpgPV/XexAtwgwpmC5YSpnVjzwFjtVYbCrYmzCzHnryoV8PY3nrET2WkYYiPHxLlxb1ngWGi0fI1xXykhzIUVYC3uEfgBwQwXEj1oxVYv5h3lbdWw8g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795048884; c=relaxed/relaxed;
	bh=MaMya0PgU0vYhcvlm3qJ4CN2gnYc3xdOLMgYWmnwI4c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JGSdIxrhw3Zs1ZKvhF68qMRtT3s6OITquNB+L1gq9dui0N+3cOsCWVU18iDUYv5apPJTpjz2zZroOodWsI9eNngPUu3jafp031gA3v5opJvfeAhTJBe/d4oavfHjxaaF2R46ygR2N9itJklDulQz0yESIBYVlO8qaXgUToOoQBLoXL7hqsmiIyA8KOF/yR1YlxwrIU2hJ5TzpdAV53WuBQu0guuViulVMZYhlgmEn/DT2b43aFR2z+Y1YEf3MDlR+34rfRbArnIbpuXspwbBrn5jJ9/x6B0+AVornwGHUbhnLKfYmEleT2HEZjM9Da5Zf7OCszIgEXNETynjZc18hg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=KfXFkcKq; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::62b; helo=mail-ej1-x62b.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=KfXFkcKq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::62b; helo=mail-ej1-x62b.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jVKQp6CZlz2xjQ
	for <linux-erofs@lists.ozlabs.org>; Thu, 19 Nov 2026 11:41:22 +1100 (AEDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-c50d3ac6b51so80382866b.1
        for <linux-erofs@lists.ozlabs.org>; Wed, 18 Nov 2026 16:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1795048878; x=1795653678; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MaMya0PgU0vYhcvlm3qJ4CN2gnYc3xdOLMgYWmnwI4c=;
        b=KfXFkcKqjAEIy0+UitYLQUzz7EpKy00XlYrXgkGxj4pvExkIeSIs63zdfrt3MFcFXa
         V+YS/5dMFgHn/R21M3lNnZKZoWAvqjcpPtKIpO27jxzI1rXhaaDpDV5q6wMoo53uOW78
         se8fxifL9ZmUGN1TffnYrJQCJzKk2fze8opPyLwzj/2WGxizGD+6pMZQXzhvMTB66Eej
         NaDgjrdSQ4ZnlriqMHNlI3WHBnsyY43LaPRuKxt4Vaoj7aiDbJN41W2Hed0eEvCGx8qs
         6y2ptx7anhX+8OJhNOiLmd16qmR2ShMEgV0orzRabBXtcwzEeCSQFvSxnZGlf09eFj/q
         vduw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795048878; x=1795653678;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MaMya0PgU0vYhcvlm3qJ4CN2gnYc3xdOLMgYWmnwI4c=;
        b=fRzgAZ8KwVOhpo+urgcP/PN4LVsvlJJXm/2zmcT291Nspdu7xf7+44vKTjUw+59/dZ
         /TnwaV2NHnnKj9OC3lJMppj/slm+yu58JlAsCXttvdq+7V7zbDVIyY33QqVErYc3ecuF
         zg/0Ym2rmi5chjCfSN5DUKmlYF5fVfWGfrhfVwapJJSuwQoxsrrYoWpvAI5+k7tDbg6l
         jgY5kRuc+sEQNBqrCx90F60CujhXTPKYHHea17Gnkb1IFd3AC6rl7AvV14jD88jwV6ms
         860pQ+iy/1JL1JhsOq9pptt7SVHXTmz5M3XjKsMA/afzvfi6ZlAhvlXQ4KDzMra9CYCb
         23kg==
X-Gm-Message-State: APuU4Z9UUhUst5fSs6dBnovCEE7FZmNaY3YqpmwYY3rPJAXnLRhJYnaC
	apAkQI+F58SdPoOXoB3rpSGMKWdKOj2vtWDLBoGCnFZGcNaK2pLY1bc76jWu15eZ9r2v2W7Y8cu
	1hPG3wUo=
X-Gm-Gg: AYBFou3u8FGOS/YnFnBbt9y9osu34Gfzsvewl/Fn6Frpt67JkNmxhJGyMEncaI3te7S
	s3AxsSXF4jFeCjfdQMcCX7isiRUFB1TXwe48UlWnaeMvh8XBJLw9bhxL/ZMr+q3BeKjmijxu0Tu
	bJfMx+UiYwZcmATqnFGSGnzNnAyZKvC+R0Li/ewnIkWSsFJSh5ZIXMx3C7wJXjjt2Yg7SEs5XD+
	8h5gza54YfB9tZbj6/x8E+1GUFYzYcONQXkxkruerFeQ8i8jjK0b/go9wTEJzT9UhQIrbwnrXSA
	L0ScA6lfIvesYaVVydJlAPabz53h8Jptluuzg3A8uTQZ91oOfO5yKMHSEbngQ33qwCTB4bdUZW4
	PUAWg1/cgR9w5wfyQV86B1uEuX1QLwgXcTWCo96HBaF3nHUyF0ImU6fNv4LP3mNvHeHleM5xmCg
	AjmjoPX9d2cRnEhiKNh8ldKUHE97AI6r9F3ogzP5YN/wEqBvT9EFSRc0RdWc2bjXtqn+dOWk72l
	CxsbVoi6MBmj4TgINGHemRBFKhFU2Hnbc8QTBZZcBic/9eRZO5ZFHvXumlIZdWOR3bWwnVsEGlU
	dEhWoFEJI2Ab8JIfUIsPuOWknB4giKwhZ7NswCE+Mx2BK2ULN54lF41NgSueNZOxDEeoKj/O
X-Received: by 2002:a17:906:4191:10b0:c51:1e4f:2f6c with SMTP id a640c23a62f3a-c512b438874mr16267066b.3.1795048877674;
        Wed, 18 Nov 2026 16:41:17 -0800 (PST)
Received: from F7R9GP321C.tail0bfbd.ts.net ([2a02:8108:8388:6600:f542:cdf:8725:3e84])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c51231bc221sm57744866b.9.2026.11.18.16.41.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Nov 2026 16:41:17 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH] erofs-utils: lib: fix buffer overrun after short positional reads
Date: Thu, 19 Nov 2026 01:41:14 +0100
Message-ID: <20261119004114.40409-1-xiang.gao@docker.com>
X-Mailer: git-send-email 2.54.0
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
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

After a positive short read, erofs_io_pread() advances the buffer and
file offset but retries with the original length.  This can write past
the end of the caller's buffer and return more bytes than requested.

Limit each read to the remaining number of bytes.

Assisted-by: ChatGPT:gpt-6.1-sol
Fixes: 97f48b3c37f5 ("erofs-utils: fix erofs_io_p{read,write} and erofs_dev_close")
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 lib/io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/io.c b/lib/io.c
index 35da5bd..ef7ad04 100644
--- a/lib/io.c
+++ b/lib/io.c
@@ -230,7 +230,7 @@ ssize_t erofs_io_pread(struct erofs_vfile *vf, void *buf, size_t len, u64 pos)
 
 	pos += vf->offset;
 	do {
-		ret = erofs_os_pread(vf->fd, buf, len, (off_t)pos);
+		ret = erofs_os_pread(vf->fd, buf, len - read, (off_t)pos);
 		if (ret <= 0) {
 			if (!ret)
 				break;
-- 
2.54.0 (Apple Git-157)


