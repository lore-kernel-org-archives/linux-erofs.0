Return-Path: <linux-erofs+bounces-3046-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F25810A88F6
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Mar 2026 17:52:47 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fhWZj4MF7z2yZc;
	Fri, 27 Mar 2026 04:52:45 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774547565;
	cv=none; b=ltlkmhq8J1KNQrQptpFQppQkOsZ0egr4MBKQAw1kTHiUPi6HcNI+ynk2alTWpwTocWX3BcB2ZA36qNGzc2CkuwFxcIFzgp59GLnYxDiH+IX1q/8AJVyxpCNCLIqKeof0/IDq7nz69iMWOQUtdKFdoE3hteycop4GoNDtdmfhF9tAwiv29E6jrpi7iohp8FkBh/WLTB/glHeNAPk55VFUdNqr3SzIkst41yvFa3MFLZHXcjWmXfcaHXnRQ1Rsx+zWUzVwseZTaV1NyRnHt8fRxMbx25CJb9Z0QzvPwo9pcugTSUC7GBg3OB/J+jHPLQNaj36TZ21OzqdxVrcqXKjKPA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774547565; c=relaxed/relaxed;
	bh=RnVuSvKqf20Cr4r257GZqJcBzBFZ3xRTChVc+sQ7vCM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gngp1DlE1fAb9it3OzGjNzs1s72NxrUnuZ2skJO4i5OT2FNWHbIq8ZJFizg7KJvmbz0+h55gFf78iHaAEzipaFuzrJVAC6ceMmnVP8f6e5eIcAnireYbpHUhmlLYjQgL8dn4/cJQqBB1Cs064rnSQGDiqYNC/FVKKFUhurZAi0NxCIdV/eS4CtBhMQK8GZF7TtzzvGVsB1IyASUFquyCXiobhWnuanyLJ2LWG1ePMW3oCgbGpmU3fUlXr0014+jYG6/EH73H25Q5Bc3cgpzk1O45CsZWSBmNBWiEO8SzjU43BsOR2ICr//NqG7blYcY/quw+HIC2jXTlE0AnsG2ilg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=VJVNODXf; dkim-atps=neutral; spf=pass (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=VJVNODXf;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fhWZg3WbBz2yVL
	for <linux-erofs@lists.ozlabs.org>; Fri, 27 Mar 2026 04:52:41 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774547557; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=RnVuSvKqf20Cr4r257GZqJcBzBFZ3xRTChVc+sQ7vCM=;
	b=VJVNODXfXmaCQeBwO7/l3wTyKLpJADmz//GySdBy+Euzy53oAU9+SNzcnPPL6SHEmsdXaGb29DGL93Oqal7vXA5yxszsSxPiM6Sj7lqx6B9Ql/YjF9U3/1KkN8dpjXBfnrugwVwttqvtIYHsNc9h69DAR1sWjiO4h+LM54K2vQo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0X.lnjv1_1774547554;
Received: from 30.41.54.139(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.lnjv1_1774547554 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Mar 2026 01:52:35 +0800
Message-ID: <da934dc1-adf0-4961-a43d-e615780c4e38@linux.alibaba.com>
Date: Fri, 27 Mar 2026 01:52:33 +0800
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
Subject: Re: [PATCH] erofs-utils: tar: guard NULL hardlink targets
To: Vansh Choudhary <ch@vnsh.in>, linux-erofs@lists.ozlabs.org
References: <20260326174050.119176-1-ch@vnsh.in>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260326174050.119176-1-ch@vnsh.in>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/27 01:40, Vansh Choudhary wrote:
> erofs_rebuild_get_dentry() can return NULL for empty or dot-style
> paths. Treat that like an unresolved hardlink target instead of
> dereferencing d2->type.
> 
> Signed-off-by: Vansh Choudhary <ch@vnsh.in>

Can we work out some testcases in experimental-tests?

Thanks,
Gao Xiang

