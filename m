Return-Path: <SRS0=/jrW=W7=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 584F3C3A5A7
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Sep 2019 06:31:48 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C7A3423402
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Sep 2019 06:31:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ytgUb1zf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7A3423402
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46NYrK4pz6zDqrj
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Sep 2019 16:31:45 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
 spf=pass (mailfrom) smtp.mailfrom=linuxfoundation.org
 (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=gregkh@linuxfoundation.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none)
 header.from=linuxfoundation.org
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.b="ytgUb1zf"; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46NYrD52HqzDqk9
 for <linux-erofs@lists.ozlabs.org>; Wed,  4 Sep 2019 16:31:39 +1000 (AEST)
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl
 [83.86.89.107])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2FC8323401;
 Wed,  4 Sep 2019 06:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1567578696;
 bh=PCHRSJN/29rWdZmjjbmIldw+gqhJ+cRKkDckabYFM5A=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=ytgUb1zfWZG0zWal4Vp+/G0jkGKMJG3sJIWaE7p4zYAQyQ+uiJJwlZ8upch/y+x8g
 mHLM7amDJOcg6KRQAgw6ReqMHj90tAC4AcxOENYW4YETegGsM5+6MpcltidL7tEuB4
 hVT6BZATChqrr9np1OXCVVwHZ9HV7INyLBLf3nUA=
Date: Wed, 4 Sep 2019 08:31:34 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Gao Xiang <gaoxiang25@huawei.com>
Subject: Re: [PATCH] erofs: using switch-case while checking the inode type.
Message-ID: <20190904063134.GA24285@kroah.com>
References: <20190830095615.10995-1-pratikshinde320@gmail.com>
 <20190830115947.GA10981@hsiangkao-HP-ZHAN-66-Pro-G1>
 <20190830142233.GA241393@architecture4>
 <20190904021247.GA65103@architecture4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904021247.GA65103@architecture4>
User-Agent: Mutt/1.12.1 (2019-06-15)
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
Cc: devel@driverdev.osuosl.org, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Wed, Sep 04, 2019 at 10:12:47AM +0800, Gao Xiang wrote:
> Hi Greg,
> 
> On Fri, Aug 30, 2019 at 10:22:33PM +0800, Gao Xiang wrote:
> > On Fri, Aug 30, 2019 at 07:59:48PM +0800, Gao Xiang wrote:
> > > Hi Pratik,
> > > 
> > > The subject line could be better as '[PATCH v2] xxxxxx'...
> > > 
> > > On Fri, Aug 30, 2019 at 03:26:15PM +0530, Pratik Shinde wrote:
> > > > while filling the linux inode, using switch-case statement to check
> > > > the type of inode.
> > > > switch-case statement looks more clean here.
> > > > 
> > > > Signed-off-by: Pratik Shinde <pratikshinde320@gmail.com>
> > > 
> > > I have no problem of this patch, and I will do a test and reply
> > > you "Reviewed-by:" in hours (I'm doing another patchset to resolve
> > > what Christoph suggested again)...
> > 
> > Reviewed-by: Gao Xiang <gaoxiang25@huawei.com>
> 
> ping.. could you kindly merge this patch, the following patchset
> has dependency on it...

Will go do that now, sorry for the delay.

greg k-h
