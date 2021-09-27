Return-Path: <SRS0=/wub=OR=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5932AC433F5
	for <linux-erofs@archiver.kernel.org>; Mon, 27 Sep 2021 11:03:58 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 85AAC610A2
	for <linux-erofs@archiver.kernel.org>; Mon, 27 Sep 2021 11:03:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 85AAC610A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4HJ0BN14DYz2yPK
	for <linux-erofs@archiver.kernel.org>; Mon, 27 Sep 2021 21:03:56 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (1024-bit key; unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UAu6Ak/k;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linuxfoundation.org (client-ip=198.145.29.99;
 helo=mail.kernel.org; envelope-from=gregkh@linuxfoundation.org;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org
 header.a=rsa-sha256 header.s=korg header.b=UAu6Ak/k; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4HJ0BJ3vygz2yJQ
 for <linux-erofs@lists.ozlabs.org>; Mon, 27 Sep 2021 21:03:51 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF09061058;
 Mon, 27 Sep 2021 11:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1632740628;
 bh=vSYRwndrh3eKEx+7FDEFsnWqqwtbPtSCDm4Bk/Dc2cA=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=UAu6Ak/kWPEI9BxlR+umrTGDl59369s7rW+/G1ks4je6LDUbn1uGn6v7DOSS/vXBo
 SaOR3AT6c9uzZPMzod5BCB/YkXB0D99drXUim6m1WWipnpg45A4raNMhh2Ib3kLttK
 C5LgGlfANUjmiINjVSHjd1ULNDpB0lDWzIc2uhYk=
Date: Mon, 27 Sep 2021 13:03:46 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: Re: [PATCH 4.19.y RESEND] erofs: fix up erofs_lookup tracepoint
Message-ID: <YVGlEkRjA2OfM9mW@kroah.com>
References: <163266167710981@kroah.com>
 <20210927052954.136280-1-hsiangkao@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927052954.136280-1-hsiangkao@linux.alibaba.com>
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
Cc: linux-erofs@lists.ozlabs.org, stable@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Mon, Sep 27, 2021 at 01:29:54PM +0800, Gao Xiang wrote:
> commit 93368aab0efc87288cac65e99c9ed2e0ffc9e7d0 upstream.
> 
> Fix up a misuse that the filename pointer isn't always valid in
> the ring buffer, and we should copy the content instead.
> 
> Link: https://lore.kernel.org/r/20210921143531.81356-1-hsiangkao@linux.alibaba.com
> Fixes: 13f06f48f7bf ("staging: erofs: support tracepoint")
> Cc: stable@vger.kernel.org # 4.19+
> Reviewed-by: Chao Yu <chao@kernel.org>
> [ Gao Xiang: resolve trivial conflicts for 4.19.y. ]
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> ---
> add missing upstream commit id...

Now queued up, thanks.

greg k-h
