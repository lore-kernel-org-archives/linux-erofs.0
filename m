Return-Path: <linux-erofs+bounces-2947-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C698CEC01A0
	for <linux-erofs@archiver.kernel.org>; Mon, 23 Mar 2026 07:55:53 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ffQTN1tgKz2ygD;
	Mon, 23 Mar 2026 18:55:52 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=95.143.211.150
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774252552;
	cv=none; b=FH+WJO8co4zVnh+Lp7smTUFcwGRj6ADX/2FrcqLN/MlD2HenjkPHE3g8RMwOnY/IUWjvENrws5Hmz3NJHS8RV7JetnqpoV9iHhu08JEJ/UiCnLRJdNc0VpY9I705G1PqpbPcPv4raHxmqxDKBS31O75ZqyQrM/O93egZQfCQEQPxoNSigAi9MMQ9iF8w4rCT/HhlYFCbuahOlN8vLPy7bEI+u7Fzks74W2WFKJOM3ihGOPJuWYOqVxnT1OyECgHrvgzu7pqb2lcBnLlmhX/Nttm0ljsPnQuoYoio/Qz63fpwagY19LhXPMzwO0OOPIuuR7vPpJNMFBHrVnIg07V68A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774252552; c=relaxed/relaxed;
	bh=mtIn7DP71PXd+663izgnCvu3LmpJDtlv1yNdOZnKHqg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vrp16nO5QG6pv6nhanMpX2gDi5DvKe6ZWiwaidiC9ZFnPYXzDvCoeuaTyMTaxXE+QgM2EPABW8Dw+9wFij6ei/FMk8L0O5OhelGJhSh4g2OZvTT90WMVmC2YPwvGD8jtuJysQ/RrzhQkNi7izZ2Z9I7zd6tj7brpgJnwgaP4vsYNz62Lq7dxnJ+4ETsDW3Arqn/nB/1uFboKhg/XZCZ4YeimpU2u5+c6APkZAZiRLJXJ6a0+b/zgZbXMWHcI+f5897kpaqaAAQxINWnA/ayvqS7GxmqlaApVkmp3w20MhF/it2ZG4Q5dKGtKAEIZHbpTDSWxWzL/RwmwtwAUAMRsKQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru; dkim=pass (1024-bit key; unprotected) header.d=swemel.ru header.i=@swemel.ru header.a=rsa-sha256 header.s=mail header.b=ahs+/kMn; dkim-atps=neutral; spf=pass (client-ip=95.143.211.150; helo=mx.swemel.ru; envelope-from=arefev@swemel.ru; receiver=lists.ozlabs.org) smtp.mailfrom=swemel.ru
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=swemel.ru header.i=@swemel.ru header.a=rsa-sha256 header.s=mail header.b=ahs+/kMn;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=swemel.ru (client-ip=95.143.211.150; helo=mx.swemel.ru; envelope-from=arefev@swemel.ru; receiver=lists.ozlabs.org)
X-Greylist: delayed 452 seconds by postgrey-1.37 at boromir; Mon, 23 Mar 2026 18:55:49 AEDT
Received: from mx.swemel.ru (mx.swemel.ru [95.143.211.150])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ffQTK0YCkz2yYy
	for <linux-erofs@lists.ozlabs.org>; Mon, 23 Mar 2026 18:55:48 +1100 (AEDT)
From: Denis Arefev <arefev@swemel.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=swemel.ru; s=mail;
	t=1774252089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mtIn7DP71PXd+663izgnCvu3LmpJDtlv1yNdOZnKHqg=;
	b=ahs+/kMnjPt9fEYJjQbd+5OH32ue4Jh+F8UcVlQYnqJ7psQEbCmyF8Ww5aPhMfRzh+6wQB
	JvxNkrS7kZvKERejGbtlIjsEVZjv8XYzkOTy1RBntBmRv8NS9JGINNP36JxiMuiHZnY2Ks
	XkcB7aqOY9NIYBZ0YmAgxNqndpvXQB0=
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Yue Hu <huyue2@coolpad.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH 6.1 0/1] erofs: Fix the slab-out-of-bounds in drop_buffers()
Date: Mon, 23 Mar 2026 10:48:05 +0300
Message-ID: <20260323074809.4542-1-arefev@swemel.ru>
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

Syzbot reported that a KASAN slab-out-of-bounds bug was discovered in the drop_buffers()
function [1].

The root cause is that erofs_raw_access_aops does not define .release_folio and
.invalidate_folio. When using iomap-based operations, folio->private may contain
iomap-specific data rather than buffer_heads. Without special handlers, the kernel
may fall back to generic functions (e.g., drop_buffers), which incorrectly treat
folio->private as a list of buffer_head structures, leading to incorrect memory
interpretation and out-of-bounds access.

This can be fixed by explicitly setting .release_folio and .invalidate_folio to 
iomap_release_folio and iomap_invalidate_folio, respectively, but there is a 
commit ce529cc25b184e93397b94a8a322128fc0095cbb in upstream  that implicitly 
fixes this bug.

Please commit it to the stable branch v6.1.y .

[1] https://syzkaller.appspot.com/bug?id=c6aeabd0c4ad2466f63a274faf2a123103f8fbf7

Jingbo Xu (1):
  erofs: enable large folios for iomap mode

 fs/erofs/data.c  | 2 ++
 fs/erofs/inode.c | 2 ++
 2 files changed, 4 insertions(+)

-- 
2.43.0


