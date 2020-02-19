Return-Path: <SRS0=ChUK=4H=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB266C3404D
	for <linux-erofs@archiver.kernel.org>; Wed, 19 Feb 2020 05:22:50 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8BAA224656
	for <linux-erofs@archiver.kernel.org>; Wed, 19 Feb 2020 05:22:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Auyp6lhS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8BAA224656
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from lists.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 48MmMD6LfvzDqZk
	for <linux-erofs@archiver.kernel.org>; Wed, 19 Feb 2020 16:22:48 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
 spf=none (no SPF record) smtp.mailfrom=infradead.org
 (client-ip=2607:7c80:54:e::133; helo=bombadil.infradead.org;
 envelope-from=willy@infradead.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=infradead.org
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 48MmM107GQzDqWJ
 for <linux-erofs@lists.ozlabs.org>; Wed, 19 Feb 2020 16:22:36 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=v3wjYvTxIvyqdBjcTZbZ6V6XXTZeeNXrItglyOMcggo=; b=Auyp6lhSbAEYNk7jcncbMkY0Ws
 XinG1c/KH2WIappKRapF9o4axpn9L8oQskBlHlBLw9XQ0nXbJnkDsqfh2SkyzmQK0YhzpKp/QBFO0
 bpEGyHFQ+YA3qxJU00WEU/tiwjkGuEnVYcW0g3zXVubgFDKWaDvoJvN6VkjVPrCo/uQ+QP9jf8QO3
 9qiXCqAzx7Awla3qaJlBefBlwM8EQeYBIUB12k8qt69YC/AIm0vwjb3K/41acVQTK6Lg81YYNgtrt
 gWZkFfEHpJDHCeifbBhNb09jKli8nY0l/0Vau09mO9a0Cb/TiGxAZcwsAaM0Zi6C3GyPPjl+GKcMg
 Evj5uHjQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red
 Hat Linux)) id 1j4Hoc-0008Pr-3p; Wed, 19 Feb 2020 05:22:30 +0000
Date: Tue, 18 Feb 2020 21:22:30 -0800
From: Matthew Wilcox <willy@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6 19/19] mm: Use memalloc_nofs_save in readahead path
Message-ID: <20200219052230.GM24185@bombadil.infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
 <20200217184613.19668-33-willy@infradead.org>
 <20200219034324.GG10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219034324.GG10776@dread.disaster.area>
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
Cc: linux-xfs@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 cluster-devel@redhat.com, linux-mm@kvack.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
 linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-btrfs@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Wed, Feb 19, 2020 at 02:43:24PM +1100, Dave Chinner wrote:
> On Mon, Feb 17, 2020 at 10:46:13AM -0800, Matthew Wilcox wrote:
> > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > 
> > Ensure that memory allocations in the readahead path do not attempt to
> > reclaim file-backed pages, which could lead to a deadlock.  It is
> > possible, though unlikely this is the root cause of a problem observed
> > by Cong Wang.
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
> > Suggested-by: Michal Hocko <mhocko@suse.com>
> > ---
> >  mm/readahead.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/mm/readahead.c b/mm/readahead.c
> > index 94d499cfb657..8f9c0dba24e7 100644
> > --- a/mm/readahead.c
> > +++ b/mm/readahead.c
> > @@ -22,6 +22,7 @@
> >  #include <linux/mm_inline.h>
> >  #include <linux/blk-cgroup.h>
> >  #include <linux/fadvise.h>
> > +#include <linux/sched/mm.h>
> >  
> >  #include "internal.h"
> >  
> > @@ -174,6 +175,18 @@ void page_cache_readahead_limit(struct address_space *mapping,
> >  		._nr_pages = 0,
> >  	};
> >  
> > +	/*
> > +	 * Partway through the readahead operation, we will have added
> > +	 * locked pages to the page cache, but will not yet have submitted
> > +	 * them for I/O.  Adding another page may need to allocate memory,
> > +	 * which can trigger memory reclaim.  Telling the VM we're in
> > +	 * the middle of a filesystem operation will cause it to not
> > +	 * touch file-backed pages, preventing a deadlock.  Most (all?)
> > +	 * filesystems already specify __GFP_NOFS in their mapping's
> > +	 * gfp_mask, but let's be explicit here.
> > +	 */
> > +	unsigned int nofs = memalloc_nofs_save();
> > +
> 
> So doesn't this largely remove the need for all the gfp flag futzing
> in the readahead path? i.e. almost all readahead allocations are now
> going to be GFP_NOFS | GFP_NORETRY | GFP_NOWARN ?

I don't think it ensures the GFP_NORETRY | GFP_NOWARN, just the GFP_NOFS
part.  IOW, we'll still need a readahead_gfp() macro at some point ... I
don't want to add that to this already large series though.

Michal also wants to kill mapping->gfp_mask, btw.
