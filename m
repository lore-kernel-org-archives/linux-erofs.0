Return-Path: <linux-erofs+bounces-4087-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72163C55184
	for <linux-erofs@archiver.kernel.org>; Mon,  3 Aug 2026 11:24:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDDpQ60b2z30FB;
	Mon, 03 Aug 2026 21:24:14 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785756254;
	cv=none; b=Wi2UqKJNm9++54SviN2JI0z5GG9cPNVAScfo9VNFIdKXE99/FZ6yjGQz5hOz227keEOU/b6b6JxejYFXsGazw85w+YWol+BX8HeRdOhXgiuumngVzQGcJyblLUGJqekpuyS6UiKVdBeDZtS7o/svkLNspoI9Q2VJlHEUmFtX8sBUPKraMsK7+CXpNOrXgDvXuzxyWImtI/3gNTgPAYxDRCG2wyDC8L4fVOqF/PNz9EiVOHQek63di5nngySKPG6Ee5d+yrzr+74TbQHWZJhjtekPPg8LpZmZhOu64a5bpLoLfaSJWNz6kA1TwFDOeN26mFlk2qDrij43ROas61i3WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785756254; c=relaxed/relaxed;
	bh=a8jUYpGWRjKfK2pFbcsKSFyQNtwQ/7x9wAUlWuXO6ag=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QRh5Gh7HQowBd+c7W8Kq3z8xPLtjYPK64aPTXXYJShTjPzcdMtw1DSGKS4H9r+O44uX1bcs7m+c06SBNch8fJsMaVpCSPCOqxM9ttoRGDe3WIE12QVRC09fDWIjVHModbgSWWHqFbMY0NwGgATAn8zk2fac/zkak/tIZfd/IrDpFS8d1LyKL6JMX4gxDaMLSsaBi3nU8EqBUsLAsmZYqyC9v5FerYxLlJg5IZanT4NAaOFWWGVKhozT3U2a71tz2iuxvyC2jLQ21ldcVXeeYtD0EX2oTC4qlOmqmq6mKyG4kfgaAu3e07AEWARK7Qh3Sdw2Vm+jlQVbsykAif3TSNg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gzEH3Vn6; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gzEH3Vn6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hDDpP6x0Dz30DY
	for <linux-erofs@lists.ozlabs.org>; Mon, 03 Aug 2026 21:24:13 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 002D741A70;
	Mon,  3 Aug 2026 11:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788281F00A3A;
	Mon,  3 Aug 2026 11:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785756250;
	bh=a8jUYpGWRjKfK2pFbcsKSFyQNtwQ/7x9wAUlWuXO6ag=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=gzEH3Vn6SZXDmv67N+MhwViK2cjpIsBSX0aGOZ6ji+ufjITteyKwMvKPuByQ7c9SD
	 C71J+OmNx/37ev1jvBIkWxdhDqdTLjCSlveJKjZQRBnzJcOr2PNe2iwnW39ijeCMbw
	 UwlgCk4764m5+WVkyoY4nEW2dXpxX2fLxJYhVckc8MQxiT+JSzW6Ws5glBDtW4o3D9
	 FQd7VcQebeFyCuF15ydCR9PwzJpBxjr3kSz0Bjux/Q6gdJTPr5nztC9gkogcXiUqC7
	 bW+NjbcS+DE1pUvs0vQlEwjSIcGv0PvxVHc37qFANtsKkjDM9TZ0hJFqUPznscmLFQ
	 3UgZNNkTTsZYw==
Message-ID: <366a9c6b-ec56-4cdf-b373-22a3cd8c9beb@kernel.org>
Date: Mon, 3 Aug 2026 19:24:07 +0800
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
Cc: chao@kernel.org, cyphar@cyphar.com, hsiangkao@linux.alibaba.com,
 linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5] erofs: accept source file descriptor via fsconfig
To: Giuseppe Scrivano <gscrivan@redhat.com>, linux-erofs@lists.ozlabs.org
References: <20260728160619.853924-1-gscrivan@redhat.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260728160619.853924-1-gscrivan@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/26 00:05, Giuseppe Scrivano wrote:
> Allow userspace to pass an already-opened file descriptor as the mount
> source instead of a path string.  This is useful for tools that already
> hold an fd to the image, such as composefs reusing an existing erofs
> backing file.
> 
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
> ---
> v4: https://lore.kernel.org/linux-fsdevel/20260717134147.1602735-1-gscrivan@redhat.com/
> v3: https://lore.kernel.org/linux-fsdevel/20260714154917.489993-1-gscrivan@redhat.com/
> v2: https://lore.kernel.org/linux-fsdevel/20260711071137.4130824-1-gscrivan@redhat.com/
> v1: https://lore.kernel.org/linux-fsdevel/ak5GfvVfWLJU1EwK@debian/
> 
>   Documentation/filesystems/erofs.rst | 15 ++++++
>   fs/erofs/super.c                    | 73 ++++++++++++++++++++++++-----
>   2 files changed, 77 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/filesystems/erofs.rst b/Documentation/filesystems/erofs.rst
> index 4230884fb359..774e8b236d09 100644
> --- a/Documentation/filesystems/erofs.rst
> +++ b/Documentation/filesystems/erofs.rst
> @@ -139,6 +139,21 @@ inode_share            Enable inode page sharing for this filesystem.  Inodes wi
>                          page cache.
>   ===================    =========================================================
>   
> +File-backed mounts
> +==================
> +
> +When CONFIG_EROFS_FS_BACKED_BY_FILE is enabled, EROFS file-backed images
> +can be mounted directly without a loopback block device.  The backing file
> +can be given either as a path, or as an already-opened file descriptor.
> +
> +When a file descriptor is used, the kernel resolves its path and records it
> +so that /proc/mounts and similar interfaces can still report the mount
> +source.
> +
> +Only regular files are accepted as backing files; to mount an image that
> +resides on a block device, use the traditional block device mount path
> +instead.

Do we need to add an entry to describe the new mount option source= in
"Mount options" section in erofs.rst?

Thanks,

> +
>   Sysfs Entries
>   =============
>   
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index 86fa5c6a0c70..558041011398 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -386,6 +386,7 @@ static void erofs_default_options(struct erofs_sb_info *sbi)
>   enum {
>   	Opt_user_xattr, Opt_acl, Opt_cache_strategy, Opt_dax, Opt_dax_enum,
>   	Opt_device, Opt_domain_id, Opt_directio, Opt_fsoffset, Opt_inode_share,
> +	Opt_source,
>   };
>   
>   static const struct constant_table erofs_param_cache_strategy[] = {
> @@ -402,17 +403,18 @@ static const struct constant_table erofs_dax_param_enums[] = {
>   };
>   
>   static const struct fs_parameter_spec erofs_fs_parameters[] = {
> -	fsparam_flag_no("user_xattr",	Opt_user_xattr),
> -	fsparam_flag_no("acl",		Opt_acl),
> -	fsparam_enum("cache_strategy",	Opt_cache_strategy,
> +	fsparam_flag_no("user_xattr",		Opt_user_xattr),
> +	fsparam_flag_no("acl",			Opt_acl),
> +	fsparam_enum("cache_strategy",		Opt_cache_strategy,
>   		     erofs_param_cache_strategy),
> -	fsparam_flag("dax",             Opt_dax),
> -	fsparam_enum("dax",		Opt_dax_enum, erofs_dax_param_enums),
> -	fsparam_string("device",	Opt_device),
> -	fsparam_string("domain_id",	Opt_domain_id),
> -	fsparam_flag_no("directio",	Opt_directio),
> -	fsparam_u64("fsoffset",		Opt_fsoffset),
> -	fsparam_flag("inode_share",	Opt_inode_share),
> +	fsparam_flag("dax",			Opt_dax),
> +	fsparam_enum("dax",			Opt_dax_enum, erofs_dax_param_enums),
> +	fsparam_string("device",		Opt_device),
> +	fsparam_string("domain_id",		Opt_domain_id),
> +	fsparam_flag_no("directio",		Opt_directio),
> +	fsparam_u64("fsoffset",			Opt_fsoffset),
> +	fsparam_flag("inode_share",		Opt_inode_share),
> +	fsparam_file_or_string("source",	Opt_source),
>   	{}
>   };
>   
> @@ -437,6 +439,40 @@ static bool erofs_fc_set_dax_mode(struct fs_context *fc, unsigned int mode)
>   	return false;
>   }
>   
> +static int erofs_fc_parse_source(struct fs_context *fc,
> +				 struct fs_parameter *param)
> +{
> +	struct erofs_sb_info *sbi = fc->s_fs_info;
> +
> +	if (fc->source || sbi->dif0.file)
> +		return invalf(fc, "Multiple sources");
> +
> +	switch (param->type) {
> +	case fs_value_is_string:
> +		fc->source = param->string;
> +		param->string = NULL;
> +		return 0;
> +	case fs_value_is_file: {
> +		char *buf __free(kfree) = kmalloc(PATH_MAX, GFP_KERNEL);
> +		char *p;
> +
> +		if (!buf)
> +			return -ENOMEM;
> +		p = file_path(param->file, buf, PATH_MAX);
> +		if (IS_ERR(p))
> +			return PTR_ERR(p);
> +		fc->source = kstrdup(p, GFP_KERNEL);
> +		if (!fc->source)
> +			return -ENOMEM;
> +		sbi->dif0.file = no_free_ptr(param->file);
> +		return 0;
> +	}
> +	default:
> +		WARN_ON_ONCE(true);
> +		return -EINVAL;
> +	}
> +}
> +
>   static int erofs_fc_parse_param(struct fs_context *fc,
>   				struct fs_parameter *param)
>   {
> @@ -524,6 +560,8 @@ static int erofs_fc_parse_param(struct fs_context *fc,
>   		else
>   			set_opt(&sbi->opt, INODE_SHARE);
>   		break;
> +	case Opt_source:
> +		return erofs_fc_parse_source(fc, param);
>   	}
>   	return 0;
>   }
> @@ -752,13 +790,26 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
>   
>   static int erofs_fc_get_tree(struct fs_context *fc)
>   {
> +	struct erofs_sb_info *sbi = fc->s_fs_info;
>   	int ret;
>   
> +	if (sbi->dif0.file) {
> +		if (!IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE)) {
> +			errorfc(fc, "source fd option not supported");
> +			return -EINVAL;
> +		}
> +		if (!S_ISREG(file_inode(sbi->dif0.file)->i_mode) ||
> +		    !sbi->dif0.file->f_mapping->a_ops->read_folio) {
> +			errorfc(fc, "source is unsupported");
> +			return -EINVAL;
> +		}
> +		return get_tree_nodev(fc, erofs_fc_fill_super);
> +	}
> +
>   	ret = get_tree_bdev_flags(fc, erofs_fc_fill_super,
>   		IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) ?
>   			GET_TREE_BDEV_QUIET_LOOKUP : 0);
>   	if (IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) && ret == -ENOTBLK) {
> -		struct erofs_sb_info *sbi = fc->s_fs_info;
>   		struct file *file;
>   
>   		if (!fc->source)


