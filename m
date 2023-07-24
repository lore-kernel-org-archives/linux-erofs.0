Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4463C0015E
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Jul 2023 09:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1690192130;
	bh=SZ4CyloeMnj8DJaX3jH++Kh0s8L9fcE8HheaL79+C9E=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=a7chWuzkspe0HMTasmxl0scaSRHqBdRvTBOLN1EuyD+4VPpHzUDomAPI7OOmdCI+A
	 YT9G9cY6FU23ah8n2wMMWZ0aixChywJyLP5JNtDbs6uUHHSWyvPrfz3eF9UBEl2bzD
	 FuIRga7mSvATmson+mpCuWij17UNu89VxjzO8+rmW1EoJUEnCUo7riMi6l7ItSxFy1
	 SDMJzbtifPQOu2YJu3GSxlUDIvv6hifonVZcKLMdlBH7WThwWLbHfrWQc+dcod+YOK
	 Cuafu4S842/YKzhb2UVvz1mL5nQbh/z67NlDPgTzRn0nxCBu13lL48e6xN6+ddcOJz
	 l63q292igVB1Q==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4R8b2p2l7Gz2ytF
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Jul 2023 19:48:50 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=J/Bt6a5B;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=bytedance.com (client-ip=2607:f8b0:4864:20::62d; helo=mail-pl1-x62d.google.com; envelope-from=zhengqi.arch@bytedance.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4R8b2j2bY9z2yhS
	for <linux-erofs@lists.ozlabs.org>; Mon, 24 Jul 2023 19:48:45 +1000 (AEST)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1b7dfb95761so5877685ad.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 24 Jul 2023 02:48:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690192122; x=1690796922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SZ4CyloeMnj8DJaX3jH++Kh0s8L9fcE8HheaL79+C9E=;
        b=J65Mb30lGu4P54lhr2zu6ow9KMH09SZB1XbkNqIied9FvOVhLA8P5Rl9zTWV/rfL5G
         7maC0d3WdGk23qAGf5+94iGobmmF45iH2M/L9uo4VkA/pshhepsjDys4aH3W9FVA6nmo
         QrB/ZnxnUYlRDC72LorFFMHbISBP2Yx2NWxMyZkvKs1K2hw1DXHU3ILu08wlnlXu/DNf
         Ikqv2CVDENj08u1tmpPKXgEwON19acvn2pwoR7mFgqD4e9F96smYA0bv/VylrtFAQxB2
         BuP2rFMaZpfjQRS54DuMMC5aeRKOrGNEmX09jLUZF56aYdEMq6TWqn9JlBmQx+Wu5IwA
         XgIQ==
X-Gm-Message-State: ABy/qLZczrfllgOwhQnU/LFh7QG2Xwn0c9hG0YdeBg+2vy7Aj250dR2U
	NB3L5w6KOhaF5YniU5LYI+HwyA==
X-Google-Smtp-Source: APBJJlGdl4zR2tT8oeBRlnNa82kteJScCMEv7aXbUuimbAqUFJ617TPjzQL08XTMcGzg+wanNIE0AA==
X-Received: by 2002:a17:902:ecce:b0:1b8:b55d:4cff with SMTP id a14-20020a170902ecce00b001b8b55d4cffmr12423850plh.2.1690192122325;
        Mon, 24 Jul 2023 02:48:42 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902c18500b001bb20380bf2sm8467233pld.13.2023.07.24.02.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 02:48:41 -0700 (PDT)
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
Subject: [PATCH v2 18/47] rcu: dynamically allocate the rcu-kfree shrinker
Date: Mon, 24 Jul 2023 17:43:25 +0800
Message-Id: <20230724094354.90817-19-zhengqi.arch@bytedance.com>
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

Use new APIs to dynamically allocate the rcu-kfree shrinker.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 kernel/rcu/tree.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 1449cb69a0e0..d068ce3567fc 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3445,12 +3445,7 @@ kfree_rcu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 	return freed == 0 ? SHRINK_STOP : freed;
 }
 
-static struct shrinker kfree_rcu_shrinker = {
-	.count_objects = kfree_rcu_shrink_count,
-	.scan_objects = kfree_rcu_shrink_scan,
-	.batch = 0,
-	.seeks = DEFAULT_SEEKS,
-};
+static struct shrinker *kfree_rcu_shrinker;
 
 void __init kfree_rcu_scheduler_running(void)
 {
@@ -4958,8 +4953,18 @@ static void __init kfree_rcu_batch_init(void)
 		INIT_DELAYED_WORK(&krcp->page_cache_work, fill_page_cache_func);
 		krcp->initialized = true;
 	}
-	if (register_shrinker(&kfree_rcu_shrinker, "rcu-kfree"))
-		pr_err("Failed to register kfree_rcu() shrinker!\n");
+
+	kfree_rcu_shrinker = shrinker_alloc(0, "rcu-kfree");
+	if (!kfree_rcu_shrinker) {
+		pr_err("Failed to allocate kfree_rcu() shrinker!\n");
+		return;
+	}
+
+	kfree_rcu_shrinker->count_objects = kfree_rcu_shrink_count;
+	kfree_rcu_shrinker->scan_objects = kfree_rcu_shrink_scan;
+	kfree_rcu_shrinker->seeks = DEFAULT_SEEKS;
+
+	shrinker_register(kfree_rcu_shrinker);
 }
 
 void __init rcu_init(void)
-- 
2.30.2

