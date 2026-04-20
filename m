Return-Path: <linux-erofs+bounces-3331-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A673EEA71A4
	for <linux-erofs@archiver.kernel.org>; Mon, 20 Apr 2026 02:57:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fzVXM1wcgz2ySf;
	Mon, 20 Apr 2026 12:57:39 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.130
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1776653859;
	cv=none; b=ENjTLyoDciB3WMPJdNGl7/2TVz0xrtYw2gyROozXGovScaeJY2waAQlxYPwDePIZLXU5h+yvgekJkHOkpLzkSc+1WGmnwAM1uONmbAxXbTOvutPKrrrWB8iqfUIzEwH5ukj+G3/xD35t6gvaitsRSsEqkLUTwmudriO6Od4UqDqGqgvvR/D+gmovHoqLq3r+7x8m4/kFlnYHEoGUZsAZxld/nL4iPVJG7Jla2toiaxzHY75egfj1PP9gVZFKhfkvb/avNGIHjuI1migUVzaJtTmT2w7Lnv7F2fLzFbwiv9qfjbuIeHH7XAu6d+vED05msgRdfDP3zGdYUuz4+KlE0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1776653859; c=relaxed/relaxed;
	bh=N3ooauqtkeSAFzd9PuOWi3TQb556RvJ+NP1D7m2taak=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XsLr1clvJvdCg/qg1jibLZ/QhHWZah6vpQUMUeCf1ybqcMAu8vAs32hsMEYx6XMHOycx7+aiK6QGRpk83+6A3dGFp0yfh0ZQVy3sRm5on2E2jUVU23YiLuhjUE0ajGOntXq408U6A5BFaXjphuOOYEc4QQJ5uoBfJIEsaYChkRcTThC1TIuWFyzq4AODDlB51AQcG6iXlsEfsjtF8hvZ92Wcg6FXLRtM5hzfcxJX7et3XOl3bv0YvFqEm+G4g7qroPFsUUKcah3GeV5TwEscODQm3U9Fwt3I8niM1r/h8Sn5LxzFYnmGeiy8dxdGvhNR/DLnv88TX6jxQ0/MMFamew==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=cqZPkZU7; dkim-atps=neutral; spf=pass (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=cqZPkZU7;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fzVXK4T2Zz2yL8
	for <linux-erofs@lists.ozlabs.org>; Mon, 20 Apr 2026 12:57:36 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776653852; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=N3ooauqtkeSAFzd9PuOWi3TQb556RvJ+NP1D7m2taak=;
	b=cqZPkZU7856zLKo7fhFROKwvRYJlxm1g4TkYYnAoZdYCz7NxEBCiNn6i7Jjzx0i2Bd3W8LYezSN5eg3+II2RDyloMuwl+RTziCTNoP0P3c9H4VMuxa+ZH4IB0kGP9K5WIIr6gXm5J1I1kVxRkhQkl8Hn2wArEDBQpscvHY7qYAo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R501e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X1GlyYT_1776653850;
Received: from 30.221.130.173(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X1GlyYT_1776653850 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Apr 2026 10:57:31 +0800
Message-ID: <a346d73c-0c46-451c-b97c-a89c73bb8ab4@linux.alibaba.com>
Date: Mon, 20 Apr 2026 10:57:29 +0800
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
Subject: Re: [PATCH 2/2] erofs-utils: libzstd: fix undefined behavior shift in
 setdictsize
To: Nithurshen <nithurshen.dev@gmail.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org
References: <00f14a87-6914-4e4a-96f1-6d0f911edc4d@linux.alibaba.com>
 <20260420025023.11802-1-nithurshen.dev@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260420025023.11802-1-nithurshen.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/4/20 10:50, Nithurshen wrote:
> Hi Xiang,
> 
> I do agree that `pclustersize_max` is always greater than 0 and
> `ondisk_extradevs` is at max 65535.
> 
> My intent was to look at these functions as independent blocks.
> Even though the current upstream callers provide safe inputs, I
> wanted to make them robust against any undefined behavior in case
> they are reused in the future.

They won't be reused in any case like this.

> 
> Thanks,
> Nithurshen
> 
> Regards,
> Nithurshen


