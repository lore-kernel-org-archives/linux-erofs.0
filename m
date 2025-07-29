Return-Path: <linux-erofs+bounces-714-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E94C3C83F26
	for <linux-erofs@archiver.kernel.org>; Tue, 29 Jul 2025 03:05:17 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4brgFS3S5Bz3064;
	Tue, 29 Jul 2025 13:05:16 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1753758316;
	cv=none; b=gYWlswuRkagnI/jaPDRRUhVnTj2u1GewqxdPZkjz8Qk48Ld23HDDgeRRFpKcXz+0XQvEnDR+OaktiFSrK8aZrd3MLnalrBrMRiMCwaNCD8UnLgynVoo7vpvy1p6wEPiQIvsHKpmogXoiuRQoONYS1B8wwB4bChtQ78/hXGyJvQt30qX1CNoAZVtMzz9/UINOg7vlUjQNVjMPaNoA+fRg7VP1aC2wEJFrMtOxS48NrOZyOqb83F1IJxM04EWIsEH/kee+DcqQpqH5xEv3FtjOjX5uiOwYVExEWKMmunTJI939SG8ilpsWT/i6Lf1FHMn3bHv7ho36zq1GXIIbbwSPXw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1753758316; c=relaxed/relaxed;
	bh=x2+gTP4QsoLIGG6pxYP6dnx1USzMnwdCSmpmAc+c4GM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Z6BqQoIcgl7Q3ld2imL2Ds1EeohBzdknimKtmxbJyNWj/5gfkuU/7ey/zGBb3I5opjSovv1mMnxAK6rtXNGTU3725SFqj/k6cfkioV2JD7LOHu9sfXixc0ufwgk8r2RsBsaCyyYq/VNra61Fm3XW/JvKzJtKsngEDod8rWJLu1GUyQGA7ePrhJ2Iw2btdhshQTl8xtD4ulzI7a5BtcMeCr5f2aHGez3lIiC8sjc3tzN6VYVo2MJzBvS8nw2FPQDxR+huRNTIreeQ83lV2nxT9t47Ne0CWxfmXp5/+MV4TbtAbwvnCKxLSoK2i5cMrzMoUvtT6m/4pak32cgw7zepKA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=PmREMnAe; dkim-atps=neutral; spf=pass (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=PmREMnAe;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4brgFP6Dwyz2xCd
	for <linux-erofs@lists.ozlabs.org>; Tue, 29 Jul 2025 13:05:12 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753758307; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=x2+gTP4QsoLIGG6pxYP6dnx1USzMnwdCSmpmAc+c4GM=;
	b=PmREMnAeyRfqjr9biqWBJuZlGmL4oP9R1ahDpEZY4eukKcqoOeUCgI8ATxJ52j11/wXT8L4hh9Z9GXS5FanKkYiMQcDoH9I2gp0Y5B287ZKVRciacjsMrOMeZUkNbRCt1Q8IKAc0SQuYYnsPmAEqLMAtoF6zsgwtccgkurCXzJ8=
Received: from 30.221.131.110(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WkOBKnd_1753758305 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 29 Jul 2025 11:05:05 +0800
Message-ID: <ab965624-949a-454c-a4d0-2edb7d9265bc@linux.alibaba.com>
Date: Tue, 29 Jul 2025 11:05:04 +0800
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
Subject: Re: [PATCH v1] erofs: Fallback to normal access if DAX is not
 supported on extra device
To: Hongbo Li <lihongbo22@huawei.com>, linux-erofs@lists.ozlabs.org
References: <20250728014920.1658799-2-Yuezhang.Mo@sony.com>
 <78fe79f9-627c-4f8b-98c6-f01be34871d7@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <78fe79f9-627c-4f8b-98c6-f01be34871d7@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Hongbo,

On 2025/7/28 18:50, Hongbo Li wrote:
> 

...

>> -        } else if (sbi->blkszbits != PAGE_SHIFT) {
>> -            errorfc(fc, "unsupported blocksize for DAX");
>> -            clear_opt(&sbi->opt, DAX_ALWAYS);
>> -        }
>> +    if (test_opt(&sbi->opt, DAX_ALWAYS) && sbi->blkszbits != PAGE_SHIFT) {
>> +        errorfc(fc, "unsupported blocksize for DAX");
> 
> How about using the info log? Can we consider using infofc in this case?

I think you suggestion sounds better, but how about
sending to the original author?

Thanks,
Gao Xiang

