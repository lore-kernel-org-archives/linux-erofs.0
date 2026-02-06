Return-Path: <linux-erofs+bounces-2275-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 503A2EE6B4E
	for <linux-erofs@archiver.kernel.org>; Fri,  6 Feb 2026 19:32:04 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4f743Q5dKwz30GV;
	Sat, 07 Feb 2026 06:32:02 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1770406322;
	cv=none; b=nU3KqIIOoIMhdaxyC0W6tk+BtVMDZ+pLjqmgpbXSwlvTkorscqI4Sz5Hw1OmavK1/dfGv7DYFer4PsrMuL5hAvSOA38yMskGoE15EG4pBcXhU1pLdfPr5sgokfX0UpzvsEZqXEcwbdWcyUW2yhp7wzMUDEdixkFyXjo3tmoiebGJ001ytLMpXWolL+t/h59ZqaoouuqyGdMx9WwChOzGaeXlrVTqSDYJSJ1/NWhvqAvm4d2Iwyv0tvg19WgyfVG27ZKXjAyTaU5OSciuTjWgnKlfnFWhEQqkfEHmU6o1DphIE6zM40L5CFVpcDhqQvFKRIxLQXxx9KAlcqLkvx1FxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1770406322; c=relaxed/relaxed;
	bh=/JY0u7gs8tKEQwhr2uYBZwKNrcfFc++zLECScrhdKYQ=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=RbDKrdzR1Z0j0A1RABksRRINkRbRJCn/d5s8aNXHauh8DMWKHqRtg1B9q3ngjIJHv5xYhuUzwWL1po0JuuG2qGXonCnV1Q3JcKRjucFaaayyzDJABUvs1aRzZFioIeQVQzZYNjXz303kRMGSg9QEegvurPPP3Dma7jxk4rl5Cpp+iK/uFCpq8+tp/vGD/aEuqkd24ya4tFHrd+8zo8ZN1PCUKRdMchy5c4ED1RP2KbL3LmoGopFTplBBsTNV3P9IOQYIot43F4sUqIjmFV8Ow9K7zd75PlYt0nu2LfcPeYvopw4QTQBEKpaPZqzVNZIXTXOsvmZBeMnGmp4UuIcJPQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; dkim=pass (1024-bit key; unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=P0//Ycw7; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=akpm@linux-foundation.org; receiver=lists.ozlabs.org) smtp.mailfrom=linux-foundation.org
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=P0//Ycw7;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux-foundation.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=akpm@linux-foundation.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4f743P0LtVz30BR
	for <linux-erofs@lists.ozlabs.org>; Sat, 07 Feb 2026 06:32:00 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7517341A3F;
	Fri,  6 Feb 2026 19:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E60FC116C6;
	Fri,  6 Feb 2026 19:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770406317;
	bh=sFmOLogLTpCWkUOE9qlbNa3u0BVXHcuyge59i+fnUfg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=P0//Ycw7MamL01hmVUxrX954cfCW9uQM9dRODdcU5KIQuuE0qEyY1JS9AxdM8F96v
	 5DofCLn88Bu4sHg6rPYalTvwkPcSbj6PjOltDumckh7j2RRU87blAz/W8ZmpRFjy+T
	 5AbBbYyJ/4/G1l/2aQ5CJCldkjuxifDVAKZKSGfM=
Date: Fri, 6 Feb 2026 11:31:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jarkko Sakkinen
 <jarkko@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Thomas
 Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, Arnd
 Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dan Williams <dan.j.williams@intel.com>, Vishal Verma
 <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Maarten
 Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Jani Nikula
 <jani.nikula@linux.intel.com>, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tursulin@ursulin.net>, Christian Koenig
 <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Matthew Auld
 <matthew.auld@intel.com>, Matthew Brost <matthew.brost@intel.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Benjamin LaHaise
 <bcrl@kvack.org>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Chunhai Guo <guochunhai@vivo.com>, Theodore Ts'o <tytso@mit.edu>, Andreas
 Dilger <adilger.kernel@dilger.ca>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mike
 Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>,
 Tony Luck <tony.luck@intel.com>, Reinette Chatre
 <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, James Morse
 <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, Carlos Maiolino
 <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota
 <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh
 Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Zi
 Yan <ziy@nvidia.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Jann Horn
 <jannh@google.com>, David Howells <dhowells@redhat.com>, Paul Moore
 <paul@paul-moore.com>, James Morris <jmorris@namei.org>, "Serge E . Hallyn"
 <serge@hallyn.com>, Yury Norov <yury.norov@gmail.com>, Rasmus Villemoes
 <linux@rasmusvillemoes.dk>, linux-sgx@vger.kernel.org,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-aio@kvack.org, linux-erofs@lists.ozlabs.org,
 linux-ext4@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev,
 devel@lists.orangefs.org, linux-xfs@vger.kernel.org,
 keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, Jason
 Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v2 09/13] mm: update all remaining mmap_prepare users to
 use vma_flags_t
Message-Id: <20260206113153.c443545459474cdef6dfd7ea@linux-foundation.org>
In-Reply-To: <hmc2or77xnhrdlncfzjsljljwljnp6zztqsvmgxspfilmzkyty@czxpjpdm66ov>
References: <cover.1769097829.git.lorenzo.stoakes@oracle.com>
	<fb1f55323799f09fe6a36865b31550c9ec67c225.1769097829.git.lorenzo.stoakes@oracle.com>
	<hmc2or77xnhrdlncfzjsljljwljnp6zztqsvmgxspfilmzkyty@czxpjpdm66ov>
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

On Fri, 6 Feb 2026 17:46:36 +0000 Pedro Falcato <pfalcato@suse.de> wrote:

> > -#define VM_REMAP_FLAGS (VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP)
> > +#define VMA_REMAP_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,	\
> > +				     VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)
> 
> as a sidenote, these flags are no longer constant expressions and thus
> 
> static vma_flags_t flags = VMA_REMAP_FLAGS;
> 
> can't compile.

Yup, that isn't nice.  An all-caps thing with no () is a compile-time
constant.

It looks like we can make this a nice inlined (commented!) lower-cased
C function as a little low-priority cleanup.

> Rest LGTM though.
> 
> Acked-by: Pedro Falcato <pfalcato@suse.de>

Great, thanks.

