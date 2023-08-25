Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ED15C3DA6F
	for <linux-erofs@archiver.kernel.org>; Fri, 25 Aug 2023 12:28:02 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=r7Zyoejk;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4RXK3h2mPKz2ypy
	for <linux-erofs@archiver.kernel.org>; Fri, 25 Aug 2023 22:28:00 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=r7Zyoejk;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2604:1380:4641:c500::1; helo=dfw.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4RXK3X6CBVz2yVQ
	for <linux-erofs@lists.ozlabs.org>; Fri, 25 Aug 2023 22:27:52 +1000 (AEST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 8A12F61FFB;
	Fri, 25 Aug 2023 12:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7141C433CB;
	Fri, 25 Aug 2023 12:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692966467;
	bh=X1sEmR7Wgo9iEx4Nm5FGEwpQOX2GMPaKb2K7hO0NWmI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r7Zyoejkzwbp96OecrluACIPS19q3kRmBAIAhMXW9X6N3gDcuzK6W06bnJV8X00W+
	 QQ2W0j+IHgi/b1O77QFPRD+Ho5mMoO+d/qLdM/tjCxsVEKAYnsSYDun3s0Hl7GlRaT
	 4Fp1xxh1rwlfzvw1sYMR67VlStTY0jb4pIfAfLqWpo2bxKCs1Vxo9cBUSLQ0p6Z7BF
	 EVYZrab9lBcUKigXaRDTDDw8XHAO0PtZW71bg0dmdRnj6622bz2LRZWLKbL7GGusXm
	 rG8dAVbMdX7UbX4Jo9+Sogv6S+7eiP59Av2Y6LgP8mlVijqREN9oIqOtpZjb6h6ar5
	 X/d0w/NZgZ9rg==
Date: Fri, 25 Aug 2023 14:27:41 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 21/29] erofs: Convert to use bdev_open_by_path()
Message-ID: <20230825-tosend-geldforderungen-6b4c43bcdcfe@brauner>
References: <20230818123232.2269-1-jack@suse.cz>
 <20230823104857.11437-21-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230823104857.11437-21-jack@suse.cz>
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org, Christoph Hellwig <hch@lst.de>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Wed, Aug 23, 2023 at 12:48:32PM +0200, Jan Kara wrote:
> Convert erofs to use bdev_open_by_path() and pass the handle around.
> 
> CC: Gao Xiang <xiang@kernel.org>
> CC: Chao Yu <chao@kernel.org>
> CC: linux-erofs@lists.ozlabs.org
> Acked-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>
