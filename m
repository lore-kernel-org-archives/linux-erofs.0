Return-Path: <linux-erofs+bounces-4587-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 145E6C982DE
	for <linux-erofs@archiver.kernel.org>; Mon, 21 Sep 2026 08:22:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hpGS06VK2z2xdb;
	Mon, 21 Sep 2026 18:22:24 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:41d0:1004:224b::1c"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789978944;
	cv=none; b=IvwWOMMeU+8mPXkw9KCUWZaiwTFSYXzcqg4VDJId6iXs31hPJQ8ynG3skvBTEH4i0Z/8xDweXl35s3cnPadsCLBEmDIXY4cFzyenYBrINR13Zbh4gFpiCCPAa2c7U/yXRDmupky7NN5ZH4NdMs0vo/uz5pmdwCQp4+uafsoGBCTt44H+2K8jBACNY7X4oWlbSf6QapgvthzgoVJVAKmCnIoIV/Tt7Vr539f7tTeFTiFN3TcHt65woOlthTjpJbw7sLqHRsAPGkb41oYbelJ5SIExQVs8CtYcadv0JeVilaa3FwnoSDNJId0r5EaKTDLh6u9aEip1xo4JyAD/iGa6Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789978944; c=relaxed/relaxed;
	bh=pQrVdrIXKT+mdbFaer35dB4HjLy6wUnP3qN7KblpCwQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RC2aNEs4Px6kG95Ya/Rd8kYE0c9OK1eJ/jXUsxgzwZrbAffuBV/hn0WwbypffSSLYrZlVkWf4tMneGFGX6dYp2zRpCdXZMNUq33lUxY/BQHbchvIor7NsKKgKpOL6aaQ4qYrUbPF+cGorL9acmlowbPfsZpx6T7H6WAJksaldDVYwzI6iWlzOR/HjTAnLUTOvhsi2ZXmUzHjVvaLJWLeGKi82R1sahdqAgGGGY97KEekd+JcFM+s4loZv08mB3hyAE8I5cfJSuPaoZq73+lKpD1xhYRd8zz3moi93FNPgnWu1UZ+HEtvMI7VS4PJ+Kd4QdtaDzACXZV2/J0DawMtIQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.dev; dkim=pass (1024-bit key; unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XIddjoCy; dkim-atps=neutral; spf=pass (client-ip=2001:41d0:1004:224b::1c; helo=mta0.migadu.com; envelope-from=lance.yang@linux.dev; receiver=lists.ozlabs.org) smtp.mailfrom=linux.dev
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XIddjoCy;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.dev (client-ip=2001:41d0:1004:224b::1c; helo=mta0.migadu.com; envelope-from=lance.yang@linux.dev; receiver=lists.ozlabs.org)
X-Greylist: delayed 80 seconds by postgrey-1.37 at boromir; Mon, 21 Sep 2026 18:22:21 AEST
Received: from mta0.migadu.com (out-28.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hpGRx1hx6z2xbQ
	for <linux-erofs@lists.ozlabs.org>; Mon, 21 Sep 2026 18:22:20 +1000 (AEST)
X-Envelope-To: linux-erofs@lists.ozlabs.org
DKIM-Signature: a=rsa-sha256; bh=aoprAUYmUN2jwm3AkI2t0iJil/x7yD8M/lNnyU1MNmM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789978922; v=1; x=1790583722;
 b=XIddjoCy7+218rV8IvY5JyAdrw5iv/zl5cnelgP58TCWCALO1KOkqCSAx5o9xBwTPEjF2TI/
 5dV7zCR+8Vd1rxs9EuSzcyWrEiyd8KRbx3f09uwLidfsTpnZyR815KjrMmgrNpUqu7UiG0zhKyT
 yqkRWkDPzzQO9/H054TaJ2B0=
X-Envelope-To: linux-erofs@lists.ozlabs.org
Received: by smtp.migadu.com with ESMTPS id 3d02c4ea80ac0ea7;
	Mon, 21 Sep 2026 08:20:20 +0000
X-Mizu-Trace-ID: 3d02c4ea80ac0ea7
X-Migadu-Flow: FLOW_OUT
Message-ID: <86f06c26-5318-4196-b792-0662ad64f2bf@linux.dev>
Date: Mon, 21 Sep 2026 16:20:01 +0800
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
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/17] erofs: mm/pagemap: add readahead_folio_last() to
 avoid folio->private
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, linux-kernel@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Gao Xiang <xiang@kernel.org>,
 Chao Yu <chao@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Nico Pache <nico.pache@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Lorenzo Stoakes
 <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>, Yue Hu <zbestahu@gmail.com>,
 Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale
 <dhavale@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Hongbo Li <hongbohbli@tencent.com>, Kairui Song <kasong@tencent.com>,
 "Liam R. Howlett" <liam@infradead.org>, Chunhai Guo <guochunhai@vivo.com>,
 linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
 Ying Huang <ying.huang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
 <20260920-remove-pg_private-v5-8-bb68b6a21869@nvidia.com>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260920-remove-pg_private-v5-8-bb68b6a21869@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/9/21 10:28, Zi Yan wrote:
> erofs needs to traverse readahead folios in reverse order to achieve
> maximum performance by
> 1. reading all folios from readahead_folio();
> 2. storing the prior folio pointer in folio->private;
> 3. traverse from the last folio to the first one.
> 
> Add readahead_folio_last() to achieve the same function without using
> folio->private. __readahead_advance() helper shares readahead_control
> adjustment code among __readahead_folio(), readahead_folio_last(), and
> __readahead_batch() by checking new private member, _forward, of
> readahead_control.
> 
> It prepares for a future commit that replaces PG_private checks with
> !folio->private checks. After switching the checks, erofs's use of
> folio->private without bumping folio refcount can cause unexpected
> outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() becomes
> reachable.
> 
> No functional change intended.
> 
> Assisted-by: LLM
> To: Gao Xiang <xiang@kernel.org>
> To: Chao Yu <chao@kernel.org>
> To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> To: Jan Kara <jack@suse.cz>
> Cc: Yue Hu <zbestahu@gmail.com>
> Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
> Cc: Sandeep Dhavale <dhavale@google.com>
> Cc: Hongbo Li <hongbohbli@tencent.com>
> Cc: Chunhai Guo <guochunhai@vivo.com>
> Cc: linux-erofs@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Nothing jumped out at me, feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

