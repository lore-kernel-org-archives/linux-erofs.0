Return-Path: <SRS0=PAtq=4O=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA8A4C4BA09
	for <linux-erofs@archiver.kernel.org>; Wed, 26 Feb 2020 02:35:11 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7F419222C2
	for <linux-erofs@archiver.kernel.org>; Wed, 26 Feb 2020 02:35:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="E41DcHsi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F419222C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from lists.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 48S0JY4WkPzDqRr
	for <linux-erofs@archiver.kernel.org>; Wed, 26 Feb 2020 13:35:09 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=ebiggers@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=default header.b=E41DcHsi; dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 48S0JQ6KGwzDqF7
 for <linux-erofs@lists.ozlabs.org>; Wed, 26 Feb 2020 13:35:02 +1100 (AEDT)
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net
 [107.3.166.239])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 7D7A821D7E;
 Wed, 26 Feb 2020 02:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1582684499;
 bh=JhCEVeDFXJdMR838T0u81Xg3kHk4An75sj2PC5EQ3ww=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=E41DcHsi9w5s7qSvhMdEnFgIzPi3Zn0cxXHpbHfP9ELT5QIPpCZ2gLypzAofsZv0n
 kzOqBw8cegdWtVFwiPLJAcujP/8Lzyx+L2cH7duIIQbC7MeDcLgKE5/8reP6uf5zd+
 eM3rP+3meboTEqOeCCjP7gfCJl3mIrhdz25qUZrI=
Date: Tue, 25 Feb 2020 18:34:58 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Gao Xiang <gaoxiang25@huawei.com>
Subject: Re: [PATCH 3/3] erofs: handle corrupted images whose decompressed
 size less than it'd be
Message-ID: <20200226023458.GB1053@sol.localdomain>
References: <20200226023011.103798-1-gaoxiang25@huawei.com>
 <20200226023011.103798-3-gaoxiang25@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226023011.103798-3-gaoxiang25@huawei.com>
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
Cc: Miao Xie <miaoxie@huawei.com>, linux-erofs@lists.ozlabs.org,
 LKML <linux-kernel@vger.kernel.org>, Lasse Collin <lasse.collin@tukaani.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Wed, Feb 26, 2020 at 10:30:11AM +0800, Gao Xiang wrote:
> As Lasse pointed out, "Looking at fs/erofs/decompress.c,
> the return value from LZ4_decompress_safe_partial is only
> checked for negative value to catch errors. ... So if
> I understood it correctly, if there is bad data whose
> uncompressed size is much less than it should be, it can
> leave part of the output buffer untouched and expose the
> previous data as the file content. "
> 
> Let's fix it now.
> 
> Cc: Lasse Collin <lasse.collin@tukaani.org>
> Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>

Shouldn't fixes like this have a Fixes tag and Cc stable?

- Eric
