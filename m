Return-Path: <linux-erofs+bounces-4194-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48759C5B572
	for <linux-erofs@archiver.kernel.org>; Tue, 11 Aug 2026 15:32:04 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hKFwf25qfz2yyJ;
	Wed, 12 Aug 2026 01:32:02 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786462322;
	cv=none; b=bFPIv+EfhLcOnrg15/SA+KA9hLXmC/A8Per9r+vFM0spdmyJE2n5ePjVw1Jz6065yIKq63yAx0yaWiaQNKqsqfemqTMPgTBXxU1LBPCgnCPwdZ86IN/piRb1q0Zbv+R9/4tLph6NGNpsKBpMFb5UTYacorSgPzC992OE1KYPOCBCKALEptWi7OCZcEjPSLyHhUeKeV1IJ3hWmdJLQE/C20NzzUHIivTbF74RN5vi9M8117bh4qADTm9PL4RRKDF6fZ/ntGEQ00uYS6d0yxBneVB1QAB9UkePKbc6dK/4jVXAV9eP5amx6qBhvsMHR1ZI6DpqjP1WhIk+FulwiCjffw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786462322; c=relaxed/relaxed;
	bh=8NCjoWCKD79x4yksCp0pUGr3DDto2NgOkys/lZwlwug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FB2XGbQR1ckBJW36XCyFOWsSB5EjrI5d2BqQETUBwS7Q0s1v17F9y+k4YaUGAKc0sEBcrD340xkwfzYSGH8nzLG5G8D9be3GGyOjt7RN3EstSJpFoN6s+Ifc2UQ6hLZ9OoklnzFNrBgEQaiV9IgTO200bNKMYiobZeYCDkg5jlVeFRtrckaAJF+ZsISY2vOrbRD1TzCdo+H+YkvdplobJ7RDS9HPYMwrETuiJjdk0G/JtYSc8c1cRcOsf8XTEZLRhT4cMbuyPqye27XOW8I78txJRxxRsWNKqJLAVygj8scPsrab/tvTEevPL6X1zY4uvUVEX1K0ys7Yh+PvduCM+g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YbmEBnrs; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YbmEBnrs;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hKFwb5fr3z2yrC
	for <linux-erofs@lists.ozlabs.org>; Wed, 12 Aug 2026 01:31:59 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C0A57600AD;
	Tue, 11 Aug 2026 15:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215711F000E9;
	Tue, 11 Aug 2026 15:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786462316;
	bh=8NCjoWCKD79x4yksCp0pUGr3DDto2NgOkys/lZwlwug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YbmEBnrsvGvja98VQQ6cvVGUIqsEaXlKUgF511HLSsyTsmrsLfxnhsbW3tdNe5WO+
	 xGfnvse3SRgYzxrFZy/Fzxx4/0x1cIc3rMlx3rhR0gUSBlAHD3Ng8SDoFn+U42j5Z4
	 pNXUvz6EgZLvTOSGVjfvNEfdsi2O3tPWRNFWDpClU9/90eJwRqdkXkvra5S2f/RhlJ
	 RFPlnJmPU50licfJ+rktCQqoh/NDntWsqVGwl/plDBx/BxDHC+zBmCGCWKpxy5sDi+
	 JsrVWDWppEApcBlpyCtflhzGyx0S7yA8Ss9c/N4dj/oh8dYV7mk5TzWGYZizwDZGqO
	 f8DfNP99las4g==
Date: Tue, 11 Aug 2026 23:31:46 +0800
From: Gao Xiang <xiang@kernel.org>
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org,
	linux-fsdevel@vger.kernel.org, amir73il@gmail.com,
	brauner@kernel.org
Subject: Re: [PATCH v5 2/2] erofs: reuse superblock for file-backed mounts
Message-ID: <antAYlH-bZ2NQWCR@XiangdeMacBook-Pro.local>
Mail-Followup-To: Giuseppe Scrivano <gscrivan@redhat.com>,
	linux-erofs@lists.ozlabs.org, xiang@kernel.org,
	linux-fsdevel@vger.kernel.org, amir73il@gmail.com,
	brauner@kernel.org
References: <20260811071241.389589-1-gscrivan@redhat.com>
 <20260811071241.389589-3-gscrivan@redhat.com>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260811071241.389589-3-gscrivan@redhat.com>

Hi Giuseppe,

On Tue, Aug 11, 2026 at 09:10:51AM +0200, Giuseppe Scrivano wrote:
> When the same file-backed image is mounted multiple times (via path or
> fd) with the superblock_share mount option, reuse the existing
> superblock instead of creating a new one.  This allows multiple mounts
> of the same image to share in-kernel data structures more efficiently.
> 
> The backing file is identified by its inode and fsoffset.  If mount
> options conflict or extra devices are used, a separate superblock
> is created transparently as a fallback.  Remount is not allowed on
> shared superblocks.
> 
> Tested by mounting a 177M Fedora EROFS image 20 times with full
> traversal:
> 
>   #!/bin/sh
>   IMG=${1:-/root/fedora.erofs}
>   OPTS=${2:+-o $2}
>   N=20
>   DIR=$(mktemp -d)
>   trap "umount $DIR/m* 2>/dev/null; rm -rf $DIR" EXIT
> 
>   sync; echo 3 > /proc/sys/vm/drop_caches
>   INODES_BEFORE=$(grep erofs_inode /proc/slabinfo | awk '{print $2}')
>   MEM_BEFORE=$(grep ^Slab: /proc/meminfo | awk '{print $2}')
> 
>   for i in $(seq 1 $N); do
>       mkdir $DIR/m$i
>       mount -t erofs $OPTS "$IMG" $DIR/m$i
>       find $DIR/m$i > /dev/null
>   done
> 
>   echo "Superblocks: $(grep $DIR /proc/self/mountinfo | \
>       awk '{print $3}' | sort -u | wc -l)"
>   echo "erofs_inode delta: +$(( $(grep erofs_inode /proc/slabinfo | \
>       awk '{print $2}') - INODES_BEFORE ))"
>   echo "Slab delta: +$(( $(grep ^Slab: /proc/meminfo | \
>       awk '{print $2}') - MEM_BEFORE )) kB"
> 
> without superblock_share:
> 
>   # time ./test.sh /root/fedora.erofs
>   Superblocks: 20
>   erofs_inode delta: +45864
>   Slab delta: +37448 kB
>   real	0m2.311s
>   user	0m0.222s
>   sys	0m1.998s
> 
> with superblock_share:
> 
>   # time ./test.sh /root/fedora.erofs superblock_share
>   Superblocks: 1
>   erofs_inode delta: +2044
>   Slab delta: +284 kB
>   real	0m0.679s
>   user	0m0.157s
>   sys	0m0.469s
> 
> The time difference shows that sharing the superblock also benefits
> the page cache and inode cache, as subsequent mounts of the same image
> avoid re-reading the backing file.  This is particularly useful for
> container hosts running multiple containers from the same base image.
> 
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>

Thanks for the patch.

It generally looks good to me. Just some minor nits:

> ---
>  Documentation/filesystems/erofs.rst |  8 ++++
>  fs/erofs/internal.h                 |  1 +
>  fs/erofs/super.c                    | 58 +++++++++++++++++++++++++++--
>  3 files changed, 64 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/filesystems/erofs.rst b/Documentation/filesystems/erofs.rst
> index d301d9ac946a..49c4e7dbc5d6 100644
> --- a/Documentation/filesystems/erofs.rst
> +++ b/Documentation/filesystems/erofs.rst
> @@ -139,6 +139,9 @@ inode_share            Enable inode page sharing for this filesystem.  Inodes wi
>                         page cache.
>  source=%s              (For file-backed mounts) Specify the backing image as a path
>                         or as an already-opened file descriptor.
> +superblock_share       (For file-backed mounts) Share the superblock when the same
> +                       backing file is mounted more than once with compatible
> +                       options.  Remount is not allowed on shared superblocks.
>  ===================    =========================================================
>  
>  File-backed mounts
> @@ -156,6 +159,11 @@ Only regular files are accepted as backing files; to mount an image that
>  resides on a block device, use the traditional block device mount path
>  instead.
>  
> +When superblock_share is specified and the same backing file (identified
> +by inode and fsoffset) is mounted more than once with compatible mount
> +options, the kernel reuses the existing superblock instead of creating a

When superblock_share is specified, multiple mounts of the same backing
file at the same fsoffset with compatible mount options can share a single
superblock.  Remount is now allowed on shared superblocks.

> +new one.  Remount is not allowed on shared superblocks.
> +
>  Sysfs Entries
>  =============
>  
> diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
> index 580f8d9f14e7..8d65cac35702 100644
> --- a/fs/erofs/internal.h
> +++ b/fs/erofs/internal.h
> @@ -156,6 +156,7 @@ struct erofs_sb_info {
>  #define EROFS_MOUNT_DAX_NEVER		0x00000080
>  #define EROFS_MOUNT_DIRECT_IO		0x00000100
>  #define EROFS_MOUNT_INODE_SHARE		0x00000200
> +#define EROFS_MOUNT_SUPERBLOCK_SHARE	0x00000400
>  
>  #define clear_opt(opt, option)	((opt)->mount_opt &= ~EROFS_MOUNT_##option)
>  #define set_opt(opt, option)	((opt)->mount_opt |= EROFS_MOUNT_##option)
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index d40961248a49..72d654ce49b7 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -386,7 +386,7 @@ static void erofs_default_options(struct erofs_sb_info *sbi)
>  enum {
>  	Opt_user_xattr, Opt_acl, Opt_cache_strategy, Opt_dax, Opt_dax_enum,
>  	Opt_device, Opt_domain_id, Opt_directio, Opt_fsoffset, Opt_inode_share,
> -	Opt_source,
> +	Opt_source, Opt_superblock_share,
>  };
>  
>  static const struct constant_table erofs_param_cache_strategy[] = {
> @@ -415,6 +415,7 @@ static const struct fs_parameter_spec erofs_fs_parameters[] = {
>  	fsparam_u64("fsoffset",			Opt_fsoffset),
>  	fsparam_flag("inode_share",		Opt_inode_share),
>  	fsparam_file_or_string("source",	Opt_source),
> +	fsparam_flag("superblock_share",	Opt_superblock_share),
>  	{}
>  };
>  
> @@ -560,6 +561,12 @@ static int erofs_fc_parse_param(struct fs_context *fc,
>  		else
>  			set_opt(&sbi->opt, INODE_SHARE);
>  		break;
> +	case Opt_superblock_share:
> +		if (!IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE))
> +			errorfc(fc, "%s option not supported", erofs_fs_parameters[opt].name);
> +		else
> +			set_opt(&sbi->opt, SUPERBLOCK_SHARE);
> +		break;
>  	case Opt_source:
>  		return erofs_fc_parse_source(fc, param);
>  	}
> @@ -663,6 +670,17 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
>  		errorfc(fc, "FSDAX is not allowed when inode_share is on");
>  		return -EINVAL;
>  	}
> +	if (test_opt(&sbi->opt, SUPERBLOCK_SHARE) &&
> +	    test_opt(&sbi->opt, INODE_SHARE)) {
> +		errorfc(fc, "superblock_share is not allowed when inode_share is on");
> +		return -EINVAL;
> +	}
> +	/* Extra devices are not yet supported with superblock sharing.  */

Okay, if the comment is added here, I don't think it's helpful since the
error message indicates the same.

> +	if (test_opt(&sbi->opt, SUPERBLOCK_SHARE) &&
> +	    sbi->devs->extra_devices) {
> +		errorfc(fc, "superblock_share does not support extra devices");
> +		return -EINVAL;
> +	}
>  
>  	sbi->blkszbits = PAGE_SHIFT;
>  	if (!sb->s_bdev) {
> @@ -788,6 +806,36 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
>  	return 0;
>  }
>  

Maybe just move the comment below here:

/*
 * The function is used only with a sbi that has SUPERBLOCK_SHARE set,
 * so that the memcmp later ensures new_sbi is also shareable.
 */

> +static int erofs_fc_test_file_super(struct super_block *sb,

Can we just rename it as erofs_sb_share_test_super()?

> +				    struct fs_context *fc)
> +{
> +	/*
> +	 * The assumption is that the function is used only with a sbi that
> +	 * has SUPERBLOCK_SHARE set, so that the memcmp later ensures
> +	 * new_sbi also is shareable.
> +	 */
> +	struct erofs_sb_info *sbi = EROFS_SB(sb);
> +	struct erofs_sb_info *new_sbi = fc->s_fs_info;
> +
> +	if (sb->s_iflags & SB_I_RETIRED)
> +		return 0;
> +	if (!sbi->dif0.file || !new_sbi->dif0.file)
> +		return 0;
> +	return file_inode(sbi->dif0.file) == file_inode(new_sbi->dif0.file) &&
> +	       sbi->dif0.fsoff == new_sbi->dif0.fsoff &&
> +	       !memcmp(&sbi->opt, &new_sbi->opt, sizeof(sbi->opt));
> +}
> +
> +static int erofs_fc_get_tree_file(struct fs_context *fc)

Could we just rename it as erofs_file_get_tree()?

Thanks,
Gao Xiang

