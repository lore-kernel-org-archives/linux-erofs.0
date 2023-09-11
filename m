Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB4ABEE7FF4
	for <linux-erofs@archiver.kernel.org>; Mon, 11 Sep 2023 09:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1694425577;
	bh=vEaLNFUhwmRxiNXJvWOPc9Z79QJgQluJlkgX3lFWQho=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=b55HRBTiRdAasvKII/UYhwmkx6+uvRJlSt/gxITc7lck+FoC+ANt6wnJMdCQiHR37
	 JogDSR+Xd6C5h5quZmYibGPcsFOylrNxxyFHFrMkN2GN+VvcKLcxAbdBAN2DArWoBA
	 5C7fr7UwKR/jXExDO+w07ENNsuljG3QL6sZW1N/rzz5U4WU6Ov/kzFtE3YKabwK01v
	 HdX9zyfCVKEo9irOyv7oK+h2TOU4Ez16U8HZPydy8yZbdOAf0e241uuRjZI0Cba/2C
	 zJj5zsLELG1DvlyqkKtUZkOo5kVgKJBd3e2iVu3gWCbnskAY+Ge/cS2A5LpEUXMwK3
	 G69W4Bjk4CRyg==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4RkhgF2Z7Tz3byP
	for <linux-erofs@archiver.kernel.org>; Mon, 11 Sep 2023 19:46:17 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=AxvrxyPs;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=bytedance.com (client-ip=2607:f8b0:4864:20::631; helo=mail-pl1-x631.google.com; envelope-from=zhengqi.arch@bytedance.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Rkhg51WKJz2yN3
	for <linux-erofs@lists.ozlabs.org>; Mon, 11 Sep 2023 19:46:07 +1000 (AEST)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1c39500767aso6231455ad.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 11 Sep 2023 02:46:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694425562; x=1695030362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vEaLNFUhwmRxiNXJvWOPc9Z79QJgQluJlkgX3lFWQho=;
        b=VwNayO5r2+bmiPIJ6/fhWN8vgeISQHelMGIcntS61irGMi0sR7dD1jCnYsCdmtmdA0
         3ZoU0cDm2dGzzQd8WsDEtASFRRip7aUMostSm919TXdWgN/px/nAFhF35tNMvDsADWlM
         9ZOyA4iXMwWkIHq3C0Q1xFprq2355y0hKLbx23nxxmaZgNMOKvE5FXmoDeP7slCfbgFk
         OXeGmwzw9wDVdbDYK0ZFQHntjqQY9pXgWnxAcwtPT5ag9dHbCS/tbeJ6jguD9IS8YNFD
         YasWHA4AQzX00u6cfwvWwoWZvy9NLvuvqrrwo011/54cT5o5UBcWESzRnlA7GTSeOWF/
         gmEw==
X-Gm-Message-State: AOJu0Ywiy2Y4COD/gGF/rqj9/mOwromlVSo5+5WvHEOfyvO/8j/MotCf
	lG9PjOLW0i10DCqqWSKXcTodqw==
X-Google-Smtp-Source: AGHT+IEEe7OKLpAjWZ6ZHMp4sopalHLkAI6pc9tZjZALl4cTsdDgpaoyKPO/MAR6mRgsc+S+sQMbZw==
X-Received: by 2002:a17:903:3386:b0:1c3:8dbe:aecb with SMTP id kb6-20020a170903338600b001c38dbeaecbmr8865820plb.2.1694425562720;
        Mon, 11 Sep 2023 02:46:02 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id az7-20020a170902a58700b001bdc2fdcf7esm5988188plb.129.2023.09.11.02.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 02:46:02 -0700 (PDT)
To: akpm@linux-foundation.org,
	david@fromorbit.com,
	tkhai@ya.ru,
	vbabka@suse.cz,
	roman.gushchin@linux.dev,
	djwong@kernel.org,
	brauner@kernel.org,
	paulmck@kernel.org,
	tytso@mit.edu,
	steven.price@arm.com,
	cel@kernel.org,
	senozhatsky@chromium.org,
	yujie.liu@intel.com,
	gregkh@linuxfoundation.org,
	muchun.song@linux.dev
Subject: [PATCH v6 06/45] erofs: dynamically allocate the erofs-shrinker
Date: Mon, 11 Sep 2023 17:44:05 +0800
Message-Id: <20230911094444.68966-7-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230911094444.68966-1-zhengqi.arch@bytedance.com>
References: <20230911094444.68966-1-zhengqi.arch@bytedance.com>
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
From: Qi Zheng via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>, linux-mm@kvack.org, Yue Hu <huyue2@coolpad.com>, Muchun Song <songmuchun@bytedance.com>, linux-fsdevel@vger.kernel.org, Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Use new APIs to dynamically allocate the erofs-shrinker.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
CC: Yue Hu <huyue2@coolpad.com>
CC: Jeffle Xu <jefflexu@linux.alibaba.com>
CC: linux-erofs@lists.ozlabs.org
---
 fs/erofs/utils.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/erofs/utils.c b/fs/erofs/utils.c
index cc6fb9e98899..e9c25cd7b601 100644
--- a/fs/erofs/utils.c
+++ b/fs/erofs/utils.c
@@ -270,19 +270,24 @@ static unsigned long erofs_shrink_scan(struct shrinker *shrink,
 	return freed;
 }
 
-static struct shrinker erofs_shrinker_info = {
-	.scan_objects = erofs_shrink_scan,
-	.count_objects = erofs_shrink_count,
-	.seeks = DEFAULT_SEEKS,
-};
+static struct shrinker *erofs_shrinker_info;
 
 int __init erofs_init_shrinker(void)
 {
-	return register_shrinker(&erofs_shrinker_info, "erofs-shrinker");
+	erofs_shrinker_info = shrinker_alloc(0, "erofs-shrinker");
+	if (!erofs_shrinker_info)
+		return -ENOMEM;
+
+	erofs_shrinker_info->count_objects = erofs_shrink_count;
+	erofs_shrinker_info->scan_objects = erofs_shrink_scan;
+
+	shrinker_register(erofs_shrinker_info);
+
+	return 0;
 }
 
 void erofs_exit_shrinker(void)
 {
-	unregister_shrinker(&erofs_shrinker_info);
+	shrinker_free(erofs_shrinker_info);
 }
 #endif	/* !CONFIG_EROFS_FS_ZIP */
-- 
2.30.2

