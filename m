Return-Path: <linux-erofs+bounces-2526-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D17CF513ED
	for <linux-erofs@archiver.kernel.org>; Fri,  6 Mar 2026 01:28:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fRphH5WDmz3bn7;
	Fri, 06 Mar 2026 12:28:31 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772760511;
	cv=none; b=BGum7a3otLLRuioeAWVcfB7UJ7MJ6bg5wG7E93LSz1HfwXvHtU5X59ecZK2yXaRbHWevykm9m1ie6jiY56+Cr6x9q4KeRLUtishqP54wKiUT1HYSBOEgzwCfTwqnuH2IJcou6pX3uvzAeHIUUdQYztibia0LXonUDpXuj4PI6cwjA2R+BHSVziIyo8OFLAua2f/fvSwiRZ3Mkh/Q1DqD63pZCg6W2aCH18ZDXZ0rn4w/UyOKeAL1kZKD5+jegqYNYtiNgUvj8wLopqCLTQ6fqDzOc+YZeAozp+CZwciOwZ68/Gu6Pkc8IkaXE+ky0gK+Bk+6x/dBP3SPHtv2NY6+Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772760511; c=relaxed/relaxed;
	bh=CaG7jr+VfjnCoSN4V62oLqn5tLh2gzx8QQSFMx4Q7MA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=UTvMk5VpBxz/mEnZCTbor8Ubu6TM0bxBuTdbaDlblOKpkKINHdYlkZPZX1ED0ccDORmSAUOI9k2AeTLbndHSrZnRw4BzxxK/AQ292fExKJNGS6UR9sua8VrpejC8/qdAhdoC+IHJXXk+qbH5yn5qlIFBU+Mk5diAjwPMCJhhlILTq4lT0646lY1yrFzyh2Fc2lWiibm8/uIe4sFRZ4Dshr9ct7S3J6/iPiYr2QLBl4oh7WssW0+Pa/rG4WwQp9WG7JOjBfF81ncneeiST9EpiMw5ewHOQzIV3W28EXegz9eUA2OXAR3UD78niwnJROooxRZh5alKx6/3x/9T+lrvoQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; dkim=pass (1024-bit key; unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GLd0s/ch; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=akpm@linux-foundation.org; receiver=lists.ozlabs.org) smtp.mailfrom=linux-foundation.org
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GLd0s/ch;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux-foundation.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=akpm@linux-foundation.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fRphG2Dlmz3bfV
	for <linux-erofs@lists.ozlabs.org>; Fri, 06 Mar 2026 12:28:29 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F214400A8;
	Fri,  6 Mar 2026 01:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9ABBC116C6;
	Fri,  6 Mar 2026 01:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772760506;
	bh=xoqtM6KgSSyBmEncwbFJBFIEM74nLDE4UHST+ZsEmS4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GLd0s/chsfmYvy+LIH62gG5cEGAEj5HMdsosVlCij4305RrtKNFRubz7oaemcCLGp
	 cYE1e6xHiziyBEv2LfZDfBA0YvxGjkdcmwIMHkbsWGB3BeloGCws11aDALA3BnxMIh
	 KTm0M6zqfZxOWL8K7hZizyGYcV4OsvQCT4Rk4jEc=
Date: Thu, 5 Mar 2026 17:28:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu
 <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep
 Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, Chunhai
 Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>, Oscar
 Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Tony Luck
 <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, Dave
 Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, Babu Moger
 <babu.moger@amd.com>, Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota
 <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Pedro
 Falcato <pfalcato@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-mm@kvack.org, ntfs3@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/6] mm: vma flag tweaks
Message-Id: <20260305172824.fd712ae310748dc6338d6d5b@linux-foundation.org>
In-Reply-To: <cover.1772704455.git.ljs@kernel.org>
References: <cover.1772704455.git.ljs@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  5 Mar 2026 10:50:13 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> The ongoing work around introducing non-system word VMA flags has
> introduced a number of helper functions and macros to make life easier when
> working with these flags and to make conversions from the legacy use of
> VM_xxx flags more straightforward.
> 
> This series improves these to reduce confusion as to what they do and to
> improve consistency and readability.

Thanks, I quietly added this (and the -fix) to mm.git's mm-new branch.

