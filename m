Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DD5606A320
	for <linux-erofs@archiver.kernel.org>; Mon, 26 Oct 2026 08:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GMtoT7WA
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jCnP52Z1rz2xDD;
	Mon, 26 Oct 2026 19:49:29 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793004569;
	cv=none; b=dgq0mUD6HmusKFfEFh5DgaUJcdfNzae1/gi6RgZy4fMoP3JSS03gRnhhGo7gBHW1W+o+ijs+zmr69V9jHUFMnUPIIuy6N3dYL1VP/RbkPvtHkZUbMjx8DIqguGSzWMiUc1TzqRk3qwC6yyPsUqHY/ts9zsFo+X7iTgnlx39FmGB+b0zQ6pQ+2GVcnUqNvhS8LBpyn1uK6FafbNxvArwyc8cII41c3WP1HYfvGGeDruxeODNJsdVJzKG2j3esOvbb21+3QAtIkTHHNzNqMojkgdIsZK3GAxVsFeC8W1LruVrLHan1Zovdjr2gIR1awhh9XNQDY1GoD/ttvHysCXwTlw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793004569; c=relaxed/relaxed;
	bh=LizEjFCJdKeMefdED2BcpHWLU6j6r3nsMZtDur3gTtc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g+SvGOLYZ8/F1aQHi3yQlyLBvd6R+nnsDjlV41EIFrcsOSueGhgdnePQZ+P7clusDyBQezxbS34af6ulML6jox5of2Sj0ZlKTBgng4YwRgJJTHRnHZVpJkERZopoFQ6E1A/wLUUKIqR2rDFYa9xfQ5TE8t8J9zoIac4QEwFO2Hoa61TMKj/VBDUpM5KU+FHNEEkZu7n56Cq5CKVTijbeSgVGjbNoUmwH4GaEf/b0c+DDnRq4uVUBg5vbrLqq3ve7vjZ3Zc625irzH9qECx5dO2anftVJcmn16y6H1hBwXoYhoNt0Vp7rG5Ejobrz8qsMhmgV1OOm/ZQJKTQSbEcX+Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GMtoT7WA; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GMtoT7WA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jCnP40Pl7z2x9c
	for <linux-erofs@lists.ozlabs.org>; Mon, 26 Oct 2026 19:49:27 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB42A600CB;
	Mon, 26 Oct 2026 08:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775751F01825;
	Mon, 26 Oct 2026 08:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793004564;
	bh=LizEjFCJdKeMefdED2BcpHWLU6j6r3nsMZtDur3gTtc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GMtoT7WA0VI2aRx3RSWdTPDMssTiugbINS+ZVvEm7JzvPEc6/KiaoxF09CbnzOdBt
	 IUlee+A4yr6WVB7T/mEhKTY2kHvT4PG6tsPFJD2LhKretqSZxh5dQrb8naD4FijljT
	 FiPapaTw9AA3EiUQWIUSLoFeqvJTnVBh0BPoQKWr2OZcmqtlmGCAeWZX8DquyBEvPq
	 U5tVf5KDpCGkshQjdSZNkCbDuDuacp8wR1O/3dcQ5avu0eJar0PVcUwwl+6ldeDy4x
	 Yt3pduRlUKoTF4aeCARBh4+ByM7jtUGFFPq9jFjeIJ6E7Jf7pqJ3VBV/7xEkltJZg7
	 +hU5sqY7jHD9Q==
Date: Mon, 26 Oct 2026 09:49:15 +0100
From: Gao Xiang <xiang@kernel.org>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Zhan Xusheng <zhanxusheng@xiaomi.com>
Subject: Re: [PATCH] erofs: don't reuse a superblock for a mount that passes
 device=
Message-ID: <at8UCyjlHgxxBAaf@MacBookPro>
Mail-Followup-To: Zhan Xusheng <zhanxusheng1024@gmail.com>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Zhan Xusheng <zhanxusheng@xiaomi.com>
References: <20261021083826.1870937-1-zhanxusheng1024@gmail.com>
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
In-Reply-To: <20261021083826.1870937-1-zhanxusheng1024@gmail.com>
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Xusheng,

On Wed, Oct 21, 2026 at 04:38:26PM +0800, Zhan Xusheng wrote:
> From: Zhan Xusheng <zhanxusheng@xiaomi.com>
> 
> superblock_share together with device= is rejected in
> erofs_fc_fill_super():
> 
> 	if (test_opt(&sbi->opt, SUPERBLOCK_SHARE) &&
> 	    sbi->devs->extra_devices)
> 		return -EINVAL;
> 
> but extra_devices is kept in sbi->devs, not in sbi->opt, and
> erofs_sb_share_test_super() compares only the backing inode, the
> fsoffset and sbi->opt.  So once the image is mounted with
> superblock_share, a second mount with superblock_share,device= matches
> that superblock and get_tree_super() reuses it without calling
> fill_super() at all.
> 
> The same command line therefore either fails with -EINVAL or succeeds
> with device= quietly dropped, depending on whether a compatible mount
> already exists.
> 
> Refuse to match a context that brought device= options, so that it gets
> a superblock of its own and fill_super() decides as it does today.
> 
> Only the incoming context can be tested: a shared superblock may have
> extra_devices set itself, because erofs_scan_devices() fills the device
> table from the image when no device= was given.
> 
> Fixes: cd4108319bb3 ("erofs: reuse superblock for file-backed mounts")
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
> ---
>  fs/erofs/super.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index 16fa3b853f1b6..bc9ab5a6234a0 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -825,6 +825,13 @@ static int erofs_sb_share_test_super(struct super_block *sb,
>  		return 0;
>  	if (!sbi->dif0.file || !new_sbi->dif0.file)
>  		return 0;
> +	/*
> +	 * extra_devices is not part of sbi->opt, so the memcmp below cannot
> +	 * see device= options.  @sb may have extra_devices set from the
> +	 * on-disk device table, so only the incoming context is tested.
> +	 */
> +	if (new_sbi->devs->extra_devices)
> +		return 0;

Yes, it's indeed an issue, but the comment message here is useless
since erofs_fc_fill_super() doesn't explicitly support `device=`.


>  	return file_inode(sbi->dif0.file) == file_inode(new_sbi->dif0.file) &&
>  	       sbi->dif0.fsoff == new_sbi->dif0.fsoff &&
>  	       !memcmp(&sbi->opt, &new_sbi->opt, sizeof(sbi->opt));

		&& !new_sbi->devs->extra_devices;

I think you should just add a line here.

Could you please send another version as soon as possible so I can
apply.

Thanks,
Gao Xiang

> 
> base-commit: 1137aa577a35e2684e8046c3e53f920e79c7cc60
> -- 
> 2.43.0
> 
> 

