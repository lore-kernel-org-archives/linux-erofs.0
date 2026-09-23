Return-Path: <linux-erofs+bounces-4596-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3005C982EA
	for <linux-erofs@archiver.kernel.org>; Wed, 23 Sep 2026 08:49:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hqVy21bmnz2ySj;
	Wed, 23 Sep 2026 18:49:14 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:39::e"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790153354;
	cv=none; b=hjF86kM1w/JNAJgfg+ylYN5991MaHZm3Nhmv/p2L046PGqFYchEb425dCS1USIF+Qrb8rdY7rQj61AL+jUp8qTuJo9B1oMG7FlKV7ljLHX4uT5cTArQU7MQyv16FuJt7sGkwNFJzKHtbRbyfzgXWtCZUZcAUQAgtiBMpwBDJfsJqxeieATSXN7p2oUrNJR3Z2NxEhMr7RBri6j/5NhMPngJZFLhvUhpJvv47uU5+E81T4M3wg5eI7W3S0de6jiGljjCF6HgyHCveiEb8dDPAynaM3UP+lgYjfRHdrvC8K9Tln273blxie9v9Jp8j1HZAVW6KDTvCTvYKJJiwu/ejdg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790153354; c=relaxed/relaxed;
	bh=25isk1T9lTeDXVlEdSd6pc8v7VoCNNgnnsyxaz1TEbg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fSwPV4KRnhBeYhaX5PiV25AjuD42HOrXZxbpFlIi/6cj9xZvYSkzCg3Ann0tyS9neeFzmpKOI5eyt7ClWqztwLVs+mkn5nJAdOFL2vj8/dMmDWVOW6Mo3sCLaxhKA5GYzzXVBcWtN1B+G9xx4frXBm3xaQQUw3YIVraDsPGrOnzL+SFDI3gvajbU9Gu6Cm+rAZB35EPL5QryEOlc+9jfVkMi1vFG3UTnnCZV568FaTO3G3/hPFFXgTj7rtE3JR1EScriFsIGGE4kh0Bkk5w/k8Jlj0i3V0mIu2vRzNpBjIYdC/lIZD907UV3L1Fk9DpYSbTB9Zz1G6mW1sEQ2Vx/Cg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=sAoySrtX; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:39::e; helo=mail-pj2-x0e.google.com; envelope-from=hwenwur@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=sAoySrtX;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:39::e; helo=mail-pj2-x0e.google.com; envelope-from=hwenwur@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj2-x0e.google.com (mail-pj2-x0e.google.com [IPv6:2607:f8b0:4864:39::e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hqVy06l1Qz2xs1
	for <linux-erofs@lists.ozlabs.org>; Wed, 23 Sep 2026 18:49:12 +1000 (AEST)
Received: by mail-pj2-x0e.google.com with SMTP id 98e67ed59e1d1-39e57ee1cb0so100815a91.0
        for <linux-erofs@lists.ozlabs.org>; Wed, 23 Sep 2026 01:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790153349; x=1790758149; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=25isk1T9lTeDXVlEdSd6pc8v7VoCNNgnnsyxaz1TEbg=;
        b=sAoySrtX+9Fq6LUDHx621BU3n1rQqPajigztuYXGMPuQXtWCifbGUCGsjlerlefOKr
         LxSNNsbhkXEA/VUhCnaiGEejbg4lC2blCemcJ9cJ6yZAIJF4eIBKqmuopbEVd8H8YL2q
         wC2ezUvrUrtnqefMp8c08pcwCV4VNbEjhucYAsEDge+cqsC5H6MOEP29lfDyV0YDBnjE
         HMugPvMlcw1BIZ6HGpLW4focneuxI1qm1kw1B/AUpBf3n+R0il7/L/k2CmNU335CTYst
         tf48WA0U1DvB8h6uzWx7JNvgUqraWBY8CjIqdLCvL6vi/phGOUvVs4DXC1mFZWGg45GU
         5r4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790153349; x=1790758149;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=25isk1T9lTeDXVlEdSd6pc8v7VoCNNgnnsyxaz1TEbg=;
        b=X9AoLrLMwLC+TDpTPIEOdUvNRifoMZJ3HgXNFeYtdhtq1tLBPjBvU+OFgCG/5JBqyR
         jXKpabTgKuBg8Dpi+jeF6ldvUfI1qDjzx7Y40bMsHfmHr/DmsVSxmvZD+3VXg2hSqXNq
         mqhtCda6SqY2T8Fw44eog0Ipq32TcFH5Va9eoPfTILtbeDZ5abqNFK50x3I41RtvQJBE
         VfukQabSov9/j6pluNjL/pomKUJ+8G0iIDE+zC2k5XuOiLUp2vq3Nm5JAd7baNPp2fJs
         8tG2LVc48H2Pe3CJpmWfeuvcq32t+ajDyzufSi9goRoNwdoq45pt5qAk7aTORIG2YKIM
         kMew==
X-Forwarded-Encrypted: i=1; AKwUvBwrlXbc1kTwOqa7JmXhgmPD4MKiHZUVfx0XmLJQ+5Sc8vcx/SZh/NsPtCQmNHvU2s88wU4fNmFzuqs0BQ==@lists.ozlabs.org
X-Gm-Message-State: AFuF++np16LdDvZtD/XFy53dHUP6K3TjYrkSuB2yxsiRJqmqrPmDREW3
	S7ejYYlXKAjHrlEe4HRMUHHToqIuHl0JD2lMIkB3ciA92pwb0IbeNsUv
X-Gm-Gg: AYBFou2e0bbDFpoQPRD74mWifqIYhLy9eZj2lk37bIrdzkYzL9d/rnFZun3pS5qWRzj
	r+ucP4OCwgWH9wo+yaJg8FbvuorqWm+g/S1fi1I24WyAclM+vb4NHAzB4Mc50RPXzReWux0Fncs
	9en327eBHEYNwukQ+a5ZnqIces+HMdapcwN7eZZg4Jm6umq7j2j60C0xDphQ2wwOLEYGRprOHsF
	ouB4tDv23WiNABSvQKm5LWHnLPs8vw3ULP9lKgWsnzbiAPFDFfPOKwxf9py5NmC3lv4ndyl4oAC
	562ZhyBpfWcppZHCwkxknZrvlRrozJZsbls1bBY9ZqTyt8lClAf73PVDN78P28Q4uBLmuaPiqpL
	xvyQJ3vHYPOR0UkSbc50u7hk0daRD+BnAVgfhkDy9wJjYo0Fm2SBjSsukBA0feVtC1NEgLm4awZ
	sUelqctq33p2CQegHK3lYS9PZh+h7FqcgjeA3QD1urkoZb79p7AD5nv/GkW3xEtdj3u25/rb8wM
	IBA6LRwsKvJ39G6v9mco8zy
X-Received: by 2002:a17:90b:4b12:b0:39d:eda6:89fa with SMTP id 98e67ed59e1d1-3a07e54ba3amr2796408a91.1.1790153349313;
        Wed, 23 Sep 2026 01:49:09 -0700 (PDT)
Received: from mi-ThinkCentre-M760t.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a07dc74977sm4041315a91.17.2026.09.23.01.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 01:49:08 -0700 (PDT)
From: Wenwu Hou <hwenwur@gmail.com>
To: gregkh@linuxfoundation.org,
	sashal@kernel.org
Cc: stable@vger.kernel.org,
	xiang@kernel.org,
	chao@kernel.org,
	zbestahu@gmail.com,
	jefflexu@linux.alibaba.com,
	dhavale@google.com,
	lihongbo22@huawei.com,
	guochunhai@vivo.com,
	yinxin.x@bytedance.com,
	linux-erofs@lists.ozlabs.org,
	Wenwu Hou <hwenwur@gmail.com>
Subject: [PATCH stable] erofs: fix large folio race in erofs_fscache_req_complete
Date: Wed, 23 Sep 2026 16:48:23 +0800
Message-ID: <20260923084823.496741-1-hwenwur@gmail.com>
X-Mailer: git-send-email 2.43.0
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch is for stable only. Commit c37460cd9b2fc ("erofs: remove fscache
backend entirely") upstream removed this code.

xas_for_each() iteration can race with reclamation of an unlocked large
folio and splitting of its replacement shadow entry. Fix this by
advancing past the entire folio before unlocking it.

For example:
CPU A: EROFS completion               Other CPUs
----------------------------------   -----------------------------------
Find F at index 0.
Mark F uptodate.
Unlock F.

                                     Reclaim F.
                                     Replace indices 0–3 with a
                                     multi-index workingset shadow.

                                     Another reader inserts a smaller
                                     folio, e.g. order-0 at index 0.
                                     Split the large shadow entry:
                                       index 0: new folio
                                       index 1: shadow
                                       index 2: shadow
                                       index 3: shadow
Find a shadow at index 1.
folio_mark_uptodate(folio).

This can cause a kernel panic such as:
[1030374.432778] [     C31] BUG: unable to handle page fault for address: 00001846af017b01
[1030374.432971] [     C31] #PF: supervisor write access in kernel mode
[1030374.432973] [     C31] #PF: error_code(0x0002) - not-present page
[1030374.433543] [     C31] PGD 5a44f75067 P4D 5a44f75067 PUD 0
[1030374.433546] [     C31] Oops: 0002 [#1] PREEMPT SMP NOPTI
[1030374.433549] [     C31] CPU: 31 PID: 2425624 Comm: node Kdump: loaded Tainted: G           OE K    6.6.88-****
[1030374.434154] [     C31] Hardware name: Alibaba Cloud Alibaba Cloud ECS, BIOS ?-20260421_110423-CN.l65g09119.cloud.sqa.na131 04/01/2014
[1030374.434156] [     C31] RIP: 0010:erofs_fscache_req_complete+0xc1/0x1a0 [erofs]
[1030374.434764] [     C31] Code: 17 c5 c3 48 89 c7 48 85 c0 0f 84 af 00 00 00 48 81 ff 06 04 00 00 74 1b 48 81 ff 02 04 00 00 0f 84 b9 00 00 00 66 85 ed 75 04 <f0> 80 0f 08 e8 96 04 24 c3 48 8b 54 24 18 f6 c2 03 0f 95 c0 48 85
[1030374.435044] [     C31] RSP: 0000:ffffb8f2fc973cc0 EFLAGS: 00010046
[1030374.435641] [     C31]
[1030374.435642] [     C31] RAX: 00001846af017b01 RBX: 000000000000000f RCX: 0000000000000001
[1030374.436885] [     C31] RDX: 000000000000000c RSI: ffffa02ab337d468 RDI: 00001846af017b01
[1030374.437127] [     C31] RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000000002
[1030374.437672] [     C31] R10: 0000000000000005 R11: 0000000000000191 R12: ffffa0060ec72300
[1030374.437673] [     C31] R13: 0000000008000000 R14: ffffffffc11b1990 R15: 0000000000007000
[1030374.437677] [     C31] FS:  00007f4928cdec80(0000) GS:ffffa07dc5f80000(0000) knlGS:0000000000000000
[1030374.437678] [     C31] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1030374.437680] [     C31] CR2: 00001846af017b01 CR3: 00000063d5356006 CR4: 0000000000770ee0
[1030374.437681] [     C31] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1030374.437682] [     C31] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
[1030374.437684] [     C31] PKRU: 55555558
[1030374.437684] [     C31] Call Trace:
[1030374.437687] [     C31]  <TASK>
[1030374.437692] [     C31]  erofs_fscache_req_put+0x27/0x40 [erofs]
[1030374.438900] [     C31]  cachefiles_read_complete+0x48/0x110 [cachefiles]
[1030374.440448] [     C31]  iomap_dio_bio_end_io+0x128/0x160
[1030374.440456] [     C31]  ? __pfx_stripe_end_io+0x10/0x10 [dm_mod]
[1030374.440950] [     C31]  clone_endio+0x123/0x1f0 [dm_mod]
[1030374.441550] [     C31]  blk_mq_end_request_batch+0xf4/0x440
[1030374.441556] [     C31]  ? nohz_balancer_kick+0x31/0x270
[1030374.441561] [     C31]  ? dma_direct_unmap_sg+0x48/0x1d0
[1030374.441565] [     C31]  ? dma_pool_free+0x22/0x60
[1030374.441569] [     C31]  ? nvme_pci_complete_batch+0xaf/0xc0 [nvme]
[1030374.442070] [     C31]  nvme_irq+0x6e/0x80 [nvme]
[1030374.442422] [     C31]  ? __pfx_nvme_pci_complete_batch+0x10/0x10 [nvme]
[1030374.442428] [     C31]  __handle_irq_event_percpu+0x46/0x1a0
[1030374.442431] [     C31]  handle_irq_event+0x37/0x80
[1030374.442433] [     C31]  handle_edge_irq+0x93/0x240
[1030374.442436] [     C31]  __common_interrupt+0x3b/0xa0
[1030374.442441] [     C31]  common_interrupt+0x3f/0xa0
[1030374.442446] [     C31]  asm_common_interrupt+0x22/0x40

Fixes: d435d53228dd ("erofs: change to use asynchronous io for fscache readpage/readahead")
Signed-off-by: Wenwu Hou <hwenwur@gmail.com>
---
For stable branches: 5.19.y, 6.0.y–6.19.y, and 7.0.y.

 fs/erofs/fscache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/erofs/fscache.c b/fs/erofs/fscache.c
index fda16eedafb57..fbf49f90bec12 100644
--- a/fs/erofs/fscache.c
+++ b/fs/erofs/fscache.c
@@ -67,6 +67,8 @@ static void erofs_fscache_req_complete(struct erofs_fscache_rq *req)
 			continue;
 		if (!failed)
 			folio_mark_uptodate(folio);
+		/* Skip the entire folio before unlocking allows it to be split. */
+		xas_advance(&xas, folio_next_index(folio) - 1);
 		folio_unlock(folio);
 	}
 	rcu_read_unlock();
-- 
2.43.0


