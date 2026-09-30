Return-Path: <linux-erofs+bounces-4642-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9CE4CA5FC5
	for <linux-erofs@archiver.kernel.org>; Wed, 30 Sep 2026 17:27:42 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hw2704zrdz2y2J;
	Thu, 01 Oct 2026 03:27:40 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790789260;
	cv=none; b=HSFKn34yTwv32SDQxE6FsKvktRmC/XrtSz91F8jDd5eXFmDjqAA5fN0+gVFMb5Qea6V1eP/bcTf5Gx4vmBVc1Bx1B3YGDhm+NKYgLkGVwIQdGc9X9yRGoNVXDA5I+PCMacr0O9e4cjjr3YFOx23Mpix+TF1CIviyJwO9eG/9XLXYEt2rY5bwR5beYeEroS/c2TLGeLq/4hEoVSdtNRKpfIiS1gXI5Uf1fwr+IeQYMLg3OLbkFuEehLKnN47sKsESbgftlY0MJfZsVcDdCvWLIsAm9got0RWnScFraLrcaOj1RsDvzeTIufhqs6Y9gdVJk3PSJzK0nJ1AA4SCi5nBuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790789260; c=relaxed/relaxed;
	bh=GyghZvqdAdJddV47CNsr4GWT+47Z5Sjzvmlp4S+84dU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LjMpg7cEl5ExJNAeJb/VxggCLQRjBiEt5mteWZv+Zn5n7R5a3K6FCIJSSiz/jnfEtt63b1pCgOdw2uCsCSV0zk22XzkrXo6shRTRQZnqrdfY3oe6zVg2u57zXy3dr1Z5WVB5sdyzSywBqSQSavDJGkCMQduz3CPmDPnKMjddV1u8FzOScTRmSzKWspVxc4INN5QS4go1bkcvs5mfBXxfXfyZbSQxVGM69CMSykO/o7k6ZlcksZatVn81GN2Ub7x0OGes9lMQcnvLU+LcaY6PNr9pliM1osoSR0CvfqLOfwAE3XlCxAs3P47wxs5xJ/KWRqhrulLmLHiExWZA8xWwQg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kitgw0dm; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kitgw0dm;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hw2700KcLz2y24
	for <linux-erofs@lists.ozlabs.org>; Thu, 01 Oct 2026 03:27:39 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 828B260233;
	Wed, 30 Sep 2026 17:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1058A1F000FF;
	Wed, 30 Sep 2026 17:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790789256;
	bh=GyghZvqdAdJddV47CNsr4GWT+47Z5Sjzvmlp4S+84dU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Kitgw0dmwDA7N2xe7x+U50g9U6PRpKbzSNL+e14juoONe2XLVbng37H1uto7f3/5a
	 CU9eICQrhQHumGRk1wlISEcw8JXvEKg4OzrmIViQsjhmBv4ofIKqRkl24GqXs8a3Zq
	 PMnbNi0fZ/7xcptp3ofuwoy/nJwhVMDqIBNzq4SevpdWZKMtzU71qyr2XXAK5BLa9b
	 p/iKsc13VKdzW6Os00pVXiw0Tw9hxrOyX1UChJ8kYhlD/HFkY0Pw39VOqHbr4118tD
	 jLJQ4jkQ4PByKmin0459J6PuaYSrjDa6l4rnVbIJUyBbshsFe5TMP80j52l2wRAlow
	 bbxmX3TsitRhA==
Date: Wed, 30 Sep 2026 19:27:28 +0200
From: Gao Xiang <xiang@kernel.org>
To: Binglei Wang <l3b2w1@gmail.com>
Cc: xiang@kernel.org, chao@kernel.org, linux-kernel@vger.kernel.org,
	zbestahu@gmail.com, jefflexu@linux.alibaba.com, dhavale@google.com,
	hongbohbli@tencent.com, guochunhai@vivo.com, liubo03@inspur.com,
	linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH] erofs: fix folio reuse from a different address_space in
 erofs_bread()
Message-ID: <ar1GgGSIZ1h0bBip@MacBookPro>
Mail-Followup-To: Binglei Wang <l3b2w1@gmail.com>, xiang@kernel.org,
	chao@kernel.org, linux-kernel@vger.kernel.org, zbestahu@gmail.com,
	jefflexu@linux.alibaba.com, dhavale@google.com,
	hongbohbli@tencent.com, guochunhai@vivo.com, liubo03@inspur.com,
	linux-erofs@lists.ozlabs.org
References: <20260930112127.27059-1-l3b2w1@gmail.com>
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
In-Reply-To: <20260930112127.27059-1-l3b2w1@gmail.com>

On Wed, Sep 30, 2026 at 07:21:27PM +0800, Binglei Wang wrote:
> From: Binglei Wang <l3b2w1@gmail.com>
> 
> erofs_bread() reuses a cached folio on page index match without checking folio->mapping.

Each line in the commit message should not exceed 72 chars.

> 
> xattr.c calls erofs_init_metabuf() twice on the same buffer without erofs_put_metabuf();
> the two in_metabox sources differ, so buf->mapping can switch
> while buf->page still belongs to the old address_space.
> The next erofs_bread() then reads the wrong mapping, dropping shared xattrs with METABOX.
> 
> We require folio->mapping == buf->mapping in the reuse check;
> otherwise drop the cached folio and re-read via the slow path.
> 
> Fixes: 414091322c63 ("erofs: implement metadata compression")
> Cc: Bo Liu (OpenAnolis) <liubo03@inspur.com>
> Signed-off-by: Binglei Wang <l3b2w1@gmail.com>
> ---
>  fs/erofs/data.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
> index be63b89f0862..d8b6523bc218 100644
> --- a/fs/erofs/data.c
> +++ b/fs/erofs/data.c
> @@ -33,8 +33,13 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset, bool need_kmap)
>  	if (buf->page) {
>  		folio = page_folio(buf->page);
> -		if (folio_file_page(folio, index) != buf->page)
> +		if (folio->mapping != buf->mapping) {
> +			/* the cached folio belongs to another address_space */
> +			erofs_put_metabuf(buf);
> +			folio = NULL;

As I said, you could just drop `erofs_put_metabuf(buf);` here,
and folio = NULL will do the correct thing instead.

Thanks,
Gao Xiang

> +		} else if (folio_file_page(folio, index) != buf->page) {
>  			erofs_unmap_metabuf(buf);
> +		}
>  	}
>  	if (!folio || !folio_contains(folio, index)) {
>  		erofs_put_metabuf(buf);
> --
> 2.43.0
> 
> 

