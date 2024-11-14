Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55573D65C44
	for <linux-erofs@archiver.kernel.org>; Thu, 14 Nov 2024 06:04:57 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4XpqPM3zLlz300g
	for <linux-erofs@archiver.kernel.org>; Thu, 14 Nov 2024 17:04:55 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a03:a000:7:0:5054:ff:fe1c:15ff"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1731564293;
	cv=none; b=GRAll5m/WisyKAaNssMdr1D4XPquhLu6RYVLaHDSmP9rmiqRdKrnEB4UXI4hGLA4fLOBkv7myNwWIyo6y44R5ed0fgQm+FRYxFCPZZbisnPFBw8ocdEwumnkav8VbiDDEZT2RwcLuhvzndKMhxxwS1mUIMvtgBLX4hmR5yq9gaxrK3AIVQOucnC8+5kUQhz4J0icsQEnoBfexR1Cip0/XHxkw1UGYDAjWfGcN6YJ1fKuRs7chgYqntrk5YugtSa/nN3OXmuYFgQ21RezabjPQgeZV3Igw+eNCEmIVhAsRlby3TdPad905G5TgN+7LLTAhELdc0m+uUGD6kVVKDXyCg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1731564293; c=relaxed/relaxed;
	bh=eHTVv/e5b+Y8y37tco4KYG3ZPdpH3pQloJuWS7nPlEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HeBtoTI69T9KPtxgomZsRIzkJjI6fSc20n1BErveRpOeOiIl+dV0etWwqZFtvXiqyTaoVhAh9mRq5ZBwEFony09wRrls6vqhsGePxJC68bnuMEJNp76KEAUnGE0jX8oiCFQRtEXYcjLwO+OBiCJHWzp+e+7tUf0RXF9ezOpdYy28cAKMJbdnTh472JfsfMeW0+nX7gb8xbFR1A7IypF/oBmZ7HkyW6Lg9A/zJJ+YdaWkass8j5n1kIE8IoVYyUMssw2Lkss+vk+0dylHDTw3NVz+B2ts/SCdTRUlrrQy2oYRYGwbibWiBd44YWWNvQjlhglRphJIOr6TSSSwNwMkJQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; dkim=pass (2048-bit key; unprotected) header.d=linux.org.uk header.i=@linux.org.uk header.a=rsa-sha256 header.s=zeniv-20220401 header.b=sLX3Sve5; dkim-atps=neutral; spf=none (client-ip=2a03:a000:7:0:5054:ff:fe1c:15ff; helo=zeniv.linux.org.uk; envelope-from=viro@ftp.linux.org.uk; receiver=lists.ozlabs.org) smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=linux.org.uk header.i=@linux.org.uk header.a=rsa-sha256 header.s=zeniv-20220401 header.b=sLX3Sve5;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=ftp.linux.org.uk (client-ip=2a03:a000:7:0:5054:ff:fe1c:15ff; helo=zeniv.linux.org.uk; envelope-from=viro@ftp.linux.org.uk; receiver=lists.ozlabs.org)
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4XpqPC3MKDz2yR9
	for <linux-erofs@lists.ozlabs.org>; Thu, 14 Nov 2024 17:04:45 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eHTVv/e5b+Y8y37tco4KYG3ZPdpH3pQloJuWS7nPlEE=; b=sLX3Sve5uDc41pHYKLkbvF8axC
	TwKcEN2d9TpWNUq0SmuAWqMB68vRmrqHUWze4UE8GJo1bATwvkf1V1Xfzba+sqI7wf2zb2oLgMzy2
	+PfZEFKOZnqq/da5NEps6txtQ528D2NVfU75F0OWacUv/hVEC4yrhGjFuPaXBbHf0GSPl1e1kSJeg
	jsnIXhUEf/Bjp4kmCvKQjrBlzJLsnmrr/RKrptJwfHtVd2eeU0T06906Qtv95M+mY9U6jAKCrcuOX
	TPruVA69YqogfPGVqeRDMHVUnPuLmZR8UGa2Fdc/y9BggxZztUxDun481DxpKYQlPaBREKSzmoO9/
	JEtoyzcg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tBSy2-0000000EnkW-0k35;
	Thu, 14 Nov 2024 06:04:34 +0000
Date: Thu, 14 Nov 2024 06:04:34 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: Re: [PATCH] erofs: fix file-backed mounts over FUSE
Message-ID: <20241114060434.GL3387508@ZenIV>
References: <20241114051957.419551-1-hsiangkao@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241114051957.419551-1-hsiangkao@linux.alibaba.com>
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>, syzbot+0b1279812c46e48bb0c1@syzkaller.appspotmail.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Thu, Nov 14, 2024 at 01:19:57PM +0800, Gao Xiang wrote:

> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
> index 6355866220ff..43c89194d348 100644
> --- a/fs/erofs/data.c
> +++ b/fs/erofs/data.c
> @@ -38,7 +38,10 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset,
>  	}
>  	if (!folio || !folio_contains(folio, index)) {
>  		erofs_put_metabuf(buf);
> -		folio = read_mapping_folio(buf->mapping, index, NULL);
> +		folio = buf->use_fp ?
> +			read_mapping_folio(file_inode(buf->filp)->i_mapping,
> +				index, buf->filp) :
> +			read_mapping_folio(buf->mapping, index, NULL);

UGH...

1) 'filp' is an atrocious identifier.  Please, don't perpetuate
the piss-poor taste of AST - if you want to say 'file', say so.

2) there's ->f_mapping; no need to go through the file_inode().

3) AFAICS, (buf->kmap_type == EROFS_KMAP) == (buf->base != NULL).  What's
the point of having that as a separate field?

4) Why bother with union?  Just have buf->file serve as your buf->use_fp
and be done with that...
