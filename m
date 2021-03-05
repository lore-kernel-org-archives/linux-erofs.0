Return-Path: <SRS0=81ls=ID=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A307C433DB
	for <linux-erofs@archiver.kernel.org>; Fri,  5 Mar 2021 09:20:46 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4363364F73
	for <linux-erofs@archiver.kernel.org>; Fri,  5 Mar 2021 09:20:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4363364F73
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4DsMfM5NCKz3cK8
	for <linux-erofs@archiver.kernel.org>; Fri,  5 Mar 2021 20:20:43 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=FWSJtCNO;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=FWSJtCNO;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=redhat.com (client-ip=216.205.24.124;
 helo=us-smtp-delivery-124.mimecast.com; envelope-from=hsiangkao@redhat.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256
 header.s=mimecast20190719 header.b=FWSJtCNO; 
 dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com
 header.a=rsa-sha256 header.s=mimecast20190719 header.b=FWSJtCNO; 
 dkim-atps=neutral
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4DsMfK33Cvz30Ql
 for <linux-erofs@lists.ozlabs.org>; Fri,  5 Mar 2021 20:20:38 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1614936035;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Ewds+wRWOHNMJpjK0L8o8oTPixozR81HX+R2nb+Ucf8=;
 b=FWSJtCNOii3581kdLVE0tJTpBZs8U4jPy4qPBTwEcSeiAJ1Ms2MtfVhVfD0UjymFdvtPot
 5aOlgI4ti+i5wDoQAjhOQ9PL0cTl+B5kuG3JC28G3NxAp1VArFWcZMkGow3ZNMymwYfD/8
 KZcLY1gbL9vaLJW57lVZiYIbhvAV1oE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1614936035;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Ewds+wRWOHNMJpjK0L8o8oTPixozR81HX+R2nb+Ucf8=;
 b=FWSJtCNOii3581kdLVE0tJTpBZs8U4jPy4qPBTwEcSeiAJ1Ms2MtfVhVfD0UjymFdvtPot
 5aOlgI4ti+i5wDoQAjhOQ9PL0cTl+B5kuG3JC28G3NxAp1VArFWcZMkGow3ZNMymwYfD/8
 KZcLY1gbL9vaLJW57lVZiYIbhvAV1oE=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-dpBw3ImrP7epjiG-p7sMuA-1; Fri, 05 Mar 2021 04:20:32 -0500
X-MC-Unique: dpBw3ImrP7epjiG-p7sMuA-1
Received: by mail-pf1-f198.google.com with SMTP id t69so1047297pfc.0
 for <linux-erofs@lists.ozlabs.org>; Fri, 05 Mar 2021 01:20:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=Ewds+wRWOHNMJpjK0L8o8oTPixozR81HX+R2nb+Ucf8=;
 b=WZrNwMNkgc3QXuugKFD/fGakXPc64sNVHy6Pb0H3ZbY1qsBrq0ZuI6F4NLWzMVqGq4
 xKvwTiBIhUY965P6jT0wmZvj24ahQk57+gXZTmfJ5zzSBpHVZiaCqEBPhrGpGdqtCnOb
 7mun+A9raodMyGkxxlyenAF/ji118JGCx2GYAopz76ELC/vovWdy7AM74zQuT8BS0N2r
 jVtSMqPyaB/tpqVeUm7tCDsI4WU1O8Ys4A40+OKDA2yY+G0riD0Rs8ajsLj94Q8RpqoW
 zb9K1MONdwrd4NBeFGRaYRU+37iOs2u0uQHUpfzxXkS4gLXTQfhNqEIiaRkDUFJXY+R/
 1/BA==
X-Gm-Message-State: AOAM531k7a84nBuftz8IfjePCrOf+ClcKNpZvemiAOkhTuyt+ZjIZX7e
 C7UoE2eAHc17E+3vM5fkukah8C/Ic8dDxVEmWKKubx4Hzm7a/XDKPFnRH1cybH/yDCeuT2cQ84t
 v0rYjcpsby0WmlxUUJal6YF2V
X-Received: by 2002:a62:68c1:0:b029:1ee:5dfa:860b with SMTP id
 d184-20020a6268c10000b02901ee5dfa860bmr7896212pfc.35.1614936031791; 
 Fri, 05 Mar 2021 01:20:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyyX/b4S9nIkSL816d/s6Hnx8UDwFDfXcwyK4iFy3n6vw5MVFSuJXC1lGHsfdwOqX68fN/8BA==
X-Received: by 2002:a62:68c1:0:b029:1ee:5dfa:860b with SMTP id
 d184-20020a6268c10000b02901ee5dfa860bmr7896199pfc.35.1614936031598; 
 Fri, 05 Mar 2021 01:20:31 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
 by smtp.gmail.com with ESMTPSA id w17sm1841709pgg.41.2021.03.05.01.20.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 05 Mar 2021 01:20:30 -0800 (PST)
Date: Fri, 5 Mar 2021 17:20:20 +0800
From: Gao Xiang <hsiangkao@redhat.com>
To: Huang Jianan <huangjianan@oppo.com>
Subject: Re: [PATCH v4 2/2] erofs: decompress in endio if possible
Message-ID: <20210305092020.GA3114893@xiangao.remote.csb>
References: <20210305082142.877265-1-huangjianan@oppo.com>
MIME-Version: 1.0
In-Reply-To: <20210305082142.877265-1-huangjianan@oppo.com>
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
Cc: zhangshiming@oppo.com, guoweichao@oppo.com, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Fri, Mar 05, 2021 at 04:21:42PM +0800, Huang Jianan via Linux-erofs wrote:
> z_erofs_decompressqueue_endio may not be executed in the atomic
> context, for example, when dm-verity is turned on. In this scenario,
> data can be decompressed directly to get rid of additional kworker
> scheduling overhead. Also, it makes no sense to apply synchronous
> decompression for such case.

Could you resend the whole patchset [v4 RESEND] as a whole? Or you
can use --in-reply-to to attach the original version.

Yet I'd suggest you could resend them all this time...

> 
> Signed-off-by: Huang Jianan <huangjianan@oppo.com>
> Signed-off-by: Guo Weichao <guoweichao@oppo.com>
> ---
>  fs/erofs/internal.h |  3 +++
>  fs/erofs/super.c    |  4 ++++
>  fs/erofs/zdata.c    | 16 +++++++++++++---
>  3 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
> index 67a7ec945686..b817cb85d67b 100644
> --- a/fs/erofs/internal.h
> +++ b/fs/erofs/internal.h
> @@ -70,6 +70,9 @@ struct erofs_sb_info {
>  
>  	/* pseudo inode to manage cached pages */
>  	struct inode *managed_cache;
> +
> +	/* decide whether to decompress synchronously */
> +	bool readahead_sync_decompress;
>  #endif	/* CONFIG_EROFS_FS_ZIP */
>  	u32 blocks;
>  	u32 meta_blkaddr;
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index d5a6b9b888a5..77819efe9b15 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -175,6 +175,10 @@ static int erofs_read_superblock(struct super_block *sb)
>  	sbi->root_nid = le16_to_cpu(dsb->root_nid);
>  	sbi->inos = le64_to_cpu(dsb->inos);
>  
> +#ifdef CONFIG_EROFS_FS_ZIP
> +	sbi->readahead_sync_decompress = false;
> +#endif

How about moving this stuff to erofs_default_options() as what we
did for max_sync_decompress_pages?

Thanks,
Gao Xiang

