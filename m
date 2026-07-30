Return-Path: <linux-erofs+bounces-4037-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 757CEC531D0
	for <linux-erofs@archiver.kernel.org>; Thu, 30 Jul 2026 07:06:04 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h9gGL3wsVz2yDs;
	Thu, 30 Jul 2026 17:06:02 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785395162;
	cv=none; b=e6uGWGfx8YTws/I2L/GSgZn1CVG0Lmnxu2kXpaqaPfcOlbocmecx6BOz4SalxolxZEeYwKQLknYSHzZ4kC0/xfwHcoE0Q76p3qfKlYP6wiuySaGh4gc7IZZjJ+VoWn8y7+y7FDKNueCOmwmIQmsrmMuYFdM4afkhMttDJC0okY68N+1TJ3Sq9BpbGtzk+RPLProDCAVtLL1QXPTdWQnuQ7fT/Cj8ELtutffuEr/2kodGsxhJ2b93U9BJH2mHtMZ1twIALx7OJ3mIcEmuGUr5ln6n3ciWjy64ZP5vw4V2g1CfGhMUGF+GFCRjvqxYb40o2fzfRmCUK1BJSm6WXgPf5g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785395162; c=relaxed/relaxed;
	bh=Aj3+ozneKRFxvyRKEW1x+foEkavllzfM2NqbtLKj8IA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FQzZL2WenBRbFdusLEHpvnx6zZG+kguCmlpO1Z2cXhFH2osE9mbtE60iJ6XGfYnXnRETOyMbJREcw6rwqOzdANqZmHuZDPnp5OXtFLyRa/Tjp0ggVm3pJF0k4wpQX+WQle36+68RZTzj5RpDYKGHhXl0ruDolbvrOqg+Q/lLI+LAT2QISsExcwHcB5TK2vsN55iPK3SKkDMPlmlx2pKLhVDK3kx6ub7fcdxbHnRLRQG0WFYAXzNzk2Nof4z+qHkxS/mc6KcyWCjBLyR2lkMkcjr8qqEjpW8Uh+S5mghZXVxs1LNDtw69O+UvH6sQIjnaiXvKakx8piUK7c9LeOI/OQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; dkim=pass (2048-bit key; unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=hv0PcEo8; dkim-atps=neutral; spf=pass (client-ip=148.163.135.74; helo=mx0a-00364e01.pphosted.com; envelope-from=tz2294@columbia.edu; receiver=lists.ozlabs.org) smtp.mailfrom=columbia.edu
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=hv0PcEo8;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=columbia.edu (client-ip=148.163.135.74; helo=mx0a-00364e01.pphosted.com; envelope-from=tz2294@columbia.edu; receiver=lists.ozlabs.org)
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h9gGK2cdGz2xwH
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 17:06:00 +1000 (AEST)
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U6YmeC1888252
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 02:59:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Aj3+
	ozneKRFxvyRKEW1x+foEkavllzfM2NqbtLKj8IA=; b=hv0PcEo8AAPDJ3qmRsyH
	3+KWRKhUuio5bu6v7AnsbOIMwgD7rZbWuZCbxPJ8NOtDT/6jnTzUMipJ0mF7QfZu
	3vHsZW0WXTeqgG2leuJy+YHuFK/7Aze+PS0kNPRJ77w6BASuAor/BNbvhZ+06gWE
	lwCff028FYqKbvLsbLBzqyFKUem7txf57ogPxPRAOr5qdW2T8loIUHnw0K1cQz09
	7P9wendgVQQF2uUVmf24BxrK1lwd44WBWwC/SjBvLCM7Ae8WAwMxAh2mgghG2Jea
	q0yZqxPC9eTBItVbYtNcMTqXiTV+yoGFDSs/zzZjapWZTUnHFT7gf1vSP1LKyFZq
	dA==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fqud416pj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 02:59:10 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-92e4f946461so214620085a.2
        for <linux-erofs@lists.ozlabs.org>; Wed, 29 Jul 2026 23:59:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785394739; x=1785999539;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Aj3+ozneKRFxvyRKEW1x+foEkavllzfM2NqbtLKj8IA=;
        b=nOpjB1yl535ngLfg6CfzRK/sy9wJjJ89ShGk/o+J2IjjjKU8ZzK4DzQ4wFS0inQad4
         BLJAsA+RnbDlOzcpjK9HKxFObdYIEJkvdN5RVYpDc4SXgFzG+2djJVqX0vc/WmJWeP5A
         QFqPvf3n15D9DBp+KqgIghHSLAjV9q+aFyy9DfB/5xPZBBvbMDJUrye+Eb5bgCd67J0j
         ZK1FMhOC34MRdg9wBkw57YkfW9mj+9EcUFJo0EOVGJgXkhGhYY2zJX+qiYAUvgFCen0q
         Ysh6BPbTxb+BbGafuD56ZVvST3gkpyihzCoiO20qQoVx7A+ojZho0xl9IYlfvjH3cHu0
         20Aw==
X-Forwarded-Encrypted: i=1; AHgh+RpGsnFPJUbOXp7XtD9HaZwIgk3GpHztmk0CaN4WeT+mUq62M+cEHfznZToxmTUQpSfQO1HRDFhft80gEw==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Yzp5W0ckEXPFXoaCZ/DWzKqSNdyalLvyfF9Dkgx8HbZlmEMokzg
	MzMYSwbttEkunnVF1qmv8zrCOxSVAMQaDY4q6YnkAgZm7hG7elYau3NWJQzrZLYBZRWzPDqQ8ci
	2d33GE5Rli0VHniPMw6oFp5NnXZMy6AFAQQvkJZMk7WO6XcDL2qUJwGUr7j6SMQ==
X-Gm-Gg: AR+sD12rs4qC3+GG3R+OS1Op0lDwDYeI5BrhYne5p97K7s0zm5tY3tumcenMrgc6foj
	iXeWXXIGgWSusPSF4sp4bVx4NlvV1/wlqhF0iNyBEuMTmyYGyo69V2K5XriQxzDTg/RnZgxPzMc
	U0H4FFZh9k5dzAaAAj51Ot6dcwytlOPMNF9NE4LtqLGpJRizNf07k0/+S5l/zav3JGQO41em+6o
	167vzThHZ4vGkWV+JlVrk6eHPN32KIOzSLLU+Ipgjbuu0h7RhWBzEfIFssfA0PePEKHrYqK8PIA
	X7uWRCyXaJUQswxOkGkr4O+xtZ0mx6TW44sZIzpxhRJeewsY2ivvS5J2Fz7nRyEBJo+EYI9w3RQ
	0xXsa99WYmKYiGV5PziVmB00XH/p9UwrNzaB242f9/kwlMw==
X-Received: by 2002:a05:620a:3709:b0:930:f852:6daf with SMTP id af79cd13be357-93487207b6emr145582585a.87.1785394739075;
        Wed, 29 Jul 2026 23:58:59 -0700 (PDT)
X-Received: by 2002:a05:620a:3709:b0:930:f852:6daf with SMTP id af79cd13be357-93487207b6emr145579585a.87.1785394738610;
        Wed, 29 Jul 2026 23:58:58 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d3221bc7sm349752485a.7.2026.07.29.23.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 23:58:57 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 30 Jul 2026 02:57:51 -0400
Subject: [PATCH v7 1/5] block: introduce bio_in_atomic()
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
Message-Id: <20260730-blk-dontcache-v7-1-3e8e6850068d@columbia.edu>
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
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785394735; l=2716;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=hHCEZENfCfsEpOmC0wBfWJMFm3C20nG7DjOTxirSTUU=;
 b=0SI7Xl8K46e0uZlTQGRMH9PF2VforZ2ADnod5gEhiUnACnwVjnxh4x+kTnl1qD5D6oyl3rPbF
 pLBs0BjnLHtCNXNT9pp0MnVsyv5sMsoS/rOivi/TnyaG9EJUxZTJlIh
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: pjBvTOx-K0C89UcONbWOq_m4TI-h49ro
X-Proofpoint-ORIG-GUID: pjBvTOx-K0C89UcONbWOq_m4TI-h49ro
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfX1s42gl6sWBDV
 sTefFFkfUVeSs13Bc1m4kpHa4Ga3hTsFSIFCoSrrU2ofxIsSsH/hNCEzZpJJSeeZgYODHM7RQ4d
 n9aI+xgnfMkiuNU71wGdyb+el3I/few4EnmuDT/DXCnNRulwkZg+
X-Authority-Analysis: v=2.4 cv=b4KCJNGx c=1 sm=1 tr=0 ts=6a6af63e cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=JfrnYn6hAAAA:8 a=i_Ns0s3d_2HFdJHkmwAA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfXxjykDq3taCM/
 pTiInNTqq4q3CSIMU1OXvK0Qr1GIytJQwTSUIs3xFmRVMbd4IQXoS1t3jMbsegrgZAYCpxbDYnf
 PrfgzdPLPEe+s+6qmNR2lMqV7iWVi+Ivw9m0H8++kVY76/fGWANLLhDiTAy23FK4GF00kT0lQUq
 jTpRad2TRxpqJcP77U6T1lU+2tk+e3xy4dQ3/nMZf53NceoqDg0M3KwyiKT0NOd9A1GQF6hQpyx
 7d+0yCkeJndzYRdaiFgj+3gaH6SaJ5l3eReVNe8+1Zf3b3haJn1HnDl5ywQHbhE+b1r5ACCMY83
 1i8K8OEDAuPNSUTWG9YoQq7ctUPvPBiMl7XaM+DfMZq8HZkH5CTx06M49zFcWG8ENOiAEfE3W4P
 keTXmXOXDDSuhOruC4rwJA0QGNbKZKi5f7k72xqpuqbtM47pPARDMWAZjXmeL4Tgkr7Qtt4MajP
 fSt0FdQbAjFLA4IDBCA==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11859
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 impostorscore=10 suspectscore=0 spamscore=0
 lowpriorityscore=10 adultscore=0 bulkscore=10 clxscore=1011 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300048

Move the atomic context detection logic from erofs's z_erofs_in_atomic()
into the block layer as bio_in_atomic(). This helper returns true when
the current context is unsafe for sleeping bio completion handlers (e.g.,
hard/soft IRQ, preempt-disabled).

The logic was originally added to erofs in commit c99fab6e80b7 ("erofs:
fix atomic context detection when !CONFIG_DEBUG_LOCK_ALLOC"). A
subsequent patch will use it in the block layer's bio completion
infrastructure, so move it to include/linux/bio.h where both subsystems
can share it.

Convert erofs to call the new bio_in_atomic() directly.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/erofs/zdata.c    | 11 +----------
 include/linux/bio.h | 15 +++++++++++++++
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 74520e910259..f796bb3ef53b 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1427,15 +1427,6 @@ static void z_erofs_decompressqueue_kthread_work(struct kthread_work *work)
 }
 #endif
 
-/* Use (kthread_)work in atomic contexts to minimize scheduling overhead */
-static inline bool z_erofs_in_atomic(void)
-{
-	if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
-		return true;
-	if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
-		return true;
-	return !preemptible();
-}
 
 static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 				       int bios)
@@ -1452,7 +1443,7 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 
 	if (atomic_add_return(bios, &io->pending_bios))
 		return;
-	if (z_erofs_in_atomic()) {
+	if (bio_in_atomic()) {
 		/* See `sync_decompress` in sysfs-fs-erofs for more details */
 		if (sbi->sync_decompress == EROFS_SYNC_DECOMPRESS_AUTO)
 			sbi->sync_decompress = EROFS_SYNC_DECOMPRESS_FORCE_ON;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8f33f717b14f..62a983758e09 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -368,6 +368,21 @@ static inline struct bio *bio_alloc(struct block_device *bdev,
 
 void submit_bio(struct bio *bio);
 
+/**
+ * bio_in_atomic - check if the current context is unsafe for bio completion
+ *
+ * Return: %true in atomic contexts (e.g. hard/soft IRQ, preempt-disabled);
+ * %false when a bio can be safely completed in the current context.
+ */
+static inline bool bio_in_atomic(void)
+{
+	if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
+		return true;
+	if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
+		return true;
+	return !preemptible();
+}
+
 extern void bio_endio(struct bio *);
 
 /**

-- 
2.39.5


