Return-Path: <linux-erofs+bounces-4345-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D540C61DBD
	for <linux-erofs@archiver.kernel.org>; Wed, 26 Aug 2026 06:12:17 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hVDnp6cVSz2y32;
	Wed, 26 Aug 2026 16:12:14 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787724734;
	cv=none; b=ZdKNqBmRlZNKdWdfQMS9SG3WZomkirVY24HoB7jzXJbOmzmTf7xFOR/gY/uQp1VTheK+xBSydOfF0K6NpKdpoBhqGynw8e4CGYTwbqrij5s2M6uqrCTtmQKGYZ2qzIEVUqAnJPoYqgtetvRw5E22azr661KacmdDDNDuilvfGjgqhBsiMSNuzXkV5+wdYwy2qujbNHOipGH2T58c9NMnAcWDHaZuD822HeyIRct1WCEbAIIxUZ4mWAo1MJYm2pIiAKyX6ZN/3oDIIqelD0xL/V1Bx8eh0Aa/9qISDL3M0bW+kmz3CuBQZc+ha7cE0nvlxnWMTzGcHLHYdBBGPEL2hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787724734; c=relaxed/relaxed;
	bh=wOXH9hORSWj/yUkhv682PeI+oAkc2FTnLriQfuLGgF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LR5C6LA0yH7laYCCzyZVze2Hzb6nN6Sn067JD0HABpTen81FZSFnxV2J2KCdaFLt/0qRgedM6tLam+oeKtpQxRD63z6rWAwmnQsUIfObp9wFltmzdJa6GohoTm/7Hoh7QKf0u3j7a5+j8hPNj2wfKL8TawyEvhp9THDDV0vdLWec7lQXayfb9h8DiBos7v1L0nyHBYfeJ74l5fMhViDWM7A3UUzPSbLXWvT5PuTxFLJduG0JVLCGojejMLhA9GXXd/YUbBqYU3kO3VLskIZkbTPJ+ytcu+P8XGpnUDqILfXyzjPYzQib+CX+P7AUAacq+MFEkNqR5llP//xetABlBw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IyzB0WfR; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IyzB0WfR;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hVDnn6wmhz2xLq
	for <linux-erofs@lists.ozlabs.org>; Wed, 26 Aug 2026 16:12:13 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C512660A5B;
	Wed, 26 Aug 2026 06:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D91C1F000E9;
	Wed, 26 Aug 2026 06:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787724730;
	bh=wOXH9hORSWj/yUkhv682PeI+oAkc2FTnLriQfuLGgF4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IyzB0WfR7qLAdReauYSafBClrKz8zlltbJD9kX/1D1ku8AdguWAbT8o8M9N02yrCA
	 lxDrvB59EL7+UHqrtVnomcfn7iDv7bGSLt3OsQSYcjwtNVM+LUWIO7vZs2hgxg6Xgz
	 NkTu4ID2g1UmMSJNwO48gJz7HnWQKisYTpNQLIxmC/OWdSUjan0eGQd0uRKSMY4RR7
	 aNLMoeYFxgEB0CL4CYT7tUGjNqClJqq+RBxmr3xfZ+fp88nE7frNQui/V4bUyjpkRX
	 3fGjL5DPCxBNmcwRSpn7IeLJe6+tbr3HkB/bwDCmP0CNs+AzMSIP0lD7Dj7mOm/HcE
	 aaI/50YzpjyAA==
Date: Wed, 26 Aug 2026 14:12:02 +0800
From: Gao Xiang <xiang@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org,
	LKML <linux-kernel@vger.kernel.org>, Chao Yu <chao@kernel.org>
Subject: Re: [PATCH v2] erofs: use dedicated meta inodes for file-backed
 mounts
Message-ID: <ao6DsnQPafVNCXGl@192.168.5.19>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org,
	LKML <linux-kernel@vger.kernel.org>, Chao Yu <chao@kernel.org>
References: <20260811080852.29418-1-xiang@kernel.org>
 <20260811090717.29787-1-xiang@kernel.org>
 <aoVFY0jyMGpcu1NX@infradead.org>
 <aocD3jkUnsPlrllM@XiangdeMacBook-Pro.local>
 <ao5vE3v-n570dvXL@infradead.org>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ao5vE3v-n570dvXL@infradead.org>

Hi Christoph,

On Tue, Aug 25, 2026 at 09:44:03PM -0700, Christoph Hellwig wrote:
> On Thu, Aug 20, 2026 at 09:40:46PM +0800, Gao Xiang wrote:
> > Hi Christoph,
> > 
> > On Tue, Aug 18, 2026 at 10:55:47PM -0700, Christoph Hellwig wrote:
> > > On Tue, Aug 11, 2026 at 05:07:17PM +0800, Gao Xiang wrote:
> > > > access on file-backed mounts (although I still don't think it is
> > > > necessary due to the EROFS immutable model). As the result, metadata
> > > > cache won't use the page cache of backing inodes anymore.
> > > > 
> > > > The "managed cache" was originally used to cache physical compressed
> > > > data according to the current cache strategy and I/O patterns; since
> > > > file-backed mounts also need to access physical data for metadata
> > > > access, it's natural to reuse the managed cache for this too, providing
> > > > a unique inode for all physical data access.
> > > 
> > > This look sane.  Any reason to not use the meta inode unconditionally
> > > to simplify the code?
> > 
> > I guess you meant avoid using bd_inode page cache?
> 
> 
> Yes.
> 
> > I'm not sure if it simplifies a lot, also like fadvise(WILLNEED) to blkdev
> > can perform to bd_inode too so I think it can still have some benefits.
> 
> This is actually an artefact of why using the bdev page cache is a bad
> idea, because it opens your metadata cache up to external modification
> and side channel attacks.

See my reply to Christian before:
https://lore.kernel.org/r/95a5fc3a-4259-44a7-bb72-8ff35a49a26f@linux.alibaba.com

EROFS is unlike generic writable filesystems which need to consider
writing to the disk and keep various cache (extent cache, ...) and
complex metadata relationship.

EROFS itself is only designed for archive use cases (like tar/zip),
and it never changes its data and metadata itself at runtime, and it
intentionally only uses the physical view as the unique metadata
cache (never duplicate a different form of in-memory metadata
cache) by design.  For unexpected external modification, it generally
behaves undefined (nevertheless, the physical device can be modified
in various ways).  In short, our implementation is always designed
to harden and tolerate this so it won't cause severe in-memory <->
on-disk or on-disk <-> on-disk inconsistency.

You could doubt that, but here I claim again that one of EROFS main
ondisk/runtime design goals (which is very unlike to other generic
filesystems, and that is one of EROFS's main value), for human-made
random implementation bugs, we will fix them all after reported since
the implementation bug cannot be totally avoidable from an engineering
perspective (unless the implementation is totally auto code generated.)

For side channel attack, the Linux page cache model is always vulnerable
to that, and I really think it's a trade-off (for shared kernel
apporaches, cache side channel attack is unavoidable and no need to
avoid; if you need a strongest protection, you should use isolated kernels
or seperate VM instead.)

We could switch to use per-fs metadata cache, but in that way, we have to
develop a new way to warm up the cache instead, I guess in that way it
will be much like switched into an EROFS-specific ioctl interface instead
since fadvise no longer works.

> 
> > I think bd_inode page cache can be used for filesystems so maybe leave it
> > as-is for now, or maybe a follow-up work if it's really needed.
> 
> That's how it has historically been done.  We generally try to avoid
> it for newer designs.

TR;DR: I will switch later when I find another slot, but it should just
based on a fact is that bd_inode page cache is deprecated in the long
term simply.

Thanks,
Gao Xiang

> 
> 

