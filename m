Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9628EC25B5E
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Jul 2023 09:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1690192463;
	bh=CMESg6KcZ1f/x8j8WNeV/0Ezds9kYbd4Innm/bU0Ooo=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=RujVt/6iI8x07mbJSdNZ6ClinsasMhzH8h4tmBv5lEqLDmVQi13E8JDkzJxSCD9oz
	 Bcr4yrflKmwbZWNbzNBOGGofjhbfp58sT5/p7mnvNcakeQ3BhCs/mlf5qRJgPbCNh3
	 ZtgUBwDFC2/PSyEHG4AA4O1tAu9zcUvJjLLJPkW5+Y1F2FdTM+O8+Ke3pDkD2Fi4J4
	 Mq3y13E2Z4Ju6LXTFtEmDGdPI6+s5lBA6uUUpJK7mKRd29aKC//nOmLMMDnnnFXxpF
	 tmcAdpUOLyPjeHlrZNGU6t09RvNuvhsMtPChNunu1O8Eis5NUJohRQIQkBxdH/PCdD
	 3/sBLc7uNRwIA==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4R8b9C1hLZz2yst
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Jul 2023 19:54:23 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=dwKlx1oQ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=bytedance.com (client-ip=2607:f8b0:4864:20::635; helo=mail-pl1-x635.google.com; envelope-from=zhengqi.arch@bytedance.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4R8b965PbGz2xLW
	for <linux-erofs@lists.ozlabs.org>; Mon, 24 Jul 2023 19:54:18 +1000 (AEST)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1b7dfb95761so5887785ad.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 24 Jul 2023 02:54:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690192457; x=1690797257;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CMESg6KcZ1f/x8j8WNeV/0Ezds9kYbd4Innm/bU0Ooo=;
        b=kbblePGhKYQKHCh9rl0yM5nalKShcRudRMNkByj9c+j2WhER8UuECqAw9ub26IGPe5
         rXK/vHaMHuQt2wN/8sxRTXHHpjIpk53Dzr0lr6GU/SLz5vFvSzkoXMA1HWKElEZj6MMM
         TCUWLItk0HLZ4LROcWW5nX5VDHrefwX39SsZMhhEBOqagDFZ2zWnhJ9hhrtRRJ/ACXHh
         MxFIwp50dZBV8BqxBTBI/2taq8Do3Lu2FddiK7ClOGXHHWXP5wAycMGU0nwOFM+tZQz1
         n2jRn85NtIb5ZNTU9XQy6b1cSYOxvm/cCdE/aNpCND8qQ5d7JNq5yn9+jwEbuXPdiQUo
         AMCA==
X-Gm-Message-State: ABy/qLZfGs3taIgV0F/fQTjhQT2XeXY0Ewpp3stJlfVd4wYnScenvRep
	xmFGMEBWjnAUJ9xs/nC/rL/XhA==
X-Google-Smtp-Source: APBJJlGXXWR+7sUNZwfELUHGku1GBmb2Z0Up/m3d12N15W4mEcGvzf3zzmR3Y2DB2osG2hV81y8tMw==
X-Received: by 2002:a17:902:dacf:b0:1b8:9215:9163 with SMTP id q15-20020a170902dacf00b001b892159163mr12209813plx.6.1690192456927;
        Mon, 24 Jul 2023 02:54:16 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902c18500b001bb20380bf2sm8467233pld.13.2023.07.24.02.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 02:54:16 -0700 (PDT)
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
Subject: [PATCH v2 46/47] mm: shrinker: hold write lock to reparent shrinker nr_deferred
Date: Mon, 24 Jul 2023 17:43:53 +0800
Message-Id: <20230724094354.90817-47-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
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
Cc: kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org, linux-mm@kvack.org, dm-devel@redhat.com, linux-mtd@lists.infradead.org, x86@kernel.org, cluster-devel@redhat.com, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, linux-arm-msm@vger.kernel.org, rcu@vger.kernel.org, linux-bcache@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>, linux-raid@vger.kernel.org, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

For now, reparent_shrinker_deferred() is the only holder of read lock of
shrinker_rwsem. And it already holds the global cgroup_mutex, so it will
not be called in parallel.

Therefore, in order to convert shrinker_rwsem to shrinker_mutex later,
here we change to hold the write lock of shrinker_rwsem to reparent.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/shrinker.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/shrinker.c b/mm/shrinker.c
index 744361afd520..90c045620fe3 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -303,7 +303,7 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 		parent = root_mem_cgroup;
 
 	/* Prevent from concurrent shrinker_info expand */
-	down_read(&shrinker_rwsem);
+	down_write(&shrinker_rwsem);
 	for_each_node(nid) {
 		child_info = shrinker_info_protected(memcg, nid);
 		parent_info = shrinker_info_protected(parent, nid);
@@ -316,7 +316,7 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 			}
 		}
 	}
-	up_read(&shrinker_rwsem);
+	up_write(&shrinker_rwsem);
 }
 #else
 static int shrinker_memcg_alloc(struct shrinker *shrinker)
-- 
2.30.2

