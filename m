Return-Path: <linux-erofs+bounces-4183-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A7C9C5AD55
	for <linux-erofs@archiver.kernel.org>; Mon, 10 Aug 2026 15:12:12 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hJdXB5WW4z2yxG;
	Tue, 11 Aug 2026 01:12:10 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786374730;
	cv=none; b=WyLpKwvWovblBkyNtzvOXIl1KN1El3SiMhWNPAI6vxOfwMXMMvSK/BpU/O+COWHYDBdS1rDx4CdJF2CHv82tmIaUmUTDSVw5IbQ9J01qzC6MKRr/YYhDrl8U6uv7L0oyx01mglc12n+RMW4xkfKYcrUvfnzqSW0iqVsvkxMuzQyrSWk6D48NaVV5ZFD7iGdRQozwW6OAIa2Nkdlq+DDW1daoVcujHImq6/TylJZr7FUHjuQJHsyClyu4ViHnkwD2wDU5XmxbpIoSQOZ7svvLh6iSvsHpuZVWqINT/LRSbKfK1HotlFG7WjAQWUeKdvPVbTD1RCTWgY3NPvyoKUReYw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786374730; c=relaxed/relaxed;
	bh=Nu867feAj7VGyZ+OLY772FIEphtnEnr9vGHPa9h+SiA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JO8fWdhCacAHKHTvPELJWWJUUurN+t1b87GBSwm7PjahlQjOcvuVz0T08x7iRCMw4A8BYKmDYbQr1uQdIPUYAvnK1QQ9DiEcI8zpd1PfA4M7CKjkyS+RdgthgjqiSXkBJD97kLQn3KLxpxdBvwI3RYttqHrJDsQWXTfMnOy0uPhdY58UTSIEgmXfwfqvX5YD0p+Sof+iI6GvA9Od7MDIpsWRsUoiGyu6x+1a8vn0Ieanh3rZJzybzY+S+y05kY2QYUuSjdMwF34OkBUhysEhWRDcQVFE6ShKtCifXNN/z/f5PEosxXyLz8UoPxVbWwO+VAYh6kNgPUofy/0r4k/lmw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LVCipvO8; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LVCipvO8; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LVCipvO8;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LVCipvO8;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hJdX85ZBBz2ytv
	for <linux-erofs@lists.ozlabs.org>; Tue, 11 Aug 2026 01:12:07 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786374724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Nu867feAj7VGyZ+OLY772FIEphtnEnr9vGHPa9h+SiA=;
	b=LVCipvO8RtDTbppgGZVo4gAaTeraxlLEGmCI29do3zDdOjNfT5wIHojSOzF8f+1FDZ0mGb
	G/Hq+uiLVpwO6ZM+Qe99o5HIM6uxSxqF46PKasEH+SBw+kyWD7Rk/cW18n0j7Sao8Ed53F
	U63/1xQvqbtV8slSgESzY7yxyeE19RE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786374724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Nu867feAj7VGyZ+OLY772FIEphtnEnr9vGHPa9h+SiA=;
	b=LVCipvO8RtDTbppgGZVo4gAaTeraxlLEGmCI29do3zDdOjNfT5wIHojSOzF8f+1FDZ0mGb
	G/Hq+uiLVpwO6ZM+Qe99o5HIM6uxSxqF46PKasEH+SBw+kyWD7Rk/cW18n0j7Sao8Ed53F
	U63/1xQvqbtV8slSgESzY7yxyeE19RE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-626-bmHMM9xENGSTLpqyd06I5A-1; Mon,
 10 Aug 2026 11:11:59 -0400
X-MC-Unique: bmHMM9xENGSTLpqyd06I5A-1
X-Mimecast-MFC-AGG-ID: bmHMM9xENGSTLpqyd06I5A_1786374718
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 68AB4195FE17;
	Mon, 10 Aug 2026 15:11:48 +0000 (UTC)
Received: from localhost (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E438618005BD;
	Mon, 10 Aug 2026 15:11:47 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-erofs@lists.ozlabs.org,  xiang@kernel.org,
  linux-fsdevel@vger.kernel.org,  amir73il@gmail.com
Subject: Re: [PATCH v4] erofs: reuse superblock for file-backed mounts
In-Reply-To: <20260810-losging-beengt-zarte-1047dd62c195@brauner> (Christian
	Brauner's message of "Mon, 10 Aug 2026 15:34:19 +0200")
References: <20260804060455.2928514-1-gscrivan@redhat.com>
	<20260810-losging-beengt-zarte-1047dd62c195@brauner>
User-Agent: Gnus/5.13 (Gnus v5.13)
Date: Mon, 10 Aug 2026 17:11:46 +0200
Message-ID: <874ih2rowd.fsf@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: Z0QXQPgjcpoAOXtSBQfZW_G8SDnjAzabroeXaIQzuO8_1786374718
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Hi Christian,

Christian Brauner <brauner@kernel.org> writes:

> Hi Giuseppe,
>
>> When the same file-backed image is mounted multiple times (via path or
>> fd) with the superblock_share mount option, reuse the existing
>> superblock instead of creating a new one.  This allows multiple mounts
>> of the same image to share in-kernel data structures more efficiently.
>> 
>> The backing file is identified by its inode and fsoffset.  If mount
>> options conflict or extra devices are used, a separate superblock
>> is created transparently as a fallback.  Remount is not allowed on
>> shared superblocks.
>> 
>> Tested by mounting a 177M Fedora EROFS image 20 times with full
>> traversal:
>> 
>>   #!/bin/sh
>>   IMG=${1:-/root/fedora.erofs}
>>   OPTS=${2:+-o $2}
>>   N=20
>>   DIR=$(mktemp -d)
>>   trap "umount $DIR/m* 2>/dev/null; rm -rf $DIR" EXIT
>> 
>>   sync; echo 3 > /proc/sys/vm/drop_caches
>>   INODES_BEFORE=$(grep erofs_inode /proc/slabinfo | awk '{print $2}')
>>   MEM_BEFORE=$(grep ^Slab: /proc/meminfo | awk '{print $2}')
>> 
>>   for i in $(seq 1 $N); do
>>       mkdir $DIR/m$i
>>       mount -t erofs $OPTS "$IMG" $DIR/m$i
>>       find $DIR/m$i > /dev/null
>>   done
>> 
>>   echo "Superblocks: $(grep $DIR /proc/self/mountinfo | \
>>       awk '{print $3}' | sort -u | wc -l)"
>>   echo "erofs_inode delta: +$(( $(grep erofs_inode /proc/slabinfo | \
>>       awk '{print $2}') - INODES_BEFORE ))"
>>   echo "Slab delta: +$(( $(grep ^Slab: /proc/meminfo | \
>>       awk '{print $2}') - MEM_BEFORE )) kB"
>> 
>> without superblock_share:
>> 
>>   # time ./test.sh /root/fedora.erofs
>>   Superblocks: 20
>>   erofs_inode delta: +45864
>>   Slab delta: +37448 kB
>>   real	0m2.311s
>>   user	0m0.222s
>>   sys	0m1.998s
>> 
>> with superblock_share:
>> 
>>   # time ./test.sh /root/fedora.erofs superblock_share
>>   Superblocks: 1
>>   erofs_inode delta: +2044
>>   Slab delta: +284 kB
>>   real	0m0.679s
>>   user	0m0.157s
>>   sys	0m0.469s
>> 
>> The time difference shows that sharing the superblock also benefits
>> the page cache and inode cache, as subsequent mounts of the same image
>> avoid re-reading the backing file.  This is particularly useful for
>> container hosts running multiple containers from the same base image.
>> 
>> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
>>
>> diff --git a/Documentation/filesystems/erofs.rst b/Documentation/filesystems/erofs.rst
>> index d301d9ac946a..49c4e7dbc5d6 100644
>> --- a/Documentation/filesystems/erofs.rst
>> +++ b/Documentation/filesystems/erofs.rst
>> @@ -139,6 +139,9 @@ inode_share            Enable inode page sharing for this filesystem.  Inodes wi
>>                         page cache.
>>  source=%s              (For file-backed mounts) Specify the backing image as a path
>>                         or as an already-opened file descriptor.
>> +superblock_share       (For file-backed mounts) Share the superblock when the same
>> +                       backing file is mounted more than once with compatible
>> +                       options.  Remount is not allowed on shared superblocks.
>>  ===================    =========================================================
>>  
>>  File-backed mounts
>> @@ -156,6 +159,11 @@ Only regular files are accepted as backing files; to mount an image that
>>  resides on a block device, use the traditional block device mount path
>>  instead.
>>  
>> +When superblock_share is specified and the same backing file (identified
>> +by inode and fsoffset) is mounted more than once with compatible mount
>> +options, the kernel reuses the existing superblock instead of creating a
>> +new one.  Remount is not allowed on shared superblocks.
>> +
>>  Sysfs Entries
>>  =============
>>  
>> diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
>> index 57bd21859c65..86da219f8f4e 100644
>> --- a/fs/erofs/internal.h
>> +++ b/fs/erofs/internal.h
>> @@ -156,6 +156,7 @@ struct erofs_sb_info {
>>  #define EROFS_MOUNT_DAX_NEVER		0x00000080
>>  #define EROFS_MOUNT_DIRECT_IO		0x00000100
>>  #define EROFS_MOUNT_INODE_SHARE		0x00000200
>> +#define EROFS_MOUNT_SUPERBLOCK_SHARE	0x00000400
>>  
>>  #define clear_opt(opt, option)	((opt)->mount_opt &= ~EROFS_MOUNT_##option)
>>  #define set_opt(opt, option)	((opt)->mount_opt |= EROFS_MOUNT_##option)
>> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
>> index 3d92caec8d3a..4e926376e17b 100644
>> --- a/fs/erofs/super.c
>> +++ b/fs/erofs/super.c
>> @@ -386,7 +386,7 @@ static void erofs_default_options(struct erofs_sb_info *sbi)
>>  enum {
>>  	Opt_user_xattr, Opt_acl, Opt_cache_strategy, Opt_dax, Opt_dax_enum,
>>  	Opt_device, Opt_domain_id, Opt_directio, Opt_fsoffset, Opt_inode_share,
>> -	Opt_source,
>> +	Opt_source, Opt_superblock_share,
>>  };
>>  
>>  static const struct constant_table erofs_param_cache_strategy[] = {
>> @@ -415,6 +415,7 @@ static const struct fs_parameter_spec erofs_fs_parameters[] = {
>>  	fsparam_u64("fsoffset",			Opt_fsoffset),
>>  	fsparam_flag("inode_share",		Opt_inode_share),
>>  	fsparam_file_or_string("source",	Opt_source),
>> +	fsparam_flag("superblock_share",	Opt_superblock_share),
>>  	{}
>>  };
>>  
>> @@ -560,6 +561,12 @@ static int erofs_fc_parse_param(struct fs_context *fc,
>>  		else
>>  			set_opt(&sbi->opt, INODE_SHARE);
>>  		break;
>> +	case Opt_superblock_share:
>> +		if (!IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE))
>> +			errorfc(fc, "%s option not supported", erofs_fs_parameters[opt].name);
>> +		else
>> +			set_opt(&sbi->opt, SUPERBLOCK_SHARE);
>> +		break;
>>  	case Opt_source:
>>  		return erofs_fc_parse_source(fc, param);
>>  	}
>> @@ -652,6 +659,17 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
>>  		errorfc(fc, "FSDAX is not allowed when inode_share is on");
>>  		return -EINVAL;
>>  	}
>> +	if (test_opt(&sbi->opt, SUPERBLOCK_SHARE) &&
>> +	    test_opt(&sbi->opt, INODE_SHARE)) {
>> +		errorfc(fc, "superblock_share is not allowed when inode_share is on");
>> +		return -EINVAL;
>> +	}
>> +	/* Extra devices are not yet supported with superblock sharing.  */
>> +	if (test_opt(&sbi->opt, SUPERBLOCK_SHARE) &&
>> +	    sbi->devs->extra_devices) {
>> +		errorfc(fc, "superblock_share does not support extra devices");
>> +		return -EINVAL;
>> +	}
>>  
>>  	sbi->blkszbits = PAGE_SHIFT;
>>  	if (!sb->s_bdev) {
>> @@ -779,6 +797,51 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
>>  	return 0;
>>  }
>>  
>> +static int erofs_fc_test_file_super(struct super_block *sb,
>> +				    struct fs_context *fc)
>> +{
>> +	struct erofs_sb_info *sbi = EROFS_SB(sb);
>> +	struct erofs_sb_info *new_sbi = fc->s_fs_info;
>> +
>> +	if (sb->s_iflags & SB_I_RETIRED)
>> +		return 0;
>> +	if (!sbi->dif0.file || !new_sbi->dif0.file)
>> +		return 0;
>> +	if (!test_opt(&new_sbi->opt, SUPERBLOCK_SHARE))
>> +		return 0;
>> +	return file_inode(sbi->dif0.file) == file_inode(new_sbi->dif0.file) &&
>> +	       sbi->dif0.fsoff == new_sbi->dif0.fsoff &&
>> +	       !memcmp(&sbi->opt, &new_sbi->opt, sizeof(sbi->opt));
>> +}
>> +
>> +static int erofs_fc_get_tree_file(struct fs_context *fc)
>> +{
>> +	struct erofs_sb_info *sbi = fc->s_fs_info;
>> +	struct super_block *sb;
>> +	int err;
>> +
>> +	if (!test_opt(&sbi->opt, SUPERBLOCK_SHARE))
>> +		return get_tree_nodev(fc, erofs_fc_fill_super);
>> +
>> +	sb = sget_fc(fc, erofs_fc_test_file_super, set_anon_super_fc);
>> +	if (IS_ERR(sb))
>> +		return PTR_ERR(sb);
>> +
>> +	if (sb->s_root) {
>> +		erofs_info(sb, "sharing superblock for the same backing file");
>> +	} else {
>> +		err = erofs_fc_fill_super(sb, fc);
>> +		if (err) {
>> +			deactivate_locked_super(sb);
>> +			return err;
>> +		}
>> +		sb->s_flags |= SB_ACTIVE;
>> +	}
>> +
>> +	fc->root = dget(sb->s_root);
>> +	return 0;
>> +}
>
> I think you should rename vfs_get_super() to get_tree_super() and expose
> it to modules. Then this function collapses to:
>
> if (!test_opt(&sbi->opt, SUPERBLOCK_SHARE))
> 	get_tree_super(fc, NULL, erofs_fc_fill_super);
>
> return get_tree_super(fc, erofs_fc_test_file_super, erofs_fc_fill_super);
>
> or simpler, if you move the sbi test for SUPERBLOCK_SHARE into
> erofs_fc_test_file_super:
>
> get_tree_super(fc, erofs_fc_test_file_super, erofs_fc_fill_super);

that is neat!  I'll send a new version with this fix.

Regards,
Giuseppe


