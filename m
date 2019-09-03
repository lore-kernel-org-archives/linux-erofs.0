Return-Path: <SRS0=BgsZ=W6=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B37C3A5A2
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Sep 2019 15:37:24 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7118622D6D
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Sep 2019 15:37:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iPZa9nn0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7118622D6D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46NB0K029NzDqjk
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Sep 2019 01:37:21 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=none (mailfrom)
 smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:e::133;
 helo=bombadil.infradead.org;
 envelope-from=batv+680e2818d6643897e706+5854+infradead.org+hch@bombadil.srs.infradead.org;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=infradead.org header.i=@infradead.org
 header.b="iPZa9nn0"; dkim-atps=neutral
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46NB0B3RMlzDqf4
 for <linux-erofs@lists.ozlabs.org>; Wed,  4 Sep 2019 01:37:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=TOMcH7snttb2Sr7cqyYUxOSzNPnn0zJCorjl1PxxkD8=; b=iPZa9nn0+EclNXulN9PX55CfF
 gjiZ/RcbonRlNHqkBzmGEe6Ioj+rAZKWUTmZvc8doirxhztv7FprjyzD7VGiWIB7qATK55E7i7a1x
 TmDqOuFRVBJbmG60tr0ElwbLZ46pwJskgV7Cz8NNRFQitmpy5Nz/lO1P2FXCuvPwzYgXor8S0FMf6
 LAmnu/Qk8ARcx6Ev1/WBOUwEB1FDGT6iVSDqwPmo763jvjWRJqLnfmylBY0Mx+wmdggFpEJOWd14L
 UHDHQLEhg+ERlFoN1IzFKJI+sahK6t1WEtjnYNVxM2f8AqkTLjGHcU8IooYs/dyfk3rjjLyTwS9xf
 nr5m+CE5w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat
 Linux)) id 1i5Arg-0000dg-Ql; Tue, 03 Sep 2019 15:37:04 +0000
Date: Tue, 3 Sep 2019 08:37:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Gao Xiang <gaoxiang25@huawei.com>
Subject: Re: [PATCH 00/21] erofs: patchset addressing Christoph's comments
Message-ID: <20190903153704.GA2201@infradead.org>
References: <20190802125347.166018-1-gaoxiang25@huawei.com>
 <20190901055130.30572-1-hsiangkao@aol.com>
 <20190902124645.GA8369@infradead.org>
 <20190902142452.GE2664@architecture4>
 <20190902152323.GB14009@infradead.org>
 <20190902155037.GD179615@architecture4>
 <20190903065803.GA11205@infradead.org>
 <20190903081749.GA89379@architecture4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903081749.GA89379@architecture4>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Tue, Sep 03, 2019 at 04:17:49PM +0800, Gao Xiang wrote:
> I implement a prelimitary version, but I have no idea it is a really
> cleanup for now.

The fact that this has to guess the block device address_space
implementation is indeed pretty ugly.  I'd much prefer to just use
read_cache_page_gfp, and live with the fact that this allocates
bufferheads behind you for now.  I'll try to speed up my attempts to
get rid of the buffer heads on the block device mapping instead.
