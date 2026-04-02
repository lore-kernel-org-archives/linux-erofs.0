Return-Path: <linux-erofs+bounces-3179-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DB10CC6B03
	for <linux-erofs@archiver.kernel.org>; Thu,  2 Apr 2026 06:51:11 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fmXZ56ZJBz2ySk;
	Thu, 02 Apr 2026 17:51:09 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775112669;
	cv=none; b=Hg4YtKQrYyQ9uUtebiRoGFRr8QEU4XHQPACuxZ52KBpWbx1bN4j8ZzRurcTDcwG0i9uN6Xgmc/2MgoG6hF4RkIXW5hiRiBXfZeg08iF/JLXjtTwBhV6FlBHz4kHw5dK8oQRTKKpfSVHX+l5g3yj81Y0TAwLdTX5/bdShn7puXFg4CyYJSN2mPCZNA+ldJpWIBVV8NPalQOctDd1nvhCoLdnS2f/RzZNKR2eqiuNKwwVz2/A/GQTEmiIauDuqnSfAfyICczl4txVsfm92SepPP1bCjeU/C7oHvbT3SLeV5g/WCBz0kMcFJzrhYniSzqgsKxA47FhKS+348gGmn9ZKUw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775112669; c=relaxed/relaxed;
	bh=XPub3ttwgo1nF3b7aGMRD7d4QMa8fEtpxpmqHPa6yDM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jpRFk+Re3q/l2zn4LYcSJxkJlIoyVuxOyxGvBETfPyQuPqVfR9Tpf/Y+amgApTPZH5Aib4gMmdCVgX59r9+BR4UyDQOMd55pnuHfDooI0dgUETkUJ7vC5VcuSGvHZ8gmtFVn1+ujFQt2BL9frvWrB7M1DYHFkuGnoJgs/kzvNsz++RJxqamLijiPnCeYtWbRP/m40kQ1GvyEhOdPBKn7kZJ6AEoYyTM6Afao/jkV3w8+OUc/WUM+uFDFAILVVAUQ0ju9afnR0rFs0F3ViA+Vnx398pnrJkZ4eys8IvVdcEEvKoGhGRwNe8tGi1OWd+2ZVro8KW2R671qUum05FAB/Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=QW5miK0T; dkim-atps=neutral; spf=pass (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=QW5miK0T;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fmXZ23Fvmz2xln
	for <linux-erofs@lists.ozlabs.org>; Thu, 02 Apr 2026 17:51:05 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775112661; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=XPub3ttwgo1nF3b7aGMRD7d4QMa8fEtpxpmqHPa6yDM=;
	b=QW5miK0TzjxKPWv6VY/3cmbqxXo4n0m/RW7PWAkSPWjVpylse6ujtdo3NIrlxkl1A0k5lzCHq6zx5+MC7/cI2+1nzWzccMAf3vF2AtGCocYsH5uBFS4jUjC8jWG0+KG/VEE0puJGsBXFuUOHAJohcgJEPxKDdfB+h2VwHBUHV7o=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X0GCdqV_1775112660;
Received: from 30.221.132.8(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X0GCdqV_1775112660 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 02 Apr 2026 14:51:01 +0800
Message-ID: <9ada4eca-3dfa-4f25-8ae4-04ece5d1acbb@linux.alibaba.com>
Date: Thu, 2 Apr 2026 14:50:59 +0800
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
Subject: =?UTF-8?Q?Re=3A_Request_for_Late_Proposal_Submission_=E2=80=93_Medi?=
 =?UTF-8?Q?cal_Emergency_During_Application_Period_=5B_ref=3A!00D1U013lbu=2E?=
 =?UTF-8?Q?!500Kd0300s0L=3Aref_=5D?=
To: GSoC Support <gsoc-support@google.com>
Cc: "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>,
 "bushrahz.giki@gmail.com" <bushrahz.giki@gmail.com>
References: <CA+ug3icM1dnMfjtesxSFtM9yJWCxzfG6oyeur1KGPQ8384G-Qw@mail.gmail.com>
 <d_rMO000000000000000000000000000000000000000000000TCTM2J00loEVDwndQfigB8rc9Ozi4Q@sfdc.net>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <d_rMO000000000000000000000000000000000000000000000TCTM2J00loEVDwndQfigB8rc9Ozi4Q@sfdc.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Admins,

On 2026/4/1 23:08, GSoC Support wrote:
> Registration and proposal submissions for Google Summer of Code 2026 closed on March 31 at 18:00 UTC.
> 
> To maintain fairness for all participants, we do not grant extensions or exceptions for any reason. This includes:
> 
> Misinterpretations of the timeline
> Technical issues or submission errors
> Internet outages
> Any other reason
> 
> As stated in our guidelines, it is the applicant's responsibility to submit well in advance of the deadline.
> 
> While the window for this year has closed, we encourage you to:
> 
> Review the Contributor Guide at g.co/gsoc: Specifically the "Choosing an Organization" section.
> Stay Connected: Engage with organizations independently to prepare for future applications.
> 
> Note: Due to our team's small size, we cannot respond to further inquiries regarding missed deadlines. We hope to see your application in a future cycle!

Thanks for the reply!

Yeah, we already have enough applications, and we don't
consider (or have any bandwidth to consider) any late
application as well.

Thanks,
Gao Xiang


> 
> Best,
> 
> GSoC Admins

