Return-Path: <SRS0=VjDM=F3=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DBB3C433DB
	for <linux-erofs@archiver.kernel.org>; Wed, 23 Dec 2020 07:45:22 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0205B224B0
	for <linux-erofs@archiver.kernel.org>; Wed, 23 Dec 2020 07:45:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0205B224B0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4D14xW1KbDzDqSg
	for <linux-erofs@archiver.kernel.org>; Wed, 23 Dec 2020 18:45:19 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record)
 smtp.mailfrom=casper.srs.infradead.org (client-ip=2001:8b0:10b:1236::1;
 helo=casper.infradead.org;
 envelope-from=batv+6038cc82e5bfdcb9912f+6331+infradead.org+hch@casper.srs.infradead.org;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256
 header.s=casper.20170209 header.b=agC1u3To; 
 dkim-atps=neutral
Received: from casper.infradead.org (casper.infradead.org
 [IPv6:2001:8b0:10b:1236::1])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4D14xN3zP6zDqPG
 for <linux-erofs@lists.ozlabs.org>; Wed, 23 Dec 2020 18:45:05 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=E1YUsD2nj+OkFU/in0WWLJXY7M3YefssH3/+iMphZXw=; b=agC1u3ToQ1zPlTVVYpeaRxP5vk
 5VQh9UrNVdKzPrSdAJMTCR2PnwZ59WEO2jeslQ50DQ7IabBtlRl+IuaxE7TauU+pxYs6gHE2RcuIZ
 1U4DpaAS0sEgx2LK3ZdvN/GjVGyVEmq2zjlA+KTvq16MyqVuWNbe0y/uvzhVnz66Do5zk4Lg5THSc
 W6hjSVrigGcUdZiFxiL9CkKFmynHmLsdTTJitENrotxkuPR9x+lvLuu2uN8MIXVqs4g/2MnVK731X
 13kdLohOH7RpR7G3QHQGuZnupe00dUatAtpkBULPqCSPxZOmKdK2KLJhDtYgIJX8ThZqQMNI9Zlde
 YNzcDnHQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat
 Linux)) id 1krypL-0003sk-Vn; Wed, 23 Dec 2020 07:44:56 +0000
Date: Wed, 23 Dec 2020 07:44:55 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Gao Xiang <hsiangkao@redhat.com>
Subject: Re: [PATCH] erofs: support direct IO for uncompressed file
Message-ID: <20201223074455.GA14729@infradead.org>
References: <20201214140428.44944-1-huangjianan@oppo.com>
 <20201222142234.GB17056@infradead.org>
 <20201222193901.GA1892159@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201222193901.GA1892159@xiangao.remote.csb>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 casper.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: zhangshiming@oppo.com, linux-kernel@vger.kernel.org,
 Christoph Hellwig <hch@infradead.org>, guoweichao@oppo.com,
 linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Wed, Dec 23, 2020 at 03:39:01AM +0800, Gao Xiang wrote:
> Hi Christoph,
> 
> On Tue, Dec 22, 2020 at 02:22:34PM +0000, Christoph Hellwig wrote:
> > Please do not add new callers of __blockdev_direct_IO and use the modern
> > iomap variant instead.
> 
> We've talked about this topic before. The current status is that iomap
> doesn't support tail-packing inline data yet (Chao once sent out a version),
> and erofs only cares about read intrastructure for now (So we don't think
> more about how to deal with tail-packing inline write path). Plus, the
> original patch was once lack of inline data regression test from gfs2 folks.

So resend Chaos prep patch as part of the series switching parts of
erofs to iomap.  We need to move things off the old infrastructure instead
of adding more users and everyone needs to help a little.
