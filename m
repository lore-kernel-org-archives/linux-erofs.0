Return-Path: <SRS0=EiX3=5F=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6A91C4332E
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Mar 2020 17:37:48 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5FDE620773
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Mar 2020 17:37:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="avAm79Pa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FDE620773
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from lists.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 48kWFP27TfzF0Q7
	for <linux-erofs@archiver.kernel.org>; Sat, 21 Mar 2020 04:37:45 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=ebiggers@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=default header.b=avAm79Pa; dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 48kWFH1tfzzDvrG
 for <linux-erofs@lists.ozlabs.org>; Sat, 21 Mar 2020 04:37:38 +1100 (AEDT)
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net
 [107.3.166.239])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4B72C20722;
 Fri, 20 Mar 2020 17:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1584725856;
 bh=G2+3MpD3WslFGLdp5NjeBbtVtx2oUkFUbLAe3FrGwo4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=avAm79PauNq7Mi8lepE1M+q8L6UcKnW/aDKz8d+iWcwGM0xSpN0CPodVkw5n7hjxI
 bmniaSQH/oDhJBhhL3LaO1e96w9j3KKiHwDmuCEMBhf2iB3BNRVYn0F6PNaJNIKpU0
 QA85GNq47i8AcHSpCY4OouI56lflivWj/ICnBfM4=
Date: Fri, 20 Mar 2020 10:37:34 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v9 20/25] ext4: Convert from readpages to readahead
Message-ID: <20200320173734.GD851@sol.localdomain>
References: <20200320142231.2402-1-willy@infradead.org>
 <20200320142231.2402-21-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320142231.2402-21-willy@infradead.org>
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
Cc: cluster-devel@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 William Kucharski <william.kucharski@oracle.com>, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 ocfs2-devel@oss.oracle.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Fri, Mar 20, 2020 at 07:22:26AM -0700, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Use the new readahead operation in ext4
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: William Kucharski <william.kucharski@oracle.com>
> ---
>  fs/ext4/ext4.h     |  3 +--
>  fs/ext4/inode.c    | 21 +++++++++------------
>  fs/ext4/readpage.c | 22 ++++++++--------------
>  3 files changed, 18 insertions(+), 28 deletions(-)
> 

Reviewed-by: Eric Biggers <ebiggers@google.com>

> +		if (rac) {
> +			page = readahead_page(rac);
>  			prefetchw(&page->flags);
> -			list_del(&page->lru);
> -			if (add_to_page_cache_lru(page, mapping, page->index,
> -				  readahead_gfp_mask(mapping)))
> -				goto next_page;
>  		}

Maybe the prefetchw(&page->flags) should be included in readahead_page()?
Most of the callers do it.

- Eric
