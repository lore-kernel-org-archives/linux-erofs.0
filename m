Return-Path: <linux-erofs+bounces-3043-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA94510A62DE
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Mar 2026 14:14:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fhQkz0Dnfz2xlM;
	Fri, 27 Mar 2026 01:14:35 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774534474;
	cv=none; b=F32j9/gZGpTjZeLYjN0TUlhRLXejVzRmXCSFzdXkJ9kU466jbbURoQY4mvJhVf/h1LdPombr1xwOS51mJMYEmFkSele3iDaAV4u/HucXN9Uu6fOcs0oGiIxhVr0usq+Fw1Hl4hCQOWc8ENKjbb4nBvMndsDwoEjnC+8RMknCSYPXK30sHPFB1vcoMHql8pQXn5ODQhgMWpfKu9wGWw81yYqpMWVZqorFH1qMS3D0i9Ji2NAlze62tDHi7vz4puGqthlctEbP8j+lSy4ySVT9/qTz1CI0yVrb56LD3rIg2ZRBIqhv2lct0qQzslPULgUTDD++sJ/KOEAwjd7wEDHXRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774534474; c=relaxed/relaxed;
	bh=FZooCPQPySD2tslSmg9lFUIcLfIfFCj93VaAbqTuJFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mWx6i0pt0lnfX04bc5/7nXDH/jl9maDsKSRij5+GzFPB5Vb8uPnzKVnjhpJsoD8D2UWxzR9Sdlx39GC0ldA+Y8np8M1Qd+YsQUXhs3H+eU9czr0PjWfzheVfbcEDwjMPCDHLbZSN7lN7nR7snMGYwd4V1r+2+I3BEQgApf7w6pe1c41PIghKy4pfqB00/OAcqXp/nTzGL9oGxd8WKe8I8EhBlTDgdLSy1DmjARNFu1HWvJkMGSPiHHQznd1/mZd29/fq5bvBNuuZWvhDZViAhE6XmdedWfc+dfPBL/pvG5h7N9Q4lA+gIH0sxRRHdrdk/FjcofgEO3UtEyKjqqiDUQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=cU6Z0CDK; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=cU6Z0CDK;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fhQkx5jCjz2xS5
	for <linux-erofs@lists.ozlabs.org>; Fri, 27 Mar 2026 01:14:33 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2594A44478;
	Thu, 26 Mar 2026 14:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F086EC116C6;
	Thu, 26 Mar 2026 14:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774534466;
	bh=9/Mc8wqWTo8FPFWf+YyPCWyvxNDgMHkuBpBcOLX21aE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cU6Z0CDKLvPywdcWRaVckLWCGFMQ9BFlM0IEu+M554IZykD8OMttZxM4vFECn2de6
	 ljdVm+SE1Y90FqE/VgCURofZNyRt9oI6AQy/20XN3PiiBzTgrHnRt3bU3BSdQXS8QZ
	 oPKMegFXcX7QdSNJdkkklUOF6HVdAyxoVsaK6kt94bavqoexspxGFRrGuaKDXleUNA
	 7GCmlhztB8Wkb+qSttaCbKQX+vWak9Qin5x5NJ+HINkXo/DHgCSKMV2r301dRSdvx/
	 NU3VvJfrdunBQ9tV5NvKzAAALXy5VdZLNcaSLBJloG3/atVngBKzhRho/7YnFWZqJv
	 5qFkISDTdKr+A==
Date: Thu, 26 Mar 2026 15:14:21 +0100
From: Christian Brauner <brauner@kernel.org>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	Amir Goldstein <amir73il@gmail.com>, Gao Xiang <xiang@kernel.org>
Subject: Re: [RFC PATCH v2 1/2] lsm: add backing_file LSM hooks
Message-ID: <20260326-wildwasser-notorisch-7271180258ef@brauner>
References: <20260323042510.3331778-4-paul@paul-moore.com>
 <20260323042510.3331778-5-paul@paul-moore.com>
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
In-Reply-To: <20260323042510.3331778-5-paul@paul-moore.com>

On Mon, Mar 23, 2026 at 12:24:18AM -0400, Paul Moore wrote:
> Stacked filesystems such as overlayfs do not currently provide the
> necessary mechanisms for LSMs to properly enforce access controls on the
> mmap() and mprotect() operations.  In order to resolve this gap, a LSM
> security blob is being added to the backing_file struct and the following
> new LSM hooks are being created:
> 
>  security_backing_file_alloc()
>  security_backing_file_free()
>  security_mmap_backing_file()
> 
> The first two hooks are to manage the lifecycle of the LSM security blob
> in the backing_file struct, while the third provides a new mmap() access
> control point for the underlying backing file.  It is also expected that
> LSMs will likely want to update their security_file_mprotect() callback
> to address issues with their mprotect() controls, but that does not
> require a change to the security_file_mprotect() LSM hook.
> 
> There are a two other small changes to support these new LSM hooks.  We
> pass the user file associated with a backing file down to
> alloc_empty_backing_file() so it can be included in the
> security_backing_file_alloc() hook, and we constify the file struct field
> in the LSM common_audit_data struct to better support LSMs that need to
> pass a const file struct pointer into the common LSM audit code.
> 
> Thanks to Arnd Bergmann for identifying the missing EXPORT_SYMBOL_GPL()
> and supplying a fixup.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> ---
>  fs/backing-file.c             |  18 ++++--
>  fs/erofs/ishare.c             |  10 +++-
>  fs/file_table.c               |  21 ++++++-
>  fs/fuse/passthrough.c         |   2 +-
>  fs/internal.h                 |   3 +-
>  fs/overlayfs/dir.c            |   2 +-
>  fs/overlayfs/file.c           |   2 +-
>  include/linux/backing-file.h  |   4 +-
>  include/linux/fs.h            |   1 +

Thanks, this looks much better.
Acked-by: Christian Brauner <brauner@kernel.org>

