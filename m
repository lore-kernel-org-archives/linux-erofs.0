From: hsiangkao@aol.com (Gao Xiang)
Date: Mon, 24 Jun 2019 15:22:53 +0800
Subject: [PATCH v3 3/8] staging: erofs: move per-CPU buffers implementation to
 utils.c
In-Reply-To: <20190624072258.28362-1-hsiangkao@aol.com>
References: <20190624072258.28362-1-hsiangkao@aol.com>
Message-ID: <20190624072258.28362-4-hsiangkao@aol.com>

From: Gao Xiang <gaoxiang25@huawei.com>

This patch moves per-CPU buffers to utils.c in order for
the upcoming generic decompression framework to use it.

Note that I tried to use generic per-CPU buffer or
per-CPU page approaches to clean up further, but obvious
performanace regression (about 2% for sequential read) was
observed.

Therefore let's leave it as it is instead, just move
to utils.c and I'll try to dig into the root cause later.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
change log v3:
 - handle error code if returned by erofs_get_pcpubuf() pointed out by Chao.

 drivers/staging/erofs/internal.h      | 26 +++++++++++++++++++
 drivers/staging/erofs/unzip_vle.c     |  5 ++--
 drivers/staging/erofs/unzip_vle.h     |  4 +--
 drivers/staging/erofs/unzip_vle_lz4.c | 37 +++++++++++----------------
 drivers/staging/erofs/utils.c         | 12 +++++++++
 5 files changed, 56 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index f3063b13c117..dcbe6f7f5dae 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -321,6 +321,16 @@ static inline void z_erofs_exit_zip_subsystem(void) {}
 
 /* page count of a compressed cluster */
 #define erofs_clusterpages(sbi)         ((1 << (sbi)->clusterbits) / PAGE_SIZE)
+#define Z_EROFS_NR_INLINE_PAGEVECS      3
+
+#if (Z_EROFS_CLUSTER_MAX_PAGES > Z_EROFS_NR_INLINE_PAGEVECS)
+#define EROFS_PCPUBUF_NR_PAGES          Z_EROFS_CLUSTER_MAX_PAGES
+#else
+#define EROFS_PCPUBUF_NR_PAGES          Z_EROFS_NR_INLINE_PAGEVECS
+#endif
+
+#else
+#define EROFS_PCPUBUF_NR_PAGES          0
 #endif
 
 typedef u64 erofs_off_t;
@@ -608,6 +618,22 @@ static inline void erofs_vunmap(const void *mem, unsigned int count)
 extern struct shrinker erofs_shrinker_info;
 
 struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp);
+
+#if (EROFS_PCPUBUF_NR_PAGES > 0)
+void *erofs_get_pcpubuf(unsigned int pagenr);
+#define erofs_put_pcpubuf(buf) do { \
+	(void)&(buf);	\
+	preempt_enable();	\
+} while (0)
+#else
+static inline void *erofs_get_pcpubuf(unsigned int pagenr)
+{
+	return ERR_PTR(-ENOTSUPP);
+}
+
+#define erofs_put_pcpubuf(buf) do {} while (0)
+#endif
+
 void erofs_register_super(struct super_block *sb);
 void erofs_unregister_super(struct super_block *sb);
 
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 8aea938172df..08f2d4302ecb 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -552,8 +552,7 @@ static int z_erofs_vle_work_iter_begin(struct z_erofs_vle_work_builder *builder,
 	if (IS_ERR(work))
 		return PTR_ERR(work);
 got_it:
-	z_erofs_pagevec_ctor_init(&builder->vector,
-				  Z_EROFS_VLE_INLINE_PAGEVECS,
+	z_erofs_pagevec_ctor_init(&builder->vector, Z_EROFS_NR_INLINE_PAGEVECS,
 				  work->pagevec, work->vcnt);
 
 	if (builder->role >= Z_EROFS_VLE_WORK_PRIMARY) {
@@ -936,7 +935,7 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 	for (i = 0; i < nr_pages; ++i)
 		pages[i] = NULL;
 
-	z_erofs_pagevec_ctor_init(&ctor, Z_EROFS_VLE_INLINE_PAGEVECS,
+	z_erofs_pagevec_ctor_init(&ctor, Z_EROFS_NR_INLINE_PAGEVECS,
 				  work->pagevec, 0);
 
 	for (i = 0; i < work->vcnt; ++i) {
diff --git a/drivers/staging/erofs/unzip_vle.h b/drivers/staging/erofs/unzip_vle.h
index 902e67d04029..9c53009700cf 100644
--- a/drivers/staging/erofs/unzip_vle.h
+++ b/drivers/staging/erofs/unzip_vle.h
@@ -44,8 +44,6 @@ static inline bool z_erofs_gather_if_stagingpage(struct list_head *page_pool,
  *
  */
 
-#define Z_EROFS_VLE_INLINE_PAGEVECS     3
-
 struct z_erofs_vle_work {
 	struct mutex lock;
 
@@ -58,7 +56,7 @@ struct z_erofs_vle_work {
 
 	union {
 		/* L: pagevec */
-		erofs_vtptr_t pagevec[Z_EROFS_VLE_INLINE_PAGEVECS];
+		erofs_vtptr_t pagevec[Z_EROFS_NR_INLINE_PAGEVECS];
 		struct rcu_head rcu;
 	};
 };
diff --git a/drivers/staging/erofs/unzip_vle_lz4.c b/drivers/staging/erofs/unzip_vle_lz4.c
index 0daac9b984a8..02e694d9288d 100644
--- a/drivers/staging/erofs/unzip_vle_lz4.c
+++ b/drivers/staging/erofs/unzip_vle_lz4.c
@@ -34,16 +34,6 @@ static int z_erofs_unzip_lz4(void *in, void *out, size_t inlen, size_t outlen)
 	return -EIO;
 }
 
-#if Z_EROFS_CLUSTER_MAX_PAGES > Z_EROFS_VLE_INLINE_PAGEVECS
-#define EROFS_PERCPU_NR_PAGES   Z_EROFS_CLUSTER_MAX_PAGES
-#else
-#define EROFS_PERCPU_NR_PAGES   Z_EROFS_VLE_INLINE_PAGEVECS
-#endif
-
-static struct {
-	char data[PAGE_SIZE * EROFS_PERCPU_NR_PAGES];
-} erofs_pcpubuf[NR_CPUS];
-
 int z_erofs_vle_plain_copy(struct page **compressed_pages,
 			   unsigned int clusterpages,
 			   struct page **pages,
@@ -56,8 +46,9 @@ int z_erofs_vle_plain_copy(struct page **compressed_pages,
 	char *percpu_data;
 	bool mirrored[Z_EROFS_CLUSTER_MAX_PAGES] = { 0 };
 
-	preempt_disable();
-	percpu_data = erofs_pcpubuf[smp_processor_id()].data;
+	percpu_data = erofs_get_pcpubuf(0);
+	if (IS_ERR(percpu_data))
+		return PTR_ERR(percpu_data);
 
 	j = 0;
 	for (i = 0; i < nr_pages; j = i++) {
@@ -117,7 +108,7 @@ int z_erofs_vle_plain_copy(struct page **compressed_pages,
 	if (src && !mirrored[j])
 		kunmap_atomic(src);
 
-	preempt_enable();
+	erofs_put_pcpubuf(percpu_data);
 	return 0;
 }
 
@@ -131,7 +122,7 @@ int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
 	unsigned int nr_pages, i, j;
 	int ret;
 
-	if (outlen + pageofs > EROFS_PERCPU_NR_PAGES * PAGE_SIZE)
+	if (outlen + pageofs > EROFS_PCPUBUF_NR_PAGES * PAGE_SIZE)
 		return -ENOTSUPP;
 
 	nr_pages = DIV_ROUND_UP(outlen + pageofs, PAGE_SIZE);
@@ -144,8 +135,9 @@ int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
 			return -ENOMEM;
 	}
 
-	preempt_disable();
-	vout = erofs_pcpubuf[smp_processor_id()].data;
+	vout = erofs_get_pcpubuf(0);
+	if (IS_ERR(vout))
+		return PTR_ERR(vout);
 
 	ret = z_erofs_unzip_lz4(vin, vout + pageofs,
 				clusterpages * PAGE_SIZE, outlen);
@@ -174,7 +166,7 @@ int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
 	}
 
 out:
-	preempt_enable();
+	erofs_put_pcpubuf(vout);
 
 	if (clusterpages == 1)
 		kunmap_atomic(vin);
@@ -196,8 +188,9 @@ int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
 	int ret;
 
 	if (overlapped) {
-		preempt_disable();
-		vin = erofs_pcpubuf[smp_processor_id()].data;
+		vin = erofs_get_pcpubuf(0);
+		if (IS_ERR(vin))
+			return PTR_ERR(vin);
 
 		for (i = 0; i < clusterpages; ++i) {
 			void *t = kmap_atomic(compressed_pages[i]);
@@ -216,13 +209,13 @@ int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
 	if (ret > 0)
 		ret = 0;
 
-	if (!overlapped) {
+	if (overlapped) {
+		erofs_put_pcpubuf(vin);
+	} else {
 		if (clusterpages == 1)
 			kunmap_atomic(vin);
 		else
 			erofs_vunmap(vin, clusterpages);
-	} else {
-		preempt_enable();
 	}
 	return ret;
 }
diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index 3e7d30b6de1d..4bbd3bf34acd 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -27,6 +27,18 @@ struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp)
 	return page;
 }
 
+#if (EROFS_PCPUBUF_NR_PAGES > 0)
+static struct {
+	u8 data[PAGE_SIZE * EROFS_PCPUBUF_NR_PAGES];
+} ____cacheline_aligned_in_smp erofs_pcpubuf[NR_CPUS];
+
+void *erofs_get_pcpubuf(unsigned int pagenr)
+{
+	preempt_disable();
+	return &erofs_pcpubuf[smp_processor_id()].data[pagenr * PAGE_SIZE];
+}
+#endif
+
 /* global shrink count (for all mounted EROFS instances) */
 static atomic_long_t erofs_global_shrink_cnt;
 
-- 
2.17.1
