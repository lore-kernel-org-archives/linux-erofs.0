Return-Path: <linux-erofs+bounces-3001-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27102109C032
	for <linux-erofs@archiver.kernel.org>; Wed, 25 Mar 2026 15:02:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fgqrS67TTz2xlf;
	Thu, 26 Mar 2026 02:02:16 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774450936;
	cv=none; b=SgdLeh7OG3TU5hzqcEfUeThOjst7H2jxit1u6rOkM8ZwOQP18AIFeLa3+jS6QpQGWWwwRDd/8ZY9FMJgjXOV2cMn56SUCKnjUzzAnxTD6gpHV7NqQu4itSnAdCOnfpa3s35/Ae8sR/qUe5wgcsfumWxzXnpV0836RZSvAA7NnjM3eaNDKLyPRSMNaP0E6YegYogF+Y7g3gg3SpZpiAl5zLr7Fg20kixItjvv6XslEbrUFpCFJ0YQ7in2FjLkfuNlSu8JNo034mzYuVkbnhu5+2jiRkfQEScoXwNB8Ruop5mfBtQy/GomjATc+kmX/Q5vNGNBCCnfKIG6hOV9hxrlCw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774450936; c=relaxed/relaxed;
	bh=ABEIty5HU/Iuw2OOS0KrKkDWBoGWz4KSwuxsAu6g60o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G8EFGZKWEj+9Umth/UbJti4m32xy1fNJQjpcFbcOhcDDg1EChGcmjc4XiOheUr/4U+hbB/GpnpSGL3CqhLsRKUIqN5FByx/h40J5SdhFCUvAOaP621Qh9R6yhSgIt1FlXuGQcS1Erur+pxZckZzyJLkfo6pxGK43uKmwle39TAb40mK8A4UehRDDaCXva5gdqv0U2OmC4O5yRJnCGUhPsW/qLNe6i9yAr2WvsEpgM46i2YpBeoTeajWZcoBP/LFZxtIXGmz8KPAEH5zLrV0xh5UuhiMh/hbiY/dsvzZmzX8wXnO93LYc31wq40kgdkURnZbYABVYYku26kHMEgaOFQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=o5xu8osK; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=ljs@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=o5xu8osK;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=ljs@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fgqrS0LKLz2xS3
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Mar 2026 02:02:16 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E5771600AC;
	Wed, 25 Mar 2026 15:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65A8C19423;
	Wed, 25 Mar 2026 15:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774450933;
	bh=ABEIty5HU/Iuw2OOS0KrKkDWBoGWz4KSwuxsAu6g60o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o5xu8osKy2dzrUDPwu5yoQjTng5YdYUL3822flT0paQIdg9e/BTFYyiUK9l+GQOaG
	 daL6PA8y7R/LiFqAwSF8+W30Ek/zrLCrpDZbuIxfPHWd722GOizks/sJQPO3WIHKiY
	 CfDNk4/1DVhqBnJgdYHY0uK3+4lwi7i9/0fMohc3KEBmauqq+wXvQYmkggDaiV/9jd
	 n0MQgsXT85KVQtgfFBS2M0U4e06lcMT25UiDWCpuonb6xPhwOwgSeYvD8zeYqx0TuD
	 fdzP7hlGmXznOEkuM8BsQ5FWz7XNoTgdBwslAWj6jJVjwgry1e8erDJNwQxk0gKP2h
	 dThIHrt9f4cog==
Date: Wed, 25 Mar 2026 15:02:02 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/6] mm: reintroduce vma_flags_test() as a singular flag
 test
Message-ID: <93f1aa28-1c1f-419e-ba9d-c4b9204336e6@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
 <f33f8d7f16c3f3d286a1dc2cba12c23683073134.1772704455.git.ljs@kernel.org>
 <palfy4jm7iifa44hjkku4ljlwy6mkvyoq5q2v7a2dilb7fpzui@v54cr4xnd443>
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
In-Reply-To: <palfy4jm7iifa44hjkku4ljlwy6mkvyoq5q2v7a2dilb7fpzui@v54cr4xnd443>

On Wed, Mar 25, 2026 at 02:57:22PM +0000, Pedro Falcato wrote:
> On Thu, Mar 05, 2026 at 10:50:17AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > Since we've now renamed vma_flags_test() to vma_flags_test_any() to be very
> > clear as to what we are in fact testing, we now have the opportunity to
> > bring vma_flags_test() back, but for explicitly testing a single VMA flag.
> >
> > This is useful, as often flag tests are against a single flag, and
> > vma_flags_test_any(flags, VMA_READ_BIT) reads oddly and potentially causes
> > confusion.
> >
> > We use sparse to enforce that users won't accidentally pass vm_flags_t to
> > this function without it being flagged so this should make it harder to get
> > this wrong.
> >
> > Of course, passing vma_flags_t to the function is impossible, as it is a
> > struct.
> >
> > Also update the VMA tests to reflect this change.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>
> This is a lot nicer, though I am wondering if there is any difference in
> codegen as well...

Not that I could tell, this was more about cromulence.

>
> --
> Pedro

Thanks, Lorenzo

