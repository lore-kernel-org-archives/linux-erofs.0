Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56370606A338
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Nov 2026 21:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UY92mI76
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jVsMg4n2Dz2xL1;
	Fri, 20 Nov 2026 08:40:31 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795124431;
	cv=none; b=GcV9XYaJllDUnGwpfF7kWb8Ap8WYa9m/tvP84yt/j+YFX7okZ+jNPyrPVwvQJ9eneJ+v/u4AJJb/bbf9gwP5fwbfcagaxEJ2PhMsf99slC2F8M6CSWSD+JOrPHFB5W9gBaDSc0VjMMhQbwPK7MR66mDJ56Atkkf1qeD9v1WpvDP08a5MUiGgrQl/0vkK0D2rCQz7udKf0yvvXCaDq8UF+ko0VyOnSgk9mfvvLBtl8YOqLboC5MUi+dxvOpzo+VQZhdMswM9HY1hyHi1smXx79xPSlqualP1deJbJuBxhrqiZefIzNA1ykk0bcKizUHwzaj/Rb2C8Q2WtkZyHFvKcYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795124431; c=relaxed/relaxed;
	bh=6BvNyHgvViv9IZmuvvYxPHjZklGMCfTMavfke1LQWLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J6Uq3osRQFy1rZq6sD0NvMFdi9cmEgqOVLGvv1puz26Jm8RP2L6VRKhgtz/zLtVHGX5a8QVrtkDelh39hah02OZkZhlTCkBGiULSVKS6QUx2JIXFfsq2+q2QFzXeOpHz/yrHPCObdgKQSoQ2b085Dc69bzQKXqw9nqxBlii5z0Q19Ks1iXfc/f2hwLKzuZ8PZIBnkRi8IsPSgzeP38EvFRu1pT2wP1eNts61M8U2DhwNewJ7zUXduIqowxV5snkVfIEzLYT6G4Dzyfi65GIIrJZ9ZHlSawcveGgnNLLuzoR0xLbdjR4Yp/848nf4DIycBrAfhwFGvFt9GvJgW9Dyxg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UY92mI76; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UY92mI76;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jVsMf40mXz2xH7
	for <linux-erofs@lists.ozlabs.org>; Fri, 20 Nov 2026 08:40:30 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 28396626E4;
	Thu, 19 Nov 2026 21:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B851F000C0;
	Thu, 19 Nov 2026 21:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795124427;
	bh=6BvNyHgvViv9IZmuvvYxPHjZklGMCfTMavfke1LQWLY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UY92mI76u/GrLHGRSW9U2aYfpLifGf0FrRQz14MIS6aPNp+bdi849ODOyJlX8IZif
	 ihhrZ51v2tlrmZemnZK69RTNyEwp2yVK78RaxCKf0IhZgAP2N/5i6XRSpouHsgMC7B
	 2lcrt1cs1PUJDGYblXRv4zKOqD/wv1X525cJI3uB8QWGgQwaDfLCltOGI2hAFASr/a
	 SxBPQaunwTUzNrgzhZeMhmVvzsNUgidxjBETtT9GEtQrGbrqGLahvOP0MuNaKRL655
	 8hSM0rIl/4jiQHtpv6fSp17ztwuHFgXrbVzN8CbJWF6/Dy/TvPITyxQAocPCmBMtR4
	 tPROyGoz6wnXQ==
Date: Thu, 19 Nov 2026 22:40:15 +0100
From: Gao Xiang <xiang@kernel.org>
To: Friendy Su <friendy.su@sony.com>
Cc: xiang@kernel.org, chao@kernel.org, jack@suse.cz, amir73il@gmail.com,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>
Subject: Re: [PATCH v2] erofs: set SB_I_ALLOW_HSM for bdev-based mounts
Message-ID: <av9svyT3otgEEDgX@MacBookPro.fritz.box>
Mail-Followup-To: Friendy Su <friendy.su@sony.com>, xiang@kernel.org,
	chao@kernel.org, jack@suse.cz, amir73il@gmail.com,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>
References: <20261023021635.2852395-1-friendy.su@sony.com>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261023021635.2852395-1-friendy.su@sony.com>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Friendy,

On Fri, Oct 23, 2026 at 10:16:35AM +0800, Friendy Su wrote:
> SB_I_ALLOW_HSM makes erofs support fanotify FAN_PRE_ACCESS event
> for bdev-based mounts. file-backed mounts do not support this.
> 
> This is for use case that erofs file data is not available on
> local block device at mount, but need to be filled at fanotify
> FAN_PRE_ACCESS event handler.
> 
> E.g. format erofs to blob mode, meta data on /dev/pmem0, file data
> on blob device /dev/pmem1. The file content in blob device is dummy.
> 
> mount as below:
> 
> $ sudo mount -o dax,device=/dev/pmem1 /dev/pmem0 /mnt/erofs/
> 
> In FAN_PRE_ACCESS handler, actual file content is fetched from remote
> then filled into the DAX mounted block device /dev/pmem1.


Set SB_I_ALLOW_HSM to enable fanotify FAN_PRE_ACCESS events for
bdev-backed mounts. File-backed mounts are not supported.

This allows EROFS to handle cases where file data is not available
locally at mount time and needs to be fetched on demand by a
FAN_PRE_ACCESS event handler.

For example, an EROFS image can use blob mode with metadata stored
on /dev/pmem0 and file data on /dev/pmem1, where the latter initially
contains dummy data.

The filesystem can be mounted with:

    mount -o dax,device=/dev/pmem1 /dev/pmem0 /mnt/erofs

On receiving a FAN_PRE_ACCESS event, the handler fetches the actual
file data from a remote source and fills the corresponding blocks
on /dev/pmem1 before access proceeds.


> 
> Signed-off-by: Friendy Su <friendy.su@sony.com>
> Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
> Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
> ---
>  fs/erofs/super.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index 0967aace9f7f..be8728b8d116 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -667,6 +667,15 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
>  		errorfc(fc, "FSDAX is not allowed when inode_share is on");
>  		return -EINVAL;
>  	}
> +	if (!erofs_is_fileio_mode(sbi)) {
> +		/*
> +		 * Only enable HSM to support fanotify FAN_PRE_ACCESS event
> +		 * under block device backed mounts.
> +		 * For file-backed mounts, do not enable since erofs-utils
> +		 * has already supported FAN_PRE_ACCESS event on backend image.
> +		 */

Could you just change it to

		 * Follow other filesystems by supporting FAN_PRE_ACCESS events
		 * only on bdev-backed mount. Don't bother with file-backed mounts.

I hope we could avoid mentioning user-space details
in the kernel codebase directly.

Could you send a new version as I suggested, otherwise
it looks good to me,

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

> +		sb->s_iflags |= SB_I_ALLOW_HSM;
> +	}
>  
>  	sbi->blkszbits = PAGE_SHIFT;
>  	if (erofs_is_fileio_mode(sbi)) {
> -- 
> 2.34.1
> 
> 

