Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 355D4C0015E
	for <linux-erofs@archiver.kernel.org>; Thu, 27 Jul 2023 08:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1690445203;
	bh=CmSKD1W4o1llBpukOwDAPdWOg+LYzWoL67ya0UPwqvg=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=EBkWcT+E0AcTfmtLiceCx2ylmaNqLADCmz/KcGtI9DCNujzpD005tSGG4TJIUPU54
	 C+tIKZPVBSIqxf1eNIrYzm9tcC6QwrK4dMg29+f0eMsdYQZB6HoCoKtRWOcsCosseC
	 HXogrOKwu1+PHgYuiEbNlV/eBjcieO2Zfu2E77kS+GM3/nhkv3hlQGTChMILRBrYHy
	 8ct29dCsdSRTTcURZ6cYheX9hhanOb1eB4K+y2uWVgUgiZlxd6xDfyMh+rX1GZMTIp
	 d5DILs5bjN8Vti7ecupRJ96oD+/+iXgkmj7hFB3FFoungYdS0GWl3s/MEVS8TRn7Xz
	 ZyJmALLnQM9cA==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4RBNdb6Nclz3cVP
	for <linux-erofs@archiver.kernel.org>; Thu, 27 Jul 2023 18:06:43 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=bWsdCjXI;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=bytedance.com (client-ip=2607:f8b0:4864:20::430; helo=mail-pf1-x430.google.com; envelope-from=zhengqi.arch@bytedance.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4RBNcp6jDJz3dK0
	for <linux-erofs@lists.ozlabs.org>; Thu, 27 Jul 2023 18:06:02 +1000 (AEST)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-686f6231bdeso112244b3a.1
        for <linux-erofs@lists.ozlabs.org>; Thu, 27 Jul 2023 01:06:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690445160; x=1691049960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CmSKD1W4o1llBpukOwDAPdWOg+LYzWoL67ya0UPwqvg=;
        b=JsVqEnrJ2kV3ysZmIkdcM4qFa6LTfflYFwgndaKuJsqzH1r6YVIaNuLqqE7WVcfxF8
         yh1NQDtDFpzbtGyyAweDDx6MhMQMrXhCL7EDnqjvoO9BWSQZZY8e2VfK6a/z+r5MbiRh
         YKhx3mWHLY88oOvR+IGQiGW/kcuOHZPGkZsTByzSMuT12Vo2BOs3Oikp48LsDaqKZBhy
         51jYgHgO8ZCgzGUyH0o8jx8iSjc13Yr8EPMeOtZNY28pnUsVd2ISp76/9hKUONE3KOse
         3GUHpzLkX2mbE07JGKtISl5gdR7bAAiU2ftMauNm6/MYCRssmRe4pmhkpIYi4XPa7arh
         eI2A==
X-Gm-Message-State: ABy/qLbSoh7RL/M7btYS+PMM1HltGu4ICCo8PdWB6WoekPRwfA9TV79E
	lqL4Z7XpPI4/67jZTlEh4p9tUg==
X-Google-Smtp-Source: APBJJlGsBl3klUilUFzaktHEHOMbkNlcOB/1K8g6HjcIbYlgfdxi92AgDTolw1HjCRkDLU6/tzA6hQ==
X-Received: by 2002:a05:6a21:78a8:b0:137:3eba:b81f with SMTP id bf40-20020a056a2178a800b001373ebab81fmr6002609pzc.3.1690445159927;
        Thu, 27 Jul 2023 01:05:59 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id j8-20020aa78d08000000b006828e49c04csm885872pfe.75.2023.07.27.01.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 01:05:59 -0700 (PDT)
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
Subject: [PATCH v3 01/49] binder: fix memory leak in binder_init()
Date: Thu, 27 Jul 2023 16:04:14 +0800
Message-Id: <20230727080502.77895-2-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
References: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
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
Cc: kvm@vger.kernel.org, Carlos Llamas <cmllamas@google.com>, dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org, linux-mm@kvack.org, dm-devel@redhat.com, linux-mtd@lists.infradead.org, x86@kernel.org, cluster-devel@redhat.com, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, linux-arm-msm@vger.kernel.org, rcu@vger.kernel.org, linux-bcache@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>, linux-raid@vger.kernel.org, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

In binder_init(), the destruction of binder_alloc_shrinker_init() is not
performed in the wrong path, which will cause memory leaks. So this commit
introduces binder_alloc_shrinker_exit() and calls it in the wrong path to
fix that.

Fixes: f2517eb76f1f ("android: binder: Add global lru shrinker to binder")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Carlos Llamas <cmllamas@google.com>
---
 drivers/android/binder.c       | 1 +
 drivers/android/binder_alloc.c | 6 ++++++
 drivers/android/binder_alloc.h | 1 +
 3 files changed, 8 insertions(+)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 486c8271cab7..d720f93d8b19 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -6617,6 +6617,7 @@ static int __init binder_init(void)
 
 err_alloc_device_names_failed:
 	debugfs_remove_recursive(binder_debugfs_dir_entry_root);
+	binder_alloc_shrinker_exit();
 
 	return ret;
 }
diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 662a2a2e2e84..e3db8297095a 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -1087,6 +1087,12 @@ int binder_alloc_shrinker_init(void)
 	return ret;
 }
 
+void binder_alloc_shrinker_exit(void)
+{
+	unregister_shrinker(&binder_shrinker);
+	list_lru_destroy(&binder_alloc_lru);
+}
+
 /**
  * check_buffer() - verify that buffer/offset is safe to access
  * @alloc: binder_alloc for this proc
diff --git a/drivers/android/binder_alloc.h b/drivers/android/binder_alloc.h
index 138d1d5af9ce..dc1e2b01dd64 100644
--- a/drivers/android/binder_alloc.h
+++ b/drivers/android/binder_alloc.h
@@ -129,6 +129,7 @@ extern struct binder_buffer *binder_alloc_new_buf(struct binder_alloc *alloc,
 						  int pid);
 extern void binder_alloc_init(struct binder_alloc *alloc);
 extern int binder_alloc_shrinker_init(void);
+extern void binder_alloc_shrinker_exit(void);
 extern void binder_alloc_vma_close(struct binder_alloc *alloc);
 extern struct binder_buffer *
 binder_alloc_prepare_to_free(struct binder_alloc *alloc,
-- 
2.30.2

