Return-Path: <linux-erofs+bounces-4090-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3D25C55196
	for <linux-erofs@archiver.kernel.org>; Mon,  3 Aug 2026 12:01:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDFdv1Lv3z30F0;
	Mon, 03 Aug 2026 22:01:55 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785758515;
	cv=none; b=IrLnV278tU1HkiRLPyVeXCUNOR5qCMsWGJd7CNR+pEpYnWplv4MQKUAFVT5/7oGtfuuIylH9l/1EzvqPmBb/duvfVnT9bERuK+efT8JM7bHdrjs+DUyQ745hNCTRZKplRAJ6UD5JjDLeX9JqzVx88v23Jm/8Tf28cZzRPYFHaB/3TDsOVecO7Ep20Cam98folyVZmE7hBrCe2KZjPyi1NycTpupKC9eIe5ijQKqV4I7gcaAykLu+Lk0St4Ke2rhJQ6aYoUHFxmbZezA1zlCPznmYg8YluMuTgPxBDGEKMYybGdgGs2sA3NkJrvd2+0VGlJdwUKHf8gDBzc/TXfy95g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785758515; c=relaxed/relaxed;
	bh=5/l/ULtq0dKzIiFBcjVXKrCzKILrVUjC7kgmZD3ajxI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KVGbB+X+4lPcLNVbDO66zGAHt3Ck8CN/Z8pQVLgcFUFJHlCl3LVcvxz8B5H1hQDZtyyZYnnyIAdOK6UWfGJylxQq9SwNaLs4eeDQqlUotbXSjfkNs8U2eSWWrAa6nfiRdyiGpv8UBkc4iXk7IgAb6xZ1nJNS+X0tIOHHvsc4KyrUM8EaPyUOMO+Y7sThDEXaCKxG7J1HO03jmXABnSuLHpiweROCVtcbq53Gk9yT9io9+IZYh5mBWp8D/Q43syW4NxMxQIzRmPJ3ITkGiru2YBGAHM3u03kqHXLVsYZwKtdl3ORGHTrfPzwcjthpOlQGv6z9pkavNPA0JB+Yy+6Wtg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=TjW4LR/r; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=TjW4LR/r; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=TjW4LR/r;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=TjW4LR/r;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hDFds5HWFz2xLf
	for <linux-erofs@lists.ozlabs.org>; Mon, 03 Aug 2026 22:01:51 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785758508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5/l/ULtq0dKzIiFBcjVXKrCzKILrVUjC7kgmZD3ajxI=;
	b=TjW4LR/rS64U6RzN4fJ6JWMAuBF2cxYuHRySHDdid9UTqQ4PeSmNuxxnrx6Yn9ePUZNXCV
	6JyIMdEGOHGs8u708dke+Za8NNXA9PS04E8LumZ+uGsLd2Odoj/Ym2sRlwVarTw/4CSr/R
	/E0L/QCA+Yn7pEBAqcZb+Kf4bS215+g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785758508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5/l/ULtq0dKzIiFBcjVXKrCzKILrVUjC7kgmZD3ajxI=;
	b=TjW4LR/rS64U6RzN4fJ6JWMAuBF2cxYuHRySHDdid9UTqQ4PeSmNuxxnrx6Yn9ePUZNXCV
	6JyIMdEGOHGs8u708dke+Za8NNXA9PS04E8LumZ+uGsLd2Odoj/Ym2sRlwVarTw/4CSr/R
	/E0L/QCA+Yn7pEBAqcZb+Kf4bS215+g=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-570-kulaAthoOQyfvVIq5lRYBg-1; Mon,
 03 Aug 2026 08:01:44 -0400
X-MC-Unique: kulaAthoOQyfvVIq5lRYBg-1
X-Mimecast-MFC-AGG-ID: kulaAthoOQyfvVIq5lRYBg_1785758503
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 551461954B19;
	Mon,  3 Aug 2026 12:01:43 +0000 (UTC)
Received: from localhost (unknown [10.44.33.95])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 75CE7424;
	Mon,  3 Aug 2026 12:01:42 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: Chao Yu <chao@kernel.org>
Cc: linux-erofs@lists.ozlabs.org,  cyphar@cyphar.com,
  hsiangkao@linux.alibaba.com,  linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5] erofs: accept source file descriptor via fsconfig
In-Reply-To: <366a9c6b-ec56-4cdf-b373-22a3cd8c9beb@kernel.org> (Chao Yu's
	message of "Mon, 3 Aug 2026 19:24:07 +0800")
References: <20260728160619.853924-1-gscrivan@redhat.com>
	<366a9c6b-ec56-4cdf-b373-22a3cd8c9beb@kernel.org>
Date: Mon, 03 Aug 2026 14:01:41 +0200
Message-ID: <874ihbxviy.fsf@redhat.com>
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
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: qojLbju7Hxw-73ikHqJU0XV_N8jO9xEC8767rbGD-jk_1785758503
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Chao Yu <chao@kernel.org> writes:

> On 7/29/26 00:05, Giuseppe Scrivano wrote:
>> Allow userspace to pass an already-opened file descriptor as the mount
>> source instead of a path string.  This is useful for tools that already
>> hold an fd to the image, such as composefs reusing an existing erofs
>> backing file.
>> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
>> ---
>> v4: https://lore.kernel.org/linux-fsdevel/20260717134147.1602735-1-gscrivan@redhat.com/
>> v3: https://lore.kernel.org/linux-fsdevel/20260714154917.489993-1-gscrivan@redhat.com/
>> v2: https://lore.kernel.org/linux-fsdevel/20260711071137.4130824-1-gscrivan@redhat.com/
>> v1: https://lore.kernel.org/linux-fsdevel/ak5GfvVfWLJU1EwK@debian/
>>   Documentation/filesystems/erofs.rst | 15 ++++++
>>   fs/erofs/super.c                    | 73 ++++++++++++++++++++++++-----
>>   2 files changed, 77 insertions(+), 11 deletions(-)
>> diff --git a/Documentation/filesystems/erofs.rst
>> b/Documentation/filesystems/erofs.rst
>> index 4230884fb359..774e8b236d09 100644
>> --- a/Documentation/filesystems/erofs.rst
>> +++ b/Documentation/filesystems/erofs.rst
>> @@ -139,6 +139,21 @@ inode_share            Enable inode page sharing for this filesystem.  Inodes wi
>>                          page cache.
>>   ===================    =========================================================
>>   +File-backed mounts
>> +==================
>> +
>> +When CONFIG_EROFS_FS_BACKED_BY_FILE is enabled, EROFS file-backed images
>> +can be mounted directly without a loopback block device.  The backing file
>> +can be given either as a path, or as an already-opened file descriptor.
>> +
>> +When a file descriptor is used, the kernel resolves its path and records it
>> +so that /proc/mounts and similar interfaces can still report the mount
>> +source.
>> +
>> +Only regular files are accepted as backing files; to mount an image that
>> +resides on a block device, use the traditional block device mount path
>> +instead.
>
> Do we need to add an entry to describe the new mount option source= in
> "Mount options" section in erofs.rst?
>
> Thanks,

I've another patch "erofs: reuse superblock for file-backed mounts" that
also touches erofs.rst and it is currently based on top of this version.
I wonder what is your preferred way to handle them.

Will maintainers deal with conflicts or do I need to submit them as a
single series?

Do you prefer a new submission v6 with the following fixup?

diff --git a/Documentation/filesystems/erofs.rst b/Documentation/filesystems/erofs.rst
index c972a869f3e9..49c4e7dbc5d6 100644
--- a/Documentation/filesystems/erofs.rst
+++ b/Documentation/filesystems/erofs.rst
@@ -137,6 +137,8 @@ fsoffset=%llu          Specify block-aligned filesystem offset for the primary d
 inode_share            Enable inode page sharing for this filesystem.  Inodes with
                        identical content within the same domain ID can share the
                        page cache.
+source=%s              (For file-backed mounts) Specify the backing image as a path
+                       or as an already-opened file descriptor.

Thanks,
Giuseppe


