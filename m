Return-Path: <linux-erofs+bounces-4588-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3722EC982DE
	for <linux-erofs@archiver.kernel.org>; Mon, 21 Sep 2026 08:46:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hpGzH3xyVz2xdb;
	Mon, 21 Sep 2026 18:46:03 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:41d0:1004:224b::ac"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789980363;
	cv=none; b=edjw+2wUdJSEGCTAWhQY7TVu6UAQ3k/visuZIgv4lIaS2MSsSN6mbdccpzwgiL0KkPrvTh9N0mzXvPJSagVdSem2qpjE0QEQ9zrbI9inT+66eEQ31bfvZt/ym5Ku7Ns87wpA82jUEuYFIC4FUbJG1YYJSAs64p+kGfrC9AZKjC2PzAzF/eq5p+NfNtohBVaxf6rYSyA7JEOBcXxG7XSMvmVWOA6Wm97cOj2FpZz9Zk57VbRli4/Lv91As2/22+XF4IbfzCj99nDxdUL6tF97Pgpqsd5qnDdxpIlJq2atgpMcrb++25UXBCtbWJx6MLokIOVqGdOXvgMX5b8SyHA+3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789980363; c=relaxed/relaxed;
	bh=BcFs4Wd4VaC8wyaDxYNPmIuUNckeXL3HDIxn9D7Ssf8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KQmmRal26HXlAMAb8aoBubraOvuVgOxMH0Q/5O6cyhM9e0G5Y2GA9Wt9YcPIEtadsEeeXtY5/AWI1ZP4spQPCALPTvRo8fKXv0f5zVIqShIxAWjsYe//uH6QpROt31759bCy/9aES/9IDRgm5W6NV+PPHl7sXsRY08U23HduU2d9YlaU6h1pE8cICs2GlZQg3VHqUpHd7WNjBecQMotIcKIb3yoaGEDikxTjT+uta+boDckiIQCG2btzN31N2TIkZ4GBudGXgRM4CSBw+OroBPgOBKPh5jjjp+oKoz+vfuDPnVEV6T3BRkbf8YYuegO4/taUQixtC1b5Zrjzt2FvLA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.dev; dkim=pass (1024-bit key; unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IU2OC7Zf; dkim-atps=neutral; spf=pass (client-ip=2001:41d0:1004:224b::ac; helo=mta0.migadu.com; envelope-from=lance.yang@linux.dev; receiver=lists.ozlabs.org) smtp.mailfrom=linux.dev
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IU2OC7Zf;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.dev (client-ip=2001:41d0:1004:224b::ac; helo=mta0.migadu.com; envelope-from=lance.yang@linux.dev; receiver=lists.ozlabs.org)
Received: from mta0.migadu.com (out-172.mta0.migadu.com [IPv6:2001:41d0:1004:224b::ac])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hpGzD3Vlcz2xbQ
	for <linux-erofs@lists.ozlabs.org>; Mon, 21 Sep 2026 18:45:58 +1000 (AEST)
X-Envelope-To: linux-erofs@lists.ozlabs.org
DKIM-Signature: a=rsa-sha256; bh=uUTNbuu97K8eZK4ytwE6k6w7euavFhJ9/KPf1WBW8ww=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789980340; v=1; x=1790585140;
 b=IU2OC7Zf5Nx0l9zwr64c0CHTEszc6ygN4zBuSydvp3xsipHTlIYk8b1YFFWhp7KHPOQu0w41
 qoaKC0Z3zLmSBxDTY7biA8g7Qv/RyiOmeLDpPL9edppOXCv3E7DQJAmI3FR6a5A4wfFT5uuMGQt
 NKtsiF6fWPLjEaXZpIlyeVHA=
X-Envelope-To: linux-erofs@lists.ozlabs.org
Received: by smtp.migadu.com with ESMTPS id 6597ae8b033e4958;
	Mon, 21 Sep 2026 08:45:22 +0000
X-Mizu-Trace-ID: 6597ae8b033e4958
X-Migadu-Flow: FLOW_OUT
Message-ID: <37d369cc-dac6-43e7-83a8-a5ecdab0d1f3@linux.dev>
Date: Mon, 21 Sep 2026 16:45:03 +0800
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
Subject: Re: [PATCH v5 09/17] erofs: use folio_attach/detach_private() instead
 of direct assignment
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Dev Jain
 <dev.jain@arm.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 linux-kernel@vger.kernel.org, Gao Xiang <xiang@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Barry Song <baohua@kernel.org>,
 Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Sandeep Dhavale <dhavale@google.com>,
 Michal Hocko <mhocko@suse.com>, Gregory Price <gourry@gourry.net>,
 Hongbo Li <hongbohbli@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Kairui Song <kasong@tencent.com>, Chunhai Guo <guochunhai@vivo.com>,
 linux-erofs@lists.ozlabs.org, Qi Zheng <qi.zheng@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Muchun Song <muchun.song@linux.dev>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
 <20260920-remove-pg_private-v5-9-bb68b6a21869@nvidia.com>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260920-remove-pg_private-v5-9-bb68b6a21869@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/9/21 10:28, Zi Yan wrote:
> erofs_onlinefolio_init/split/end() use folio->private without setting
> PG_private or increasing folio refcount and it works. But after PG_private
> is replaced by checking folio->private in a future commit, it can break
> folio_expected_ref_count(), since the folio has private data without
> elevated refcount. Change them to use folio_attach/detach_private().
> Folios during this process are locked as they are in the process of
> readahead, so no parallel migration/folio split can happen.
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
> Assisted-by: LLM
> To: Gao Xiang <xiang@kernel.org>
> To: Chao Yu <chao@kernel.org>
> Cc: Yue Hu <zbestahu@gmail.com>
> Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
> Cc: Sandeep Dhavale <dhavale@google.com>
> Cc: Hongbo Li <hongbohbli@tencent.com>
> Cc: Chunhai Guo <guochunhai@vivo.com>
> Cc: linux-erofs@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Gao Xiang <xiang@kernel.org>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM! Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

