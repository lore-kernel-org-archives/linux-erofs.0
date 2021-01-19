Return-Path: <SRS0=T4eZ=GW=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA4EC433E0
	for <linux-erofs@archiver.kernel.org>; Tue, 19 Jan 2021 15:36:51 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BE73F2070C
	for <linux-erofs@archiver.kernel.org>; Tue, 19 Jan 2021 15:36:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE73F2070C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4DKt745tTKzDr0Q
	for <linux-erofs@archiver.kernel.org>; Wed, 20 Jan 2021 02:36:48 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=redhat.com (client-ip=63.128.21.124;
 helo=us-smtp-delivery-124.mimecast.com; envelope-from=hsiangkao@redhat.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256
 header.s=mimecast20190719 header.b=QJxEyAhl; 
 dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com
 header.a=rsa-sha256 header.s=mimecast20190719 header.b=QJxEyAhl; 
 dkim-atps=neutral
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4DKt6w2LrtzDqtt
 for <linux-erofs@lists.ozlabs.org>; Wed, 20 Jan 2021 02:36:37 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1611070594;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=IQnFGMHwVFhQgbibFkYK3pXJiA7D/GP0Kwa8aQOmtFE=;
 b=QJxEyAhltB/H4GHd0QK2wDqgHuV7HsD+gB/ijpVE0x/B4dgqRPnGw+hFBzkqC21Wqtu+de
 T6F6YI6tzzShHgxNNKjT3Z/fkP3e6+M2draTHQD6k439KpRkEgWBSc1qx7ZHXDCzBRAqQx
 F1Jm26vrNwQLKuiqg+Wt86AbmQEDBlQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1611070594;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=IQnFGMHwVFhQgbibFkYK3pXJiA7D/GP0Kwa8aQOmtFE=;
 b=QJxEyAhltB/H4GHd0QK2wDqgHuV7HsD+gB/ijpVE0x/B4dgqRPnGw+hFBzkqC21Wqtu+de
 T6F6YI6tzzShHgxNNKjT3Z/fkP3e6+M2draTHQD6k439KpRkEgWBSc1qx7ZHXDCzBRAqQx
 F1Jm26vrNwQLKuiqg+Wt86AbmQEDBlQ=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-2p9xhBnJOqacZ-GDZl8-Uw-1; Tue, 19 Jan 2021 10:36:32 -0500
X-MC-Unique: 2p9xhBnJOqacZ-GDZl8-Uw-1
Received: by mail-pl1-f200.google.com with SMTP id y15so2399831plp.23
 for <linux-erofs@lists.ozlabs.org>; Tue, 19 Jan 2021 07:36:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=IQnFGMHwVFhQgbibFkYK3pXJiA7D/GP0Kwa8aQOmtFE=;
 b=StWNmzTjj+Q6X752hIwT5OiBy7nNtp0ghZMcQRUg7E0FoiNpw3K2Kn+4Oet/nxcOJH
 YX2pXFT3lKnNY9/NQXIrwX9RRwwRajtMeMoVHihQvY6px6nvKtg3ed9A+vzXfL+S/fHV
 fFBqOvnSmMnKiSi6pNn13DvjmXrQ351diquSNPFyQpjyAj6eNYf8x55zZ57qW4hUWy7w
 +ywsaPY30vwCHX9nuSfXp4xQk2fRwT0jXOBMVBEq6jkrsoBDSHoLUZAI3nJ/dE/2jrIw
 cfcU1Yj4gLUdK2UTE3RDWIpGkbZSWrlp9LKsOpW2aLcBDAqQti0Mf305APpdLtexUPWO
 MKdg==
X-Gm-Message-State: AOAM5303XZW4zVVnFVneSPEWJPWSC6ZS8ZsI6mOHfjCVLAzfi78o2MT3
 DPby3Nwwxuq2KFM4JV7PtOxLPXXgBLAmMIWG0MIp1zU0pive0AoXpRgjCynlu5L43tu8eEUBT09
 keyDMTbsNXFdD+U+eaHs439FT
X-Received: by 2002:a63:e20b:: with SMTP id q11mr4977201pgh.396.1611070590954; 
 Tue, 19 Jan 2021 07:36:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyUYY5W+25CAoXhoeYvCFDQrqJ8aHAORuAXF8uf5/Pp8POpFZnKGIPTj0tzt+TFAVVzHgML2Q==
X-Received: by 2002:a63:e20b:: with SMTP id q11mr4977165pgh.396.1611070590475; 
 Tue, 19 Jan 2021 07:36:30 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
 by smtp.gmail.com with ESMTPSA id oa10sm3579602pjb.45.2021.01.19.07.36.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 19 Jan 2021 07:36:30 -0800 (PST)
Date: Tue, 19 Jan 2021 23:36:20 +0800
From: Gao Xiang <hsiangkao@redhat.com>
To: Hu Weiwen <sehuww@mail.scut.edu.cn>
Subject: Re: [PATCH v2] erofs-utils: fix memory leak when erofs_fill_inode()
 fails
Message-ID: <20210119153620.GA2601261@xiangao.remote.csb>
References: <20210118124033.23888-1-sehuww@mail.scut.edu.cn>
 <20210119061123.9774-1-sehuww@mail.scut.edu.cn>
MIME-Version: 1.0
In-Reply-To: <20210119061123.9774-1-sehuww@mail.scut.edu.cn>
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
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Weiwen,

On Tue, Jan 19, 2021 at 02:11:23PM +0800, Hu Weiwen wrote:
> Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> ---
> fixes a typo in v1
> 
>  lib/inode.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/inode.c b/lib/inode.c
> index d6a64cc..6f6e984 100644
> --- a/lib/inode.c
> +++ b/lib/inode.c
> @@ -868,9 +868,13 @@ struct erofs_inode *erofs_iget_from_path(const char *path, bool is_src)
> 
>  	ret = erofs_fill_inode(inode, &st, path);
>  	if (ret)
> -		return ERR_PTR(ret);
> +		goto err;
> 
>  	return inode;
> +
> +err:
> +	free(inode);
> +	return ERR_PTR(ret);

Yeah, I think many error paths now might have memory leak, yet I'm not sure
if these does matter since the program would be exited soon... (since liberofs
doesn't export as a public library for now since I don't think these APIs are
finalized to public...)

Since there is the only one user of this label... So I think we might inline
such error path until more users exist?

Otherwise it looks good to me.

Thanks,
Gao Xiang

>  }
> 
>  void erofs_fixup_meta_blkaddr(struct erofs_inode *rootdir)
> --
> 2.30.0
> 

