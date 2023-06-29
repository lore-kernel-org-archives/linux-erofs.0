Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88A7BEB64D9
	for <linux-erofs@archiver.kernel.org>; Thu, 29 Jun 2023 05:44:42 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=hIR4hN4B;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Qs6pc5LpFz3bNp
	for <linux-erofs@archiver.kernel.org>; Thu, 29 Jun 2023 15:44:40 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=hIR4hN4B;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+82df7db2dadf9b914934+7249+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Qs6pT62l0z30Px
	for <linux-erofs@lists.ozlabs.org>; Thu, 29 Jun 2023 15:44:32 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZH2LZio22mQexeVRx+H7ULNKh+Hfj2iXIK15cwYlRjg=; b=hIR4hN4B74sge6G08Zg+Qjk1rl
	ISOCFeylq83bOt3snrPFKtcEmAHmeq57aNIRevl11V5CG9cN5G/XN8YBGCXEP83isYLUD2qV2WANo
	amlrQRjGmkV4ldL/Fqa9U1yIjq2WzqAOlo3RbDOQNiKon1Z4Scqgwn57t4s05mxtfB2WJtCqRUpPx
	ZHfokhkLhi4p0z1GxvwIoL5GKrQIMCZ/LqSzrqQNx/8fLld2gkijRbVCoLt9dzym4n//fQ6IhQIho
	HJI/2Jn+Q9/wkpolyqxIV2DVhpJLbuyBG28eV1Qq8jhTp5+bqppW+d82eUZvxXOiMUUYAa5QAjexj
	HPq2bJ6A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qEkRt-0001dI-0L;
	Thu, 29 Jun 2023 05:44:09 +0000
Date: Wed, 28 Jun 2023 22:44:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yangtao Li <frank.li@vivo.com>
Subject: Re: [PATCH 1/7] block: add queue_logical_block_mask() and
 bdev_logical_block_mask()
Message-ID: <ZJ0aKU2w9xwS/vg1@infradead.org>
References: <20230628093500.68779-1-frank.li@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230628093500.68779-1-frank.li@vivo.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, brauner@kernel.org, linux-raid@vger.kernel.org, djwong@kernel.org, linux-kernel@vger.kernel.org, hch@infradead.org, song@kernel.org, huyue2@coolpad.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

What is the value add of this series?


