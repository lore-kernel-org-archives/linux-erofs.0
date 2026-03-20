Return-Path: <linux-erofs+bounces-2869-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 203171093168
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Mar 2026 01:41:51 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fcQK94f4kz2xm3;
	Fri, 20 Mar 2026 12:41:49 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773970909;
	cv=none; b=NEl1EhN5ounY6VPis2lRxYyZdNB3MaGwQtx2KpxetYJ/0BM7hRouK//q7+vxwonTJS7nsEJ9Xdj5JH4IzpfNAAWzZ76FJM8LBnHUdF8VTpTE1KCte64LK5Oaf584sL7RHMhf9WofSCpGpSjQDIuoly9S7WVSd+BHm6XYLpYTq8wgn8W8/3bVSRcsPqJwSpC5BTeiRq0SN6PMtA71E+VatrFDjpwnePKLeMdKHH7WN8ttZMVSUrSG6fEo+W5q/O2ko+5sV/Fu0VXXTrJK2YLo8+DobkjEcAbbkpJjjo108jylMEsqQSqDhktSjE8FcSvl0qJCdAmn/XeeabrIw1dBqw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773970909; c=relaxed/relaxed;
	bh=jj0VD1nf+sUWGOHRdCuzFl3CGuJ7BQG1IpgJp7cVxzQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=iVSkWghO+ReFJdadYwee/UUI2DwnJoo1mH9HmJ6omqP6SDLXdc+wuQ6SDjPOTJ5WKAlz6Y88L7atpIJd3M0x4Mx+PE82Aw14zi04CNmmTDGHh8KduVLDmXvmkFm7qoGdotqyv6QGGo7G8Lt1vAO0w+0os7X5W7hUtlXDubIxTZDHF4wNOqS5HoPk36SqZzzn3g7vy5JWLcKvrTgbqu8skIIKhEtiC+gDanTPw6bdpmXRYRlsvvgCq6F+vDqQsp+5wcbBShFuxLKmXlJeshDyyeDa9/WYecsxomJsBx8m9yv/2g9QBtheVzrrrhqBMlrSFVhHA8SynXt4crDBNLuNfg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=eNnzMqLU; dkim-atps=neutral; spf=pass (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=eNnzMqLU;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fcQK846PZz2xly
	for <linux-erofs@lists.ozlabs.org>; Fri, 20 Mar 2026 12:41:47 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773970903; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=jj0VD1nf+sUWGOHRdCuzFl3CGuJ7BQG1IpgJp7cVxzQ=;
	b=eNnzMqLU1SnDC/MAXi1bN0AjCEndr+xA93Xtc1zrgI7vG8g3XDWkkt5tZ/Zh0mbNNkL1yWqATt5K5RdGTlfZRIZTOgJkNKyfPax8gqvWj/ha95Ui63tzRH3htVY8iiY5PPRa4GcQMVHQqZQWcE9L2OaJoLWiF8R3lZ7pi6rvlbs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X.JxI38_1773970901;
Received: from 30.221.131.211(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.JxI38_1773970901 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 20 Mar 2026 09:41:42 +0800
Message-ID: <592df2af-2109-410f-88a3-b774655f11a8@linux.alibaba.com>
Date: Fri, 20 Mar 2026 09:41:41 +0800
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
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Ajay Rajera <newajay.11r@gmail.com>, Vi-shub <smsharma3121@gmail.com>
Cc: linux-erofs@lists.ozlabs.org, yifan@pku.edu.cn
References: <20260319221136.2126-1-smsharma3121@gmail.com>
 <CAMhhD9hbenqz2z2pRQ1EoSNttATsTnW9BZcgFVZ1VPCzAciHiw@mail.gmail.com>
 <0b0ad26c-f462-4274-aaad-6a8e079c0963@linux.alibaba.com>
In-Reply-To: <0b0ad26c-f462-4274-aaad-6a8e079c0963@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/20 09:37, Gao Xiang wrote:
> 
> 
> On 2026/3/20 09:16, Ajay Rajera wrote:
>> Hi Vi-shub,
>> just a review :
>> I think the fix looks correct and it is the right approach but the
>> commit message formatting needs work. The entire description is in the
>> subject line. Per kernel conventions, the subject should be a short
>> one-liner, e.g: erofs-utils: lib: fix QPL job leak on early error
>> paths
>> The detailed explanation (which error paths leak, why, and how the fix
>> works) should go in the commit message body, separated from the
>> subject.
>>
>> So you can resend with the subject/body split fixed? so It will look more clear.
> 
> yes, the commit message is in a mess.

BTW, I don't know who is using the email address
<yifan@pku.edu.cn>, and the recipient doesn't exist.

Here, I want to say, I have to identfy you as another
AI bot.

Thanks,
Gao Xiang

> 
> Thanks,
> Gao Xiang
> 
>> Thanks, Ajay
> 


