Return-Path: <SRS0=lyQx=L5=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB0BC07E99
	for <linux-erofs@archiver.kernel.org>; Mon,  5 Jul 2021 22:49:19 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7925461978
	for <linux-erofs@archiver.kernel.org>; Mon,  5 Jul 2021 22:49:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7925461978
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GJgq10TB4z2yjB
	for <linux-erofs@archiver.kernel.org>; Tue,  6 Jul 2021 08:49:17 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=Lw3wt+d7;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=xiang@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=Lw3wt+d7; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GJgpx1KWZz2yX8
 for <linux-erofs@lists.ozlabs.org>; Tue,  6 Jul 2021 08:49:13 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECCBB6186A;
 Mon,  5 Jul 2021 22:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1625525349;
 bh=mkfPMjkHVZE0n14BdJf3P80AOd+hrM+UUpZI+nANjwc=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Lw3wt+d7NhPeCSzYclWsItQ6S7mi3EaCuEacBxCewmMfWc7MsoTUbQXJudjA8tVDb
 GtzHGzyFiUgTUq7MqJjYbWYPgL66aDXAtCgQLpX4EdU/JuwghySeMQyG2baEHOPrWz
 ncj7fvfhl5mBd/DDMDdhbbw0K54qHEY+1VbFmojQpnJriIQl8NTBVM4qJqxca+TJg6
 NXTqorK8W6ICOZQdbDjXGiZajpy2XH8jEy5qnF32se9Y9HnlZFJaD0R7ZuTQLctK3y
 55l0Ts5j+/Z5uiobJvrHZ821RCEacu+xBLHRcgnGcoIov8W70hTFy2AKhubt3fDNHV
 FESEO8VY3n09w==
Date: Tue, 6 Jul 2021 06:48:39 +0800
From: Gao Xiang <xiang@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 2/2] erofs: directly traverse pages in
 z_erofs_readahead()
Message-ID: <20210705224822.GA17518@hsiangkao-HP-ZHAN-66-Pro-G1>
Mail-Followup-To: Matthew Wilcox <willy@infradead.org>,
 linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>
References: <20210705183253.14833-1-xiang@kernel.org>
 <20210705183253.14833-2-xiang@kernel.org>
 <YONoXm1ksYgWWi/r@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YONoXm1ksYgWWi/r@casper.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
Cc: linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Matthew,

On Mon, Jul 05, 2021 at 09:15:26PM +0100, Matthew Wilcox wrote:
> On Tue, Jul 06, 2021 at 02:32:53AM +0800, Gao Xiang wrote:
> > In that way, pages can be accessed directly with xarray.
> 
> I didn't mean "open code readahead_page()".  I meant "Wouldn't it be
> great if z_erofs_do_read_page() used readahead_expand() in order to
> allocate the extra pages in the extents that cover the start and end of
> the requested chunk".  That way the pages would already be in the page
> cache for subsequent reads.

Yes, I understand that idea. readahead_expand() can be used to
cache the whole requested decompressed chunk. Currently, EROFS tends
to cache compressed data for incomplete requested chunks instead in the
managed inode if cache mode is enabled since LZ4 compressed data is
more effective for caching to save I/O than uncompressed data
(considering LZ4 decompression speed, which is somewhat like zcache.)

For now, EROFS LZMA support is also on the way (but recently I
have to work on the DAX support in advance.) LZMA is somewhat slow
algorithm but with much better compression ratio. I think it should
decompress all requested chunks to save the overall decompression
time. So readahead_expand() is quite useful with EROFS LZMA cases,
I will investigate it for LZMA-specific cases...

BTW, from the patch [2/2] itself, it there some chance to extend
readahead_page() or some new API like this? So the original dance
can be avoided.

Some comments for the iteration behavior itself is always useful,
anyway...

Thanks,
Gao Xiang

> 
