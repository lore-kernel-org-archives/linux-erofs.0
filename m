Return-Path: <linux-erofs+bounces-2513-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5575F30938
	for <linux-erofs@archiver.kernel.org>; Thu,  5 Mar 2026 10:50:52 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fRRCb2fH5z3c95;
	Thu, 05 Mar 2026 21:50:51 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772707851;
	cv=none; b=mQXy3NEyo0CjLnAXn5LNcwpcNGRzZGbUc+k1SPEncvuM+NitgOewivPehg+r0GeRKR+YkbhBo28HuEzeUdsMy1nt0PD7m9KcrBR+AtsWSM8QaDG4zkDrBB3NqoOvE5IJh0MQOTepbay3GdF53l5yuocOtNbLCbRlp79SQFRBhz07tQGoHJ4gCvBXdTqI3WP8kugaRpFo4JE/wsMiDgS8o3qQAaVeCr3waaIG3CJnhkAXYf02aYVZd/lWvWfl31bI838L4OrqtaAgQlPYxC1JnzMCvLLwQsYZqvdL8656vC56VJbmPDNcN2H7RDpnljYg/xtsDDIOFhwgPBTkrc6joQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772707851; c=relaxed/relaxed;
	bh=owoM2jdF5fHOsavpMLD8fR4J8bwGSxjTtC/5RQdL0mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URLG78ZgN2AQ6yFPnnd8jwp56UN/sbO8w/Z/NJ4qxM2BHBrIEa3DRLdoepITko/bY8E//xMT8+S3qvmBOeA4xo4+O+DXY9u3QfKOl1Tx9jzXsiyEuFj3PdSQwuXa8lqHt1TqAuIEGos63VnFbnUwmz0CUh9dze8/2S3pdJuuLJ2Nq+Va0jogicFfXwOI1j/YK/p1nDy1UlR6EMzKIBgtY6KJhw5VNK1zfFCcJwzBIyrCwiowZs7i6rlsk2s4Ir+G1eWKD1Rt+EJlLm5wA09v3aUfDMLwitDdgLaCrP7PRS4N7AoyhwiKUuMvXiTaH+ORNp8C3R0tKpPOlffZWWtg7Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=K69d4D5r; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=ljs@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=K69d4D5r;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=ljs@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fRRCZ46Vtz30MZ
	for <linux-erofs@lists.ozlabs.org>; Thu, 05 Mar 2026 21:50:50 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 04F7D44592;
	Thu,  5 Mar 2026 10:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5D1C116C6;
	Thu,  5 Mar 2026 10:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772707848;
	bh=TF/Y8m2ST7SjfkcrUaxHq0mGyE5PLPgmgeUh4mbmrZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K69d4D5rkvQAOQO0X9LY14GVr8nxRsOyTxPOk3HOl5lilOcGooMFJ1RSYabqmcbgi
	 2Kb4JKE3xl5ujn+rVENRM01RMuTqfN5GJwiDujdpNrnz+/bSi+4/iUwDcrGQaZHKos
	 WXzPNA75E+fgOcKflJ9S1lqO3dtH7VUiIB1E7Hc1lEg87BCGJu+oHuw3etXLaH5ZL1
	 rOurPfYGNpyXfojRseUPlcwfGElAUfDsaU0vtsWbc6yGvwoo83oJQDYFDfivlslCRt
	 kK1RuRQF4zkVJg5hHHManDOSl2kFut9lIrxZm0xduQ2NivqK7NLhoCGGzPedfWaFhz
	 XSvIMevRPsU1Q==
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
Subject: [PATCH 6/6] tools/testing/vma: add test for vma_flags_test(), vma_desc_test()
Date: Thu,  5 Mar 2026 10:50:19 +0000
Message-ID: <376a39eb9e134d2c8ab10e32720dd292970b080a.1772704455.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772704455.git.ljs@kernel.org>
References: <cover.1772704455.git.ljs@kernel.org>
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

Now we have helpers which test singular VMA flags - vma_flags_test() and
vma_desc_test() - add a test to explicitly assert that these behave as
expected.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 tools/testing/vma/tests/vma.c | 36 +++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
index f031e6dfb474..1aa94dd7e74a 100644
--- a/tools/testing/vma/tests/vma.c
+++ b/tools/testing/vma/tests/vma.c
@@ -159,6 +159,41 @@ static bool test_vma_flags_word(void)
 	return true;
 }
 
+/* Ensure that vma_flags_test() and friends works correctly. */
+static bool test_vma_flags_test(void)
+{
+	const vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+					       VMA_EXEC_BIT, 64, 65);
+	struct vm_area_desc desc;
+
+	desc.vma_flags = flags;
+
+#define do_test(_flag)					\
+	ASSERT_TRUE(vma_flags_test(&flags, _flag));	\
+	ASSERT_TRUE(vma_desc_test(&desc, _flag))
+
+#define do_test_false(_flag)				\
+	ASSERT_FALSE(vma_flags_test(&flags, _flag));	\
+	ASSERT_FALSE(vma_desc_test(&desc, _flag))
+
+	do_test(VMA_READ_BIT);
+	do_test(VMA_WRITE_BIT);
+	do_test(VMA_EXEC_BIT);
+#if NUM_VMA_FLAG_BITS > 64
+	do_test(64);
+	do_test(65);
+#endif
+	do_test_false(VMA_MAYWRITE_BIT);
+#if NUM_VMA_FLAG_BITS > 64
+	do_test_false(66);
+#endif
+
+#undef do_test
+#undef do_test_false
+
+	return true;
+}
+
 /* Ensure that vma_flags_test_any() and friends works correctly. */
 static bool test_vma_flags_test_any(void)
 {
@@ -334,6 +369,7 @@ static void run_vma_tests(int *num_tests, int *num_fail)
 	TEST(vma_flags_unchanged);
 	TEST(vma_flags_cleared);
 	TEST(vma_flags_word);
+	TEST(vma_flags_test);
 	TEST(vma_flags_test_any);
 	TEST(vma_flags_clear);
 }
-- 
2.53.0


