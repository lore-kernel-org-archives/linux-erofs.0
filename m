Return-Path: <SRS0=D63+=WR=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E4CC3A589
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Aug 2019 00:41:09 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0244E22DD3
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Aug 2019 00:41:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="Q9YZi1h2";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=aol.com header.i=@aol.com header.b="kuYZOndM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0244E22DD3
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46CpkC01jMzDqTl
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Aug 2019 10:41:07 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1566348067;
	bh=Q8Kx+HV/Q7vAULU8cqcf/2KGRU8mW5ihxp/q/YSKRro=;
	h=Date:To:Subject:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=Q9YZi1h2tNbsLyfmA+DKsE6OcJDarzF1awV6JNYfijgnNfDh+rpvDuyQppEAjg4gQ
	 artnM9DNLYEyagaq8FPH0OGTipMHP9evbxdTq+tsxZXGxsXDBKPBz2Smm9lkSDS+r/
	 iNMT0iLQjwg2UlqJ5q9L7ZXEcRXUh7urLwn3vxXeY2meUyRSpxnvZyw4OZD1qlXTnm
	 80aHQ/8//p+ucV8ywYHgFF+xSCFOhIi+DUNzG3cy4GmnOlDN7u/SXQEJHv2XHPwaAQ
	 ByAvF6BTlwVZbC4agyTvFjMP0UqvJS2Us66THWNhIyIbZlBPVcr7hvzJuMnHVOE+Jp
	 bitEGxQx7a8og==
Authentication-Results: lists.ozlabs.org;
 spf=pass (mailfrom) smtp.mailfrom=aol.com
 (client-ip=77.238.178.202; helo=sonic303-21.consmr.mail.ir2.yahoo.com;
 envelope-from=hsiangkao@aol.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=aol.com header.i=@aol.com header.b="kuYZOndM"; 
 dkim-atps=neutral
Received: from sonic303-21.consmr.mail.ir2.yahoo.com
 (sonic303-21.consmr.mail.ir2.yahoo.com [77.238.178.202])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46Cpk33vcBzDqQM
 for <linux-erofs@lists.ozlabs.org>; Wed, 21 Aug 2019 10:40:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048;
 t=1566348053; bh=uoHNZJxJa9VRsV+z7AQWvIn+F0BxqijmyJlY6MgZLx4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From:Subject;
 b=kuYZOndMqe7ZC5FVvgqTPSEpRRpR/v17n+9t5OkwnoB/azmQsYebPxK7TFBzRRS0tlFMcBMNMbxK2Cn/WJWesBrsvzHu9cLxFziDdozf0fyLsFiOQK6m3tAHa283YzYPm0rZglXmHvH/IXiNpPkeKbMpxgt5Wjrf7QxCv/0CTS9VF7tpjASiCCJv1s6LQccD0PNz7PBZvAz5dBCFi6cUJJA1Vt70biT9RbefZUXDkSTIFij7imXhyB6VLjDqiL6whE+rjjRve+9hU+ct4LCJwamKmIqsCxWPyQavtjZKuxK7JzH3Cy9xzC18EN687EiMo50i048qMU46d57/qqVNYA==
X-YMail-OSG: Ne0pE6UVM1njlqX04b5NDgBjIt2EHYkIoGDI1beBg0HLNCWbFaLiyD.BdURxqUc
 f47pGF1kjOkFHaIDpKoTPVJ74azL2xJAolxEB4IQDcb7owml3CnNy83yPqzDiGkidCE1nCr68w9o
 Xt0ETL0vXXtY31hrcyIfLsiBMCg9Rp1cz4uC1AKShn7Je3LCFCmhiLyF8idrAGpVoa4HnBw8qPD5
 pEjSp3zvlPWI3DNu7lLF7AEH1FxD56rq0ddjcq5hnQHqbg2gYpW7twft_XFBUscYPSiFJxr21TZz
 Z_nnhaIX6MLRkz8Ec1YOM4xwQavC8uf9GePJT4bShI37BMXnq4gbSclEkKsOIVqKSf4SHURtnBv3
 NE2UXz7wxShaaJhPtA4DGhWACHReJKYPwTVpso6BnHLOZSmU0o3xMBGED8gani6UgyqkSgPFM6RH
 hwUQE16APmP4xvYpDC1apg10mRy8KKYVw73EVCA9N4Ul6DeVX_O3QeFaOWalToDaqbKFCUXFrQ2K
 vQHyq3aiqEhQtPeQtkQURnEjJDtzLeJww5xlB3hS108QfHdFLlIjhHkOdj7J6kViNo2ZldspNEWL
 HoSEqDriJUvrdxgHuwscge62F6.Tzy_oEhnsAOCw6E1D0TXZ8ag1Ta60toKbN05dkomyCVaml7jX
 HOdZ3DU_CE4_FEdhWzBTidiHv56sWzfNlnvh9kk2UGpVoTwiMxzikcM847bcjGaFp5r3qWF6XhTV
 hF6Hs4F0ZN9OoO.3pG3_Y9H8eqbMWQRmVrI9dj9VYgv.CRFSFIFzHrEzChXRZVc5BgoFwjtiWLFO
 ZI.yiu.13oXMtbvZ7LKEWTlINS4ynkYKevHWS9OFK6cfH0lvlXqiti3AJyq8DbvNWLg6VmlVhEZz
 z8JE8v8PcfpSkl9mdNaWOu1pekRdbY1tz_MVFtkRPMF_owBgcWZjlFTM3JMrWWP1ptDOWOm.ZTRQ
 FFz5zwez9E4ybJHA23D8hd889Mx.o3GGlcLZD8ioq_gnIwM0tirQUSsUNWNN77ZYCDsBHbfYNR1e
 OETXSoROVgqo1HH3fJqsxnMq26.KqAVEOpQdoVESyDRklcNzBAx10YQQgOUwZrMQnU8vgvK4NpFj
 _5iL.eWA8esgzd7qQXVxmiCPTs9Qf0MOcww63yQ5Fr7D4oEDzLjeJlMaU3Nc8jPFDyz53wzjFwSa
 fOQF2Dlz5IYqRDk7wQ2m.ikDhZ0Oa85W2uErgxpbA6kqZcjA0OZsgeQkFGzRSpF8WLLd2eZ.E8SV
 QGnwLyTj0Jdfo9LOOArcM.j1cJJvyXg--
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic303.consmr.mail.ir2.yahoo.com with HTTP; Wed, 21 Aug 2019 00:40:53 +0000
Received: by smtp405.mail.ir2.yahoo.com (Oath Hermes SMTP Server) with ESMTPA
 ID 9bc5d03928255fbfd31111b341626360; 
 Wed, 21 Aug 2019 00:40:49 +0000 (UTC)
Date: Wed, 21 Aug 2019 08:40:43 +0800
To: Caitlyn <caitlynannefinn@gmail.com>
Subject: Re: [PATCH 2/2] staging/erofs: Balanced braces around a few
 conditional statements.
Message-ID: <20190821004042.GB18606@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <1566346700-28536-1-git-send-email-caitlynannefinn@gmail.com>
 <1566346700-28536-3-git-send-email-caitlynannefinn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566346700-28536-3-git-send-email-caitlynannefinn@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
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
From: Gao Xiang via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Gao Xiang <hsiangkao@aol.com>
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-kernel@vger.kernel.org, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Tue, Aug 20, 2019 at 08:18:20PM -0400, Caitlyn wrote:
> Balanced braces to fix some checkpath warnings in inode.c and
> unzip_vle.c
> 
> Signed-off-by: Caitlyn <caitlynannefinn@gmail.com>
> ---
>  drivers/staging/erofs/inode.c     |  4 ++--
>  drivers/staging/erofs/unzip_vle.c | 12 ++++++------
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
> index 4c3d8bf..8de6fcd 100644
> --- a/drivers/staging/erofs/inode.c
> +++ b/drivers/staging/erofs/inode.c
> @@ -278,9 +278,9 @@ struct inode *erofs_iget(struct super_block *sb,
>  		vi->nid = nid;
>  
>  		err = fill_inode(inode, isdir);
> -		if (likely(!err))
> +		if (likely(!err)) {
>  			unlock_new_inode(inode);

The only valid place is here.

Thanks,
Gao Xiang

> -		else {
> +		} else {
>  			iget_failed(inode);
>  			inode = ERR_PTR(err);
>  		}
> diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
> index f0dab81..f431614 100644
> --- a/drivers/staging/erofs/unzip_vle.c
> +++ b/drivers/staging/erofs/unzip_vle.c
> @@ -915,21 +915,21 @@ static int z_erofs_vle_unzip(struct super_block *sb,
>  	mutex_lock(&work->lock);
>  	nr_pages = work->nr_pages;
>  
> -	if (likely(nr_pages <= Z_EROFS_VLE_VMAP_ONSTACK_PAGES))
> +	if (likely(nr_pages <= Z_EROFS_VLE_VMAP_ONSTACK_PAGES)) {
>  		pages = pages_onstack;
> -	else if (nr_pages <= Z_EROFS_VLE_VMAP_GLOBAL_PAGES &&
> -		 mutex_trylock(&z_pagemap_global_lock))
> +	} else if (nr_pages <= Z_EROFS_VLE_VMAP_GLOBAL_PAGES &&
> +		 mutex_trylock(&z_pagemap_global_lock)) {
>  		pages = z_pagemap_global;
> -	else {
> +	} else {
>  repeat:
>  		pages = kvmalloc_array(nr_pages, sizeof(struct page *),
>  				       GFP_KERNEL);
>  
>  		/* fallback to global pagemap for the lowmem scenario */
>  		if (unlikely(!pages)) {
> -			if (nr_pages > Z_EROFS_VLE_VMAP_GLOBAL_PAGES)
> +			if (nr_pages > Z_EROFS_VLE_VMAP_GLOBAL_PAGES) {
>  				goto repeat;
> -			else {
> +			} else {
>  				mutex_lock(&z_pagemap_global_lock);
>  				pages = z_pagemap_global;
>  			}
> -- 
> 2.7.4
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
