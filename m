Return-Path: <linux-erofs+bounces-4061-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90542C5516D
	for <linux-erofs@archiver.kernel.org>; Fri, 31 Jul 2026 13:12:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hBRLV5Lmqz2y1F;
	Fri, 31 Jul 2026 23:12:18 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785503538;
	cv=none; b=ad9G59EltiYWcaEYTdoaOEqBikduGH5O5QUPvqB8imndsKbvx0fWZuaTKjLhL5NBvKVAd8MA4+2tvvw4WnUhtpeTrAcJk4MHs7jk0TgIljDgmPm6Bm7UGjHrHz6PkA69n77f/aKRiwZHZl0T3GUj+zl0EJdEVO4FfResSj1/Io5Kh4RyBAa+6RtXzNpuDUSlt5jZ1Nufr5Y7s1d9ZkGA0VWI+oNyj1CvS5mdPar3d5k3ciAm4oSeSI1SlEoqjmyExy/qTMnwM5hgwA1vgSXY/yO/NluSVq24/MuZEckO5iD6co9IA6LXUQxlrGxVnFlFaeWbsQmJm4af/j6SXw6FbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785503538; c=relaxed/relaxed;
	bh=T9yL5DoFqpaEaIWJfOP8SImbLZJq6mXfiaoKm7/mmaM=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=HN6ww3suQX106c/oaes1hCv3WH9uloy+wgmvmrtPqAt4jTBMAEA+I03fyLAcTkw/32t5rZL1jpl685c7a9j19nSUfxRLONIkfr7/4Hvsv4CRiCzIp3Q3FmpsYqFfxrJ4YJeeXxrMj6cEykDM/YsXiiT5KLQtPOmQnx2j6nFW873T01yZCXlE2tjOoDMk/SmXij5LIBzl9/OX1WCSKSk2s6JCzrja9aX1SrwdpBJynjhd4628h6tTu24+a8QZ4jqnbb88ky60NaiQC3iLC6pZ71CFPOH0UtpWiwRFiEI6HF+L10HO91N2ZWFpYdQ1iIUruyKVhJX6XBTBATU5zSIWpw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fau+q9AA; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fau+q9AA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hBRLT50yhz2xl5
	for <linux-erofs@lists.ozlabs.org>; Fri, 31 Jul 2026 23:12:17 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 343844165B;
	Fri, 31 Jul 2026 13:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC5D1F000E9;
	Fri, 31 Jul 2026 13:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785503535;
	bh=T9yL5DoFqpaEaIWJfOP8SImbLZJq6mXfiaoKm7/mmaM=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=fau+q9AAQyBLcZ6SIjkPd5AP7t8Hg6LtSlQnQPiG7fdq/YIhKSuM4yJzfG/DaMwRo
	 paFthI1OHhbKg17nw7/Rp/lgCtyiAT1ZWakDMMePj4S7cyoAXUfLJynR6lnQPQrnDb
	 B0RJyJLJclXIdYr6T4F5enK05L8604mJ4ee01/YQqfm8wTg76N7ZbfEViFmRoNLCpk
	 JLLs1cfiR19AhOCsImOpfdaJauOCaZ4ea/H7KrP5gQen1xjuRI8rPyOu4fXDzppA8A
	 wU7gw5OlfqP+yLBYFnd9pumyuRhyzvajr7Wd63RI/w/ASmA00hAcxQp8P39PK6tZLZ
	 dYHYMCH5q9yjA==
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
Subject: Re: [PATCH] erofs: reuse superblock for file-backed mounts
From: Christian Brauner <brauner@kernel.org>
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>, linux-erofs@lists.ozlabs.org, 
 xiang@kernel.org, linux-fsdevel@vger.kernel.org, amir73il@gmail.com
In-Reply-To: <87fr10h2wh.fsf@redhat.com>
References: <20260730124120.1501126-1-gscrivan@redhat.com>
 <amtJX8aTZT5d_sP3@pedro-suse.lan> <8733x0k2p1.fsf@redhat.com>
 <87fr10h2wh.fsf@redhat.com>
Date: Fri, 31 Jul 2026 15:12:11 +0200
Message-Id: <20260731-geeilt-hasen-demografie-83c895f789ea@brauner>
X-Mailer: b4 0.16-dev-af865
X-Developer-Signature: v=1; a=openpgp-sha256; l=4917; i=brauner@kernel.org;
 h=from:subject:message-id; bh=9L9LseLRGFspLwtIxCfLJtD/TRM++qr9LmTL9fHk66U=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTlzNcNn7sswO329KbavLVVadyHNZPyHVac25Ej+8/hi
 K3QjEb2jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIl0pTAyPEhn0yo8vNNby6hn
 +RL/tlsP0rQ9Us6FJii9OSEh9kWonpHhxZyqwIQVz697XNDjDPC9yv1TNUF4W9bEqPYnF7w2cac
 yAwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

> >>> The time difference shows that sharing the superblock also benefits
> >>> the page cache and inode cache, as subsequent mounts of the same image
> >>> avoid re-reading the backing file.  This is particularly useful for
> >>> container hosts running multiple containers from the same base image.
> >>
> >> Doesn't this approach break-down as soon as you get to change SB flags (through
> >> e.g mount -o remount)? It will change superblock flags for all of them, right?
> >>
> >> (I don't think you can switch off the superblock transparently on a
> >> reconfigure?)
> >
> > This is the same preexisting behavior for block device mounts.  That

Yeah, and it sucks ass. :)
Only an incompatible vfs-level RO/RW property causes a silent reuse to
fail. Otherwise it not possible to detect that a superblock has been
created and requested mount options silently ignore.

In other words, doing this unconditionally is incompatible with current
userspace.

Btw, I added FSCONFIG_CMD_CREATE_EXCL for this reason which refuses to
reuse an existing superblock for filesystems that would otherwise end up
sharing a superblock. This way userspace is guaranteed to not silently
get filesystem options ignored.

> > said, I realize this can feel confusing since EROFS is not a block
> > device and allowed this so far.
> >
> > One way to solve this could be an explicit mount option "share_sb" that
> > is opt-in and, once set, blocks any remount operations.  Would that
> > work?
> 
> Would something like the following fixup on top of the previous patch be
> acceptable (suggestions for better names are welcome)?

The patch as written still means that a task A creates a new erofs mount
with for file F and marks it as shared. Another task B creates new erofs
mount expecting to get a new superblock and will end up sharing it with
task A instead.

That is still quite the behavior change and could be used to subvert
workloads expectations and be used in (odd) attacks.

So if you want sb-sharing you need it to be an admin-level setting or
you need to make it a domain the same way page cache sharing for erofs
is a domain. IOW, only task that mount with the same domain end up
sharing superblocks. Or it's a global setting.

But doing it this way seems problematic to me.

> Thanks,
> Giuseppe
> 
> diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
> index 580f8d9f14e7..ac26daf4f78a 100644
> --- a/fs/erofs/internal.h
> +++ b/fs/erofs/internal.h
> @@ -156,6 +156,7 @@ struct erofs_sb_info {
>  #define EROFS_MOUNT_DAX_NEVER		0x00000080
>  #define EROFS_MOUNT_DIRECT_IO		0x00000100
>  #define EROFS_MOUNT_INODE_SHARE		0x00000200
> +#define EROFS_MOUNT_SHARE_SB		0x00000400
>  
>  #define clear_opt(opt, option)	((opt)->mount_opt &= ~EROFS_MOUNT_##option)
>  #define set_opt(opt, option)	((opt)->mount_opt |= EROFS_MOUNT_##option)
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index cbd76727f0d3..dd2a351811c8 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -386,7 +386,7 @@ static void erofs_default_options(struct erofs_sb_info *sbi)
>  enum {
>  	Opt_user_xattr, Opt_acl, Opt_cache_strategy, Opt_dax, Opt_dax_enum,
>  	Opt_device, Opt_domain_id, Opt_directio, Opt_fsoffset, Opt_inode_share,
> -	Opt_source,
> +	Opt_source, Opt_share_sb,
>  };
>  
>  static const struct constant_table erofs_param_cache_strategy[] = {
> @@ -414,6 +414,7 @@ static const struct fs_parameter_spec erofs_fs_parameters[] = {
>  	fsparam_flag_no("directio",		Opt_directio),
>  	fsparam_u64("fsoffset",			Opt_fsoffset),
>  	fsparam_flag("inode_share",		Opt_inode_share),
> +	fsparam_flag("share_sb",		Opt_share_sb),
>  	fsparam_file_or_string("source",	Opt_source),
>  	{}
>  };
> @@ -560,6 +561,12 @@ static int erofs_fc_parse_param(struct fs_context *fc,
>  		else
>  			set_opt(&sbi->opt, INODE_SHARE);
>  		break;
> +	case Opt_share_sb:
> +		if (!IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE))
> +			errorfc(fc, "%s option not supported", erofs_fs_parameters[opt].name);
> +		else
> +			set_opt(&sbi->opt, SHARE_SB);
> +		break;
>  	case Opt_source:
>  		return erofs_fc_parse_source(fc, param);
>  	}
> @@ -798,6 +805,8 @@ static int erofs_fc_test_file_super(struct super_block *sb,
>  		return 0;
>  	if (!sbi->dif0.file || !new_sbi->dif0.file)
>  		return 0;
> +	if (!test_opt(&new_sbi->opt, SHARE_SB))
> +		return 0;
>  	return file_inode(sbi->dif0.file) == file_inode(new_sbi->dif0.file) &&
>  	       sbi->dif0.fsoff == new_sbi->dif0.fsoff &&
>  	       sbi->opt.mount_opt == new_sbi->opt.mount_opt &&
> @@ -874,6 +883,9 @@ static int erofs_fc_reconfigure(struct fs_context *fc)
>  
>  	DBG_BUGON(!sb_rdonly(sb));
>  
> +	if (test_opt(&sbi->opt, SHARE_SB))
> +		return -EBUSY;
> +
>  	if (new_sbi->domain_id)
>  		erofs_info(sb, "ignoring reconfiguration for domain_id.");
>  
> 
> 
> 



