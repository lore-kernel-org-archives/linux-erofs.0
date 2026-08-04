Return-Path: <linux-erofs+bounces-4106-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D5D8C55172
	for <linux-erofs@archiver.kernel.org>; Tue,  4 Aug 2026 06:06:21 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDjj807VMz2yYs;
	Tue, 04 Aug 2026 16:06:20 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785823579;
	cv=none; b=FRUc+Q8nx4QFiJ7C2nVpC7Xj3I4gJfduWJcI5HSjfuRP4Lvki53fpjqc1ZCK6fnVjtOCvajivEZtkA8b+IpPk2OxArC54iVJOPCpe54E2TQtg9uWB3CLN00UDwnr146sT0K2Cvn/bC/q7wSk+pZTy02EBdD8BmusfbV7lVVemdRQWI32K4X75bXzU9N8QBlk7yw7aMDWPDhRM3dhFX6yBzgKaz1Nc3WktwrQ8OcTplERE07bSaQFqc0zTtxTFFuG7MkMRPpx2OXOGPsUdDr+Xx7N6D4YYlSKeCpwvnSTVLsMrr4DD1DW5giPJHwpc5H9RolCVGIWpUUjPmwfvoNEfg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785823579; c=relaxed/relaxed;
	bh=SnxDrBsLPvJACqaRUnF7SjpZdbz+YqCUV9y4Py+NEVI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KwCtXHQUpsEOl9X+SGBE6FHZH21z7mQ1631FTol8+4uKETLDUC4gswLDbEu4O3LXONArfGcTx0tEgBb1recb316Y8cplOy4b3KvxCUJq8eBvv4W6Hh7ytqcjxo0mcsIaHonmPr3QpEffdhK7lVJ5Mt2J9TDHXJoBMptbatRv5CYtr1N/fhVIfPwx/RhIToy8JxFPoRHv763/Pl752+GJjLAwLrKahRbDqld3T4o1PSeLkOMW2+T6hj1OUVmxlgMUdd6DbgsaFJ5+1HyA8gDTr5O2wrmY8rq33Jg/5tfTwRGLo1czObuQJMmVwich32Fi+Rx6v4NP09HQQ8BoUqpKjg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CYd3WBjY; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CYd3WBjY; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CYd3WBjY;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CYd3WBjY;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hDjj70yHBz2y1Y
	for <linux-erofs@lists.ozlabs.org>; Tue, 04 Aug 2026 16:06:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785823576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SnxDrBsLPvJACqaRUnF7SjpZdbz+YqCUV9y4Py+NEVI=;
	b=CYd3WBjYChTfpCCA49qDpLRP4i22Fto16Uu3FnR2Vs+8USDdGrT1o5M8q+OM2VLhH0VwOT
	PR7RjvLmIANr201w33O08nNYVqCKM2MLPzuKI2tPmIVe3PhfZzThTk40IHlHmbL7X8vfO3
	Dh153QbIzROg4tS9QhmY7wXqN84bmMs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785823576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SnxDrBsLPvJACqaRUnF7SjpZdbz+YqCUV9y4Py+NEVI=;
	b=CYd3WBjYChTfpCCA49qDpLRP4i22Fto16Uu3FnR2Vs+8USDdGrT1o5M8q+OM2VLhH0VwOT
	PR7RjvLmIANr201w33O08nNYVqCKM2MLPzuKI2tPmIVe3PhfZzThTk40IHlHmbL7X8vfO3
	Dh153QbIzROg4tS9QhmY7wXqN84bmMs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-630-SOmHNtbFM4yRBdILl8uKlQ-1; Tue,
 04 Aug 2026 02:06:10 -0400
X-MC-Unique: SOmHNtbFM4yRBdILl8uKlQ-1
X-Mimecast-MFC-AGG-ID: SOmHNtbFM4yRBdILl8uKlQ_1785823569
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3D01619560AE;
	Tue,  4 Aug 2026 06:06:09 +0000 (UTC)
Received: from localhost (unknown [10.44.48.84])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 06132300019F;
	Tue,  4 Aug 2026 06:06:07 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: Chao Yu <chao@kernel.org>
Cc: linux-erofs@lists.ozlabs.org,  cyphar@cyphar.com,
  hsiangkao@linux.alibaba.com,  linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5] erofs: accept source file descriptor via fsconfig
In-Reply-To: <anEmNQWJzo-osec6@XiangdeMacBook-Pro.local> (Gao Xiang's message
	of "Tue, 4 Aug 2026 07:37:25 +0800")
References: <20260728160619.853924-1-gscrivan@redhat.com>
	<366a9c6b-ec56-4cdf-b373-22a3cd8c9beb@kernel.org>
	<874ihbxviy.fsf@redhat.com>
	<anEmNQWJzo-osec6@XiangdeMacBook-Pro.local>
Date: Tue, 04 Aug 2026 08:06:06 +0200
Message-ID: <87zez2whbl.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: KDus1eEfMhnyDsjRgDLjsRThKkj80xZVD2-OeJVUawg_1785823569
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Gao Xiang <hsiangkao@gmx.com> writes:

> On Mon, Aug 03, 2026 at 02:01:41PM +0200, Giuseppe Scrivano wrote:
>> Chao Yu <chao@kernel.org> writes:
>> 
>> > On 7/29/26 00:05, Giuseppe Scrivano wrote:
>> >> Allow userspace to pass an already-opened file descriptor as the mount
>> >> source instead of a path string.  This is useful for tools that already
>> >> hold an fd to the image, such as composefs reusing an existing erofs
>> >> backing file.
>> >> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
>> >> ---
>> >> v4: https://lore.kernel.org/linux-fsdevel/20260717134147.1602735-1-gscrivan@redhat.com/
>> >> v3: https://lore.kernel.org/linux-fsdevel/20260714154917.489993-1-gscrivan@redhat.com/
>> >> v2: https://lore.kernel.org/linux-fsdevel/20260711071137.4130824-1-gscrivan@redhat.com/
>> >> v1: https://lore.kernel.org/linux-fsdevel/ak5GfvVfWLJU1EwK@debian/
>> >>   Documentation/filesystems/erofs.rst | 15 ++++++
>> >>   fs/erofs/super.c                    | 73 ++++++++++++++++++++++++-----
>> >>   2 files changed, 77 insertions(+), 11 deletions(-)
>> >> diff --git a/Documentation/filesystems/erofs.rst
>> >> b/Documentation/filesystems/erofs.rst
>> >> index 4230884fb359..774e8b236d09 100644
>> >> --- a/Documentation/filesystems/erofs.rst
>> >> +++ b/Documentation/filesystems/erofs.rst
>> >> @@ -139,6 +139,21 @@ inode_share            Enable inode page sharing for this filesystem.  Inodes wi
>> >>                          page cache.
>> >>   ===================    =========================================================
>> >>   +File-backed mounts
>> >> +==================
>> >> +
>> >> +When CONFIG_EROFS_FS_BACKED_BY_FILE is enabled, EROFS file-backed images
>> >> +can be mounted directly without a loopback block device.  The backing file
>> >> +can be given either as a path, or as an already-opened file descriptor.
>> >> +
>> >> +When a file descriptor is used, the kernel resolves its path and records it
>> >> +so that /proc/mounts and similar interfaces can still report the mount
>> >> +source.
>> >> +
>> >> +Only regular files are accepted as backing files; to mount an image that
>> >> +resides on a block device, use the traditional block device mount path
>> >> +instead.
>> >
>> > Do we need to add an entry to describe the new mount option source= in
>> > "Mount options" section in erofs.rst?
>> >
>> > Thanks,
>> 
>> I've another patch "erofs: reuse superblock for file-backed mounts" that
>> also touches erofs.rst and it is currently based on top of this version.
>> I wonder what is your preferred way to handle them.
>
> EROFS dev branch usually has a small number of patches. Since Chao gave
> a new suggestion, I think a v6 is needed (but you could add all
> previous reviewed-by:).
>
> And "erofs: reuse superblock for file-backed mounts" needs to be rebased
> too, I will find time to play with it this week (or you could add a
> testcase in erofs-utils experimental-tests if you have time.)
>
>> 
>> Will maintainers deal with conflicts or do I need to submit them as a
>> single series?
>> 
>> Do you prefer a new submission v6 with the following fixup?
>> 
>> diff --git a/Documentation/filesystems/erofs.rst b/Documentation/filesystems/erofs.rst
>> index c972a869f3e9..49c4e7dbc5d6 100644
>> --- a/Documentation/filesystems/erofs.rst
>> +++ b/Documentation/filesystems/erofs.rst
>> @@ -137,6 +137,8 @@ fsoffset=%llu          Specify block-aligned filesystem offset for the primary d
>>  inode_share            Enable inode page sharing for this filesystem.  Inodes with
>>                         identical content within the same domain ID can share the
>>                         page cache.
>> +source=%s              (For file-backed mounts) Specify the backing image as a path
>> +                       or as an already-opened file descriptor.
>
> Not quite sure "an already-opened file descriptor" is "%s", but I'm fine
> since it's quite a minor one (it's unneeded to nitpick the
> documentation).

thanks, I've sent v6 as well as the rebase of "erofs: reuse superblock
for file-backed mounts" on top of it.

Regards,
Giuseppe


