Return-Path: <linux-erofs+bounces-2210-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56275D72343
	for <linux-erofs@archiver.kernel.org>; Fri, 23 Jan 2026 07:47:00 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dy94L6VP3z2xHt;
	Fri, 23 Jan 2026 18:46:58 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769154418;
	cv=none; b=CVZhenGZIkzjlrFkl/KxLbnMvRpYezpqIKhOgOE8jvHWFzVf5w2+UCRcFNOsrdB5JYQRHrNXOdvJH8Hm076ePXA+EystFTOyXuDEfXC+w2JHv/IWzSUuIfrCmSPAewYO7N3+oumEwtNkg/FY3LxXZWmiDse6AED4sKfrXPUuP2jCZJnuJ/iYaenXYWGWwVmNRcMMBZXKZAKBlVIBVyx9pvhW9TuOPwr3RRcGa7rqVlUWBrWu+a5epF6fOVOXs13hki+iwX2rbCM7buFpXVOmCVTgvbd23BaWKf6uTDR0IIj9/mC9YDsUsf4dxiIEMB30jzNBwVFIpdVORV8HUAYwkA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769154418; c=relaxed/relaxed;
	bh=Dn3robGukUhTOXOalWLulDq01xpYbk4pZ/CZENXym0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oEkVriEZrmzzmXAV24Xm3m4nkTclKiz7NAh5awzdvSL6yTPsU7kQhuqQjERV3dixtTutMaCYt5Hl2H2spGJblsVz6owGhoj4MYdQYC4K5YmLEnBxC/R66BzfAFufAjkYmuNwUePgTqJglOPeWWaV+eploQkr9s1tKcIOq2IoDSrqwJJPigfzBCvnxVjU6zvCQy3JkCU1Hz52KhOXga/QuVCT66YFm6XseZ/7UKjrg2LI1glXRgK95ogUgAOG+Nk4rmzIUYE3rtSR7J2HPSAz7Tpl5Zk3MdxdnV7XhQ5nUuHjCG7mVnCVMB+RSnQhrZTzgR2m08RWC5Ltrtap/OTv2w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=gKjzE7cq; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=djwong@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=gKjzE7cq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=djwong@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dy94K1Plbz2x9M
	for <linux-erofs@lists.ozlabs.org>; Fri, 23 Jan 2026 18:46:57 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5847842B6E;
	Fri, 23 Jan 2026 07:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD45C4CEF1;
	Fri, 23 Jan 2026 07:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769154413;
	bh=OAD/ygUEOD88K+ggqyDG4ngV41XfzkifYu+rUan4UmY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gKjzE7cqDXZweQuGHrMLnfOMSZf3lh7HGxajgtU/lt8kCe+JBtiVTH7cLgHlNYZDq
	 /xkI+t4I2UXrUC62zmbj0vZUsBgJVNWHf2u/IB5rVWQ0M92qWVFNAn+aHpwjmatIJJ
	 42HGEvas39c7oPcKIUvmKiwxdWG6F7op09dvqSnaEPXJxDYV8uNaZg5zuYpCGbPOV2
	 uECZnk5jJ2EcGxljpENkS6fEZ1z6XTrmkHHGu/DMNaJHL0zQj3FpdgRCKBYhPwGr8Q
	 PcpeqEt3bPSuwM7nEePid0sJHAvbYps2rpINdGvyHw/B3l0OhLkXuPNse9MoBWxRVu
	 vChCTt8SYWz8g==
Date: Thu, 22 Jan 2026 23:46:52 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Benjamin LaHaise <bcrl@kvack.org>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dave Martin <Dave.Martin@arm.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	David Howells <dhowells@redhat.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
	linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
	linux-mm@kvack.org, ntfs3@lists.linux.dev, devel@lists.orangefs.org,
	linux-xfs@vger.kernel.org, keyrings@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v2 08/13] mm: update shmem_[kernel]_file_*() functions to
 use vma_flags_t
Message-ID: <20260123074652.GW5945@frogsfrogsfrogs>
References: <cover.1769097829.git.lorenzo.stoakes@oracle.com>
 <736febd280eb484d79cef5cf55b8a6f79ad832d2.1769097829.git.lorenzo.stoakes@oracle.com>
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
In-Reply-To: <736febd280eb484d79cef5cf55b8a6f79ad832d2.1769097829.git.lorenzo.stoakes@oracle.com>

On Thu, Jan 22, 2026 at 04:06:17PM +0000, Lorenzo Stoakes wrote:
> In order to be able to use only vma_flags_t in vm_area_desc we must adjust
> shmem file setup functions to operate in terms of vma_flags_t rather than
> vm_flags_t.
> 
> This patch makes this change and updates all callers to use the new
> functions.
> 
> No functional changes intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  arch/x86/kernel/cpu/sgx/ioctl.c           |  2 +-
>  drivers/gpu/drm/drm_gem.c                 |  5 +-
>  drivers/gpu/drm/i915/gem/i915_gem_shmem.c |  2 +-
>  drivers/gpu/drm/i915/gem/i915_gem_ttm.c   |  3 +-
>  drivers/gpu/drm/i915/gt/shmem_utils.c     |  3 +-
>  drivers/gpu/drm/ttm/tests/ttm_tt_test.c   |  2 +-
>  drivers/gpu/drm/ttm/ttm_backup.c          |  3 +-
>  drivers/gpu/drm/ttm/ttm_tt.c              |  2 +-
>  fs/xfs/scrub/xfile.c                      |  3 +-
>  fs/xfs/xfs_buf_mem.c                      |  2 +-
>  include/linux/shmem_fs.h                  |  8 ++-
>  ipc/shm.c                                 |  6 +--
>  mm/memfd.c                                |  2 +-
>  mm/memfd_luo.c                            |  2 +-
>  mm/shmem.c                                | 59 +++++++++++++----------
>  security/keys/big_key.c                   |  2 +-
>  16 files changed, 57 insertions(+), 49 deletions(-)
> 

<snip to xfs>

> diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> index c753c79df203..fe0584a39f16 100644
> --- a/fs/xfs/scrub/xfile.c
> +++ b/fs/xfs/scrub/xfile.c
> @@ -61,7 +61,8 @@ xfile_create(
>  	if (!xf)
>  		return -ENOMEM;
>  
> -	xf->file = shmem_kernel_file_setup(description, isize, VM_NORESERVE);
> +	xf->file = shmem_kernel_file_setup(description, isize,
> +					   mk_vma_flags(VMA_NORESERVE_BIT));

Seems fine, macro sorcery aside...

>  	if (IS_ERR(xf->file)) {
>  		error = PTR_ERR(xf->file);
>  		goto out_xfile;
> diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
> index dcbfa274e06d..fd6f0a5bc0ea 100644
> --- a/fs/xfs/xfs_buf_mem.c
> +++ b/fs/xfs/xfs_buf_mem.c
> @@ -62,7 +62,7 @@ xmbuf_alloc(
>  	if (!btp)
>  		return -ENOMEM;
>  
> -	file = shmem_kernel_file_setup(descr, 0, 0);
> +	file = shmem_kernel_file_setup(descr, 0, EMPTY_VMA_FLAGS);

...but does mk_vma_flags() produce the same result?

--D

>  	if (IS_ERR(file)) {
>  		error = PTR_ERR(file);
>  		goto out_free_btp;

