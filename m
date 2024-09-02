Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3594CD13CF
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Sep 2024 07:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1725260460;
	bh=16T8kYwpbBuW3+NAto6Jm8Gq1eiF2RMZkO+aeHQ7K1o=;
	h=To:Subject:Date:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=S+f2x7wRBhiHmCOXljT+LrUA8g0Zi2HyGSZGG8Buf8dOVHxSfsEQrhqnoct1ls6ZJ
	 6d385CCddwn/wofZ/PJdsavowrSNNjvvbVJ6slJd5+otT5GGQy/HQkwTB2C0IYzsSA
	 gHdQccr38F7Uf8NvxfXgSHQEZ0+TWeqXFSZAEygejXJndZSr8K8s92Y8ZleFe9DLD1
	 1Y7YB6Q/StaOCeTe88surK92i9SEYjkE4/BwxI9WiyH3Aaj+j1IY9Z+W6PXRsPolH7
	 UT4rykXkvQsUPBdp6kQPVHB3CQQt62SGouB0f2mB+nhQ7STReTtAQZkf44bN+FVlRh
	 l3w/q/yiwV6Bg==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Wy05m0xFLz2yRZ
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Sep 2024 17:01:00 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=148.135.17.20
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1725260457;
	cv=none; b=C/CbqsJp1eSPcfD3ekKSF5+qUkzBPOMvuKRwQiFmg3tOiYpzJ2BnEj1k6KG057ihKWED0Yzs1fTAZDJ+v6mA8U5NG9Zxky5rWr3W3QWbNE4sC9kAsOFU+XxETE5eAb/tkYjrwVOJOxhXCk1mmHwS4fvikKetxHMeFtnRS02oNn1O/S6/EP3gCa6wn8lqy0Y6W7s13KpR4bhNqSMxuDWgZBeOayGha3oq7IfeoEuz8THsQIVVxrpi0876vEGIGpYZmDxZVo95OF2bMaCuMg3BjDyQyJxnyfbfiZwcc8wmY7+sE2EAwNqV6r8lWLo4zQd+Ixo+PtyEdjB337FmEF09jg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1725260457; c=relaxed/relaxed;
	bh=16T8kYwpbBuW3+NAto6Jm8Gq1eiF2RMZkO+aeHQ7K1o=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Last-TLS-Session-Version; b=BFudZ8KDdPlrLvaOy4Y8ukGI/cbMMSrKq6yijQXHfqekMOUW14BwGZZyRvfPuAWDpbLSp15IsbAiUQajp+DcKBQpTrVTxnnwiXY+7bFwk3Hk1pqHcX6d7OvuiYCSEtJyQfH4CQO7ME96ciUEPOqzOo2U0nRvK8Ye9ssLKtBltM8ll0SpmN7WVzJ+H7voToMLiCtxnu6KXD93A6L1cKK1d3qSYmfskI1HSb4gNZtuCJf5IFp5XB+NDQdjp6IluR+aFEXr5CJFdW9RMG0Z8ataBIprFVn9R6lDuBeBn4jjHT/mfeFn0fVdAFYfiE5d15Df3hEcxBzjSrZS4zWFtxJcGA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=tlmp.cc; dkim=pass (2048-bit key; secure) header.d=tlmp.cc header.i=@tlmp.cc header.a=rsa-sha256 header.s=dkim header.b=mrDi/Zgt; dkim-atps=neutral; spf=pass (client-ip=148.135.17.20; helo=mail.tlmp.cc; envelope-from=toolmanp@tlmp.cc; receiver=lists.ozlabs.org) smtp.mailfrom=tlmp.cc
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=tlmp.cc
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=tlmp.cc header.i=@tlmp.cc header.a=rsa-sha256 header.s=dkim header.b=mrDi/Zgt;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=tlmp.cc (client-ip=148.135.17.20; helo=mail.tlmp.cc; envelope-from=toolmanp@tlmp.cc; receiver=lists.ozlabs.org)
Received: from mail.tlmp.cc (unknown [148.135.17.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Wy05j40qbz2xtK
	for <linux-erofs@lists.ozlabs.org>; Mon,  2 Sep 2024 17:00:57 +1000 (AEST)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id EF39D69838;
	Mon,  2 Sep 2024 03:00:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tlmp.cc; s=dkim;
	t=1725260454; h=from:subject:date:message-id:to:cc:mime-version:
	 content-transfer-encoding; bh=16T8kYwpbBuW3+NAto6Jm8Gq1eiF2RMZkO+aeHQ7K1o=;
	b=mrDi/ZgtzeRmQ9tVh6O5hsOYQk+gDHZY1ZKCpbhiBwGK62Li6GFA/zm3CGMt1tuccd6dpI
	gEyEP3dTmu2HF8uLQLPoryYoSq+KPJh9OPeHxdthkWNdkQLdSB9ZhVkVrRJt89bk5JAX5r
	4sM9OtlYBQtBX2rE1dSRnZYzx8Y4uJi/M3ZTXZndVmO9jA+ksNtB5todmUf8j57R3S3Kbh
	FD09Is6E9tidyD2iosWeexU5FWna+DviFCNlwZPLuUdasiT8nmdKVtYkJ0ZVaUJ0x3oHd5
	OuqYyAIj4/3kM8IpkLEu1mhs7e0MA0MbRenHPfDGDgmhGEx8/IaB79LWs2uxCQ==
To: hsiangkao@linux.alibaba.com
Subject: [PATCH V2 0/2] erofs: refactor fast_symlink and read_inode
Date: Mon,  2 Sep 2024 15:00:45 +0800
Message-ID: <20240902070047.384952-1-toolmanp@tlmp.cc>
X-Mailer: git-send-email 2.46.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
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
From: Yiyang Wu via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Yiyang Wu <toolmanp@tlmp.cc>
Cc: linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

This patchset is response to the original suggestions posted here[1].
Since my later work is somehow related to this issue, i think it's
better to deal with it first.

Changes in V2:
  1. Lift the erofs_fill_symlink patch to 1/2
  2. Fix code styles problems in read_inode patch.
  3. Fix the formatting problems caused by clang-format.

[1]: https://lore.kernel.org/all/20240425222847.GN2118490@ZenIV/

Yiyang Wu (2):
  erofs: use kmemdup_nul in erofs_fill_symlink
  erofs: refactor read_inode calling convention

 fs/erofs/inode.c | 128 ++++++++++++++++++++++++-----------------------
 1 file changed, 65 insertions(+), 63 deletions(-)

-- 
2.46.0

