Return-Path: <linux-erofs+bounces-3929-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95C30C44512
	for <linux-erofs@archiver.kernel.org>; Fri, 17 Jul 2026 03:04:43 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h1ZWs6Kz3z2yfD;
	Fri, 17 Jul 2026 13:04:41 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.112
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784257481;
	cv=none; b=EM6LjJqRDSAtwYA8/H7ShhB0M4t3JyAnsTOMyDYPKSzu1lo4PFMDg/qkv5ayG0B9t+4twt4rBiYKS0231N/+BcHaEaQMzKhldvvt5PTnrfOfFMrGJSiSEIJuwv7iOpG22W+FsSRfnkUZ0TN8C6WvZfBhOTGNFROjoq7FkYu9iFACpGnbTvLttt05IsrAfqoohOEi475vWpfI8qZ5wZWfuK1Q14q5MmthkG57RpTVxFygMyQHCCUjKYBEAPbE3GyNTWxYi+Gi3zgjlMLheHAoVPs2mkVoQsU39VfLUUiMCrOWHL8QN9uxMCFQII1FQ5vkuBE3kf2nRUyO4HT6RZuv5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784257481; c=relaxed/relaxed;
	bh=jkHH8kNujNRlneLyW02lQtDVKGegkxnYQhY2EmD23/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bhd62X6DcnrL96mF7k/pmPwGEz28QOfY8nuaKp/kYwm2kHYd8FNvjwtd8HgzYawiFgs2HxD8HlW5giJb4kY0ZJiogDxlYifjNXq3Mr3LkKpfLI+Hw9oJlU4+/CDBA6On1ioRGAsE1J4ve9yiUKUFhSSSuAvlG1GzZe0dk4JjSXSlAMkup8CzyAV7TmOR8jV4581ZKjEpSbO4E+UcI7eAwjTr0i0XXcozyHgHKcRNO9MfedWEjnAWoaYZboL72mN0KJkMGrDPl0XDdvxxgQP7RhkJPmymfSxMkq+VQMc+QAaH06282qyLwWIg+Z9n/QtPOlLQQ97aDM1ACGt8GbHWyA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=cazylcg2; dkim-atps=neutral; spf=pass (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=cazylcg2;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h1ZWr0BcCz2ydn
	for <linux-erofs@lists.ozlabs.org>; Fri, 17 Jul 2026 13:04:38 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784257473; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=jkHH8kNujNRlneLyW02lQtDVKGegkxnYQhY2EmD23/0=;
	b=cazylcg2bKItMRdARM5iHCAEmPO0NS7CZ9IZMZGuOc9n1r9hpT6Fob73jo6NsAjaUka4hxhBryj9MRwZ72MXk08tXz7uM2zSoKo26I1hq92mPUlcSeKq9rD57vhgEay+47h6mCt3CmHckieGxq1CkG778N22vl4ggjkmqQl+f/k=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R561e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0X7FxETV_1784257468;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X7FxETV_1784257468 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 17 Jul 2026 11:04:32 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH] erofs-utils: tar: refuse negative size in tar header
Date: Fri, 17 Jul 2026 11:04:27 +0800
Message-ID: <20260717030427.1769514-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260716032401.4172874-1-hsiangkao@linux.alibaba.com>
References: <20260716032401.4172874-1-hsiangkao@linux.alibaba.com>
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

As @oscarjhk reported:

When tar-index mode is used, the inode chunk count will be calculated
as 0 if a crafted GNU base-256 size is UINT64_MAX, which will cause
a heap out-of-bounds write.

Fixes: 95d315fd7958 ("erofs-utils: introduce tarerofs")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/tar.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/tar.c b/lib/tar.c
index 242f27ae49fd..cf60b02daf2b 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -886,6 +886,13 @@ out_eot:
 			goto invalid_tar;
 	}
 
+	if ((s64)st.st_size < 0) {
+		erofs_err("invalid negative size=%lld @ %lld",
+			  (s64)st.st_size, tar_offset);
+		ret = -EFSCORRUPTED;
+		goto out;
+	}
+
 	if (th->typeflag <= '7' && !eh.path) {
 		eh.path = path;
 		j = 0;
-- 
2.43.5


