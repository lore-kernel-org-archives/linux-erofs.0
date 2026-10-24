Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6BD606A31D
	for <linux-erofs@archiver.kernel.org>; Sat, 24 Oct 2026 19:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FTPJQGRD
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jBr7S3HZyz2xlw;
	Sun, 25 Oct 2026 06:49:24 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792871364;
	cv=none; b=TqOxWuMoKFpfB/l2KnBVZoy6bEtntVGJ/iviKgub4neOjXbzv3u9g1vCOp4BjGHnWjbia0+RAjdbUPHl4EAIDVYPPOExyDR/EjEkFcLDNzJ9zjA7JKsRpg0txcmIxlWmW1rfNatvpwuy650zjf+b9CGO3m0mS2gw3SCO/I7gGyqdJTp3+aPP7K9FtpfmUeq6/YB0sP4tHkkalRWYDzTaM968X6FqNnqT0r99+yBPXl6bgZd84LyixwzXAJE3v7cMT5DFOigSQ0E6LD3W8FIob7ltf7klgnK+UeEl78eQkPUo442GZM2YaAPpjoZDNHxd6K9xYoVhN5iuOhcrhEkXuA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792871364; c=relaxed/relaxed;
	bh=Lolb73ZzkNeVgvmRmzP6aoaOobLavyPT6W9rKgYFA2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MGFueoukBU/BqFOpKOxHlskdTJsBsnJr3qGPW/fHIayiYvdr8fby1i60qwA8XA7fubJ7ncBqTilZFxLaH5o17z+38xDXwrTMHP0rZmBlKORaWyfAJMFi6lFfRgIQRHX7MkBiE2qU6jAUJDAk0Ag5JizfnikuN54OjA/PDi2EsJ3TVN+BeHTcW3mNMo8n7iCa3EwP2ZCOSntn9dI/wlZ8ek4TUzj7uSaXX9ah4kw0Gh9I9oqCDt+5nLIuOEggDH6FL4m7l5BeogLH4V/FlXvsQrY9mLEYbba0PZPCBaGhcXQp81/I1hnMqCDzCM8Z5BJYqdmn2G28ZJCPYluWrYNHow==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FTPJQGRD; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FTPJQGRD;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jBr7R2Mzsz2xjh
	for <linux-erofs@lists.ozlabs.org>; Sun, 25 Oct 2026 06:49:23 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7C458600D4;
	Sat, 24 Oct 2026 19:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD24E1F01825;
	Sat, 24 Oct 2026 19:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792871359;
	bh=Lolb73ZzkNeVgvmRmzP6aoaOobLavyPT6W9rKgYFA2k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FTPJQGRDTq/Damy+nZIDwbaBi5mKEikg6ZiCXnHVxB4mlVRQGnCR9ffg1/1jfk1Tr
	 9HhOxXIMp2I9res7so/5oAS/TK0KBEtNKaA5IXLFM3dcjsOyLFerixtLr9aX3coHc9
	 rFfyT/sgchtEh+Jbr/0HJpv76tAhkipoY+GKcDhsU7r/T+BtznLXwf8jCy+a0eiCTP
	 JQ7RwCT0kBt4ZQynGpn0bi+sdERq+5aHRd6DK5H9hjps5LrIqzWdogvvD+NILMc097
	 +gbIjG98PApTqTlUYyJ/lnDy1dRKDS2LCXyEvolD48WMIunNXR5liA0ba0iseRT0Ng
	 La0jb+VXxo7DA==
Date: Sat, 24 Oct 2026 21:49:09 +0200
From: Gao Xiang <xiang@kernel.org>
To: Hengyu Liang <hengyul@cs.unc.edu>
Cc: xiang@kernel.org, chao@kernel.org, zbestahu@gmail.com, jefflexu@163.com,
	dhavale@google.com, hongbohbli@tencent.com, guochunhai@vivo.com,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] erofs: fix metadata reads at the end of file-backed
 images
Message-ID: <at0LtfBEoQpV4VDn@MacBookPro>
Mail-Followup-To: Hengyu Liang <hengyul@cs.unc.edu>, xiang@kernel.org,
	chao@kernel.org, zbestahu@gmail.com, jefflexu@163.com,
	dhavale@google.com, hongbohbli@tencent.com, guochunhai@vivo.com,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
References: <20261023190051.3457491-1-hengyul@cs.unc.edu>
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
In-Reply-To: <20261023190051.3457491-1-hengyul@cs.unc.edu>
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 03:00:51PM -0400, Hengyu Liang wrote:
> Commit e587a984d332 ("erofs: use dedicated meta inodes for file-backed
> mounts") made erofs_read_meta_folio() read the metadata of a
> file-backed mount one whole folio at a time.
> 
> However, an image only has to be a multiple of its block size. With a
> block size below the page size, it can end in the middle of a page. The
> read of that last page is then short, and erofs_fileio_ki_complete()
> fails it with -EIO. As of now, inodes in the last page of such an image
> cannot be read, and an image smaller than a page cannot be mounted.
> 
> The issue can be reproduced with util-linux 2.41, whose mount uses the
> image file directly:
> 
>     mkdir src
>     for i in $(seq 50); do echo $i > src/$i; done
>     mkfs.erofs -b512 test.erofs src
>     mount -t erofs test.erofs /mnt
>     ls -l /mnt
> 
> Before that commit, ls -l lists all 50 files. After it, ls -l reports
> "Input/output error" for 24 of them.
> 
> This patch reads the folio only up to the end of the backing file and
> zeroes the rest, as the page cache of the backing file did before. A
> folio that lies wholly past the end is zeroed without a read.
> 
> Fixes: e587a984d332 ("erofs: use dedicated meta inodes for file-backed mounts")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
> ---
> Changes in v2:
> - Also zero a folio that lies wholly past the end of the backing file,
>   without a read, as suggested by Gao Xiang.
> - v1: https://lore.kernel.org/r/20261023174232.3282900-1-hengyul@cs.unc.edu
> 
> Tested in KVM with KASAN on 734bef548a96: the images used for v1, plus
> three images cut so that whole folios lie past the end. With this
> patch every complete image reads back correctly, and the cut images
> give the same results as v7.2 (EFSCORRUPTED instead of EIO for the
> inodes past the end).
> 
>  fs/erofs/fileio.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/erofs/fileio.c b/fs/erofs/fileio.c
> index c36a90a1a4cb..a77af604479f 100644
> --- a/fs/erofs/fileio.c
> +++ b/fs/erofs/fileio.c
> @@ -142,17 +142,30 @@ int erofs_read_meta_folio(struct file *file, struct folio *folio)
>  		.dev = { .m_pa = folio_pos(folio), },
>  	};
>  	struct inode *inode = folio_inode(folio);
> +	size_t len = folio_size(folio);
> +	loff_t pos, isize;
>  	int err;
>  
>  	err = erofs_map_dev(inode->i_sb, &io.dev);
>  	if (err)
>  		return err;
>  
> +	pos = io.dev.m_dif->fsoff + io.dev.m_pa;
> +	isize = i_size_read(file_inode(io.dev.m_dif->file));
> +	/* the image may end before the end of the folio, zero the rest */

I dropped this obvious comment, otherwise it looks good to me:

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

