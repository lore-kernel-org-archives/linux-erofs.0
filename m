Return-Path: <linux-erofs+bounces-4638-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A645ECA5FB1
	for <linux-erofs@archiver.kernel.org>; Wed, 30 Sep 2026 07:52:46 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hvnMd0CRGz2y7Y;
	Wed, 30 Sep 2026 17:52:45 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790754764;
	cv=none; b=ZETfuXVeWO2cYtsLKg7WOzVyC3iv1M+PmI6jw3Mb4zvPhIZvWXdv9c1Aej3jy4HlnOWLJeUtPA88eJjBmZ1iE1E6TI461CS4YVaXxfbwXaHOTwRYjZY87PVukvEvaylxC3MGBIXC4qnB6FkX2xVmCDRYBmOj0NfoHnivGhnB/eMHkLmGwaIq0Dd/sKK0Ye/WvrWkQBy1sXJj2ChR0sRewldUHjjuhVl/M/c5DrGB00+wYuzGeNg1KfV76RcNrPcwF1fTG2ssIB4ATdloVBEXO1jH4vA9dy3cdwEotg/+SGNbognfMyeucPAkwlIA6rlDNvIjZK2gxtH+LY7oCJzJxw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790754764; c=relaxed/relaxed;
	bh=HG+Asrw3g/mWMsN1/SOW/UfriJ5U+pNGLQlihCs8RCI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JmX+LkkhdQmYtYSTFFwzFTrwlSue3o/wH+5gGw+i/yPWkoSsMAJ1TWUuIo+PZ+9n/kD11//PLc8OQCSEv4/rmdB+hHFOmsj+M2AKsx+/767gpVTHZbxCy4taImdYJLE8WLjUZQiD9Z9ZB+0eXLUheHA95eiA+Yxk1fL2iw7h4fgelPwUCHsIhlZMpbK414jtA33+DcCRK1V4iVpdt1qvYzd4wpoy9RahpWAeKTRxTVQepn45tOIPDV6TndY1Qh3dDgM3CL8IRQpoPrINni46Rb414KT7X+n7lVgWFZA8tQrg6qDTJEFdhRuSHZARa1xRLGSJ8qTFRNG8qnkgP6jPfw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bRIKRrc9; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bRIKRrc9;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hvnMb4mcXz2xnQ
	for <linux-erofs@lists.ozlabs.org>; Wed, 30 Sep 2026 17:52:43 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4484B6025A;
	Wed, 30 Sep 2026 07:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3F81F000FF;
	Wed, 30 Sep 2026 07:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790754760;
	bh=HG+Asrw3g/mWMsN1/SOW/UfriJ5U+pNGLQlihCs8RCI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bRIKRrc9r7IyEvc70N95JxUAf3/OCQjvHIGE5ymmxMkyFfC/BqladvJwSTZ36yOJO
	 oJlzgtvgll/lEgsAjORo9GbQvs44xf/xOaIke2peIw1qQuQjX9BPgM+VYvwyaJ+rhk
	 h1bGgbQEtmVfAUZDwSRKljHDvD6vT0l8fxzjZ4YW8UzOjtQXTgr8n/JnJ9NXKrKLrR
	 TpVW4wbOkO9pwcIpZONL3ZN12b3cA7wTQ+BRJlmUTtRDQfUakf3QjtCoN2wPbahjcb
	 r5GYJOgabEQlHfNFjAxTiDg1G1a6ZOZHVYsQaarbwWClFtjww6bDt4+l70YA4P0FVp
	 ZueLzRsbFmw3g==
Date: Wed, 30 Sep 2026 09:52:34 +0200
From: Gao Xiang <xiang@kernel.org>
To: binglei wang <l3b2w1@gmail.com>
Cc: xiang@kernel.org, chao@kernel.org, linux-erofs@lists.ozlabs.org,
	zbestahu@gmail.com, jefflexu@linux.alibaba.com, dhavale@google.com,
	hongbohbli@tencent.com, guochunhai@vivo.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] erofs: fix folio reuse from a different address_space in
 erofs_bread()
Message-ID: <ary_wjlpYNWbqaHU@MacBookPro>
Mail-Followup-To: binglei wang <l3b2w1@gmail.com>, xiang@kernel.org,
	chao@kernel.org, linux-erofs@lists.ozlabs.org, zbestahu@gmail.com,
	jefflexu@linux.alibaba.com, dhavale@google.com,
	hongbohbli@tencent.com, guochunhai@vivo.com,
	linux-kernel@vger.kernel.org
References: <CAJ3C4KySUqKevOBn=CROzsWkaLdK_X241oLFXO26FKBVq73QJg@mail.gmail.com>
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
In-Reply-To: <CAJ3C4KySUqKevOBn=CROzsWkaLdK_X241oLFXO26FKBVq73QJg@mail.gmail.com>

On Wed, Sep 30, 2026 at 11:37:53AM +0800, binglei wang wrote:
> erofs_bread() caches the last folio in struct erofs_buf and reuses it when
> the next request lands on the same folio, but the reuse predicate only
> compares the page index; it never checks that the cached folio still
> belongs to buf->mapping.  Correctness therefore relies on an invariant
> that is nowhere enforced.
> 
> fs/erofs/xattr.c already breaks it: erofs_xattr_iter_inline() and
> erofs_xattr_iter_shared() call erofs_init_metabuf() on the same buffer
> with no intervening erofs_put_metabuf(), and their in_metabox arguments
> come from different sources (per-inode vs per-fs).  When the two differ,
> buf->mapping is switched while buf->page still holds a folio of the
> previous address_space, so the next erofs_bread() can return data from
> the wrong one.
> 
> This is observable with METABOX enabled, where shared xattrs silently
> disappear on the mounted fs, while the same tree built without METABOX
> reports them fine.
> 
> Fix it by validating the address_space in the reuse predicate too: if the
> cached folio belongs to another mapping, drop it so that the existing
> slow path re-reads from buf->mapping.  Reading folio->mapping is safe
> here because a reference on the cached folio is still held; if the folio
> was already truncated, folio->mapping is NULL and the slow path is taken,
> which is the safe direction.
> 
> Fixes: 414091322c63 ("erofs: implement metadata compression")
> Cc: Bo Liu (OpenAnolis) <liubo03@inspur.com>
> Signed-off-by: Binglei Wang <l3b2w1@gmail.com>

Thanks for the patch.

 1) The patch format is still broken as your previous patch, please
    check your email client again before sending out a new patch
    (as I said, you could send a patch to yourself and try to apply
     the patch and see if it works);

 2) the commit message of this patch is too over long (mostly
in the LLM-generated style), I think you could simplify a bit since
it's more friendly to human developers.

> ---
>  fs/erofs/data.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
> index be63b89f0862..d8b6523bc218 100644
> --- a/fs/erofs/data.c
> +++ b/fs/erofs/data.c
> @@ -33,8 +33,13 @@ void *erofs_bread(struct erofs_buf *buf,
> erofs_off_t offset, bool need_kmap)
> 
>   if (buf->page) {
>   folio = page_folio(buf->page);
> - if (folio_file_page(folio, index) != buf->page)
> + if (folio->mapping != buf->mapping) {
> + /* the cached folio belongs to another address_space */
> + erofs_put_metabuf(buf);
> + folio = NULL;

     `folio = NULL` is enough?

Thanks,
Gao Xiang

> + } else if (folio_file_page(folio, index) != buf->page) {
>   erofs_unmap_metabuf(buf);
> + }
>   }
>   if (!folio || !folio_contains(folio, index)) {
>   erofs_put_metabuf(buf);

