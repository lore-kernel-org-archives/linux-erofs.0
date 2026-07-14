Return-Path: <linux-erofs+bounces-3890-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3E68C43458
	for <linux-erofs@archiver.kernel.org>; Tue, 14 Jul 2026 01:57:11 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gzj9L2MSwz2yfD;
	Tue, 14 Jul 2026 11:57:10 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1783994230;
	cv=none; b=FE3iZt3g7Kd3nmX1+TTtUbGKDOrEIQ2WvMQ5laPEc3goAyWktNPQkCKN2H/qB2iWauAKfSZKrv1m1yoaBloX17xYyaBZ3XL7soKCl4/ZxxXH78FFz7XVjX7NbLY9a4Gb2NIN5fCkSllepUiPzjQVDLjbjLakRHSiEqJooNsT2iKvgCBOU6s14YqWUbeMtmvMtMxqZZ4/RxFyjiy/qi3bCots86pXsf3KUyLkFnNorj6d0jRHZ2Aj1h/jWKfL6KzZktit3xth0NzHL5pPDF6SrYLlsMcoKH+CEzn5P/QUurlB4Lk8rfU1FOmWLOZLFTWTDpUyi5pCI1L9//OJ3OpNww==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1783994230; c=relaxed/relaxed;
	bh=G7GF+Y+GERuMT/ZqchPMOeUIcvNKk5M2ioI0NUjyKDw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JgTMwCwzh02rAoRcwgQqgj0Oa53y75V2k7eMWQqEkmp7dPxLd6Nq0o+/G1FfQDYWiJSPVu86cIc9yIoY/v+eW94sKibim+Y+fgIz0F5QgpRiVgG5j51a0ls2QqL02K2wLGHnjalgVSrlbE/7UKeE29tQ5TwpYUjGT5KOrQRAUDYuZV9KwfZGqh/O+qtzhjKeerDMzIVxnj0+btd5JkITg3jLezZe4yAduBEEE2UDBLDwVaKIN+nNTZp5sOgqji8yQQBwG8CoODjq7rwyZ7bzQujgcggQ/uPaCB5vw3oH3oeQ3vj9PT+J3kaj07v7IBJkykQ0rBmh8whajYqjN8S4Lw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Jc+Ehqnp; dkim-atps=neutral; spf=pass (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Jc+Ehqnp;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gzj9J2Vr6z2yYq
	for <linux-erofs@lists.ozlabs.org>; Tue, 14 Jul 2026 11:57:06 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783994222; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=G7GF+Y+GERuMT/ZqchPMOeUIcvNKk5M2ioI0NUjyKDw=;
	b=Jc+EhqnpSdfA53nA6Nix6uJNRvMWdbg3xvxjpddx/wZO6uUxV4MwJnKhB80glOF6k/igSjk+2DIKzhlHr9cW5vXQuvP/2K6U/8/XF+2Xy6NS4Cz5kkb7/xo88YsCP+zGs8OV5fe/OMR6Xo2/YiM5u4ie2+k3eFrHjbLOo/40jLI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X72OrGi_1783994218;
Received: from 30.221.132.65(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X72OrGi_1783994218 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Jul 2026 09:56:58 +0800
Message-ID: <ba9cf493-45c8-45e8-9e21-9731ec492030@linux.alibaba.com>
Date: Tue, 14 Jul 2026 09:56:57 +0800
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
Subject: Re: [PATCH v2] erofs: accept source file descriptor via fsconfig
To: Aleksa Sarai <cyphar@cyphar.com>, Giuseppe Scrivano
 <gscrivan@redhat.com>, Christian Brauner <brauner@kernel.org>
Cc: linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org
References: <20260711071137.4130824-1-gscrivan@redhat.com>
 <2026-07-13-dandy-better-exposure-wager-9hBmfv@cyphar.com>
 <871pd748kh.fsf@redhat.com>
 <2026-07-13-chief-single-carnival-graders-7dI4ue@cyphar.com>
 <87wluz2nnc.fsf@redhat.com>
 <2026-07-14-drafty-folded-woes-volumes-Z93P4V@cyphar.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <2026-07-14-drafty-folded-woes-volumes-Z93P4V@cyphar.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/7/14 08:49, Aleksa Sarai wrote:
> On 2026-07-13, Giuseppe Scrivano <gscrivan@redhat.com> wrote:
>> thanks for the hints.
>>
>> I'll prepare a v3 if you are fine with the version below:
> 
> No worries, and this seems more reasonable at a first glance.
> 
>> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
>> index 86fa5c6a0c70..72c85cc53085 100644
>> --- a/fs/erofs/super.c
>> +++ b/fs/erofs/super.c
> ...
>> @@ -437,6 +439,38 @@ static bool erofs_fc_set_dax_mode(struct fs_context *fc, unsigned int mode)
>>   	return false;
>>   }
>>   
>> +static int erofs_fc_parse_source(struct fs_context *fc,
>> +				 struct fs_parameter *param)
>> +{
>> +	struct erofs_sb_info *sbi = fc->s_fs_info;
>> +
>> +	if (fc->source || sbi->dif0.file)
>> +		return invalf(fc, "Multiple sources");
>> +
>> +	switch (param->type) {
>> +	case fs_value_is_string:
>> +		fc->source = param->string;
>> +		param->string = NULL;
>> +		return 0;
>> +	case fs_value_is_file: {
>> +		char *buf, *p;
>> +
>> +		sbi->dif0.file = get_file(param->file);
> 
> A very minor nit, but you can actually steal the file reference here
> with
> 
> 		sbi->dif0.file = no_free_ptr(param->file);
> 
> A few other places do this. (You'll also need to change the param->file
> reference below.)
> 
>> +		buf = kmalloc(PATH_MAX, GFP_KERNEL);
>> +		if (!buf)
>> +			return -ENOMEM;
>> +		p = file_path(param->file, buf, PATH_MAX);
>> +		fc->source = kstrdup(IS_ERR(p) ? "(fd)" : p, GFP_KERNEL);
> 
> I think that /proc/self/fd/%d would be a more useful name for debugging
> if file_path() fails (not that it is really possible here AFAICS). But
> I'm not really too fussed.

Not quite sure if we should get in agreement with the format of this
one in advance (IOWs, users use source_fd and how fc->source looks like;
since other fses may follow the same practice if source_fd becomes common
later) since it's a user-visible field and I believe we shouldn't treat
this one as a dontcare field as some pseudo fses (since those fses don't
rely on `fc->source` by design but typically EROFS can rely on.)

I hope Christian and others could share move thought on this part too
before I land this feature for the next cycle.

Thanks,
Gao Xiang


> 


