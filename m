Return-Path: <SRS0=egKJ=5E=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACFBAC4332B
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Mar 2020 12:19:01 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 606C620663
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Mar 2020 12:19:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="taEbISgv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 606C620663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from lists.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 48jmD31lfgzDrHl
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Mar 2020 23:18:59 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
 spf=none (no SPF record) smtp.mailfrom=infradead.org
 (client-ip=2607:7c80:54:e::133; helo=bombadil.infradead.org;
 envelope-from=willy@infradead.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=infradead.org header.i=@infradead.org
 header.a=rsa-sha256 header.s=bombadil.20170209 header.b=taEbISgv; 
 dkim-atps=neutral
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 48jlkv3R4KzDrFC
 for <linux-erofs@lists.ozlabs.org>; Thu, 19 Mar 2020 22:57:11 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=zSKNJpg3bSHQZrR6eSGgkELs7AnAMsGUFTR84vG8N+Q=; b=taEbISgvSjSBP5vFWW8bUzGpnP
 MKArSkuRIrMUVzeknqF5IG82BQ0rRpdBkhyPwGJUstzncqnKATxyqnIPY7+1YlPamettzIY62SIOe
 NjePxFuSuYvIN1CyExl08KgCgVOKlBp6PwGzsLBofMZTKcaPyXK6XFyVMrgf7MonLR3osphoWenlX
 sundTKrs1nNxBZQfX9U36K6/ARMpgehcUsyKFiio1oi1/7QqJNa7OAtqjBW7hTx52h5XWExEECCbA
 ybmTAPaH80ciWSV+Cg1RcHvxXwu291GiNoqQjE6jJmuU2a2XkiCwZXJKbC6saBE1jZ5T2EQuOpNT9
 kqks7pWQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red
 Hat Linux)) id 1jEtnJ-0000ue-IU; Thu, 19 Mar 2020 11:57:01 +0000
Date: Thu, 19 Mar 2020 04:57:01 -0700
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v8 00/25] Change readahead API
Message-ID: <20200319115701.GJ22433@bombadil.infradead.org>
References: <20200225214838.30017-1-willy@infradead.org>
 <20200319102038.GE3590@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319102038.GE3590@infradead.org>
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

On Thu, Mar 19, 2020 at 03:20:38AM -0700, Christoph Hellwig wrote:
> Any plans to resend this with the little nitpicks fixed?  I'd love to
> get this series into 5.7..

The only nitpick I see left is the commit comment in the btrfs patch,
and a note from Dave Sterba that he intends to review it.  I can collect
up the additional Reviewed-by tags and repost the series.

I'm assuming it'll go through Andrew's tree?
