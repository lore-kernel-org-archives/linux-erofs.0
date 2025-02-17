Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 389C9C021A4
	for <linux-erofs@archiver.kernel.org>; Mon, 17 Feb 2025 02:49:45 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Yx6ZH2Jzdz3bmS
	for <linux-erofs@archiver.kernel.org>; Mon, 17 Feb 2025 13:49:43 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1739760581;
	cv=none; b=bYOLW2v9mrOVaY+htZO9pNT1gbAeWwQ1qC3INptWFBe4uia4PIoEYPKpQXquz5ITCY8Y4CXR4xFO8qWXBndCagDLPtTouzzOjYqhMCP8Dl73uxm7Qnx9DL/vJcCMlpv9g5FjeXEMXiTUAiWA7Q+e4pdN8UBqojs/67D/HjsC9ptRsVU7tUuPg8DEfK4OHbS6UHS6/2WfwceOhikzTea6SrmCs9LIwN2C3CWowq45w4Edke8jQVcT3nLX43czQ1EwKAkfft7T9qgPFcmGt6ht5ngDnCi8wJo5OUq7O9KNp02BeaNcfWbgSaWsVrEhCLRLeA1xe9dXvN2yLXb1BHROHw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1739760581; c=relaxed/relaxed;
	bh=yK1p+MPtXk6NdJPjvE5qSOu8qV+oDQkPdAup7COA7FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqlnl4Q6SzSAHXwRMi4AlOlWboPe/4LSu91kRfTsDxkbSbuaLaXjm50kENDYQIz2BdIaUtI4sWxNqpG3VmFe3hoeUCbNxalmX0b3nD83AY/UR6zhCrUhBdEK7wxBMbuBT08CEKbnys0lBWCYzy449ADA0X4Hk60Fb8f9Uv5JvswgdWQ7bYmHE74C7hhtlorXY0Uokt0boMaiAVWN9cHDgNMziCFNAFv1ChS6yNd8T49r15hiNugB/k+GWk8zwGPU6XzUW4pD/Y0bTzi6ot62XJNf6mON412ODbr/PV7iE/zpeCSB/3AqLhQLlls+UD5mQ7ujg3dgbxcZU8Qpv+tdeQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Eq9inJZv; dkim-atps=neutral; spf=pass (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Eq9inJZv;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Yx6ZF07DGz2yyC
	for <linux-erofs@lists.ozlabs.org>; Mon, 17 Feb 2025 13:49:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1739760576; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=yK1p+MPtXk6NdJPjvE5qSOu8qV+oDQkPdAup7COA7FA=;
	b=Eq9inJZvnbzorIxVWGvvB+4QbRwd5KAsEnj+e1uwZO82qI9v4khfMCjU4DsHjwTdhs4Uv2XdiW8qM8iMNn1Ki30OWsGcr7NtLmyR8TkQOFoe6BgySYZfQbW+XtAi10hJQxj3gx1VCz/gLR6nysUZb57VkNFFKkPDeO4OgyxAYt0=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WPYAOPi_1739760574 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 17 Feb 2025 10:49:35 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH 2/2] erofs-utils: lib: fix an API usage error
Date: Mon, 17 Feb 2025 10:49:29 +0800
Message-ID: <20250217024929.66658-2-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250217024929.66658-1-hsiangkao@linux.alibaba.com>
References: <20250217024929.66658-1-hsiangkao@linux.alibaba.com>
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

  CID 541574:  API usage errors  (PRINTF_ARGS)
  Argument "rc" to format specifier "%d" was expected to have type "int" but has type "long".

Coverity-id: 541574
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/fragments.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/fragments.c b/lib/fragments.c
index e22b773..2f5fbf9 100644
--- a/lib/fragments.c
+++ b/lib/fragments.c
@@ -271,7 +271,7 @@ out:
 	if (rc)
 		erofs_err("Failed to record %llu-byte fragment data @ %llu for nid %llu: %d",
 			  inode->fragment_size | 0ULL,
-			  inode->fragmentoff | 0ULL, inode->nid | 0ULL, rc);
+			  inode->fragmentoff | 0ULL, inode->nid | 0ULL, (int)rc);
 	if (memblock)
 		munmap(memblock, inode->i_size);
 	return rc;
-- 
2.43.5

