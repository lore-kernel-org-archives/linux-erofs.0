Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C28E606A31B
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Nov 2026 08:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XwfnYTb7
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jKJhW2kdjz2xHG;
	Wed, 04 Nov 2026 19:36:59 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793781419;
	cv=none; b=dUwJMroxG724d7sbBT2rzFDhfFeBTV/0gt7AarGmVX8B2E6Cuaxnc5XrPi2vtKntB3eQsV+cfPwhD5i16tnAz9auwjAIYYMkm5c/YJ2BDnjE7AiQrISQrTwJwgTzTZBieBi8BJgk11pvx8TmR4ZGrKM3v2rhKP5TY9IF2k7gErKnN5PPYdW90F+VFxHaHThwJGIgKgrCsQupsroyVDnUlCfXTMDegJvuwlb4fCbZlUV/IpEWvm6fVmKXQGEZVJQuLp3s1+Ky/LvhApufzWNXcXSAO7caEYOXfynOgUurMIT8MHowObO8Q2vxdSfwX4bqnL0CrsqRK4HreItj3aZnvg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793781419; c=relaxed/relaxed;
	bh=th5KrBClXNeY5x+YGXYH9ms1fJFnGjAR9DmFXlEwDcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HFTXG5ZK2ZwD7erQKSg9JS4dKn2ZIeEL5nTjTki0fFkBsgjB9x1ATwlgFIKfHU8a7AbSVAoVPERM3WFDCqtAPF20dXGfaNFVGui87RjVTk19st20TJL04QkESROxZYmv8Ya4e0IFURXfQ2BgcOAiAlcJOdy6yXznO/uHv3vfk3HltsWRbO8gJzycvOycq957c10VxKZtu1G/Xkr78B/Ke8YNfmkOZUWONhAOpm6zuVeVlXO5kXFHHijpFuFeUDXObkamSpofS21tSpWKP2hs/c8Dsi+PFhhlHA2oGOIq6zLsN7zRFj7548CdQyho/xekRfztxzRGSMtUQGImKq1KqQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XwfnYTb7; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XwfnYTb7;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jKJhT5xDrz2xH7
	for <linux-erofs@lists.ozlabs.org>; Wed, 04 Nov 2026 19:36:57 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C73C43499;
	Wed,  4 Nov 2026 08:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468AB1F000C1;
	Wed,  4 Nov 2026 08:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793781413;
	bh=th5KrBClXNeY5x+YGXYH9ms1fJFnGjAR9DmFXlEwDcs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XwfnYTb7K5o7ANEgVmA0k47RXloK/1ynaYjttOUAqYxS0W8DGt5BtB72RMqXBVRun
	 z6IFAmWIxJdfex4NVms+Q7+oEhyJ8XpnGQdpSeudeLhwCCLHegqAx1V0CCawTajSNj
	 bOd2BCJe73P7Tz1ETLrZt4+r1oh7VFLJnIybS9KLFod3y7DNAZZA8d36NeeIV438Ne
	 7ukbrkw4YdJw03t9F+TpsVOJhRw56nlj/+H6/2Xl61ukEyaBc/D90hyejHOVVlEu36
	 7WIpQWu5zmtFbzImDit275eclMYT61eN0ZZ6J7YR1aRIJ2LCcGi1Xta6REiNvqtnkg
	 DBYvxHGn6XXiQ==
Date: Wed, 4 Nov 2026 09:36:47 +0100
From: Gao Xiang <xiang@kernel.org>
To: Wenyuan Xu <sereno.xu@deepseek.com>
Cc: xiang@kernel.org, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH] erofs-utils: fsck: extract zero-length xattr values
Message-ID: <aurunz5-1b4visC4@XiangdeMacBook-Pro.local>
Mail-Followup-To: Wenyuan Xu <sereno.xu@deepseek.com>, xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
References: <20261104035208.2471090-1-sereno.xu@deepseek.com>
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
In-Reply-To: <20261104035208.2471090-1-sereno.xu@deepseek.com>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Wenyuan,

On Wed, Nov 04, 2026 at 03:52:08AM +0000, Wenyuan Xu wrote:
> A zero return value from erofs_getxattr() denotes an empty attribute,
> but the extraction path treats it as an error.
> 
> Accept zero-length values and allocate at least one byte for the value
> buffer, avoiding dependence on malloc(0) behavior.
> 
> Signed-off-by: Wenyuan Xu <sereno.xu@deepseek.com>

According to
https://linux.die.net/man/2/getxattr

Return Value
On success, a positive number is returned indicating the
size of the extended attribute value.

So 0-sized xattrs are not a valid number or here is a mistake.

In principle, filesystems accept 0-size xattrs, and
overlayfs uses it (see ovl_path_check_origin_xattr()).

I think EROFS should support 0-size xattrs, but here
we shouldn't expand to 1.

I applied the following diff (please find if it works or not):

diff --git a/fsck/main.c b/fsck/main.c
index 8e3ae52..1a36ef8 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -458,25 +458,33 @@ static int erofsfsck_dump_xattrs(struct erofs_inode *inode)
 		size_t size = 0;
 
 		ret = erofs_getxattr(inode, key, NULL, 0);
-		if (ret <= 0) {
+		if (ret < 0) {
 			DBG_BUGON(1);
 			erofs_err("failed to get xattr value size of `%s` @ nid %llu",
 				  key, inode->nid | 0ULL);
 			break;
 		}
 		size = ret;
-		value = malloc(size);
-		if (!value) {
-			ret = -ENOMEM;
-			break;
-		}
-		ret = erofs_getxattr(inode, key, value, size);
-		if (ret < 0) {
-			erofs_err("failed to get xattr `%s` @ nid %llu, because of `%s`", key,
-				  inode->nid | 0ULL, erofs_strerror(ret));
-			free(value);
-			break;
+
+		/* Empty xattrs are allowed */
+		if (!size) {
+			value = NULL;
+		} else {
+			value = malloc(size);
+			if (!value) {
+				ret = -ENOMEM;
+				break;
+			}
+
+			ret = erofs_getxattr(inode, key, value, size);
+			if (ret < 0) {
+				erofs_err("failed to get xattr `%s` @ nid %llu, because of `%s`", key,
+					  inode->nid | 0ULL, erofs_strerror(ret));
+				free(value);
+				break;
+			}
 		}
+
 		if (fsckcfg.extract_path)
 			ret = erofs_sys_lsetxattr(fsckcfg.extract_path, key,
 						  value, size);

Thanks,
Gao Xiang

> ---
>  fsck/main.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fsck/main.c b/fsck/main.c
> index e54c523..9db5ae9 100644
> --- a/fsck/main.c
> +++ b/fsck/main.c
> @@ -458,14 +458,15 @@ static int erofsfsck_dump_xattrs(struct erofs_inode *inode)
>  		size_t size = 0;
>  
>  		ret = erofs_getxattr(inode, key, NULL, 0);
> -		if (ret <= 0) {
> +		if (ret < 0) {
>  			DBG_BUGON(1);
>  			erofs_err("failed to get xattr value size of `%s` @ nid %llu",
>  				  key, inode->nid | 0ULL);
>  			break;
>  		}
>  		size = ret;
> -		value = malloc(size);
> +		/* Empty xattrs are valid */
> +		value = malloc(size ? size : 1);
>  		if (!value) {
>  			ret = -ENOMEM;
>  			break;
> -- 
> 2.43.0
> 
> 

