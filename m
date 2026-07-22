Return-Path: <linux-erofs+bounces-3983-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D078C44532
	for <linux-erofs@archiver.kernel.org>; Wed, 22 Jul 2026 16:11:30 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h4zlN75Frz2ygG;
	Thu, 23 Jul 2026 02:11:28 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784736688;
	cv=none; b=g+v28WIeuU1d98Rc+R2d8DfzOyxSSOwiHOb1geKwVbaeHstdYgCFpBp1hAlnrYjQZs5yAlBsiR5WSGjHg4FRzU2N5CVFbAAA5HvD1uLPCR74oAIpRpdX86UuEMrq03So0HDXxJQ49JMX1kPrYtAFk6khiBoRAJO97JLGrifK2dRPvU5AtMex7TGWzQiJ8p7bj8BmtmNyhBeQv3OIvyX4W8L6p8KCXmHza7IEsu4qzPbR66Cuc1pHHDLzHnOzzvfV23bF/4gyLB8iX0pMLjGML3vOb15NqIrZ3Tvr11aZKEqEOUYUDYkCcJFUFmk62AcoBgrPOYhSjLV/W7Qx188Uag==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784736688; c=relaxed/relaxed;
	bh=jmHOO8v3CjZ5peztUGfvRfYjk+5pWRJPqeU2hb9jJx4=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=We8kp2U1u/Nno1DdtrE3smsgOyYD3c1/MyuLnDHd/m1vwsBGeADdb+IAMrTo/AnhMHevigPlVfaE1yKI3Twah2zDxlFIipThbPo2JRJx4euKYn5w+eKMAfJuCmfnZ2cfLMZSPLWBm44VECUjMWdk/o9BEpqqyYnXEAVQTtPc/nm9CvAhGWIwMTMvklg9DCNM20HZVlYEZTXVdTqWsXaJf8QZo2KTN6fA/8zhGJmguk2yT++OxRN9pV0KeAYmfw6RC5erCTaw+mlFqhx70ztsd1u5hQvI6LEeFjkOtZxp7QHGILIROicI8/2ZoiLt3+INkBlmrRTFwWPFSRlFKrIraA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LbKIQEfT; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LbKIQEfT;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h4zlN08j5z2yfy
	for <linux-erofs@lists.ozlabs.org>; Thu, 23 Jul 2026 02:11:27 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B5A21600AB;
	Wed, 22 Jul 2026 16:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB5B1F000E9;
	Wed, 22 Jul 2026 16:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784736685;
	bh=jmHOO8v3CjZ5peztUGfvRfYjk+5pWRJPqeU2hb9jJx4=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=LbKIQEfT2gSW4QmLwR/8F5ki5U3lQ1iiqHh8Xy265hP8SEYfBVV6PJT9LXTE6nSre
	 Ard8+7vhFaY/Kl2Se+aphCwKgHZiW0eWrs3QhEWbYJXL2fHSs0IAnTffNlmbYZX9YR
	 NzrpXtubZZtcaOlWC6BtZR0EVCTZAwZQk2VkaXd5SgDS0YHVcgzmd1E7PDBS/bOTt1
	 17+56HwJ6CJ4brnf96x9+hT0p3noiC5CMjDyOMSlNchBZhePmIUEs+DfEZgKljM0cQ
	 esakOxndyVmU+Pkr2gJHciMaz7Y/AxBN5igGNYGmQOvBWYS6Cq108KWuLqIf8NayY3
	 tcCktPp395JYg==
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4] erofs: accept source file descriptor via fsconfig
From: Christian Brauner <brauner@kernel.org>
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: linux-erofs@lists.ozlabs.org, cyphar@cyphar.com, 
 hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org
In-Reply-To: <20260717134147.1602735-1-gscrivan@redhat.com>
References: <20260717134147.1602735-1-gscrivan@redhat.com>
Date: Wed, 22 Jul 2026 18:11:20 +0200
Message-Id: <20260722-notnagel-allemal-kampfsport-8fd4e4d98a15@brauner>
X-Mailer: b4 0.16-dev-2f6f2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4466; i=brauner@kernel.org;
 h=from:subject:message-id; bh=8Dv3XbgnBSjLrbgy91j9aliSmIHevpMj/hTUlGCzSoo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQlvF79ydNx+fnWBDXmGc/+7eXJams5fmRu/1KWSd/z0
 r4n7Tth0lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRdUYMfwXmPiwLLr27KuqU
 xsxlZ1r6/p9aqhd7uMqgfkXcvJvPp/EyMvw91KT8fNcmpg1JKgFustc83DbcKp5k93bTMubAvb5
 7zTgA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

> Allow userspace to pass an already-opened file descriptor as the mount
> source instead of a path string.  This is useful for tools that already
> hold an fd to the image, such as composefs reusing an existing erofs
> backing file.
> 
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
>
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index 9d8f862f309f..bc55be84d945 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -386,6 +386,7 @@ static void erofs_default_options(struct erofs_sb_info *sbi)
>  enum {
>  	Opt_user_xattr, Opt_acl, Opt_cache_strategy, Opt_dax, Opt_dax_enum,
>  	Opt_device, Opt_domain_id, Opt_directio, Opt_fsoffset, Opt_inode_share,
> +	Opt_source,
>  };
>  
>  static const struct constant_table erofs_param_cache_strategy[] = {
> @@ -402,17 +403,18 @@ static const struct constant_table erofs_dax_param_enums[] = {
>  };
>  
>  static const struct fs_parameter_spec erofs_fs_parameters[] = {
> -	fsparam_flag_no("user_xattr",	Opt_user_xattr),
> -	fsparam_flag_no("acl",		Opt_acl),
> -	fsparam_enum("cache_strategy",	Opt_cache_strategy,
> +	fsparam_flag_no("user_xattr",		Opt_user_xattr),
> +	fsparam_flag_no("acl",			Opt_acl),
> +	fsparam_enum("cache_strategy",		Opt_cache_strategy,
>  		     erofs_param_cache_strategy),
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
>  	{}
>  };
>  
> @@ -437,6 +439,40 @@ static bool erofs_fc_set_dax_mode(struct fs_context *fc, unsigned int mode)
>  	return false;
>  }
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

Afaict this is just fsparam_file_or_string()?

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

Hm, hm, hm... How is that reliable? So iirc this is then passed to:

static int erofs_fc_get_tree(struct fs_context *fc)
{
	int ret;

	ret = get_tree_bdev_flags(fc, erofs_fc_fill_super,
		IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) ?
			GET_TREE_BDEV_QUIET_LOOKUP : 0);
	if (IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) && ret == -ENOTBLK) {
		struct erofs_sb_info *sbi = fc->s_fs_info;
		struct file *file;

		if (!fc->source)
			return invalf(fc, "No source specified");
		file = filp_open(fc->source, O_RDONLY | O_LARGEFILE, 0);
		if (IS_ERR(file))
			return PTR_ERR(file);
		sbi->dif0.file = file;

		if (S_ISREG(file_inode(sbi->dif0.file)->i_mode) &&
		    sbi->dif0.file->f_mapping->a_ops->read_folio)
			return get_tree_nodev(fc, erofs_fc_fill_super);
	}
	return ret;
}

which then reopens the file or looks up the block device. So the only
way this is _vaguely_ (and really _very vaguely_) safe is if userspace
keeps at least the file descriptor open until the filesystem has been
mounted.

If they close it before this means you can mount something completely
different. The other thing is even if they keep the fd open someone
could just rename the damn thing and fc->source ends up pointing
somwhere completely different. The could switch namespaces as well in
some circumstances and then it points again into wherever.

I've played with that fd idea before. The only way to make this work
correctly is if you plumb this down into get_tree_nodev()

-- 


