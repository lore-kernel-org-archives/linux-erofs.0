Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4B260A2629
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 14:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tcwd7Q8/
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP8py0w7bz2yS4;
	Wed, 11 Nov 2026 01:55:54 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794322553;
	cv=none; b=ZWmI47h9+7bPCAYXyB9DQ1BzP0SzNKM/LyHB5FRRcK8U2h6p9Z62ft4JK82WKUBCObQtx3bkmfRHqTDGHqgrMAaABUMc0f+S5j1UghuN2g4x4NYzF5ePV9hq32Ww/ioFt6qIy8D2am5P/mcDViH+m0uqIOy/OWgHJC17qeP9ubkcH6o2yggSCaYQvlC3msfhgG7vQsaCUbL4xKJbpKmY6r8MQLlcKKatvgky4myaUUv/EvFFqwzfjfjvNDZTX18NbuTHnIXsERzwO2zRQh0o96vvH22gAavggfufBZLQ3KZ/d2Bb47lhaGyCDQcrJAGFsY5TWywsBn9sSpkFTw7OdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794322553; c=relaxed/relaxed;
	bh=zSjXnOetE5oKa5v8S9LBrUhcmgizc8ch93AeD/W6gEI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=fvr/zllv3B3IKmByIl9c4uio75kfihg7nn/Mt4f+Zj+hFcY0Btu3DJBaAPGFdN/BNjxVzDqcDTgte19W7dIaWE9T8/sKZL/rKJeV7vV6twIobzUMbzGeEnOKvZ2NjlULAG5emFuPbXfM17e+09gH1zab4zGGMeWIgjp4KZrK2rB+KpzJ3AI7+v3D9/2Bwr8+IE9ngUzBHHwIlbcP5ILyXIgtMqPkyytC4HYkBlyk/YCH0dBVCasmWKJ9nPG01MJCLghaGAlQPCZhiZKGsUB+EyF5cQitxuy5KSn4HANE571ECqmctFOAPYYi5A6R6NeworZaXCSF6Gqiq8l5/jAXaw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tcwd7Q8/; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=cel@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tcwd7Q8/;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=cel@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP8pw5vflz2yNj
	for <linux-erofs@lists.ozlabs.org>; Wed, 11 Nov 2026 01:55:52 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D6AD8639EB;
	Tue, 10 Nov 2026 14:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8D71F008A2;
	Tue, 10 Nov 2026 14:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794322549;
	bh=zSjXnOetE5oKa5v8S9LBrUhcmgizc8ch93AeD/W6gEI=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Tcwd7Q8/BgCZr0AJA+q53XtkaEXHNBQAptcCIoE3INOkDT8T++JPLwFgnijhu6LIp
	 QoJCfJqeBNhK26M7LL9xd4MzXxKVISVDOEW1cYrYEyBiFKRmR2hdLsioEex6m+2Rc5
	 2AgfVzjCsuMDtAVvAKOrFX1qXAfAYeUYjVl2rownrESZ29DXkmWTHYRM7alPMZLQ6M
	 DZH727vPlYTYzZb+oco6o/Bkhlk4m5LBSezhlvCb0bhHHiXIMbUlIMDObU3PIfYN46
	 k7napT6YlagBuXnh78UDBF3WtFBwiJfcd2zG9H8WTZ7Zkc62YNaLopDBhwYuzfc472
	 iPuH2WgxnRVeQ==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id B2761F40069;
	Tue, 10 Nov 2026 09:55:47 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Tue, 10 Nov 2026 09:55:47 -0500
X-ME-Sender: <xms:czDzahOxHA_IGoa_FJdwV0BFPQw-nSdKO6kKGUN5puCfrxj2G2sK_w>
    <xme:czDzauxKYck9zKSqhpZaTHxPL9lIOi42MPCnrNTR7eaQqnpkmbe8dEx0PuhUogQkg
    tb2W38kOzksOJlDJ4uTGR7-rkbiwtctKuF5oVtOm556TqS1yjjUw9U>
X-ME-Proxy-Cause: dmFkZTE8jIcOTzT9axQiHwEjJScKTRkNH3ZVhgYbwXrBMnGwr/PZk5kUfGxy+RC0ezRM03
    2Axgl1A3kstcvJQqQJ+tEirxS634eXBQm2b+wwk+7byJnMoEdYYw7Lfb7185Bnwoliq1Mt
    XZ8lliUhOZ8AACZwbl4T2Tc7NYRy4GvnOujvSweRGBGAD4OQXGjTipshhA5n2cB6RQlk4p
    zmTRFZMOMjoY8cueG7e24ndoN2R/gq/lSNUbCVZu/PUOrAg9f6aovYYa9SSKBBYGtgXYMN
    0qbpFOi4S4kwXDcxuFcZlmK43Jt2p3+0W9uSzX8U3QJynW/odwma6a1hhpAbc8zEaSnbtk
    CFI/IAk8YwHJ0hyg7qaH8oiiVC3V/1ZiobIhoPO231VrqQk5oaP4jl+jS7yMnBbNxynDhF
    /tTsfxMaF/A9xwJBu4sKm+3lzwzMEEbqt79mE4Lq/VAgowI2/Z3gVdFMTE48DIB1KcUvAe
    gGFx1Bx/tQmWXfeE09uUSkiQ2KYN+OrlgTMnrepjVRxO73rY2t7sodPh2AhJIAG1ZYT5ga
    3nwb3G0mQrnmFOm4Qa4C2JwbajMdJBWMeam4uZKQraajbqcBHzCXvMtQm1fQbm3S2rexTo
    KA6wW/vDabSoXlut9Nm5uKTSjp20eGQ9lpLOxOz31c8eLm8Mlp10sjOYDNZA
X-ME-Proxy: <xmx:czDzaoanLMdLTFqhzMhrxv5H09chgFe3GMMhc1XBCkfiMJQ_ckta8Q>
    <xmx:czDzauzWTK7EYc76X_4JSXvP7e9Yqejr2yggz6O-tuvCpsEWBQGUaQ>
    <xmx:czDzasWQEDY8T3p3eaJhPzKDKFxYGPCQnFb1-n-prg7tBs3f0gJpWA>
    <xmx:czDzaqbpJaYjvNkk5zy3xoww5EsXMA5_awnvU25FYCgSdhgQQ41Hfg>
    <xmx:czDzavOKwCwywHfR1JNgdmNe33GAeUXrw31wmu_3YBRbMsucyl2ChD_t>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 7D2B9780070; Tue, 10 Nov 2026 09:55:47 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
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
X-ThreadId: AKCAcWHxcB8B
Date: Tue, 10 Nov 2026 09:55:27 -0500
From: "Chuck Lever" <cel@kernel.org>
To: "Christian Brauner" <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: "Jann Horn" <jannh@google.com>, "Chris Mason" <mason@kernel.org>,
 "Josef Bacik" <josef@toxicpanda.com>, "Christoph Hellwig" <hch@lst.de>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 target-devel@vger.kernel.org, driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org,
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
 fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
 xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
 linux-s390@vger.kernel.org, "Linuxppc Dev" <linuxppc-dev@lists.ozlabs.org>,
 linux-usb@vger.kernel.org, "Amir Goldstein" <amir73il@gmail.com>,
 linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Message-Id: <47b8b8cb-aadb-4f84-aa5c-c5a74d73fac1@app.fastmail.com>
In-Reply-To: <20261110-work-loop-pseudo-v1-21-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-21-4c998976c6c7@kernel.org>
Subject: Re: [PATCH RFC 21/41] nfsd: use fc_init_pseudo()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On Tue, Nov 10, 2026, at 4:14 AM, Christian Brauner wrote:
> Initialize the nfsd filesystem as a pseudo filesystem. This raises
> SB_I_PSEUDO and also SB_I_NOEXEC and SB_I_NODEV. It never holds
> executables or device nodes.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/nfsd/nfsctl.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
> index f32311f2d7cf..ce2666deddbd 100644
> --- a/fs/nfsd/nfsctl.c
> +++ b/fs/nfsd/nfsctl.c
> @@ -9,6 +9,7 @@
>  #include <linux/namei.h>
>  #include <linux/ctype.h>
>  #include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> 
>  #include <linux/sunrpc/cache.h>
>  #include <linux/sunrpc/svcsock.h>
> @@ -1375,6 +1376,7 @@ static int nfsd_init_fs_context(struct fs_context *fc)
>  {
>  	put_user_ns(fc->user_ns);
>  	fc->user_ns = get_user_ns(fc->net_ns->user_ns);
> +	fc_init_pseudo(fc);
>  	fc->ops = &nfsd_fs_context_ops;
>  	return 0;
>  }
>
> -- 
> 2.53.0

Acked-by: Chuck Lever <cel@kernel.org>


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)

