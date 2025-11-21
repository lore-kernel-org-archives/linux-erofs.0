Return-Path: <linux-erofs+bounces-1415-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 340D1CFA465
	for <linux-erofs@archiver.kernel.org>; Fri, 21 Nov 2025 01:45:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dCJ1s2k3Kz2yFq;
	Fri, 21 Nov 2025 12:45:05 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1763689505;
	cv=none; b=eCHD1yS6Bi2iUr3I4j2HIntAW0WSJjwlUXrdHyvw4I1eqwCNgvj2f7nQdxqH271QQlkrXcL1E2B2b7AqWB+Tc5A0nMy74VQmgbMRWZUJUDN2B1ZmWdSczrUBPV6WnF2SQOEx1zYgRU4yo2urNciqFq8PTb/yHHXaH8ZEeUw8jWvIkLTKbSokX+yh61kSImPsiTA5WrBewb93GGo1Ba3u6uVMFXGwrUms4Ogzic1Omz7XFI64J6ElTcvDs1UbiBkuxuEBnojoCjBVpIQW1UQJJjjRVNzaXhioZEVwkp+aNn7Zptn+SnahM0kzIPJp1uyj+NPkmGzauTkdjmjHbuaVLA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1763689505; c=relaxed/relaxed;
	bh=ydOvMSYGLBPG/Sw3HqmtS98YZtsA/FvEeL+izFPO4Ak=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=azXKFqwoBS58JMuYGetn1g7z1w5466mP/H2rlf0XqeKypWNBQRTlnzwdOfImDKn5mVehBGlj6tJP71XnAev05oo3jHtNYPmdfXwszCM5HsjqlIm5UJIpxiOAe0ZDcukE8YS5XRb88HOkH3xJgZTwjCPnGdw4Dz5J8/2oUjPEGJ5uJydlFOwVMyeFp44vSo/s6YVcNCGpFprxS/ExAf1KPhqezv0SpgOYBnI/o4FqsmkV8k/mGbSPcOBDivjQdvvnNCHTmumkWQQEtl//yWYI2mqSvQjS7JSyz1V0sJJZlPkjS9H/RTRq9K5EdlF0Ru0tEQuhFCUFMGZ05qM9weNnMQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=FPN6a+x5; dkim-atps=neutral; spf=pass (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=FPN6a+x5;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dCJ1p4fqmz2yD5
	for <linux-erofs@lists.ozlabs.org>; Fri, 21 Nov 2025 12:45:00 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763689494; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ydOvMSYGLBPG/Sw3HqmtS98YZtsA/FvEeL+izFPO4Ak=;
	b=FPN6a+x5w8mo+mA9bBlcypSdCrxaBa14trueND8Yy3WF8sDiz8IlKXexiSbZ+xuCZuwpyFGhsTo0QWV90nFKFJCpHgsnGJWG2cs9a/dYiqcEzhoSUo6RJkPQ+HtOAi01Y8WaKBCqDMMyzl0YLa1G5gt1CjMK94AMthzuqeNxSAU=
Received: from 30.221.131.79(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WsyfYXS_1763689492 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 21 Nov 2025 09:44:52 +0800
Message-ID: <1939a99d-c1d2-4b98-93c3-1951db367b3f@linux.alibaba.com>
Date: Fri, 21 Nov 2025 09:44:51 +0800
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
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [erofs?] WARNING in get_next_unlocked_entry
To: syzbot <syzbot+31b8fb02cb8a25bd5e78@syzkaller.appspotmail.com>,
 syzkaller-bugs@googlegroups.com
References: <691af9f6.a70a0220.3124cb.0097.GAE@google.com>
Cc: linux-erofs mailing list <linux-erofs@lists.ozlabs.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, nvdimm@lists.linux.dev,
 Gao Xiang <xiang@kernel.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <691af9f6.a70a0220.3124cb.0097.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git dev-test

