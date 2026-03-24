Return-Path: <linux-erofs+bounces-2977-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D41B2F54AD6
	for <linux-erofs@archiver.kernel.org>; Tue, 24 Mar 2026 23:12:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fgQmM38xNz2xlf;
	Wed, 25 Mar 2026 10:12:19 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774393939;
	cv=none; b=eYeLgJuvR7yFYf1lop1+tEJri7PICEIyaPn4kVGbLjXLyE2PcSepiRiux2rReh+9lx0KkYDTmckNlt66Go6walsTNZgrN7B13A9IakkS9D/NK65SIdjML8U7f5KJ9riVSo7JVb6ZqqEfHsZpN/5RLaKkcmh0RcGu2Ctyhltp4KCLjtsxP6CFZEko0cjVJdS5xwbfS8e9QGANRuI8WLr7zqi6L50D+SRdBpn6UQB6LeCLHhATN+/+iyDfM0zCHmP9ureYhrpLIHUk4zvZZ8160Db5DNWbKPQiyI27PDRZ1kDl6AHZEDnMptaQGvzYOrp1VHSA6OYdst0NpcMXKDELCw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774393939; c=relaxed/relaxed;
	bh=eD92WmlD057XTMfLH1Z3GAggqz7pk4b/GXmngytedTo=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=aw61sgFVOBiD4FOFAjIc2Clq6dQeafoY5HjRGQO7I9iK1MA+Hk8UwM/3oQJ3ffbQqYvff51IrflFSLh8KZ6zPxqjMPM18rOyJUTbrItDG18gfMwwWK4GYFt4LfV5/lCK/9lFErfbWMBHo/re6hFyYi6YPfFQbqdh7cWQtrvAL7lzS7LlgjDNuTHcYez27Bl2Np7vfB6+CicBDFPkyAPulYWxx9K9NNl0nQh4VpVTWL5Gho2b8O/cbA5b/cw24GX8famqdp66QxBWSjXIimqwiughIKnUPBrA/VpBLNXUmzMHfVUuYvJXVI5x5kUObhEy/o1lfHT1ZiDs4jJXssBf4w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; dkim=pass (1024-bit key; unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QLTwz3SH; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=akpm@linux-foundation.org; receiver=lists.ozlabs.org) smtp.mailfrom=linux-foundation.org
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QLTwz3SH;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux-foundation.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=akpm@linux-foundation.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fgQmL5SZqz2xd6
	for <linux-erofs@lists.ozlabs.org>; Wed, 25 Mar 2026 10:12:17 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D603660103;
	Tue, 24 Mar 2026 23:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B43C2BCB1;
	Tue, 24 Mar 2026 23:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774393934;
	bh=ptwwHbLCf3qQFNvLf2dqckDDyShAhKmxD+qHZ2Ems8w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QLTwz3SHw1yDMUT8EK0RImQOiTezzgyIr6GaoUCK96d78VHIYEHGoiZrsBICY0RY4
	 prdPg7dDS7EU+/v8oFdgaCjXtOnqW1Knnhb837S/tRUqZeShz4gGiX5ErTjUgItBsG
	 VAlZfcP28RfcIDXSiBthAZwtM/tBDNz0XMg79lmI=
Date: Tue, 24 Mar 2026 16:12:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu
 <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep
 Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, Chunhai
 Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>, Oscar
 Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Tony Luck
 <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, Dave
 Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, Babu Moger
 <babu.moger@amd.com>, Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota
 <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Pedro
 Falcato <pfalcato@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-mm@kvack.org, ntfs3@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/6] mm: add vma_desc_test_all() and use it
Message-Id: <20260324161212.4b0a6f4fd5eb57ff2ffa7ea5@linux-foundation.org>
In-Reply-To: <568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
References: <cover.1772704455.git.ljs@kernel.org>
	<568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
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

On Thu,  5 Mar 2026 10:50:15 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> erofs and zonefs are using vma_desc_test_any() twice to check whether all
> of VMA_SHARED_BIT and VMA_MAYWRITE_BIT are set, this is silly, so add
> vma_desc_test_all() to test all flags and update erofs and zonefs to use
> it.
> 
> While we're here, update the helper function comments to be more
> consistent.
> 
> Also add the same to the VMA test headers.

fwiw, we have no review tags on this one.

