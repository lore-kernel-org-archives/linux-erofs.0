Return-Path: <linux-erofs+bounces-4354-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39462C5DF9D
	for <linux-erofs@archiver.kernel.org>; Thu, 27 Aug 2026 07:59:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hVv6t2vsTz2xwN;
	Thu, 27 Aug 2026 17:59:18 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787817558;
	cv=none; b=HA1ehsHPekZGPhyGd2pTLIPoE6KU/QURo3mak6bt6L74+Miu3tefZHMmfxpr/cHOD0aI35gwCGGtfZ+JR6LZe27nhD8KhHMcPIrY7xnTuaJpFFLwyzFntSzl7FftGdB4bZpp3ORwt/MhTLOsfonsOzSX9EgS25F87COL1hHlVkMjORzdtT3FvkM/rllzMaVZI5eCxchlX20ijMlaUmq9FfhQGizUVYh87/pz9IqL/nYfQkjosIV1r/UPQtk5M4mb39onRf4pm2F2EqNXU/soodI/5yhvHovywCfV1M1Z1DvpmOY79WEWRWM18ox/kieMInDK617ZwL3lqZiCETq5JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787817558; c=relaxed/relaxed;
	bh=Sx5ZUMfFItKhxSQ6qWwToiNGAV5mIXhHJKx8DmZ/gIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VEj89ZmpCIyxehX7my/puEyLXOwANnVfhcLO88dJEIffn6FHeNHrv7KGRGMBr1Ifjl4SCmJWw4lHC6tC+HiV567l5px4Gz3wH4xO6VQ9PQnGP0qJA8lT3Y2iqErI3lORq0wS5wBOg0GE08psumY+oQpu8QL3BN5ZsaFEC+4mVOAIGwSDPCix21sVfRYtFwz2GHKQbULYSYfocp+wM+aNlNIWFzwY1Emr34pUhCQLdf6SMHsnXIHhSW8AkezVzuEwAvHhyQq9Yi3janJY3093KtCE0RZye74/6TpSQKk5KlAfRy4LSVJ/JpIbI8co/++zLEeZ2AQwk6pj2KKKKnQK6g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V2Zf6lRQ; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V2Zf6lRQ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hVv6r3pL9z2xdb
	for <linux-erofs@lists.ozlabs.org>; Thu, 27 Aug 2026 17:59:16 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 770094041A;
	Thu, 27 Aug 2026 07:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F011F000E9;
	Thu, 27 Aug 2026 07:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787817553;
	bh=Sx5ZUMfFItKhxSQ6qWwToiNGAV5mIXhHJKx8DmZ/gIU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V2Zf6lRQSurCfJAgQpI/+mYiB2DFIxrNsOU0sVqKuuRlbU97JxotNWx1YKqHfEt2l
	 g27lEMlvw7OOV9F1xykTmlaWiLyrqlxhUjkmn+q9empo4YSyTYK10ZTvVv22e+UvBI
	 /sC7zQ3j4rk2khiujsWlrISyq31yb93gw5/lqxuyQVOv5PNQqtDk0b/Se43G+0dh0U
	 KeE1p8WmFAAIQw4n0Oe0Qx/qsCe78UCNKWfskm/Xb9WUY8egncQXSIaGz8P604/ZsC
	 Eh+gH+ug2ftPpDnkC8h95oEavbY0gFxT6pkOLtROSnzvzFA8Z2kbNvQGYyN9i2xjwN
	 zlWRE9WScvq+A==
Date: Thu, 27 Aug 2026 15:59:08 +0800
From: Gao Xiang <xiang@kernel.org>
To: Yifan Zhao <stopire@gmail.com>
Cc: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH 2/4] erofs-utils: lib: use `struct erofs_device_info` for
 the primary device
Message-ID: <ao_uTDm54Pb16rIP@192.168.5.19>
Mail-Followup-To: Yifan Zhao <stopire@gmail.com>,
	Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
References: <20260826134321.11835-1-xiang@kernel.org>
 <20260826134321.11835-2-xiang@kernel.org>
 <77994974-775a-4b5c-a872-4973ed40364e@gmail.com>
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
In-Reply-To: <77994974-775a-4b5c-a872-4973ed40364e@gmail.com>

Hi Yifan,

On Thu, Aug 27, 2026 at 09:30:38AM +0800, Yifan Zhao wrote:
> 
> On 26/8/26 21:43, Gao Xiang wrote:
> > Source kernel commit: 7b00af2c5414dc01e0718deef7ead81102867636
> > 
> > Signed-off-by: Gao Xiang <xiang@kernel.org>
> > ---

...

> > diff --git a/lib/vmdk.c b/lib/vmdk.c
> > index 316a8ff..28381c8 100644
> > --- a/lib/vmdk.c
> > +++ b/lib/vmdk.c
> > @@ -51,8 +51,8 @@ int erofs_dump_vmdk_desc(FILE *f, struct erofs_sb_info *sbi)
> >   	int ret, i;
> >   	fprintf(f, desc_template_1, cid, parent_cid, subformat);
> > -	sectors = sbi->primarydevice_blocks << (sbi->blkszbits - 9);
> > -	ret = erofs_vmdk_desc_add_extent(f, sectors, (char *)sbi->devname, 0);
> > +	sectors = sbi->dif0.blocks << (sbi->blkszbits - 9);
> > +	ret = erofs_vmdk_desc_add_extent(f, sectors, (char *)sbi->dif0.blocks, 0);
> 
> mistake? should use `src_path` instead of `blocks`

It's already got fixed.

Thanks,
Gao Xiang

> 
> 
> Thanks,
> 
> Yifan Zhao

