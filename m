Return-Path: <linux-erofs+bounces-4352-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECF6EC61DBE
	for <linux-erofs@archiver.kernel.org>; Thu, 27 Aug 2026 01:30:53 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hVkVg6n9Sz2xyh;
	Thu, 27 Aug 2026 11:30:51 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::1034"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787794251;
	cv=none; b=R2yTWwZxqRPVwdPhUs5jdm++crJVZT5yUHESA4S/cNNF7+lhpOHwavKFwbYBZH0wgTFUFcQb4RLpMan4i3oli2k/PXWlC1ACw5DQIHBB7xJQtKY1hfZ6l7mfFKzUiULlxniqnIlwddEPY+Q9E8DUccU/9MpuSC7TjkunqmAc6uc+q0oLipeQ4JD3FGIS3Ux1hiFvgkeC2I2PvTG8XhKIj0Qzt6fVksN58WE5xlY9zE10YfS1OcPADVrmqmwYQtw7vpSlzFMjkiZ7A106ePf+Yy9eATaMlOSv8zl4XgW6kKM6q0CmjF4MJKrHWL2hG8JwP3OUo/qIohAEwXuWnjg3wg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787794251; c=relaxed/relaxed;
	bh=4DxJZJvLJVYoJpENEaZN0Xv4Qk39G9RHMdOy4VPR3IY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BywTgK2BS42zkj8xF0ZY7QId2uhaQOF/wmmGMmST+UJMsXt9VRXTLUlptKw0YCN2XHLEKYk4Y1G1Osq3TX/VRwEcE8Mv9GmEFf4ybtE84oK09B70kv3Li/CkZu6KqdZ3dXH08oXg5w957TlbAcwt+cX8FCFvM8Q82kve+yB1w2R68TYoqqFv6Qkpr72sSleYkf5oqNGwME9swthWKeLWPs4EfnkiH3tqGHYM+Bo5W1IFv1Tn+MK7aYeOlkR7dXhopr2X34N6CJULv5irQZgOtwQTO3LKslduPqFDkgvWKOORexp1zYr6EpsYT2W2zqLA7FuM9IPN/BuRObvRdV303g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Fq/Yqk34; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1034; helo=mail-pj1-x1034.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Fq/Yqk34;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1034; helo=mail-pj1-x1034.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hVkVf2yd0z2xGr
	for <linux-erofs@lists.ozlabs.org>; Thu, 27 Aug 2026 11:30:49 +1000 (AEST)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-38e42560ebcso1578245a91.1
        for <linux-erofs@lists.ozlabs.org>; Wed, 26 Aug 2026 18:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787794242; x=1788399042; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4DxJZJvLJVYoJpENEaZN0Xv4Qk39G9RHMdOy4VPR3IY=;
        b=Fq/Yqk34DaVOLfp79uXBEiEPL5OTxRoYhe9D0unMwE+pM0ntppSD5QU8ZX/LfipjXD
         KEylf3UiZWmhRSXJzV4zNwgrgx+YSbnDBvmdjm67zf93BwKVRQPHzXM2Zib008WN23xr
         u5MSS/1ZD1O7TUMmJsJt5Nk8zmjrQujTcpdsaZojj7CW7Pcpej2L1M2FpFZBjB2NCEUU
         +7xC5oPVIfYWm+B+AizcrIaWI6OTqiIEcenJ/FD8Ts94HTqWZWiMIih/+dSlP4Mno2or
         IQbo22wMT01F6L6wT4W25FV8P1+ZAbefdXFy8XPNrpx24EQXCEwxMj4VTRah3wjOVQzC
         IAGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787794242; x=1788399042;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4DxJZJvLJVYoJpENEaZN0Xv4Qk39G9RHMdOy4VPR3IY=;
        b=lBdcGGm4l+gpgeUhcuw33a2iwAWsfdcF+BlBJIOfqOoLbRUR8gE2GhOJf4/q6dB/v6
         nxp11toLnc/NmK3OnwwZAic4EawMhytiAQTybEc0bWkYkp1xGp9pfB1MxD8n1zLiKYhk
         PYQqhe6nHVQjxjlCZzPoF4oUwztGNsCy/puuD9TYK9480h1j4Vh8IBtU+JvWV2+hbL2A
         2SRAa/5Ovl8cOimqCS0GOroYkgw3xzfYmugnItC3QYbWR4+n+O/VLtzSkjyYu5e36m5H
         VzjrVaM/RT9ffWox3039/J6QhGJY2zKUBdKzF3y8x54HQaA3pzjZAqUtVYRQMccpTC+E
         xgQQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp0n54496PtXTPwInMsDD5KsgXpwWNj68DkQ7BlJzUeRG9Y/xh7BC498ucUclaj2IGTOVkvNzdFCotDqA==@lists.ozlabs.org
X-Gm-Message-State: AFuF++k6y/vzBQPa44w1s1zhENL8ffqr5/EBfXqkDKYacR/dLn9vu8bC
	JhGAm3CE1vUzpAUwx22pwllrNXHTqyalfCr914N8WSyjQQy9HTLsoAm8
X-Gm-Gg: AR+sD10sZuUSrJTjLCiT0EuUgQcTwOcNc8o1+JQ6W6tGNpIy4wVj3y5HCy4ZErXgWD2
	9LHOV5WG5zZxRUDTXk+GqVFLvgtgMpiyryu0kct43VHdfEsYxZrIwSlYGPzjJoOQCXeyf5ZHcTo
	qArw9NLWlB2IBQwQQaI0otoob/EcgIwAW0kn/bTBRfUwu0/o/Bc9PuQvtsJeBJl09kD7Nl32icw
	krXsITXqCwAX6YJNfsoLvSWjT0bnKlfPDD+GO7cjSJkrWkHvfLEYRqom5KVppTJyDWGhRCxwlhj
	n+vZtDSJSU/8EdZ7B1fWs5/m5hEzES9bMQmvtYDY0IlpyqsN3YksWE4DjclYciMnmt92wzxB1jy
	X8ghM+tvo7W+fzOYD5O4yCQPen5YovoxrTJK9eFCuuxRxCX3kjNyr2SEl12tgjtwj4aytaRi6E2
	t6vWAKS5qSmA/WaPgUmfC378g8ra0ahzDfs4CrfwUO6iBul+kihofq7BTgElzPJDuqT9OxLajeR
	2I5qjhTw+2C/xv8WdN/6w==
X-Received: by 2002:a17:90b:3a05:b0:37f:fd1f:d30f with SMTP id 98e67ed59e1d1-3966d44312fmr23576326a91.12.1787794241771;
        Wed, 26 Aug 2026 18:30:41 -0700 (PDT)
Received: from [7.249.248.112] ([124.70.231.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b112b57bsm539166a91.17.2026.08.26.18.30.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2026 18:30:41 -0700 (PDT)
Message-ID: <77994974-775a-4b5c-a872-4973ed40364e@gmail.com>
Date: Thu, 27 Aug 2026 09:30:38 +0800
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
Subject: Re: [PATCH 2/4] erofs-utils: lib: use `struct erofs_device_info` for
 the primary device
To: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
References: <20260826134321.11835-1-xiang@kernel.org>
 <20260826134321.11835-2-xiang@kernel.org>
Content-Language: en-US
From: Yifan Zhao <stopire@gmail.com>
In-Reply-To: <20260826134321.11835-2-xiang@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 26/8/26 21:43, Gao Xiang wrote:
> Source kernel commit: 7b00af2c5414dc01e0718deef7ead81102867636
>
> Signed-off-by: Gao Xiang <xiang@kernel.org>
> ---
>   include/erofs/internal.h |  4 +---
>   lib/importer.c           |  3 +--
>   lib/io.c                 |  8 ++++----
>   lib/rebuild.c            |  6 +++---
>   lib/super.c              | 18 +++++++++---------
>   lib/vmdk.c               |  4 ++--
>   mkfs/main.c              | 12 ++++++------
>   7 files changed, 26 insertions(+), 29 deletions(-)
>
> diff --git a/include/erofs/internal.h b/include/erofs/internal.h
> index 514cfbd..30dae41 100644
> --- a/include/erofs/internal.h
> +++ b/include/erofs/internal.h
> @@ -93,11 +93,9 @@ struct erofs_metamgr;
>   
>   struct erofs_sb_info {
>   	struct erofs_sb_lz4_info lz4;
> -	struct erofs_device_info *devs;
> -	char *devname;
> +	struct erofs_device_info *devs, dif0;
>   
>   	u64 total_blocks;
> -	u64 primarydevice_blocks;
>   
>   	s32 meta_blkaddr;
>   	u32 xattr_blkaddr;
> diff --git a/lib/importer.c b/lib/importer.c
> index c404b0f..2a635d2 100644
> --- a/lib/importer.c
> +++ b/lib/importer.c
> @@ -126,8 +126,7 @@ int erofs_importer_flush_all(struct erofs_importer *im)
>   
>   	fsalignblks = im->params->fsalignblks ?
>   		roundup_pow_of_two(im->params->fsalignblks) : 1;
> -	sbi->primarydevice_blocks = roundup(erofs_mapbh(sbi->bmgr, NULL),
> -					    fsalignblks);
> +	sbi->dif0.blocks = roundup(erofs_mapbh(sbi->bmgr, NULL), fsalignblks);
>   	err = erofs_write_device_table(sbi);
>   	if (err)
>   		return err;
> diff --git a/lib/io.c b/lib/io.c
> index 3ba45cc..5c5449f 100644
> --- a/lib/io.c
> +++ b/lib/io.c
> @@ -368,8 +368,8 @@ repeat:
>   	}
>   
>   out:
> -	sbi->devname = strdup(dev);
> -	if (!sbi->devname) {
> +	sbi->dif0.src_path = strdup(dev);
> +	if (!sbi->dif0.src_path) {
>   		close(fd);
>   		return -ENOMEM;
>   	}
> @@ -381,8 +381,8 @@ out:
>   void erofs_dev_close(struct erofs_sb_info *sbi)
>   {
>   	erofs_io_close(&sbi->bdev);
> -	free(sbi->devname);
> -	sbi->devname = NULL;
> +	free(sbi->dif0.src_path);
> +	sbi->dif0.src_path = NULL;
>   	sbi->bdev.fd = -1;
>   }
>   
> diff --git a/lib/rebuild.c b/lib/rebuild.c
> index a5308dc..6b03a52 100644
> --- a/lib/rebuild.c
> +++ b/lib/rebuild.c
> @@ -233,7 +233,7 @@ static int erofs_rebuild_write_full_data(struct erofs_inode *inode)
>   				return -EFSCORRUPTED;
>   			return 0;
>   		}
> -		inode->rebuild_blobpath = strdup(src_sbi->devname);
> +		inode->rebuild_blobpath = strdup(src_sbi->dif0.src_path);
>   		if (!inode->rebuild_blobpath)
>   			return -ENOMEM;
>   		inode->rebuild_src_dataoff =
> @@ -244,7 +244,7 @@ static int erofs_rebuild_write_full_data(struct erofs_inode *inode)
>   		unsigned int inline_size = inode->i_size % erofs_blksiz(src_sbi);
>   
>   		if (nblocks > 0 && inode->u.i_blkaddr != EROFS_NULL_ADDR) {
> -			inode->rebuild_blobpath = strdup(src_sbi->devname);
> +			inode->rebuild_blobpath = strdup(src_sbi->dif0.src_path);
>   			if (!inode->rebuild_blobpath)
>   				return -ENOMEM;
>   			inode->rebuild_src_dataoff =
> @@ -500,7 +500,7 @@ int erofs_rebuild_load_tree(struct erofs_inode *root, struct erofs_sb_info *sbi,
>   	struct erofs_inode inode = {};
>   	struct erofs_rebuild_dir_context ctx;
>   	char uuid_str[37];
> -	char *fsid = sbi->devname;
> +	char *fsid = sbi->dif0.src_path;
>   	int ret;
>   
>   	if (!fsid) {
> diff --git a/lib/super.c b/lib/super.c
> index d138f84..ead4170 100644
> --- a/lib/super.c
> +++ b/lib/super.c
> @@ -33,7 +33,7 @@ static int erofs_init_devices(struct erofs_sb_info *sbi,
>   	erofs_off_t pos;
>   	bool _48bit = erofs_sb_has_48bit(sbi);
>   
> -	sbi->total_blocks = sbi->primarydevice_blocks;
> +	sbi->total_blocks = sbi->dif0.blocks;
>   
>   	if (!erofs_sb_has_device_table(sbi))
>   		ondisk_extradevs = 0;
> @@ -118,14 +118,14 @@ int erofs_read_superblock(struct erofs_sb_info *sbi)
>   		erofs_err("invalid sb_extslots %u", dsb->sb_extslots);
>   		return -EINVAL;
>   	}
> -	sbi->primarydevice_blocks = le32_to_cpu(dsb->blocks_lo);
> +	sbi->dif0.blocks = le32_to_cpu(dsb->blocks_lo);
>   	sbi->meta_blkaddr = le32_to_cpu(dsb->meta_blkaddr);
>   	sbi->xattr_blkaddr = le32_to_cpu(dsb->xattr_blkaddr);
>   	sbi->xattr_prefix_start = le32_to_cpu(dsb->xattr_prefix_start);
>   	sbi->xattr_prefix_count = dsb->xattr_prefix_count;
>   	if (erofs_sb_has_48bit(sbi) && dsb->rootnid_8b) {
>   		sbi->root_nid = le64_to_cpu(dsb->rootnid_8b);
> -		sbi->primarydevice_blocks = sbi->primarydevice_blocks |
> +		sbi->dif0.blocks = sbi->dif0.blocks |
>   				((u64)le16_to_cpu(dsb->rb.blocks_hi) << 32);
>   	} else {
>   		sbi->root_nid = le16_to_cpu(dsb->rb.rootnid_2b);
> @@ -230,10 +230,10 @@ int erofs_writesb(struct erofs_sb_info *sbi)
>   	char *buf;
>   	int ret;
>   
> -	sb.blocks_lo	= cpu_to_le32(sbi->primarydevice_blocks);
> -	if (sbi->primarydevice_blocks > UINT32_MAX ||
> +	sb.blocks_lo	= cpu_to_le32(sbi->dif0.blocks);
> +	if (sbi->dif0.blocks > UINT32_MAX ||
>   	    sbi->root_nid > UINT16_MAX) {
> -		sb.rb.blocks_hi = cpu_to_le16(sbi->primarydevice_blocks >> 32);
> +		sb.rb.blocks_hi = cpu_to_le16(sbi->dif0.blocks >> 32);
>   		sb.rootnid_8b = cpu_to_le64(sbi->root_nid);
>   	}
>   	memcpy(sb.uuid, sbi->uuid, sizeof(sb.uuid));
> @@ -404,7 +404,7 @@ int erofs_mkfs_init_devices(struct erofs_sb_info *sbi, unsigned int devices)
>   
>   int erofs_write_device_table(struct erofs_sb_info *sbi)
>   {
> -	erofs_blk_t nblocks = sbi->primarydevice_blocks;
> +	erofs_blk_t nblocks = sbi->dif0.blocks;
>   	struct erofs_buffer_head *bh = sbi->bh_devt;
>   	erofs_off_t pos;
>   	unsigned int i, ret;
> @@ -484,7 +484,7 @@ int erofs_mkfs_load_fs(struct erofs_sb_info *sbi, unsigned int dsunit)
>   	erofs_warn("EXPERIMENTAL incremental build in use. Use at your own risk!");
>   	err = erofs_read_superblock(sbi);
>   	if (err) {
> -		erofs_err("failed to read superblock of %s: %s", sbi->devname,
> +		erofs_err("failed to read superblock of %s: %s", sbi->dif0.src_path,
>   			  erofs_strerror(err));
>   		return err;
>   	}
> @@ -493,7 +493,7 @@ int erofs_mkfs_load_fs(struct erofs_sb_info *sbi, unsigned int dsunit)
>   	if (!err && S_ISREG(u.st.st_mode))
>   		u.startblk = DIV_ROUND_UP(u.st.st_size, erofs_blksiz(sbi));
>   	else
> -		u.startblk = sbi->primarydevice_blocks;
> +		u.startblk = sbi->dif0.blocks;
>   
>   	bmgr = erofs_buffer_init(sbi, u.startblk, NULL);
>   	if (!bmgr)
> diff --git a/lib/vmdk.c b/lib/vmdk.c
> index 316a8ff..28381c8 100644
> --- a/lib/vmdk.c
> +++ b/lib/vmdk.c
> @@ -51,8 +51,8 @@ int erofs_dump_vmdk_desc(FILE *f, struct erofs_sb_info *sbi)
>   	int ret, i;
>   
>   	fprintf(f, desc_template_1, cid, parent_cid, subformat);
> -	sectors = sbi->primarydevice_blocks << (sbi->blkszbits - 9);
> -	ret = erofs_vmdk_desc_add_extent(f, sectors, (char *)sbi->devname, 0);
> +	sectors = sbi->dif0.blocks << (sbi->blkszbits - 9);
> +	ret = erofs_vmdk_desc_add_extent(f, sectors, (char *)sbi->dif0.blocks, 0);

mistake? should use `src_path` instead of `blocks`


Thanks,

Yifan Zhao

>   	if (ret)
>   		return ret;
>   	total_sectors = sectors;
> diff --git a/mkfs/main.c b/mkfs/main.c
> index 929ce7c..5bf7b8f 100644
> --- a/mkfs/main.c
> +++ b/mkfs/main.c
> @@ -1685,12 +1685,12 @@ static int erofs_mkfs_rebuild_load_trees(struct erofs_inode *root)
>   		ret = erofs_rebuild_load_tree(root, src, datamode);
>   		src->xamgr = NULL;
>   		if (ret) {
> -			erofs_err("failed to load %s", src->devname);
> +			erofs_err("failed to load %s", src->dif0.src_path);
>   			return ret;
>   		}
>   		if (src->extra_devices > 1) {
>   			erofs_err("%s: unsupported number %u of extra devices",
> -				  src->devname, src->extra_devices);
> +				  src->dif0.src_path, src->extra_devices);
>   			return -EOPNOTSUPP;
>   		}
>   		extra_devices += src->extra_devices;
> @@ -1723,8 +1723,8 @@ static int erofs_mkfs_rebuild_load_trees(struct erofs_inode *root)
>   			nblocks = src->devs[0].blocks;
>   			tag = src->devs[0].tag;
>   		} else {
> -			nblocks = src->primarydevice_blocks;
> -			devs[idx].src_path = strdup(src->devname);
> +			nblocks = src->dif0.blocks;
> +			devs[idx].src_path = strdup(src->dif0.src_path);
>   		}
>   		devs[idx].blocks = nblocks;
>   		if (tag && *tag)
> @@ -1849,7 +1849,7 @@ int main(int argc, char **argv)
>   			goto exit;
>   		err = erofs_read_superblock(src);
>   		if (err) {
> -			erofs_err("failed to read superblock of %s", src->devname);
> +			erofs_err("failed to read superblock of %s", src->dif0.src_path);
>   			goto exit;
>   		}
>   		mkfs_blkszbits = src->blkszbits;
> @@ -2051,7 +2051,7 @@ int main(int argc, char **argv)
>   	if (err)
>   		goto exit;
>   
> -	err = erofs_dev_resize(&g_sbi, g_sbi.primarydevice_blocks);
> +	err = erofs_dev_resize(&g_sbi, g_sbi.dif0.blocks);
>   
>   	if (!err && erofs_sb_has_sb_chksum(&g_sbi)) {
>   		err = erofs_enable_sb_chksum(&g_sbi, &crc);

