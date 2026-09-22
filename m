Return-Path: <linux-erofs+bounces-4595-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA4E7C98304
	for <linux-erofs@archiver.kernel.org>; Tue, 22 Sep 2026 20:05:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hqB0V74Bsz2ygK;
	Wed, 23 Sep 2026 06:05:14 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:38::10"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790107514;
	cv=none; b=k/JFqcCZuahjmvs7DVyz6BmrV+D/96J82s2J4G6e739pJRVICX/J4L1di4hqsVYfPXgNMf0+4dk1Bxl2FhNgKFRv+nsHerPDB3lsmqSK7YLh2R3m6iaWLWHE9y+205DaTxLpmfaSMZIs87DWUls5mYgjfMIhHg9PEoBU6DtKlJHYRaYn3ti2wv/R+KbULnoNolv8iwzjIdAzAFAR82W2J6W/l12h61Avx8gQzQ0F9sgkMDneSueEKBDDAmRZqJgGxw1idAvbzxwAeqbObwSsrjSNUb0p4syR4RwWeOkambWxBWK39mgpa4b7IBSI4IE0RYFf+9p17N+XIg0Q4GKG5A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790107514; c=relaxed/relaxed;
	bh=uyRungl+NqmtYNgL/8dH71XCYpq6TtSAT/snP5PAQEU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DVv6dfwfRLFKY8jPlyTcDzx8Fb4ifKezd+WTg+VoorNHVHxvFgiuGnWVwbWuoIcSAnXRea7op/e7Ys4Hh60kS+LqR3G7lD3A+vt+9+SHKtXziHo0ZMRhK+8PV0wpXzE/AtZlpokUn27aPie/Ge+kEh75fBAQdUk+sJV/neYRLag89T5WibdZzDec4CYJJ14rKXpLr8b3u+9KOJ8BviL7BYrwb1Vti1Tlrf/PRyPPRfp08eXZianHqa2dmaZ/s3u6hxohwnVpZuOLOdNp7bDlokxJWrL5fHezJ/gGA8CPgsprVzoBNc1PVbUUz+AYNaqTsfcRJa2/zQkv4RYPfIrFSQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; dkim=pass (2048-bit key; unprotected) header.d=trailofbits.com header.i=@trailofbits.com header.a=rsa-sha256 header.s=google header.b=E3ghwSeT; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:38::10; helo=mail-dl2-x10.google.com; envelope-from=artem@trailofbits.com; receiver=lists.ozlabs.org) smtp.mailfrom=trailofbits.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=trailofbits.com header.i=@trailofbits.com header.a=rsa-sha256 header.s=google header.b=E3ghwSeT;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=trailofbits.com (client-ip=2607:f8b0:4864:38::10; helo=mail-dl2-x10.google.com; envelope-from=artem@trailofbits.com; receiver=lists.ozlabs.org)
Received: from mail-dl2-x10.google.com (mail-dl2-x10.google.com [IPv6:2607:f8b0:4864:38::10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hqB0V0BcMz2yFQ
	for <linux-erofs@lists.ozlabs.org>; Wed, 23 Sep 2026 06:05:12 +1000 (AEST)
Received: by mail-dl2-x10.google.com with SMTP id a92af1059eb24-142dd05d97dso179181c88.0
        for <linux-erofs@lists.ozlabs.org>; Tue, 22 Sep 2026 13:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1790107509; x=1790712309; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uyRungl+NqmtYNgL/8dH71XCYpq6TtSAT/snP5PAQEU=;
        b=E3ghwSeT01d3yNrI+yxfxJdzCNTocNnd3F2bkvohqXNgf3h1IG8+f+l1x0Y439Va3n
         P7uaKpZBoGHrTSuMLu7DpmvhpCGJ9cfuNP+ktu2W+WvAWL0RurDIMnhdEQ57vbHK3bAe
         W4iFYNDczT8D4wo4sCdsdYl1AF7ZOkP+Xq1wOQnVnx7cx/lYUK1Wn8CLwfk4KjvPYsCy
         zPiZuTCovmGGem/P1azy21h0t/13Zdc2Trp2zQHf+Tvg3VQLzDh2bqXdvpv3o7r284HY
         PES2EEYz9dxh+TDV59/m7sP85B5GnR/BNTEKXJEhJbZKTeArrjyUeqNT2YXWvwgz1MOO
         zOsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790107509; x=1790712309;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uyRungl+NqmtYNgL/8dH71XCYpq6TtSAT/snP5PAQEU=;
        b=oMYnTLMuS0aApCZNEcytSPZZk+061tAR6rU4fr0ZnZyW46aADR73CLaGH+utyQhvcp
         +omBG9oNdobReVFSs/mpt1uKa51boWmenOMBZ6YbkJ2gCbBmvcUqVq2Zncvl1AHnMYL9
         q5mADprP1rAypNmS6HlZLg2a/MCaMdaKzc99VSaLWEq4u1oZEqoVaMpY/MSz3dVwg9W/
         wx8e2J4lCy9PchOGszzqZXAqCxyXaaymT4APdJigw+kJic79AKGc9H+L2pxdb8NDO9+3
         LzYVAkRIVaBdlHskLVekfNql+FfgYct8427s7NQxB6YbYXLU1YG0NFPqZoR6Cs1bbMLe
         V12g==
X-Forwarded-Encrypted: i=1; AKwUvByS4Y7TbSVsiaS3rqNWzvnq9odQ3mt4nWgiI4Uhm75uOPG31VRm/JyN5zT1H1tWK+DIQ/Ti3iBHMn7Ivg==@lists.ozlabs.org
X-Gm-Message-State: AFuF++mRLPnt5qNf0Fg/OAPg/WoDeJxwMk0ndzPcjau6xpNK0ZklwXXi
	pzzx87EhQZcOdWInERj73rgAudj+LuQLH539Z+lK/vU5yrTE2IdtbZUe1SoBr5f38IY=
X-Gm-Gg: AYBFou3glR+5e+DVrM5shT3bam4NFAVlz4wZrgXQ9ObKrhnI+ooPDDmZdXrwNcAK/A1
	oNtfLIkb14akm6chK7MApVPgzNdIjps1Ve03h///yNDj9nEv21uUThY+l8v8tsqUN49S6HAveBG
	dMhsYTmeFvkgbInoX+Re+/kIS/6u25Y78TdqEp4nFc6h4UdxqcsN1+35WZkkg7Qi1TnE1pua+u5
	UZjAWHJBqMs3Yo1lnmKB8ZZTBFnrfn6eSHq+Iq1uHtJnGfla8Nl8+9PJnFm6Qhpjx6JZItOhlj7
	2gYpsV34CycBcyqLCq1o27L+EhX0IdgPcjB++NCuVqn0dabqND8EgihDVd7rQ1LjEXe74LZoqr+
	2WEZy3c2Deo48d8nQC1ImgZGqBBoYYeMpnW1xtwDnhsB6+ZpfkS6KZVfWIP1e3wJ6VLoCLCHR+y
	l1TTA/5jAmuE0hgFlhne3yTgBUbEebXMRtei+uHtqPlBsz80e36mH9QW+3nunGLMEt3+u0U+fLL
	zRLBliyhN1sS9tJLCG4N4GJZVgzJiyElq3iC/fQULNLI5RYO5sCbnwRDTs1FNDCi5NKPRo=
X-Received: by 2002:a05:7022:3a08:b0:143:4710:a84e with SMTP id a92af1059eb24-144f9186b23mr505519c88.15.1790107493262;
        Tue, 22 Sep 2026 13:04:53 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:c016:77a6:d382:7611])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144f983c5a1sm852614c88.7.2026.09.22.13.04.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 22 Sep 2026 13:04:52 -0700 (PDT)
From: Artem Dinaburg <artem@trailofbits.com>
To: stable@vger.kernel.org
Cc: Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Yue Hu <huyue2@coolpad.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Sandeep Dhavale <dhavale@google.com>,
	Will Shiu <will.shiu@mediatek.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	Will Shiu <Will.Shiu@mediatek.com>
Subject: [PATCH 6.1.y] erofs: Fix detection of atomic context
Date: Tue, 22 Sep 2026 16:04:36 -0400
Message-ID: <20260922200448.27724-1-artem@trailofbits.com>
X-Mailer: git-send-email 2.55.0
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

From: Sandeep Dhavale <dhavale@google.com>

[ Upstream commit 12d0a24afd9ea58e581ea64d64e066f2027b28d9 ]

Current check for atomic context is not sufficient as
z_erofs_decompressqueue_endio can be called under rcu lock
from blk_mq_flush_plug_list(). See the stacktrace [1]

In such case we should hand off the decompression work for async
processing rather than trying to do sync decompression in current
context. Patch fixes the detection by checking for
rcu_read_lock_any_held() and while at it use more appropriate
!in_task() check than in_atomic().

Background: Historically erofs would always schedule a kworker for
decompression which would incur the scheduling cost regardless of
the context. But z_erofs_decompressqueue_endio() may not always
be in atomic context and we could actually benefit from doing the
decompression in z_erofs_decompressqueue_endio() if we are in
thread context, for example when running with dm-verity.
This optimization was later added in patch [2] which has shown
improvement in performance benchmarks.

==============================================
[1] Problem stacktrace
[name:core&]BUG: sleeping function called from invalid context at kernel/locking/mutex.c:291
[name:core&]in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1615, name: CpuMonitorServi
[name:core&]preempt_count: 0, expected: 0
[name:core&]RCU nest depth: 1, expected: 0
CPU: 7 PID: 1615 Comm: CpuMonitorServi Tainted: G S      W  OE      6.1.25-android14-5-maybe-dirty-mainline #1
Hardware name: MT6897 (DT)
Call trace:
 dump_backtrace+0x108/0x15c
 show_stack+0x20/0x30
 dump_stack_lvl+0x6c/0x8c
 dump_stack+0x20/0x48
 __might_resched+0x1fc/0x308
 __might_sleep+0x50/0x88
 mutex_lock+0x2c/0x110
 z_erofs_decompress_queue+0x11c/0xc10
 z_erofs_decompress_kickoff+0x110/0x1a4
 z_erofs_decompressqueue_endio+0x154/0x180
 bio_endio+0x1b0/0x1d8
 __dm_io_complete+0x22c/0x280
 clone_endio+0xe4/0x280
 bio_endio+0x1b0/0x1d8
 blk_update_request+0x138/0x3a4
 blk_mq_plug_issue_direct+0xd4/0x19c
 blk_mq_flush_plug_list+0x2b0/0x354
 __blk_flush_plug+0x110/0x160
 blk_finish_plug+0x30/0x4c
 read_pages+0x2fc/0x370
 page_cache_ra_unbounded+0xa4/0x23c
 page_cache_ra_order+0x290/0x320
 do_sync_mmap_readahead+0x108/0x2c0
 filemap_fault+0x19c/0x52c
 __do_fault+0xc4/0x114
 handle_mm_fault+0x5b4/0x1168
 do_page_fault+0x338/0x4b4
 do_translation_fault+0x40/0x60
 do_mem_abort+0x60/0xc8
 el0_da+0x4c/0xe0
 el0t_64_sync_handler+0xd4/0xfc
 el0t_64_sync+0x1a0/0x1a4

[2] Link: https://lore.kernel.org/all/20210317035448.13921-1-huangjianan@oppo.com/

Reported-by: Will Shiu <Will.Shiu@mediatek.com>
Suggested-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Sandeep Dhavale <dhavale@google.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Link: https://lore.kernel.org/r/20230621220848.3379029-1-dhavale@google.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Backport to 6.1.y: the source change is unchanged; only its location
  in z_erofs_decompress_kickoff() differs. ]
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
---
Hi Greg, Sasha, and EROFS maintainers,

I am continuing backporting CVE fixes still missing from 6.1.y.
This fix is inherited by v6.6 and every later mainline release, but 6.1.y
still has the affected code. The target-specific adjustment is described
in the bracketed note above.

Could you please queue it for 6.1.y?

Thanks,
Artem Dinaburg

CVE: CVE-2023-53231

Build: This patch was included in an x86_64 allmodconfig and
CONFIG_WERROR=y build.
It produced vmlinux and modules with no new warnings or errors.

AI assistance: An LLM helped find, adapt, and validate this
backport; I reviewed the patch and test output.

 fs/erofs/zdata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 66c323cbdd73e1..49b7c77488415a 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1271,7 +1271,7 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 	if (atomic_add_return(bios, &io->pending_bios))
 		return;
 	/* Use workqueue and sync decompression for atomic contexts only */
-	if (in_atomic() || irqs_disabled()) {
+	if (!in_task() || irqs_disabled() || rcu_read_lock_any_held()) {
 		queue_work(z_erofs_workqueue, &io->u.work);
 		/* enable sync decompression for readahead */
 		if (sbi->opt.sync_decompress == EROFS_SYNC_DECOMPRESS_AUTO)
-- 
2.39.5


