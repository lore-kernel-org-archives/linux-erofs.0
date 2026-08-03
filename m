Return-Path: <linux-erofs+bounces-4096-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C2F0C55184
	for <linux-erofs@archiver.kernel.org>; Mon,  3 Aug 2026 23:41:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDY8g2vdqz3080;
	Tue, 04 Aug 2026 09:41:07 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785800467;
	cv=none; b=Q4YZH1UtrYuzYsxSAAsA6OdpLOY7E2Rt+NXg6IBGRr7bvO6VloQvmOFjWlNcDeqbmi2BJ6VxesQW65dALY6h/V61YcLYxz0b2GHzDkJ3NKUazS1Ssg+Fi+Zlgw9E0q6RDBt/Ny0xPp79eA5q0skM3LK5Z5ghGscipWYMC3VQimnyR2rxxliRW0+sBBkQS7nxBANLuOfcI3e2RsS8CMMbk4XtHtFBt43MkIhZhfjmOy0zOphUEno842os5oTJKUKstI8bhD50QxyJ4oFaYI7zpw1KON9Aj+0Q3wbNSxni9RDpcGpQeiaAk3PBLxv+yn09Jn/nXdgh/5RNjYXC16C4SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785800467; c=relaxed/relaxed;
	bh=q4ebMADhzsqGZo4g2q++EvXNBy8Vyr9f7ox5xCdjmho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ctX78HMUg0mXhJaElod6xw14nJGgn5vjvoosq/SGN1VciIeAGYjJhxRRrR6Io6LGcEYt6FyGJtipe6lKE7SO1/iGDFI3HwWa75mA86CXs3Jt1Bb/HRFE99ipuDz5yb9LwfaIhyoEDk/A/uvIjFpYK5EJi/BY4zzN42snFaMVbz+Tp9T6PxkW479RFsLslH9C9zbpb7RhMdm1hiULOK90nxE9cI2jKUuq6VgTVg3dSJk/rX5HVsFuBERKL+qCmxWsPaBSC2LL9BzJTfrbdG78kXuensQXbZZFrKL73V3qcxBX5fav5mbJb0T7y4r3akUAtOd9t/+P0VkNf3hDPOHFbQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M0BJuQs9; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M0BJuQs9;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hDY8f3wj7z307v
	for <linux-erofs@lists.ozlabs.org>; Tue, 04 Aug 2026 09:41:06 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6707741278;
	Mon,  3 Aug 2026 23:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536C21F000E9;
	Mon,  3 Aug 2026 23:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785800463;
	bh=q4ebMADhzsqGZo4g2q++EvXNBy8Vyr9f7ox5xCdjmho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M0BJuQs9xua3UyQqpC0j/HzH7OM14N+1DH/hAcRO2svjCN/3bZujd0RW2lU8qu0gF
	 ms2psthVQ+Nn0B1T4dQrABCA+ZDBBasfUnRp/v5Ge2rO3aOrRBt44JK6kxceO1smfC
	 +NENk9pw7T8+tnz/l1hYduFQgbEGkdavPuUyokC1mw/5s2qQGMvHBI8BNY7u9dCnCn
	 FTya97HCJcY9vSR2Ruzi/PBnCmFr+tfKc7uGUpg+GF6CztprtvmAxO/pgbOWouZ9tp
	 9pZWn6ovDywvRZ3mb2zgd2ZZKbujQRR6deEJmd8zMmKZZPLSZSnghcWfhIKIn9CHEC
	 LmUilB2cQBumQ==
Date: Tue, 4 Aug 2026 07:40:53 +0800
From: Gao Xiang <xiang@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>,
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
	linux-kernel@vger.kernel.org, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC 08/14] fs/erofs: use folio_attach/detach_private()
 instead of direct assignment
Message-ID: <anEnBSAOQE8LyKdI@XiangdeMacBook-Pro.local>
Mail-Followup-To: Zi Yan <ziy@nvidia.com>,
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
	linux-kernel@vger.kernel.org, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-8-142c97ba3562@nvidia.com>
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
In-Reply-To: <20260731-remove-pg_private-v1-8-142c97ba3562@nvidia.com>

Hi Zi,

On Fri, Jul 31, 2026 at 10:13:31PM -0400, Zi Yan wrote:
> erofs_onelinefolio_init/split/end() use folio->private without setting
> PG_private or increase folio refcount and it works. But after PG_private is
> replaced by checking folio->private in a future commit, it can break
> folio_expected_ref_count(), since the folio has private data without
> elevated refcount. Change it now.
> 
> It prepares for a future commit that removes PG_private.
> 
> No funtional change intended.
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

It looks fine as long as PG_private flag will be removed in the
follow-up patches:

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

