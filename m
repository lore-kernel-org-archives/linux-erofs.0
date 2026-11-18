Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DD6606A320
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Nov 2026 18:29:53 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jV9B74dvJz2xdX;
	Thu, 19 Nov 2026 05:29:51 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=165.204.217.251
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795026591;
	cv=none; b=XgCqDlRgh9tu9xhNMxYn/0/k8how2JuU2nlmXDAnsUhHSRg30F+IVCdfraUh/jpqKS/JUl7gy1bavOLoNNrdvn+gbY3vNhI+I/GIGn8msuTOUo5CQ9PfEwNAML5NhvPWOyRzVh3vZDh7EWLottRK7a6MYhgG4TKsuwbKiZYiCt3FqienKDHQNt58ai4es3muaNrTrXkaIXX+JhShah6MlbvZ/jCOinAhTlEYN5k4Afc2b8/tNxVrRPdA2n+rreJ85rYeqWp8oAo821aGIZ5Bf9OtZ9LBFV36ciVbXvYpvKnpeolpZgX93IACs4JdEZ/8QQQqu3VMFbFIBA/IiL3cIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795026591; c=relaxed/relaxed;
	bh=A3tNeCSwoWjCDDSBQNWxvSnoX2IEsF19TkW/KxRFqtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDk8vdAMhRo1HySVw2kGoSjHJpZ/g7Ba/jOZfI15UAd4Ah/SoaQUkRAiCu+kmBf2M+ZOHfqc7uZUWi/l0AMCZTp+7anOTIlomeCdGLXLv2B3h2lYFCL8HmG3YkAxSBPQC6Ma8AEblv0aSBldUOhJfB8q/7SMeZOu/XoMPKifbJCNG1FB3D6GRO9QehUSnQ2sjICRs96fAOXh38XOhicoTcpAtcL2rhO1desDA3BLCvKJDy1Jf8osDygSNPFYW4xcLcdat0+ODKsunHP7S/gNdeULQ5XBSxYR5kUW/DHR3rf6qrilGANi+GwrCyUcVyXOzxerFjMGCcvCxKDPptAVyg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=none (client-ip=165.204.217.251; helo=aocl-turin-03-9e62.amd.com; envelope-from=amd@aocl-turin-03-9e62.amd.com; receiver=lists.ozlabs.org) smtp.mailfrom=aocl-turin-03-9e62.amd.com
Authentication-Results: lists.ozlabs.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=aocl-turin-03-9e62.amd.com (client-ip=165.204.217.251; helo=aocl-turin-03-9e62.amd.com; envelope-from=amd@aocl-turin-03-9e62.amd.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 362 seconds by postgrey-1.37 at boromir; Thu, 19 Nov 2026 05:29:49 AEDT
Received: from aocl-turin-03-9e62.amd.com (unknown [165.204.217.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jV9B5407Hz2xMt
	for <linux-erofs@lists.ozlabs.org>; Thu, 19 Nov 2026 05:29:49 +1100 (AEDT)
Received: by aocl-turin-03-9e62.amd.com (Postfix, from userid 1000)
	id 3237617202BA; Wed, 18 Nov 2026 18:23:43 +0000 (UTC)
From: "S. Biplab Raut" <Biplab.Raut@amd.com>
To: Michal Wilczynski <m.wilczynski@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Gao Xiang <xiang@kernel.org>,
	linux-erofs@lists.ozlabs.org,
	Yann Collet <yann.collet.73@gmail.com>,
	Nick Terrell <terrelln@meta.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>,
	Rae Moar <raemoar63@gmail.com>,
	kunit-dev@googlegroups.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] lib/lz4: add KUnit tests for compression and decompression
Date: Wed, 18 Nov 2026 18:23:43 +0000
Message-ID: <20261118182343.1628236-1-Biplab.Raut@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

lib/lz4 has no in-tree tests, and this series replaces both the
compressor and the decompressor.  Add KUnit suites for the behaviour
callers rely on.

lz4_decompress:
 - round-trips through LZ4_decompress_safe() and
   LZ4_decompress_safe_partial() with exact, oversized and partial
   capacities;
 - truncated and corrupted blocks never write past the destination,
   through either entry point.  The input sits at the end of its
   allocation, so KASAN also reports over-reads;
 - an offset-0 match decodes the same whatever the buffer held before;
 - literal and match lengths longer than the output are rejected.  On
   32-bit, lengths whose extension bytes sum to SIZE_MAX are rejected
   rather than wrapped;
 - in-place decoding within LZ4_DECOMPRESS_INPLACE_MARGIN() leaves the
   output intact.  A fixed block that corrupts with the old +32 margin
   covers the vendored decoder's 32-byte wild copies, and a port of
   upstream's worst-case test covers the 64-byte copies its decoder
   makes since v1.11.0.

lz4_compress:
 - LZ4_compress_default() fits LZ4_COMPRESSBOUND(), and with a smaller
   buffer fails rather than overflowing;
 - LZ4_compress_fast() across documented acceleration boundaries;
 - LZ4_compress_destSize() output decodes to exactly the consumed
   prefix;
 - the dictionary paths of zram's lz4 and lz4hc backends;
 - LZ4_compress_HC() across supported levels, including the kernel's
   clamp boundary, with full and limited output.

Work memory is allocated at exactly LZ4_MEM_COMPRESS, LZ4HC_MEM_COMPRESS
and LZ4_MEM_DECOMPRESS bytes, so KASAN reports an implementation that
outgrows them.

Without this series, the 32-bit length case fails on i386 ("long match
accepted: ret=31"): the old decoder wraps the match length to 18 bytes
and accepts the block.

Signed-off-by: S. Biplab Raut <Biplab.Raut@amd.com>
---

Michal, this goes on top of your v2: it uses LZ4_MEM_DECOMPRESS and the
opaque stream types, so please fold it into v3 if you find it useful.

The tests are deterministic regression tests.  Every randomized case
uses a fixed seed, so each run checks the same inputs and any failure
reproduces exactly.  The in-place suite has two fixed cases:

 - a block that corrupts with the old (compressedSize >> 8) + 32 margin
   under a 32-byte fast loop, the case patch 12 fixes;

 - a port of upstream's decompress_safe_inPlace_worstCase test [1]:
   fixed noise with a 65-byte match at offset 65, for every source size
   from 300 to 4096.

On patch 12 and the +65 margin: since v1.11.0, upstream's decoder makes
64-byte wild copies on x86-64, aarch64 and ppc64, and upstream has raised
its margin to (compressedSize >> 8) + 65 to match [1].  That fix is on
the dev branch for v1.11.2; the released v1.11.0 and v1.11.1 headers
still say +32.  Your v1.10.0 import uses the 32-byte loop, so +36 is
right for this series.  A later re-sync to v1.11.0 or newer needs the
kernel's margin raised to +65 in the same patch, whatever the upstream
header at that tag says.

I checked that the worst-case test catches this, using a userspace
build of the same test.  Against upstream dev's decoder, all 3797 sizes
fail at +36 and none fail at +65.  Against your vendored v1.10.0
decoder, none fail at +36.

The HC cases are built only when LZ4HC_COMPRESS is reachable.

With your v2 applied on v7.3-rc4, the suite passes on UML (17 passed,
one 32-bit-only skip), on i386 (18 passed), and on x86_64 with KASAN and
KASAN_VMALLOC (17 passed, the same skip).  A UML build without
LZ4HC_COMPRESS passes 15 tests with the same skip.

[1] https://github.com/lz4/lz4/pull/2104

 lib/Kconfig               |  15 +
 lib/lz4/.kunitconfig      |   5 +
 lib/lz4/Makefile          |   1 +
 lib/lz4/tests/Makefile    |   2 +
 lib/lz4/tests/lz4_kunit.c | 911 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 934 insertions(+)
 create mode 100644 lib/lz4/.kunitconfig
 create mode 100644 lib/lz4/tests/Makefile
 create mode 100644 lib/lz4/tests/lz4_kunit.c

diff --git a/lib/Kconfig b/lib/Kconfig
index 4e6b34c3346d..74e272a4173b 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -199,6 +199,21 @@ config LZ4HC_COMPRESS
 config LZ4_DECOMPRESS
 	tristate
 
+config LZ4_KUNIT_TEST
+	tristate "KUnit tests for the LZ4 compression library" if !KUNIT_ALL_TESTS
+	depends on KUNIT && LZ4_COMPRESS && LZ4_DECOMPRESS
+	default KUNIT_ALL_TESTS
+	help
+	  KUnit tests for lib/lz4: block round-trips, malformed and over-long
+	  input, in-place decompression within LZ4_DECOMPRESS_INPLACE_MARGIN(),
+	  the dictionary paths zram uses and, when LZ4HC_COMPRESS is enabled,
+	  the HC compressor.
+
+	  For more information on KUnit and unit tests in general,
+	  please refer to the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  If unsure, say N.
+
 config ZSTD_COMMON
 	select XXHASH
 	tristate
diff --git a/lib/lz4/.kunitconfig b/lib/lz4/.kunitconfig
new file mode 100644
index 000000000000..34f775556620
--- /dev/null
+++ b/lib/lz4/.kunitconfig
@@ -0,0 +1,5 @@
+CONFIG_KUNIT=y
+CONFIG_CRYPTO=y
+CONFIG_CRYPTO_LZ4=y
+CONFIG_CRYPTO_LZ4HC=y
+CONFIG_LZ4_KUNIT_TEST=y
diff --git a/lib/lz4/Makefile b/lib/lz4/Makefile
index 5cbbe10beedc..89bdb729672e 100644
--- a/lib/lz4/Makefile
+++ b/lib/lz4/Makefile
@@ -10,6 +10,7 @@ ccflags-y += -I $(src)/freestanding
 obj-$(CONFIG_LZ4_COMPRESS)	+= lz4_compress.o
 obj-$(CONFIG_LZ4HC_COMPRESS)	+= lz4hc_compress.o
 obj-$(CONFIG_LZ4_DECOMPRESS)	+= lz4_decompress.o
+obj-$(CONFIG_LZ4_KUNIT_TEST)	+= tests/
 
 # lz4hc.c pulls in lz4.c's common definitions, which include two decoder
 # tables nothing here uses when LZ4_FAST_DEC_LOOP is off.
diff --git a/lib/lz4/tests/Makefile b/lib/lz4/tests/Makefile
new file mode 100644
index 000000000000..cd5186b52372
--- /dev/null
+++ b/lib/lz4/tests/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_LZ4_KUNIT_TEST) += lz4_kunit.o
diff --git a/lib/lz4/tests/lz4_kunit.c b/lib/lz4/tests/lz4_kunit.c
new file mode 100644
index 000000000000..d44a68142b51
--- /dev/null
+++ b/lib/lz4/tests/lz4_kunit.c
@@ -0,0 +1,911 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KUnit tests for the LZ4 compression library.
+ *
+ * Copyright (C) 2026 Advanced Micro Devices, Inc.
+ */
+#include <kunit/test.h>
+#include <linux/array_size.h>
+#include <linux/limits.h>
+#include <linux/lz4.h>
+#include <linux/minmax.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+
+#define LZ4_KUNIT_MAX_SIZE	8192
+#define LZ4_KUNIT_GUARD		64
+#define LZ4_KUNIT_POISON	0xab
+#define LZ4_KUNIT_PAGE		4096
+#define LZ4_KUNIT_DICT_SIZE	8192
+#define LZ4_KUNIT_INPLACE_MIN	300
+#define LZ4_KUNIT_INPLACE_MAX	4096
+#define LZ4_KUNIT_INPLACE_OFFSET	65
+
+/* Work per randomized case.  The seeds are fixed, so every run is the same. */
+#define LZ4_KUNIT_ROUNDTRIP_ITERS	4000
+#define LZ4_KUNIT_MALFORMED_ITERS	4000
+#define LZ4_KUNIT_CORRUPT_BYTES		3
+#define LZ4_KUNIT_INPLACE_ITERS		30000
+#define LZ4_KUNIT_COMPRESS_ITERS	1500
+#define LZ4_KUNIT_ACCEL_ITERS		200
+#define LZ4_KUNIT_DICT_ITERS		500
+#define LZ4_KUNIT_HC_LEVEL_ITERS	60
+#define LZ4_KUNIT_HC_DICT_ITERS		100
+
+KUNIT_DEFINE_ACTION_WRAPPER(lz4_kunit_kvfree, kvfree, const void *);
+
+/* zeroed, and freed when the case ends even if an assertion aborts it */
+static void *lz4_kunit_alloc(struct kunit *test, size_t size)
+{
+	void *p = kvzalloc(size, GFP_KERNEL);
+
+	KUNIT_ASSERT_NOT_NULL(test, p);
+	KUNIT_ASSERT_EQ(test, 0,
+			kunit_add_action_or_reset(test, lz4_kunit_kvfree, p));
+	return p;
+}
+
+/* deterministic xorshift32, so every run sees the same streams */
+static u32 prng(u32 *s)
+{
+	u32 x = *s;
+
+	x ^= x << 13;
+	x ^= x >> 17;
+	x ^= x << 5;
+	return (*s = x);
+}
+
+/*
+ * Structured data that makes the compressor emit every token shape: short
+ * and long literal runs, short and long matches, and offsets below 8, 8..15
+ * and beyond.  @lit_pct is the percentage of literal runs.
+ */
+static void gen(u8 *buf, int size, u32 *s, int lit_pct)
+{
+	int pos = 0;
+
+	while (pos < size) {
+		int mtype = prng(s) % 100;
+		int i;
+
+		if (pos == 0 || mtype < lit_pct) {
+			int lit = 1 + prng(s) % 40;
+
+			if ((prng(s) & 7) == 0)
+				lit += prng(s) % 300;
+			lit = min(lit, size - pos);
+			for (i = 0; i < lit; i++)
+				buf[pos + i] = prng(s);
+			pos += lit;
+		} else {
+			int off, len;
+
+			switch (prng(s) & 3) {
+			case 0:
+				off = 1 + prng(s) % 7;
+				break;
+			case 1:
+				off = 8 + prng(s) % 8;
+				break;
+			default:
+				off = 1 + prng(s) % min(pos, 65535);
+				break;
+			}
+			off = min(off, pos);
+			len = 4 + prng(s) % 40;
+			if ((prng(s) & 7) == 0)
+				len += prng(s) % 400;
+			len = min(len, size - pos);
+			for (i = 0; i < len; i++)
+				buf[pos + i] = buf[pos - off + i];
+			pos += len;
+		}
+	}
+}
+
+enum { FILL_RANDOM, FILL_MIXED, FILL_ZERO, FILL_SHAPES };
+
+static void fill(u8 *buf, int size, u32 *s, int shape)
+{
+	int i;
+
+	switch (shape) {
+	case FILL_RANDOM:
+		for (i = 0; i < size; i++)
+			buf[i] = prng(s);
+		break;
+	case FILL_MIXED:
+		gen(buf, size, s, 10 + prng(s) % 85);
+		break;
+	default:
+		memset(buf, 0, size);
+		break;
+	}
+}
+
+static void fill_fixed_noise(u8 *buf, int size)
+{
+	u32 s = 0x5eed1234;
+	int i;
+
+	for (i = 0; i < size; i++)
+		buf[i] = prng(&s);
+}
+
+static void poison(u8 *p, int cap)
+{
+	memset(p + cap, LZ4_KUNIT_POISON, LZ4_KUNIT_GUARD);
+}
+
+static bool guard_ok(const u8 *p, int cap)
+{
+	return !memchr_inv(p + cap, LZ4_KUNIT_POISON, LZ4_KUNIT_GUARD);
+}
+
+/*
+ * Copy @n bytes to the very end of the @cap-byte allocation @buf, so that
+ * KASAN reports any read past the end of the compressed input.
+ */
+static const u8 *at_tail(u8 *buf, int cap, const u8 *src, int n)
+{
+	memcpy(buf + cap - n, src, n);
+	return buf + cap - n;
+}
+
+static int lz4_comp(const u8 *src, u8 *dst, int n, int cap, void *wrk)
+{
+	return LZ4_compress_default((const char *)src, (char *)dst, n, cap,
+				    wrk);
+}
+
+static int lz4_dec(const u8 *src, u8 *dst, int csize, int cap)
+{
+	return LZ4_decompress_safe((const char *)src, (char *)dst, csize, cap);
+}
+
+static int lz4_dec_partial(const u8 *src, u8 *dst, int csize, int target,
+			   int cap)
+{
+	return LZ4_decompress_safe_partial((const char *)src, (char *)dst,
+					   csize, target, cap);
+}
+
+static bool decodes_to(const u8 *c, int csize, const u8 *ref, int size,
+		       u8 *dst)
+{
+	return lz4_dec(c, dst, csize, size) == size && !memcmp(dst, ref, size);
+}
+
+/* ---- decompression ---------------------------------------------------- */
+
+static void lz4_decompress_test_roundtrip(struct kunit *test)
+{
+	const int max = LZ4_KUNIT_MAX_SIZE, cbound = LZ4_COMPRESSBOUND(max);
+	u8 *src = lz4_kunit_alloc(test, max);
+	u8 *comp = lz4_kunit_alloc(test, cbound);
+	u8 *in = lz4_kunit_alloc(test, cbound);
+	u8 *dst = lz4_kunit_alloc(test, max + 64 + LZ4_KUNIT_GUARD);
+	void *wrk = lz4_kunit_alloc(test, LZ4_MEM_COMPRESS);
+	u32 s = 0x1234567;
+	int fails = 0, it;
+
+	for (it = 0; it < LZ4_KUNIT_ROUNDTRIP_ITERS; it++) {
+		int size = 1 + prng(&s) % max;
+		int csize, r, k;
+		const u8 *c;
+
+		gen(src, size, &s, 10 + prng(&s) % 85);
+		csize = lz4_comp(src, comp, size, cbound, wrk);
+		if (csize <= 0) {
+			fails++;
+			continue;
+		}
+		c = at_tail(in, cbound, comp, csize);
+
+		poison(dst, size);
+		r = lz4_dec(c, dst, csize, size);
+		if (r != size || memcmp(dst, src, size) || !guard_ok(dst, size))
+			fails++;
+
+		poison(dst, size + 37);
+		r = lz4_dec(c, dst, csize, size + 37);
+		if (r != size || memcmp(dst, src, size) ||
+		    !guard_ok(dst, size + 37))
+			fails++;
+
+		k = 1 + prng(&s) % size;
+		poison(dst, k);
+		r = lz4_dec_partial(c, dst, csize, k, k);
+		if (r != k || memcmp(dst, src, k) || !guard_ok(dst, k))
+			fails++;
+
+		poison(dst, size);
+		r = lz4_dec_partial(c, dst, csize, k, size);
+		if (r < k || r > size || memcmp(dst, src, r) ||
+		    !guard_ok(dst, size))
+			fails++;
+	}
+
+	KUNIT_EXPECT_EQ_MSG(test, fails, 0, "round-trip failures: %d", fails);
+}
+
+static void lz4_decompress_test_malformed(struct kunit *test)
+{
+	const int max = LZ4_KUNIT_MAX_SIZE, cbound = LZ4_COMPRESSBOUND(max);
+	u8 *src = lz4_kunit_alloc(test, max);
+	u8 *comp = lz4_kunit_alloc(test, cbound);
+	u8 *in = lz4_kunit_alloc(test, cbound);
+	u8 *dst = lz4_kunit_alloc(test, max + LZ4_KUNIT_GUARD);
+	void *wrk = lz4_kunit_alloc(test, LZ4_MEM_COMPRESS);
+	u32 s = 0x0badc0de;
+	int bad = 0, it;
+
+	for (it = 0; it < LZ4_KUNIT_MALFORMED_ITERS; it++) {
+		int size = 16 + prng(&s) % (max - 16);
+		int csize, clen, k, i, r;
+		const u8 *c;
+
+		gen(src, size, &s, 10 + prng(&s) % 85);
+		csize = lz4_comp(src, comp, size, cbound, wrk);
+		if (csize <= 0)
+			continue;
+
+		clen = 1 + prng(&s) % csize;
+		for (i = 0; i < LZ4_KUNIT_CORRUPT_BYTES; i++)
+			comp[prng(&s) % clen] = prng(&s);
+		c = at_tail(in, cbound, comp, clen);
+
+		/* any result is acceptable except writing past the capacity */
+		poison(dst, size);
+		r = lz4_dec(c, dst, clen, size);
+		if (r > size || !guard_ok(dst, size))
+			bad++;
+
+		k = 1 + prng(&s) % size;
+		poison(dst, size);
+		r = lz4_dec_partial(c, dst, clen, k, size);
+		if (r > size || !guard_ok(dst, size))
+			bad++;
+	}
+
+	KUNIT_EXPECT_EQ_MSG(test, bad, 0, "malformed input overran dst: %d", bad);
+}
+
+/*
+ * Offset 0 makes match == op.  Decode the same stream into buffers
+ * pre-filled with 0x00 and 0xff: if the decoder accepts it, the output must
+ * not depend on stale buffer contents.  Literal runs that are multiples of
+ * 32 end the fast loop's wild copy exactly at op.
+ */
+static int build_offset0_block(u8 *comp, int l1, int total)
+{
+	int lf = total - (l1 + 4);
+	int p = 0, i, rem;
+
+	comp[p++] = 0xf0;			/* extended literals, ML 0 */
+	for (rem = l1 - 15; rem >= 255; rem -= 255)
+		comp[p++] = 0xff;
+	comp[p++] = rem;
+	for (i = 0; i < l1; i++)
+		comp[p++] = 0x41 + (i & 31);
+	comp[p++] = 0x00;			/* offset 0 */
+	comp[p++] = 0x00;
+	comp[p++] = 0xf0;			/* last literals */
+	for (rem = lf - 15; rem >= 255; rem -= 255)
+		comp[p++] = 0xff;
+	comp[p++] = rem;
+	for (i = 0; i < lf; i++)
+		comp[p++] = 0x61 + (i & 31);
+	return p;
+}
+
+static void lz4_decompress_test_offset0(struct kunit *test)
+{
+	static const int l1s[] = { 32, 64, 96 };
+	const int total = 400;
+	u8 *comp = lz4_kunit_alloc(test, 512);
+	u8 *d0 = lz4_kunit_alloc(test, total + LZ4_KUNIT_GUARD);
+	u8 *df = lz4_kunit_alloc(test, total + LZ4_KUNIT_GUARD);
+	unsigned int k;
+	int bad = 0;
+
+	for (k = 0; k < ARRAY_SIZE(l1s); k++) {
+		int csize = build_offset0_block(comp, l1s[k], total);
+		int r0, rf;
+
+		memset(d0, 0x00, total);
+		memset(df, 0xff, total);
+		poison(d0, total);
+		poison(df, total);
+		r0 = lz4_dec(comp, d0, csize, total);
+		rf = lz4_dec(comp, df, csize, total);
+		if (r0 != rf || (r0 > 0 && memcmp(d0, df, r0)) ||
+		    !guard_ok(d0, total) || !guard_ok(df, total))
+			bad++;
+	}
+
+	KUNIT_EXPECT_EQ_MSG(test, bad, 0, "offset-0 stale read: %d", bad);
+}
+
+/*
+ * A literal run of 15 + 255 * @ext bytes.  On 32-bit, @ext == SIZE_MAX / 255
+ * makes that 15 + SIZE_MAX, which wraps to 14: a decoder that wraps sees the
+ * 14 trailing bytes as the whole run and accepts the block.
+ */
+static int build_long_literals(u8 *p, size_t ext)
+{
+	int n = 0;
+
+	p[n++] = 0xf0;
+	memset(p + n, 0xff, ext);
+	n += ext;
+	p[n++] = 0x00;
+	memset(p + n, 'L', 14);
+	return n + 14;
+}
+
+/* 8 literals, then a match of 4 + 15 + 255 * @ext bytes at offset 1 */
+static int build_long_match(u8 *p, size_t ext)
+{
+	int n = 0;
+
+	p[n++] = 0x8f;
+	memset(p + n, 'M', 8);
+	n += 8;
+	p[n++] = 0x01;
+	p[n++] = 0x00;
+	memset(p + n, 0xff, ext);
+	n += ext;
+	p[n++] = 0x00;
+	p[n++] = 0x50;				/* last 5 literals */
+	memset(p + n, 'L', 5);
+	return n + 5;
+}
+
+static void expect_rejected(struct kunit *test, const u8 *c, int csize,
+			    const char *what)
+{
+	const int cap = 4096;
+	u8 *dst = lz4_kunit_alloc(test, cap + LZ4_KUNIT_GUARD);
+	int r;
+
+	poison(dst, cap);
+	r = lz4_dec(c, dst, csize, cap);
+	KUNIT_EXPECT_LT_MSG(test, r, 0, "%s accepted: ret=%d", what, r);
+	KUNIT_EXPECT_TRUE_MSG(test, guard_ok(dst, cap), "%s overran dst", what);
+
+	/* partial decoding may stop early, but must stay within capacity */
+	poison(dst, cap);
+	r = lz4_dec_partial(c, dst, csize, cap, cap);
+	KUNIT_EXPECT_LE_MSG(test, r, cap, "%s partial: ret=%d", what, r);
+	KUNIT_EXPECT_TRUE_MSG(test, guard_ok(dst, cap),
+			      "%s partial overran dst", what);
+}
+
+/* @buf holds ext + 18 bytes; both streams end exactly at its end */
+static void expect_long_lengths_rejected(struct kunit *test, u8 *buf,
+					 size_t ext)
+{
+	expect_rejected(test, buf + 2, build_long_literals(buf + 2, ext),
+			"long literal run");
+	expect_rejected(test, buf, build_long_match(buf, ext), "long match");
+}
+
+static void lz4_decompress_test_overlong(struct kunit *test)
+{
+	const size_t ext = 20000;		/* ~5 MB against 4 KB */
+
+	expect_long_lengths_rejected(test, lz4_kunit_alloc(test, ext + 18), ext);
+}
+
+static void lz4_decompress_test_length_wrap(struct kunit *test)
+{
+	const size_t ext = SIZE_MAX / 255;	/* 255 * ext == SIZE_MAX */
+
+	if (IS_ENABLED(CONFIG_64BIT))
+		kunit_skip(test, "needs a 32-bit size_t");
+
+	expect_long_lengths_rejected(test, lz4_kunit_alloc(test, ext + 18), ext);
+}
+
+/*
+ * In-place decoding: a buffer of
+ *   decompressedSize + LZ4_DECOMPRESS_INPLACE_MARGIN(compressedSize)
+ * bytes with the compressed data at its tail.  The margin must cover the
+ * decoder's widest wild copy, or the writer clobbers input it has not read.
+ *
+ * inplace_vec[] decodes to 384 bytes and corrupts in place with the
+ * historical (compressedSize >> 8) + 32 margin under a decoder whose fast
+ * loop copies 32 bytes at a time.
+ */
+static const u8 inplace_vec[] = {
+	0xff, 0x3a, 0xd0, 0x4f, 0xfc, 0xf8, 0x51, 0x87, 0x29, 0x7a, 0x58, 0x6e,
+	0x7d, 0x89, 0x2c, 0x16, 0x6d, 0x17, 0xb7, 0x27, 0x7e, 0x08, 0x4b, 0xdb,
+	0xaf, 0x7f, 0x7a, 0x19, 0xdb, 0xf1, 0x8a, 0xcb, 0xc9, 0x21, 0x83, 0xc5,
+	0x26, 0xd9, 0x37, 0x5c, 0x2d, 0xf3, 0x39, 0x59, 0xb9, 0x9e, 0x8b, 0x9a,
+	0xb7, 0x05, 0xd4, 0x4f, 0x8d, 0x36, 0x72, 0xab, 0x6d, 0x31, 0x94, 0x64,
+	0x8e, 0x39, 0x3b, 0x68, 0x51, 0xa9, 0x7c, 0x58, 0xb1, 0x03, 0x57, 0x0f,
+	0x4b, 0x27, 0xcf, 0x18, 0x00, 0x0e, 0xf0, 0xff, 0x08, 0x15, 0x20, 0x99,
+	0x5c, 0x28, 0xe4, 0xb0, 0x4b, 0xc3, 0x89, 0x6a, 0x02, 0xc2, 0x91, 0xdc,
+	0xfd, 0xe2, 0x36, 0x4c, 0x45, 0x97, 0x46, 0xf0, 0x20, 0xe2, 0x6b, 0xee,
+	0x9d, 0xbf, 0x44, 0x38, 0x74, 0xe3, 0x36, 0xc8, 0x8e, 0xc5, 0x5f, 0x84,
+	0xcb, 0x1a, 0x4a, 0x6e, 0x72, 0x66, 0x57, 0x77, 0x73, 0xdf, 0x37, 0xbd,
+	0xa0, 0x3b, 0xd9, 0x26, 0x76, 0xc4, 0x5c, 0x94, 0xa0, 0x8f, 0x0b, 0x81,
+	0xdf, 0xe1, 0xe6, 0x5a, 0x5e, 0xf0, 0x9d, 0xa9, 0x9f, 0xe6, 0x07, 0xf3,
+	0x8d, 0x64, 0xfd, 0x62, 0x17, 0x74, 0x2b, 0xdb, 0x72, 0xea, 0x72, 0x1b,
+	0x53, 0x75, 0x25, 0xab, 0xda, 0xe1, 0xe4, 0x96, 0x27, 0x20, 0xc3, 0xcc,
+	0x68, 0x3d, 0x59, 0x30, 0xbf, 0xb6, 0x0f, 0xcb, 0x56, 0x0a, 0x31, 0xbe,
+	0x18, 0xf8, 0x24, 0x14, 0xe4, 0x6e, 0x96, 0x22, 0xd0, 0x06, 0xdf, 0x91,
+	0x85, 0xa2, 0x8e, 0x1b, 0x05, 0x95, 0x7d, 0x1e, 0x51, 0x8a, 0x81, 0xc7,
+	0xad, 0x39, 0xf6, 0xb9, 0xf5, 0xe4, 0x38, 0x8e, 0x30, 0x22, 0x76, 0x4f,
+	0xa2, 0x1a, 0xcf, 0xa0, 0xea, 0x6c, 0x4e, 0x0d, 0x7d, 0xa3, 0xac, 0x69,
+	0xa8, 0x54, 0xe3, 0xbb, 0x89, 0x41, 0x27, 0x7e, 0x29, 0xba, 0x19, 0xa8,
+	0x40, 0xce, 0x29, 0x5c, 0x92, 0xba, 0x47, 0x51, 0x9c, 0x5a, 0x4f, 0xaf,
+	0xce, 0xa7, 0x9d, 0x1a, 0xfd, 0xcd, 0xb7, 0x44, 0x2a, 0x62, 0x3d, 0x54,
+	0x9b, 0x19, 0xbc, 0x24, 0x4a, 0xc0, 0x6a, 0x5d, 0xac, 0xb1, 0x4f, 0x08,
+	0x00, 0xb1, 0x95, 0x04, 0xae, 0x40, 0xed, 0xfc, 0x69, 0xd5, 0x6e, 0x13,
+	0xa9, 0xb7, 0x3d, 0x67, 0xdf, 0xb6, 0x60, 0x8a, 0x3c, 0x62, 0xcb, 0x50,
+	0x13, 0x96, 0x85, 0x62, 0x80, 0xb1, 0xe7, 0x14, 0x60, 0xe4, 0xc9, 0x78,
+	0xe1, 0x43, 0x4f, 0xdf, 0x39, 0xa0, 0x1e, 0x28, 0x8a, 0xaa, 0x41, 0x94,
+	0x86, 0x4b, 0xdf, 0xba, 0xf3, 0x69, 0x8d, 0xa8, 0x36, 0xfa, 0xd9, 0xaa,
+	0x8e, 0xe3, 0xc5, 0xde, 0xee, 0x45, 0x10, 0x4f, 0xb0, 0x53, 0xdc,
+};
+
+#define INPLACE_VEC_OUT 384
+
+static bool inplace_ok(const u8 *comp, int csize, const u8 *ref, int size,
+		       u8 *buf, int bufcap)
+{
+	int n = size + LZ4_DECOMPRESS_INPLACE_MARGIN(csize);
+	int r;
+
+	if (bufcap < LZ4_KUNIT_GUARD ||
+	    n > bufcap - LZ4_KUNIT_GUARD)
+		return false;
+
+	memset(buf, 0, n);
+	poison(buf, n);
+	memcpy(buf + n - csize, comp, csize);
+	r = lz4_dec(buf + n - csize, buf, csize, size);
+	return r == size && !memcmp(buf, ref, size) && guard_ok(buf, n);
+}
+
+static void lz4_decompress_test_inplace(struct kunit *test)
+{
+	const int max = LZ4_KUNIT_MAX_SIZE, cbound = LZ4_COMPRESSBOUND(max);
+	const int bufcap = max + 256;
+	u8 *src = lz4_kunit_alloc(test, max);
+	u8 *ref = lz4_kunit_alloc(test, max);
+	u8 *comp = lz4_kunit_alloc(test, cbound);
+	u8 *buf = lz4_kunit_alloc(test, bufcap);
+	void *wrk = lz4_kunit_alloc(test, LZ4_MEM_COMPRESS);
+	u32 s = 0x51ab1e00;
+	int fails = 0, it;
+
+	KUNIT_ASSERT_EQ(test, INPLACE_VEC_OUT,
+			lz4_dec(inplace_vec, ref, sizeof(inplace_vec),
+				INPLACE_VEC_OUT));
+	KUNIT_EXPECT_TRUE_MSG(test,
+			      inplace_ok(inplace_vec, sizeof(inplace_vec), ref,
+					 INPLACE_VEC_OUT, buf, bufcap),
+			      "vector corrupts in place at margin %d",
+			      LZ4_DECOMPRESS_INPLACE_MARGIN((int)sizeof(inplace_vec)));
+
+	for (it = 0; it < LZ4_KUNIT_INPLACE_ITERS; it++) {
+		int size = 64 + prng(&s) % (max - 64);
+		int csize;
+
+		gen(src, size, &s, 10 + prng(&s) % 85);
+		csize = lz4_comp(src, comp, size, cbound, wrk);
+		if (csize <= 0 || !decodes_to(comp, csize, src, size, ref))
+			continue;
+		if (!inplace_ok(comp, csize, ref, size, buf, bufcap))
+			fails++;
+	}
+
+	KUNIT_EXPECT_EQ_MSG(test, fails, 0,
+			    "in-place corruption at LZ4_DECOMPRESS_INPLACE_MARGIN: %d",
+			    fails);
+}
+
+/*
+ * This mirrors upstream's decompress_safe_inPlace_worstCase test, added with
+ * the +65 margin fix for the 64-byte wild copies of its v1.11.0 decoder.  A
+ * 65-byte match at offset 65 makes such a copy visible when the in-place
+ * margin is too small.
+ */
+static void lz4_decompress_test_inplace_worst_case(struct kunit *test)
+{
+	const int max = LZ4_KUNIT_INPLACE_MAX;
+	const int cbound = LZ4_COMPRESSBOUND(max);
+	const int bufcap = max +
+		LZ4_DECOMPRESS_INPLACE_MARGIN(cbound) + LZ4_KUNIT_GUARD;
+	u8 *src = lz4_kunit_alloc(test, max);
+	u8 *ref = lz4_kunit_alloc(test, max);
+	u8 *comp = lz4_kunit_alloc(test, cbound);
+	u8 *buf = lz4_kunit_alloc(test, bufcap);
+	void *wrk = lz4_kunit_alloc(test, LZ4_MEM_COMPRESS);
+	int fails = 0, size;
+
+	for (size = LZ4_KUNIT_INPLACE_MIN; size <= max; size++) {
+		int csize, r;
+
+		fill_fixed_noise(src, size);
+		memcpy(src + LZ4_KUNIT_INPLACE_OFFSET, src,
+		       LZ4_KUNIT_INPLACE_OFFSET);
+		csize = lz4_comp(src, comp, size, cbound, wrk);
+		if (csize <= 0 || csize >= size) {
+			fails++;
+			continue;
+		}
+
+		r = lz4_dec(comp, ref, csize, size);
+		if (r != size || memcmp(ref, src, size)) {
+			fails++;
+			continue;
+		}
+
+		if (!inplace_ok(comp, csize, ref, size, buf, bufcap))
+			fails++;
+	}
+
+	KUNIT_EXPECT_EQ_MSG(test, fails, 0,
+			    "in-place worst-case failures: %d", fails);
+}
+
+/* ---- compression ------------------------------------------------------ */
+
+static void lz4_compress_test_bound(struct kunit *test)
+{
+	const int max = LZ4_KUNIT_MAX_SIZE, cbound = LZ4_COMPRESSBOUND(max);
+	u8 *src = lz4_kunit_alloc(test, max);
+	u8 *comp = lz4_kunit_alloc(test, cbound + LZ4_KUNIT_GUARD);
+	u8 *dst = lz4_kunit_alloc(test, max);
+	void *wrk = lz4_kunit_alloc(test, LZ4_MEM_COMPRESS);
+	u32 s = 0xb0b0cafe;
+	int fails = 0, it, r;
+
+	r = lz4_comp(src, comp, 0, cbound, wrk);
+	KUNIT_ASSERT_GT(test, r, 0);
+	KUNIT_EXPECT_EQ(test, lz4_dec(comp, dst, r, 0), 0);
+
+	for (it = 0; it < LZ4_KUNIT_COMPRESS_ITERS; it++) {
+		int size = 1 + prng(&s) % max;
+		int bound = LZ4_COMPRESSBOUND(size);
+
+		fill(src, size, &s, it % FILL_SHAPES);
+		poison(comp, bound);
+		r = lz4_comp(src, comp, size, bound, wrk);
+		if (r <= 0 || r > bound || !guard_ok(comp, bound) ||
+		    !decodes_to(comp, r, src, size, dst))
+			fails++;
+	}
+
+	KUNIT_EXPECT_EQ_MSG(test, fails, 0, "LZ4_COMPRESSBOUND failures: %d",
+			    fails);
+}
+
+static void lz4_compress_test_limited(struct kunit *test)
+{
+	const int max = LZ4_KUNIT_MAX_SIZE, cbound = LZ4_COMPRESSBOUND(max);
+	u8 *src = lz4_kunit_alloc(test, max);
+	u8 *comp = lz4_kunit_alloc(test, cbound);
+	u8 *out = lz4_kunit_alloc(test, cbound + LZ4_KUNIT_GUARD);
+	u8 *dst = lz4_kunit_alloc(test, max);
+	void *wrk = lz4_kunit_alloc(test, LZ4_MEM_COMPRESS);
+	u32 s = 0x11d1ed00;
+	int fails = 0, it;
+
+	for (it = 0; it < LZ4_KUNIT_COMPRESS_ITERS; it++) {
+		int size = 16 + prng(&s) % (max - 16);
+		int full, cap, r;
+
+		fill(src, size, &s, it % FILL_SHAPES);
+		full = lz4_comp(src, comp, size, cbound, wrk);
+		if (full <= 0) {
+			fails++;
+			continue;
+		}
+		switch (it & 3) {
+		case 0:
+			cap = prng(&s) % 16;
+			break;
+		case 1:
+			cap = full / 2;
+			break;
+		case 2:
+			cap = full - 1;
+			break;
+		default:
+			cap = full;
+			break;
+		}
+
+		/* too small a buffer may fail (0), but never overflow */
+		poison(out, cap);
+		r = lz4_comp(src, out, size, cap, wrk);
+		if (r < 0 || r > cap || !guard_ok(out, cap) ||
+		    (r > 0 && !decodes_to(out, r, src, size, dst)))
+			fails++;
+	}
+
+	KUNIT_EXPECT_EQ_MSG(test, fails, 0, "limited-output failures: %d", fails);
+}
+
+static void lz4_compress_test_accel(struct kunit *test)
+{
+	/* 65537 is the upstream acceleration clamp used by zram. */
+	static const int accel[] = { 1, 2, 8, 65537 };
+	const int max = LZ4_KUNIT_MAX_SIZE, cbound = LZ4_COMPRESSBOUND(max);
+	u8 *src = lz4_kunit_alloc(test, max);
+	u8 *comp = lz4_kunit_alloc(test, cbound + LZ4_KUNIT_GUARD);
+	u8 *dst = lz4_kunit_alloc(test, max);
+	void *wrk = lz4_kunit_alloc(test, LZ4_MEM_COMPRESS);
+	u32 s = 0xacce1000;
+	unsigned int i;
+	int fails = 0, it;
+
+	for (i = 0; i < ARRAY_SIZE(accel); i++) {
+		for (it = 0; it < LZ4_KUNIT_ACCEL_ITERS; it++) {
+			int size = 1 + prng(&s) % max;
+			int bound = LZ4_COMPRESSBOUND(size);
+			int r;
+
+			fill(src, size, &s, it % FILL_SHAPES);
+			poison(comp, bound);
+			r = LZ4_compress_fast((const char *)src, (char *)comp,
+					      size, bound, accel[i], wrk);
+			if (r <= 0 || r > bound || !guard_ok(comp, bound) ||
+			    !decodes_to(comp, r, src, size, dst))
+				fails++;
+		}
+	}
+
+	KUNIT_EXPECT_EQ_MSG(test, fails, 0, "LZ4_compress_fast failures: %d",
+			    fails);
+}
+
+static void lz4_compress_test_destsize(struct kunit *test)
+{
+	const int max = LZ4_KUNIT_MAX_SIZE, cbound = LZ4_COMPRESSBOUND(max);
+	u8 *src = lz4_kunit_alloc(test, max);
+	u8 *comp = lz4_kunit_alloc(test, cbound + LZ4_KUNIT_GUARD);
+	u8 *dst = lz4_kunit_alloc(test, max);
+	void *wrk = lz4_kunit_alloc(test, LZ4_MEM_COMPRESS);
+	u32 s = 0xde575123;
+	int fails = 0, it;
+
+	for (it = 0; it < LZ4_KUNIT_COMPRESS_ITERS; it++) {
+		int size = 1 + prng(&s) % max;
+		int target, consumed = size, r;
+
+		fill(src, size, &s, it % FILL_SHAPES);
+		if (it & 1)
+			target = 1 + prng(&s) % 64;
+		else
+			target = 1 + prng(&s) % LZ4_COMPRESSBOUND(size);
+
+		/* the output must decode to exactly the consumed prefix */
+		poison(comp, target);
+		r = LZ4_compress_destSize((const char *)src, (char *)comp,
+					  &consumed, target, wrk);
+		if (r < 0 || r > target || !guard_ok(comp, target) ||
+		    consumed < 0 || consumed > size ||
+		    (r > 0 && !decodes_to(comp, r, src, consumed, dst)))
+			fails++;
+	}
+
+	KUNIT_EXPECT_EQ_MSG(test, fails, 0, "LZ4_compress_destSize failures: %d",
+			    fails);
+}
+
+/* a page that mostly repeats dictionary content */
+static void fill_from_dict(u8 *page, const u8 *dict, u32 *s)
+{
+	int pos = 0;
+
+	while (pos < LZ4_KUNIT_PAGE) {
+		int len = 16 + prng(s) % 200;
+		int off = prng(s) % (LZ4_KUNIT_DICT_SIZE - len);
+		int i;
+
+		len = min(len, LZ4_KUNIT_PAGE - pos);
+		if (prng(s) & 3)
+			memcpy(page + pos, dict + off, len);
+		else
+			for (i = 0; i < len; i++)
+				page[pos + i] = prng(s);
+		pos += len;
+	}
+}
+
+static int decode_with_dict(LZ4_streamDecode_t *dstrm, const u8 *dict,
+			    const u8 *c, int csize, u8 *out)
+{
+	if (LZ4_setStreamDecode(dstrm, (const char *)dict,
+				LZ4_KUNIT_DICT_SIZE) != 1)
+		return -1;
+	return LZ4_decompress_safe_continue(dstrm, (const char *)c, (char *)out,
+					    csize, LZ4_KUNIT_PAGE);
+}
+
+/* zram's lz4 backend: copy a primed stream per page, decode with the dict */
+static void lz4_compress_test_dict_stream(struct kunit *test)
+{
+	const int cbound = LZ4_COMPRESSBOUND(LZ4_KUNIT_PAGE);
+	u8 *dict = lz4_kunit_alloc(test, LZ4_KUNIT_DICT_SIZE);
+	u8 *page = lz4_kunit_alloc(test, LZ4_KUNIT_PAGE);
+	u8 *comp = lz4_kunit_alloc(test, cbound);
+	u8 *out = lz4_kunit_alloc(test, LZ4_KUNIT_PAGE);
+	LZ4_stream_t *primed = lz4_kunit_alloc(test, LZ4_MEM_COMPRESS);
+	LZ4_stream_t *cstrm = lz4_kunit_alloc(test, LZ4_MEM_COMPRESS);
+	LZ4_streamDecode_t *dstrm = lz4_kunit_alloc(test, LZ4_MEM_DECOMPRESS);
+	int fails = 0, it;
+	u32 s = 0xd1c7d1c7;
+
+	gen(dict, LZ4_KUNIT_DICT_SIZE, &s, 50);
+	KUNIT_ASSERT_EQ(test, LZ4_KUNIT_DICT_SIZE,
+			LZ4_loadDict(primed, (const char *)dict,
+				     LZ4_KUNIT_DICT_SIZE));
+
+	for (it = 0; it < LZ4_KUNIT_DICT_ITERS; it++) {
+		int c, r;
+
+		fill_from_dict(page, dict, &s);
+		memcpy(cstrm, primed, LZ4_MEM_COMPRESS);
+		c = LZ4_compress_fast_continue(cstrm, (const char *)page,
+					       (char *)comp, LZ4_KUNIT_PAGE,
+					       cbound, 1);
+		if (c <= 0) {
+			fails++;
+			continue;
+		}
+
+		r = decode_with_dict(dstrm, dict, comp, c, out);
+		if (r != LZ4_KUNIT_PAGE || memcmp(out, page, LZ4_KUNIT_PAGE))
+			fails++;
+
+		r = LZ4_decompress_safe_usingDict((const char *)comp,
+						  (char *)out, c,
+						  LZ4_KUNIT_PAGE,
+						  (const char *)dict,
+						  LZ4_KUNIT_DICT_SIZE);
+		if (r != LZ4_KUNIT_PAGE || memcmp(out, page, LZ4_KUNIT_PAGE))
+			fails++;
+	}
+
+	KUNIT_EXPECT_EQ_MSG(test, fails, 0, "dictionary round-trip failures: %d",
+			    fails);
+}
+
+#if IS_REACHABLE(CONFIG_LZ4HC_COMPRESS)
+static void lz4hc_compress_test_levels(struct kunit *test)
+{
+	static const int levels[] = {
+		1, 2, 3, 4, 9, 10, 11, 12, 13, 14, 15, LZ4HC_MAX_CLEVEL
+	};
+	const int max = LZ4_KUNIT_MAX_SIZE, cbound = LZ4_COMPRESSBOUND(max);
+	u8 *src, *comp, *dst;
+	void *wrk;
+	u32 s = 0x4c5a3448;
+	unsigned int i;
+	int fails = 0, it;
+
+	src = lz4_kunit_alloc(test, max);
+	comp = lz4_kunit_alloc(test, cbound + LZ4_KUNIT_GUARD);
+	dst = lz4_kunit_alloc(test, max);
+	wrk = lz4_kunit_alloc(test, LZ4HC_MEM_COMPRESS);
+
+	for (i = 0; i < ARRAY_SIZE(levels); i++) {
+		for (it = 0; it < LZ4_KUNIT_HC_LEVEL_ITERS; it++) {
+			int size = 1 + prng(&s) % max;
+			int bound = LZ4_COMPRESSBOUND(size);
+			int r, cap;
+
+			fill(src, size, &s, it % FILL_SHAPES);
+			poison(comp, bound);
+			r = LZ4_compress_HC((const char *)src, (char *)comp,
+					    size, bound, levels[i], wrk);
+			if (r <= 0 || r > bound || !guard_ok(comp, bound) ||
+			    !decodes_to(comp, r, src, size, dst)) {
+				fails++;
+				continue;
+			}
+
+			cap = r / 2;
+			poison(comp, cap);
+			r = LZ4_compress_HC((const char *)src, (char *)comp,
+					    size, cap, levels[i], wrk);
+			if (r < 0 || r > cap || !guard_ok(comp, cap) ||
+			    (r > 0 && !decodes_to(comp, r, src, size, dst)))
+				fails++;
+		}
+	}
+
+	KUNIT_EXPECT_EQ_MSG(test, fails, 0, "LZ4_compress_HC failures: %d",
+			    fails);
+}
+
+/* zram's lz4hc backend: reset once, reload the dict before every page */
+static void lz4hc_compress_test_dict_stream(struct kunit *test)
+{
+	const int cbound = LZ4_COMPRESSBOUND(LZ4_KUNIT_PAGE);
+	u8 *dict, *page, *comp, *out;
+	LZ4_streamHC_t *cstrm;
+	LZ4_streamDecode_t *dstrm;
+	u32 s = 0x4cd1c700;
+	int fails = 0, it;
+
+	dict = lz4_kunit_alloc(test, LZ4_KUNIT_DICT_SIZE);
+	page = lz4_kunit_alloc(test, LZ4_KUNIT_PAGE);
+	comp = lz4_kunit_alloc(test, cbound);
+	out = lz4_kunit_alloc(test, LZ4_KUNIT_PAGE);
+	cstrm = lz4_kunit_alloc(test, LZ4HC_MEM_COMPRESS);
+	dstrm = lz4_kunit_alloc(test, LZ4_MEM_DECOMPRESS);
+
+	gen(dict, LZ4_KUNIT_DICT_SIZE, &s, 50);
+	LZ4_resetStreamHC(cstrm, 9);
+
+	for (it = 0; it < LZ4_KUNIT_HC_DICT_ITERS; it++) {
+		int c, r;
+
+		fill_from_dict(page, dict, &s);
+		if (LZ4_loadDictHC(cstrm, (const char *)dict,
+				   LZ4_KUNIT_DICT_SIZE) != LZ4_KUNIT_DICT_SIZE) {
+			fails++;
+			continue;
+		}
+		c = LZ4_compress_HC_continue(cstrm, (const char *)page,
+					     (char *)comp, LZ4_KUNIT_PAGE,
+					     cbound);
+		r = c > 0 ? decode_with_dict(dstrm, dict, comp, c, out) : -1;
+		if (r != LZ4_KUNIT_PAGE || memcmp(out, page, LZ4_KUNIT_PAGE))
+			fails++;
+	}
+
+	KUNIT_EXPECT_EQ_MSG(test, fails, 0,
+			    "HC dictionary round-trip failures: %d", fails);
+}
+#endif
+
+static struct kunit_case lz4_decompress_test_cases[] = {
+	KUNIT_CASE(lz4_decompress_test_roundtrip),
+	KUNIT_CASE(lz4_decompress_test_malformed),
+	KUNIT_CASE(lz4_decompress_test_offset0),
+	KUNIT_CASE(lz4_decompress_test_overlong),
+	KUNIT_CASE_SLOW(lz4_decompress_test_length_wrap),
+	KUNIT_CASE(lz4_decompress_test_inplace),
+	KUNIT_CASE_SLOW(lz4_decompress_test_inplace_worst_case),
+	{}
+};
+
+static struct kunit_suite lz4_decompress_test_suite = {
+	.name = "lz4_decompress",
+	.test_cases = lz4_decompress_test_cases,
+};
+
+static struct kunit_case lz4_compress_test_cases[] = {
+	KUNIT_CASE(lz4_compress_test_bound),
+	KUNIT_CASE(lz4_compress_test_limited),
+	KUNIT_CASE(lz4_compress_test_accel),
+	KUNIT_CASE(lz4_compress_test_destsize),
+	KUNIT_CASE(lz4_compress_test_dict_stream),
+#if IS_REACHABLE(CONFIG_LZ4HC_COMPRESS)
+	KUNIT_CASE(lz4hc_compress_test_levels),
+	KUNIT_CASE(lz4hc_compress_test_dict_stream),
+#endif
+	{}
+};
+
+static struct kunit_suite lz4_compress_test_suite = {
+	.name = "lz4_compress",
+	.test_cases = lz4_compress_test_cases,
+};
+
+kunit_test_suites(&lz4_decompress_test_suite, &lz4_compress_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests for the LZ4 compression library");
+MODULE_AUTHOR("S. Biplab Raut <Biplab.Raut@amd.com>");
+MODULE_LICENSE("GPL");
-- 
2.43.0


