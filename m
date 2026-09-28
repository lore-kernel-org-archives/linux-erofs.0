Return-Path: <linux-erofs+bounces-4621-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0B4DC9832F
	for <linux-erofs@archiver.kernel.org>; Mon, 28 Sep 2026 04:17:08 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4htSgk6wJ5z2y32;
	Mon, 28 Sep 2026 14:17:06 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:39::e"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790569026;
	cv=none; b=ZMm2lFXqyhAxC2VwSK66o2iyumI7p7pum2ec7JknBSsIlJOLOeSb3jmV7ICgAPdrpxv1Khg0wkdmpt7Gc2DytwQbtMaBd4xPohccx5btC3+XYg0sxcf0B5uIouZRsMjWjzKOnlf6MYIo1eHo5WEqztpm+uzSwybNXjoA5DgNhm8RRFHuxbWh2RC01mBeceqXBWDx9KiBluSQYdqiAbu/nP6JK98Ub/A5JDREmtsmS5Osc9K66vXsYh0jdDiX0+1SpnyGVk/d97IgingVf/Uy9W/laDPQRTcIc80GEvxQ7ik5SywvuBGepEM+JJ8+pgh3437de6vl5zlwvxYYcmz79A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790569026; c=relaxed/relaxed;
	bh=j3LIx4OT6RdJGRg4qDatJ4q0rZ8i4sT2AGqSbaU6cDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d7hh4rHvZzGBT0k3MtRcVUBXIWJERXybhES3u/CJopUWbHa3BAm48dSoLYrbfxF0Vu0MoMToXIqDKr52OKDSvcuWb905vqyW21kMe5TaQowhHyYX6gnJdoHsWOqNsGI50XAWXN67u/8D2BT6RAm+KL6S+IJNa/cAUj+POONUbg6un6lFW4atkiWII8J+r1nFCku9vXMDgMfvmHcrL74HRUm2gv0kC5CPJXMvG8+vxk/FT/Ho4ZxnlxpOv4Ow2QzNUxjzHpKhgXxNqWOWjHX2TAomTW6N5W/EsjjGg1tvfk15iz8UXhnIrrWU8PYu0z1zBP6//qznH3qru79Bv4kvoQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=UqZyEZtK; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:39::e; helo=mail-pj2-x0e.google.com; envelope-from=senozhatsky@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=UqZyEZtK;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2607:f8b0:4864:39::e; helo=mail-pj2-x0e.google.com; envelope-from=senozhatsky@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-pj2-x0e.google.com (mail-pj2-x0e.google.com [IPv6:2607:f8b0:4864:39::e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4htSgk1v28z2xnn
	for <linux-erofs@lists.ozlabs.org>; Mon, 28 Sep 2026 14:17:06 +1000 (AEST)
Received: by mail-pj2-x0e.google.com with SMTP id d9443c01a7336-2ddaa08c890so10354045ad.0
        for <linux-erofs@lists.ozlabs.org>; Sun, 27 Sep 2026 21:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1790569024; x=1791173824; darn=lists.ozlabs.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=j3LIx4OT6RdJGRg4qDatJ4q0rZ8i4sT2AGqSbaU6cDI=;
        b=UqZyEZtKJ8QO9512HXMWwXOP2GDXMCCB5UKXH2bNd6Enu1NtNXZdzXifPWFcorSUcD
         FS8bxZdMwGqdhhc3m1mYGQt4FwWVzkul6hPIXMWyCm15OkXJBHUPlfoFMOi0ax6aZjO6
         fD5vOt+MzJb6AccCz8rARyibs6twZ3xQelv2E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790569024; x=1791173824;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j3LIx4OT6RdJGRg4qDatJ4q0rZ8i4sT2AGqSbaU6cDI=;
        b=xc4hikv8Inld7Os2tRPzAEg1ng6Ae+Xi4/CHUTyJgZZxx92N1nQnz8lj0U/Hxi/kgE
         McTtbbzJ+dV37JpdgZhY284/I7KWNBfZyZGPy8PYHV+elj9RoctX3IoYBanw30DF3ZdD
         aLQ4/dbsvE1feVt0E+Y+oENVBg63G2xt0r/gXs5EOo/qLEmOdl1ec0SbYrZ+fKBOC26R
         8HFeoopdbcr0K8X7fYW9GcoULrTbWXQAbE7JX6JVKzWGyz/DH40vLFEW4qLHLt5xGmO3
         u5naqaE3GFk38l0KwslvcfWzoiQcbrHnIAAGs/Z4lawscn3ozpw3FymanJtZA8MDmb9o
         Lyeg==
X-Forwarded-Encrypted: i=1; AKwUvByXAjleqJW5cqC1G5tsTYtnBbsTBFcPeZobKvTSfj3WmJveJCzNnbiUK00wSVC3H0v7B0nCRsixgsPNoA==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYIkfFw//cm/Umv9qGfl9AhODUjDT6LmEC/T7UMIutgggOXeq0cM
	4Ex9KM2W0toZ4cYzsdyRNau+2jXXM+eZbYkWnIQo1HDPYcbA0lGWQoxR7r47XdJdhw==
X-Gm-Gg: AYBFou3vB27kIX1aKkZ2YrGC7q9XP4jzZyv1q1q+8/QvQbwsRCYkDZ8UC6R8hJaLnYQ
	R9DSX4hQ6bRcz1piZ8troG3u1y7ReufoarJGAz0Y/nrm3iaSwfJvPVdcq39zB0idkWBxJnU/Nmg
	JouICAUrmpQxdKJEP78t4HJ8xjXlCDP+d2A8oyiEqATGtP/le78xo22zKzbbRa63YMTy7AbLqVX
	HbtipxLuEphUVg2qTI/RbjSlgRtwxrsMDFQRcT3Y7Tzok00rQAgeqPjH5AbE2s2fRTZZIVfSQPH
	QFR2bwdb4DK6E727eALp0dl+MwmB4XC/zhR4z/4miFWBgv6CBrBJ+iK9e4ZTFNJq9VJ9X1mCUq0
	/ggDDDNpK+tgLfUikGmBoL2x9o1HJogAcOKqJxZct7Sy+O1asPNk+eW4SISPmZwXhXPI9LbDqEt
	0XpRYVpG8DueX1W73IYTV27N6KUFqlnIc7fF9Qp+q/G4h0OeVVSZvJXlRR+4mu8l9pZh2z8JH+3
	Es1kj3Ws/kaGKzcEdwrTRB3bCF7lvdOSnN19Qo=
X-Received: by 2002:a17:902:d98d:b0:2dd:c100:7cc3 with SMTP id d9443c01a7336-2df7dd72aa3mr103163935ad.63.1790569024011;
        Sun, 27 Sep 2026 21:17:04 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:fdbe:318b:98fe:bd96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df913e23ecsm35034075ad.18.2026.09.27.21.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 21:17:03 -0700 (PDT)
Date: Mon, 28 Sep 2026 13:16:54 +0900
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
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, 
	linux-block@vger.kernel.org, Yann Collet <yann.collet.73@gmail.com>, 
	Nick Terrell <terrelln@meta.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Sungguk <sungguk.na@samsung.com>, 
	Jaehoon Chung <jh80.chung@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH RFC 7/9] lib/lz4: switch the decompressor to the vendored
 sources
Message-ID: <arnpj53cgDErAQEz@google.com>
References: <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>
 <CGME20260925113504eucas1p25e50de59c02681fc1385220be8acd184@eucas1p2.samsung.com>
 <20260925-lz4-vendor-upstream-v1-7-1c7ffbe21c4b@samsung.com>
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
In-Reply-To: <20260925-lz4-vendor-upstream-v1-7-1c7ffbe21c4b@samsung.com>

On (26/09/25 13:27), Michal Wilczynski wrote:
[..]
> -static FORCE_INLINE int LZ4_decompress_generic(
[..]
> -			/* Necessarily EOF when !partialDecoding.
> -			 * When partialDecoding, it is EOF if we've either
> -			 * filled the output buffer or
> -			 * can't proceed with reading an offset for following match.
> -			 */
> -			if (!partialDecoding || (cpy == oend) || (ip >= (iend - 2)))
> -				break;

Worth noting, these lines are downstream commit eafc0a02391b
(lz4: fix LZ4_decompress_safe_partial read out of bound).

Is this intended or are we "loosing" some of the downstream fixes?

