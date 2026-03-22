Return-Path: <linux-erofs+bounces-2933-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8344BFC72AE
	for <linux-erofs@archiver.kernel.org>; Sun, 22 Mar 2026 09:48:55 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fds2G0YlGz2ySb;
	Sun, 22 Mar 2026 20:48:54 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774172933;
	cv=none; b=JejlUHbtSsASVz4AOGN2jDR8UItYtGpoKL0cVxAtf90wNarxexnnbeRgCjF6Os8vgJ3vtfLI9VDY6C5v5Hv9nCoEij9Rp85J1qJ/d1DEjc6W6ehaNnRIpknOpNF+iv3DTrdWE3KU4P2/0++eLXcf9yBeORPi5OuibCdc/RuoTOIpLrASuRovOyyoEACYhXCN3qXe7qu/jVFqlHNRFEd2Vgol23RFcF0Kw6T4rAG3d6ikyAxwpqLgmViljEk15F4JDmiC/NzakyFY/fvn8dO2+9V/T81R7Lhvn1B+hZqCw7ifI2qhD6SDfTx9aW5SjRuLIhGvFNXGXL0Oxw9vBqW5YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774172933; c=relaxed/relaxed;
	bh=jmIV/I3RU0BNTazfD2nPRNJTwZ4Qvc+YYC75syLp1Qk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=icetnQUeIeCu0Cg4hbMbLRKCu1x9P+NGJzWLjEMIFXpXb3YcfgtURJcZ0mO7zyGPAJ5KkASWbzfNbamP+D+c/OJVySE4LdTRXjn1MBRbEIG6gmUmg9hfIXCMD/v5KZH9wzs+Q6prx9fzKoNB8Z5qfTKG34TAo0huo8UdGYeFzqfwtngdctoQ6bXm8RGhuA0clip08mHuvj/oB10Sn97fVeOQKY5mo6tb+meOnfiPKHJmhzwgr8pPsAZLOGHRVmjyi7BGppC/UoaY8ZUWeO3F6eGYec3qupfRzzcUbu68jKNlzVA1ZNWx6KPSlxSN5USVz9DEJBblrtSoOJFcx2G3cw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ecEGxBX1; dkim-atps=neutral; spf=pass (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ecEGxBX1;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fds2C1Wyvz2xlr
	for <linux-erofs@lists.ozlabs.org>; Sun, 22 Mar 2026 20:48:49 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774172919; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jmIV/I3RU0BNTazfD2nPRNJTwZ4Qvc+YYC75syLp1Qk=;
	b=ecEGxBX1oxUbSmrFQh/FQDgao+Xre7gM5vuZP2mKUFCWeo98BXbWr8t9UGFnk5bdviWwhrAOqvBIhfCKXnTJUV5tvbYwpoDPfyPQptgCt5qAlWMhLTP+r/xLQKWEMzzCqPM6YXikuKVLawfn5h6QgQvJC+BR7R9LVNOXHcZiwxc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X.QhfTE_1774172917;
Received: from 30.41.54.139(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.QhfTE_1774172917 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 22 Mar 2026 17:48:38 +0800
Message-ID: <aff41e7b-dc81-4d2d-9298-c44bfb487936@linux.alibaba.com>
Date: Sun, 22 Mar 2026 17:48:37 +0800
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
Subject: Re: [PATCH] fsck: add --workers option to configure worker threads
To: Utkal Singh <singhutkal015@gmail.com>,
 Nithurshen <nithurshen.dev@gmail.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org
References: <20260322083620.19933-1-nithurshen.dev@gmail.com>
 <20260322085729.24511-1-nithurshen.dev@gmail.com>
 <CAGSu4WPJ2nvYRUHT-JiPx00RLAmwZS-AzPfzWxn4oiAqLb3zHg@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAGSu4WPJ2nvYRUHT-JiPx00RLAmwZS-AzPfzWxn4oiAqLb3zHg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/3/22 17:31, Utkal Singh wrote:
> Hi Nithurshen,
> 
> Thanks for testing the patch and for the detailed feedback.
> 
> You're right about the strtoul() wrap-around on 32-bit systems — I'll
> switch to strtol() and add explicit error reporting in v2.
> 
> Regarding the design concern: I agree that landing just the CLI
> portion without wiring it to the workqueue may be premature. I'll
> hold off on v2 until we hear from Gao Xiang on whether this should
> wait for the broader multi-threaded fsck design.

This patch is simply not needed as an individual patch.

> 
> Thanks,
> Utkal
> 
> On Sun, 22 Mar 2026 at 14:27, Nithurshen <nithurshen.dev@gmail.com> wrote:
> 
>> As you know, currently decompression process in fsck.erofs is currently
>> strictly single threaded. In fsck/main.c, erofs_verify_inode_data
>> still processes blocks synchronously via a standard while loop.
>> Without wiring this flag to the workqueue engine in lib/workqueue.c,
>> the option doesn't currently change the tool's behavior.
>>
>> And as you know "Multi-threaded Decompression Support in fsck.erofs"
>> is actually an official GSoC 2026 project idea and the project will
>> likely involve a comprehensive design of the parallelized
>> architecture, landing just the --workers CLI portion now might be
>> premature or conflict with the eventual design chosen by the GSoC
>> contributor.
>>
>> I'd suggest reaching out to the mentors on the list to see if they
>> want to hold off on this patch until the GSoC project kicks off.
>> Also, if you do send a v2, switching to strtol() would be safer to
>> avoid potential -1 wrap-around issues on 32-bit systems.
>>
>> Best,
>> Nithurshen
>>
> 


