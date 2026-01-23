Return-Path: <linux-erofs+bounces-2211-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EBDCD72348
	for <linux-erofs@archiver.kernel.org>; Fri, 23 Jan 2026 07:47:53 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dy95N1RHgz2xJ5;
	Fri, 23 Jan 2026 18:47:52 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769154472;
	cv=none; b=CJE1NAEHyqTaIxkNzMgFzGajLdR0eYpzQ/d1PEaMXKJf2GxFYNdwY8qGz2nVMtTa7eBe1i6QRZ3LOq6rg5WfVBRoOVycyvCOo9Sx1K462T8DSNmqR+RL4gnN5h02nKnCcpBx/T0pqLKKUlSgxfrD1ZZqIc5xCuunq0EDfcck1reWFmbrc+zwDyS7nhU61d8uJQZkW1+k84MFOOnzRvQ4SYgaSAzq3kXHWgBDA95eDaYiDUlcq4qbd/qyg4fS8IhQwgpmz63/03ObwZFqblGzO6DVKr4d0k2Qpyxt/Oq7hFS4P2ONHtDBgvZUzgCf2NmkDVIKF0jmKxa1VAR6z1ueow==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769154472; c=relaxed/relaxed;
	bh=d7Cved2U0cx1Ah0GRYbOwiLnpALcJilpWIO4L1x9IxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cer0ejgmpnVWFJ9qZpS+ZjB3rsfo04IELd4z8y3qr7S0FNiKE3GayHOXo/HD7GwhAZHhejQuU4uScmtaikbKiIQQCvH5lpPF1WSj+78eWGoRsvBuLp2slZCpQY4HRWE0XRQJVO+Hd2nBLj0Qx4ONvhIL//Z9Jj1mTRl/Y7/VH3xxHBBKrmFpa2496+9kUUK+JcauRPKbNoshP3A8i2Lybeyo6+xIGBKWt1ji1CD63xiQbZqnemxFNdJ1ectufMW+BrWozQW5Zt5An1SMbrNrVocjxT6j+sBdQ82qy+CrKKKMgdc7MOvxdsBB1FCI15BQ81syCiZdHcQXJ311r2AWzA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=Dhz6ArAn; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=djwong@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=Dhz6ArAn;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=djwong@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dy95M3Yhcz2x9M
	for <linux-erofs@lists.ozlabs.org>; Fri, 23 Jan 2026 18:47:51 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F53D443C6;
	Fri, 23 Jan 2026 07:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6FAC2BC86;
	Fri, 23 Jan 2026 07:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769154469;
	bh=qZcCh8YaN75BaHxJI3n8DUClBttDVVefL2TarE8x2cs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dhz6ArAnF4mrMgD2V9gaW0IOdAyt0UWHdcwmUQgrPBIWvnoaDzJtzmzMJxVck5gv+
	 zEZgJOeFD/IJQzx2Up99SCKmemnDSbXrWZlm1SAK7ny61M8KuplDc84jbfdlgQwQR6
	 +8Rb9fJ2j1Dh4UnsHETHjtBawHKcytU2E3ai7JjVMGK0KGDMhhcMz8n/3MAGSNlsTJ
	 lel+3wVzQK3+jEYSZdvY/T5wo14jtYZ5i4jErLaZOvUngMzlLTTOeS1t4am1xi1tfP
	 GskVtQYN+cTM93xV5bjb1azN9mPAsYErt+ynoEzLMYagl5talCo4C2ogUWa2ojcK07
	 lGuDTmdB4UMCw==
Date: Thu, 22 Jan 2026 23:47:48 -0800
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
Subject: Re: [PATCH v2 09/13] mm: update all remaining mmap_prepare users to
 use vma_flags_t
Message-ID: <20260123074748.GX5945@frogsfrogsfrogs>
References: <cover.1769097829.git.lorenzo.stoakes@oracle.com>
 <fb1f55323799f09fe6a36865b31550c9ec67c225.1769097829.git.lorenzo.stoakes@oracle.com>
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
In-Reply-To: <fb1f55323799f09fe6a36865b31550c9ec67c225.1769097829.git.lorenzo.stoakes@oracle.com>

On Thu, Jan 22, 2026 at 04:06:18PM +0000, Lorenzo Stoakes wrote:
> We will be shortly removing the vm_flags_t field from vm_area_desc so we
> need to update all mmap_prepare users to only use the dessc->vma_flags
> field.
> 
> This patch achieves that and makes all ancillary changes required to make
> this possible.
> 
> This lays the groundwork for future work to eliminate the use of vm_flags_t
> in vm_area_desc altogether and more broadly throughout the kernel.
> 
> While we're here, we take the opportunity to replace VM_REMAP_FLAGS with
> VMA_REMAP_FLAGS, the vma_flags_t equivalent.
> 
> No functional changes intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  drivers/char/mem.c       |  6 +++---
>  drivers/dax/device.c     | 10 +++++-----
>  fs/aio.c                 |  2 +-
>  fs/erofs/data.c          |  5 +++--
>  fs/ext4/file.c           |  4 ++--
>  fs/ntfs3/file.c          |  2 +-
>  fs/orangefs/file.c       |  4 ++--
>  fs/ramfs/file-nommu.c    |  2 +-
>  fs/resctrl/pseudo_lock.c |  2 +-
>  fs/romfs/mmap-nommu.c    |  2 +-
>  fs/xfs/xfs_file.c        |  4 ++--
>  fs/zonefs/file.c         |  3 ++-
>  include/linux/dax.h      |  8 ++++----
>  include/linux/mm.h       | 24 +++++++++++++++++++-----
>  kernel/relay.c           |  2 +-
>  mm/memory.c              | 17 ++++++++---------
>  16 files changed, 56 insertions(+), 41 deletions(-)
> 

<snip to xfs>

> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 7874cf745af3..1238ec018bc7 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1974,14 +1974,14 @@ xfs_file_mmap_prepare(
>  	 * We don't support synchronous mappings for non-DAX files and
>  	 * for DAX files if underneath dax_device is not synchronous.
>  	 */
> -	if (!daxdev_mapping_supported(desc->vm_flags, file_inode(file),
> +	if (!daxdev_mapping_supported(desc, file_inode(file),
>  				      target->bt_daxdev))
>  		return -EOPNOTSUPP;
>  
>  	file_accessed(file);
>  	desc->vm_ops = &xfs_file_vm_ops;
>  	if (IS_DAX(inode))
> -		desc->vm_flags |= VM_HUGEPAGE;
> +		vma_desc_set_flags(desc, VMA_HUGEPAGE_BIT);

Looks good to me,
Acked-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  	return 0;
>  }
>  

