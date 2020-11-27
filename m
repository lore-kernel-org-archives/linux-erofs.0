Return-Path: <SRS0=4boh=FB=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C7D9C2D0E4
	for <linux-erofs@archiver.kernel.org>; Fri, 27 Nov 2020 13:17:41 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 23E142223F
	for <linux-erofs@archiver.kernel.org>; Fri, 27 Nov 2020 13:17:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y3a0T9BJ";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BIBF0dyK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23E142223F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4CjFXt1sWXzDrfN
	for <linux-erofs@archiver.kernel.org>; Sat, 28 Nov 2020 00:17:34 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=redhat.com (client-ip=63.128.21.124;
 helo=us-smtp-delivery-124.mimecast.com; envelope-from=hsiangkao@redhat.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256
 header.s=mimecast20190719 header.b=Y3a0T9BJ; 
 dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com
 header.a=rsa-sha256 header.s=mimecast20190719 header.b=BIBF0dyK; 
 dkim-atps=neutral
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4CjFX31dDHzDrRH
 for <linux-erofs@lists.ozlabs.org>; Sat, 28 Nov 2020 00:16:49 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1606483006;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=QVXWPpYgXcdOY4MY7ilUhTKav+S3jlh8i9zTxFO2mVo=;
 b=Y3a0T9BJ4Md9Fl+vGeFG+p3a52xfRG3r7e3nrB3nJjEe3rIERZ43BIwUsGtLJkpEpXHMoO
 z0VymDU4L5EkNw4Y+2eJLBSVy+efR7TJRTlVWPgzhSl2OISwf4CLollVh79aS+sfFwcL3H
 wyb8ytsHbUlAGsrnilszefyahsc6U8o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1606483007;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=QVXWPpYgXcdOY4MY7ilUhTKav+S3jlh8i9zTxFO2mVo=;
 b=BIBF0dyKwJ0vQAqs8aqxSIz0PFCniTp9pqJ46C5SMGXk+0snMpVZ65h3s8TJNnlr3OWhDu
 0+slrbqBAeVWGlDkVk/zj2aA2WR4vv6Ey5xoedtJ2FpUnjuDSE8Q0Py4Qu/ZxxLJr4rYmh
 THOSP0ZnfWIQnf39Edefj21YHsZIQBk=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-O2dMsx26Nia35aXlCuRfDw-1; Fri, 27 Nov 2020 08:16:44 -0500
X-MC-Unique: O2dMsx26Nia35aXlCuRfDw-1
Received: by mail-pl1-f198.google.com with SMTP id t13so3553281plo.16
 for <linux-erofs@lists.ozlabs.org>; Fri, 27 Nov 2020 05:16:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=QVXWPpYgXcdOY4MY7ilUhTKav+S3jlh8i9zTxFO2mVo=;
 b=OBDXntxWvS/YVPV3gYyzANG5Ve0cuEuhsI2qWWEHNQtfckOK1rKk35DTFFoFeBPKKT
 R+KaNu8y6FQWgGB4fj2lueOFDuMm4ZejGtWsf75o2OpTqxCPadj1d+CR8YluvEfSWfdC
 b2kfkCuHSvQ/mqF3vaGi9W9IND6QgxHI2DTntXlwgBW2zfJJy7u3E3QyFksKLk+y1a3D
 0hTr4gFZyiGkbQDC/10BKdqdMRksCknYHxlgYLje9qc2PLv2vz1rEAsrH/0IGBWHGIgS
 cp0uJ0kiZI2WPXts9w9cNFYYjEtmUe1LCL8+QFK7tKcgDC+2JeVzjpe45Vro39mxdu6p
 MGbg==
X-Gm-Message-State: AOAM531xW35lsho5K6nm+L4hf9CIihqsZpu2qB7TOLlpavg55fY+9Y++
 JJSYKPXQJ9AnZ1VAqpKjf5dSY6Rt0Drocd7gciLxCcY8DctyIgp2UgNX9IseTsLw1luEx5kgQ6N
 4Y2tUWU/VNBuNza8x5Ki8k47PWFZgIO3xNwvGtICZ4NcqFhQL+0zI8CZayNr/diznO1jO3HWAxR
 /+9g==
X-Received: by 2002:a17:90a:df05:: with SMTP id
 gp5mr10097723pjb.143.1606483003676; 
 Fri, 27 Nov 2020 05:16:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzolQKEh1HlPSE3HvSPgxISF81YRI9NapShhOr5keryKqeenyRjqp1KKBhO72VgQRGUkz4+4g==
X-Received: by 2002:a17:90a:df05:: with SMTP id
 gp5mr10097684pjb.143.1606483003336; 
 Fri, 27 Nov 2020 05:16:43 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
 by smtp.gmail.com with ESMTPSA id i4sm7063591pgg.67.2020.11.27.05.16.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 27 Nov 2020 05:16:42 -0800 (PST)
Date: Fri, 27 Nov 2020 21:16:30 +0800
From: Gao Xiang <hsiangkao@redhat.com>
To: linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH v3 0/3] erofs-utils: introduce fuse implementation
Message-ID: <20201127131630.GA654423@xiangao.remote.csb>
References: <20201127114617.13055-1-hsiangkao.ref@aol.com>
 <20201127114617.13055-1-hsiangkao@aol.com>
MIME-Version: 1.0
In-Reply-To: <20201127114617.13055-1-hsiangkao@aol.com>
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
Cc: Guo Weichao <guoweichao@oppo.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Fri, Nov 27, 2020 at 07:46:14PM +0800, Gao Xiang via Linux-erofs wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> changes since v2:
>  - erofs_dbg() -> erofs_dump() in signal_handle_sigsegv() (Guifu);
>  - get rid of unnecessary new lines (Guifu).
> 
> changes since v1:
>  - fix off-by-one error of namebuf in erofs_fill_dentries();
>  - drop unused "struct erofs_super_block super;" in lib/super.c; 
>  - fix clang/32-bit build errors founded by travis CI.

FYI, I will apply this to dev branch since it has been of some
preliminary deployment by some vendor, plus it's disabled
by default for the upcoming erofs-utils 1.2. And it's already
in shape after several rounds cleanup.

I'm looking into and will add more automated testcase coverage
for this stuff.

Incremental bugfixes / improvements for erofsfuse are always
welcome!

Thanks,
Gao Xiang

