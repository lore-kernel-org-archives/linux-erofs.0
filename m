Return-Path: <linux-erofs+bounces-4197-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C889AC5B572
	for <linux-erofs@archiver.kernel.org>; Tue, 11 Aug 2026 15:59:43 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hKGXZ21GTz2yv9;
	Wed, 12 Aug 2026 01:59:42 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786463982;
	cv=none; b=PMEo76w57RCq8zceNMp1Rahyad4QyJ1yllaCMxaKWH+TWWUSsKhkQMjsB64gtThSdbxhyAtZguFWAMabhau0v+iu2Q35vV+sVeRUcHtQxrT1OY5kw7wIDZYxAU8jO8341rmGspIYZk0/Rkce0nqEk5wBwL+3V4IRyPRpAEjLCMQdlYGMr9DB4jNtC7alrhftN+wxAV0XKoVm+D9YEF3q7i+j2p18EIp8rY/a3r16xQS7E1AabYG/isRSRxf9QKy2gUV04J14/P3V5Ay1Vx5G1DQQXGEn547vvt7rkRb1PUTYW01xFwH616EPYObF24rOO1KvJI6GO+K02uBQMOor5g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786463982; c=relaxed/relaxed;
	bh=mCvDnupsbeV/Yzo1YbOdqHwd4oobYNdBsGkpGWtN2Ug=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=n7s9nLABW076+0OHJTKoFjZZFcPmHqiy4+L08JLJD/Ngu8cQc4LyvAwzSUWwOGBsWfFrd7bNs8zcGPa+9WYua1JapXsOgUZRY4jMcYzmEyztuAMnzuk4Htl3oiAEPwffrEau4Cz/endPEIyefoZeh4Ozbo5DoD8Ta/nVcQE/kDkUrtVhR1n97W1HwQMijmF7Bsc1kIJE8JnZxJWZdqjMmflqSHF1x2QoJS8W1QBDoAtfJeCxF8Jfz+dkUPtZ7AsdWQXuMf6xdbHYubMETBdvQjM8VjoUd6iONAl3Q6RYwnbsq/z/NE2UV3aGKy1Os/dDdpbTHxXMnWpQW2sIwHMeyQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KOVwDuqG; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bbuLmHfL; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KOVwDuqG;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bbuLmHfL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hKGXY1KL6z2yrL
	for <linux-erofs@lists.ozlabs.org>; Wed, 12 Aug 2026 01:59:40 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786463976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mCvDnupsbeV/Yzo1YbOdqHwd4oobYNdBsGkpGWtN2Ug=;
	b=KOVwDuqGpWBGqGSl66sLP0swCWByKkoQ+338Eg2RITlsymWfa9FfzZ0xr0w8trZeXrg99N
	zNz4tpvn4NJqctaTsoyd73wrSB/zXhCAD2zORBoc8gnt5Bo9zC/8fMIYsBxhcNpy42lN4O
	oRXkI6KZqUAaQpcwsLh7k1Vt1HJmGWY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786463977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mCvDnupsbeV/Yzo1YbOdqHwd4oobYNdBsGkpGWtN2Ug=;
	b=bbuLmHfL6TFHa0Rv7BfJIkx/7+1/wZEOUyvYQs1Tu9S3KWmg8pX06q5xKyvcUyFhCqiqVy
	tr+bKj8ILq6c2Bg7WwtN4kD8KQ8foDFzOtpQqeHDe9l9xIZ8c930qyG8s+A7Glz9q/DwvF
	mxtXWmoQmr32NhHQDhU2wuh9hBLeSRU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-248-09AjPMHzNF61S3s6m3lSkg-1; Tue,
 11 Aug 2026 11:59:28 -0400
X-MC-Unique: 09AjPMHzNF61S3s6m3lSkg-1
X-Mimecast-MFC-AGG-ID: 09AjPMHzNF61S3s6m3lSkg_1786463966
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 075AE1800614;
	Tue, 11 Aug 2026 15:59:26 +0000 (UTC)
Received: from localhost (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3ECCF195DF98;
	Tue, 11 Aug 2026 15:59:24 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,  linux-fsdevel@vger.kernel.org,  amir73il@gmail.com,
  brauner@kernel.org,  Alexander Viro <viro@zeniv.linux.org.uk>,  Jan Kara
 <jack@suse.cz>
Subject: Re: [PATCH v5 1/2] fs: rename vfs_get_super() to get_tree_super()
 and export it
In-Reply-To: <antDVPzz0tbn2kTU@XiangdeMacBook-Pro.local> (Gao Xiang's message
	of "Tue, 11 Aug 2026 23:44:20 +0800")
References: <20260811071241.389589-1-gscrivan@redhat.com>
	<20260811071241.389589-2-gscrivan@redhat.com>
	<antDVPzz0tbn2kTU@XiangdeMacBook-Pro.local>
Date: Tue, 11 Aug 2026 17:59:23 +0200
Message-ID: <877blwwsv8.fsf@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: YnVRTgltPoMlgMxvJ0fraPBTFCl_IV8AAfmWwtdQo7U_1786463966
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Gao Xiang <xiang@kernel.org> writes:

> (+ cc vfs maintainers)
>
> Hi,
>
> On Tue, Aug 11, 2026 at 09:10:50AM +0200, Giuseppe Scrivano wrote:
>> vfs_get_super() already implements the common get_tree pattern of
>> looking up an existing superblock via a test callback and initialising
>> a new one with fill_super otherwise, but it is private to fs/super.c
>> and only reachable through the get_tree_nodev()/get_tree_single()/
>> get_tree_keyed() wrappers, none of which let a filesystem supply its
>> own test callback.
>> 
>> Rename it to get_tree_super() and export it so filesystems that need a
>> custom superblock matching policy can reuse it directly instead of
>> open-coding sget_fc() + fill_super().  No functional change.
>> 
>> This is a preparatory fix for the next patch.
>> 
>> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
>
> With the new vfs_get_super() helper, it seems much cleaner compared
> to the previous versions.
>
> Since this series interacts with the other erofs ongoing patches.
> So I hope at least [PATCH 2/2] can be routed into the erofs tree to
> avoid unnecessary conflict resolving.
>
> Maybe the simplistic way is vfs maintainers can ack this vfs patch so
> that both patches can go through erofs tree for the next cycle
> directly.
>
>
>> ---
>
> ...
>
>> +/**
>> + * get_tree_super - Get a superblock, optionally sharing an existing one
>> + * @fc: The filesystem context holding the parameters
>> + * @test: Comparison function to find a matching existing superblock, or NULL
>> + * @fill_super: Helper to initialise a new superblock
>> + *
>> + * If @test is non-NULL and matches an existing superblock, that superblock is
>> + * reused; otherwise a new anonymous superblock is created and initialised with
>> + * @fill_super.  Passing NULL for @test always creates a new superblock.
>> + */
>> +int get_tree_super(struct fs_context *fc,
>>  		int (*test)(struct super_block *, struct fs_context *),
>>  		int (*fill_super)(struct super_block *sb,
>>  				  struct fs_context *fc))
>> @@ -1278,12 +1288,13 @@ static int vfs_get_super(struct fs_context *fc,
>>  	deactivate_locked_super(sb);
>>  	return err;
>>  }
>> +EXPORT_SYMBOL(get_tree_super);
>
> btw, some people prefer EXPORT_SYMBOL_GPL() for this kind of helpers.

I am fine with this change, but the rest of the file is using
EXPORT_SYMBOL though, that is why I've used it.

Regards,
Giuseppe


