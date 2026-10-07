Return-Path: <linux-erofs+bounces-4674-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24A70CA6002
	for <linux-erofs@archiver.kernel.org>; Wed,  7 Oct 2026 19:50:00 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j0Nxy35QKz30NF;
	Thu, 08 Oct 2026 06:49:58 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791402598;
	cv=none; b=B9ieaQJEB/Ux71y6I7lAFU9R/5rhv0GgxxqTB1NU0zxyUrNQPJSTDfhxbRISvmUq90WrrZpv4hPf9StkOaxfU4Vjcf9NdVL0bc/PQEHT0AFPl4/lv7XEfMILDExDg6pEfrh5YVKeHpyMJbkwS5HTqrMsNCbE2UuX+Z0akwgaGiBjU0yieWvzoZKVtNnuMXFm8anPe3UYYVLo6CMr+pb/b3qTngZVIZ5M6rSTVbZKf/31qX4Dt+/kmiMfIKFdfZR2xnW9hbJ9e3KBuYsYCoFBta71vIiJSf/sSb5X8TRQC0apaW6h4Z4O47BjbqIXrhWI5/M3wG8OXAlKahgIoSL2mw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791402598; c=relaxed/relaxed;
	bh=UG1hir3hATNaNbJqvgxVznpDe8jY0ODpgOQz7Wvf3Mw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S4wgDQkIOfjBH3rnwy/GAh6XTtuD6743JjE5FwRct+/KaVUpGn/AsUJc9JOv81jxwIkyKlUX6MCo/2VRPkHTFIHTYai0kVHiFaCXxu5w0IrvZfYoYDYeWYa+4p4WryPgEI1ynSZ6oIpqc+5jFPmm+iKtn79rsN1c2AsxerPtLZBipJz3E6UDYLZdWHgWNSKu7s4rAk2EDZa7Octki05iDGq+uKO6fHpJxIQwOAmV+KsEYT36EH8YGF8zeBggxBM0uR6oZgdjkCR1ZrKqkQwUW7wPlC+QH1L4KBe9oYG0mtGklHQ7HkfMFr/osnfY6U7Z58USJ+h67TX6ZLRT2t0Bfg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JMZNwvlm; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JMZNwvlm;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j0Nxw5Mbtz30Bd
	for <linux-erofs@lists.ozlabs.org>; Thu, 08 Oct 2026 06:49:56 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C7C16447D6
	for <linux-erofs@lists.ozlabs.org>; Wed,  7 Oct 2026 19:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D42951F00893;
	Wed,  7 Oct 2026 19:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791402594;
	bh=UG1hir3hATNaNbJqvgxVznpDe8jY0ODpgOQz7Wvf3Mw=;
	h=From:To:Cc:Subject:Date;
	b=JMZNwvlmFeMjrkQ3qrL37+bcAhvToLvc4pFC2c20hVmO70YNVnghM+DZ+dujDtdLw
	 tCEUr+VpQt3Mez2mGpkBA2iJmKkWiyWtgOsu3ES8eeFIAo4oHymfjXjjJ/tLk43MyD
	 9uDakmlg/Pk5z7vvtpUBADDUN+Vb0v8LqKwQEFe32brIWDgU79WPcqrbLvtxVLaYYR
	 AnxkmvX3P1qmS+Zq5CC3YGhrds7YDVtrpK4njpKSBRCAtF2lIF/jPIFPz/p8U0nwWD
	 ycfz0dG2UM2Wgkn7ra06vGXFRNWfy+5COUy0UHeOyR5D1wDTz8LPqxL1wCXXqQTxwW
	 w8xTgFwx5d2TQ==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>
Subject: [PATCH] erofs-utils: avoid unsigned long if possible (incomplete)
Date: Wed,  7 Oct 2026 21:49:49 +0200
Message-ID: <20261007194949.15224-1-xiang@kernel.org>
X-Mailer: git-send-email 2.50.1
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

long is always 32 bits on Windows, even on 64-bit systems.

Link: https://github.com/chenxiaolong/erofs-utils/commit/becfc45e8372992d96bea103e1284875a397111e
Link: https://github.com/erofs/go-erofs/blob/main/.github/workflows/patches/erofs-utils/001-windows.patch
Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 include/erofs/err.h      |  9 +++++----
 include/erofs/internal.h |  2 +-
 lib/dedupe.c             | 31 +++++++++++++++----------------
 lib/inode.c              |  4 ++--
 lib/kite_deflate.c       |  3 +--
 5 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/include/erofs/err.h b/include/erofs/err.h
index 28de701..1d18d54 100644
--- a/include/erofs/err.h
+++ b/include/erofs/err.h
@@ -13,6 +13,7 @@ extern "C"
 #endif
 
 #include <errno.h>
+#include <stdint.h>
 #include <string.h>
 #include <stdio.h>
 
@@ -30,7 +31,7 @@ static inline const char *erofs_strerror(int err)
 
 #define MAX_ERRNO (4095)
 #define IS_ERR_VALUE(x)                                                        \
-	((unsigned long)(void *)(x) >= (unsigned long)-MAX_ERRNO)
+	((uintptr_t)(void *)(x) >= (uintptr_t)-MAX_ERRNO)
 
 static inline void *ERR_PTR(long error)
 {
@@ -39,18 +40,18 @@ static inline void *ERR_PTR(long error)
 
 static inline int IS_ERR(const void *ptr)
 {
-	return IS_ERR_VALUE((unsigned long)ptr);
+	return IS_ERR_VALUE((uintptr_t)ptr);
 }
 
 static inline long PTR_ERR(const void *ptr)
 {
-	return (long) ptr;
+	return (intptr_t)ptr;
 }
 
 static inline void * ERR_CAST(const void *ptr)
 {
 	/* cast away the const */
-	return (void *) ptr;
+	return (void *)ptr;
 }
 
 /* EROFS-specific error codes */
diff --git a/include/erofs/internal.h b/include/erofs/internal.h
index d905077..19e38fb 100644
--- a/include/erofs/internal.h
+++ b/include/erofs/internal.h
@@ -348,7 +348,7 @@ static inline unsigned int erofs_inode_datalayout(unsigned int ifmt)
 
 static inline struct erofs_inode *erofs_parent_inode(struct erofs_inode *inode)
 {
-	return (struct erofs_inode *)((unsigned long)inode->i_parent & ~1UL);
+	return (struct erofs_inode *)((uintptr_t)inode->i_parent & ~(uintptr_t)1);
 }
 
 #define IS_ROOT(x)	((x) == erofs_parent_inode(x))
diff --git a/lib/dedupe.c b/lib/dedupe.c
index ec9e2bb..b242f7d 100644
--- a/lib/dedupe.c
+++ b/lib/dedupe.c
@@ -9,18 +9,17 @@
 #include "liberofs_xxhash.h"
 #include "liberofs_sha256.h"
 
-unsigned long erofs_memcmp2(const u8 *s1, const u8 *s2,
-			    unsigned long sz)
+uintptr_t erofs_memcmp2(const u8 *s1, const u8 *s2, uintptr_t sz)
 {
-	const unsigned long *a1, *a2;
-	unsigned long n = sz;
+	const uintptr_t *a1, *a2;
+	uintptr_t n = sz;
 
-	if (sz < sizeof(long))
+	if (sz < sizeof(uintptr_t))
 		goto out_bytes;
 
-	if (((long)s1 & (sizeof(long) - 1)) ==
-			((long)s2 & (sizeof(long) - 1))) {
-		while ((long)s1 & (sizeof(long) - 1)) {
+	if (((uintptr_t)s1 & (sizeof(uintptr_t) - 1)) ==
+			((uintptr_t)s2 & (sizeof(uintptr_t) - 1))) {
+		while ((uintptr_t)s1 & (sizeof(uintptr_t) - 1)) {
 			if (*s1 != *s2)
 				break;
 			++s1;
@@ -28,25 +27,25 @@ unsigned long erofs_memcmp2(const u8 *s1, const u8 *s2,
 			--sz;
 		}
 
-		a1 = (const unsigned long *)s1;
-		a2 = (const unsigned long *)s2;
-		while (sz >= sizeof(long)) {
+		a1 = (const uintptr_t *)s1;
+		a2 = (const uintptr_t *)s2;
+		while (sz >= sizeof(uintptr_t)) {
 			if (*a1 != *a2)
 				break;
 			++a1;
 			++a2;
-			sz -= sizeof(long);
+			sz -= sizeof(uintptr_t);
 		}
 	} else {
-		a1 = (const unsigned long *)s1;
-		a2 = (const unsigned long *)s2;
+		a1 = (const uintptr_t *)s1;
+		a2 = (const uintptr_t *)s2;
 		do {
 			if (get_unaligned(a1) != get_unaligned(a2))
 				break;
 			++a1;
 			++a2;
-			sz -= sizeof(long);
-		} while (sz >= sizeof(long));
+			sz -= sizeof(uintptr_t);
+		} while (sz >= sizeof(uintptr_t));
 	}
 	s1 = (const u8 *)a1;
 	s2 = (const u8 *)a2;
diff --git a/lib/inode.c b/lib/inode.c
index 489c44e..d819659 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -2169,13 +2169,13 @@ static int erofs_mkfs_handle_inode(const struct erofs_mkfs_btctx *ctx,
 
 static bool erofs_inode_visited(struct erofs_inode *inode)
 {
-	return (unsigned long)inode->i_parent & 1UL;
+	return (uintptr_t)inode->i_parent & 1;
 }
 
 static void erofs_mark_parent_inode(struct erofs_inode *inode,
 				    struct erofs_inode *dir)
 {
-	inode->i_parent = (void *)((unsigned long)dir | 1);
+	inode->i_parent = (void *)((uintptr_t)dir | 1);
 }
 
 static int erofs_mkfs_dump_tree(const struct erofs_mkfs_btctx *ctx)
diff --git a/lib/kite_deflate.c b/lib/kite_deflate.c
index c1d3c6d..67b01c9 100644
--- a/lib/kite_deflate.c
+++ b/lib/kite_deflate.c
@@ -13,8 +13,7 @@
 #include <ctype.h>
 #include <stdio.h>
 
-unsigned long erofs_memcmp2(const u8 *s1, const u8 *s2,
-			    unsigned long sz);
+uintptr_t erofs_memcmp2(const u8 *s1, const u8 *s2, uintptr_t sz);
 
 #ifdef TEST
 #define kite_dbg(x, ...)	fprintf(stderr, x "\n", ##__VA_ARGS__)
-- 
2.50.1 (Apple Git-155)


