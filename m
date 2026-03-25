Return-Path: <linux-erofs+bounces-2998-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92E0B109C030
	for <linux-erofs@archiver.kernel.org>; Wed, 25 Mar 2026 14:58:31 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fgqm61wfbz2xcB;
	Thu, 26 Mar 2026 01:58:30 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774450710;
	cv=none; b=RTmkLnoEPN6vGGqzVBbywCW/5lq8+4dobXuu0nhoMoHhIqRIuMPGf75AhPPviB+C1zX7r5rrct+lxC10k/Bs9xuySVisYJJVshciWoOA79HCY1dMk0xR/5t3sLOdYGN5QB41IH6dRJ6B3oFVO9phV28Uf/0GOIwCbr4CsTXD6/lXlUs/5305PyIWASqzy7d/YwKEw8HzGh7BB5f+G1hHyAEhoR1zoqkL0dprixXSFRkPm8nZpYNoR+oSMi8Wutp4pXqu+aI2dASsWEnUiikd78GACz3gOtDLaykm2nlsOvrKb/3/6qODBI2DkpCpey21fRZfoKhTL0aGYytJvJId9g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774450710; c=relaxed/relaxed;
	bh=OAg/9SYOwNvXBsK3xYB3WMYU/nidc/COKx3Vf5pQQZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YTguwniVhACd6lxO+re/6MHXtUXzGTJ/DbZuqI4s38VAlKbr6T/OF+SSmGeZ8YER9pB2qy0o2CgI1F+fymBXImYkGZuw0wZvdx++N4h/mCoyfZ8QpBF4C75k24tLyZwfGeGs0cHEn+9/aJEA8b8HRdAMLnkWGnJA7VjfcuFZhUEmwE4Qi2XOhmSKHc/vzy8dr6gxolMA/Vay8T66pXf1wQjlES6dcmgAsVyS1MaDhfFCQsU0eKoaI36Vozls0xv4OeiGViVWgac8wDpkqtVEg6LEbWeULAwJZEdNWQyh5ioC0AeRwVdEGHOtOsHWNt5yVAMeMk7JDz/KfqgX+pXztw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=C4H7nAW7; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=ljs@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=C4H7nAW7;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=ljs@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fgqm527r4z2xS3
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Mar 2026 01:58:29 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 76E04600AC;
	Wed, 25 Mar 2026 14:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E62C4CEF7;
	Wed, 25 Mar 2026 14:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774450706;
	bh=PJ66QebMQICZPHru+Ol9tC17Y8ZYviklyv0rvmLSZHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C4H7nAW7M8zf238SiNH7LcqjmEdcm69QKxxl5QtoBGJ3JRpt98C6N4cv7bpBpqV4f
	 R8LDjFfBF3z2EguuCUL8pxrw34c6hMyFX/FEryKCamqgdgFnZ0jhdcjd+4e3FVTgt7
	 apBPGPVaF9c8DeWNz1pYn9IbEpEcV5SxRKlU3yt6Ss6/+nADVOXQbwxXIn0fN9JvJy
	 8UjP2CS36YbhgQgMfUXil2w1MkzCZ92GjJbbb7H//Cb0F5Y6GO2kRCAFiRSPudQGSB
	 hb5EasVzLPBeRXllpvhCNzLtyy4zucK4eYz8xXVySYjbaNxM+2eiXUaA3uGwmnrvRf
	 usaZbsHCKJTyw==
Date: Wed, 25 Mar 2026 14:58:14 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm: always inline __mk_vma_flags() and invoked
 functions
Message-ID: <d352055d-06fe-43b2-8ad3-b73ab99683d0@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
 <241f49c52074d436edbb9c6a6662a8dc142a8f43.1772704455.git.ljs@kernel.org>
 <ndtnvnobevdymu5a5tdxdbi4tcsqshs3d6x2vnfgnuclxvgwok@bhbqkzilsets>
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
In-Reply-To: <ndtnvnobevdymu5a5tdxdbi4tcsqshs3d6x2vnfgnuclxvgwok@bhbqkzilsets>

On Wed, Mar 25, 2026 at 02:54:50PM +0000, Pedro Falcato wrote:
> On Thu, Mar 05, 2026 at 10:50:16AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
> > macro) always being inline, as we rely on the compiler converting this
> > function into meaningful.
> 		meaningful what?

'into the equivalent compile-time constant code' probably fine.

Andrew - could you update that if there's time?

>
> >
> > Also update all of the functions __mk_vma_flags() ultimately invokes to be
> > always inline too.
> >
> > Note that test_bitmap_const_eval() asserts that the relevant bitmap
> > functions result in build time constant values.
> >
> > Additionally, vma_flag_set() operates on a vma_flags_t type, so it is
> > inconsistently named versus other VMA flags functions.
> >
> > We only use vma_flag_set() in __mk_vma_flags() so we don't need to worry
> > about its new name being rather cumbersome, so rename it to
> > vma_flags_set_flag() to disambiguate it from vma_flags_set().
> >
> > Also update the VMA test headers to reflect the changes.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>
> Is there an actual difference in codegen here? On -O2.

No, this is more about consistency.

>
> --
> Pedro

Thanks, Lorenzo

