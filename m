Return-Path: <SRS0=AJ+u=HM=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CBE9C433E0
	for <linux-erofs@archiver.kernel.org>; Wed, 10 Feb 2021 14:57:05 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3C48364E74
	for <linux-erofs@archiver.kernel.org>; Wed, 10 Feb 2021 14:57:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C48364E74
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4DbNC21bVVzDvbt
	for <linux-erofs@archiver.kernel.org>; Thu, 11 Feb 2021 01:57:02 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=redhat.com (client-ip=63.128.21.124;
 helo=us-smtp-delivery-124.mimecast.com; envelope-from=hsiangkao@redhat.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256
 header.s=mimecast20190719 header.b=AUCyyHzI; 
 dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com
 header.a=rsa-sha256 header.s=mimecast20190719 header.b=LjB6okmx; 
 dkim-atps=neutral
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4DbKkh1tnbzDvbm
 for <linux-erofs@lists.ozlabs.org>; Thu, 11 Feb 2021 00:05:46 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1612962341;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=x01ruuxA0cfwcbVBCUqqYJWqKZiSU+Bm+OyEXVm7xtY=;
 b=AUCyyHzINBQ9W4L+dDLw4lrfuDPuaIjIsAuSZ0ozsOGxQfmP0iZXbj+/1wXq/YtWdQ5oRy
 TRO/ACARgd4jczxZP1aDXLm7Nyo1jpWc0HwxR7504E8JM6X0KPKVaNw1ksv5LFV5XXBmKl
 4W30T64cgdeFmeF5N8nsLtROi6isyFI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1612962342;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=x01ruuxA0cfwcbVBCUqqYJWqKZiSU+Bm+OyEXVm7xtY=;
 b=LjB6okmxUCxx3tKYr39AD+549acMG4fuNOUxZv9kbVzc4WpLxTbC8mFgp+tjV1YuRQRq9l
 pLkX7uQgBos18f6EF9mIT/k1lJ3LpavGoaExQyhYsvL1WLZrH+jLDe9iyfWAkKaRtEvG8O
 1rXX7Kp8CkMLC4Q2tcX978G3apCJe8Y=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-sU5VjNtwOsO8BT4jJOAXHg-1; Wed, 10 Feb 2021 08:05:38 -0500
X-MC-Unique: sU5VjNtwOsO8BT4jJOAXHg-1
Received: by mail-pl1-f199.google.com with SMTP id w22so1645884pll.6
 for <linux-erofs@lists.ozlabs.org>; Wed, 10 Feb 2021 05:05:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=x01ruuxA0cfwcbVBCUqqYJWqKZiSU+Bm+OyEXVm7xtY=;
 b=CazdYHFmqDuYPS+zo03XudixWExqQn0JeXpXEfeOHWIr7Lc4gzMF9eKJqr96TNPqjX
 GTxObl8a9f3XSwIqD3pUG5JW2B2qFvwXOA4SDdbz2zpTMboAxjjxS60Jq92mehx5KYHa
 uHxVL8y7oh4pfUAkXKuWiig3FKBNNlT9Y+/TWLGMYd1ZN+kk29qeGHDf6JWqtYMRlzcB
 k97Y2RIo1fwfmctvi+CFrK2bTdgfPtX4Qjb5nxcx16o4tczf10jXr7F33oLUbrs+JZCB
 emLPJiuMSop2CvTkxXnZ2hwaSGYXjdUvymttP9bDeonwJ9gEp84qJf90/ohCQGbLQRu3
 VmoA==
X-Gm-Message-State: AOAM532h/ZDcGtk2oQRqxxmRWEZN3SspDnjZziy1PF5jz6fqhDGp7lTy
 R5yXLdj/cat4k4iXORBmjG3kmRSP1Wf/nURbFJVTinZASU6b/lJA3FWz2sC2saNjj5+piGeu004
 Y3wlXVO/d5UWEK7YR/sID7QJd
X-Received: by 2002:a17:90a:9912:: with SMTP id
 b18mr3066425pjp.120.1612962336875; 
 Wed, 10 Feb 2021 05:05:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxdnKAhSt6eJBEp/ZLzVhLX2BIuwzX2ua4xi+0pCTvmPOXEWG9GP4YnGf6EeZ8KNgbnoje4fw==
X-Received: by 2002:a17:90a:9912:: with SMTP id
 b18mr3066406pjp.120.1612962336608; 
 Wed, 10 Feb 2021 05:05:36 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
 by smtp.gmail.com with ESMTPSA id 124sm2367866pfd.59.2021.02.10.05.05.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 10 Feb 2021 05:05:35 -0800 (PST)
Date: Wed, 10 Feb 2021 21:05:25 +0800
From: Gao Xiang <hsiangkao@redhat.com>
To: Chao Yu <chao@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: Re: [PATCH] erofs: fix shift-out-of-bounds of blkszbits
Message-ID: <20210210130525.GB1173803@xiangao.remote.csb>
References: <20210120013016.14071-1-hsiangkao.ref@aol.com>
 <20210120013016.14071-1-hsiangkao@aol.com>
MIME-Version: 1.0
In-Reply-To: <20210120013016.14071-1-hsiangkao@aol.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=hsiangkao@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
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
Cc: syzkaller-bugs@googlegroups.com, linux-erofs@lists.ozlabs.org,
 LKML <linux-kernel@vger.kernel.org>,
 syzbot+c68f467cd7c45860e8d4@syzkaller.appspotmail.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Chao,

On Wed, Jan 20, 2021 at 09:30:16AM +0800, Gao Xiang wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> syzbot generated a crafted bitszbits which can be shifted
> out-of-bounds[1]. So directly print unsupported blkszbits
> instead of blksize.
> 
> [1] https://lore.kernel.org/r/000000000000c72ddd05b9444d2f@google.com
> Reported-by: syzbot+c68f467cd7c45860e8d4@syzkaller.appspotmail.com
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Could you kindly review this trivial syzaller patch as well? Since
"erofs: initialized fields can only be observed after bit is set"
is somewhat serious on some weak-memory-order designed platforms
(no idea why our hisilison ARM64 platform didn't observe it before.)
I intended to prepare this for 5.13 cycle directly with ongoing
multi pcluster / LZMA in-kernel decompresion. But that regression
seems a bit important to upstream for the next 5.12 cycle....

Thanks,
Gao Xiang

> ---
>  fs/erofs/super.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index be10b16ea66e..d5a6b9b888a5 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -158,8 +158,8 @@ static int erofs_read_superblock(struct super_block *sb)
>  	blkszbits = dsb->blkszbits;
>  	/* 9(512 bytes) + LOG_SECTORS_PER_BLOCK == LOG_BLOCK_SIZE */
>  	if (blkszbits != LOG_BLOCK_SIZE) {
> -		erofs_err(sb, "blksize %u isn't supported on this platform",
> -			  1 << blkszbits);
> +		erofs_err(sb, "blkszbits %u isn't supported on this platform",
> +			  blkszbits);
>  		goto out;
>  	}
>  
> -- 
> 2.24.0
> 

