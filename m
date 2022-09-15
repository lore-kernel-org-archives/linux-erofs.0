Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4701C6FA8A
	for <linux-erofs@archiver.kernel.org>; Thu, 15 Sep 2022 09:42:38 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4MSsgd26w0z3c1G
	for <linux-erofs@archiver.kernel.org>; Thu, 15 Sep 2022 19:42:37 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Z0mbKLDU;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+aa90abf7a61f323a8d2f+6962+infradead.org+hch@bombadil.srs.infradead.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Z0mbKLDU;
	dkim-atps=neutral
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4MSsgK5f2Rz308B
	for <linux-erofs@lists.ozlabs.org>; Thu, 15 Sep 2022 19:42:19 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=f10ud+4Yk8zuOd0FwaSc+xsLEXHksvzyDOLFsDza1gY=; b=Z0mbKLDUJODd7WIJH7zNtS2L90
	vOmMj4hDPPXiSDw+aMBTpUxgy0asgtgfV+4+J+l4oS+R2K/YUyuJ8I/elEQRBtiYerT7+cF5+veE0
	As2MLe9Jh+crJYKoXZY8Yx6HDQSgstxsDLr8ptgQnaOoxvx+vyNis0c4HBZ1yJWMJml91LbKDJ6sT
	o8ABQhBEkp2KFWBYACzfFvirFth7WnnmAhhowLIfySIykeZwWp4JCLieTfsniUw4AZwmamm7MT3nC
	xxaJOz0cCYfhy3q/EURHz/sxkq0xwdjKLYezjVO8xCGkodJzvbpVbeUUBWYy02JEErH3z9SzjWEdA
	jKe0ukpg==;
Received: from [185.122.133.20] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1oYlNn-005b1k-MR; Thu, 15 Sep 2022 09:42:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/5] sched/psi: export psi_memstall_{enter,leave}
Date: Thu, 15 Sep 2022 10:41:57 +0100
Message-Id: <20220915094200.139713-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220915094200.139713-1-hch@lst.de>
References: <20220915094200.139713-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: linux-mm@kvack.org, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

To properly account for all refaults from file system logic, file systems
need to call psi_memstall_enter directly, so export it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
 kernel/sched/psi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index ecb4b4ff4ce0a..7f6030091aeee 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -917,6 +917,7 @@ void psi_memstall_enter(unsigned long *flags)
 
 	rq_unlock_irq(rq, &rf);
 }
+EXPORT_SYMBOL_GPL(psi_memstall_enter);
 
 /**
  * psi_memstall_leave - mark the end of an memory stall section
@@ -946,6 +947,7 @@ void psi_memstall_leave(unsigned long *flags)
 
 	rq_unlock_irq(rq, &rf);
 }
+EXPORT_SYMBOL_GPL(psi_memstall_leave);
 
 #ifdef CONFIG_CGROUPS
 int psi_cgroup_alloc(struct cgroup *cgroup)
-- 
2.30.2

