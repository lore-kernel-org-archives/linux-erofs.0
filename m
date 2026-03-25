Return-Path: <linux-erofs+bounces-2981-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2012FFEA817
	for <linux-erofs@archiver.kernel.org>; Wed, 25 Mar 2026 07:08:39 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fgdKx2nV9z2xMQ;
	Wed, 25 Mar 2026 18:08:37 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774422517;
	cv=none; b=hnBWdm/sjPneFaRdJQEAhCuCrXoikYNR2a4uo7D0w77mL3iisbjcM8gZx3LqEOfj4fLqFYx/rTcl0h+p/LAm/yY/WoaT/9dL9yS0PNxahzZxbUtXti1nY3ykhh97ZHFmEptIbzhdO01R6efY2jyJIroJNt4Ew+hCedhFsmHXYCTB9B4dlHqJuRRDZzvtA2S2cMRocTu+jfqZy5afYmtoo2PHFtrdN/TQz1ZrAHUwKy+ZkihfDIrecPPcfnkr54E2AI/WnTHGdfxwvYyokncrkZ0gGUVxrAy11rC9faGyUHh+zt6/8rA6m3mzVwmj5vhh6h35AhOBI0J5uOflbSx5jw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774422517; c=relaxed/relaxed;
	bh=zampRoceqgBsThYjPx33YjovWL9STWRQLqywI/2s0FQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=moTHsV+L15hY52BC9mW+yQQ4nR0qQ2EBozJK2uztzPUUNJFCfZ2owh9BntdfhXgeEldJRqcSDJykxcLVSqRvSgXO7jSkmbEQFB2a0Q2Qnu/WgpQoqa+Do/FNE77H6LGGrbknGZyg6Ay3ZE0A0IXlMEd/ATaSykUii0jG7yZGtm7LW4RmEQg7xPlv50TuHRTgovfLiIEiIJchD4nk6ddouV8xh/fEAnBS6tAdvbP2pqhdk1cKmQDQNLV3m4dru+IlTspjkYALPRh6m4w7MU3m6CbO2XG/BMW/GwQNeI55B8cjRucjy5DzbFfCseToyk5vsR4zarUZbmFdnAXT5PyOZg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=U+fi7yjA; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=ljs@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=U+fi7yjA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=ljs@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fgdKw4gYnz2xLv
	for <linux-erofs@lists.ozlabs.org>; Wed, 25 Mar 2026 18:08:36 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 51CB341789;
	Wed, 25 Mar 2026 07:08:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C979DC2BC9E;
	Wed, 25 Mar 2026 07:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774422514;
	bh=wloUbny5iGf241ZcwoWfGI1G4epwXCE04slEJFNkwPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U+fi7yjAY4ZcZaA8Wmq+9ofwJ01X6R5BUulVmOdBiUMiJNXdz/KWVyrUVBvzgPCdG
	 2iIJ4CGzZ7IBbErqBjmBCXGf1CFvx3+fKZ147WGar3VzjtyTzRvfbEBNSup+q0+J7b
	 aPb6Ft2C7ojmFs8B8ou4LrMK94BCHWXKBqtTOB/U0rh+I+z+hMFm7l2vh+tpqjhKHZ
	 E1o19EK9/Tp01KDDdBMfljviCTxMfaIATpKElMbeNcU09W7rcU882ncXoUehokpWFR
	 /05zR6R0eEOzCsZDKcOave4LUSm3OuHObd65uQKuOZ1OkoMCXMj2iTdIe1ov7xt5cF
	 KwF5Hpr6IdeEQ==
Date: Wed, 25 Mar 2026 07:08:22 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, 
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
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, 
	ntfs3@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/6] mm: add vma_desc_test_all() and use it
Message-ID: <24163ac9-bb0d-402c-a028-d1af7f56caa1@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
 <568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
 <20260324161212.4b0a6f4fd5eb57ff2ffa7ea5@linux-foundation.org>
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
In-Reply-To: <20260324161212.4b0a6f4fd5eb57ff2ffa7ea5@linux-foundation.org>

On Tue, Mar 24, 2026 at 04:12:12PM -0700, Andrew Morton wrote:
> On Thu,  5 Mar 2026 10:50:15 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > erofs and zonefs are using vma_desc_test_any() twice to check whether all
> > of VMA_SHARED_BIT and VMA_MAYWRITE_BIT are set, this is silly, so add
> > vma_desc_test_all() to test all flags and update erofs and zonefs to use
> > it.
> >
> > While we're here, update the helper function comments to be more
> > consistent.
> >
> > Also add the same to the VMA test headers.
>
> fwiw, we have no review tags on this one.

Based on the discussion we had about this previously I was under the impression
if submitted by a maintainer that wasn't required?

I'll nag people, but I'm a bit surprised if this is why you haven't moved this
to mm-stable, given how trivially obviously correct this patch is.

Lorenzo

