Return-Path: <linux-erofs+bounces-3933-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7369C44514
	for <linux-erofs@archiver.kernel.org>; Fri, 17 Jul 2026 08:37:42 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h1jw46ZwXz3brV;
	Fri, 17 Jul 2026 18:37:40 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784277460;
	cv=none; b=g82NHrK6ngpAq13U5pA0Da1c+e/dJvoP722dfSohvBgq+gWEGanz58IOD+CfMGrX32YCh7xmeFVnjVtYg5ABEm2mkUxmnBBjs6FQR1egwZaBwEb2locA+sqDdrDXPjLzSw7yHbNP1jUnFgU2obAkcPed9SMHEHUwUbb/FsJ9zQUorjH/mL+DzY/Ug+mF7ppZAyVjfVI5gQqyM9RoCht/pty4aNZaoGHKuGfKpUmTezGZkyHZ+pvanBgq/ckAErMozCdCWRxeSIpxBBwIO4y7siAmvSXEuhbxfm0wTff+oS29wO2dSqozEbWNXOkp/87Us6pdeXsOxu1Eaeovd1/fxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784277460; c=relaxed/relaxed;
	bh=46zEzh7V3f0seR05X4wVMTBb1YImbCc49sRB+nWpCh0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k/9oV5xp9VdAue8NC3IZU7EiOTx16J23nuRqPS4vBJ2T6SZ/qSpGUU1VvrycYVSwNxmDZSMN00LJCH3WuVbct7ceCJb5TQder9BeSE5XHWPR+vyvWUO+rRujRLC4ySa8eebVdJoFLOrp8UManIM8/1xUCHJidN36w05LNkHeC/jewrHHRjpP9DGI+wB/KOMXLADPORGL9k0z+k/Ii+SWYeE3e2jSp93PxR3is8iM9elYkLTCHVgXtrkCCiwdUcGrP/fmCpQtCVJZvNekEKcbKafUpnOfebnKuoTWErkaC6yt6ZRzy5gdU7lY3ozgL0LqjoZ6zs77ZhPVzVCJxfId/g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=jSq/ipY/; dkim-atps=neutral; spf=pass (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=jSq/ipY/;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h1jw26J0cz2yZf
	for <linux-erofs@lists.ozlabs.org>; Fri, 17 Jul 2026 18:37:36 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784277452; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=46zEzh7V3f0seR05X4wVMTBb1YImbCc49sRB+nWpCh0=;
	b=jSq/ipY/MgFzydlI56afA4S75CnSync6wTJITnHyYfyZmPU+CFttbFZ2fwJvoxrZfYk6Jav2CT6xTeCFg/e7jTaDmUNfqi3x4/vvaEcjNxjfdJxl2VrssrAldwQppA1sNFsIy9grqyK3GIkEK0+fMq1Apub0ep7ct5WlhxyqD6M=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X7GkPe2_1784277449;
Received: from 30.221.133.5(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X7GkPe2_1784277449 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 17 Jul 2026 16:37:29 +0800
Message-ID: <5f5e668f-c371-4b8a-9ca3-91aa8fa10fbf@linux.alibaba.com>
Date: Fri, 17 Jul 2026 16:37:27 +0800
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
Subject: Re: [PATCH v3] erofs: accept source file descriptor via fsconfig
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: linux-erofs@lists.ozlabs.org, cyphar@cyphar.com,
 linux-fsdevel@vger.kernel.org
References: <20260714154917.489993-1-gscrivan@redhat.com>
 <a3ee4538-6273-4d25-90d0-8dbaac092a38@linux.alibaba.com>
 <87cxwm2f6z.fsf@redhat.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <87cxwm2f6z.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/7/17 16:28, Giuseppe Scrivano wrote:
> Gao Xiang <hsiangkao@linux.alibaba.com> writes:
> 
>> Hi Giuseppe,
>>
>> On 2026/7/14 23:48, Giuseppe Scrivano wrote:
>>> Allow userspace to pass an already-opened file descriptor as the mount
>>> source instead of a path string.  This is useful for tools that already
>>> hold an fd to the image, such as composefs reusing an existing erofs
>>> backing file.
>>> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
>>
>> Use the current erofs-utils testsuite, the following tests seems skipped incorrectly.
>>
>> [Error 22] Invalid argument
>> SKIP: erofs/008
>> [Error 22] Invalid argument
>> SKIP: erofs/009
>> [Error 22] Invalid argument
>> SKIP: erofs/010
>> [Error 22] Invalid argument
>> SKIP: erofs/011
>>
>> [Error 22] Invalid argument
>> SKIP: erofs/017
>> [Error 22] Invalid argument
>> SKIP: erofs/018
>>
>> And the kernel message shows:
>> [  116.477816] erofs: source is unsupported
>> ...
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git -b experimental-tests
>> $ sudo make check
>>
>> Thanks,
>> Gao Xiang
> 
> it seems to be caused by the different error returned by erofs_fc_get_tree.
> 
> Would you be fine if I amend this on top of v3?

I think you could just send out the diff from the baseline
since it might be harder to follow an incremental diff here.

But anyway, new versions are always welcome, I will play
with them when I am availble.

Thanks,
Gao Xiang

> 
> Thanks,
> Giuseppe

