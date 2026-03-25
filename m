Return-Path: <linux-erofs+bounces-3003-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88C5C109C02F
	for <linux-erofs@archiver.kernel.org>; Wed, 25 Mar 2026 16:09:57 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fgsLX14zcz2yTK;
	Thu, 26 Mar 2026 03:09:56 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774454996;
	cv=none; b=XuwtH76cihv+pcmacAyYa9y+7zM8+ExmU7oZyOVuNIEiuDPhkqs9sWGAdaizoWevoQUQwFC2gN1y0Nzy5enPonMQYo/c9aaUifuvO+z41LSjrg851n1qrBA0ThFYdxsLVmfmmcHyw0o9a1I876iTmP22nq+mZqbZxq4Oj65ZiMs1U2GOYRuZ9ZE0uXlWVEEznSthZx0Vlzg4wmohfU/Iwb8b0fSlVjW82HMGLuQ6/2KwuEcsQekwcHGFOWMB+BsoOORFsm67UkkGxjHkyjrC74rXmq8GgstmX0waZhW21E9jJzMdASc2+K8KCHn2U7y79wTKGvx4OdrffqA/Tp1Kkg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774454996; c=relaxed/relaxed;
	bh=9hvko/myVXBSL3XjUJs7M6eNXPWsG85odKtJdX4y2Yg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Am4AIvKogdQbvw+/0jkJ8sRAYqZZIlOvCA+IcFIv6wKnvxItRyrrp64XVRiRpHH6xYyC+24AMPShC4yR/6ufjZ4ePbLtKtqLGCSAlELCB5tmYTDy+WQwGSTdJBcI+LZzdwbr3/8OYeBbJwZ5HmtIV96/dLII5cgTx2+rFDejooYIl1quMNQHOMxL74pJRQlgFcNGh1zfglAuphrhtnyTqLAKr/fCbd6b/SUYxCF0yrEVp59G1Mc60L9wPceHpwNYpV7iJ+bLZk1Gzw8NYeW3iL85BjiU0GRxJKvVEqB0HUWlD9rkcRTkJivjOhggIdCNV1T+hojxaKM/AgLPg0wemw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; dkim=pass (1024-bit key; unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yu2nTqTr; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=akpm@linux-foundation.org; receiver=lists.ozlabs.org) smtp.mailfrom=linux-foundation.org
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yu2nTqTr;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux-foundation.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=akpm@linux-foundation.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fgsLW0mJmz2ySc
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Mar 2026 03:09:54 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CB73600AC;
	Wed, 25 Mar 2026 16:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBA3C4CEF7;
	Wed, 25 Mar 2026 16:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774454991;
	bh=CpwACGnKbmh8bnL86Y86WsKuJUxg5abhUqwLWbX/48s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=yu2nTqTr+4Ixa0aIK77JmVd/k21R9kBHnAAnN62dMDBskTZPMj6ItigXaNiPWYaDN
	 owILDdRj9CR94Ne+mlXhFs0xeZET+j+BL7Wc2PyC7Y5JlWmPDlJwczr1b4LsYZy2nY
	 cP83/jsCsjO9VMlXX+z1yugQE+WA+BNaE8wcuZeA=
Date: Wed, 25 Mar 2026 09:09:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Arnd Bergmann <arnd@arndb.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams
 <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave
 Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, Chao Yu
 <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, Jeffle Xu
 <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, Hongbo
 Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@kernel.org>, Konstantin Komarov
 <almaz.alexandrovich@paragon-software.com>, Tony Luck
 <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, Dave
 Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, Babu Moger
 <babu.moger@amd.com>, Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota
 <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev,
 linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm: always inline __mk_vma_flags() and invoked
 functions
Message-Id: <20260325090949.795e06f48ec455053db9ae89@linux-foundation.org>
In-Reply-To: <d352055d-06fe-43b2-8ad3-b73ab99683d0@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
	<241f49c52074d436edbb9c6a6662a8dc142a8f43.1772704455.git.ljs@kernel.org>
	<ndtnvnobevdymu5a5tdxdbi4tcsqshs3d6x2vnfgnuclxvgwok@bhbqkzilsets>
	<d352055d-06fe-43b2-8ad3-b73ab99683d0@lucifer.local>
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

On Wed, 25 Mar 2026 14:58:14 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> On Wed, Mar 25, 2026 at 02:54:50PM +0000, Pedro Falcato wrote:
> > On Thu, Mar 05, 2026 at 10:50:16AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > > Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
> > > macro) always being inline, as we rely on the compiler converting this
> > > function into meaningful.
> > 		meaningful what?
> 
> 'into the equivalent compile-time constant code' probably fine.
> 
> Andrew - could you update that if there's time?


np


: Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
: macro) always being inline, as we rely on the compiler converting this
: function into the equivalent compile-time constant code.

what does "compile-time constant code" actually mean?  That constants
within the code are evaluated at compile-time?

