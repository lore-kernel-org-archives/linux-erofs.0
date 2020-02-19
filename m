Return-Path: <SRS0=ChUK=4H=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BC25C34022
	for <linux-erofs@archiver.kernel.org>; Wed, 19 Feb 2020 03:48:01 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F366920801
	for <linux-erofs@archiver.kernel.org>; Wed, 19 Feb 2020 03:48:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sMeTw1fz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F366920801
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from lists.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 48MkFq2xY7zDqjg
	for <linux-erofs@archiver.kernel.org>; Wed, 19 Feb 2020 14:47:59 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
 spf=none (no SPF record) smtp.mailfrom=infradead.org
 (client-ip=2607:7c80:54:e::133; helo=bombadil.infradead.org;
 envelope-from=willy@infradead.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=infradead.org header.i=@infradead.org
 header.a=rsa-sha256 header.s=bombadil.20170209 header.b=sMeTw1fz; 
 dkim-atps=neutral
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 48MkFj4dCwzDqbq
 for <linux-erofs@lists.ozlabs.org>; Wed, 19 Feb 2020 14:47:53 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=i/xcm0BfIZoUOgtJ9Kb7+ENMgRO8MVFTO+YgYUUmnnU=; b=sMeTw1fz0AtXWv4h5McRaI0hCC
 OIeMYm4j5TaxU6/S+PNsormwo6Bir4wd3qqGXl+GGGR9ekz3hzBXljkYHgg49p+g8cXAmtP2rs6k3
 69dcsD1yVpFMMZPVBgJM2M6dUtwSbV8XzDOOXM1+rQ8x8Tgn7iTWBfWCzxF5LPjzKG8tHjIZgCd5o
 o+iDKzs+iuYHb0nWK7CgfwUKvGVxa1DpfmuaYH6dzHmEMJGYSROvOuIy/F02GpS2f4BnOSoK7htCK
 dj9wRqSeArzQt/ea/tpsDBkyItAgPHmM8u//+U1zx2sHOilh75WFAwV2VrYfOZ/IlTmzStwZqicCC
 ZgaRjdug==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red
 Hat Linux)) id 1j4GKs-0001V5-0u; Wed, 19 Feb 2020 03:47:42 +0000
Date: Tue, 18 Feb 2020 19:47:41 -0800
From: Matthew Wilcox <willy@infradead.org>
To: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v6 10/19] fs: Convert mpage_readpages to mpage_readahead
Message-ID: <20200219034741.GK24185@bombadil.infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
 <20200217184613.19668-18-willy@infradead.org>
 <20200219032826.GB1075@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219032826.GB1075@sol.localdomain>
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
Cc: cluster-devel@redhat.com, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Junxiao Bi <junxiao.bi@oracle.com>,
 linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Tue, Feb 18, 2020 at 07:28:26PM -0800, Eric Biggers wrote:
> On Mon, Feb 17, 2020 at 10:45:58AM -0800, Matthew Wilcox wrote:
> > diff --git a/include/linux/mpage.h b/include/linux/mpage.h
> > index 001f1fcf9836..f4f5e90a6844 100644
> > --- a/include/linux/mpage.h
> > +++ b/include/linux/mpage.h
> > @@ -13,9 +13,9 @@
> >  #ifdef CONFIG_BLOCK
> >  
> >  struct writeback_control;
> > +struct readahead_control;
> >  
> > -int mpage_readpages(struct address_space *mapping, struct list_head *pages,
> > -				unsigned nr_pages, get_block_t get_block);
> > +void mpage_readahead(struct readahead_control *, get_block_t get_block);
> >  int mpage_readpage(struct page *page, get_block_t get_block);
> >  int mpage_writepages(struct address_space *mapping,
> >  		struct writeback_control *wbc, get_block_t get_block);
> 
> Can you name the 'struct readahead_control *' parameter?

What good would that do?  I'm sick of seeing 'struct page *page'.
Well, no shit it's a page.  Unless there's some actual information to
convey, leave the argument unnamed.  It should be a crime to not name
an unsigned long, but not naming the struct address_space pointer is
entirely reasonable.
