Return-Path: <linux-erofs+bounces-2507-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71874F30937
	for <linux-erofs@archiver.kernel.org>; Thu,  5 Mar 2026 10:50:37 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fRRCH2xlbz3c5f;
	Thu, 05 Mar 2026 21:50:35 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772707835;
	cv=none; b=c9O5ySqWpq6KEhxPWTkx/+rKFpzc+5LeuMu0JMU7i3mEptJpW285W+dGPNdTE6n5GaREdaxc34ZbXVixaMPvDYD4VsyDvTcdGjqA23OE0Fdp0J06c0Cl0vWKOoWjyWErzKZtqAd1KVeAZxxJDq4miNumhbd90/Blprg0Ki1406d0ww0o/63VsckUAVqL9Nzdr565ikCQ1BB0yrDV6z5ZG4F0NDF9eNaSxwDtWBXNEdRal7OrmAlQmGSKJ32gdABCHo4aAZaxOGvqeMGnRTO+q2sY3csr55Rh0z0OBFn7QW8HSebOYJt+p9Ss10jvA++q2MrkEOauCrI5h/8LbKK+7A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772707835; c=relaxed/relaxed;
	bh=KhG9m/1nKVNbvlbE2x8YzN2aakDEcNzRzVMeo+ykMaU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ArwxycvxYiIpvJJ0eSxBOYd9bcVjrMOgPOz6nczqZ1IrngV7wnQG9I+8KWaHq1PlItyHqGEQlrnE63QobaLmIpLr8G3MnlQEyZ3lW4Sr42hiYzTH7HD+Y25qIHD3vjC9LlFr8yznCnxiKy5E3vOfy+o2yBd9CLl7kCDXshXojYTDmGsnP81SW9jAz/5V74ISF38lOqChAVFYroU95VSwfqsU5AlbMQjzy+LtyNNl/97+XPSaoV+iRTionWvF8exXro2R2sP9bz1nQrN4C7CshIqUpbnom8+3XF5uZHQP8m7PwlQz0yIdAo02kuqIFPyHhvUVathZ7u5dCJQhjqbnuA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=Ks2WnXhB; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=ljs@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=Ks2WnXhB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=ljs@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fRRCG0QQvz30MZ
	for <linux-erofs@lists.ozlabs.org>; Thu, 05 Mar 2026 21:50:33 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3146061339;
	Thu,  5 Mar 2026 10:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD7BC116C6;
	Thu,  5 Mar 2026 10:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772707830;
	bh=0/QAvDFwZi+F+9QH+vbMTA5rIfdw8VEPToPzhoxxIs8=;
	h=From:To:Cc:Subject:Date:From;
	b=Ks2WnXhBZhJYCciDsJ/Fjo8g68UnOm1+2N5sQ4oKF/kGeATt0cOgG+p7IStQiz3z2
	 EaiKLpNcYuvQR0g+WTb5buzNJSSfOvUyoPW9kVP1mxiGLOY0aaIL36Y8HeRxCRWjH0
	 xPNNxHX1xyrDEsAcz9u21dlmMcxuEfinuXRzrRvtJ7zbfASMxifc8jFI1uuXm0VkKV
	 vO8JJM2Fd72GNEUcYoWCy/ySVJ/YSjCa2F7WYjhFHDQGWKarW2sHEvezQchoGe9GZ5
	 xra3AjQzJT0q+i6jzWOOPQIuXDSNX56qDPetnPGikvlCk8ESka3PTrdJXR50wB3Usv
	 cHc1r7gvVBIug==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dave Martin <Dave.Martin@arm.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	linux-mm@kvack.org,
	ntfs3@lists.linux.dev,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/6] mm: vma flag tweaks
Date: Thu,  5 Mar 2026 10:50:13 +0000
Message-ID: <cover.1772704455.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
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
Content-Transfer-Encoding: 8bit

The ongoing work around introducing non-system word VMA flags has
introduced a number of helper functions and macros to make life easier when
working with these flags and to make conversions from the legacy use of
VM_xxx flags more straightforward.

This series improves these to reduce confusion as to what they do and to
improve consistency and readability.

Firstly the series renames vma_flags_test() to vma_flags_test_any() to make
it abundantly clear that this function tests whether any of the flags are
set (as opposed to vma_flags_test_all()).

It then renames vma_desc_test_flags() to vma_desc_test_any() for the same
reason. Note that we drop the 'flags' suffix here, as
vma_desc_test_any_flags() would be cumbersome and 'test' implies a flag
test.

Similarly, we rename vma_test_all_flags() to vma_test_all() for
consistency.

Next, we have a couple of instances (erofs, zonefs) where we are now
testing for vma_desc_test_any(desc, VMA_SHARED_BIT) &&
vma_desc_test_any(desc, VMA_MAYWRITE_BIT).

This is silly, so this series introduces vma_desc_test_all() so these
callers can instead invoke vma_desc_test_all(desc, VMA_SHARED_BIT,
VMA_MAYWRITE_BIT).

We then observe that quite a few instances of vma_flags_test_any() and
vma_desc_test_any() are in fact only testing against a single flag.

Using the _any() variant here is just confusing - 'any' of single item
reads strangely and is liable to cause confusion.

So in these instances the series reintroduces vma_flags_test() and
vma_desc_test() as helpers which test against a single flag.

The fact that vma_flags_t is a struct and that vma_flag_t utilises sparse
to avoid confusion with vm_flags_t makes it impossible for a user to misuse
these helpers without it getting flagged somewhere.

The series also updates __mk_vma_flags() and functions invoked by it to
explicitly mark them always inline to match expectation and to be
consistent with other VMA flag helpers.

It also renames vma_flag_set() to vma_flags_set_flag() (a function only
used by __mk_vma_flags()) to be consistent with other VMA flag helpers.

Finally it updates the VMA tests for each of these changes, and introduces
explicit tests for vma_flags_test() and vma_desc_test() to assert that they
behave as expected.

Lorenzo Stoakes (Oracle) (6):
  mm: rename VMA flag helpers to be more readable
  mm: add vma_desc_test_all() and use it
  mm: always inline __mk_vma_flags() and invoked functions
  mm: reintroduce vma_flags_test() as a singular flag test
  mm: reintroduce vma_desc_test() as a singular flag test
  tools/testing/vma: add test for vma_flags_test(), vma_desc_test()

 drivers/char/mem.c                 |   2 +-
 drivers/dax/device.c               |   2 +-
 fs/erofs/data.c                    |   3 +-
 fs/hugetlbfs/inode.c               |   2 +-
 fs/ntfs3/file.c                    |   2 +-
 fs/resctrl/pseudo_lock.c           |   2 +-
 fs/zonefs/file.c                   |   3 +-
 include/linux/dax.h                |   4 +-
 include/linux/hugetlb_inline.h     |   2 +-
 include/linux/mm.h                 | 100 +++++++++++++++++++++--------
 include/linux/mm_types.h           |   2 +-
 mm/hugetlb.c                       |  12 ++--
 mm/memory.c                        |   2 +-
 mm/secretmem.c                     |   2 +-
 tools/testing/vma/include/custom.h |   5 +-
 tools/testing/vma/include/dup.h    |  48 ++++++++++----
 tools/testing/vma/tests/vma.c      |  58 +++++++++++++----
 17 files changed, 177 insertions(+), 74 deletions(-)

--
2.53.0

