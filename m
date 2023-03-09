Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76B43C61DA4
	for <linux-erofs@archiver.kernel.org>; Thu,  9 Mar 2023 07:31:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4PXLTS4F9rz3cf4
	for <linux-erofs@archiver.kernel.org>; Thu,  9 Mar 2023 18:31:24 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20210112 header.b=bcP5IcOK;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::629; helo=mail-pl1-x629.google.com; envelope-from=zbestahu@gmail.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20210112 header.b=bcP5IcOK;
	dkim-atps=neutral
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4PXLSr33bCz3ccr
	for <linux-erofs@lists.ozlabs.org>; Thu,  9 Mar 2023 18:30:51 +1100 (AEDT)
Received: by mail-pl1-x629.google.com with SMTP id h8so1072127plf.10
        for <linux-erofs@lists.ozlabs.org>; Wed, 08 Mar 2023 23:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678347048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f1bDXhfS+Zf3czIKMHqpIQcR1bLl3EJ1K2VTEtlTGwI=;
        b=bcP5IcOKm+tJOzafpX8ImYC1LGFfWUAqO5mJ/P7OSlWq/O3ZBq9tz/9BD9C53ypQGw
         tzpbALLWOGFM2Nv3H9FCFS4g62Q1meaHncmhBvcBgSrAmH4yhsEVe1zFUzSb5CzJuQhw
         FQliadhvVwXuRFrFT9N553574uW2V00VXLRoN/kHSTgfbWaOWmrV7ge36yzUG18sh0Qg
         zn0XZ+6us3Z9cjFPjKmdx7b3eOAVQllz7nwHfRG3jF0U7YIaT/aMObMLH4aJHG44XjNH
         iB/uy/9wCDeG62XB96qNUL8EMWOVpNbH3CdpbZl2824L7xcEDeSMRzmYQae+bmz4/1Nw
         URqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678347048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f1bDXhfS+Zf3czIKMHqpIQcR1bLl3EJ1K2VTEtlTGwI=;
        b=5mDLjYHF5NgL0LzwMPRtgb2uSQxe8hgw3iit0JyrW6MrFGW1iyA6/3CVWlMa+H1d6z
         gQa4UqmnyEwZYLSexjY4oh+qJbEU6eRf2fzXDToi3cHWxhNyl6c4n7YgXu5NFgAaoqRO
         Q4buDbXyfTHNZpo/gM5EwcxvEM2EmwMxuQuFBXvTweSzVn9R74kqKZeZIApFGVilM5g1
         FPrFHWeXTyCxIgz8ZC0eYcpsWaQ09nHAmgQkF7sOYxNxBSkQNuUxEVTZ1fmkYKaChyau
         +gc9f8KuoR7jliYHd3R5jF9fG/qDhyLAEoL9tVJFMMxAWFAFQ+xXlczYgg3WTBs8Qv0z
         IibQ==
X-Gm-Message-State: AO0yUKVyQlAc1NWW424Y5x3yyt/pmd4ZUyH9qqizSJmpSJwVorhF8Bq1
	o3CACBcLw6PByU/3MuuxkQg=
X-Google-Smtp-Source: AK7set/5X9Br2s/E6UyT7fzWcZUDC2+vFH93YUrD2Xn8Oyv0c0u5FU1SsWUTwCXRD4waj21OGszXOQ==
X-Received: by 2002:a17:90b:4d04:b0:237:47b0:3ea8 with SMTP id mw4-20020a17090b4d0400b0023747b03ea8mr23685827pjb.41.1678347048464;
        Wed, 08 Mar 2023 23:30:48 -0800 (PST)
Received: from localhost ([156.236.96.165])
        by smtp.gmail.com with ESMTPSA id n8-20020a17090ac68800b00233ebcb52a6sm928461pjt.36.2023.03.08.23.30.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Mar 2023 23:30:47 -0800 (PST)
Date: Thu, 9 Mar 2023 15:37:09 +0800
From: Yue Hu <zbestahu@gmail.com>
To: Yangtao Li <frank.li@vivo.com>
Subject: Re: erofs: use wrapper i_blocksize() in erofs_file_read_iter()
Message-ID: <20230309153709.00003876.zbestahu@gmail.com>
In-Reply-To: <20230309071515.25675-1-frank.li@vivo.com>
References: <20230306075527.1338-1-zbestahu@gmail.com>
	<20230309071515.25675-1-frank.li@vivo.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
Cc: linux-kernel@vger.kernel.org, zhangwen@coolpad.com, huyue2@coolpad.com, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Thu,  9 Mar 2023 15:15:15 +0800
Yangtao Li <frank.li@vivo.com> wrote:

> > @@ -380,7 +380,7 @@ static ssize_t erofs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
> > 		if (bdev)
> > 			blksize_mask = bdev_logical_block_size(bdev) - 1;
> > 		else
> > -			blksize_mask = (1 << inode->i_blkbits) - 1;
> > +			blksize_mask = i_blocksize(inode) - 1;  
> 
> Since the mask is to be obtained here, is it more appropriate to use GENMASK(inode->i_blkbits - 1, 0)?

It should be another change independently to this patch. rt?

> 
> Thx,
> Yangtao

