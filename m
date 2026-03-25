Return-Path: <linux-erofs+bounces-3005-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D55F6109C037
	for <linux-erofs@archiver.kernel.org>; Wed, 25 Mar 2026 16:24:09 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fgsfw2L0Kz2yVL;
	Thu, 26 Mar 2026 03:24:08 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774455848;
	cv=none; b=GWdAV536IDJBRAFG/dP0z+XPOrFeAiziRUrm4u2LRdckZhS5dv7SM9i80j17ccFg8pFOArWusCcWWvJ27lWXspTjYxVeZa90sLAlrL7HhVGS10ov+oiRWJS/YHKyzoh9smeYE1eBmMt8mFWTRuufplDGknqjYOkGeEWQVvV3hKo2Sh6Ls80mw6QG4Y/7Y8DseMlsGKcHve9qIJHil2nkAoHhZjBwY6LEpaqvuAYC5JhSdqcG63KGgFbbG+3hRcOfGIhek8tvQambFdqgd5FKdAOuGi1dlZBig7N58IZ3RRU1QhdjkHbj2L3f7TbhQcxb5OcwTa58/gXirW1hKuP5FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774455848; c=relaxed/relaxed;
	bh=y+cQS26H7vyCKrxPAvHHZDmBa00xHiwKvNzjQXsWfXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GZhCAIOMufP9wvLu3g4S6HVjF4axoivURjtCZFJlqBVE0G8wk2hr8ghy+vkD5mAvRAGd6UavA0e4+CvybrZBUCfoAeqCeh9SEDxmHuEwPZfQGv2ZDNzsrEzM/V3UY/1og82gvfZan2klsSOdDqwUN+QLITfkugfVpjZ3ph0gmv/G+sALnLEYsFz75R9bdIdJ0ihhe4F1f2NW96uicI6sjZQJUuM2qqvUvIo2oE7L41tslvgV1hhp7o2ntqYW+g8Xz3hSTvMe7cc2v13LSQanVK91btaCE4TVPEh+k1YJm7k/CigIgXdJQGIoq+WKKzZOaSnmGneql4IFRaokENrVLw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=BSBG0LH7; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=ljs@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=BSBG0LH7;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=ljs@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fgsfv2VW3z2yTK
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Mar 2026 03:24:07 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 21B2960121;
	Wed, 25 Mar 2026 16:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D21C19423;
	Wed, 25 Mar 2026 16:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774455844;
	bh=6GGVqV2Zd7+GdOihEp+etPbPztUZ47vsPoYBsuWNUJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BSBG0LH7Uew3Sjq4jNxlJrWFyT3Tna+tc7X4kVxxF6w8nzX8eer3lHMZB4zswcXfP
	 xjHkzOmcSkmxm5eq/3iXOohApbujl5UruoOAbbfHvSjozo44xQoYWVhODuTf8D4ju/
	 nswtqxxY1kL35DBhTNfPo8+tdKnNJWFnrh75P90LL0UiKYaoZJsqSgFN8aWmgBP6Yd
	 Jo+unrnO+Cm3t2c9upMUBSuKZyea42E3Gj+JOALgQJRcR8Hg2sh+qphdGAvmbalo2h
	 LRQWxtM1B5CccqDCpGhuKpefdNbdPDiDGiXiEOVqRKqyR2IZ20vieNQOs5dGac3Dbc
	 dhKvxI1+xXZ4A==
Date: Wed, 25 Mar 2026 16:23:53 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Tony Luck <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, 
	Babu Moger <babu.moger@amd.com>, Damien Le Moal <dlemoal@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm: always inline __mk_vma_flags() and invoked
 functions
Message-ID: <959b34ea-69a7-4fda-a494-0b9a1773ec1d@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
 <241f49c52074d436edbb9c6a6662a8dc142a8f43.1772704455.git.ljs@kernel.org>
 <ndtnvnobevdymu5a5tdxdbi4tcsqshs3d6x2vnfgnuclxvgwok@bhbqkzilsets>
 <d352055d-06fe-43b2-8ad3-b73ab99683d0@lucifer.local>
 <20260325090949.795e06f48ec455053db9ae89@linux-foundation.org>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325090949.795e06f48ec455053db9ae89@linux-foundation.org>

On Wed, Mar 25, 2026 at 09:09:49AM -0700, Andrew Morton wrote:
> On Wed, 25 Mar 2026 14:58:14 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > On Wed, Mar 25, 2026 at 02:54:50PM +0000, Pedro Falcato wrote:
> > > On Thu, Mar 05, 2026 at 10:50:16AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > > > Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
> > > > macro) always being inline, as we rely on the compiler converting this
> > > > function into meaningful.
> > > 		meaningful what?
> >
> > 'into the equivalent compile-time constant code' probably fine.
> >
> > Andrew - could you update that if there's time?
>
>
> np
>
>
> : Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
> : macro) always being inline, as we rely on the compiler converting this
> : function into the equivalent compile-time constant code.
>
> what does "compile-time constant code" actually mean?  That constants
> within the code are evaluated at compile-time?

Yeah, so effectively the compiler rewrites:

x = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT);

To:

x = (1UL << VMA_READ_BIT) | (1UL << VMA_WRITE_BIT);

And then:

x = 3;

Various efforts at checking generated assembly has confirmed this.


Maybe 'into an inline constant value' is better?

Thanks, Lorenzo

