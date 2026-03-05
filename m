Return-Path: <linux-erofs+bounces-2518-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 342F0F33A7C
	for <linux-erofs@archiver.kernel.org>; Thu,  5 Mar 2026 15:02:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fRXnc3WCpz3c5f;
	Fri, 06 Mar 2026 02:02:12 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772722932;
	cv=none; b=K3fKqrbuKsrzXQSDU/rZnTHeDENPuyKlNNqVJCs/WzbDmL70mRZWcV6p0CgM6IefV8Mq6PlPoNzvJ0bEUynvEwpMF9TML7H9TDu/4yVnX1GhSujTeh6KSHE+BmG1eKfF5kaCsH/F+/DMI1m9vkmTlG1uVAX0gjM/YXeqDx8X/iTS/Cl7MjR0zLhLJYEwrt9ZydCe6ZrCMyprWoB6SiCFSUxdWQ6TLXnHYQoesdiNVF/yqucppxHssFs86ib00D50elAPVNolgLP0/0iPx/VUyBtsSV8LU5t92pbERyucidKlgPJRGHh+x5TEXHF7ZHNblfNM61D2zgSsfv2DMoOrXg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772722932; c=relaxed/relaxed;
	bh=JM5JonFNOVdHlApqMCLoaabF/YcXP7LkS6bAcjhuBZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lvQzHrgnGGCoJoFc26A1Z6gAcSNuZ0NsGT/OTR+t2rwIPmMAZxLl/5o3CMiVy7JGF0u9h/Nr82G0VoJ+QN46INUocXPOSbqD5r1UpzUV5wO3/9OawjfIhY9WGR3zGvun+kvaAXUDJ7UfYjSgxTtWsZZ1VBGg7hmJ9+GKypm4YctATo5I+NoYjzVvDN0VvXD/gsegxN3Zugl4QkoIpkstMygqSxHYsp58iMH4UYPML5JurXZr3nUJ6Wu3vXN6qqHsHIBhSHGwJrSgcqyaR55PeILdH3+646DWMeuVzPZR9cHWE/2Ty+EMj28opldXeWfqds77sOHyFgeZGPlP8vm5lg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=osfIcpMz; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=ljs@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=osfIcpMz;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=ljs@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fRXnb4dq4z3c2R
	for <linux-erofs@lists.ozlabs.org>; Fri, 06 Mar 2026 02:02:11 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A97943C52;
	Thu,  5 Mar 2026 15:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6767AC2BCAF;
	Thu,  5 Mar 2026 15:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772722929;
	bh=wRgZmhQjr00u6xNwov7+QTN0n9PgF8LRxMXoCLehj2Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=osfIcpMz9xkEHd1thmcRC7ID5peuXO60NX3dAfXWNx8XuxafCP3huQAqeo0Z50NTL
	 7WHXGEd9l4SBIO3qFyZSZs51cQDgZ/txEREq+UVMtkAIWHPQdU6rlIkMwasA+X4H1R
	 0vgTKrOo0sYCn09iGpla9DwhdJK5l6HmDrrqVHFOs3zTPxZNOSLtG7KttSGuKKL7C5
	 CGHdJwOurKzj6Z9/m8NtjplDD54vC/3JtqBAJaS9/CVLprX6BFPrW616tHCOxrmc4G
	 1fXwqivYf5kdVG+FCyXb3KTvQbaG5LkGZXWNmjd7ibSYSDapxeuO3BMr8v1Fwg+Yeu
	 JQAA3sGPUYrCQ==
Date: Thu, 5 Mar 2026 15:01:55 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Tony Luck <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, 
	Babu Moger <babu.moger@amd.com>, Damien Le Moal <dlemoal@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, 
	ntfs3@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 6/6] tools/testing/vma: add test for vma_flags_test(),
 vma_desc_test()
Message-ID: <f6f396d2-1ba2-426f-b756-d8cc5985cc7c@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
 <376a39eb9e134d2c8ab10e32720dd292970b080a.1772704455.git.ljs@kernel.org>
 <f11ec383-d688-4512-a9ea-700cc2d42f3a@kernel.org>
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
In-Reply-To: <f11ec383-d688-4512-a9ea-700cc2d42f3a@kernel.org>

On Thu, Mar 05, 2026 at 02:52:20PM +0100, David Hildenbrand (Arm) wrote:
> On 3/5/26 11:50, Lorenzo Stoakes (Oracle) wrote:
> > Now we have helpers which test singular VMA flags - vma_flags_test() and
> > vma_desc_test() - add a test to explicitly assert that these behave as
> > expected.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > ---
> >  tools/testing/vma/tests/vma.c | 36 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 36 insertions(+)
> >
> > diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
> > index f031e6dfb474..1aa94dd7e74a 100644
> > --- a/tools/testing/vma/tests/vma.c
> > +++ b/tools/testing/vma/tests/vma.c
> > @@ -159,6 +159,41 @@ static bool test_vma_flags_word(void)
> >  	return true;
> >  }
> >
> > +/* Ensure that vma_flags_test() and friends works correctly. */
> > +static bool test_vma_flags_test(void)
> > +{
> > +	const vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
> > +					       VMA_EXEC_BIT, 64, 65);
>
> When already using numbers, I was wondering whether you'd want to stick
> to numbers only here.

Numbers are for flags > 64 bits, we currently don't define any, it's to make
sure everything works at higher bitmap sizes, the tests currently set the bitmap
size to 128 bits.

>
> > +	struct vm_area_desc desc;
>
>
> struct vm_area_desc desc = {
> 	.vma_flags = flags,
> };
>
> ?

Ack can do, fix-patch for Andrew below :)

Cheers, Lorenzo

----8<----
From 5cc64e6c1884aaf995ce6398e36d5844c246352d Mon Sep 17 00:00:00 2001
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Date: Thu, 5 Mar 2026 14:59:58 +0000
Subject: [PATCH] fix

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 tools/testing/vma/tests/vma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
index 1aa94dd7e74a..f6edd44f4e9e 100644
--- a/tools/testing/vma/tests/vma.c
+++ b/tools/testing/vma/tests/vma.c
@@ -164,9 +164,9 @@ static bool test_vma_flags_test(void)
 {
 	const vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
 					      VMA_EXEC_BIT, 64, 65);
-	struct vm_area_desc desc;
-
-	desc.vma_flags = flags;
+	struct vm_area_desc desc = {
+		.vma_flags = flags,
+	};

 #define do_test(_flag)					\
 	ASSERT_TRUE(vma_flags_test(&flags, _flag));	\
--
2.53.0

