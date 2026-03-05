Return-Path: <linux-erofs+bounces-2511-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E64E7F30930
	for <linux-erofs@archiver.kernel.org>; Thu,  5 Mar 2026 10:50:46 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fRRCT3Hzxz3c8s;
	Thu, 05 Mar 2026 21:50:45 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772707845;
	cv=none; b=JvnpZfSGTpDM62EO0mnwudLbNh+11HeUcW2MgHP3CN2mWN3wNf/+JeCpzN5jKQlAtIQyeWsus07SqLIDL4uc/u4d3/viIvJW3cxsjM4tRjNF/1lwPcNitE7VWf6OYGRTge2sVgFyEBjPScEDFH/wDwPNQTj4QnMmRHaB8g/gUP83SAr+ddCYENciYsZYemc0LCA3XAWK8ujnLN0Aef9UBOD60cGjLcHcLDu4V0mjW6fKsbTq1J+YHYb6clL96uBwtSMGsZHLujPd6EnYmbWxBpxLiGrPuEK4puF60I0NFF8cjB8Ln7CZUpR/oqwDbTtrpBlMasP0rzDXZPzAzpQx/A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772707845; c=relaxed/relaxed;
	bh=vRQsrGjKXJR+5Wxo/0yAY1jeVCtiya9R7M4weUno1fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dobl/CCm2K6Xgdfijr3uHzfJLU1UQAQy4jKG008AxXELKmwYGIk/muBXPWH4tIlwVUJlplW1GE2JgiyW1mYmesiUxU4yG9aNY1hJZO0Fs2NQJDjswbahh5viWLs/iSNV2eBcyizFuSetxNn5/m0bNVtggtY3oD7KhoMuLi6pYHaxf6PyxB9ZO5E8hyZpu44F4jje/JB/7YFHhqR8BJOyXArOlXlJvWYgIsRtQviQi8tjLWEzdHXfkpM0dwsQ/tBTI1wknKd2dMxEUDmeIsqUgfm74Z3Z821OZVbRxGuHBXpD1fiyVfSJr33ZbYU2Ymae5ZdzP+hV0CIqOzFL+3/Tjg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=ZnwnEQWp; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=ljs@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=ZnwnEQWp;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=ljs@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fRRCS4zyQz30MZ
	for <linux-erofs@lists.ozlabs.org>; Thu, 05 Mar 2026 21:50:44 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D8632445ED;
	Thu,  5 Mar 2026 10:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23EE8C19422;
	Thu,  5 Mar 2026 10:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772707842;
	bh=K6atPXEwAz6pCpNgSjUNbutgg0Ze42UtzX9vGX/lf1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZnwnEQWppRWj2X12TGMNPtDnaTYkVoE6SscxZf2XjuEV7EAMd5hPqHKmJjNb0couT
	 4Yr/gp9nN20VjAigjL3TT+oUbgvsXjg7/Ngchr1ZaD54JKZbRZ73qB38gEujixGeGv
	 GINuPfK8VIIcOs7b9HhLhT6ob1XPKTe868CSOX9LzAaUFCygQtAA6pK9T2qM+SKukc
	 lwmvOrm2Me7Xdn4E6B0XZtJszykq6mOYjj2lfsdMujilXsAJrPXpnpfI0518yH9B9C
	 7R1lexJePjT6Xn446TcwX5w5HCUlDQBBguymYuFcXM2YbOz5DUroMVLiDxaAhKV0Ch
	 kEWuHUjWY/9mw==
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
Subject: [PATCH 4/6] mm: reintroduce vma_flags_test() as a singular flag test
Date: Thu,  5 Mar 2026 10:50:17 +0000
Message-ID: <f33f8d7f16c3f3d286a1dc2cba12c23683073134.1772704455.git.ljs@kernel.org>
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

Since we've now renamed vma_flags_test() to vma_flags_test_any() to be very
clear as to what we are in fact testing, we now have the opportunity to
bring vma_flags_test() back, but for explicitly testing a single VMA flag.

This is useful, as often flag tests are against a single flag, and
vma_flags_test_any(flags, VMA_READ_BIT) reads oddly and potentially causes
confusion.

We use sparse to enforce that users won't accidentally pass vm_flags_t to
this function without it being flagged so this should make it harder to get
this wrong.

Of course, passing vma_flags_t to the function is impossible, as it is a
struct.

Also update the VMA tests to reflect this change.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm.h              | 17 +++++++++++++++--
 mm/hugetlb.c                    |  2 +-
 mm/shmem.c                      |  4 ++--
 tools/testing/vma/include/dup.h |  8 ++++++++
 4 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 66b90de30bf6..5622d04c9ba9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1051,6 +1051,19 @@ static __always_inline vma_flags_t __mk_vma_flags(size_t count,
 	return flags;
 }
 
+/*
+ * Test whether a specific VMA flag is set, e.g.:
+ *
+ * if (vma_flags_test(flags, VMA_READ_BIT)) { ... }
+ */
+static __always_inline bool vma_flags_test(const vma_flags_t *flags,
+		vma_flag_t bit)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+
+	return test_bit((__force int)bit, bitmap);
+}
+
 /*
  * Helper macro which bitwise-or combines the specified input flags into a
  * vma_flags_t bitmap value. E.g.:
@@ -1957,8 +1970,8 @@ static inline bool vma_desc_is_cow_mapping(struct vm_area_desc *desc)
 {
 	const vma_flags_t *flags = &desc->vma_flags;
 
-	return vma_flags_test_any(flags, VMA_MAYWRITE_BIT) &&
-		!vma_flags_test_any(flags, VMA_SHARED_BIT);
+	return vma_flags_test(flags, VMA_MAYWRITE_BIT) &&
+		!vma_flags_test(flags, VMA_SHARED_BIT);
 }
 
 #ifndef CONFIG_MMU
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8286c5db2c12..bd9f3b2d2cb0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6591,7 +6591,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	 * attempt will be made for VM_NORESERVE to allocate a page
 	 * without using reserves
 	 */
-	if (vma_flags_test_any(&vma_flags, VMA_NORESERVE_BIT))
+	if (vma_flags_test(&vma_flags, VMA_NORESERVE_BIT))
 		return 0;
 
 	/*
diff --git a/mm/shmem.c b/mm/shmem.c
index 965a8908200b..5e7dcf5bc5d3 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3086,7 +3086,7 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
 	spin_lock_init(&info->lock);
 	atomic_set(&info->stop_eviction, 0);
 	info->seals = F_SEAL_SEAL;
-	info->flags = vma_flags_test_any(&flags, VMA_NORESERVE_BIT)
+	info->flags = vma_flags_test(&flags, VMA_NORESERVE_BIT)
 		? SHMEM_F_NORESERVE : 0;
 	info->i_crtime = inode_get_mtime(inode);
 	info->fsflags = (dir == NULL) ? 0 :
@@ -5827,7 +5827,7 @@ static struct file *__shmem_file_setup(struct vfsmount *mnt, const char *name,
 				       unsigned int i_flags)
 {
 	const unsigned long shmem_flags =
-		vma_flags_test_any(&flags, VMA_NORESERVE_BIT) ? SHMEM_F_NORESERVE : 0;
+		vma_flags_test(&flags, VMA_NORESERVE_BIT) ? SHMEM_F_NORESERVE : 0;
 	struct inode *inode;
 	struct file *res;
 
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index ef6b9d963acc..630478f0d583 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -844,6 +844,14 @@ static inline vma_flags_t __mk_vma_flags(size_t count, const vma_flag_t *bits);
 #define mk_vma_flags(...) __mk_vma_flags(COUNT_ARGS(__VA_ARGS__), \
 					 (const vma_flag_t []){__VA_ARGS__})
 
+static __always_inline bool vma_flags_test(const vma_flags_t *flags,
+		vma_flag_t bit)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+
+	return test_bit((__force int)bit, bitmap);
+}
+
 static __always_inline bool vma_flags_test_any_mask(const vma_flags_t *flags,
 		vma_flags_t to_test)
 {
-- 
2.53.0


