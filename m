Return-Path: <SRS0=dz+x=MP=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E50DFC4338F
	for <linux-erofs@archiver.kernel.org>; Fri, 23 Jul 2021 06:10:59 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 215BE60E95
	for <linux-erofs@archiver.kernel.org>; Fri, 23 Jul 2021 06:10:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 215BE60E95
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GWJpn605jz3048
	for <linux-erofs@archiver.kernel.org>; Fri, 23 Jul 2021 16:10:57 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20161025 header.b=XBvqW5fV;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::62a;
 helo=mail-pl1-x62a.google.com; envelope-from=zbestahu@gmail.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256
 header.s=20161025 header.b=XBvqW5fV; dkim-atps=neutral
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com
 [IPv6:2607:f8b0:4864:20::62a])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GWJpg34X8z300C
 for <linux-erofs@lists.ozlabs.org>; Fri, 23 Jul 2021 16:10:50 +1000 (AEST)
Received: by mail-pl1-x62a.google.com with SMTP id u8so2152559plr.1
 for <linux-erofs@lists.ozlabs.org>; Thu, 22 Jul 2021 23:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=EyYaX5Ge9rJt/cZUUVKP3uFtDE0yo7sM5TMHSNj5DLM=;
 b=XBvqW5fVlVulm+7zJKwrstkXbAilUwwxhcdj/WFROej5JZ3jlk8F0bV2mjf5IgBoCe
 9cwr97bqvGriHTUc8+MignuPWsg9Pi8FxblV2st5WRL+xW7rwXTaounq5enK7KalsCqz
 0w1HJU1+l9tXhWzf06DFHMyBU56ph1r9e9yEB5vzDY8yxGHNJR5o/uuEz6UDTBSGILls
 J3BZB86qy7dm1v8WZd7ogxbypyPbGzbOtRmpqy913ZtLqYuN7Rw2/aOux/0oejVLZPXx
 s7Pp8AL0m0Mp86P+jS0K44IYglXs3GzEQHiV5fXRIjfk2PxaHvjnSZvgQUhLdhY9Ww70
 4ifA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=EyYaX5Ge9rJt/cZUUVKP3uFtDE0yo7sM5TMHSNj5DLM=;
 b=Wda6+ard3e0Y7t2zy1H0kJWZdFZwPBMIqtiw5QuhzDzbJbncrJMqn+4vMeeboe+9+d
 jwzXId5ZW6M6PYflz0/Vv7N8kE5eTNEUo08q3h0IrgCNB+6VyIbjkHoupwXUhYegEueH
 u6qZn3/mGDfIyi6uCJ9KGNdlwmHcoyZhItH/n/4W08f0HK8l4CcSnr2QpWixo+hllxDC
 /izBFYp3+WOYNQwstbUz9ULC0zfy1llAHhAvsAsStF7dXzb6qeQyOzxqddVICE7o6PeL
 MKUEvwacQjKUCHPghdIlSJlGOjufvXfSmYA18u8O6LZ4BQqHPWcpEEUq5i1rZswo85gF
 0sqw==
X-Gm-Message-State: AOAM532IunS7anRjirWOmPSzmy8rie29D/WNORFI3q/+M4fbTJpPv8eA
 vsN8PEUyJFTctsyrK68hxbU=
X-Google-Smtp-Source: ABdhPJwM2atvXKvykScstHqhOBN+12ce5W4fWnMDxHq4nCIpVboSnFg54h5h31x5Vv75ykDaQ0lIKg==
X-Received: by 2002:a63:565f:: with SMTP id g31mr3540511pgm.164.1627020647144; 
 Thu, 22 Jul 2021 23:10:47 -0700 (PDT)
Received: from localhost ([103.220.76.197])
 by smtp.gmail.com with ESMTPSA id p33sm32441452pfw.40.2021.07.22.23.10.45
 (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
 Thu, 22 Jul 2021 23:10:46 -0700 (PDT)
Date: Fri, 23 Jul 2021 14:10:49 +0800
From: Yue Hu <zbestahu@gmail.com>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: Re: [PATCH] erofs-utils: no compression case for tail-end block in
 vle_write_indexes()
Message-ID: <20210723141049.00004bff.zbestahu@gmail.com>
In-Reply-To: <YPpNVoTg8xqRZOan@B-P7TQMD6M-0146.local>
References: <20210723034945.1337-1-zbestahu@gmail.com>
 <YPpNVoTg8xqRZOan@B-P7TQMD6M-0146.local>
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
Cc: yuchao0@huawei.com, zbestahu@163.com, huyue2@yulong.com, xiang@kernel.org,
 linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Fri, 23 Jul 2021 13:02:14 +0800
Gao Xiang <hsiangkao@linux.alibaba.com> wrote:

> Hi Yue,
> 
> On Fri, Jul 23, 2021 at 11:49:45AM +0800, Yue Hu wrote:
> > From: Yue Hu <huyue2@yulong.com>
> > 
> > Note that count value will be always greater than EROFS_BLKSIZ when
> > calling erofs_compress_destsize() in vle_compress_one(). So, the d1
> > always >= 1 for compressed block in vle_write_indexes(). That is to
> > say tail-end block can't be compressed.
> > 
> > Signed-off-by: Yue Hu <huyue2@yulong.com>  
> 
> I once thought tail end block can be compressed with < EROFS_BLKSIZ as
> well (as long as it has some benefit) and also tail-packing inline
> like uncompressed cases together after compress extents, so that when we
> reading the last compress extent meta block, the tail-packing compressed
> data can be loaded together.

Understood.

> 
> Currently, I think we could do that, but could you add some DBG_BUGON
> like DBG_BUGON(!raw) right above
> "type = Z_EROFS_VLE_CLUSTER_TYPE_PLAIN;" and a TODO comment to mention
> tail-packing inline compressed cases is under TODO list? That would be

Will do it in v2.

Thanks.

> much better.
> 
> Thanks,
> Gao Xiang
> 
> > ---
> >  lib/compress.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/lib/compress.c b/lib/compress.c
> > index af0c720..93fc543 100644
> > --- a/lib/compress.c
> > +++ b/lib/compress.c
> > @@ -73,10 +73,9 @@ static void vle_write_indexes(struct z_erofs_vle_compress_ctx *ctx,
> >  
> >  	di.di_clusterofs = cpu_to_le16(ctx->clusterofs);
> >  
> > -	/* whether the tail-end (un)compressed block or not */
> > +	/* whether the tail-end uncompressed block or not */
> >  	if (!d1) {
> > -		type = raw ? Z_EROFS_VLE_CLUSTER_TYPE_PLAIN :
> > -			Z_EROFS_VLE_CLUSTER_TYPE_HEAD;
> > +		type = Z_EROFS_VLE_CLUSTER_TYPE_PLAIN;
> >  		advise = cpu_to_le16(type << Z_EROFS_VLE_DI_CLUSTER_TYPE_BIT);
> >  
> >  		di.di_advise = advise;
> > -- 
> > 1.9.1  

