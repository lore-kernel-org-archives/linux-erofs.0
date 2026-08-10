Return-Path: <linux-erofs+bounces-4153-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC31CC5AE49
	for <linux-erofs@archiver.kernel.org>; Mon, 10 Aug 2026 13:34:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hJbMb1L3Gz2ysb;
	Mon, 10 Aug 2026 23:34:35 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786368875;
	cv=none; b=eY0+/wCZz5ZkBEBinPiPjdmrwynH9R9nknEwvv1kYA15vi+cG9qUuWgmWOc7MONVfTSNlOmjorP8Vql8XOfrv8CfKWNszzJ0QSEv0SyQktZMHa/Itxf1BXApv7gWejjI4FFKfpK7gGNQUZntaGS3jQExURDHq2lpg7iu/1WkHPpz/H31dQqtJTQvM6P/LY+UKNBHi+Lif7qwqP1ZlLn0UFUvPd5Hm0yPFlm9Y7pUhEMBj/pM8E2EuGdqk2Vb0g5DEZkB26qSssj39zucAyU6QLZQGaq2QRP/GuRxvBzpRwOcirOQ+/j+7tL2opwMcJCxSMWFZs7tEXJLSCqYY1ot6w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786368875; c=relaxed/relaxed;
	bh=kR71C2Ubt4WiR9h4PtQLeumpWbg0KGu8uex6hXcc5F8=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=RTGBgRPFzpgZPUF+VLAU8dyhJTx4t2JTtmggYSHmGlDaD53k258Az+IjVojiGxmxCrgR7erBsIJbIfW2X1SpPTutqpiPG42MpaIEMyvKwUxn8kUBygNknK22z59Ayg8k4Y5EYXOg/8T0TLFM0QWl3Ru5kj8h4PIissiSscvC77d+W4TikyQvSRHdw3MDCrG+EGqkwBlPwMmVR3rz1Ot5IUVFDXGbjwNlDHGcbY9Mlr61U4NJtsju7hp9zYQ4l9AtYfKRS0W8BJkHj4STSLdZratXGTqOOZigTogAXjpyUtYpz//taKTrCxhdZC/99YvDjlZQFgUBLesXapa7H6czkA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IqRS9D6q; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IqRS9D6q;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hJbMY2Zbzz2yMD
	for <linux-erofs@lists.ozlabs.org>; Mon, 10 Aug 2026 23:34:33 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 32030403BC;
	Mon, 10 Aug 2026 13:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1911F000E9;
	Mon, 10 Aug 2026 13:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786368865;
	bh=kR71C2Ubt4WiR9h4PtQLeumpWbg0KGu8uex6hXcc5F8=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=IqRS9D6qpUfWNnkV9VTBBzgON+P3tW+KcBrnf+wQTQ6ukR6YPy01PhLjQcnvRzm0y
	 8soQIABwHT2TaeXnI4OLCHmZ7xSNOktylxg+DQdt7ycfSLTUTqkynp00UZb7k968g0
	 o6r2HjhdatJ4LDdd3l7H46PSL0gptZOipwXU08hQNH51MiEMCVZCiYL7Xz7yiMgCU+
	 2KZADKZicvcew9YBi8JtaYQXFXKEv+Ed7upEC5FvrCoMOKJcnZr7o0P0flZY8hCQix
	 xSBEQ5PswbUxcf4HLgbHkfXnamAH9lwyrDyvS4kSDnShVFL+w5qmk0UFFYimQc0fss
	 iZu1QJ+wsJGuA==
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
Subject: Re: [PATCH v4] erofs: reuse superblock for file-backed mounts
From: Christian Brauner <brauner@kernel.org>
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org, 
 linux-fsdevel@vger.kernel.org, amir73il@gmail.com, brauner@kernel.org
In-Reply-To: <20260804060455.2928514-1-gscrivan@redhat.com>
References: <20260804060455.2928514-1-gscrivan@redhat.com>
Date: Mon, 10 Aug 2026 15:34:19 +0200
Message-Id: <20260810-losging-beengt-zarte-1047dd62c195@brauner>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=8165; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Gdl9lFp8bb1Ad7U9d6ZbHg46SyvNZwcX7+m2PALfoO4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRVXo6/Pn3fk7fxPAd992cYvZvWH7ega+e0uWEqKxau2
 7VuU1G6dkcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEZt1hZPiqluVmanVhz3Z3
 R7s16+P6k5j8wpoeLGGa1ZO2n1/7uifDX6G4j/78MYmvd1rsinaVm/M+V8x22cI1p+wdfh5S+7J
 clhcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Hi Giuseppe,

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
> +new one.  Remount is not allowed on shared superblocks.
> +
>  Sysfs Entries
>  =============
>  
> diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
> index 57bd21859c65..86da219f8f4e 100644
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
> index 3d92caec8d3a..4e926376e17b 100644
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
> @@ -652,6 +659,17 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
>  		errorfc(fc, "FSDAX is not allowed when inode_share is on");
>  		return -EINVAL;
>  	}
> +	if (test_opt(&sbi->opt, SUPERBLOCK_SHARE) &&
> +	    test_opt(&sbi->opt, INODE_SHARE)) {
> +		errorfc(fc, "superblock_share is not allowed when inode_share is on");
> +		return -EINVAL;
> +	}
> +	/* Extra devices are not yet supported with superblock sharing.  */
> +	if (test_opt(&sbi->opt, SUPERBLOCK_SHARE) &&
> +	    sbi->devs->extra_devices) {
> +		errorfc(fc, "superblock_share does not support extra devices");
> +		return -EINVAL;
> +	}
>  
>  	sbi->blkszbits = PAGE_SHIFT;
>  	if (!sb->s_bdev) {
> @@ -779,6 +797,51 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
>  	return 0;
>  }
>  
> +static int erofs_fc_test_file_super(struct super_block *sb,
> +				    struct fs_context *fc)
> +{
> +	struct erofs_sb_info *sbi = EROFS_SB(sb);
> +	struct erofs_sb_info *new_sbi = fc->s_fs_info;
> +
> +	if (sb->s_iflags & SB_I_RETIRED)
> +		return 0;
> +	if (!sbi->dif0.file || !new_sbi->dif0.file)
> +		return 0;
> +	if (!test_opt(&new_sbi->opt, SUPERBLOCK_SHARE))
> +		return 0;
> +	return file_inode(sbi->dif0.file) == file_inode(new_sbi->dif0.file) &&
> +	       sbi->dif0.fsoff == new_sbi->dif0.fsoff &&
> +	       !memcmp(&sbi->opt, &new_sbi->opt, sizeof(sbi->opt));
> +}
> +
> +static int erofs_fc_get_tree_file(struct fs_context *fc)
> +{
> +	struct erofs_sb_info *sbi = fc->s_fs_info;
> +	struct super_block *sb;
> +	int err;
> +
> +	if (!test_opt(&sbi->opt, SUPERBLOCK_SHARE))
> +		return get_tree_nodev(fc, erofs_fc_fill_super);
> +
> +	sb = sget_fc(fc, erofs_fc_test_file_super, set_anon_super_fc);
> +	if (IS_ERR(sb))
> +		return PTR_ERR(sb);
> +
> +	if (sb->s_root) {
> +		erofs_info(sb, "sharing superblock for the same backing file");
> +	} else {
> +		err = erofs_fc_fill_super(sb, fc);
> +		if (err) {
> +			deactivate_locked_super(sb);
> +			return err;
> +		}
> +		sb->s_flags |= SB_ACTIVE;
> +	}
> +
> +	fc->root = dget(sb->s_root);
> +	return 0;
> +}

I think you should rename vfs_get_super() to get_tree_super() and expose
it to modules. Then this function collapses to:

if (!test_opt(&sbi->opt, SUPERBLOCK_SHARE))
	get_tree_super(fc, NULL, erofs_fc_fill_super);

return get_tree_super(fc, erofs_fc_test_file_super, erofs_fc_fill_super);

or simpler, if you move the sbi test for SUPERBLOCK_SHARE into
erofs_fc_test_file_super:

get_tree_super(fc, erofs_fc_test_file_super, erofs_fc_fill_super);

-- 


