Return-Path: <linux-erofs+bounces-2191-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF0E8D3EE95
	for <linux-erofs@archiver.kernel.org>; Thu, 22 Jan 2026 16:56:12 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dxnJW2fG9z2yFm;
	Fri, 23 Jan 2026 03:56:11 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769100971;
	cv=none; b=m8XHEpcen13EJGeoERdDXGni1XD/0GfitmarSCP8jMj2c5EZeoo4uK8SnzKHe13qNIQvYC2bwU+fTTDVgsY2oaMJXXHQKmfbL2KHvJgQkHxtMBhICUz8+RuxPBenlXoeTY8JY+Wk0gtcccaEiy5ABpVtk0uuu5PavaGnJIF1HjzeYrMFJaiOPIOdjHZXIIHD8MLe2RINb63Ah8jrYf2c4KLM9kCvXBCtB+V1p2TcGVeDIb5aDDNOlIUjPOWNIjdCL70pOteVlcBk1wKEsqMwZrXGn1NG0ErhJKsODXkpcsfGfPgQQFbdw9BBEC+ZURLi954HmijEHB7LWD/MrsAisg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769100971; c=relaxed/relaxed;
	bh=5Ouuw1KntUWS56pg/PFLpKK95mOBMuhGqPq2jMG5wGw=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Q4ut/P6pSfptetlLFeMwI9SlKlY3hvh3u5lCwKbJByPJksasHn3AE/kNemQAxFxpxhGK1ivVRhaC9y+lxWD9W9wlotjblasYc7nhpGHVqvh3ShabP52M+J68gnJQ6PayGp5zQ4f43dVYkI+qTvtdgk9FLKuBbm/epMQ1NNVhEWMxQEoC/kJzeoHL+T9j0BEUsrw7D7kZloHaOJ6yKsUPlAmqN/rlr+xHYIuqMKlAcdTWeSaUmCOY3SzP0gu5mOuMsg4qFq42EQnIz9LgpvfRkxQ8P0LcQaNRY2/VIwwIAZbfRsvv3VDodcs/3XF5rtuvu5pfTCT8frLx0LZz0zcVyQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; dkim=pass (1024-bit key; unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UTEaHcdr; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=akpm@linux-foundation.org; receiver=lists.ozlabs.org) smtp.mailfrom=linux-foundation.org
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UTEaHcdr;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux-foundation.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=akpm@linux-foundation.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dxnJT5Tv0z2xl0
	for <linux-erofs@lists.ozlabs.org>; Fri, 23 Jan 2026 03:56:08 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B2B5A43A88;
	Thu, 22 Jan 2026 16:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C451BC116C6;
	Thu, 22 Jan 2026 16:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769100964;
	bh=jrjPF0WwvPZPRM6P6o/2VJJe4697MQWP7qZdUYFxSHY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UTEaHcdr42aH4+na9j15KfpiqbAYafbC0X2iMUD6k4y/YtdzCCZ1DycwTLHJx0PPt
	 +CS99+ai15VAAJyTlXJod09HI5BHg9DqD+81D8WgglFvTzCgDavAE+Qd9mUxEIoEfe
	 6FnS53cyUDclSITvSvJ4wllykWndkBImnZdCxvZI=
Date: Thu, 22 Jan 2026 08:56:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen
 <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@kernel.org>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams
 <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave
 Jiang <dave.jiang@intel.com>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi
 <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>, Christian
 Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Matthew
 Auld <matthew.auld@intel.com>, Matthew Brost <matthew.brost@intel.com>,
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
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, David Howells
 <dhowells@redhat.com>, Paul Moore <paul@paul-moore.com>, James Morris
 <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>, Yury Norov
 <yury.norov@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
 linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
 linux-mm@kvack.org, ntfs3@lists.linux.dev, devel@lists.orangefs.org,
 linux-xfs@vger.kernel.org, keyrings@vger.kernel.org,
 linux-security-module@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v2 00/13] mm: add bitmap VMA flag helpers and convert
 all mmap_prepare to use them
Message-Id: <20260122085601.4d40447ca2f9a060d3140212@linux-foundation.org>
In-Reply-To: <cover.1769097829.git.lorenzo.stoakes@oracle.com>
References: <cover.1769097829.git.lorenzo.stoakes@oracle.com>
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

On Thu, 22 Jan 2026 16:06:09 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> We introduced the bitmap VMA type vma_flags_t in the aptly named commit
> 9ea35a25d51b ("mm: introduce VMA flags bitmap type") in order to permit
> future growth in VMA flags and to prevent the asinine requirement that VMA
> flags be available to 64-bit kernels only if they happened to use a bit
> number about 32-bits.
> 
> This is a long-term project as there are very many users of VMA flags
> within the kernel that need to be updated in order to utilise this new
> type.
> 
> In order to further this aim, this series adds a number of helper functions
> to enable ordinary interactions with VMA flags - that is testing, setting
> and clearing them.

Thanks, I updated mm.git to this version.

I dropped the memfd_luo.c hunk due to today's inclusion of
https://lkml.kernel.org/r/20260122151842.4069702-3-pratyush@kernel.org

`get_maintainer --nogit' wants me to cc 72 people on this patchset.  I
didn't ;)

