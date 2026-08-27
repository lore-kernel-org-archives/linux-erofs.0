Return-Path: <linux-erofs+bounces-4356-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7C35C61DCD
	for <linux-erofs@archiver.kernel.org>; Thu, 27 Aug 2026 16:52:55 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hW6yY5c7Xz2y2L;
	Fri, 28 Aug 2026 02:52:53 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787849573;
	cv=none; b=BqEZhhVoYy2afY5NsHW77juYl/aQRtZReYFn5Ki5xpWMagqLN/Lv4LiB1WByLiLgwBys9JWrYoJrrFXmuTUEhBPhw86yQ2iAOnDLzYJqumubJXYb6VJJfFCAdlfHcWY8e9mc0QBdcVNn7jVjTKyzuP7Ft5GkltiHeKXoujm/r9oPe4XU+0oYZF81Wbn9W1RK5mz+IbdHfsUFLYhKCP7KXn9xk6i7NrEyol/6z3WKUl+y8AJxChsGJye/W/fOXAInoej3H9mXyar7OTZUvh/R28XvBI65QjB4LfbOhQ5vvxQ0b7p9o80rbG9XHVQUEEuzw9/dtjoi1QsIR6HOU0P7pA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787849573; c=relaxed/relaxed;
	bh=La7+n/BTOVLpEFBV8eTM49N7cZ13U+f0qngddms9da0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gH8BLaxGJJvvEGK1wd2mYEtXTLkGyqczXqTCdaKaKEq+4xx18sRyeTYf9ki/eLZeGXtPJiVMvAW9zUUFa7/Uv7AJNQbSq61O5cAq66xkZBWnScYZC0M08B00ytcxJL/3sXDObsBAj/MsfLKvVUo1Vyq+OOkcLisdPzWiJwljjdY50Ij6wuS74yLhrbZPEC3whnxou+SxU+MNN8/ap4dm3e1+/AzUSAZORXvTU5j3SUe2DbDRsfAy16A/AFpIDNsFZwAawikeaQqobeO0T1SLnf2H6NJNTjC+SApK7NxMgMNIxLgzzYpenTviZVXnsYjZmCS52xzCuCgdF7AMSxoGMA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VbVM9CNp; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VbVM9CNp;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hW6yX1jq5z2xtt
	for <linux-erofs@lists.ozlabs.org>; Fri, 28 Aug 2026 02:52:52 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 26A8A600D4;
	Thu, 27 Aug 2026 16:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3381F000E9;
	Thu, 27 Aug 2026 16:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787849568;
	bh=La7+n/BTOVLpEFBV8eTM49N7cZ13U+f0qngddms9da0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VbVM9CNpTwRJiYnopU9nWvH85KXU34YOjxrgKJFWH61d35F5Omn302tNDqvZ/+32k
	 +udv1O4T11fWssGOcpW7Vh1vLLplY3Byne2E6T7YUt58oHIrHcTgUk28rSBEIESlpE
	 Gapq3nkulOJlaFkNRA14fpxMLXTqEm0n/PuPIXsIuCRcfjr9xNw3IYYt5NdjBKUgCQ
	 CbRrPsiOznfBdwdcNiGq67nPLo2V6oQPoYaexSyHx1iR0oB0K8Sgt1LF3AoU57q20/
	 gHr2yJX7CdnNI2QRVvn0rrZOOZZlsnYpWnOC24/egqrTQ4LZdWwAp3UCmouAuS3EYD
	 XK9MSRQL3E+mw==
Date: Fri, 28 Aug 2026 00:52:42 +0800
From: Gao Xiang <xiang@kernel.org>
To: mike.malyshev@gmail.com
Cc: linux-erofs@lists.ozlabs.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH] erofs-utils: lib: follow symlinks on intermediate tar
 path components
Message-ID: <apBrWmPu9hMDcZHS@192.168.5.19>
Mail-Followup-To: mike.malyshev@gmail.com, linux-erofs@lists.ozlabs.org,
	Gao Xiang <xiang@kernel.org>
References: <20260725150920.1900298-1-mike.malyshev@gmail.com>
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
In-Reply-To: <20260725150920.1900298-1-mike.malyshev@gmail.com>

Hi Mikhail,

On Sat, Jul 25, 2026 at 03:09:20PM +0000, mike.malyshev@gmail.com wrote:
> From: Mikhail Malyshev <mike.malyshev@gmail.com>
> 
> mkfs.erofs --tar fails to convert layers that store files underneath a
> symlinked directory, a very common "usr-merge" layout in RHEL/UBI/Fedora
> based OCI images.  For example a base layer contains
> 
>     lib64 -> usr/lib64        (symlink)
>     usr/lib64/                (directory)
>     lib64/libc.so.6           (regular file, path goes THROUGH the symlink)

Also my another question is that how these tars are generated, I guess
it should be recorded as `usr/lib64/libc.so.6`, why does it need to
record a path with a symlink component, that is confusing to me
honestly.

> 
> erofs_rebuild_get_dentry() walks the path component by component and, when
> it hits the "lib64" component, finds an existing dentry that is a symlink
> rather than a directory.  Since there are still components left to resolve
> it bails out with -ENOTDIR.  In practice this surfaces as a bogus ~2 TiB
> image and "Could not format the device", making the whole layer
> unconvertible even though nothing is wrong with the tar.
> 
> A real filesystem (and containerd's walking differ, which applies the same
> layers via fs.RootPath) resolves such a path by following the symlink to

It would be better to summarize the various tar behaviors here too as
you mentioned in the previous reply.

> its target directory.  Do the same during tar rebuild: when an intermediate
> path component resolves to a symlink, follow it to the target directory
> (relative targets from the containing directory, absolute targets from the
> tree root), chasing chained symlinks up to a bounded depth to avoid loops.
> 
> Signed-off-by: Mikhail Malyshev <mike.malyshev@gmail.com>
> ---
>  lib/rebuild.c | 72 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 70 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/rebuild.c b/lib/rebuild.c
> index 108a464..febc95c 100644
> --- a/lib/rebuild.c
> +++ b/lib/rebuild.c
> @@ -82,8 +82,60 @@ struct erofs_dentry *erofs_d_lookup(struct erofs_inode *dir, const char *name)
>  	return NULL;
>  }
>  
> -struct erofs_dentry *erofs_rebuild_get_dentry(struct erofs_inode *pwd,
> -		char *path, bool aufs, bool *whout, bool *opq, bool to_head)
> +/* Bound symlink chains during path resolution, like the kernel's MAXSYMLINKS. */
> +#define EROFS_REBUILD_SYMLINK_DEPTH	40
> +
> +static struct erofs_dentry *__erofs_rebuild_get_dentry(struct erofs_inode *root,
> +		struct erofs_inode *pwd, char *path, bool aufs,
> +		bool *whout, bool *opq, bool to_head, unsigned int depth);
> +
> +/*
> + * Resolve the target of an intermediate symlink path component to its
> + * directory inode, following chained symlinks up to a bounded depth.  This
> + * lets tar layers that store files under a symlinked directory be converted
> + * the same way a real filesystem extracts them, e.g. usr-merge layouts where
> + * "/lib64 -> usr/lib64" coexists with entries such as "lib64/libc.so.6".
> + */

I guess the comment is unneeded since the code is already
straight-forward.

> +static struct erofs_inode *erofs_rebuild_follow_link(struct erofs_inode *root,
> +		struct erofs_inode *pwd, struct erofs_inode *link,
> +		unsigned int depth)
> +{
> +	struct erofs_dentry *d;
> +	struct erofs_inode *base;
> +	bool dumb_wh, dumb_opq;
> +	char *target;
> +
> +	if (depth >= EROFS_REBUILD_SYMLINK_DEPTH)
> +		return ERR_PTR(-ELOOP);
> +	if (!link->i_link)
> +		return ERR_PTR(-ENOENT);
> +
> +	target = strdup(link->i_link);

I guess we could just use an on-disk variable instead?

> +	if (!target)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* absolute targets are resolved from the tree root */
> +	base = target[0] == '/' ? root : pwd;
> +	d = __erofs_rebuild_get_dentry(root, base, target, false,
> +				       &dumb_wh, &dumb_opq, false, depth + 1);
> +	free(target);
> +	if (IS_ERR(d))
> +		return ERR_CAST(d);
> +	/* target referred to the root or the base directory itself ("/", ".") */
> +	if (!d)
> +		return base;
> +	if (d->type == EROFS_FT_DIR)
> +		return d->inode;
> +	/* the target is itself a symlink: keep following the chain */
> +	if (d->type == EROFS_FT_SYMLINK)
> +		return erofs_rebuild_follow_link(root, d->inode->i_parent,
> +						 d->inode, depth + 1);

It seems that it could be converted into a tail recursion.

Otherwise it looks good to me.

Thanks,
Gao Xiang

