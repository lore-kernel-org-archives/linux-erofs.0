Return-Path: <linux-erofs+bounces-4484-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F18CC79F9E
	for <linux-erofs@archiver.kernel.org>; Mon,  7 Sep 2026 08:18:43 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hdg291T9nz2xfj;
	Mon, 07 Sep 2026 18:18:41 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788769121;
	cv=none; b=D269bH+w0RPqJFqYyj1p3XxNYolu2YfHJzofBT5GRrCIo701bxR1CpZcwKFlw4Qs4YuU380Slw6MLssFVL03E5Qm5X7AtjarwHgLezM4ROI96+UdA0zuVtv1G0ExpdfcOxwhvtMTE93QfjFqmmwymT5RwupKtCzbfujEiF4qLObw9PmLhkoH0j2EMNmSSIjhatMUC8GRqJ0cMRjTQ21+P2zOWfNqcALE4ZCjJvyhXWh51e9Wzw3jBwdbONjw2XXbF9bCAQZwRfTexRSi3jxHtbk1zYd4YeNiD6KaoOpE75NFxLosCMqFfFLrWSr/louPU4n/1+Esy4mgdsk6cFjpTg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788769121; c=relaxed/relaxed;
	bh=KhBnvj5n+ETZ8WBM/uFHhGCY2fW1p8CuNXfVEPfr2MU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W9FA8aHV8T0HOXj6+XeJ3UHtIsZWlCPpEgeIJKSzUbWl0+FsATjJsEe0/PyVrzHub4TXEL8qfKWEC3MMlGBhoJWwtBmo7YmTBmWctW7QhlXN/7UjIlF4pt1fh+lKr1/SNYXKg6/Qhuc4fQDqYSilc0nEghFZyNKcje/XR5FmcpkI0IUfJTRglDlxp2WC0lm6vRFowrce7/jpeCulAKyPjDt7HS3Ql67WzTvTOEr/v3TB0oNbXaG2XVkIdSunGgv3sINyCG+mUQJf+2+AtUvcIsIYHvKefF1wdMq9Vr3p0R8na0RNSirjWYnefG+mEMNAU0qPvvv+H/OpO54hp5aC4g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U2jxxNQa; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U2jxxNQa;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hdg2765Mxz2xLG
	for <linux-erofs@lists.ozlabs.org>; Mon, 07 Sep 2026 18:18:39 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4838A435B0;
	Mon,  7 Sep 2026 08:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED251F00A3D;
	Mon,  7 Sep 2026 08:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788769116;
	bh=KhBnvj5n+ETZ8WBM/uFHhGCY2fW1p8CuNXfVEPfr2MU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U2jxxNQa2+QP0pDN+hIWA0ohpMh1pdKa2MM/uVRwodL8UB1G7ZkWQvq2te/AuV0wj
	 pK6RgPdpio3ZHl6ixOlwWkTyXqx6NKCJHJpMh3pJuXKvk9Kzhme/ruDX7Th5EP6Pgr
	 KBpRrzvaS35a5D9IqOVsROZl9TG05CwWby77oehbazesqnQwoofPg7CpWTxiKDm60E
	 rUYSaFat616CezHninBkfNcMKbExt2bYDyccCpx4tHnZd4HUVpH9wXS/qkHhN6H1tF
	 I1ezXQaU0EX5hw49J6klxOWGq5kDdFAVFqXXgTlBjl2MOkx1cZDVh3S0FMMVHZqldn
	 XPZeDgw7IyUsA==
Date: Mon, 7 Sep 2026 16:18:29 +0800
From: Gao Xiang <xiang@kernel.org>
To: ChengyuZhu6 <hudson@cyzhu.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org,
	Chengyu Zhu <hudsonzhu@tencent.com>
Subject: Re: [PATCH] erofs: delimit inode_share cache key components
Message-ID: <ap5zVT1PJQnMW6i3@XiangdeMacBook-Pro.local>
Mail-Followup-To: ChengyuZhu6 <hudson@cyzhu.com>,
	linux-erofs@lists.ozlabs.org, xiang@kernel.org,
	Chengyu Zhu <hudsonzhu@tencent.com>
References: <20260907072440.76001-1-hudson@cyzhu.com>
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
In-Reply-To: <20260907072440.76001-1-hudson@cyzhu.com>

Hi Chengyu,

On Mon, Sep 07, 2026 at 03:24:40PM +0800, ChengyuZhu6 wrote:
> From: Chengyu Zhu <hudsonzhu@tencent.com>
> 
> The selected fingerprint xattr is treated as opaque and accepts any
> positive length up to the filesystem block size.  Appending the domain ID
> directly to such a value leaves no boundary between the two key components
> if a different fingerprint length is used.
> 
> Change the key encoding as follows:
> 
>   fingerprint || domain_id  ->  domain_id || '\0' || fingerprint
> 
> Since a mount option string cannot contain NUL, this makes the in-memory
> tuple unambiguous without constraining fingerprint contents or changing
> the on-disk format.
> 
> Signed-off-by: Chengyu Zhu <hudsonzhu@tencent.com>

Subject: erofs: delimit inode_share key components

Previously, inode_share keys are encoded as follows:
    fingerprint || domain_id

It would be better to have a separator between fingerprint and domain_id
so that fingerprint won't be parsed as part of a domain_id.

Change the key encoding as follows:
    domain_id || '\0' || fingerprint

Since domain_id is a NIL-terminated string, this makes the in-memory
key indices unambiguous.

> ---
>  fs/erofs/xattr.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
> index df7ea019526d..17c640aca5f7 100644
> --- a/fs/erofs/xattr.c
> +++ b/fs/erofs/xattr.c
> @@ -621,6 +621,7 @@ int erofs_xattr_fill_inode_fingerprint(struct erofs_inode_fingerprint *fp,
>  	struct erofs_sb_info *sbi = EROFS_SB(inode->i_sb);
>  	struct erofs_xattr_prefix_item *prefix;
>  	const char *infix;
> +	size_t domainlen;
>  	int valuelen, base_index;
>  
>  	if (!test_opt(&sbi->opt, INODE_SHARE))
> @@ -633,17 +634,19 @@ int erofs_xattr_fill_inode_fingerprint(struct erofs_inode_fingerprint *fp,
>  	valuelen = erofs_getxattr(inode, base_index, infix, NULL, 0);
>  	if (valuelen <= 0 || valuelen > (1 << sbi->blkszbits))
>  		return -EFSCORRUPTED;
> -	fp->size = valuelen + (domain_id ? strlen(domain_id) : 0);
> +	domain_id = domain_id ?: "";
> +	domainlen = strlen(domain_id);
> +	fp->size = domainlen + 1 + valuelen;
>  	fp->opaque = kmalloc(fp->size, GFP_KERNEL);
>  	if (!fp->opaque)
>  		return -ENOMEM;
> +	memcpy(fp->opaque, domain_id, domainlen + 1);
>  	if (valuelen != erofs_getxattr(inode, base_index, infix,
> -				       fp->opaque, valuelen)) {
> +				       fp->opaque + domainlen + 1, valuelen)) {
>  		kfree(fp->opaque);
>  		fp->opaque = NULL;
>  		return -EFSCORRUPTED;
>  	}
> -	memcpy(fp->opaque + valuelen, domain_id, fp->size - valuelen);
>  	return 0;

Can you apply the following diff? domain_id cannot be NULL so it was a
redundant check:

diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
index 17c640aca5f7..57cfb7520782 100644
--- a/fs/erofs/xattr.c
+++ b/fs/erofs/xattr.c
@@ -620,9 +620,8 @@ int erofs_xattr_fill_inode_fingerprint(struct erofs_inode_fingerprint *fp,
 {
 	struct erofs_sb_info *sbi = EROFS_SB(inode->i_sb);
 	struct erofs_xattr_prefix_item *prefix;
+	int domainlen, valuelen, base_index;
 	const char *infix;
-	size_t domainlen;
-	int valuelen, base_index;
 
 	if (!test_opt(&sbi->opt, INODE_SHARE))
 		return -EOPNOTSUPP;
@@ -634,7 +633,6 @@ int erofs_xattr_fill_inode_fingerprint(struct erofs_inode_fingerprint *fp,
 	valuelen = erofs_getxattr(inode, base_index, infix, NULL, 0);
 	if (valuelen <= 0 || valuelen > (1 << sbi->blkszbits))
 		return -EFSCORRUPTED;
-	domain_id = domain_id ?: "";
 	domainlen = strlen(domain_id);
 	fp->size = domainlen + 1 + valuelen;
 	fp->opaque = kmalloc(fp->size, GFP_KERNEL);


>  }
>  #endif
> -- 
> 2.51.0

