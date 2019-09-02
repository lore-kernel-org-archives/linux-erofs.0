Return-Path: <SRS0=r8Mz=W5=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 293CFC3A59E
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Sep 2019 12:53:44 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9DAE52168B
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Sep 2019 12:53:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ts1URB2b"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DAE52168B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46MVPx23s7zDqgN
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Sep 2019 22:53:41 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=none (mailfrom)
 smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:e::133;
 helo=bombadil.infradead.org;
 envelope-from=batv+8d7e6b8ef813b711cfc0+5853+infradead.org+hch@bombadil.srs.infradead.org;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=infradead.org header.i=@infradead.org
 header.b="Ts1URB2b"; dkim-atps=neutral
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46MVPk3shzzDq9B
 for <linux-erofs@lists.ozlabs.org>; Mon,  2 Sep 2019 22:53:30 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=7/PnToezagXqwbE0JThYjiZtwfyfOHMmdhe3eq0wzJQ=; b=Ts1URB2bALfk7/nZqBL5ACev6
 d6mytq+WkKmBdI1Wv08vqYRnZWfBrvhlqsGyKr5I4haxAzvi1W0/AiztPOWlODIwH8mprivMNHXAc
 /06Rn4wqK72ipJdREnrX+N2KdwFs0alrXDItr685VeLgZ3ZdyJyTHlhsH34pP3K2yCdVqH8DnTs/j
 vj3YiKH5xkSRPnqzeWZNfNKawQNVoLDPMLBBr5QpqV1hzO5AjsTVVWeY8JPW2d9Hgv32yOgh3txYF
 oA9lsn52rb0jx+KDpVn29SBne/zu8ILFVNgmCDcXXK3YpY12eWYPnQfPLQI15eG/7BOC75MyP0cRr
 CqX5qv0Kg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat
 Linux)) id 1i4lpg-0004bl-IN; Mon, 02 Sep 2019 12:53:20 +0000
Date: Mon, 2 Sep 2019 05:53:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Gao Xiang <hsiangkao@aol.com>
Subject: Re: [PATCH v6 05/24] erofs: add inode operations
Message-ID: <20190902125320.GA16726@infradead.org>
References: <20190802125347.166018-1-gaoxiang25@huawei.com>
 <20190802125347.166018-6-gaoxiang25@huawei.com>
 <20190829102426.GE20598@infradead.org>
 <20190901093326.GA6267@hsiangkao-HP-ZHAN-66-Pro-G1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190901093326.GA6267@hsiangkao-HP-ZHAN-66-Pro-G1>
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
Cc: devel@driverdev.osuosl.org, Stephen Rothwell <sfr@canb.auug.org.au>,
 linux-erofs@lists.ozlabs.org, Jan Kara <jack@suse.cz>,
 "Darrick J . Wong" <darrick.wong@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>,
 LKML <linux-kernel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>,
 Christoph Hellwig <hch@infradead.org>, Pavel Machek <pavel@denx.de>,
 David Sterba <dsterba@suse.cz>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jaegeuk Kim <jaegeuk@kernel.org>,
 linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Miao Xie <miaoxie@huawei.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Sun, Sep 01, 2019 at 05:34:00PM +0800, Gao Xiang wrote:
> > > +	return iget5_locked(sb, hashval, erofs_ilookup_test_actor,
> > > +		erofs_iget_set_actor, &nid);
> > > +#endif
> > 
> > Just use the slightly more complicated 32-bit version everywhere so that
> > you have a single actually tested code path.  And then remove this
> > helper.
> 
> As I said before, 64-bit platforms is common currently,
> I think iget_locked is enough.
> https://lore.kernel.org/r/20190830184606.GA175612@architecture4/

The problem with that is that you now have two entirely different
code paths.  And the 32-bit one will probably get very little testing
and eventually bitrot.  We defintively had problems of that sort in
XFS in the past, so my suggestion is to not go down the root of
separate code for 32-bit vs 64-bit unless it makes a real difference
for a real-life workload.
