Return-Path: <linux-erofs+bounces-2868-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B227B1093168
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Mar 2026 01:37:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fcQDG18Lcz2xm3;
	Fri, 20 Mar 2026 12:37:34 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773970654;
	cv=none; b=YjVRnVawke5UrU0Z9xN2ZRNCONMjvortRTY+lQ9uqtA8cjDIX8zVercMrnVrPfYEZPjmn5cWG9540gh+vl/s55HggQatnvCc7OESE0zejEuO9rFWGlbZk3zyDvPMasiOABYHoc8e835Tn3PghJgIoWEy52bb3BjkQ71Wycz2GlFBVrJBQ2BXEmkKwN4MMbqBrZBZ/UPpusufQGdgQlOY/D/iepIn7/YKutuh0ieZ/gKvenMNqjk6CnV4ymDK1UB9Hx5RBTMh+DtOyPuWGT4utAqvWethp+coYCeghAi9TBYmk1dpNtoiheeQmN09gdS+E7W+rz7twLYsS5DyArve1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773970654; c=relaxed/relaxed;
	bh=FVFrt7jv/SC6g1rr9zjJ8IpL06ZSy5Zu1F83NBLNHEE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bz+iGYsHSQiIM9SZupSLbfSsJJa0AOdkCmW+cDEcbnkNz6N2r6zN9R35uuOVVdAssTX6tSKiArfh9CA1eWC4cXyw0rB6I43adMTVs0RbdsBkGVTcND45+4Lcvqt4mzlekKd4UGRbad4E1Iw44c4z2DSatPeUt1RvmOWpTBbR0PGyCUh1f+NbRzy7BN/f1HiashG+agFNtvN+TNsv1QQc7bHkK6gsjE/2gbQFAuw2oCIzLaRRlqB61EEzPdaJg2IwplGYigTfXwW4T8AY3FWb7YmaZycmZGGg9QQdVq9FS+Kw+1BjsrBYL/Sir0+6nuUD5XqEfdXMacPMB2iHii6pZA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=u6DQBSTr; dkim-atps=neutral; spf=pass (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=u6DQBSTr;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fcQDC5t6Cz2xly
	for <linux-erofs@lists.ozlabs.org>; Fri, 20 Mar 2026 12:37:29 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773970644; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=FVFrt7jv/SC6g1rr9zjJ8IpL06ZSy5Zu1F83NBLNHEE=;
	b=u6DQBSTr/umiOBYmuRD3hqwMH0c9+E04ajQEcEBIOoKkBWTpwxEQHakqj1i25eZFP2mzpChRxCb2AU4211bus1tXKuxLY5WG5p8zBp6EGpFA8Tlf6pCECyVAUZcZG/TmyAf39SonQzTuwsGyOekOMhbu90QLWxjbvx/PYiBxY7w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X.JxGgx_1773970641;
Received: from 30.221.131.211(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.JxGgx_1773970641 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 20 Mar 2026 09:37:22 +0800
Message-ID: <0b0ad26c-f462-4274-aaad-6a8e079c0963@linux.alibaba.com>
Date: Fri, 20 Mar 2026 09:37:21 +0800
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
Subject: Re: [PATCH] erofs-utils: lib: fix QPL job leak on early error paths
 in z_erofs_decompress_qpl() After z_erofs_qpl_get_job() succeeds, two
 early-return error paths bypass z_erofs_qpl_put_job(), leaking the QPL job
 handle: - Line 200: return -EFSCORRUPTED (when inputmargin >= inputsize) -
 Line 205: return -ENOMEM (when malloc fails for decodedskip buffer) Fix by
 replacing the bare returns with goto out_inflate_end, which already handles
 both z_erofs_qpl_put_job() and free(buff).
To: Ajay Rajera <newajay.11r@gmail.com>, Vi-shub <smsharma3121@gmail.com>
Cc: linux-erofs@lists.ozlabs.org, yifan@pku.edu.cn
References: <20260319221136.2126-1-smsharma3121@gmail.com>
 <CAMhhD9hbenqz2z2pRQ1EoSNttATsTnW9BZcgFVZ1VPCzAciHiw@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAMhhD9hbenqz2z2pRQ1EoSNttATsTnW9BZcgFVZ1VPCzAciHiw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/20 09:16, Ajay Rajera wrote:
> Hi Vi-shub,
> just a review :
> I think the fix looks correct and it is the right approach but the
> commit message formatting needs work. The entire description is in the
> subject line. Per kernel conventions, the subject should be a short
> one-liner, e.g: erofs-utils: lib: fix QPL job leak on early error
> paths
> The detailed explanation (which error paths leak, why, and how the fix
> works) should go in the commit message body, separated from the
> subject.
> 
> So you can resend with the subject/body split fixed? so It will look more clear.

yes, the commit message is in a mess.

Thanks,
Gao Xiang

> Thanks, Ajay


