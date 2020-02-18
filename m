Return-Path: <SRS0=DvCx=4G=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECBBEC34026
	for <linux-erofs@archiver.kernel.org>; Tue, 18 Feb 2020 13:43:08 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9DF342173E
	for <linux-erofs@archiver.kernel.org>; Tue, 18 Feb 2020 13:43:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WiqMBzR3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DF342173E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from lists.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 48MMVw6HgXzDqjl
	for <linux-erofs@archiver.kernel.org>; Wed, 19 Feb 2020 00:43:04 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
 spf=none (no SPF record) smtp.mailfrom=infradead.org
 (client-ip=2607:7c80:54:e::133; helo=bombadil.infradead.org;
 envelope-from=willy@infradead.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=infradead.org header.i=@infradead.org
 header.a=rsa-sha256 header.s=bombadil.20170209 header.b=WiqMBzR3; 
 dkim-atps=neutral
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 48MMVQ2G35zDqc7
 for <linux-erofs@lists.ozlabs.org>; Wed, 19 Feb 2020 00:42:37 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
 :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
 Sender:Reply-To:Content-ID:Content-Description;
 bh=sRRfkuIro3UJgk7ronBRbu9Qpl4FSkPX98/JT02cIzQ=; b=WiqMBzR3mGIQcEq161KXuYNNqn
 oGEGsCAD1sh6ZxDHFnwWKQ2UwAbxLDKaVUSstZlvvZi3x4yIlHuLp2u6l7YrszKdgcpLhi972Q0/M
 v2lPX/oCVktUYRubwI/oT4ULqsPrfYeqx1ppvykbJky0SIGyrQDEEKC6qeiOAZIZLEEa8fGbwzymS
 SKIhK0eTvDnycS/K6GjH9DoFUk9lT4+Bh4Q7le4HVT8wkpD+696fuAoTeI+nAElAF/93gchu8m6kq
 3yyLRS2ZUp2AAlJpuu2kf3UYi/qoxOxEhYzdrtFmaDyvoJBUAzp1grGpHZPuH40DCWRoboP4begWK
 g4B3syeQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red
 Hat Linux)) id 1j438w-0002EE-C5; Tue, 18 Feb 2020 13:42:30 +0000
Date: Tue, 18 Feb 2020 05:42:30 -0800
From: Matthew Wilcox <willy@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6 00/19] Change readahead API
Message-ID: <20200218134230.GN7778@bombadil.infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
 <20200218045633.GH10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200218045633.GH10776@dread.disaster.area>
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
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
 linux-mm@kvack.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-btrfs@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Tue, Feb 18, 2020 at 03:56:33PM +1100, Dave Chinner wrote:
> Latest version in your git tree:
> 
> $ ▶ glo -n 5 willy/readahead
> 4be497096c04 mm: Use memalloc_nofs_save in readahead path
> ff63497fcb98 iomap: Convert from readpages to readahead
> 26aee60e89b5 iomap: Restructure iomap_readpages_actor
> 8115bcca7312 fuse: Convert from readpages to readahead
> 3db3d10d9ea1 f2fs: Convert from readpages to readahead
> $
> 
> merged into a 5.6-rc2 tree fails at boot on my test vm:
> 
> [    2.423116] ------------[ cut here ]------------
> [    2.424957] list_add double add: new=ffffea000efff4c8, prev=ffff8883bfffee60, next=ffffea000efff4c8.
> [    2.428259] WARNING: CPU: 4 PID: 1 at lib/list_debug.c:29 __list_add_valid+0x67/0x70
> [    2.457484] Call Trace:
> [    2.458171]  __pagevec_lru_add_fn+0x15f/0x2c0
> [    2.459376]  pagevec_lru_move_fn+0x87/0xd0
> [    2.460500]  ? pagevec_move_tail_fn+0x2d0/0x2d0
> [    2.461712]  lru_add_drain_cpu+0x8d/0x160
> [    2.462787]  lru_add_drain+0x18/0x20

Are you sure that was 4be497096c04 ?  I ask because there was a
version pushed to that git tree that did contain a list double-add
(due to a mismerge when shuffling patches).  I noticed it and fixed
it, and 4be497096c04 doesn't have that problem.  I also test with
CONFIG_DEBUG_LIST turned on, but this problem you hit is going to be
probabilistic because it'll depend on the timing between whatever other
list is being used and the page actually being added to the LRU.

