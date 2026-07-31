Return-Path: <linux-erofs+bounces-4062-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7772C5516D
	for <linux-erofs@archiver.kernel.org>; Fri, 31 Jul 2026 13:20:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hBRWd2FYmz2y1F;
	Fri, 31 Jul 2026 23:20:13 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785504013;
	cv=none; b=cvVLHwOPtlJSV+BBVMXo94edMBjVjKjwJ6Rgh+7Sf05jqf1yzVGMR49OKyVOcRCjhjEOQidHldY+DHcx0U0JR4/MsyOE0yisXqRf7MsYBvt9LL/GlnX8HIHWjs5o2Q06+G5S3jDVT3t13xOuoKs0fRLDaD16+oUoGOqACSAhprYM9ufxBYwM6PCISljMp0sZDwDqinGCDg91tiwWYivJOOOOnmw+DzG2BDtOo9L/lxatVXxSi6//1NSJ40KyZGaIDt9a1HnY49t137KAKW+W7TvX915R+bfooNV1OdPMTDpbjOHCkxlqBikrQnU+pKoTPzBEkB2hi7pX7027FP9XJg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785504013; c=relaxed/relaxed;
	bh=pyOPsiUIBTWFHqhC3K1AsN3OR/n36zaeH0PxmI6at7U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=eOT4225+1LXduOMucskJOqaAbeCfGA0QJGKqaxhV3JfcI3WU3iDIg+3tR5jQJJWBozAx5KgYeBl8IUi8c2v1EcOEtUJGtP3Px8RGVxUVrxuVdgY/69sURNvFCcVE3nMDn9g8OBbR6kKI83Q01BpC2i3ZkRMQi32+WDvK2ytBQ7JZl++EJcnxTAt3bYzuuRUa4wAC/EFdkJEbtlrrOAtdAkUBghL2Ms6Z++LCTTo1Qme0E5WCOBAKwozpZ0tIkrate/rXfM9ipmazJ+VscnuoGJZRK4cT4EVBIR/Pq6yKpiDalWj1Y9qYDPDZiioknNp/69A2wAcXJ1WY6NT4agOHIA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DIx+KVUq; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=AxPYkhKF; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DIx+KVUq;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=AxPYkhKF;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hBRWb5cHjz2xl5
	for <linux-erofs@lists.ozlabs.org>; Fri, 31 Jul 2026 23:20:09 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785504006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pyOPsiUIBTWFHqhC3K1AsN3OR/n36zaeH0PxmI6at7U=;
	b=DIx+KVUqoM5K+fkzSYfAdo348A2i0kjaWMi03uYIk4N4U0gDqhyadsRSrnTGA6qt1GyXhp
	zjALS6yK64BuZzmyIefctiY3u00d/tYbVOOW3rQMOJxt5vSfeTGe44+CzP3HSB3X6LQniN
	T/+ZJJ0PvFJdWD7UQfBVZFtMUEgUQUQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785504007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pyOPsiUIBTWFHqhC3K1AsN3OR/n36zaeH0PxmI6at7U=;
	b=AxPYkhKFXS3ZHqyYHay9SoO1iGkDEQdq7gv+8Q429ivO6j4f18Ml2eC3XGvTmif3iSXxBS
	02fwv/D7BntfZEUwqOO0r5+Sz+z7LU57kcXHLu7zJVuIDf+a6fkaw+ZYOPMD0XLTAM8yVS
	0SSVay6ijSRy2S17Yaa9no+Vym23khE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-614-vYjiWzQnNN-Jk30ZqAwH1A-1; Fri,
 31 Jul 2026 09:20:02 -0400
X-MC-Unique: vYjiWzQnNN-Jk30ZqAwH1A-1
X-Mimecast-MFC-AGG-ID: vYjiWzQnNN-Jk30ZqAwH1A_1785504001
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 574BF1956049;
	Fri, 31 Jul 2026 13:20:01 +0000 (UTC)
Received: from localhost (unknown [10.44.49.83])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5449C1800480;
	Fri, 31 Jul 2026 13:20:00 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,  linux-erofs@lists.ozlabs.org,
  xiang@kernel.org,  linux-fsdevel@vger.kernel.org,  amir73il@gmail.com
Subject: Re: [PATCH] erofs: reuse superblock for file-backed mounts
In-Reply-To: <20260731-geeilt-hasen-demografie-83c895f789ea@brauner>
	(Christian Brauner's message of "Fri, 31 Jul 2026 15:12:11 +0200")
References: <20260730124120.1501126-1-gscrivan@redhat.com>
	<amtJX8aTZT5d_sP3@pedro-suse.lan> <8733x0k2p1.fsf@redhat.com>
	<87fr10h2wh.fsf@redhat.com>
	<20260731-geeilt-hasen-demografie-83c895f789ea@brauner>
Date: Fri, 31 Jul 2026 15:19:58 +0200
Message-ID: <8733wz1ekh.fsf@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: UF9N6teUq8i95BmnhPhh_j3XGviWdpOMf6CIdRLpVrM_1785504001
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Christian Brauner <brauner@kernel.org> writes:

>> >>> The time difference shows that sharing the superblock also benefits
>> >>> the page cache and inode cache, as subsequent mounts of the same image
>> >>> avoid re-reading the backing file.  This is particularly useful for
>> >>> container hosts running multiple containers from the same base image.
>> >>
>> >> Doesn't this approach break-down as soon as you get to change SB flags (through
>> >> e.g mount -o remount)? It will change superblock flags for all of them, right?
>> >>
>> >> (I don't think you can switch off the superblock transparently on a
>> >> reconfigure?)
>> >
>> > This is the same preexisting behavior for block device mounts.  That
>
> Yeah, and it sucks ass. :)
> Only an incompatible vfs-level RO/RW property causes a silent reuse to
> fail. Otherwise it not possible to detect that a superblock has been
> created and requested mount options silently ignore.
>
> In other words, doing this unconditionally is incompatible with current
> userspace.
>
> Btw, I added FSCONFIG_CMD_CREATE_EXCL for this reason which refuses to
> reuse an existing superblock for filesystems that would otherwise end up
> sharing a superblock. This way userspace is guaranteed to not silently
> get filesystem options ignored.
>
>> > said, I realize this can feel confusing since EROFS is not a block
>> > device and allowed this so far.
>> >
>> > One way to solve this could be an explicit mount option "share_sb" that
>> > is opt-in and, once set, blocks any remount operations.  Would that
>> > work?
>> 
>> Would something like the following fixup on top of the previous patch be
>> acceptable (suggestions for better names are welcome)?
>
> The patch as written still means that a task A creates a new erofs mount
> with for file F and marks it as shared. Another task B creates new erofs
> mount expecting to get a new superblock and will end up sharing it with
> task A instead.
>
> That is still quite the behavior change and could be used to subvert
> workloads expectations and be used in (odd) attacks.

no, my suggestion is that task B gets the same superblock created by A
only if it also specifies share_sb.

If the option is not specified, as is the case for existing workloads,
then it gets a new superblock even if A is already mounted with
share_sb.

The tasks A and B will get the same superblock only if they both specify
share_sb.  It is fully opt-in, it doesn't affect any other user that
doesn't want this behavior.

Regards,
Giuseppe



>
> So if you want sb-sharing you need it to be an admin-level setting or
> you need to make it a domain the same way page cache sharing for erofs
> is a domain. IOW, only task that mount with the same domain end up
> sharing superblocks. Or it's a global setting.
>
> But doing it this way seems problematic to me.
>
>> Thanks,
>> Giuseppe
>> 
>> diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
>> index 580f8d9f14e7..ac26daf4f78a 100644
>> --- a/fs/erofs/internal.h
>> +++ b/fs/erofs/internal.h
>> @@ -156,6 +156,7 @@ struct erofs_sb_info {
>>  #define EROFS_MOUNT_DAX_NEVER		0x00000080
>>  #define EROFS_MOUNT_DIRECT_IO		0x00000100
>>  #define EROFS_MOUNT_INODE_SHARE		0x00000200
>> +#define EROFS_MOUNT_SHARE_SB		0x00000400
>>  
>>  #define clear_opt(opt, option)	((opt)->mount_opt &= ~EROFS_MOUNT_##option)
>>  #define set_opt(opt, option)	((opt)->mount_opt |= EROFS_MOUNT_##option)
>> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
>> index cbd76727f0d3..dd2a351811c8 100644
>> --- a/fs/erofs/super.c
>> +++ b/fs/erofs/super.c
>> @@ -386,7 +386,7 @@ static void erofs_default_options(struct erofs_sb_info *sbi)
>>  enum {
>>  	Opt_user_xattr, Opt_acl, Opt_cache_strategy, Opt_dax, Opt_dax_enum,
>>  	Opt_device, Opt_domain_id, Opt_directio, Opt_fsoffset, Opt_inode_share,
>> -	Opt_source,
>> +	Opt_source, Opt_share_sb,
>>  };
>>  
>>  static const struct constant_table erofs_param_cache_strategy[] = {
>> @@ -414,6 +414,7 @@ static const struct fs_parameter_spec erofs_fs_parameters[] = {
>>  	fsparam_flag_no("directio",		Opt_directio),
>>  	fsparam_u64("fsoffset",			Opt_fsoffset),
>>  	fsparam_flag("inode_share",		Opt_inode_share),
>> +	fsparam_flag("share_sb",		Opt_share_sb),
>>  	fsparam_file_or_string("source",	Opt_source),
>>  	{}
>>  };
>> @@ -560,6 +561,12 @@ static int erofs_fc_parse_param(struct fs_context *fc,
>>  		else
>>  			set_opt(&sbi->opt, INODE_SHARE);
>>  		break;
>> +	case Opt_share_sb:
>> +		if (!IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE))
>> +			errorfc(fc, "%s option not supported", erofs_fs_parameters[opt].name);
>> +		else
>> +			set_opt(&sbi->opt, SHARE_SB);
>> +		break;
>>  	case Opt_source:
>>  		return erofs_fc_parse_source(fc, param);
>>  	}
>> @@ -798,6 +805,8 @@ static int erofs_fc_test_file_super(struct super_block *sb,
>>  		return 0;
>>  	if (!sbi->dif0.file || !new_sbi->dif0.file)
>>  		return 0;
>> +	if (!test_opt(&new_sbi->opt, SHARE_SB))
>> +		return 0;
>>  	return file_inode(sbi->dif0.file) == file_inode(new_sbi->dif0.file) &&
>>  	       sbi->dif0.fsoff == new_sbi->dif0.fsoff &&
>>  	       sbi->opt.mount_opt == new_sbi->opt.mount_opt &&
>> @@ -874,6 +883,9 @@ static int erofs_fc_reconfigure(struct fs_context *fc)
>>  
>>  	DBG_BUGON(!sb_rdonly(sb));
>>  
>> +	if (test_opt(&sbi->opt, SHARE_SB))
>> +		return -EBUSY;
>> +
>>  	if (new_sbi->domain_id)
>>  		erofs_info(sb, "ignoring reconfiguration for domain_id.");
>>  
>> 
>> 
>> 


