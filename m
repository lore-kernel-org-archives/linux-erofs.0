Return-Path: <linux-erofs+bounces-4394-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3F0EC624C6
	for <linux-erofs@archiver.kernel.org>; Mon, 31 Aug 2026 23:32:17 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hYldW0y9qz2y2P;
	Tue, 01 Sep 2026 09:32:15 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788219135;
	cv=none; b=ZuTxyKh4gFHhMiUW1Gtf/OJOCWQ86QZBcoACIKdFLgmEwi/tNMmHTYVbbPDDXdrK7OIV8u8xlymPCz9uKWTNDTPkFPkngUaWHPM7hsaY2BPCrcyZfRpZbIf2JI7luL8OWNY2azsMHIBhDgiMEEm2C/4K925fKQnHinhrsscQFJCtXLTMkomm9CaE7uOcHS6yEGrTqMCclQwLI/ZA6ojaGeEIVy6BnLWuuZ+iSwhcIYRCOmc7NJFewoQz3WReF3NVl4KRgRenIqfehVM8yyi5weKpqf8c7J54QjvDGFstyUDRgfLkAkOrcyMvMNGsMGAUR3BUXKDZDN+lyfaLqXslsg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788219135; c=relaxed/relaxed;
	bh=HqSnM2Sf1MnAraFVDX5f+6TBqIzKd36nKm4xtyvhybM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cY1ceNmi0hpIVzdvRFejSV62USU0LFHpcfcPBC/7BQcYSxbhF+1e6P0qkQbIFHYpddMhEKDXFcvPHTSYagPvEp8g9KSclBde/9tpMXAB9TbE4X4xlKqQb52Y/3Ml55u1fyUs9LoQcZc8yzjd8OCam+0SACuNYQA1XHEP3lQrFkoYWUvXGw7pYEerqCQCBvHlu74tOraydRwiCW3sJPpSQI1Vuy3ip1jFOi7YkLcttdgG2wCrMTgoOo39F0OkVmnpIpMGf2o7tpne7NPGTLUkmtQEyDQJWRhjBbwX66WB20V1B/FKVcU06U6us7z41wTsmpPduoRT7Yx5iSDGjIZJQg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hM9ggej7; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=linkinjeon@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hM9ggej7;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=linkinjeon@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hYldT4xJxz2xGr
	for <linux-erofs@lists.ozlabs.org>; Tue, 01 Sep 2026 09:32:13 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B2FE40493
	for <linux-erofs@lists.ozlabs.org>; Mon, 31 Aug 2026 23:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232F21F0155B
	for <linux-erofs@lists.ozlabs.org>; Mon, 31 Aug 2026 23:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788219131;
	bh=HqSnM2Sf1MnAraFVDX5f+6TBqIzKd36nKm4xtyvhybM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hM9ggej7PlPuTMCDzgOh3zYet3jaCTTtvglzC/zYWOZL6KGj0BcKod4DB2KHZmpuk
	 9Xr8E5fI7omKEWAg8npO64Q4oxaIsgjG+ROJho52pGDM0t6/3xak1DlwmCvfeLGEq2
	 QgA1Yt5/MRFPTMRaDIUjwW5YGSiC2DurJZI45p7kp3NGtY4Qjnfuwky7WXn7o9f4Z8
	 wC4Ds6R9vHRh9IGZpDif5s6pgETlC/Wre846fOo21aTGBy8Pvwtz0uK2tMm6Oadwv/
	 53QRlUMvhrjqA91WlLKbIal6dENP3blXPeG/7/rBm3eOLTTcQXLTrHKYGeIJ/eD/kO
	 gZhLRtPK2lJyg==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a60d406a5cso6330678a12.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 31 Aug 2026 16:32:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByHYsYq2TcSxUpNI4bBIhhwBmI7Ab3tEMC842rOxSZOiDN72BVm5nMV7WlcVsPdndkaypGlCvZdEaYQgw==@lists.ozlabs.org
X-Gm-Message-State: AFuF++mVrZxtBU0VIVV/27LCdlW9c29AinvgX2e0DpFfNCEWcZU/jCds
	abpI/+fFyuiNBcYqhR4qoJKjZGGzMC4II3YsN8a0KV/NiBGMEFnIxxUnpbl+Nf2NzOmjmgDbK84
	FCnznEBYy5FF3xAdXHwsMyT7zWmwlhtU=
X-Received: by 2002:a05:6402:1e90:b0:6a6:32f5:90b3 with SMTP id
 4fb4d7f45d1cf-6a663b24942mr2593080a12.21.1788219129658; Mon, 31 Aug 2026
 16:32:09 -0700 (PDT)
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
References: <20260830041901.2668-1-willy@infradead.org> <20260830041901.2668-7-willy@infradead.org>
In-Reply-To: <20260830041901.2668-7-willy@infradead.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 1 Sep 2026 08:31:57 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_zarKuogwNS=ZNDuyR4w_iB7yui+h+CqGvjZvzxPFpzw@mail.gmail.com>
X-Gm-Features: AcwNN1UvF-7AQZoHjsPGrrmMkPeyVFXaEcU2n-gcV41YpQO_AYBnZepzQZ06-b8
Message-ID: <CAKYAXd_zarKuogwNS=ZNDuyR4w_iB7yui+h+CqGvjZvzxPFpzw@mail.gmail.com>
Subject: Re: [PATCH 6/9] ntfs: Remove redundant FGP_NOFS from ntfs_wof_collect_dest()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <christian@brauner.io>, Jan Kara <jack@suse.cz>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Theodore Tso <tytso@mit.edu>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, linux-erofs@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-nfs@vger.kernel.org, ntfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 30, 2026 at 1:19=E2=80=AFPM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> The flags already include FGP_NOWAIT which prohibits all reclaim, not
> just reclaiming from the filesystem.  Use mapping_gfp_mask() instead of
> GFP_NOFS as this will preserve flags like GFP_MOVABLE.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!

