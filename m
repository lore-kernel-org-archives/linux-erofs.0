Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 683CFC04A94
	for <linux-erofs@archiver.kernel.org>; Mon,  7 Aug 2023 11:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1691407206;
	bh=X5ij/O+E/bk/tTzX9mgxwiCynzBHcXx4EKtI9EsHayo=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=B3qvd7WwRW+pDRCA/UxqL7gRWgulYZIl4JNDhNkDZ5cafsGkgHPfwQA3TzTQEesfz
	 XCdDaTRp+RXZllNVmYsWyVnrVLWd8P43ycLXExQisQGXFlGqvEpvvDQuXNJw9SMTH0
	 IKBH+uiJWb2X+7oZHu5JgENkvAJZ8s9yA4zxMnYh+rwmjRjUiYLF4bEmvnNZjgc7iZ
	 6zpjEMKY6kcZNATeStFvx39PBhkXRnZUTX4bWIT9iZqqKHk5cSZd/Pgoj/sXny27GA
	 /zWVpWt2CF6qb5fS+ofzkDFUSA1ys7j7RmjxZ9jbjlVrXJD9pm4l0kFl0i3StKZMPo
	 CejZ7BtxOkBDg==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4RKDPf0CKkz2yV5
	for <linux-erofs@archiver.kernel.org>; Mon,  7 Aug 2023 21:20:06 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=i3OLYIqg;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=bytedance.com (client-ip=2607:f8b0:4864:20::1033; helo=mail-pj1-x1033.google.com; envelope-from=zhengqi.arch@bytedance.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4RKDPY5k3dz2yGB
	for <linux-erofs@lists.ozlabs.org>; Mon,  7 Aug 2023 21:20:01 +1000 (AEST)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-26890669c8eso933014a91.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 07 Aug 2023 04:20:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691407200; x=1692012000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X5ij/O+E/bk/tTzX9mgxwiCynzBHcXx4EKtI9EsHayo=;
        b=eaja4QBstuKDy0iESJX0OUlCLz8jY+1CLCIQ58YB5v0fzGAc0yZs9WFgmmAM8v0Xcg
         G5jkPkW1dJdNuFYMXOB9s/QD7h/d3H1jVAc0QW85EjJdeSO99OJo8vvqgX3sJEGe+eva
         B+6BVCc3gmp6KdlvuX9xxbkTGurq4QK19eZ5m3nETuB7aEKl8+DTA6Sg2gLpKiuIwA9L
         Z0rDe2LBaaqA81zwwoA+Db1+2v7SYdJOuJdDwP1UY8OyrjDX8w6cvAAlUgZ8LLzcaBCr
         WJDsp8jgH+nfoQUIVmCJ2j/C1KQNhtfaFLlbJfKIBE+Q/OyixW6N7vjgmO3yI77dE4DF
         owsQ==
X-Gm-Message-State: AOJu0Yz3dhLtFdtrp4DsfoFC/Rg+5RJ6yabqdSIsAzXGsQo2qLxsNo2U
	nCZu2U9ElcLDbDVNc4B0JUK4Aw==
X-Google-Smtp-Source: AGHT+IH1iUQIXRu8fJbzxUHSh+kWmc44BJdJFh0ZxZy41KSEiq7lusFAb/6JfkXEPdg45Q03TKbByg==
X-Received: by 2002:a17:90a:9c3:b0:269:41cf:7212 with SMTP id 61-20020a17090a09c300b0026941cf7212mr4973775pjo.4.1691407200010;
        Mon, 07 Aug 2023 04:20:00 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090aca8d00b0025be7b69d73sm5861191pjt.12.2023.08.07.04.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 04:19:59 -0700 (PDT)
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
	muchun.song@linux.dev,
	simon.horman@corigine.com,
	dlemoal@kernel.org
Subject: [PATCH v4 47/48] mm: shrinker: hold write lock to reparent shrinker nr_deferred
Date: Mon,  7 Aug 2023 19:09:35 +0800
Message-Id: <20230807110936.21819-48-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
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
index fee6f62904fb..a12dede5d21f 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -299,7 +299,7 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 		parent = root_mem_cgroup;
 
 	/* Prevent from concurrent shrinker_info expand */
-	down_read(&shrinker_rwsem);
+	down_write(&shrinker_rwsem);
 	for_each_node(nid) {
 		child_info = shrinker_info_protected(memcg, nid);
 		parent_info = shrinker_info_protected(parent, nid);
@@ -312,7 +312,7 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
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

