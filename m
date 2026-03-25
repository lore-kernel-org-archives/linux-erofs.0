Return-Path: <linux-erofs+bounces-2988-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91FFEFEA838
	for <linux-erofs@archiver.kernel.org>; Wed, 25 Mar 2026 09:24:45 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fghM01cv5z2xPL;
	Wed, 25 Mar 2026 20:24:44 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.97
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774430684;
	cv=none; b=EiOE2xP/SCQaivn2KCKN2BO75+ddgaahCkNpGHQUMdnb0+PBZH0my4nMx3DIoGrEayET66IplwhpTQhNc7Yo4bCVDjGC69FaNYnM2RMblu6ktAXk032VcoW9W5nM6qtgZIKOZ9TLgqpgZVmc0yoABmjabRaKXNRSZuO9fKWAVj9WcJkTbCpjHju1z5MyyIUgrO87mH75s+0uqxOxJ/lTVsMbnpJFkRKeIcYKEGLTvRuhLqsRjJ4OZjpI+Tzev0wjoMgqO51yg8QI4Dlqd6kKjY6UdHwHKIk6hHcSLOXizlk5GCoGkyD7jm5iLG8il8h8GwpJPkyyt/EH9/NeClRaAw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774430684; c=relaxed/relaxed;
	bh=bnzxU8nl+j0Q/hLx5b0H8uJBlg1eG5CgaeVuYdiP+OE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Ms7NYWPCWBc2jtLiqKIxcGrjx2XJaU4Qk/HikQR7PwF+epC9eQ5vULDtW+hdvbXV7Bnl/M/vGQtBqy5dzUdaNY+ToW9emQ7MFFrqQrdVLzDQv7ixiSg9Kygsqi5SCEI3tzpVcZeiwjCQPsOw0FtGG5/ym10e0JbC4al+J++Pg3fymxRUcLIMgYp4dHCTx9rujgh30uZ8vDbvw6Vu469iJ15UpG7gqYlQy6SNRw30FvgC/OIOsUWuYyvZQH/GsDE2ZNbCdaCqofvwT41vrbfvuRVBCJM7ou6rcLjYo8LE5XqaPhq9jxfYCZFYw41+rMKUlXFh+7/HA7LYnuJNOIneIQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=N35UV9H3; dkim-atps=neutral; spf=pass (client-ip=115.124.30.97; helo=out30-97.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=N35UV9H3;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.97; helo=out30-97.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fghLx4nZQz2xMt
	for <linux-erofs@lists.ozlabs.org>; Wed, 25 Mar 2026 20:24:39 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774430675; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=bnzxU8nl+j0Q/hLx5b0H8uJBlg1eG5CgaeVuYdiP+OE=;
	b=N35UV9H3S8YTzdfCETyt02NhkVkV+baPJjR1HIFoPr1MDLyS9n+GmwfmaT3qd4hIGeDpZLXkpe2Kif6omng4uT1xRxJUs3SQDuyAl711wf31kddFQchH/ENZvVApp5+3jm06xL8mxoNLs/rFv7VeiaSkq9DtpfbuWbcoCQ0koJI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X.hDC7n_1774430673;
Received: from 30.221.132.80(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.hDC7n_1774430673 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 25 Mar 2026 17:24:34 +0800
Message-ID: <5a1e8d3e-6533-4db4-a4d5-14f977d8514b@linux.alibaba.com>
Date: Wed, 25 Mar 2026 17:24:33 +0800
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
Subject: Re: [v6.6] BUG: Bad page state in z_erofs_do_read_page
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: syzkaller-lts-bugs@googlegroups.com
Cc: linux-erofs mailing list <linux-erofs@lists.ozlabs.org>,
 syzbot+b6353e35ae2bab997538@syzkaller.appspotmail.com
Reply-To: 6855f07b.a00a0220.137b3.005a.GAE@google.com
References: <8bed2474-4e2c-4a28-a959-bce3bc5190fb@linux.alibaba.com>
In-Reply-To: <8bed2474-4e2c-4a28-a959-bce3bc5190fb@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz test

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 496e4c7c52a4..29a73cbb5535 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1485,6 +1485,7 @@ static struct page *pickup_page_for_submission(struct z_erofs_pcluster *pcl,
  	lock_page(page);
  	if (likely(page->mapping == mc)) {
  		WRITE_ONCE(pcl->compressed_bvecs[nr].page, page);
+		oldpage = page;

  		/*
  		 * The cached folio is still in managed cache but without

