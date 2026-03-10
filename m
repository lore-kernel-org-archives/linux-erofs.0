Return-Path: <linux-erofs+bounces-2615-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB44EFD2D62
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 12:05:32 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVXdC1mLPz3cJ9;
	Tue, 10 Mar 2026 23:05:19 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:bf0:244:244::120"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773144319;
	cv=none; b=CgdOA9FiSNK308IPthXSA/bCWn9QloZ00VitQbuJYYS9avWkdmWgW0drPC0REXZVu3fZq8JZFltvfnUfNe/Vujw5PgnjUUX0APsD2cn8gyXTouUfDNoD912/viwjWEieYVrwkIpSyS5leFippRZSNstNubwJncRYe6k5CXW2MxOzopJoWDW9+QK8opJxrRyQb8LmEAxz682RIDCLIC6X6wrBII1ChI1o75OSmxQmD1PcX1F44bIfx5wqz55khO4hxAkv5jeCDBQVPQZ4Mq85aQFj2ebDVBjB1GC+EldFysnzzd3YU4TX95n7T6QOsWA/vwQVGuZNGEO/6xLcy3N1gA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773144319; c=relaxed/relaxed;
	bh=Xi8Rxb9N8gVUASmXPG2lAu3yO+J9YHYyyksDmdHBdxY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YpER/kyUgCCccy4/iWpkux7VaYLoTbVQlFnSPtW/Jkjr3w60zH5hynTdCo00TBotsHUwbLz4WWjVWKH6zgBwZrdy7g0FLMUl7odhxS/JYu2BELdxH8quzOLIVcIHit4ZpCPmUKMwA1wQDi7/wOC54wajfX0cAjoUkPlx6e/8voy/FVuDRXvjMBiCHvdORPO5cI+qKPJ4ITINs+goM3pDmb5LVI1+tyHUorOMYnPNnLz/VwfNiwAHQgAC9XjtRYgDDjvjCZPrD0EQy61aC87gn51mpiLtIEWHLWjC69uHLhVSeagWK7h6JmsDZiqbhH3pGK759wzflkg2uLj8ASdrmA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de; dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=J3wSWYAg; dkim-atps=neutral; spf=pass (client-ip=2001:bf0:244:244::120; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org) smtp.mailfrom=avm.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=J3wSWYAg;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=avm.de (client-ip=2001:bf0:244:244::120; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org)
Received: from mail.avm.de (mail.avm.de [IPv6:2001:bf0:244:244::120])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVXdB3vV0z2xlh
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 23:05:18 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143724; bh=1PXfnuytcDxCJ5WvjcpjD44YA1sDO5ZH9mYGPwGsGfw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=J3wSWYAgTHffE/RASKBpQWq2ySnTd5MpW6YLASVrV89gusHRkOxfAkrwsTjGvFaNS
	 hDxuWWXJL4XVOl+LI/t97dlq56rN6Kpzc7n2jHPxY+V+uUTEo8r5Ulk5M3qiRSRkq1
	 dYJqASb6U15Y8KxN9uh8urreNs5K4N5plRC3Hf68=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ab-b734-7f0000032729-7f000001bff0-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:23 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:23 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:42 +0100
Subject: [PATCH 16/61] sched: Prefer IS_ERR_OR_NULL over manual NULL check
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
Message-Id: <20260310-b4-is_err_or_null-v1-16-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
To: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
 bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
 dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org, 
 linux-mips@vger.kernel.org, linux-mm@kvack.org, 
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org, 
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org, 
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, 
 Philipp Hahn <phahn-oss@avm.de>
Cc: Tejun Heo <tj@kernel.org>, David Vernet <void@manifault.com>, 
 Andrea Righi <arighi@nvidia.com>, Changwoo Min <changwoo@igalia.com>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1398; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=1PXfnuytcDxCJ5WvjcpjD44YA1sDO5ZH9mYGPwGsGfw=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYMDPZu3smBGrrjEDAZgewRd/vSzrMtCJxCU
 Ab0/aCneJOJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGDAAKCRA0LQZT0ays
 2yYuCACBFSism0sJT51wNOH3mmVipRWFOp8Vg+RkYWteB8QGePJlSbJv9OJm09HMkW7tLjwUyWX
 VVHeC9B16w6ID+8gEcOTClH7t/fK4Dy8WecKHkh0F285AVZWcglgZ3SjIJUNbcIL4vnctyxVDTz
 UXRKVqYZS83Tz67A8a3xEjr7wme1UPPk+FME5Cb8slTwxHRkeibjPT1wP0LHzCbUOIo6nCgv8R7
 jLfvDCodAoO4aPJRzL3vfdPDFaqXegciQKVWThwHK6Iz+gXqJuudCNdAk8Oa0FFSpSor2eNbdWj
 hK6ZRlUo0db2BRvH/nraA1HapgaLEA9P2vfUY2mJwp9Lzm4g
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143723-E0DD4A3D-EB59D507/0/0
X-purgate-type: clean
X-purgate-size: 1400
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Tejun Heo <tj@kernel.org>
To: David Vernet <void@manifault.com>
To: Andrea Righi <arighi@nvidia.com>
To: Changwoo Min <changwoo@igalia.com>
To: Ingo Molnar <mingo@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@redhat.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
To: Ben Segall <bsegall@google.com>
To: Mel Gorman <mgorman@suse.de>
To: Valentin Schneider <vschneid@redhat.com>
Cc: sched-ext@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 kernel/sched/ext.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 1594987d637b09e586ae788b7f2e6336332d605a..cfa869bd7de5406a5ca094992ab04c62b0e92fd0 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3688,7 +3688,7 @@ static void scx_sched_free_rcu_work(struct work_struct *work)
 	do {
 		rhashtable_walk_start(&rht_iter);
 
-		while ((dsq = rhashtable_walk_next(&rht_iter)) && !IS_ERR(dsq))
+		while (!IS_ERR_OR_NULL((dsq = rhashtable_walk_next(&rht_iter))))
 			destroy_dsq(sch, dsq->id);
 
 		rhashtable_walk_stop(&rht_iter);

-- 
2.43.0


