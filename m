Return-Path: <linux-erofs+bounces-2678-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC7F0105A58D
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Mar 2026 11:40:22 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fWlzT2G2Wz3cFN;
	Thu, 12 Mar 2026 22:40:21 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.97
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773315621;
	cv=none; b=TTSUG69igGqc9T+ZxrnDFmW9N2MvXuYGQps0+Gqf9EyF7ZPLbIZCgFNG3dcicEXztlAkgGTRcmPYLE2bh5gpSV511K4lTLNG4llnG2BP/CUY4RveVvCxNNFqk0qt4WDKghK04OtcJZI8H4wdQtVvHvZ+zmPOviFYHlhW/3uJXTM4FQzy/RORPtOAkJTzgov+EfBjnBoldpKe6iu86SI+DwuT6zAHQi4I4+JKhssVrpZKCO5G73A1REesyJXO0mG4lE/r/lObeGuomCG1XJejgnqFokjZmONA1IqnqEYKu8H/DUNbhB0sG6ud05+63i3HJ/0wZ1F683DRRW6joBtRcA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773315621; c=relaxed/relaxed;
	bh=LH56+nmGZrs81DjXzbJd/EaRu8YEqr6QeSJjyfEc+QQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RW7iYA9v2YW+d9DHackdHT8a56aAmeeh8Fcny+/Ybf+CGzezE/odmMEdhzg2lbwZDKRi6gsi7YpvKWkeTo2MbHChHPhS2IZKTGmWWybyoWQKuNYQy2gq3v+VGkdtUgRO4uYuJUcZAuO2SDWFUPj6NhH+Kk1j9w8/MalmpRiODEnSCKWIiqm2gE5imKH+exYHztd/2IraeCLbk/EXEIoSN1nedC/p7DVDCVFI9h6IempNHpylDwe4BGTCipvtItEeYZ0n0Z/6+AQ12jEUwCqLLQV7ALNtTJ4AD+rq18o/1YIH8+I9JzCpvAwnTaCkqPAnvcSJahyaG42b8YU4flbeTg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=mqW94hOu; dkim-atps=neutral; spf=pass (client-ip=115.124.30.97; helo=out30-97.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=mqW94hOu;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.97; helo=out30-97.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fWlzQ0YtGz3cCJ
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Mar 2026 22:40:15 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773315610; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=LH56+nmGZrs81DjXzbJd/EaRu8YEqr6QeSJjyfEc+QQ=;
	b=mqW94hOuqddyeEDLgVN8q3kocvHNRAkwezwwoiI7y2yvqTaoBLBznvZjpguHXkW5eOmzvDSGN/SyhtqFMxs7PmWS/v7islXoWm309KQK+jbambdx+d5XvYZEPJl7DJOG47+oaVx66jvv5poiDfcpVzgqwE/eK5JQcTPjBRXA+bM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X-oZ3Mo_1773315608;
Received: from 30.170.14.2(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X-oZ3Mo_1773315608 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 12 Mar 2026 19:40:09 +0800
Message-ID: <66946454-25ab-4550-84af-53bdecac839d@linux.alibaba.com>
Date: Thu, 12 Mar 2026 19:40:07 +0800
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
Subject: Re: [PATCH] mkfs: support block map for blob devices
To: Nithurshen Karthikeyan <nithurshen.dev@gmail.com>,
 "zhaoyifan (H)" <zhaoyifan28@huawei.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org
References: <20260307062810.19862-1-nithurshen.dev@gmail.com>
 <b9387ac5-e717-4e9c-910f-5b218d177e64@huawei.com>
 <CANRYsKgoA9pMsDnBRnLgpY7ydYcuq8FxEhs+NCw9_p2ABjsMnA@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CANRYsKgoA9pMsDnBRnLgpY7ydYcuq8FxEhs+NCw9_p2ABjsMnA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/3/12 17:56, Nithurshen Karthikeyan wrote:
> Hi Yifan Zhao,
> 
> On Mon, Mar 9, 2026 at 5:08 PM zhaoyifan (H) <zhaoyifan28@huawei.com> wrote:
>> not reset m_deviceid. Could you help also fix this? If you are
>> interested please also add related
>>
>> testcases in erofs/erofsnightly repo.
> 
> I have opened PR #7 in erofs/erofsnightly repo.
> https://github.com/erofs/erofsnightly/pull/7

Such test cases should be landed in experimental-tests
instead rather than integration tests (erofsnightly).

I will check out later, busying in other stuffs.

Thanks,
Gao Xiang

> 
> Thanks and regards,
> Nithurshen
> 


