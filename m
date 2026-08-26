Return-Path: <linux-erofs+bounces-4349-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4964C61DBD
	for <linux-erofs@archiver.kernel.org>; Wed, 26 Aug 2026 13:44:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hVQqX01nmz2yf9;
	Wed, 26 Aug 2026 23:44:24 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787751863;
	cv=none; b=EVVMr8/kvIkkrV1bimg5kP33hOr2eUA7AVHtD9ewATf5ni8BxbTwtUnsQGdnNZJJIiyf5T5x2yKZpHGc9jWMdxhTrpj+rhYwAuOe4eM8V0sv/NFia50lK6bk6Ks2tlY6MLjc2w+y/LNIUIPuTVyWkxmpcsRlNAzXMGwXBJ7BICnBqNwYiec7RGyBl7X2asd4W1qw48sklb+fge1W8NJCbaiW2U3yWdsAa86dPqhsADm/It4zrD1QQjFJMkDTASfUML2cvzdIaZGh5frNSx+Gvx0gq8+yXmvu08XZSmCkmcv07LdcCLuEcCG99svRRZEr06doYKpWmBWaIOi40nQQYw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787751863; c=relaxed/relaxed;
	bh=Pliysv9dBXAY7tDvZz8pEbilfac3im2EnvX56aaqVKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVqcNnCe2zt3/HFZczyZ5Pj7IgR62cjc2zfLts5dYPJHkZBnK92DJ1m46P1Rl9AepHe9DUCv2R8/uyrqTDh6hKRk8Pc8KRcrzTFPuSC5+7gNqsEptmTI0Fe1bZ49TKYGf00A9TPyYKWs6PqVIWh6BqMbSjbwKIwHAZFW2ljysTMemrQhjh59RA1Xbx4SFZ9kcd3ybDPIxR1hSfSug+PFUVAol0c3+87DfNTc4PZhg5RIopMGkh4z6bDCuKsY1rW6KSwD5GzBv2IHfXye5bhdv+g4JKXDLu9odYzO9D/4Z6zgG441i4dAOkeo9GrU6JiMqAS4wcvt5IrNciV/GkLx5g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HoTSbrei; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HoTSbrei;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hVQqV2Kmnz2y8F
	for <linux-erofs@lists.ozlabs.org>; Wed, 26 Aug 2026 23:44:22 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 156E043CB9
	for <linux-erofs@lists.ozlabs.org>; Wed, 26 Aug 2026 13:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D491F000E9;
	Wed, 26 Aug 2026 13:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787751860;
	bh=Pliysv9dBXAY7tDvZz8pEbilfac3im2EnvX56aaqVKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HoTSbreinZsG6rLFsJg/0FkMdHMfVxsPcrNVgsokKXcGCKHm+7TgTdyMVL3gFKdsP
	 Jvl3zW1A1ZkwrgWhFdYTFG/tqnTr9gnt9cGmxuuJpLgX9kxQmRZXSQ63ha/bfYMSy9
	 PjxOzKhFoEmYuiOUBt3sg74C5O5X5XclhEADF5mS5L7gfRyshN8RFd1Gk25U0vXsZj
	 5hGQQJklAO9FfsD78CMpTZT7r2sKxYgBlcs77W7omTt+czAuLoqodshqPRH8nDApMK
	 08Ml7As4ZMe2tEPv+rHCueg9tVEkC2fq9oTA9nszfA9ez44fY1npZy0NzTWA8B9DVi
	 rgPuiQ33NCLmw==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>
Subject: [PATCH 4/4] erofs-utils: get rid of hashmap
Date: Wed, 26 Aug 2026 21:43:20 +0800
Message-ID: <20260826134321.11835-4-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260826134321.11835-1-xiang@kernel.org>
References: <20260826134321.11835-1-xiang@kernel.org>
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

This is the last piece of GPL-only 3rd-party code in
liberofs.

We may introduce a new dynamic hashmap implementation without GPL-only
restriction later.

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 include/erofs/flex-array.h | 156 ---------------------
 include/erofs/hashmap.h    | 115 ---------------
 lib/Makefile.am            |   4 +-
 lib/hashmap.c              | 280 -------------------------------------
 4 files changed, 1 insertion(+), 554 deletions(-)
 delete mode 100644 include/erofs/flex-array.h
 delete mode 100644 include/erofs/hashmap.h
 delete mode 100644 lib/hashmap.c

diff --git a/include/erofs/flex-array.h b/include/erofs/flex-array.h
deleted file mode 100644
index 9b1642f..0000000
--- a/include/erofs/flex-array.h
+++ /dev/null
@@ -1,156 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __EROFS_FLEX_ARRAY_H
-#define __EROFS_FLEX_ARRAY_H
-
-#ifdef __cplusplus
-extern "C"
-{
-#endif
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <limits.h>
-#include <stdint.h>
-
-#include "defs.h"
-#include "print.h"
-
-/*
- * flex-array.h
- *
- * Some notes to make sense of the code.
- *
- * Flex-arrays:
- *   - Flex-arrays became standard in C99 and are defined by "array[]" (at the
- *     end of a struct)
- *   - Pre-C99 flex-arrays can be accomplished by "array[1]"
- *   - There is a GNU extension where they are defined using "array[0]"
- *     Allegedly there is/was a bug in gcc whereby foo[1] generated incorrect
- *     code, so it's safest to use [0] (https://lkml.org/lkml/2015/2/18/407).
- *
- * For C89 and C90, __STDC__ is 1
- * For later standards, __STDC_VERSION__ is defined according to the standard.
- * For example: 199901L or 201112L
- *
- * Whilst we're on the subject, in version 5 of gcc, the default std was
- * changed from gnu89 to gnu11. In jgmenu, CFLAGS therefore contains -std=gnu89
- * You can check your default gcc std by doing:
- * gcc -dM -E - </dev/null | grep '__STDC_VERSION__\|__STDC__'
- *
- * The code below is copied from git's git-compat-util.h in support of
- * hashmap.c
- */
-
-#ifndef FLEX_ARRAY
-#if defined(__STDC_VERSION__) && (__STDC_VERSION__ >= 199901L) && \
-	(!defined(__SUNPRO_C) || (__SUNPRO_C > 0x580))
-# define FLEX_ARRAY /* empty */
-#elif defined(__GNUC__)
-# if (__GNUC__ >= 3)
-#  define FLEX_ARRAY /* empty */
-# else
-#  define FLEX_ARRAY 0 /* older GNU extension */
-# endif
-#endif
-
-/* Otherwise, default to safer but a bit wasteful traditional style */
-#ifndef FLEX_ARRAY
-# define FLEX_ARRAY 1
-#endif
-#endif
-
-#define bitsizeof(x) (CHAR_BIT * sizeof(x))
-
-#define maximum_signed_value_of_type(a) \
-	(INTMAX_MAX >> (bitsizeof(intmax_t) - bitsizeof(a)))
-
-#define maximum_unsigned_value_of_type(a) \
-	(UINTMAX_MAX >> (bitsizeof(uintmax_t) - bitsizeof(a)))
-
-/*
- * Signed integer overflow is undefined in C, so here's a helper macro
- * to detect if the sum of two integers will overflow.
- * Requires: a >= 0, typeof(a) equals typeof(b)
- */
-#define signed_add_overflows(a, b) \
-	((b) > maximum_signed_value_of_type(a) - (a))
-
-#define unsigned_add_overflows(a, b) \
-	((b) > maximum_unsigned_value_of_type(a) - (a))
-
-static inline size_t st_add(size_t a, size_t b)
-{
-	if (unsigned_add_overflows(a, b)) {
-		erofs_err("size_t overflow: %llu + %llu", a | 0ULL, b | 0ULL);
-		BUG_ON(1);
-		return -1;
-	}
-	return a + b;
-}
-
-#define st_add3(a, b, c) st_add(st_add((a), (b)), (c))
-#define st_add4(a, b, c, d) st_add(st_add3((a), (b), (c)), (d))
-
-/*
- * These functions help you allocate structs with flex arrays, and copy
- * the data directly into the array. For example, if you had:
- *
- *   struct foo {
- *     int bar;
- *     char name[FLEX_ARRAY];
- *   };
- *
- * you can do:
- *
- *   struct foo *f;
- *   FLEX_ALLOC_MEM(f, name, src, len);
- *
- * to allocate a "foo" with the contents of "src" in the "name" field.
- * The resulting struct is automatically zero'd, and the flex-array field
- * is NUL-terminated (whether the incoming src buffer was or not).
- *
- * The FLEXPTR_* variants operate on structs that don't use flex-arrays,
- * but do want to store a pointer to some extra data in the same allocated
- * block. For example, if you have:
- *
- *   struct foo {
- *     char *name;
- *     int bar;
- *   };
- *
- * you can do:
- *
- *   struct foo *f;
- *   FLEXPTR_ALLOC_STR(f, name, src);
- *
- * and "name" will point to a block of memory after the struct, which will be
- * freed along with the struct (but the pointer can be repointed anywhere).
- *
- * The *_STR variants accept a string parameter rather than a ptr/len
- * combination.
- *
- * Note that these macros will evaluate the first parameter multiple
- * times, and it must be assignable as an lvalue.
- */
-#define FLEX_ALLOC_MEM(x, flexname, buf, len) do { \
-	size_t flex_array_len_ = (len); \
-	(x) = calloc(1, st_add3(sizeof(*(x)), flex_array_len_, 1)); \
-	BUG_ON(!(x)); \
-	memcpy((void *)(x)->flexname, (buf), flex_array_len_); \
-} while (0)
-#define FLEXPTR_ALLOC_MEM(x, ptrname, buf, len) do { \
-	size_t flex_array_len_ = (len); \
-	(x) = xcalloc(1, st_add3(sizeof(*(x)), flex_array_len_, 1)); \
-	memcpy((x) + 1, (buf), flex_array_len_); \
-	(x)->ptrname = (void *)((x) + 1); \
-} while (0)
-#define FLEX_ALLOC_STR(x, flexname, str) \
-	FLEX_ALLOC_MEM((x), flexname, (str), strlen(str))
-#define FLEXPTR_ALLOC_STR(x, ptrname, str) \
-	FLEXPTR_ALLOC_MEM((x), ptrname, (str), strlen(str))
-
-#ifdef __cplusplus
-}
-#endif
-
-#endif
diff --git a/include/erofs/hashmap.h b/include/erofs/hashmap.h
deleted file mode 100644
index 484948e..0000000
--- a/include/erofs/hashmap.h
+++ /dev/null
@@ -1,115 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __EROFS_HASHMAP_H
-#define __EROFS_HASHMAP_H
-
-#ifdef __cplusplus
-extern "C"
-{
-#endif
-
-/* Copied from https://github.com/git/git.git */
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-
-#include "flex-array.h"
-
-/*
- * Generic implementation of hash-based key-value mappings.
- * See Documentation/technical/api-hashmap.txt.
- */
-
-/* FNV-1 functions */
-unsigned int strhash(const char *str);
-unsigned int strihash(const char *str);
-unsigned int memhash(const void *buf, size_t len);
-unsigned int memihash(const void *buf, size_t len);
-
-static inline unsigned int sha1hash(const unsigned char *sha1)
-{
-	/*
-	 * Equivalent to 'return *(unsigned int *)sha1;', but safe on
-	 * platforms that don't support unaligned reads.
-	 */
-	unsigned int hash;
-
-	memcpy(&hash, sha1, sizeof(hash));
-	return hash;
-}
-
-/* data structures */
-struct hashmap_entry {
-	struct hashmap_entry *next;
-	unsigned int hash;
-};
-
-typedef int (*hashmap_cmp_fn)(const void *entry, const void *entry_or_key,
-		const void *keydata);
-
-struct hashmap {
-	struct hashmap_entry **table;
-	hashmap_cmp_fn cmpfn;
-	unsigned int size, tablesize, grow_at, shrink_at;
-};
-
-struct hashmap_iter {
-	struct hashmap *map;
-	struct hashmap_entry *next;
-	unsigned int tablepos;
-};
-
-/* hashmap functions */
-void hashmap_init(struct hashmap *map, hashmap_cmp_fn equals_function,
-		  size_t initial_size);
-int hashmap_free(struct hashmap *map);
-
-/* hashmap_entry functions */
-static inline void hashmap_entry_init(void *entry, unsigned int hash)
-{
-	struct hashmap_entry *e = entry;
-
-	e->hash = hash;
-	e->next = NULL;
-}
-
-void *hashmap_get(const struct hashmap *map, const void *key, const void *keydata);
-void *hashmap_get_next(const struct hashmap *map, const void *entry);
-void hashmap_add(struct hashmap *map, void *entry);
-void *hashmap_remove(struct hashmap *map, const void *key);
-
-static inline void *hashmap_get_from_hash(const struct hashmap *map,
-					  unsigned int hash,
-					  const void *keydata)
-{
-	struct hashmap_entry key;
-
-	hashmap_entry_init(&key, hash);
-	return hashmap_get(map, &key, keydata);
-}
-
-/* hashmap_iter functions */
-void hashmap_iter_init(struct hashmap *map, struct hashmap_iter *iter);
-void *hashmap_iter_next(struct hashmap_iter *iter);
-static inline void *hashmap_iter_first(struct hashmap *map,
-				       struct hashmap_iter *iter)
-{
-	hashmap_iter_init(map, iter);
-	return hashmap_iter_next(iter);
-}
-
-static inline void hashmap_disable_shrink(struct hashmap * map)
-{
-	map->shrink_at = 0;
-}
-/* string interning */
-const void *memintern(const void *data, size_t len);
-static inline const char *strintern(const char *string)
-{
-	return memintern(string, strlen(string));
-}
-
-#ifdef __cplusplus
-}
-#endif
-
-#endif
diff --git a/lib/Makefile.am b/lib/Makefile.am
index 5ef2122..25d08f2 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -10,8 +10,6 @@ noinst_HEADERS = $(top_srcdir)/include/erofs_fs.h \
       $(top_srcdir)/include/erofs/diskbuf.h \
       $(top_srcdir)/include/erofs/err.h \
       $(top_srcdir)/include/erofs/exclude.h \
-      $(top_srcdir)/include/erofs/flex-array.h \
-      $(top_srcdir)/include/erofs/hashmap.h \
       $(top_srcdir)/include/erofs/inode.h \
       $(top_srcdir)/include/erofs/internal.h \
       $(top_srcdir)/include/erofs/io.h \
@@ -43,7 +41,7 @@ endif
 
 liberofs_la_SOURCES = config.c io.c cache.c super.c inode.c xattr.c exclude.c \
 		      namei.c data.c compress.c compressor.c zmap.c decompress.c \
-		      compress_hints.c hashmap.c sha256.c blobchunk.c dir.c \
+		      compress_hints.c sha256.c blobchunk.c dir.c \
 		      fragments.c dedupe.c uuid_unparse.c uuid.c tar.c \
 		      block_list.c rebuild.c diskbuf.c bitops.c dedupe_ext.c \
 		      vmdk.c metabox.c global.c importer.c base64.c
diff --git a/lib/hashmap.c b/lib/hashmap.c
deleted file mode 100644
index 45916ae..0000000
--- a/lib/hashmap.c
+++ /dev/null
@@ -1,280 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copied from https://github.com/git/git.git
- * Generic implementation of hash-based key value mappings.
- */
-#include "erofs/hashmap.h"
-
-#define FNV32_BASE ((unsigned int)0x811c9dc5)
-#define FNV32_PRIME ((unsigned int)0x01000193)
-
-unsigned int strhash(const char *str)
-{
-	unsigned int c, hash = FNV32_BASE;
-
-	while ((c = (unsigned char)*str++))
-		hash = (hash * FNV32_PRIME) ^ c;
-	return hash;
-}
-
-unsigned int strihash(const char *str)
-{
-	unsigned int c, hash = FNV32_BASE;
-
-	while ((c = (unsigned char)*str++)) {
-		if (c >= 'a' && c <= 'z')
-			c -= 'a' - 'A';
-		hash = (hash * FNV32_PRIME) ^ c;
-	}
-	return hash;
-}
-
-unsigned int memhash(const void *buf, size_t len)
-{
-	unsigned int hash = FNV32_BASE;
-	unsigned char *ucbuf = (unsigned char *)buf;
-
-	while (len--) {
-		unsigned int c = *ucbuf++;
-
-		hash = (hash * FNV32_PRIME) ^ c;
-	}
-	return hash;
-}
-
-unsigned int memihash(const void *buf, size_t len)
-{
-	unsigned int hash = FNV32_BASE;
-	unsigned char *ucbuf = (unsigned char *)buf;
-
-	while (len--) {
-		unsigned int c = *ucbuf++;
-
-		if (c >= 'a' && c <= 'z')
-			c -= 'a' - 'A';
-		hash = (hash * FNV32_PRIME) ^ c;
-	}
-	return hash;
-}
-
-#define HASHMAP_INITIAL_SIZE 64
-/* grow / shrink by 2^2 */
-#define HASHMAP_RESIZE_BITS 2
-/* load factor in percent */
-#define HASHMAP_LOAD_FACTOR 80
-
-static void alloc_table(struct hashmap *map, unsigned int size)
-{
-	map->tablesize = size;
-	map->table = calloc(size, sizeof(struct hashmap_entry *));
-	BUG_ON(!map->table);
-
-	/* calculate resize thresholds for new size */
-	map->grow_at = (unsigned int)((uint64_t)size * HASHMAP_LOAD_FACTOR / 100);
-	if (size <= HASHMAP_INITIAL_SIZE)
-		map->shrink_at = 0;
-	else
-		/*
-		 * The shrink-threshold must be slightly smaller than
-		 * (grow-threshold / resize-factor) to prevent erratic resizing,
-		 * thus we divide by (resize-factor + 1).
-		 */
-		map->shrink_at = map->grow_at / ((1 << HASHMAP_RESIZE_BITS) + 1);
-}
-
-static inline int entry_equals(const struct hashmap *map,
-			       const struct hashmap_entry *e1,
-			       const struct hashmap_entry *e2,
-			       const void *keydata)
-{
-	return (e1 == e2) || (e1->hash == e2->hash && !map->cmpfn(e1, e2, keydata));
-}
-
-static inline unsigned int bucket(const struct hashmap *map,
-				  const struct hashmap_entry *key)
-{
-	return key->hash & (map->tablesize - 1);
-}
-
-static void rehash(struct hashmap *map, unsigned int newsize)
-{
-	unsigned int i, oldsize = map->tablesize;
-	struct hashmap_entry **oldtable = map->table;
-
-	alloc_table(map, newsize);
-	for (i = 0; i < oldsize; i++) {
-		struct hashmap_entry *e = oldtable[i];
-
-		while (e) {
-			struct hashmap_entry *next = e->next;
-			unsigned int b = bucket(map, e);
-
-			e->next = map->table[b];
-			map->table[b] = e;
-			e = next;
-		}
-	}
-	free(oldtable);
-}
-
-static inline struct hashmap_entry **find_entry_ptr(const struct hashmap *map,
-						    const struct hashmap_entry *key,
-						    const void *keydata)
-{
-	struct hashmap_entry **e = &map->table[bucket(map, key)];
-
-	while (*e && !entry_equals(map, *e, key, keydata))
-		e = &(*e)->next;
-	return e;
-}
-
-static int always_equal(const void *unused1, const void *unused2, const void *unused3)
-{
-	return 0;
-}
-
-void hashmap_init(struct hashmap *map, hashmap_cmp_fn equals_function,
-		  size_t initial_size)
-{
-	unsigned int size = HASHMAP_INITIAL_SIZE;
-
-	map->size = 0;
-	map->cmpfn = equals_function ? equals_function : always_equal;
-
-	/* calculate initial table size and allocate the table */
-	initial_size = (unsigned int)((uint64_t)initial_size * 100
-			/ HASHMAP_LOAD_FACTOR);
-	while (initial_size > size)
-		size <<= HASHMAP_RESIZE_BITS;
-	alloc_table(map, size);
-}
-
-int hashmap_free(struct hashmap *map)
-{
-	if (map && map->table) {
-		struct hashmap_iter iter;
-		struct hashmap_entry *e;
-
-		hashmap_iter_init(map, &iter);
-		e = hashmap_iter_next(&iter);
-		if (e)
-			return -EBUSY;
-
-		free(map->table);
-		memset(map, 0, sizeof(*map));
-	}
-	return 0;
-}
-
-void *hashmap_get(const struct hashmap *map, const void *key, const void *keydata)
-{
-	return *find_entry_ptr(map, key, keydata);
-}
-
-void *hashmap_get_next(const struct hashmap *map, const void *entry)
-{
-	struct hashmap_entry *e = ((struct hashmap_entry *)entry)->next;
-
-	for (; e; e = e->next)
-		if (entry_equals(map, entry, e, NULL))
-			return e;
-	return NULL;
-}
-
-void hashmap_add(struct hashmap *map, void *entry)
-{
-	unsigned int b = bucket(map, entry);
-
-	/* add entry */
-	((struct hashmap_entry *)entry)->next = map->table[b];
-	map->table[b] = entry;
-
-	/* fix size and rehash if appropriate */
-	map->size++;
-	if (map->size > map->grow_at)
-		rehash(map, map->tablesize << HASHMAP_RESIZE_BITS);
-}
-
-void *hashmap_remove(struct hashmap *map, const void *entry)
-{
-	struct hashmap_entry *old;
-	struct hashmap_entry **e = &map->table[bucket(map, entry)];
-
-	while (*e && *e != entry)
-		e = &(*e)->next;
-
-	if (!*e)
-		return NULL;
-
-	/* remove existing entry */
-	old = *e;
-	*e = old->next;
-	old->next = NULL;
-
-	/* fix size and rehash if appropriate */
-	map->size--;
-	if (map->size < map->shrink_at)
-		rehash(map, map->tablesize >> HASHMAP_RESIZE_BITS);
-	return old;
-}
-
-void hashmap_iter_init(struct hashmap *map, struct hashmap_iter *iter)
-{
-	iter->map = map;
-	iter->tablepos = 0;
-	iter->next = NULL;
-}
-
-void *hashmap_iter_next(struct hashmap_iter *iter)
-{
-	struct hashmap_entry *current = iter->next;
-
-	for (;;) {
-		if (current) {
-			iter->next = current->next;
-			return current;
-		}
-
-		if (iter->tablepos >= iter->map->tablesize)
-			return NULL;
-
-		current = iter->map->table[iter->tablepos++];
-	}
-}
-
-struct pool_entry {
-	struct hashmap_entry ent;
-	size_t len;
-	unsigned char data[FLEX_ARRAY];
-};
-
-static int pool_entry_cmp(const struct pool_entry *e1,
-			  const struct pool_entry *e2,
-			  const unsigned char *keydata)
-{
-	return e1->data != keydata &&
-	       (e1->len != e2->len || memcmp(e1->data, keydata, e1->len));
-}
-
-const void *memintern(const void *data, size_t len)
-{
-	static struct hashmap map;
-	struct pool_entry key, *e;
-
-	/* initialize string pool hashmap */
-	if (!map.tablesize)
-		hashmap_init(&map, (hashmap_cmp_fn)pool_entry_cmp, 0);
-
-	/* lookup interned string in pool */
-	hashmap_entry_init(&key, memhash(data, len));
-	key.len = len;
-	e = hashmap_get(&map, &key, data);
-	if (!e) {
-		/* not found: create it */
-		FLEX_ALLOC_MEM(e, data, data, len);
-		hashmap_entry_init(e, key.ent.hash);
-		e->len = len;
-		hashmap_add(&map, e);
-	}
-	return e->data;
-}
-- 
2.47.3


