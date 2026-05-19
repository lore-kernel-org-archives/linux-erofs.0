Return-Path: <linux-erofs+bounces-3450-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7628CCD4F52
	for <linux-erofs@archiver.kernel.org>; Tue, 19 May 2026 08:15:54 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gKSD90r04z2xwH;
	Tue, 19 May 2026 18:15:53 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::429"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1779178553;
	cv=none; b=gaiUFboETU8/xPYKe9CLTNURIjGC1RYsVDMMXD9mZUUaREf6vI3TLfqqUrKBHwF+hGxHzdYKdxAYfZLjtj862OTFSuP0uF1mAuqPDVgQ4W9kMELHKUsrxR0pOweCz4TGA2MZX1pw9scVsJ0/7MDUeF/b+u6YtlHomKmzR81QIX+iNBWjPEktSNWdYRGVL3cYd2bKWdUks4JZUcY9bW7O8v9MglzWX8ruTurmB99gCkj60PfAdFIlOWim94KRaVg8JYJSteN3lJD2loVG7pZMU7c1QQQPWHC8MHZ+cVcz5NRrL1T2Ix5arjFTuVE71A0hBRMAfEl0X49CUp6mK0YYmw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1779178553; c=relaxed/relaxed;
	bh=Gq7q4q44H1XtbreNnGBa/qXoQQzGGv2LByvvEOVI2FM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FmRSpOJ/DWfG7ZW5HeInrUxcTSvWXvKeGVNi9bLz6LoQ1WXfZSAy8EI+1ECqSsJlkzGdcJxXA4R4TkrWqLo+PKiBYVnAieetrQ5wiYG6hdua2OkAxUn8QrY3kshlbNQ4L0Vm7jOLlAsLrrFI7IzcQH8YwwXPtWZFaMITEru02uHIgvxI/pb+LfrWAKoelH3IE58M2UsHtLiAOwSuk3ys4LIwWDZ9W5ugDfU+UsIaGxj9gb1Ki0ad8i5cN7SHu9CbZ60MF7aRJkmc4oDk3omeDZjlasCVGQNVL03zSM9bZ39ep6L2P/41AHi2RsnpLXXsr3FBMXzVWTSsADimnDRJJA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=nuTSMRsZ; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::429; helo=mail-wr1-x429.google.com; envelope-from=david.laight.linux@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=nuTSMRsZ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::429; helo=mail-wr1-x429.google.com; envelope-from=david.laight.linux@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gKSD80NJVz2xSG
	for <linux-erofs@lists.ozlabs.org>; Tue, 19 May 2026 18:15:51 +1000 (AEST)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-43d734223e4so2006882f8f.0
        for <linux-erofs@lists.ozlabs.org>; Tue, 19 May 2026 01:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779178548; x=1779783348; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gq7q4q44H1XtbreNnGBa/qXoQQzGGv2LByvvEOVI2FM=;
        b=nuTSMRsZc6nCxPwyQzPpgW/F/Z8ZUnqEm0eMZ48F0fZbuXH2+o7+HNAXODiQGm+lxR
         Io/ob14S3TJUY7Eod3WSUCySkRKdGHH9NsAD/HwAlNAmW9dw0ngkI47S43TkaoIO17qV
         e/2UrHxHqnjNKZ8ebmHdSDoyvq0Rp70ExINq16JKszVO+uuNxnz4qLfLVPrkirlGmbBP
         7gQhyLy86xv+bl8M1obc0Z/d5uHqDSuUa9R8/BVWW7K1NqO4ae8ZNE1Doc4fZSJ5Iqc9
         HgoNDjs1RAXYvmFNEhEmrbivwTqWevtFwGE/gfpOm5cYIwNnjdGHkwrVZvwIilYOBskd
         OuHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779178548; x=1779783348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Gq7q4q44H1XtbreNnGBa/qXoQQzGGv2LByvvEOVI2FM=;
        b=C3IDDONG5LdjRPga9CRCBeul9sVfacJg5z9FS7QMQfAY8FGw+Frq3lYZw/kIaSTTwL
         Jn+rJ05XXB5K6rY/1b6BgF+mvEcgufS2PsNHASD9jSB3Yi0sK+5wLiGbYVuZUznw2pou
         8/nQe/nytCNTBdJX/jvpKlocXZ/OImH/yD778GnjNQ5a4DD7Ji/yXd3lmvFG/bGF2HSI
         n1eYjoC2Mlq6If6hgVCXL0F7hwgTE2HZtzS+WU6O8ZYI2hx828Quf7fEidToOBz38NST
         uPgztC22zo9XePpjo2Z3Lh5IQMKsI68HtvV1dNoSUyiOB5z02TcC+0DEmb4YrRAqt1b8
         kq/w==
X-Forwarded-Encrypted: i=1; AFNElJ9WioTm/nBtlhQxMlhuvJXYuwELm5tuKMPqH3H7rQCumiFDNP0YR5bLvWG20dHgNG7OH3ibzJ979m1PPA==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YxSXr0RBHZXJUXsXaQFUirARaVmPYiBd68PDhNb+JRS5Ekh2+5R
	NXS1PC7H6OdUlCa2EJcLk5PnNMAQ7zwdC2z4BN6hvn+PtY2RZIZb7e8G
X-Gm-Gg: Acq92OHaFqtDqAyo8Q3AV0uKUX1U9LwnYVKS5cKP1AiP3aEtQsIIL1DDYiNRHiWYBK7
	/09S/eK9q4YZ6Z4LTxIPSPeMnN1U1dftVXK7eQ/qImakTn91xDlajk8/wk+zjt90at4ovQDAtq2
	QjqrwmQAPTI4UVCIFb0qqqZutS8/LtRR0ua/7rHnI56Mu62dzBuBvBbYJy2jPHuKlZEt71xVtm7
	Z37zWLteMS8ggGBo2BcqdDJBKrXKzu+dXqB/ZO6ofG0kimkFU5/VuGVp/jdxu5g3khOky4eQ4lr
	OPQsXDF0PnIH+auxZa2RL91MGAA6fDHIWx8THA7vGUfvjJU9uozQPYIQ27iBQRGnWIra7aj02iW
	ck8qaUZa1NM3lQ+iHyt5Vky1qe+3vwIgI9V9OzNeiHeq4yCnr3BV2vxV091+RX/1poDomcFeiWK
	qhKjZ7m6aQg8viIS5LIx86kxlhMzaPJzWONOu7Ja+xWhoH6TtPrbuEZva+pIJuPtkJ
X-Received: by 2002:a5d:4577:0:b0:450:b883:dd3c with SMTP id ffacd0b85a97d-45d9352412cmr26263969f8f.20.1779178547828;
        Tue, 19 May 2026 01:15:47 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45e7c22d8b7sm14602897f8f.6.2026.05.19.01.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 01:15:47 -0700 (PDT)
Date: Tue, 19 May 2026 09:15:45 +0100
From: David Laight <david.laight.linux@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>, Matthew Wilcox
 <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>, Paulo
 Alcantara <pc@manguebit.org>, Jens Axboe <axboe@kernel.dk>, Leon Romanovsky
 <leon@kernel.org>, Steve French <sfrench@samba.org>, ChenXiaoSong
 <chenxiaosong@chenxiaosong.com>, Marc Dionne <marc.dionne@auristor.com>,
 Eric Van Hensbergen <ericvh@kernel.org>, Dominique Martinet
 <asmadeus@codewreck.org>, Ilya Dryomov <idryomov@gmail.com>, Trond
 Myklebust <trondmy@kernel.org>, netfs@lists.linux.dev,
 linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
 v9fs@lists.linux.dev, linux-erofs@lists.ozlabs.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/21] netfs: Keep track of folios in a segmented
 bio_vec[] chain
Message-ID: <20260519091545.171c4b85@pumpkin>
In-Reply-To: <20260518222959.488126-1-dhowells@redhat.com>
References: <20260518222959.488126-1-dhowells@redhat.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
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
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 18 May 2026 23:29:32 +0100
David Howells <dhowells@redhat.com> wrote:

> Hi Christian,
> 
> Could you add these patches to the VFS tree for next?
> 
> The patches get rid of folio_queue, rolling_buffer and ITER_FOLIOQ,
> replacing the folio queue construct used to manage buffers in netfslib with
> one based around a segmented chain of bio_vec arrays instead.  There are
> three main aims here:
> 
>  (1) The kernel file I/O subsystem seems to be moving towards consolidating
>      on the use of bio_vec arrays, so embrace this by moving netfslib to
>      keep track of its buffers for buffered I/O in bio_vec[] form.
> 
>  (2) Netfslib already uses a bio_vec[] to handle unbuffered/DIO, so the
>      number of different buffering schemes used can be reduced to just a
>      single one.
> 
>  (3) Always send an entire filesystem RPC request message to a TCP socket
>      with single kernel_sendmsg() call as this is faster, more efficient
>      and doesn't require the use of corking as it puts the entire
>      transmission loop inside of a single tcp_sendmsg().
> 
> For the replacement of folio_queue, a segmented chain of bio_vec arrays
> rather than a single monolithic array is provided:
> 
> 	struct bvecq {
> 		struct bvecq		*next;
> 		struct bvecq		*prev;
> 		unsigned long long	fpos;
> 		refcount_t		ref;
> 		u32			priv;
> 		u16			nr_segs;
> 		u16			max_segs;
> 		enum bvecq_mem		mem_type:2;
> 		bool			inline_bv:1;
> 		bool			discontig:1;

There doesn't seem to be any point using bitfields.
There is a massive hole here anyway.

> 		struct bio_vec		*bv;
> 		struct bio_vec		__bv[];
> 	};
> 
> The fields are:
> 
>  (1) next, prev - Link segments together in a list.  I want this to be
>      NULL-terminated linear rather than circular to make it possible to
>      arbitrarily glue bits on the front.

Do you ever need to follow the list backwards?
If not making prev point to the pointer to the entry (probably a tailq?)
makes the logic simpler (and safer) because you can remove an item without
knowing whether it is the head or which list it is on.

> 
>  (2) fpos, discontig - Note the current file position of the first byte of
>      the segment; all the bio_vecs in ->bv[] must be contiguous in the file
>      space.  The fpos can be used to find the folio by file position rather
>      then from the info in the bio_vec.

Should fpos be off_t (or u64) rather than 'long long' (they are all the
same underlying type).

>      If there's a discontiguity, this should break over into a new bvecq
>      segment with the discontig flag set (though this is redundant if you
>      keep track of the file position).  Note that the beginning and end
>      file positions in a segment need not be aligned to any filesystem
>      block size.

At this point you lose me :-)

-- David

