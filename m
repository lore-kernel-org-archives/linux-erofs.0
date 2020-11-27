Return-Path: <SRS0=4boh=FB=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 206ADC63777
	for <linux-erofs@archiver.kernel.org>; Fri, 27 Nov 2020 10:48:50 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 69618205F4
	for <linux-erofs@archiver.kernel.org>; Fri, 27 Nov 2020 10:48:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YsoySWIH";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YsoySWIH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69618205F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4CjBFB4YRqzDrgf
	for <linux-erofs@archiver.kernel.org>; Fri, 27 Nov 2020 21:48:46 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=redhat.com (client-ip=63.128.21.124;
 helo=us-smtp-delivery-124.mimecast.com; envelope-from=hsiangkao@redhat.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256
 header.s=mimecast20190719 header.b=YsoySWIH; 
 dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com
 header.a=rsa-sha256 header.s=mimecast20190719 header.b=YsoySWIH; 
 dkim-atps=neutral
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4CjBCB0BtYzDrfH
 for <linux-erofs@lists.ozlabs.org>; Fri, 27 Nov 2020 21:47:00 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1606474016;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ooPAVDF40JKUlgiFOlauBRmbGIu+Ms5e/R1wskVKj7g=;
 b=YsoySWIHq7itXfxhRJyK+eSAUI3b+b+Z3arOPnJ0RuTZLMVC5D9j6BXyHGsKgclhL3cqA3
 moHXaNXaIn82p/SJrO3xoCaPpLgG6eupSsPR3l3ira2bZwzNQ5TAtaNgj4/vb1VnmXzq+W
 RnRPKL3VseXgx5FCozSQ1RqeW31YBfw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1606474016;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ooPAVDF40JKUlgiFOlauBRmbGIu+Ms5e/R1wskVKj7g=;
 b=YsoySWIHq7itXfxhRJyK+eSAUI3b+b+Z3arOPnJ0RuTZLMVC5D9j6BXyHGsKgclhL3cqA3
 moHXaNXaIn82p/SJrO3xoCaPpLgG6eupSsPR3l3ira2bZwzNQ5TAtaNgj4/vb1VnmXzq+W
 RnRPKL3VseXgx5FCozSQ1RqeW31YBfw=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148--G1a4Wd9P4WixjVmv2mMwA-1; Fri, 27 Nov 2020 05:46:52 -0500
X-MC-Unique: -G1a4Wd9P4WixjVmv2mMwA-1
Received: by mail-pf1-f198.google.com with SMTP id p5so3736521pfb.14
 for <linux-erofs@lists.ozlabs.org>; Fri, 27 Nov 2020 02:46:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=ooPAVDF40JKUlgiFOlauBRmbGIu+Ms5e/R1wskVKj7g=;
 b=hDbqzqQIPYqkXjzf1f2mcCzZK+d2YoAh63j28vlsHfQaVc3cqspXlHBAN1Dtdj6lKW
 6EECfAAEO4N2tTE4CIOC+otI785dd35AKyUt81PkeDwDWMyEIT5/ZULkLBFvcuSVrIed
 9Qoth3SZTos1O5xVH9r0rZLWo5p1YJ5sJbDnS9VembrysZWJcLTtubjFjLrJcuGf+O93
 UV11beaGaDYdmy370+nd5F/S9XOu4Rg4WIRJGkbtMZLoM743dHOdMHaphPXqa+VGQFey
 8lx8bbm2/GZIA3hyh2FWt1AbVrFoWe5Pb8ta0ioOyDHgb5p3gqhV9ryzHLmiTb/xTUyb
 VShw==
X-Gm-Message-State: AOAM532MF1kRHsD9jFnv1ojKP2PHdIVJxWpvBzMjyA3oMDhaFNEOKOEB
 kn8fV7C0EJy5op2nUEdKlN/8RqaR+wb0QfVUlm5VkkPh6EI3s6RckK5hAIs5fzdoXrTfT1zw+yG
 v1g7B//oXVANk90efFCQqdrnM
X-Received: by 2002:a63:145d:: with SMTP id 29mr6100012pgu.285.1606474011401; 
 Fri, 27 Nov 2020 02:46:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzQSMk8kMmOZNDTabH+Md1k8uNxcCh3IphJbqWNmNcHJuM1Uq5pcia4KEvamAjfaFSXmmMjDw==
X-Received: by 2002:a63:145d:: with SMTP id 29mr6100002pgu.285.1606474011217; 
 Fri, 27 Nov 2020 02:46:51 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
 by smtp.gmail.com with ESMTPSA id e23sm7283914pfd.64.2020.11.27.02.46.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 27 Nov 2020 02:46:50 -0800 (PST)
Date: Fri, 27 Nov 2020 18:46:40 +0800
From: Gao Xiang <hsiangkao@redhat.com>
To: Huang Jianan <huangjianan@oppo.com>
Subject: Re: [PATCH] erofs-utils: fix use after free in closedir
Message-ID: <20201127104640.GC598572@xiangao.remote.csb>
References: <20201127101511.33373-1-huangjianan@oppo.com>
MIME-Version: 1.0
In-Reply-To: <20201127101511.33373-1-huangjianan@oppo.com>
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
Cc: liufeibao@oppo.com, guoweichao@oppo.com, linux-erofs@lists.ozlabs.org,
 zhangshiming@oppo.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Jianan,

On Fri, Nov 27, 2020 at 06:15:11PM +0800, Huang Jianan wrote:
> No need to closedir _dir again since it has been released.
> 
> Signed-off-by: Huang Jianan <huangjianan@oppo.com>
> Signed-off-by: Guo Weichao <guoweichao@oppo.com>
> ---
>  lib/inode.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/inode.c b/lib/inode.c
> index eb2e0f2..2397bc7 100644
> --- a/lib/inode.c
> +++ b/lib/inode.c
> @@ -958,11 +958,11 @@ struct erofs_inode *erofs_mkfs_build_tree(struct erofs_inode *dir)
>  
>  	ret = erofs_prepare_dir_file(dir);
>  	if (ret)
> -		goto err_closedir;
> +		goto err;
>  
>  	ret = erofs_prepare_inode_buffer(dir);
>  	if (ret)
> -		goto err_closedir;
> +		goto err;

Thanks for finding this, after looking into the current dev branch,
I think

		if (IS_ERR(d->inode)) {
			ret = PTR_ERR(d->inode);
fail:
			d->inode = NULL;
			d->type = EROFS_FT_UNKNOWN;
			goto err_closedir;
		}

needs to be fixed as well.
You could fix it or I can also send the next version about this
if needed.


Thanks,
Gao Xiang

>  
>  	if (IS_ROOT(dir))
>  		erofs_fixup_meta_blkaddr(dir);
> @@ -1003,6 +1003,7 @@ fail:
>  
>  err_closedir:
>  	closedir(_dir);
> +err:
>  	return ERR_PTR(ret);
>  }
>  
> -- 
> 2.25.1
> 

