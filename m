Return-Path: <linux-erofs+bounces-486-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75993C77B7F
	for <linux-erofs@archiver.kernel.org>; Mon, 23 Jun 2025 12:23:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4bQnLC71Mgz2yF0;
	Mon, 23 Jun 2025 22:23:31 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:8b0:10b:1236::1"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1750681411;
	cv=none; b=c7nLtgFz6pKum8q8y/+Z+QeeXs4bPebN/MZf8+qEB7tOK+YVk9aw3pUJlqed4M01c4ew9vCwDRDQ+SMjqcp5oMyh5/jwsVFw5lTMFd0IJXOb4hLrcbfyO38zHksaYcUynQiifSl9qSz3HgHM4HLVx6n5lNSsylq1Qm7WwKoJ3PdbJqovzPJUBZBijkPrv1ThMdq5vC2rNfW2Codex4IFtQD69PRaSfDDx535N9I0+7hSzsc4osoVXsqw0BvlQiZHlJjZVMgj/H9qAVwefaDXeyRAzdzP+7PtFZKUMnml2r0pWZUjL72UueOK4wkc0RaResoRWslXp6AjCp4qtKeSeg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1750681411; c=relaxed/relaxed;
	bh=3oCr8/2E/ECUGMdCQG5uK2s/rAaWdb4SF8d9yHw1SGc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h5rULcfX0/nSvOY7SSC1GoKtfhjdIc9YisUUuUMpEE9+6PwNQMaXeO3auKOfYFZfjMSpy4UBT0uklkdynYK9+2AU4lT7Dy3O/ANVi5PCXA9m2yb6mclHPZd/NfPIQgxZKZj8NO2ygI576A4ofwPyBhp8U8vTP9WmtrA/nXK2qPoY7nV6E/BK7Fd/jdG29tHfCFffU5bEy+p9KvOBEEluJzUPLvz97n8Q3uHc22PlBjxn/fpHoZ2QtW77R2iRIs2Yw1y+jmckGfFpdGFr0kWZehldv2aGT3PQmXjlIwWaAqlw/846OxXasmo1xZR1zVnJvuo8B+wTc409YngizPIijg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=LnNB/HnR; dkim-atps=neutral; spf=none (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=LnNB/HnR;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=infradead.org (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4bQnL42FbHz2xRq
	for <linux-erofs@lists.ozlabs.org>; Mon, 23 Jun 2025 22:23:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3oCr8/2E/ECUGMdCQG5uK2s/rAaWdb4SF8d9yHw1SGc=; b=LnNB/HnRw1ZuK8fdt8rSMJ2ZYs
	q+mW5oayHUBd2qfRNZL5j0uUh9ko/ejIS840XHJrbvp0XXsnPshvxo22sJ2/tdoYi6ERn4uQPoids
	wWMoD9y+CL3Eubvm4JTJtsfBUMB3K5F7LRxS8wdG6bSZK4z6byuJQYa85lbqNFDJRZj4Ia/+OYd8d
	9ipCORuobaKsyF0cXHA8WHbUY6oPA7b/XkqQtx4BeOji44BWo4jJcuXOvV5cy7UrNymptQgKKmQ04
	nj/lr96lizIJt52vWyInxpNXHVuHv8TrB4k/r+WH2R08hi5XIz+wWuYWais41pGsOlRtF3aaeYV3n
	Lx7l0xHw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uTgCR-00000003OC9-0JQF;
	Mon, 23 Jun 2025 12:22:59 +0000
Date: Mon, 23 Jun 2025 13:22:58 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Shivank Garg <shivankg@amd.com>
Cc: kent.overstreet@linux.dev, clm@fb.com, josef@toxicpanda.com,
	dsterba@suse.com, xiang@kernel.org, chao@kernel.org,
	jaegeuk@kernel.org, akpm@linux-foundation.org, david@redhat.com,
	vbabka@suse.cz, zbestahu@gmail.com, jefflexu@linux.alibaba.com,
	dhavale@google.com, lihongbo22@huawei.com, pankaj.gupta@amd.com,
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH V2 1/2] mm/filemap: Add NUMA mempolicy support to
 filemap_alloc_folio()
Message-ID: <aFlHIjLBwn3LQFMC@casper.infradead.org>
References: <20250623093939.1323623-4-shivankg@amd.com>
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
In-Reply-To: <20250623093939.1323623-4-shivankg@amd.com>

On Mon, Jun 23, 2025 at 09:39:41AM +0000, Shivank Garg wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Add a mempolicy parameter to filemap_alloc_folio() to enable NUMA-aware
> page cache allocations. This will be used by upcoming changes to
> support NUMA policies in guest-memfd, where guest_memory needs to be
> allocated according to NUMA policy specified by the VMM.
> 
> All existing users pass NULL maintaining current behavior.

I don't want to see this as a separate series.  I want to see it as part
of the series that introduces the user.

Andrew, please drop these two patches from your tree.

