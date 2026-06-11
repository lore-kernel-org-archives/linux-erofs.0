Return-Path: <linux-erofs+bounces-3567-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2AA2CD98C6
	for <linux-erofs@archiver.kernel.org>; Thu, 11 Jun 2026 01:40:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gbQM50XG7z2ysW;
	Thu, 11 Jun 2026 11:40:17 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.130
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781142016;
	cv=none; b=l8fyKHDCaCVXwzpH34PLTgprYMvFJMqlHqEHQx2MjYS3qSTESJKbF0RsnASJ+eQUZ50LqQYZMS+pSJAKKl7vy/ZsP4lTYr+LuDX47njUxu2qtiGxdznPc9GH+KWR250lV4VpQtWQ6FhJo0C1jlmi1cCAkLCXshwDghI5JNJ7dJIPjtorz+LFlLtIfV5Q7aoBuy0k1Oz8mLmSsqHrOaxmhxu3fTdhk8uy4YBXnFIHpRbo3/oV6SIcYA4uN01H7zEomEuJatObpUjYtvj7eRpnFXhnIbn186jiN98vztkwOyprhEI63AkOykZCuzWBlFvmuKk0B1l1lIsw9Gcc5Vobkw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781142016; c=relaxed/relaxed;
	bh=RLUkCBZ6DjJynHBl/N1C3d1hqkLNKUzIPyWCGqIcDMk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QTuo6moov+JKmc04Uc6L/8iFW0SdeF43DCxp+O2xAknxIKHHK6a4b+7U0qwi6pmeLnk+BHCucJX0pabN0kQhwkDWgm4sfCi2HQ3Oig3kYQzOb+rzq18+fW/gCJUh/lVepN7Szl9peAudWKB3h/VUFaZ5UtvSyOqtKm3Mpe7RDgzJyugJZ/ZrS089Doomy+JliP6BvdoQS23qHZOYfRBVU9xT4pHzKeO0UnLT72QnzxsC9G/rd6CsYhTXM9qsmY/9W0xOmtVNcStOHElxgTnwpAN27h72y+AHqkZgRf7e6UvWhmLGXz8voQpvH0Nubh+Ferxr9B/nav9FnEe203wqVA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=r2KiRWug; dkim-atps=neutral; spf=pass (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=r2KiRWug;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gbQM25mqbz2y8h
	for <linux-erofs@lists.ozlabs.org>; Thu, 11 Jun 2026 11:40:12 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781142008; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=RLUkCBZ6DjJynHBl/N1C3d1hqkLNKUzIPyWCGqIcDMk=;
	b=r2KiRWugepgXoPKk0qrj65ybEea9FVUi8K+ZurgS0z6q0VOzq+FZ3e05X7DhdcOm0AKRp9K5cxAhhi7a90pYGJ2dLCxQUY6oessfSmO5N5rhFuHY9UUVygZDKhGjgHr4xecEvy6Xb5QUDVfEFF6Z3r/z4/2T/dKjr7rKRdjkwvc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0X4bymhG_1781142006;
Received: from 30.221.131.247(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X4bymhG_1781142006 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 11 Jun 2026 09:40:06 +0800
Message-ID: <62d126e2-fbf6-4ff5-a327-5c8d7b0b59d4@linux.alibaba.com>
Date: Thu, 11 Jun 2026 09:40:04 +0800
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
Subject: Re: Vulnerability Report - 5 findings in erofs-utils
To: Tristan <TristanInSec@gmail.com>, linux-erofs@lists.ozlabs.org
References: <CAA1XrhPMekMqAnRkC-jV9rTsO4LHjzh=kxn6zQKMgBrqfrnp8A@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAA1XrhPMekMqAnRkC-jV9rTsO4LHjzh=kxn6zQKMgBrqfrnp8A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 2026/6/11 05:27, Tristan wrote:
> Hello,
> 
> I am reporting 5 vulnerabilities in erofs-utils across three versions.
> All are triggered by crafted EROFS filesystem images.
> 
> Findings summary:
> 
>    - ZSTD decompression heap OOB read (erofs-utils 8a579d4, CVSS 5.5,
> CWE-125)
>    - u64-to-u32 truncation heap overflow (erofs-utils 1.8.5, CVSS 7.8,
> CWE-190)
>    - Off-by-one heap overflow in fsck path (erofs-utils 1.9.1, CVSS 6.2,
> CWE-193)
>    - Symlink extraction integer overflow (erofs-utils 1.9.1, CVSS 7.8,
> CWE-190)
>    - Uncontrolled recursion in dump.erofs (erofs-utils 1.9.1, CVSS 5.5,
> CWE-674)
> 
> I would appreciate acknowledgement of receipt and CVE assignment.

Although I agree that some issues are obvious issues, but
would you mind provide reproducible images (in gzipped-based64)
at least?

Thanks,
Gao Xiang


> 
> Regards,
> Tristan
> 


