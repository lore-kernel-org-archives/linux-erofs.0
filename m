Return-Path: <linux-erofs+bounces-4141-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AB2FC55174
	for <linux-erofs@archiver.kernel.org>; Wed,  5 Aug 2026 04:18:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hFHFx00bmz2xpn;
	Wed, 05 Aug 2026 14:18:13 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785903492;
	cv=none; b=OcH+k3tvj9HhoVzGI1JEaq33mg/mnWXHxAapgZfqknW0rbq3Eg470aE64bMrLb+Vybtg7K+tiDdNSRjkuRz0zX7bL9VaybbKgiXcgNSZGzSxfodAgiNa+gKXndBKpw4E7RahQ1vdy9NDEjWjD4bSJwu0pFDcrsF7InSsiQI8rpEcNp1u3cTHOCtT3RCtL0QqBMRnK0UVoekC6MIAEGcqxuDCXTSYcBPcVL/5Am9LBbWUMN33bSM28E2j3tTgdk38wqSiKew44aElhjtt2SEqobsleYYa10+tpHBmhI9XkqCEjKGSe6eRpb1c+bIaoQ4YQUt13xltwCzbMSj1dnY12g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785903492; c=relaxed/relaxed;
	bh=Hadm6xP+PswyD3AihAYzJPsQQhoLmdR6g4whbLAjP20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RIm4O7vUsuxqdENLBnWPZDpzVtF7cl7ybV6tFVOL2FnadI5aHKNAyvdCV80cLXIKsJrwUVafVMizabONXad8cL8LWtjVq4XIQINwEBWnJsLyHOrCBnxAKIpprQt1UoJwZtFUcctguawxK7yEKx7t56NX4TCDIE2+xyhEgOtuALwGukjcHXd3Y3OWcK3+Hrzen+9qpYWpFc3a/KxrLdSs8TgiWK2JHkCg+Xo8U3FJ97bjqACUjuVCuYQSovXHRx2mvPF/FetEQCQi7J5ZyScZKX8FrJPnI4tQFesc0zsedwbbTfKJ26z6VMvb6nXheAzLrFUoj/jNTX4ZNjO50KaDrg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K2is/aMg; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K2is/aMg;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hFHFv6q5Fz2xnp
	for <linux-erofs@lists.ozlabs.org>; Wed, 05 Aug 2026 14:18:11 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E0141600B1;
	Wed,  5 Aug 2026 04:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5721F000E9;
	Wed,  5 Aug 2026 04:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785903488;
	bh=Hadm6xP+PswyD3AihAYzJPsQQhoLmdR6g4whbLAjP20=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K2is/aMgoIL59CuN3DzHfIlouW8vHEhx5Fs5A+bV+Hqf222GpKlsjBkviC4n4XkcP
	 b71KdhcuPGtMqnGOl2K4xdf8uQq4vp06sDQeVs2+DLnHRcHhOGmDz2aPcWpmj7FopA
	 a0uufkAXnUyfjLV+buwHjQIyGKLW/QrY7pXFi1I5LDSMwXlyBflKB6S62j4pmGM+Cu
	 Pt1CRdcR2vzTcN9y8vczBcB1zBDei2wYoj08MQWVuyxhG+IuImioTovnVRymkhcnrg
	 OmAJwtL67EcOJJ7vtFasWWRkNsSJIiuQl264jCIPP+FBEgmwQpuQ3PdPokROuViOWt
	 4x/Z7RI4bJbAA==
Date: Wed, 5 Aug 2026 12:17:56 +0800
From: Gao Xiang <xiang@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Gao Xiang <xiang@kernel.org>, David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC 08/14] fs/erofs: use folio_attach/detach_private()
 instead of direct assignment
Message-ID: <anK5dIF25xWmaHzW@XiangdeMacBook-Pro.local>
Mail-Followup-To: Zi Yan <ziy@nvidia.com>, Gao Xiang <xiang@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-8-142c97ba3562@nvidia.com>
 <anEnBSAOQE8LyKdI@XiangdeMacBook-Pro.local>
 <DKGNW5NWY73G.2E0EH28C37POP@nvidia.com>
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
In-Reply-To: <DKGNW5NWY73G.2E0EH28C37POP@nvidia.com>

Hi Zi,

On Tue, Aug 04, 2026 at 10:41:23PM -0400, Zi Yan wrote:
> On Mon Aug 3, 2026 at 7:40 PM EDT, Gao Xiang wrote:
> > Hi Zi,
> >
> > On Fri, Jul 31, 2026 at 10:13:31PM -0400, Zi Yan wrote:
> >> erofs_onelinefolio_init/split/end() use folio->private without setting
> >> PG_private or increase folio refcount and it works. But after PG_private is
> >> replaced by checking folio->private in a future commit, it can break
> >> folio_expected_ref_count(), since the folio has private data without
> >> elevated refcount. Change it now.
> >> 
> >> It prepares for a future commit that removes PG_private.
> >> 
> >> No funtional change intended.
> >> 
> >> Assisted-by: Claude:claude-opus-4-8
> >> Assisted-by: Codex:gpt-5
> >> Signed-off-by: Zi Yan <ziy@nvidia.com>
> >> To: Gao Xiang <xiang@kernel.org>
> >> To: Chao Yu <chao@kernel.org>
> >> Cc: Yue Hu <zbestahu@gmail.com>
> >> Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
> >> Cc: Sandeep Dhavale <dhavale@google.com>
> >> Cc: Hongbo Li <hongbohbli@tencent.com>
> >> Cc: Chunhai Guo <guochunhai@vivo.com>
> >> Cc: linux-erofs@lists.ozlabs.org
> >> Cc: linux-kernel@vger.kernel.org
> >
> > It looks fine as long as PG_private flag will be removed in the
> > follow-up patches:
> >
> 
> Hi Gao,
> 
> Sashiko spot an issue in this patch[1]. Basically, ->private can be 0 if
> I/O completes without any issue or being dirty and it causes
> folio_detach_private() not to folio_put(). My fix is to add a bias, 1,
> to the counter, so that ->private stays non NULL throughout online folio
> process. The revised patch is below. Let me know your thoughts. Thanks.
> 

Yes, that is a valid issue: ->private can be decreased to 0 without
folio_detach_private() for a short period so a +1 bias is indeed
a solution.

The following diff looks good to me, you could use it in your next
version.

Thanks,
Gao Xiang

> [1] https://sashiko.dev/#/patchset/20260731-remove-pg_private-v1-0-142c97ba3562%40nvidia.com?part=8
> 
> >From d8fadd13fee03e72c03a718af65ed41927ccbcca Mon Sep 17 00:00:00 2001
> From: Zi Yan <ziy@nvidia.com>
> Date: Thu, 30 Jul 2026 11:04:00 -0400
> Subject: [PATCH] erofs: use folio_attach/detach_private() instead of direct
>  assignment
> 
> erofs_onlinefolio_init/split/end() use folio->private without setting
> PG_private or increasing folio refcount and it works. But after PG_private
> is replaced by checking folio->private in a future commit, it can break
> folio_expected_ref_count(), since the folio has private data without
> elevated refcount. Change them to use folio_attach/detach_private().
> 
> Furthermore, because folio->private is used to store in-flight I/O counter
> and the counter reaches 0 when all I/O completes successfully without error
> or being dirty, ->private=0 causes folio_detach_private() to not drop the
> elevated folio refcount. Solve this issue by using bias=1 for the counter,
> so that ->private stays non NULL throughout every attach-to-detach process.
> Add a macro EROFS_ONLINEFOLIO_BIAS=1. While at it, fix the comment about
> ->private bit layout and add EROFS_ONLINEFOLIO_COUNT_MASK.
> 
> It prepares for a future commit that removes PG_private.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Gao Xiang <xiang@kernel.org>
> To: Chao Yu <chao@kernel.org>
> Cc: Yue Hu <zbestahu@gmail.com>
> Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
> Cc: Sandeep Dhavale <dhavale@google.com>
> Cc: Hongbo Li <hongbohbli@tencent.com>
> Cc: Chunhai Guo <guochunhai@vivo.com>
> Cc: linux-erofs@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  fs/erofs/data.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
> index 9aa48c8d67d12..81e9dab247e0f 100644
> --- a/fs/erofs/data.c
> +++ b/fs/erofs/data.c
> @@ -251,19 +251,23 @@ int erofs_map_dev(struct super_block *sb, struct erofs_map_dev *map)
>  /*
>   * bit 30: I/O error occurred on this folio
>   * bit 29: CPU has dirty data in D-cache (needs aliasing handling);
> - * bit 0 - 29: remaining parts to complete this folio
> + * bit 0 - 28: remaining parts to complete this folio, biased by 1 so that
> + *	       ->private stays non-NULL while the folio is attached
>   */
>  #define EROFS_ONLINEFOLIO_EIO		30
>  #define EROFS_ONLINEFOLIO_DIRTY		29
> +#define EROFS_ONLINEFOLIO_COUNT_MASK	(BIT(EROFS_ONLINEFOLIO_DIRTY) - 1)
> +#define EROFS_ONLINEFOLIO_BIAS		1
>  
>  void erofs_onlinefolio_init(struct folio *folio)
>  {
>  	union {
>  		atomic_t o;
>  		void *v;
> -	} u = { .o = ATOMIC_INIT(1) };
> +	} u = { .o = ATOMIC_INIT(1 + EROFS_ONLINEFOLIO_BIAS) };
>  
> -	folio->private = u.v;	/* valid only if file-backed folio is locked */
> +	/* valid only if file-backed folio is locked */
> +	folio_attach_private(folio, u.v);
>  }
>  
>  void erofs_onlinefolio_split(struct folio *folio)
> @@ -277,14 +281,14 @@ void erofs_onlinefolio_end(struct folio *folio, int err, bool dirty)
>  
>  	do {
>  		orig = atomic_read((atomic_t *)&folio->private);
> -		DBG_BUGON(orig <= 0);
> +		DBG_BUGON((orig & EROFS_ONLINEFOLIO_COUNT_MASK) <= EROFS_ONLINEFOLIO_BIAS);
>  		v = dirty << EROFS_ONLINEFOLIO_DIRTY;
>  		v |= (orig - 1) | (!!err << EROFS_ONLINEFOLIO_EIO);
>  	} while (atomic_cmpxchg((atomic_t *)&folio->private, orig, v) != orig);
>  
> -	if (v & (BIT(EROFS_ONLINEFOLIO_DIRTY) - 1))
> +	if ((v & EROFS_ONLINEFOLIO_COUNT_MASK) != EROFS_ONLINEFOLIO_BIAS)
>  		return;
> -	folio->private = 0;
> +	folio_detach_private(folio);
>  	if (v & BIT(EROFS_ONLINEFOLIO_DIRTY))
>  		flush_dcache_folio(folio);
>  	folio_end_read(folio, !(v & BIT(EROFS_ONLINEFOLIO_EIO)));
> -- 
> 2.53.0
> 
> 
> 
> 
> -- 
> Best Regards,
> Yan, Zi
> 

