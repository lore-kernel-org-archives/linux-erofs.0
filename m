Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E28A606A31E
	for <linux-erofs@archiver.kernel.org>; Fri, 23 Oct 2026 18:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OWlPZqPU
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jBBBs1l62z2y8m;
	Sat, 24 Oct 2026 05:20:05 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792779605;
	cv=none; b=jVtkp4GWhfvbSUkvGKfDxYXjxlS7xWtbo0fZZsHySkraCuvx7Q3K8F1ebr1kw0qDgoDehSIMk+9D+c8pU1c6FbQM/bVrH+I1IMv9mLYloW+Y1Ic9PZWA54SrNMNTx0EXDgfsLbpEoRr/G3756M//z2DpuzSvIM91PcWaeLiRRaxe1E6UZL4u0rm2T2wN4DHpvdo1Juto4bxI9O3GEdkigk8X/FC6wENVhNcXJVfY5F0VHWUDCU7h4mWz8VIJAhqF+aznDhLFuM8W+YlZ5jvNYMPFW1NXLmtTP1055yM4oMK4s8QKF2V/zCBxJkAWuQhL7hedIOhmpnTcEI+/GlsMOw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792779605; c=relaxed/relaxed;
	bh=G2c9gMhC26zOajKSMEZ7r3qKmAbIN4QuJKbmwPZjihI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eixhhs4vt8M+Q3hy8n9Jdgqv9FgNhKTkigf9uJsEl6wdnlWGsAnVdaZExMbZcx39xgNPZt4nVIkPzrgy3bjj91GsIffdi3WnGBxZ6CYt/0p0FfPh5a3kNacg6Z+GCSR+qR6vWVYbIJNNwD9+m5Bgfdhzk/kiErAyDEcQEPlBzW17Y85EApOs3rwMkYbAlCQvlnISgoJYB7ZvO5ndjvkGLKZAepmXrtMjBtokA6LfavwST+PciHuQZheGK6FklR2Iesy+CP72T/MtEjsbr4ixwNxx3JlS7UFe6gzsy1ErIK8peML72puhVevp2Q0mbCq7tARiJbw4nLBECQKIrvEj9A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OWlPZqPU; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OWlPZqPU;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jBBBq2ckvz2xpv
	for <linux-erofs@lists.ozlabs.org>; Sat, 24 Oct 2026 05:20:03 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B6E0D60142;
	Fri, 23 Oct 2026 18:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F24E1F01825;
	Fri, 23 Oct 2026 18:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792779599;
	bh=G2c9gMhC26zOajKSMEZ7r3qKmAbIN4QuJKbmwPZjihI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OWlPZqPULT7AvYT142dXhPcGli+cTs827dJh+OFQRg3hqG9TU077T28tpi5Y/QbfU
	 2O/oynuiepFmtEL7o/JYxeYIzGLIOuLFH8rWl+NFhJ+Va8rdylrykdLt53QhSOi++0
	 ucquZUZBvBo5MjidzBWGjh4eQDUJ1w8E8gASUL1pMvAjRR4MJI/20psHpIMk7y2PZW
	 al/+3tna+QI063mE3WJbffMTk3VY09wVqD/WJL5ryIWwaC5Wm0OtATwHTLKGYtf1pn
	 4Zrlrj2naxR7KOZ9VxCQlARjKIJvAelMZzQWZklNgKIQeZao5eYVV3Tv76tHsyV3JU
	 dbbYXM6Sra/cg==
Date: Fri, 23 Oct 2026 20:19:36 +0200
From: Gao Xiang <xiang@kernel.org>
To: Hengyu Liang <hengyul@cs.unc.edu>
Cc: xiang@kernel.org, chao@kernel.org, zbestahu@gmail.com, jefflexu@163.com,
	dhavale@google.com, hongbohbli@tencent.com, guochunhai@vivo.com,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] erofs: fix metadata reads at the end of file-backed
 images
Message-ID: <atulOBxgbf0OIyOE@XiangdeMacBook-Pro.local>
Mail-Followup-To: Hengyu Liang <hengyul@cs.unc.edu>, xiang@kernel.org,
	chao@kernel.org, zbestahu@gmail.com, jefflexu@163.com,
	dhavale@google.com, hongbohbli@tencent.com, guochunhai@vivo.com,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
References: <20261023174232.3282900-1-hengyul@cs.unc.edu>
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
In-Reply-To: <20261023174232.3282900-1-hengyul@cs.unc.edu>
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Hengyu,

On Fri, Oct 23, 2026 at 01:42:31PM -0400, Hengyu Liang wrote:
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
> zeroes the rest, as the page cache of the backing file did before.
> 
> Fixes: e587a984d332 ("erofs: use dedicated meta inodes for file-backed mounts")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>

Thanks for catching this!

Yes, since we reject short read on the complete I/O path,
but it makes post-EOF behavior wrong.

> ---
> Tested in KVM with KASAN on a804c5742bff: file-backed mounts of images
> with 512 to 4096 byte blocks, uncompressed and compressed, with and
> without directio. With this patch every file reads back correctly;
> without it, 24 of the 36 mounts give errors. Not tested on 16K or 64K
> page kernels, where 4K-block images should be affected too.
> 
>  fs/erofs/fileio.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/erofs/fileio.c b/fs/erofs/fileio.c
> index c36a90a1a4cb..b4ed7fe7347c 100644
> --- a/fs/erofs/fileio.c
> +++ b/fs/erofs/fileio.c
> @@ -142,17 +142,26 @@ int erofs_read_meta_folio(struct file *file, struct folio *folio)
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
> +	/* the image may end in the middle of the folio, zero the rest */
> +	if (pos < isize && isize - pos < len) {
> +		len = isize - pos;
> +		folio_zero_segment(folio, len, folio_size(folio));
> +	}
> +

Can you just 
	pos = folio_end_read(fi.folio, uptodate);
	isize = i_size_read(file_inode(io.dev.m_dif->file));
	if (pos + folio_size(folio) > isize) {
		len = isize > pos ? isize - pos : 0;
		folio_zero_segment(folio, len, folio_size(folio));
		if (!len) {
			folio_end_read(folio, true);
			return 0;
		}
	}

...

Since post-EOF should be filled with zeroes all the time.

>  	io.rq = erofs_fileio_rq_alloc(inode->i_sb, io.dev.m_dif->file);
>  	io.rq->bio.bi_end_io = erofs_fileio_meta_endio;
> -	io.rq->bio.bi_iter.bi_sector =
> -		(io.dev.m_dif->fsoff + io.dev.m_pa) >> 9;
> -	bio_add_folio_nofail(&io.rq->bio, folio, folio_size(folio), 0);
> +	io.rq->bio.bi_iter.bi_sector = pos >> 9;
> +	bio_add_folio_nofail(&io.rq->bio, folio, len, 0);

Thanks,
Gao Xiang

>  	erofs_fileio_rq_submit(io.rq);
>  	return 0;
>  }
> 
> base-commit: a804c5742bff224d4cb4d25dd383554d598be32b
> -- 
> 2.53.0
> 
> 

