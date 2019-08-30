Return-Path: <SRS0=iJNB=W2=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2ACCC3A59B
	for <linux-erofs@archiver.kernel.org>; Fri, 30 Aug 2019 16:42:33 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 529C32087F
	for <linux-erofs@archiver.kernel.org>; Fri, 30 Aug 2019 16:42:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Nb5baDLH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 529C32087F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46KldL3LNzzDr34
	for <linux-erofs@archiver.kernel.org>; Sat, 31 Aug 2019 02:42:30 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=none (mailfrom)
 smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:e::133;
 helo=bombadil.infradead.org;
 envelope-from=batv+b0e6514120785512acaa+5850+infradead.org+hch@bombadil.srs.infradead.org;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=infradead.org header.i=@infradead.org
 header.b="Nb5baDLH"; dkim-atps=neutral
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46KldB1Z9jzDqQP
 for <linux-erofs@lists.ozlabs.org>; Sat, 31 Aug 2019 02:42:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=zT6Sffc7p6dXxr/DqLVZuPlm0esCLyE+d/3ikz+/jqI=; b=Nb5baDLHs6tOVMnZ2y1xUxHzs
 MhSwjOCDGxy8BvtXnOfjEW35qlNWyTbB5J8UoRl4zzLn+YSkRG+J46vsn972X8NpB8I7gKz1i1ZcD
 Bi2JWKJq4ZUANCc0oWI11+X0jE7gzpS3IFc1UfQGoD9Mk+ov4ZRJqRweV6Ek2FRGvomWDP7hd3ryu
 oaPu2QpDsqEh4GwblDsXtaPgKEHbndclLqmmnGyF5+5JhqE/2wMWTx6zkz1YCrd3bEALL5KVNQKUQ
 WpHREdtO/JtxBC5fHQ2repjFQJhEBNYaFxOJln6YisDqgjlMrFlhxRGO4FqgfssIOHIyKIy5OFC+0
 f9lySr1Cg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat
 Linux)) id 1i3jyP-0002rX-Ku; Fri, 30 Aug 2019 16:42:05 +0000
Date: Fri, 30 Aug 2019 09:42:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Gao Xiang <gaoxiang25@huawei.com>
Subject: Re: [PATCH v6 05/24] erofs: add inode operations
Message-ID: <20190830164205.GD29603@infradead.org>
References: <20190802125347.166018-1-gaoxiang25@huawei.com>
 <20190802125347.166018-6-gaoxiang25@huawei.com>
 <20190829102426.GE20598@infradead.org>
 <20190829115922.GG64893@architecture4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829115922.GG64893@architecture4>
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
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
 LKML <linux-kernel@vger.kernel.org>, Miao Xie <miaoxie@huawei.com>,
 devel@driverdev.osuosl.org, Stephen Rothwell <sfr@canb.auug.org.au>,
 "Darrick J . Wong" <darrick.wong@oracle.com>,
 Christoph Hellwig <hch@infradead.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Amir Goldstein <amir73il@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 David Sterba <dsterba@suse.cz>, Pavel Machek <pavel@denx.de>,
 linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Thu, Aug 29, 2019 at 07:59:22PM +0800, Gao Xiang wrote:
> On Thu, Aug 29, 2019 at 03:24:26AM -0700, Christoph Hellwig wrote:
> 
> []
> 
> > 
> > > +
> > > +		/* fill last page if inline data is available */
> > > +		err = fill_inline_data(inode, data, ofs);
> > 
> > Well, I think you should move the is_inode_flat_inline and
> > (S_ISLNK(inode->i_mode) && inode->i_size < PAGE_SIZE) checks from that
> > helper here, as otherwise you make everyone wonder why you'd always
> > fill out the inline data.
> 
> Currently, fill_inline_data() only fills for fast symlink,
> later we can fill any tail-end block (such as dir block)
> for our requirements.

So change it when that later changes actually come in.  And even then
having the checks outside the function is a lot more obvious.

> And I think that is minor.

The problem is that each of these issues might appear minor on their
own.  But combined a lot of the coding style choices lead to code that
is more suitable an obsfucated code contest than the Linux kernel as
trying to understand even just a few places requires jumping through
tons of helpers with misleading names and spread over various files.

> The consideration is simply because iget_locked performs better
> than iget5_locked.

In what benchmark do the differences show up?
