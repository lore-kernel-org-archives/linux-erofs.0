From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 4 Dec 2018 21:30:49 +0800
Subject: [PREVIEW] [NOMERGE] [PATCH v2 1/2] staging: erofs: introduce percpu
 map areas
Message-ID: <20181204133050.4501-1-gaoxiang25@huawei.com>

There is a need for decompress algorithms to work in continuous
virtual memory areas. However, vmap or vm_map_ram will also repeatly
(un)allocate vm_areas over and over again (vmap_area_lock is needed),
which takes much overhead.

Let's introduce percpu vm areas as what zsmalloc does, expect that
erofs needs mapping more pages at once, therefore only VM mapping is
performed.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
change log v2:
 - fix wrong `erofs_vmap()' to `erofs_pcpumap'

 drivers/staging/erofs/internal.h      |   8 +++
 drivers/staging/erofs/super.c         |   7 +++
 drivers/staging/erofs/unzip_vle.c     |   8 +--
 drivers/staging/erofs/unzip_vle_lz4.c |  28 +++++----
 drivers/staging/erofs/utils.c         | 113 ++++++++++++++++++++++++++++++++++
 5 files changed, 149 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index e049d00c087a..69ec5dc9e332 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -612,8 +612,16 @@ static inline void erofs_vunmap(const void *mem, unsigned int count)
 }
 
 /* utils.c */
+#define EROFS_FS_PERCPU_VM_PAGES	128
+
 extern struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp);
 
+void *erofs_pcpumap(struct page **pages, unsigned int nr_pages);
+void erofs_pcpuunmap(void);
+
+int __init erofs_register_cpu_notifier(void);
+void erofs_unregister_cpu_notifier(void);
+
 extern void erofs_register_super(struct super_block *sb);
 extern void erofs_unregister_super(struct super_block *sb);
 
diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 1ab3553c839b..8bdc3b7dbcc3 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -560,6 +560,10 @@ static int __init erofs_module_init(void)
 	erofs_check_ondisk_layout_definitions();
 	infoln("initializing erofs " EROFS_VERSION);
 
+	err = erofs_register_cpu_notifier();
+	if (err)
+		goto cpu_notifier_err;
+
 	err = erofs_init_inode_cache();
 	if (err)
 		goto icache_err;
@@ -586,6 +590,8 @@ static int __init erofs_module_init(void)
 shrinker_err:
 	erofs_exit_inode_cache();
 icache_err:
+	erofs_unregister_cpu_notifier();
+cpu_notifier_err:
 	return err;
 }
 
@@ -595,6 +601,7 @@ static void __exit erofs_module_exit(void)
 	z_erofs_exit_zip_subsystem();
 	unregister_shrinker(&erofs_shrinker_info);
 	erofs_exit_inode_cache();
+	erofs_unregister_cpu_notifier();
 	infoln("successfully finalize erofs");
 }
 
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 929815705b98..695f342d0509 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1010,12 +1010,12 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 	}
 
 skip_allocpage:
-	vout = erofs_vmap(pages, nr_pages);
+	vout = erofs_pcpumap(pages, nr_pages);
 
-	err = z_erofs_vle_unzip_vmap(compressed_pages,
-		clusterpages, vout, llen, work->pageofs, overlapped);
+	err = z_erofs_vle_unzip_vmap(compressed_pages, clusterpages,
+				     vout, llen, work->pageofs, overlapped);
 
-	erofs_vunmap(vout, nr_pages);
+	erofs_pcpuunmap();
 
 out:
 	for (i = 0; i < nr_pages; ++i) {
diff --git a/drivers/staging/erofs/unzip_vle_lz4.c b/drivers/staging/erofs/unzip_vle_lz4.c
index de0a5d1365a4..2bf09daac206 100644
--- a/drivers/staging/erofs/unzip_vle_lz4.c
+++ b/drivers/staging/erofs/unzip_vle_lz4.c
@@ -195,6 +195,20 @@ int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
 	unsigned int i;
 	int ret;
 
+	/* dst and src buffers aren't overlapped (ex, cached decompression) */
+	if (!overlapped) {
+		if (clusterpages == 1)
+			vin = kmap_atomic(compressed_pages[0]);
+		else
+			/*
+			 * Note that only clusterpages == 1 is supported now,
+			 * no need to optimize (ex, compressed percpu vm areas
+			 * for clusterpages > 1) this case in the short term,
+			 * fall back to the overlapped case as a simplication.
+			 */
+			overlapped = true;
+	}
+
 	if (overlapped) {
 		preempt_disable();
 		vin = erofs_pcpubuf[smp_processor_id()].data;
@@ -205,10 +219,6 @@ int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
 			memcpy(vin + PAGE_SIZE * i, t, PAGE_SIZE);
 			kunmap_atomic(t);
 		}
-	} else if (clusterpages == 1) {
-		vin = kmap_atomic(compressed_pages[0]);
-	} else {
-		vin = erofs_vmap(compressed_pages, clusterpages);
 	}
 
 	ret = z_erofs_unzip_lz4(vin, vout + pageofs,
@@ -216,14 +226,10 @@ int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
 	if (ret > 0)
 		ret = 0;
 
-	if (!overlapped) {
-		if (clusterpages == 1)
-			kunmap_atomic(vin);
-		else
-			erofs_vunmap(vin, clusterpages);
-	} else {
+	if (overlapped)
 		preempt_enable();
-	}
+	else
+		kunmap_atomic(vin);
 	return ret;
 }
 
diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index d2e3ace91046..e9236cdc63fe 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -13,6 +13,19 @@
 
 #include "internal.h"
 #include <linux/pagevec.h>
+#include <linux/cpu.h>
+#include <linux/cpuhotplug.h>
+
+struct erofs_pcpu_mapping_area {
+	/* vm area for mapping object that span pages */
+	struct vm_struct *vm;
+
+	char *vm_addr; /* address of kmap_atomic()'ed pages */
+	unsigned nr_pages;
+};
+
+/* per-cpu mapping areas for multi-pages */
+static DEFINE_PER_CPU(struct erofs_pcpu_mapping_area, map_area);
 
 struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp)
 {
@@ -30,6 +43,106 @@ struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp)
 	return page;
 }
 
+void *erofs_pcpumap(struct page **pages, unsigned int nr_pages)
+{
+	struct erofs_pcpu_mapping_area *area;
+	int ret;
+
+	/* it is too large, use the generic vmap approch */
+	if (nr_pages > EROFS_FS_PERCPU_VM_PAGES) {
+		void *vaddr = erofs_vmap(pages, nr_pages);
+
+		area = &get_cpu_var(map_area);
+		area->vm_addr = vaddr;
+		goto out;
+	}
+	area = &get_cpu_var(map_area);
+
+	if (area->vm->flags & VM_NO_GUARD)
+		area->vm->size = nr_pages * PAGE_SIZE;
+	else
+		area->vm->size = (nr_pages + 1) * PAGE_SIZE;
+
+	ret = map_vm_area(area->vm, PAGE_KERNEL, pages);
+
+	if (unlikely(ret))
+		return ERR_PTR(ret);
+
+	area->vm_addr = area->vm->addr;
+out:
+	area->nr_pages = nr_pages;
+	return area->vm_addr;
+}
+
+void erofs_pcpuunmap(void)
+{
+	struct erofs_pcpu_mapping_area *const area = this_cpu_ptr(&map_area);
+	void *const vaddr = area->vm_addr;
+	const unsigned int nr_pages = area->nr_pages;
+
+	if (nr_pages > EROFS_FS_PERCPU_VM_PAGES) {
+		put_cpu_var(map_area);
+		erofs_vunmap(vaddr, nr_pages);
+		return;
+	}
+
+	unmap_kernel_range((unsigned long)vaddr,
+			   PAGE_SIZE * nr_pages);
+
+	if (area->vm->flags & VM_NO_GUARD)
+		area->vm->size = EROFS_FS_PERCPU_VM_PAGES * PAGE_SIZE;
+	else
+		area->vm->size = (EROFS_FS_PERCPU_VM_PAGES + 1) * PAGE_SIZE;
+	put_cpu_var(map_area);
+}
+
+static int erofs_cpu_prepare(unsigned int cpu)
+{
+	struct erofs_pcpu_mapping_area *const area = &per_cpu(map_area, cpu);
+	/*
+	 * Make sure we don't leak memory if a cpu UP notification
+	 * and erofs_register_cpu_notifier() race and both call
+	 * cpu_up() on the same cpu
+	 */
+	if (area->vm)
+		return 0;
+
+	area->vm = alloc_vm_area(PAGE_SIZE * EROFS_FS_PERCPU_VM_PAGES, NULL);
+	if (!area->vm)
+		return -ENOMEM;
+	return 0;
+}
+
+static int erofs_cpu_dead(unsigned int cpu)
+{
+	struct erofs_pcpu_mapping_area *const area = &per_cpu(map_area, cpu);
+
+	if (area->vm) {
+		free_vm_area(area->vm);
+		area->vm = NULL;
+	}
+	return 0;
+}
+
+static enum cpuhp_state hp_online;
+
+int __init erofs_register_cpu_notifier(void)
+{
+	int err = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "fs/erofs:online",
+				    erofs_cpu_prepare, erofs_cpu_dead);
+
+	if (err < 0)
+		return err;
+
+	hp_online = err;
+	return 0;
+}
+
+void erofs_unregister_cpu_notifier(void)
+{
+	cpuhp_remove_state(hp_online);
+}
+
 /* global shrink count (for all mounted EROFS instances) */
 static atomic_long_t erofs_global_shrink_cnt;
 
-- 
2.14.4
