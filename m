Return-Path: <linux-erofs+bounces-4026-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 862FFC53219
	for <linux-erofs@archiver.kernel.org>; Tue, 28 Jul 2026 12:34:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h8Zdl6C4fz2yRl;
	Tue, 28 Jul 2026 22:34:03 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785242043;
	cv=none; b=c5Q9nQ4ousTMus5FL1zsXy/JdKNkLpbI6Ii+w8nt9onRXuJj4iiEv3HLl4/ZhH+0UZj8jSUxYpe98JaygzvOmHvXM85RSn1QZle4Dakc1e/RdbScrLsrLGHYo5JFjhPsxu5a8uBiH7/U9u59HjBNE+xjA0MY2R5lUfJqI2ZWBY/rPgxEuVFjjfQyB3+sG9+NZFkulPQsrKkSfhnXDvHYfrPUhK4HPvOmd24NzCrN066HBXZv/iWSVBEb0/OFRisAImzrKWPLu855MQqkwcuIQhCtEAa+94Vv1KPU7frNiKfsLOT5JLEhyG7VBFSJc54OOvDYokkYk51eZlydxQsPyg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785242043; c=relaxed/relaxed;
	bh=HZYbAcie+5Exfmk84qOueCdd8pPr5SW+ez9Sxtfghyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KbuTa+jcvs7KCZwecQNcg1pVD1nnOYwVqUp2YA/eaMisFrQHJ1cv5Ltwwi03lS1Ij8HeeLfzxK0mCFlC/7J5IzrKtuPVRUtYf7GFpfjBMT8NCesOH/+QYhto47sInJTF7cJVtllcfgFc1WsO45yEH57nKB1XP2lzObcHMpmsgS+rJmNZDizmF94z5Xs6rORlW1fP0o/NI4mWfzqyKYzzRJ0WNfBG4W8V99kQsy5wuLCbPqd7rzAAZYztZmEbJIPexhQDomCMSJX3zBYLvhCcsusNgszbUEpuVUnyN72B4lCKwqvkIPObDTkg4hKki79iSMzP/hpC7C6ncw5duLhwvA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=F+bWeDXP; dkim-atps=neutral; spf=pass (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=F+bWeDXP;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h8Zdj5r90z2xyk
	for <linux-erofs@lists.ozlabs.org>; Tue, 28 Jul 2026 22:34:00 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785242035; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=HZYbAcie+5Exfmk84qOueCdd8pPr5SW+ez9Sxtfghyc=;
	b=F+bWeDXPaFiGx0qxGSqqS3z9tIHgbZUNRqm5gXN8dre3FH3PnwVWTmcIkYffJ2l3Q9UPJ/NWsojcy5b734Wt7Uh0FyNHxe3n1t2wxpImqg7CWMxx27OL0sCwarLw7jpV9zDBqvnwfhnF6fT0lEjvc87Q+WsXLE9AmfBhU9QA7nI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X8-vD6H_1785242032;
Received: from 30.180.139.68(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X8-vD6H_1785242032 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 28 Jul 2026 20:33:53 +0800
Message-ID: <ba39c0d9-1b7a-43d6-9a91-e729cb3a2731@linux.alibaba.com>
Date: Tue, 28 Jul 2026 20:33:52 +0800
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
Subject: Re: [PATCH v4] erofs: accept source file descriptor via fsconfig
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-erofs@lists.ozlabs.org,
 cyphar@cyphar.com, linux-fsdevel@vger.kernel.org
References: <20260717134147.1602735-1-gscrivan@redhat.com>
 <20260722-notnagel-allemal-kampfsport-8fd4e4d98a15@brauner>
 <6d1ac697-d5f8-4952-ba68-27610f17bf3c@linux.alibaba.com>
 <20260723-wickeln-schindel-rotstift-d987d4e9c036@brauner>
 <95a5fc3a-4259-44a7-bb72-8ff35a49a26f@linux.alibaba.com>
 <87mrvckgip.fsf@redhat.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <87mrvckgip.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Giuseppe,

On 2026/7/27 16:01, Giuseppe Scrivano wrote:
> Gao Xiang <hsiangkao@linux.alibaba.com> writes:
> 
>> Hi Christian,
>>
>> On 2026/7/23 22:46, Christian Brauner wrote:
>>>> I'm not quite sure if I catched the point, I think Giuseppe's patch here
>>>> tried to record `file` into `sbi->dif0.file` (which indicates the primary
>>>> "device" later.)
>>>>
>>>> And if `sbi->dif0.file` is set up by erofs_fc_parse_source(),
>>>> erofs_fc_get_tree() will just use `sbi->dif0.file` instead of
>>>> `fc->source` according to this patch.
>>> Oh, so you only do it for file-backed mounts. Do you only allow
>>> regular
>>> files or do you also support block devices with
>>> CONFIG_EROFS_FS_BACKED_BY_FILE?
>>
>> Block devices with CONFIG_EROFS_FS_BACKED_BY_FILE are supported,
>> but with only `fc->source` (not this way.)
>>
>> That is the limitation I see in Giuseppe's patch. I'd hoped
>> bdev-backed mounts could work the same way, but that would require
>> changes to the VFS flow.
>>
>> Since this is a side improvement, I think it's fine as long as
>> it's documented somewhere, and I do hope Giuseppe can at least
>> address the documentation.
> 
> would something like the following be enough?
> 
> diff --git a/Documentation/filesystems/erofs.rst b/Documentation/filesystems/erofs.rst
> index 4230884fb359..768e1d43dfcc 100644
> --- a/Documentation/filesystems/erofs.rst
> +++ b/Documentation/filesystems/erofs.rst
> @@ -139,6 +139,29 @@ inode_share            Enable inode page sharing for this filesystem.  Inodes wi
>                          page cache.
>   ===================    =========================================================
>   
> +File-backed mounts
> +==================
> +
> +When ``CONFIG_EROFS_FS_BACKED_BY_FILE`` is enabled, EROFS can mount filesystem
> +images stored as regular files directly, without requiring a loopback block
> +device.  The source can be specified either by path or by passing an
> +already-opened file descriptor via ``fsconfig(fd, FSCONFIG_SET_FD, "source",
> +NULL, source_fd)``.  Only regular files are accepted; block devices must use


File-backed mounts
==================

When ``CONFIG_EROFS_FS_BACKED_BY_FILE`` is enabled, EROFS file-backed images
can be mounted directly without a loopback block device.  The backing file
can be given either as a path, or as an already-opened file descriptor via
``fsconfig(fd, FSCONFIG_SET_FD, "source", NULL, source_fd)``.

Only regular files are accepted as backing files; to mount an image that
resides on a block device, use the traditional block device mount path
instead.


It's just my own sketch of this; you could just fold this into this patch
with modification (I'm not quite good at English.)

Also it lacks how `fc->source is filled` when source_fd is specified, we
may need to document here as well (and hopefully vfs maintainers can ack
on this so it can be stable.)

> +the standard block device mount path.

> +
> +The backing file content must remain stable for the lifetime of the mount.
> +EROFS never writes to it, but concurrent modifications by other processes lead
> +to undefined behavior.

Yes, I explained to Christian but I don't think it should be included
in this patch, maybe we need to document this as a new section
in a seperate patch later (possibly as a formal security model.)

> +
> +Ioctls
> +======
> +
> +``EROFS_IOC_GET_SOURCE_FD``
> +  Return a read-only file descriptor (``O_CLOEXEC``) for the backing file of a
> +  file-backed mount.  Returns ``-ENOENT`` on block-device-backed mounts.
> +  Requires ``CAP_SYS_ADMIN`` in the initial user namespace (returns ``-EPERM``
> +  otherwise).

I hope document this part in the corresponding patch but I guess we have
to get a consensus between filesystems first.

Thanks,
Gao Xiang

