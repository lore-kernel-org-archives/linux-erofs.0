Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48BD4E7718F
	for <linux-erofs@archiver.kernel.org>; Fri,  3 Jan 2025 09:04:06 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4YPd0y5BBDz30TF
	for <linux-erofs@archiver.kernel.org>; Fri,  3 Jan 2025 20:04:02 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1735895039;
	cv=none; b=Vsn79SMeyao3iVsZbRh5FMkmiKIKU0pvXJB5ayVvCo8kcgp5KlFIsWyFaK0Ji/MuPk4BZKG9xCgTl3yA9WmBtX/bsKedmO8z+te7y8wOezuDZlR1K/QGgy+utK8FNukpeG/pqC0aEwf1sTadXMcBs5fldqb3dpuopwksd4676B3EN9+AdeWGHDDKO3Qvh9dPA5PpQPmqQTKZ34WrJ20+qL1VfCvyQM0k+pU1ePGFRjcmMQfvnM9Cw94LGyfBNY57QuuY8qLrKWUyuMNXKEAgn10iQgypLRQV8btRMIkjcOiutlY28IuHHSLho2lwcZj5wgMa62+K27fqKD9TEWjM7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1735895039; c=relaxed/relaxed;
	bh=vFkKxZvE2v+e34/3bryoh5zbDD4oXQ2CSHNV/fLC0Hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlqLma1zg4QLhS5cHnGeHeAvgu89ib76XQe74fM8KIVvO6+q0Q7ITS/FIEGZKmNiQpCEvhvCngK+teXsjPA4JzL2P92evJlTxEnbfm0fDEDirLDMxljIJVn1xwfEP6xi5oUb5qZ8uVV+DzWj4b8GfPwfuOX5ZIQsEhF5EqVTKZaS4sHeJuCFFr6T2mXDJE6fDnTiWF2WqKVRI7o3hRNft7edgRgDHBWXYpTxVyFRoLFCePRjmYTh9EEWXNhqukmotL+iDkTRaxa/KTb1iSaBtOo7n+og9mpVS1gB7GJMLLuEFtZ/2uxMFQHJE3Ug2r+0MMnOzXLkQGkHYyUGwWrQUg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=QYQKk0kP; dkim-atps=neutral; spf=pass (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=QYQKk0kP;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4YPd0q6Qq5z30RS
	for <linux-erofs@lists.ozlabs.org>; Fri,  3 Jan 2025 20:03:53 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1735895028; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=vFkKxZvE2v+e34/3bryoh5zbDD4oXQ2CSHNV/fLC0Hw=;
	b=QYQKk0kPDsbpK2SjeNQ6fu1ap9mABG01puM95t20cgPCkFjD+wgyJqq4jonH9N0zyqzu3ceSmZwSWG/EYaRwx4QVAMWsONj855kaSFYn3FOW6zt1AMwcZRWhTdj57PS3GaeZgdWM/WLhggxJ0uV8JEmrwilvSYb78JkhPbRPpm0=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WMsl6QW_1735895026 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 03 Jan 2025 17:03:46 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH 2/5] erofs-utils: lib: add some bit operations
Date: Fri,  3 Jan 2025 17:03:35 +0800
Message-ID: <20250103090338.740593-2-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250103090338.740593-1-hsiangkao@linux.alibaba.com>
References: <20250103090338.740593-1-hsiangkao@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Hongzhen Luo <hongzhen@linux.alibaba.com>

Introduce following bitmap helpers:
	erofs_test_bit
	__erofs_set_bit
	__erofs_clear_bit
	erofs_find_next_bit

Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com> [1]
[1] https://lore.kernel.org/r/20230802091750.74181-3-jefflexu@linux.alibaba.com
Signed-off-by: Hongzhen Luo <hongzhen@linux.alibaba.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 include/erofs/bitops.h | 40 ++++++++++++++++++++++++++++++++++++++++
 include/erofs/defs.h   |  5 +++++
 lib/Makefile.am        |  3 ++-
 lib/bitops.c           | 30 ++++++++++++++++++++++++++++++
 4 files changed, 77 insertions(+), 1 deletion(-)
 create mode 100644 include/erofs/bitops.h
 create mode 100644 lib/bitops.c

diff --git a/include/erofs/bitops.h b/include/erofs/bitops.h
new file mode 100644
index 0000000..058642f
--- /dev/null
+++ b/include/erofs/bitops.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR Apache-2.0 */
+#ifndef __EROFS_BITOPS_H
+#define __EROFS_BITOPS_H
+
+#ifdef __cplusplus
+extern "C"
+{
+#endif
+
+#include "defs.h"
+
+static inline void __erofs_set_bit(int nr, volatile unsigned long *addr)
+{
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+
+	*p  |= mask;
+}
+
+static inline void __erofs_clear_bit(int nr, volatile unsigned long *addr)
+{
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+
+	*p &= ~mask;
+}
+
+static inline int __erofs_test_bit(int nr, const volatile unsigned long *addr)
+{
+	return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
+}
+
+unsigned long erofs_find_next_bit(const unsigned long *addr,
+				  unsigned long nbits, unsigned long start);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/include/erofs/defs.h b/include/erofs/defs.h
index e462338..051a270 100644
--- a/include/erofs/defs.h
+++ b/include/erofs/defs.h
@@ -286,6 +286,11 @@ static inline u32 get_unaligned_le64(const void *p)
 	(n) & (1ULL <<  1) ?  1 : 0	\
 )
 
+static inline unsigned int ffs_long(unsigned long s)
+{
+	return __builtin_ctzl(s);
+}
+
 static inline unsigned int fls_long(unsigned long x)
 {
 	return x ? sizeof(x) * 8 - __builtin_clzl(x) : 0;
diff --git a/lib/Makefile.am b/lib/Makefile.am
index ef98377..9cddc92 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -20,6 +20,7 @@ noinst_HEADERS = $(top_srcdir)/include/erofs_fs.h \
       $(top_srcdir)/include/erofs/io.h \
       $(top_srcdir)/include/erofs/list.h \
       $(top_srcdir)/include/erofs/print.h \
+      $(top_srcdir)/include/erofs/bitops.h \
       $(top_srcdir)/include/erofs/tar.h \
       $(top_srcdir)/include/erofs/trace.h \
       $(top_srcdir)/include/erofs/xattr.h \
@@ -34,7 +35,7 @@ liberofs_la_SOURCES = config.c io.c cache.c super.c inode.c xattr.c exclude.c \
 		      namei.c data.c compress.c compressor.c zmap.c decompress.c \
 		      compress_hints.c hashmap.c sha256.c blobchunk.c dir.c \
 		      fragments.c dedupe.c uuid_unparse.c uuid.c tar.c \
-		      block_list.c rebuild.c diskbuf.c
+		      block_list.c rebuild.c diskbuf.c bitops.c
 
 liberofs_la_CFLAGS = -Wall ${libuuid_CFLAGS} -I$(top_srcdir)/include
 if ENABLE_LZ4
diff --git a/lib/bitops.c b/lib/bitops.c
new file mode 100644
index 0000000..bb0c9ee
--- /dev/null
+++ b/lib/bitops.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0+ OR Apache-2.0
+/*
+ * erofs-utils/lib/bitops.c
+ *
+ * Copyright (C) 2025, Alibaba Cloud
+ */
+#include <erofs/bitops.h>
+
+unsigned long erofs_find_next_bit(const unsigned long *addr,
+				  unsigned long nbits, unsigned long start)
+{
+	unsigned long tmp;
+
+	if (__erofs_unlikely(start >= nbits))
+		return nbits;
+
+	tmp = addr[start / BITS_PER_LONG];
+
+	tmp &= ~0UL << ((start) & (BITS_PER_LONG - 1));
+	start = round_down(start, BITS_PER_LONG);
+
+	while (!tmp) {
+		start += BITS_PER_LONG;
+		if (start >= nbits)
+			return nbits;
+
+		tmp = addr[start / BITS_PER_LONG];
+	}
+	return min(start + ffs_long(tmp), nbits);
+}
-- 
2.43.5

