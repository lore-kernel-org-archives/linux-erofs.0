Return-Path: <linux-erofs+bounces-2987-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD85EFEA833
	for <linux-erofs@archiver.kernel.org>; Wed, 25 Mar 2026 09:01:01 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fggqc2MCtz2xcB;
	Wed, 25 Mar 2026 20:01:00 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774429260;
	cv=none; b=L46pvOO+HmjDmlF1X1lfLSESnCzjhflAn4Gqr1wajyN77IyQfxuotgOdCQk6kxngV5mag8v75kO8ZP1OcrXWN0yofJQQ9yl80E2rsYdQMh0ayYv8YQGxPeDNkyKChQmR9MtsobpcoXpH96pwUGXrtCoTBawKRyVfi0yvz2PtqVSAsdNTLPW7l5pVi3vGFg5ad5Qx5eTbituDw6Vh1K8MqgLX1V+f0QMlw7aFhIeEXjjeYGOyh128eskeFkp01ikrjW7gJe1xcTWJCUieBwpTgclHpe3lvbsJmtOtZuzWOA0HgTWrkuqplePjGpLoKLkot2szL5qS+1cmABWD5yRzzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774429260; c=relaxed/relaxed;
	bh=w+nLUZgwSWMrVsQ9BWc8IL6TNoSizs7cHzH744u3HYw=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=PI9CeFBx3ngIPbZX2KkFvcRqM+hmDVD068agMX9YNNrmXANYEzRN7KT+RNeTGi7fy8omz/0gMgfjMsGExRQMiVI7ZoztiawNoVwzhXr8Ox+571flgHSb7YXIAu5U52Z1++gaho18ah7Xzt8lnUGlzbmzjM+Bnr8AYgSBm8iQW+kUMBRbqqNSodscFJk0PNe+7VDi7gje4OYxcIA/qsTybUq2IqG97sdE5791c3soP/j67eweB4q/TRhOVxNexMMz+/5q/A5EmdX/vq0U30XJal1F0jHsQu3AatxN0j5itnKiRPEmzYaCeIpPfNktPBAK90oRi0XE9TK0efjvzB/OnA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=qcgFNxVG; dkim-atps=neutral; spf=pass (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=qcgFNxVG;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fggqZ3DXxz2xPL
	for <linux-erofs@lists.ozlabs.org>; Wed, 25 Mar 2026 20:00:57 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774429251; h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
	bh=w+nLUZgwSWMrVsQ9BWc8IL6TNoSizs7cHzH744u3HYw=;
	b=qcgFNxVGHun9fQws7HocMyDDuiQH0kRH9GDftLB2lT4T4sCctnWt5GVL2ZSdNo5hC7YQl+vpAIxGXghmWQ2nVa2oHDwPkEcg92FB4+yLBW+YL7mHji+cuVuKjr+cKxLXd/b4ViedFIZrA8vJJGLd19OwSEScsEK5P/oguLeRDtg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X.hGmRK_1774429248;
Received: from 30.221.132.80(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.hGmRK_1774429248 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 25 Mar 2026 17:00:49 +0800
Message-ID: <8bed2474-4e2c-4a28-a959-bce3bc5190fb@linux.alibaba.com>
Date: Wed, 25 Mar 2026 17:00:48 +0800
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
To: syzkaller-lts-bugs@googlegroups.com
Cc: linux-erofs mailing list <linux-erofs@lists.ozlabs.org>,
 syzbot+b6353e35ae2bab997538@syzkaller.appspotmail.com
Reply-To: 6855f07b.a00a0220.137b3.005a.GAE@google.com
From: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: Re: [v6.6] BUG: Bad page state in z_erofs_do_read_page
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz test

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index c1f802ecc47b..e744717d6003 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1538,6 +1538,8 @@ static struct page *pickup_page_for_submission(struct z_erofs_pcluster *pcl,
  	}
  	unlock_page(page);
  	put_page(page);
+	/* since pcl->compressed_bvecs[nr].page has changed above */
+	oldpage = page;
  out_allocpage:
  	page = erofs_allocpage(pagepool, gfp | __GFP_NOFAIL);
  	if (oldpage != cmpxchg(&pcl->compressed_bvecs[nr].page,

