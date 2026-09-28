Return-Path: <linux-erofs+bounces-4625-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E1EBC9832F
	for <linux-erofs@archiver.kernel.org>; Mon, 28 Sep 2026 08:27:39 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4htZDn5g23z2y2K;
	Mon, 28 Sep 2026 18:27:37 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:3b::2a"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790584057;
	cv=none; b=GNQqrI22O07JMtS8z8WoPzC5CFnzAW5T09jspQAARp+tfj5cr6vE524KApl7WcfZhbpWeEUcqTcY8rdjuSmIIguepvq70EuhAFNY98FPm4kRk4+iLrNZq5CRCkahbwahL95ebvtBp8dhQOEfcLSI79J1LBATQVLlW+uKKEEpNooasbyYnJNMuVderwj4Q9SP9KfNmpOSznN9CkPZ3mz+46xGauIZfGB7+DN72IlxuMLNg92r9egZfXSF71uQUdeeHwAYsSjA7K4cSlQaXCJ87LzELtkv8APdL+lMN/btYdnweneINyYVnaY35jBHNBoE/gHLlOm+nqLN6hnKGaEttA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790584057; c=relaxed/relaxed;
	bh=XfTNwTEf8cXEoiVJjaR2wzaM0AVgLL//fGyHvTOkwQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C2auTEgNOFLmnKIjsN2A2iIPvOdLK5TqspkEPZsZG5deVXsCoKAHtMA1FBLr5jlgd3vZDXHMudkuT7WAi3qc0mrErkGo+xv2M/uXS7oph9frZgh0JpjIgfwpCia/MQCu2YH0peSo6bfGZR0VdMdv4Cc46ALndo3zR+HN1XNUq0wVimgTUQ3KNgPR940PftuD7WlyXAUJ/5ioLcn7KmeOCtYUq9GxdBYAl6ovOh7dg2IcM121LmPd644NGLahyBQ9EGdkwwSCh8vmvjdVwPHrm0tcSdmEKs7o+O6zmVqcw7MwBfNdw/y7rDpcCj3lJOMyzbQL4zEgglccN5hyglpFYg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=IojP8VdT; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:3b::2a; helo=mail-pz2-x2a.google.com; envelope-from=senozhatsky@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=IojP8VdT;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2607:f8b0:4864:3b::2a; helo=mail-pz2-x2a.google.com; envelope-from=senozhatsky@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-pz2-x2a.google.com (mail-pz2-x2a.google.com [IPv6:2607:f8b0:4864:3b::2a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4htZDm1lthz2xST
	for <linux-erofs@lists.ozlabs.org>; Mon, 28 Sep 2026 18:27:34 +1000 (AEST)
Received: by mail-pz2-x2a.google.com with SMTP id d2e1a72fcca58-88206fc44c6so1146536b3a.2
        for <linux-erofs@lists.ozlabs.org>; Mon, 28 Sep 2026 01:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1790584053; x=1791188853; darn=lists.ozlabs.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XfTNwTEf8cXEoiVJjaR2wzaM0AVgLL//fGyHvTOkwQs=;
        b=IojP8VdTLfXx3xpPJDcA5cyuZ1oNF80iZSRG1OCdhDLiJhLIdClAXNOWyq919CRRbI
         2T/JGwh5hcrx/2fLh9fWSq6WQ+yOpNhvfs0p2chijGQgPEOZk5kisulDWZUjWRI/nA7b
         j4K20jyyeMF03NMZXPD7Dln8wnevNRwxj57bE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790584053; x=1791188853;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XfTNwTEf8cXEoiVJjaR2wzaM0AVgLL//fGyHvTOkwQs=;
        b=QfW/AiPu4AbI82HHrj4URdVOlC0KjgA70v0OwJBfVos+B4pHtRUVMjBbTPkTlPGhQV
         WCqkLGfdZB5qibM9eojQJW0fH2TVZHKykovmBkvYzxmA9OWsB/dB7vWGyHXZsNal/Qph
         UYkZ8ZwIAIsJ1SG9dUfoEbuVmfBpXEij687ZQul3hMzuxFJx6Gnqg3f3K9X5nL94y1xE
         PT1CteWcahE3P85msnrJDOMs3mfOOpoCmlz2YpYpTRU+X4d1mPjiCfrBmRSg13iWGx+j
         YjeWN4U4Uo8MRoy4YrvKFejy9lxQK9qPJHkhICgVsJik9Ifwx9ytnBIKQqMzZxkKTz12
         bBsA==
X-Forwarded-Encrypted: i=1; AKwUvBwSrBHhIgd06PavaFtdXXNq9rD9rscYDY3j8LV1lmMv5bbEEZhyTGVD7rc4dTKfpsqr4JTTKj3InNBHIA==@lists.ozlabs.org
X-Gm-Message-State: AFuF++mAvQesFkS/9xaneV/wiebwBJd8AQzuD91CPDyu4L9L/iQeRUB/
	0tKTULyBtFakFYmaVJqmuzEatcBuTTBjRLWBOeucTR86fMfIxYBT9PKN4jPo2tGvzw==
X-Gm-Gg: AYBFou3/QhXBW+tqEtuh8VtDLYiUajiTPsuK1MXAdZaxRCMIoWxfd6lDiyzFMM4TRg6
	mWXWMJAoa4mfPmR21I+FPQlr+SFxjnz/dkeARXuS8f9FW8gYJPMbPh2UCzQlqjqC28qDDCEoMJB
	MUWGZK/AqZ1xaWa1u03bN05xvVUYKMOX5Sciqdtif4rESK9GIJAoSs4DY/FGrUvDVhi7lUVPAhR
	jxryFeI7TyFAsAAR1uweNN0BEpgvgwyxoqKWhpGk4F2nxV/mjSIVw4H8F/HSHDfr0bVPcCqeV/H
	vWkULTCRwNjUDYbPK5IWbSs+InpFm7iNiAl721mWl2vPAsZEYzbzdEA6d00J28b3m6sEVAfxyJB
	io7dyM9kkjo47JSEe58c3Tv1Ao2yO6Ibx8seVNGR3jgdxsbWCdKuIzbY7gcVX5of5D53U17I+Qx
	YCHzd1Y6xo19/DonmwHR6BjJjjILSKrgaFdb91JYTZfqaffAzqED0GOawdrxoDx8kZ6lqKQi9RI
	loFnoRsXYhcfeIGO0u0iWUeY2HOMdsoTbuV9sQ=
X-Received: by 2002:a05:6a00:7619:b0:880:8fe8:a3ea with SMTP id d2e1a72fcca58-8808fe8a798mr3659738b3a.45.1790584053122;
        Mon, 28 Sep 2026 01:27:33 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:fdbe:318b:98fe:bd96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87feae8d827sm3676965b3a.36.2026.09.28.01.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 01:27:32 -0700 (PDT)
Date: Mon, 28 Sep 2026 17:27:23 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Michal Wilczynski <m.wilczynski@samsung.com>
Cc: Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Russell King <linux@armlinux.org.uk>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Minchan Kim <minchan@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-block@vger.kernel.org, 
	Yann Collet <yann.collet.73@gmail.com>, Nick Terrell <terrelln@meta.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Phillip Lougher <phillip@squashfs.org.uk>, 
	Sungguk <sungguk.na@samsung.com>, Jaehoon Chung <jh80.chung@samsung.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, linux-erofs@lists.ozlabs.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org, 
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH RFC 0/9] lib/lz4: stop forking upstream LZ4, vendor it
 instead
Message-ID: <arokqo4gVQVglkBa@google.com>
References: <CGME20260925113450eucas1p2fcf838f00f35e1bce0ca04a694cd0cd2@eucas1p2.samsung.com>
 <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>
 <arnr-Su0uJdK_rOb@google.com>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arnr-Su0uJdK_rOb@google.com>

On (26/09/28 13:25), Sergey Senozhatsky wrote:
> On my x86_64 build .text size change seems to be quite significant:
> 
>  ./scripts/bloat-o-meter lib/lz4/lz4_compress-old.ko lib/lz4/lz4_compress.ko
> add/remove: 0/2 grow/shrink: 5/1 up/down: 8022/-1755 (6267)
> Function                                     old     new   delta
> LZ4_compress_fast_continue                  6028   10486   +4458
> LZ4_compress_destSize                        158    3112   +2954
> LZ4_compress_fast_extState                  4078    4597    +519
> LZ4_saveDict                                  82     153     +71
> __UNIQUE_ID_modinfo_466                       52      72     +20
> __pfx_LZ4_compress_destSize_generic           16       -     -16
> LZ4_loadDict                                 261     204     -57
> LZ4_compress_destSize_generic               1682       -   -1682
> Total: Before=14756, After=21023, chg +42.47%

D'oh you actually point that out in the commit message, sorry for the noise.

