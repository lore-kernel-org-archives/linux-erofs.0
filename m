Return-Path: <linux-erofs+bounces-469-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B895C71159
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Jun 2025 03:53:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4bN6CR6vPWz2xpl;
	Thu, 19 Jun 2025 13:53:23 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1750305203;
	cv=none; b=ebi+RGSBC19F6tI5Nht8tl15wVUdSAIEcgFHUex4yl82c4F2OpR5wVXtP1NOXS0opbFkdc+cHkbZsLsFTyruDEHpU8N007nctD0tdUsbE/XW6z8xEWfWsX0Ff7TGEfezTlYyuCb23lBNxSEGgdyA/tyE2caixV4dBKyMPXgzzIVuOdNfH29DCtnCO7+1dd5w5+pX9riDpm0edEaf3MtoJ91Ea9Bda0YTbwSx/MBtzBAUH7021S1dtyHJtJ0Vi07yxW9o0iCNdaOFCQZQe05Pk5XVKvXSduU9+UY5Awa3g0KlGlx04biLlQg9f6IYJWfvC/DSTbxMHIn4MaHHL/jT6g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1750305203; c=relaxed/relaxed;
	bh=ydOvMSYGLBPG/Sw3HqmtS98YZtsA/FvEeL+izFPO4Ak=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=oGVAbCPBoLiCCS5igWHZHR/zNHx1YVe3EBzJjxkSUDJ6hTK02OhnXs1o6WtzeEA1KCdIIrnLxX5HvTHBZt612/KGiHGjiX6fFUHxxuJMGl6OLTYcgyaGHEpXBBuTYAQ1fxiJam0+ixpOxwvlSnTNwuAXdttNYsaDr3gPCmcqPW71il+BLlCYg1mBLe2DCqiTxzdwJ0Wt+fQ+hs7ZLsxP5cj1NsjG8HcQZfEUswUZukV/2N4eyfBsvGVS7+o61kt7PAhK1xf/JsMtYtTUwIQZEwHPEF0bB/QRZTcVxTs32Xdbmr6KXkK5rttoKJR0r+9BRKdNCKc9DxpFDUHVvStG1g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=H0C9YsSt; dkim-atps=neutral; spf=pass (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=H0C9YsSt;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4bN6CQ0N75z2xjN
	for <linux-erofs@lists.ozlabs.org>; Thu, 19 Jun 2025 13:53:20 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1750305197; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ydOvMSYGLBPG/Sw3HqmtS98YZtsA/FvEeL+izFPO4Ak=;
	b=H0C9YsStdSCpDLUu0LHbzKrqg0v3jpSr7ERJGExR6xqb+crLmrqWSnlHxsnMLopps1C7nZMMIYcAIFRwp8tirRd91GrueTmwuoxJdvqtp9Cf9U0VmdxavPnWxnTGb2MrzJf7e55qPU3iy2H9RCjP5NA3Uak1BR88fz4lEjKKWoE=
Received: from 30.221.131.54(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WeFmZ87_1750305195 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 19 Jun 2025 11:53:15 +0800
Message-ID: <5a513fca-b8cd-40b9-9b28-9793cf80e293@linux.alibaba.com>
Date: Thu, 19 Jun 2025 11:53:12 +0800
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
Subject: Re: [syzbot] [iomap?] [erofs?] WARNING in iomap_iter (5)
To: syzbot <syzbot+d8f000c609f05f52d9b5@syzkaller.appspotmail.com>,
 linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <684d44da.050a0220.be214.02b2.GAE@google.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <684d44da.050a0220.be214.02b2.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git dev-test

