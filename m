Return-Path: <SRS0=Di2a=MS=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E94D8C4338F
	for <linux-erofs@archiver.kernel.org>; Mon, 26 Jul 2021 12:27:35 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 16D9C60F57
	for <linux-erofs@archiver.kernel.org>; Mon, 26 Jul 2021 12:27:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 16D9C60F57
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GYK1x5Gb2z307L
	for <linux-erofs@archiver.kernel.org>; Mon, 26 Jul 2021 22:27:33 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20161025 header.b=eqP4qyJn;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::133;
 helo=mail-il1-x133.google.com; envelope-from=andreas.gruenbacher@gmail.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256
 header.s=20161025 header.b=eqP4qyJn; dkim-atps=neutral
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com
 [IPv6:2607:f8b0:4864:20::133])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GYK1t13KWz3062
 for <linux-erofs@lists.ozlabs.org>; Mon, 26 Jul 2021 22:27:28 +1000 (AEST)
Received: by mail-il1-x133.google.com with SMTP id r5so8645909ilc.13
 for <linux-erofs@lists.ozlabs.org>; Mon, 26 Jul 2021 05:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Y5AHF2oAD71DeTWUNBFjQquVzfkKr1vrVF/VPD6Sz0E=;
 b=eqP4qyJnBWxjfTvhxOrzirUmRswssbH2cu7lRtxpZOk91zZQMBtVKbvT89iSg9zxOO
 UcVZGeeYnJHwkUV30pe/9tzswg3vN+JjFAe1FYW6XQc01NcQvZNP0WKzo3GM2qnd1vWh
 ErmZpR7UPbEndqQAh9hcVETTS0Zu4pmicsqDFIgqOOr5t8ZPwu6J1LmHhAdObtIWmtx/
 pfdu1E4y3SwROCDhjWaYaRNzqT+R9xOrFMRgEJHvw7/puQf6pOOClOGEPzteEHSbd1sx
 peb89XtpmZUfX0PJiFDawf7iFlinbLYeuQadAtzB/WorVHGTrnvBZ71It9HYdq0gfp1x
 70xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Y5AHF2oAD71DeTWUNBFjQquVzfkKr1vrVF/VPD6Sz0E=;
 b=q7gerk5wHAQzARUiPqga9eesbZto292TETN7g+BqLVJ0gcZoYaWFxLrFTDLh8oGroP
 mxOYfBurGc0bzQuFtFvWZUYJTqWaULaZe8iwt9YPH4F62/jU/6YWjsAJFlgzKqDIvwan
 dR4yBQPwVZAcY5cSn2kl+PfDYG4JB/AF7iHeVvWR8E/fYXofU3cJSdZxKfmcKteunLu7
 1hVII3lqXbCZ57awkmwl201e9Gwkqz+8gRYsiIId3do4uKris0Q+rPr1GmoiyS1VMNfF
 WBlyscj9WqGsqwr6Atx1C/8hylkLmJ8Bui9QmtUzkU6b+qBwKzZuA90ed0AbiGe9oZOm
 lsLg==
X-Gm-Message-State: AOAM5330FQejXJOEF3d+Xy3fihSVFQpaH97UTOlcOsWkCS077SQYJJp4
 BpLV0rkEmPv0bVM5GjX5OcR6GUzGiy8R4MoIxd0=
X-Google-Smtp-Source: ABdhPJzG5jKWBAyqeJ4cbWptYmY1gOuSr1JLfz5y7rWv/LuJNdeLRATTmfeUMI6/n8WwMUjZLKMzjQVx1y+6Y2OmLNo=
X-Received: by 2002:a92:d451:: with SMTP id r17mr13257263ilm.109.1627302443653; 
 Mon, 26 Jul 2021 05:27:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAHpGcMKZP8b3TbRv3D-pcrE_iDU5TKUFHst9emuQmRPntFSArA@mail.gmail.com>
 <CAHpGcMJBhWcwteLDSBU3hgwq1tk_+LqogM1ZM=Fv8U0VtY5hMg@mail.gmail.com>
 <20210723174131.180813-1-hsiangkao@linux.alibaba.com>
 <20210725221639.426565-1-agruenba@redhat.com>
 <YP4zUvnBCAb86Mny@B-P7TQMD6M-0146.local>
 <20210726110611.459173-1-agruenba@redhat.com>
 <20210726121702.GA528@lst.de>
In-Reply-To: <20210726121702.GA528@lst.de>
From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date: Mon, 26 Jul 2021 14:27:12 +0200
Message-ID: <CAHpGcMJhuSApy4eg9jKe2pYq4d7bY-Lg-Bmo9tOANghQ2Hxo-A@mail.gmail.com>
Subject: Re: [PATCH v7] iomap: make inline data support more flexible
To: Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
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
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
 "Darrick J . Wong" <djwong@kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
 linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Am Mo., 26. Juli 2021 um 14:17 Uhr schrieb Christoph Hellwig <hch@lst.de>:
>
> > Subject: iomap: Support tail packing
>
> I can't say I like this "tail packing" language here when we have the
> perfectly fine inline wording.  Same for various comments in the actual
> code.
>
> > +     /* inline and tail-packed data must start page aligned in the file */
> > +     if (WARN_ON_ONCE(offset_in_page(iomap->offset)))
> > +             return -EIO;
> > +     if (WARN_ON_ONCE(size > PAGE_SIZE - offset_in_page(iomap->inline_data)))
> > +             return -EIO;
>
> Why can't we use iomap_inline_data_size_valid here?

We can now. Gao, can you change that?

> That is how can size be different from iomap->length?

Quoting from my previous reply,

"In the iomap_readpage case (iomap_begin with flags == 0),
iomap->length will be the amount of data up to the end of the inode.
In the iomap_file_buffered_write case (iomap_begin with flags ==
IOMAP_WRITE), iomap->length will be the size of iomap->inline_data.
(For extending writes, we need to write beyond the current end of
inode.) So iomap->length isn't all that useful for
iomap_read_inline_data."

> Shouldn't the offset_in_page also go into iomap_inline_data_size_valid,
> which should probably be called iomap_inline_data_valid then?

Hmm, not sure what you mean: iomap_inline_data_size_valid does take
offset_in_page(iomap->inline_data) into account.

> >       if (iomap->type == IOMAP_INLINE) {
> > +             int ret = iomap_read_inline_data(inode, page, iomap);
> > +             return ret ?: PAGE_SIZE;
>
> The ?: expression without the first leg is really confuing.  Especially
> if a good old if is much more readable here.

I'm sure Gao can change this.

>                 int ret = iomap_read_inline_data(inode, page, iomap);
>
>                 if (ret)
>                         return ret;
>                 return PAGE_SIZE;
>
> > +             copied = copy_from_iter(iomap_inline_data(iomap, pos), length, iter);
>
>
> > +             copied = copy_to_iter(iomap_inline_data(iomap, pos), length, iter);
>
> Pleae avoid the overly long lines.

I thought people were okay with 80 character long lines?

Thanks,
Andreas
