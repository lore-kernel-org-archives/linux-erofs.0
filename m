Return-Path: <linux-erofs+bounces-4196-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09A10C5B56A
	for <linux-erofs@archiver.kernel.org>; Tue, 11 Aug 2026 15:57:39 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hKGVB1csMz2yrW;
	Wed, 12 Aug 2026 01:57:38 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786463858;
	cv=none; b=DYchB/Yhc5YLPmqgp1+XfuDi7cNIKEjMFePvft0GqWgW8KBxjqSBJYZExT5WF+ecSwKScC2gRnwFIWUpyS/U78xM1RJIbcvkm0G/maABVwikq/Ag1XB45lDyrVi4NkBCa6nGyvbHBo+2hxiw983t/DWnFY5Re4OY3sPMab4EKLL4bYppK5TxUQz/D0831BWftCIkQQQLxb59pLzKACyDzDq/NQVlXdPDAAgBOjGlx6cuzS8S8hc+wkh37Ge8XHTEu8mMq7MxXPuurXB8shRDUNJ0lvO2LZ3iCHT11p70zrmifJ8Q8CPe87tqZU7eqFsO5HtQemWzkv0oeLI58SrNyg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786463858; c=relaxed/relaxed;
	bh=bEED7qEroeMR9htSCXxZ1mOUIYUQP/wt9HQZo+ZmSXg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Oksqcl9hwzMsXBvQ1sS3GIpVKJkHfjNx+DsTYMChwzxeSOtsnBRH4YlhyoMB15w1fD4l9xQb/ofvrp1CDaSzoyM+AV6hUAdeGI8ex7JkDTso2I6WLNv3F6hQlPufMGnW+MCurNyEsf60lUzr1G3/nP+AFhTNg1eQmTFpxUjAkrylywSQ46JYMo0Dn3SLJV6CqJ/bFcBI6NHlG8YxchHzCmpxXQPsyvxPiNonTPukzkQUK/XT85HBrlG9/Eq9YPcp2oomRIOQqYyopktuddEa92EQxKgmf0DlMdOghjsaq+1wdIcOyPQMK2wzulngUl9ssQLGzcPVG0U2QOJzAx01Gg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iTWHniWS; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=aln8XLEW; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iTWHniWS;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=aln8XLEW;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hKGV85BhTz2yrL
	for <linux-erofs@lists.ozlabs.org>; Wed, 12 Aug 2026 01:57:34 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786463849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bEED7qEroeMR9htSCXxZ1mOUIYUQP/wt9HQZo+ZmSXg=;
	b=iTWHniWSwVJfabAidJVxnDYMIWg5qPLUf0lU2qTFviH/z3craNst7iLyaMzR71/iooX0ku
	Xrxh85HHdb/gGE1t7/6G87ku3kSImYKD61e4Jc5KLTpgX1qhpvxN7epMUUX6WAAksyWm9B
	O3KgmpBjRYXmOaybV6zfK/d9VHzmSdk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786463850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bEED7qEroeMR9htSCXxZ1mOUIYUQP/wt9HQZo+ZmSXg=;
	b=aln8XLEWDE2H/1rW5YdGFb4Qqn+vBGAttXR5Iveo9ozfSVL7T7lkuMfv7ZGWKzq5/1aa2o
	4XeRQ/rVusK2Vvfrg1zXQZeM5I49M6XJKtdMcfIM6P+YfcV10wItNEIDVF/HKgLQPE75xj
	PsLcH1FrCEU2ZwJCE8ezKNX5fW2FeyI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-413-jgIb1dKqMNuz1HO8x3zkVQ-1; Tue,
 11 Aug 2026 11:57:26 -0400
X-MC-Unique: jgIb1dKqMNuz1HO8x3zkVQ-1
X-Mimecast-MFC-AGG-ID: jgIb1dKqMNuz1HO8x3zkVQ_1786463843
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F63E1956045;
	Tue, 11 Aug 2026 15:57:23 +0000 (UTC)
Received: from localhost (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ADCB9195DF91;
	Tue, 11 Aug 2026 15:57:22 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,  linux-fsdevel@vger.kernel.org,  amir73il@gmail.com,
  brauner@kernel.org
Subject: Re: [PATCH v5 2/2] erofs: reuse superblock for file-backed mounts
In-Reply-To: <antAYlH-bZ2NQWCR@XiangdeMacBook-Pro.local> (Gao Xiang's message
	of "Tue, 11 Aug 2026 23:31:46 +0800")
References: <20260811071241.389589-1-gscrivan@redhat.com>
	<20260811071241.389589-3-gscrivan@redhat.com>
	<antAYlH-bZ2NQWCR@XiangdeMacBook-Pro.local>
Date: Tue, 11 Aug 2026 17:57:20 +0200
Message-ID: <87bjb8wsyn.fsf@redhat.com>
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
X-Mimecast-MFC-PROC-ID: HwAkINLmmsJdgQLSH7qxwv1Jx3AeQvD-4T_jX8E4Va4_1786463843
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Gao Xiang <xiang@kernel.org> writes:

> Hi Giuseppe,
>
> On Tue, Aug 11, 2026 at 09:10:51AM +0200, Giuseppe Scrivano wrote:
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
>
> Thanks for the patch.
>
> It generally looks good to me. Just some minor nits:
>
>> ---
>>  Documentation/filesystems/erofs.rst |  8 ++++
>>  fs/erofs/internal.h                 |  1 +
>>  fs/erofs/super.c                    | 58 +++++++++++++++++++++++++++--
>>  3 files changed, 64 insertions(+), 3 deletions(-)
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
>
> When superblock_share is specified, multiple mounts of the same backing
> file at the same fsoffset with compatible mount options can share a single
> superblock.  Remount is now allowed on shared superblocks.
>
>> +new one.  Remount is not allowed on shared superblocks.
>> +
>>  Sysfs Entries
>>  =============
>>  
>> diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
>> index 580f8d9f14e7..8d65cac35702 100644
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
>> index d40961248a49..72d654ce49b7 100644
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
>> @@ -663,6 +670,17 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
>>  		errorfc(fc, "FSDAX is not allowed when inode_share is on");
>>  		return -EINVAL;
>>  	}
>> +	if (test_opt(&sbi->opt, SUPERBLOCK_SHARE) &&
>> +	    test_opt(&sbi->opt, INODE_SHARE)) {
>> +		errorfc(fc, "superblock_share is not allowed when inode_share is on");
>> +		return -EINVAL;
>> +	}
>> +	/* Extra devices are not yet supported with superblock sharing.  */
>
> Okay, if the comment is added here, I don't think it's helpful since the
> error message indicates the same.
>
>> +	if (test_opt(&sbi->opt, SUPERBLOCK_SHARE) &&
>> +	    sbi->devs->extra_devices) {
>> +		errorfc(fc, "superblock_share does not support extra devices");
>> +		return -EINVAL;
>> +	}
>>  
>>  	sbi->blkszbits = PAGE_SHIFT;
>>  	if (!sb->s_bdev) {
>> @@ -788,6 +806,36 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
>>  	return 0;
>>  }
>>  
>
> Maybe just move the comment below here:
>
> /*
>  * The function is used only with a sbi that has SUPERBLOCK_SHARE set,
>  * so that the memcmp later ensures new_sbi is also shareable.
>  */
>
>> +static int erofs_fc_test_file_super(struct super_block *sb,
>
> Can we just rename it as erofs_sb_share_test_super()?
>
>> +				    struct fs_context *fc)
>> +{
>> +	/*
>> +	 * The assumption is that the function is used only with a sbi that
>> +	 * has SUPERBLOCK_SHARE set, so that the memcmp later ensures
>> +	 * new_sbi also is shareable.
>> +	 */
>> +	struct erofs_sb_info *sbi = EROFS_SB(sb);
>> +	struct erofs_sb_info *new_sbi = fc->s_fs_info;
>> +
>> +	if (sb->s_iflags & SB_I_RETIRED)
>> +		return 0;
>> +	if (!sbi->dif0.file || !new_sbi->dif0.file)
>> +		return 0;
>> +	return file_inode(sbi->dif0.file) == file_inode(new_sbi->dif0.file) &&
>> +	       sbi->dif0.fsoff == new_sbi->dif0.fsoff &&
>> +	       !memcmp(&sbi->opt, &new_sbi->opt, sizeof(sbi->opt));
>> +}
>> +
>> +static int erofs_fc_get_tree_file(struct fs_context *fc)
>
> Could we just rename it as erofs_file_get_tree()?

sure, thanks for the review.  I'll send another version later
today/tomorrow if there are no other comments.

Regards,
Giuseppe


