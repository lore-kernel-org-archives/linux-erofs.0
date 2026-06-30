Return-Path: <linux-erofs+bounces-3788-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BABEC43458
	for <linux-erofs@archiver.kernel.org>; Tue, 30 Jun 2026 02:52:51 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gq73s1xqJz2yZ6;
	Tue, 30 Jun 2026 12:52:41 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782787961;
	cv=none; b=W4ppKOOEl6EP3jcKd38/5m+lQKBNOsnhjBVuKVkcZ8tehHt9HyIS7wmVv4pV0Thg08a+okKBqzRFujaCnoUKAmec7mmdq+6ZzByLyBw8ud5ax2WLZt+HafS0loU/iIyUnXhp04V3BfBWJIiBWWULzyD4RJMH54fe8/x3gz0yw9qx+R5BmFa/Qkxor9WuYED9GxUaL94vlKcbzGcefJ7vvbSzNBAtml6YxoWz8+WNTkLQ1KqXzv1m7LmM8uQj1BXIriZ6GFfECXAOCLZSVNvUbaV9F3UKjnyB5+WeRFBpw0v/A8pJjrL25W8JP2QA5zgluZlfiaTvlPchE+Y6gLC0xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782787961; c=relaxed/relaxed;
	bh=r2O/xV3m7KV4Mj0iYQPGTYCu4AC0PsfFbR/vkvbQwGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDakNmkNWembasKuYvfvSf5mpYAI34kLSukco9fGGy3VHKfjmEa/k2eXEyOoZ2IaLbxwUTXAT/wM1rP1T9B2Q7onxEiqApnHXGLsoN1eBHp/GcAlYTKxORYc0uE+ijJQmU0EnsQ913TJ6FWv/mSD0c37sQgmDl/8JBRKtuulk7PGIB5vMGg9JLhR0CA5oa6/pjQLgeE6xbWN4tItnl5wRZXQR7PY0dgu8WfXQVnSxtgXxLVivp64VeSbUZ1N/Odl91AytfAVP4gqfhdRDlAk2aqsh78c6u5EzP9jupukEXM2odbdTEwDHz1ljGyyRLmMAuck2BLg1Tju2OvxpochjQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=uOMKZKmc; dkim-atps=neutral; spf=pass (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=uOMKZKmc;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gq73r2gvYz2ybR
	for <linux-erofs@lists.ozlabs.org>; Tue, 30 Jun 2026 12:52:39 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782787956; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=r2O/xV3m7KV4Mj0iYQPGTYCu4AC0PsfFbR/vkvbQwGk=;
	b=uOMKZKmcNsD10vy5Ggt1m3hkxTvUSacTlMAQUw0dbASGB41oFFRszJ1zkmyRHnXsjB0sxrs/dBsdL7LN12Rj23+yp/7DMbYnwvY+b/RVfIDcU9LMS73U23TtzLuLTZIDrM3lLts0d09ffmDB5J7wFYryvhp5hnuhKHLIIBXnAbU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0X5zS2qP_1782787953;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5zS2qP_1782787953 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 30 Jun 2026 10:52:34 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6/7] erofs-utils: mount: fix `RESOURCE_LEAK`
Date: Tue, 30 Jun 2026 10:52:23 +0800
Message-ID: <20260630025224.3955763-6-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260630025224.3955763-1-hsiangkao@linux.alibaba.com>
References: <20260630025224.3955763-1-hsiangkao@linux.alibaba.com>
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

Coverity-id: 647246
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 mount/main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mount/main.c b/mount/main.c
index ffe718a0a90f..ec27dcb53eb3 100644
--- a/mount/main.c
+++ b/mount/main.c
@@ -1698,8 +1698,11 @@ static int erofsmount_loopmount(const char *source, const char *mountpoint,
 		return -errno;
 
 	num = ioctl(fd, LOOP_CTL_GET_FREE);
-	if (num < 0)
-		return -errno;
+	if (num < 0) {
+		dfd = -errno;
+		close(fd);
+		return dfd;
+	}
 	close(fd);
 
 	snprintf(device, sizeof(device), "/dev/loop%d", num);
-- 
2.43.5


