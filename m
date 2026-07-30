Return-Path: <linux-erofs+bounces-4038-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75595C531D0
	for <linux-erofs@archiver.kernel.org>; Thu, 30 Jul 2026 07:10:09 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h9gM3626kz2xwH;
	Thu, 30 Jul 2026 17:10:07 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785395407;
	cv=none; b=oiA9ucnIu3ZZGb6mf5SITgRO7HdaQp/o129wSq3PliHmT5ZVUEPheNlXkIS353jWZuMl5DtvspHbVlN15REYFmJ8XgvJHO6NLfFxcM0kqUcpYNUPO5AguPHYOQP2NqdJ9tNWvdZtbbtzf+vVCAlpuqzrlbAq5ixqDozFU3oIJZBYp/Kngy2OejUM/t1ylhNp/VNLPDejRQh+0ROXff30UfQQkIyDtX5BkLif6qkLN6XlgokRMAIORhg4XgSV5vi6pmrOV0Z9JTYjcRCGbI7iRH/dodoeyAWnBRIA4hVUpX8RheYnu3G6QMMesdWTO62QJnOE6Ygk/6V6lz7ONRs+bw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785395407; c=relaxed/relaxed;
	bh=Wwzdh+lefzQ3Mewr3ag7PKLqaiugNuHuZ6D8zRZNNZY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=F5lFBgYVmSpYKlch15R9Kz1SqhwKR/gN2QYQBuO6KpqKvH4+g86v8wc84JindoiLB+5guLf09GRWGytTOGP8WGtKqDsOB3sxIlqceh0XUsbbuGoMaWKx19vvCws6RH6A2cLaGABZpffAXu9T9E+X/KxXThACYs5RfcoOYoDL1AhPaKmn6TQeGG9B2OFuT/7FlMB4K/E5c/yhPJl8b3a/UVoVKsC72UfIoVTIfJbYwnRJ4i8atrUJcq9Nk+6rKhGaJjssB8jyIFarA8by8YtXfVi9iQVh4wDNd46l8zUggoZcdl3CWjW30Kejy9chPU99XdHNdlVtZ+RETiF3Sskc3A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; dkim=pass (2048-bit key; unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=i0qRx6nS; dkim-atps=neutral; spf=pass (client-ip=148.163.135.74; helo=mx0a-00364e01.pphosted.com; envelope-from=tz2294@columbia.edu; receiver=lists.ozlabs.org) smtp.mailfrom=columbia.edu
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=i0qRx6nS;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=columbia.edu (client-ip=148.163.135.74; helo=mx0a-00364e01.pphosted.com; envelope-from=tz2294@columbia.edu; receiver=lists.ozlabs.org)
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h9gM25s6Qz2xF8
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 17:10:05 +1000 (AEST)
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U6rXx42260482
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 02:59:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Wwzd
	h+lefzQ3Mewr3ag7PKLqaiugNuHuZ6D8zRZNNZY=; b=i0qRx6nSvdRp35M11yLi
	zCDL5833R4xWz9ehYcDjCN+iJy81EVfUbRN08bHwKN4Sv0jCdbucXr7pPAXPrQxg
	1n32YTlFzi84Wr18ittxMIrJzVdRnkygO8LEM7xlODihfBD+KKpFhVBicsOyZBR4
	JD+7PIf6HomtCv8bssHFR2jU/sxf0CVVHqPgBDVeubE9hqpuQG2Q/5k475unjLYu
	leSSOvM4xxdsLdk3pxUwcrvIJrrT21ENuMSN5TaP/FL7OVtRqYOQU+/M1DKF509J
	66cfLiS/MOEbOYUmN638Fpjn7j7NmlsYIk9r74XBJWePIIUuy2ZYsp95KPo8t/ry
	nw==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fqrjq25cs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 02:59:12 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-92e55721a8cso206359885a.1
        for <linux-erofs@lists.ozlabs.org>; Wed, 29 Jul 2026 23:59:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785394745; x=1785999545;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wwzdh+lefzQ3Mewr3ag7PKLqaiugNuHuZ6D8zRZNNZY=;
        b=kt49kB8aRm6YT0yD6mOy4+F5F+4mBtYCH6Z7+FFcmcA3rA7O3y/wyTEA3mk4YGWOhZ
         a3oxyBBD6Sx0czbT7LbxfeSNaUviYG1FSkvhQcI/44wElOlsgZrRET2N1aJKxIRMhUmw
         f2prCOX0S82ibTJurUP0s0aVlmtvRcY5faQP9fETTDEsVk/+qvDrrf8w4yDi4TaK52p9
         9A0Mp2RBRIZFCCzep/IKPY+HKuzUSRqlGCb+yVc/xmbq01QeWtjHQrWGGi3Juoe1H50d
         TqjdjngB2EeVuKf9WbCg3epAXpBwld4ejFxvxZZ8ALVIXF6PU52zVWMJfDLtzLsYl2mE
         P/iA==
X-Forwarded-Encrypted: i=1; AHgh+Ro9E9RhSSVDbWDiYXESy5ZrW6ds5j/8KYhoz+nQoDNOkxU4bTCpCWcYbS7IQOwdEnSzSapdeev4x++cxQ==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YzM3FG5LmIM8UN3uUxcQ5dQkCnbASCJG3vPk41nv9r5fzOszG2y
	VHQMBUROL9h2IEhYziDVeSPxIZJsH9FGCJqLVi7vhYrhHPObzGw2zmAgoo+Ae09o+ZVYrgHWG4n
	IxTLq0DqcnZUpyPoUvggI755sr4Mubm71gmgirlNNJFK2cgSwwzgOcGr6ItsMmw==
X-Gm-Gg: AR+sD10fjMB87DcBDQt2zELhZpeVKLswCIOWLacUh/y5kclL/jNUpsZzeP02ewiZVs3
	gxthwZza8iHCbpCZaIBa2MopLeWS5irqDoK9cIwxVmojgyI7cBx+pssJUSbEhKPdX5yL94vlrpB
	Qww88Of3YoNGK+V5x2WDMcmV65euWmReOcZxVYsBumaPTPk4U1HROOQs3NB8gFjk/3cDWz6Ca4p
	qhA8AVOlQNDDgJ9izYACB8JQFq6L5E6BOGrzRrPfWEZDm3Ez9f6I3GDbmLpPdCkcUjdhPjMChLf
	aPcKahMah/EULspQoqP7+ZKnaH50NwNImiQEKnB1SgfaF+TD6eVIcJ7vOy0foM3A68yJ+2L9wgV
	o8+ghRMF83t+CupQ+cignN9p3LF+GCSPjsC0sMiUcRsdcLg==
X-Received: by 2002:a05:620a:2886:b0:8cf:c106:faca with SMTP id af79cd13be357-93485fe35d1mr140937985a.36.1785394745167;
        Wed, 29 Jul 2026 23:59:05 -0700 (PDT)
X-Received: by 2002:a05:620a:2886:b0:8cf:c106:faca with SMTP id af79cd13be357-93485fe35d1mr140935685a.36.1785394744677;
        Wed, 29 Jul 2026 23:59:04 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d3221bc7sm349752485a.7.2026.07.29.23.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 23:59:03 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 30 Jul 2026 02:57:55 -0400
Subject: [PATCH v7 5/5] block: enable RWF_DONTCACHE for block devices
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-blk-dontcache-v7-5-3e8e6850068d@columbia.edu>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
In-Reply-To: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>,
        Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale <dhavale@google.com>,
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        Hillf Danton <hdanton@sina.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-erofs@lists.ozlabs.org,
        Christoph Hellwig <hch@lst.de>, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785394735; l=1234;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Tk8jUyrOqQ7WXa1eqV1nq7SPxnPRM7zEp3j/WZJSWC8=;
 b=os6OKouVgqku2jRKGVaPk1noDMT3+eXOUJzWQsRazIMJ1bPae/JGJpIYkqGCxir04AYNo7/bT
 w+Brhzebg6AAvdsxWkzbY3bN7osSNAQdnJPqVkijmqj/2VMhvYhfElf
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: T01X8YYQrxpP0u3qqYv60hInhAf_s1bG
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfX3F3eSINOd9jj
 P2jHIs11k3Aeaa6R9CjJvzV7c4v4/qO7gbAzQB6GWTE+ybpJ3OuGVqtg7ChR2a1Oeg8y6NIyOEt
 W/l261hiBaC7j9vk/NpdqT93YxHDe8nZet+WewrZGDjwQHbHIQ+z
X-Authority-Analysis: v=2.4 cv=S4PpBosP c=1 sm=1 tr=0 ts=6a6af640 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=J9_MS8zF8NN3zyd_QTgA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-GUID: T01X8YYQrxpP0u3qqYv60hInhAf_s1bG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfXxOdKgoa4jaQP
 gSIKdj3XIy+qU02nt6tB3freWjotArpk3k8sUpHFtWrMlrZUyamY63nyVWT6bPbDzGLZ4pG8Cwm
 strFKHuo70GtQKz3/7XiROn2kxIkD+2Av12VHsuA8ZQuVR2keS7ibqN8OGDVQJh9QrD7Jmzgl79
 3JWtYSUsovxQ0jEto6/VUnss2Wy9YPNgwd86xQ54DD/5UMKuE1EvoLgy/IqV2ykgfKNpWMIXjaw
 HjoYhTrk+NbJl+QmSorOzmI5KntKCrO8+9CKSNU1Qh1/CQVkl5kQoyvP4E81FvQlZ8G6tyPjTQM
 BaZGWubbTExvJjdBxJH6DjTXCyq0uqjBqwMHyCdwdWf1SVpDNdWHqei0lguf/zJ8zZU9a/iItGY
 8cWs7HpDkYJnFLqjhf0OHi62rv0rdGeZm9JWwOJk8KwkJmyjrP93DC6fGnyKy8wuoM/atuhpIQQ
 1lgI2LCxaQILlq95EGQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11859
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 phishscore=0 lowpriorityscore=10 impostorscore=10
 clxscore=1015 priorityscore=1501 spamscore=0 suspectscore=0 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300048

Block device buffered reads and writes already pass through
filemap_read() and iomap_file_buffered_write() respectively, both of
which handle IOCB_DONTCACHE. Enable RWF_DONTCACHE for block device files
by setting FOP_DONTCACHE in def_blk_fops.

For CONFIG_BUFFER_HEAD=y, writeback goes through buffer_head's
__bh_submit() which sets BIO_COMPLETE_IN_TASK on dropbehind folios. For
CONFIG_BUFFER_HEAD=n, writeback goes through iomap which handles it via
BIO_COMPLETE_IN_TASK on the ioend bio.

This support is useful for databases that operate on raw block devices,
among other userspace applications.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/fops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index 15783a6180de..8b39c53b6393 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -941,7 +941,7 @@ const struct file_operations def_blk_fops = {
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= blkdev_fallocate,
 	.uring_cmd	= blkdev_uring_cmd,
-	.fop_flags	= FOP_BUFFER_RASYNC,
+	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
 };
 
 static __init int blkdev_init(void)

-- 
2.39.5


