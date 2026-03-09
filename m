Return-Path: <linux-erofs+bounces-2535-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46E03EA854A
	for <linux-erofs@archiver.kernel.org>; Mon,  9 Mar 2026 03:02:11 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fThcx3sTBz3bnm;
	Mon, 09 Mar 2026 14:02:09 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773025329;
	cv=none; b=FTrVzgLomt1dsMmtvTnJ0yu+Nw7LtVCiS9sOeCKlX0mm9qriZXaVvUXhAMvstoO/qvddXUloYGBDFb13x7LqXP46LK+2wnT9griObPqsqXI7HAfV9sDD3PQgqN84PKtOCpM9b1fE4XtN6pN0M9fuIiulr01F748OiHmyu7YYzrpTr0mN//BczMURYlrTmyXJv8+v2yxcWBxDpj2zAqgMl6gXcgnlEX3o4ZteBcyhlBJwa6k2yG6gSl2kpK+6zpZ/0i3kvEtHF/OIsRGlWvl13iiCQMF56If7UcZijzPh1dm9bUiuHqe/XKYvb7QcWEyGqDcpS1+DbUqXbLB0gFbFHA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773025329; c=relaxed/relaxed;
	bh=wXruS7sYNNs5AqEinrpNUsbJNbVP+SAbifLRwxw2WSM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oXMOm3DyqcJ4CApmtF6L1vEyzqGoTwtwZcQyImo5DH8hePavRaLvopJO1+B+OhwThjgRwgj4iICaIjW8Q3Pu+vVrH4DDkLYb7bPUwag+CA8azmcmVDwrR9Oor69W87jamJH42kN458szDaRuXqSPPTWvLgTkIHbyXNf95HwqgZTRVdo1zPoaOC7D2hI4zP97Gq+hF2ZT8xoBOWk3NNhQ6gsYwTpR3u5sJGcBXGGMHVm5Bv6P/oz1P1m9Eq9r1JPQL27TVu4rHs5oz31uHUZgn4jgV81Ra7h5JCaGKtN7/bW94xqC3ndaMNeBw+9iZyo6/LbiuAktFKLiq66yqNOzxQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=SXaqXBAj; dkim-atps=neutral; spf=pass (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=SXaqXBAj;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fThct2xFLz2xdL
	for <linux-erofs@lists.ozlabs.org>; Mon, 09 Mar 2026 14:02:04 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773025317; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wXruS7sYNNs5AqEinrpNUsbJNbVP+SAbifLRwxw2WSM=;
	b=SXaqXBAjQD6qVMlKEZZ63jWA9h7en2BS/0YRa+Wck2hx1cO7MbhuF1eYRac1XXALZeQvFwOGxIXg/1JcneeZcj9F9/BV/Jx7SZM5jxOJARKFAnjz/ANn4dPW/OT1N8XyjEP9wVgwXFfczABxCdZ2AYsLP/VjCvDg1d9sKISJe2Q=
Received: from 30.170.14.2(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X-TI8aX_1773025314 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Mar 2026 11:01:55 +0800
Message-ID: <dc5f1a0f-ef93-4a57-b170-2d6514693fb8@linux.alibaba.com>
Date: Mon, 9 Mar 2026 11:01:54 +0800
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
Subject: Re: [PATCH] erofs: introduce nolargefolio mount option
To: Chao Yu <chao@kernel.org>, xiang@kernel.org
Cc: linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Chunhai Guo <guochunhai@vivo.com>,
 Hongbo Li <lihongbo22@huawei.com>,
 linux-erofs mailing list <linux-erofs@lists.ozlabs.org>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>
References: <20260309023053.1685839-1-chao@kernel.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260309023053.1685839-1-chao@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Chao,

(+cc -fsdevel, willy, Jan kara)

On 2026/3/9 10:30, Chao Yu wrote:
> This patch introduces a new mount option 'nolargefolio' for EROFS.
> When this option is specified, large folio will be disabled by
> default for all inodes, this option can be used for environments
> where large folio resources are limited, it's necessary to only
> let specified user to allocate large folios on demand.

For this kind of options, I think more real backgrounds
about avoiding high-order allocations are needed in the
commit message (at least for later reference) also like
what I observed in:
https://android-review.googlesource.com/c/kernel/common/+/3877981

because the entire community tends to enable large folios
unconditionally if possible.  Without enough clarification,
even I merge this, there will be endless questions again
and again about this.

And Jan once raised up if it should be a user interface
or auto-tuning one:
https://lore.kernel.org/r/z2ule3ilnnpoevo5mvt3intvjtuyud7vg3pbfauon47fhr4owa@giaehpbie4a5

My question is that if the needs are real, I wonder if
it should be a vfs generic decision instead (because
it's not due to the filesystem restriction but due to
real system memory pressure or heavy workload for
example).  However, if the answer is that others don't
really care about this, I'm fine to leave it as an
erofs-specific option as long as the actual case is
clear in the commit message.

Thanks,
Gao Xiang


> 
> Signed-off-by: Chao Yu <chao@kernel.org>
> ---
>   Documentation/filesystems/erofs.rst | 1 +
>   fs/erofs/inode.c                    | 3 ++-
>   fs/erofs/internal.h                 | 1 +
>   fs/erofs/super.c                    | 8 +++++++-
>   4 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/filesystems/erofs.rst b/Documentation/filesystems/erofs.rst
> index fe06308e546c..d692a1d9f32c 100644
> --- a/Documentation/filesystems/erofs.rst
> +++ b/Documentation/filesystems/erofs.rst
> @@ -137,6 +137,7 @@ fsoffset=%llu          Specify block-aligned filesystem offset for the primary d
>   inode_share            Enable inode page sharing for this filesystem.  Inodes with
>                          identical content within the same domain ID can share the
>                          page cache.
> +nolargefolio           Disable large folio support for all files.
>   ===================    =========================================================
>   
>   Sysfs Entries
> diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
> index 4b3d21402e10..26361e86a354 100644
> --- a/fs/erofs/inode.c
> +++ b/fs/erofs/inode.c
> @@ -254,7 +254,8 @@ static int erofs_fill_inode(struct inode *inode)
>   		return 0;
>   	}
>   
> -	mapping_set_large_folios(inode->i_mapping);
> +	if (!test_opt(&EROFS_SB(inode->i_sb)->opt, NO_LARGE_FOLIO))
> +		mapping_set_large_folios(inode->i_mapping);
>   	aops = erofs_get_aops(inode, false);
>   	if (IS_ERR(aops))
>   		return PTR_ERR(aops);
> diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
> index a4f0a42cf8c3..b5d98410c699 100644
> --- a/fs/erofs/internal.h
> +++ b/fs/erofs/internal.h
> @@ -177,6 +177,7 @@ struct erofs_sb_info {
>   #define EROFS_MOUNT_DAX_NEVER		0x00000080
>   #define EROFS_MOUNT_DIRECT_IO		0x00000100
>   #define EROFS_MOUNT_INODE_SHARE		0x00000200
> +#define EROFS_MOUNT_NO_LARGE_FOLIO	0x00000400
>   
>   #define clear_opt(opt, option)	((opt)->mount_opt &= ~EROFS_MOUNT_##option)
>   #define set_opt(opt, option)	((opt)->mount_opt |= EROFS_MOUNT_##option)
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index 972a0c82198d..a353369d4db8 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -390,7 +390,7 @@ static void erofs_default_options(struct erofs_sb_info *sbi)
>   enum {
>   	Opt_user_xattr, Opt_acl, Opt_cache_strategy, Opt_dax, Opt_dax_enum,
>   	Opt_device, Opt_fsid, Opt_domain_id, Opt_directio, Opt_fsoffset,
> -	Opt_inode_share,
> +	Opt_inode_share, Opt_nolargefolio,
>   };
>   
>   static const struct constant_table erofs_param_cache_strategy[] = {
> @@ -419,6 +419,7 @@ static const struct fs_parameter_spec erofs_fs_parameters[] = {
>   	fsparam_flag_no("directio",	Opt_directio),
>   	fsparam_u64("fsoffset",		Opt_fsoffset),
>   	fsparam_flag("inode_share",	Opt_inode_share),
> +	fsparam_flag("nolargefolio",	Opt_nolargefolio),
>   	{}
>   };
>   
> @@ -541,6 +542,9 @@ static int erofs_fc_parse_param(struct fs_context *fc,
>   		else
>   			set_opt(&sbi->opt, INODE_SHARE);
>   		break;
> +	case Opt_nolargefolio:
> +		set_opt(&sbi->opt, NO_LARGE_FOLIO);
> +		break;
>   	}
>   	return 0;
>   }
> @@ -1105,6 +1109,8 @@ static int erofs_show_options(struct seq_file *seq, struct dentry *root)
>   		seq_printf(seq, ",fsoffset=%llu", sbi->dif0.fsoff);
>   	if (test_opt(opt, INODE_SHARE))
>   		seq_puts(seq, ",inode_share");
> +	if (test_opt(opt, NO_LARGE_FOLIO))
> +		seq_puts(seq, ",nolargefolio");
>   	return 0;
>   }
>   


