Return-Path: <linux-erofs+bounces-52-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDF6DC28B30
	for <linux-erofs@archiver.kernel.org>; Wed, 12 Mar 2025 01:45:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ZCD3Q0lw1z3bpx;
	Wed, 12 Mar 2025 12:45:22 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1741743922;
	cv=none; b=TXajlkBUZy2GC/c3eRVFCXWZWSpAtd2sqZdU1+JQBbla//oGje5rc3iPA6dogGY/YpoeOhWIoGoyqpCv2nQZU4Kom3MAUmJxIpcSoH0NxPSBdeh30Ee5XjOfMVNMe9cA6EJmayBHWo9qyuTK/PIl0KUkfkiq8OpYJunKYR/AipMu8wNG9uhMmgZ5ElM3UqrLOsrGXkWtuzDlfmViOb/AzdqHsd3eeJUno9xUdn7n8T/CkwR+5+vw17gs2bcWzS9r9zExDfdwmZpuwskcdjsjZaKh0IAHMRRmlvPFHmv2KotBNHEtBMoXbRvwzrKcSLjBiAIF2nztdI396e2pBhP2WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1741743922; c=relaxed/relaxed;
	bh=pJsIAiBQwxxlPupaINFvaIjtvwWgE2QzMrLd5G9yQKs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XYBy/iETYjH6+gG5AFSLgW1RDiV1FTUqX184airbDiiM9ffZv62+3R6jDDxD4t8VA8714JVjR/nQ96QrBLw1cH1j2ogFlCoiu1in2nq3TV4bmucFFkzfhu1ENABfZyC3zKE6Tyy/8aUe+Rd5poCNUTZb9wj9WPJVMt5J0G8EuI1PKKPaGcEVoelSB8OaPo+L0z51hSaroAKNmeJEEN2VLht23IC02e1R44nTVKYlIemaUEs67MG5cI0XHdb/9UcXiuyCqde/u1HfecUXvYyoDlT3nvgCTZaEeLaDHXrV2fn4WUBfH/ZfharyjTnPym1b32HE+IrKxuEzunyu/IgXsA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=T4p5PI+/; dkim-atps=neutral; spf=pass (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=T4p5PI+/;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ZCD3M6j12z3bp7
	for <linux-erofs@lists.ozlabs.org>; Wed, 12 Mar 2025 12:45:18 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1741743914; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=pJsIAiBQwxxlPupaINFvaIjtvwWgE2QzMrLd5G9yQKs=;
	b=T4p5PI+/FFra7ELZyIkX3qB9kIUPLMqTU+Lu5jAlgNbcKuMOLcUHiWqEkGV//CS3XtBi/1wFch7sxaBmeH7QAQJ46VD9lBJ+Rom3mmNcX9ZZrFBxUANwDqReKGsWyvrdfxDzy9Hj+NxOHiYYKS1D+NccfdmSxUAtCVoAnc8s7JY=
Received: from 30.74.129.75(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WRAiBpj_1741743910 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 12 Mar 2025 09:45:11 +0800
Message-ID: <14ef70cc-beba-4abb-b206-e9fb29381023@linux.alibaba.com>
Date: Wed, 12 Mar 2025 09:45:10 +0800
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: alloc_pages_bulk: remove assumption of populating
 only NULL elements
To: NeilBrown <neilb@suse.de>
Cc: Yunsheng Lin <linyunsheng@huawei.com>,
 Yunsheng Lin <yunshenglin0825@gmail.com>, Dave Chinner
 <david@fromorbit.com>, Yishai Hadas <yishaih@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Carlos Maiolino <cem@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Trond Myklebust <trondmy@kernel.org>,
 Anna Schumaker <anna@kernel.org>, Chuck Lever <chuck.lever@oracle.com>,
 Jeff Layton <jlayton@kernel.org>, Olga Kornievskaia <okorniev@redhat.com>,
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
 Luiz Capitulino <luizcap@redhat.com>,
 Mel Gorman <mgorman@techsingularity.net>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
 linux-nfs@vger.kernel.org
References: <> <316d62c1-0e56-4b11-aacf-86235fba808d@linux.alibaba.com>
 <174173371062.33508.12685894810362310394@noble.neil.brown.name>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <174173371062.33508.12685894810362310394@noble.neil.brown.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2025/3/12 06:55, NeilBrown wrote:
> On Mon, 10 Mar 2025, Gao Xiang wrote:
>>
>>    - Your new api covers narrow cases compared to the existing
>>      api, although all in-tree callers may be converted
>>      properly, but it increases mental burden of all users.
>>      And maybe complicate future potential users again which
>>      really have to "check NULL elements in the middle of page
>>      bulk allocating" again.
> 
> I think that the current API adds a mental burden for most users.  For
> most users, their code would be much cleaner if the interface accepted
> an uninitialised array with length, and were told how many pages had
> been stored in that array.> 
> A (very) few users benefit from the complexity.  So having two
> interfaces, one simple and one full-featured, makes sense.

Ok, I think for this part, diferrent people has different
perference on API since there is no absolutely right and
wrong in the API design area.

But I have no interest to follow this for now.

Thanks,
Gao Xiang

