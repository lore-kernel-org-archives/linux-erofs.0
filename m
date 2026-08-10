Return-Path: <linux-erofs+bounces-4150-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA39AC5AD4E
	for <linux-erofs@archiver.kernel.org>; Mon, 10 Aug 2026 04:19:47 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hJM3Q0B5hz2yr4;
	Mon, 10 Aug 2026 14:19:46 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786335585;
	cv=none; b=YCo6Y6xxREPuUi/kkf0U5k1BK1BUj1/QfShRnoKe/W+SnbrJbW9flUUbrKm3pGS4eAw+s5dMjqfaWuaQMQQGjX2Lic/XIJJGVJrtLLw7i9JwUSHsQAuFdXb/49o2h/RuQ9jVmGqqOvuTeVRdT+HnBYx/Yovc5ogkc1pD7F0dAI4UZ6wO4RUdhT4IFB10uZFjjzFRK91TT+xibGZ/hj07SprJm7HXjsQafWCjRTMzshC1iP6AIk/QcZ1D2PD45MUXkd7OuQg3pREp5kUxvLFg/01iKZKiIHEM+O+FuqwxCzUTmnovc1oIc9ENXnLvcFDvurd6QSRQ1pK+FAMnNupDiA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786335585; c=relaxed/relaxed;
	bh=TBneeX3gQ4onmpgIsE8qs/PrfEbeQLHcpzsSpPJ8iVU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=HBVjYG1BcsFbl3pVjq0nWHjvNEWLTJqZ588/uZ56zuiIWfOgD+vbmYucEQoNamn3jF8CDcLQ3JMnIm6Su22nuuCuaOIlbLwyHNOoc/3eLxX5XiQDjTGGoCMjV1mZlARAHvPOZO7n1Zhpc28g8ehZ5ny+84K4ySoWFCGw2fihq6kTUCQy1FbbI1Hwyo3Iwp9jGv5lJoTc8o+GSbFEatwAtwqXVZ/ix3y2jjVifR0fQf5l6+2sdd7h6yEW6LjKE98NO51JMzbpOZupv8gfcEBURmd09D7lo1YyqrEO5WVwhnW58VQdPckd6AKfsWQkxWI60rk7lHL9WXNzY5v7DyyaLg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=rkOyE9wU; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=devnull+cayoub.openai.com@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=rkOyE9wU;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=devnull+cayoub.openai.com@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hJM3N6LTsz2yr0
	for <linux-erofs@lists.ozlabs.org>; Mon, 10 Aug 2026 14:19:44 +1000 (AEST)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F423B60052;
	Mon, 10 Aug 2026 04:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A1F03C19425;
	Mon, 10 Aug 2026 04:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786335581;
	bh=iACC8acBoVKwhRWHlsapbUPOD82dJvHrb338HQzFwlY=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=rkOyE9wUjjGgAzKctMhEKDylEbt0QxO8Ottk5HJ0pcP3tY/vkf9YUoJgvTbRf+rin
	 ATzwqy5BaBAUe2Ny7gZwNSxb72T/pmSZDI4pN19LLB3m1I20goZ2e5GGS9g6SpIqWL
	 RgUchC1SOYqiRhlySnerz+EONNzBwAGzzu/Ie9eYXlJehBfVqBfYP2Dt9XLZCSv8LZ
	 9dScCdIPl0ZyaezhPpUoRyxsYJ7HCVHl4cIZogkQxzyz6Y41DCLhp+oQhR5wQUhh0z
	 optrJaYLVy3+dXDaYovjrOTn95cs291R9kVbH8tNMTyg7EhnYbJ/QgnxT6jyoQWwiN
	 rjenjJQoavjvA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83C8CC5AD4E;
	Mon, 10 Aug 2026 04:19:41 +0000 (UTC)
From: Chris Ayoub via B4 Relay <devnull+cayoub.openai.com@kernel.org>
Date: Mon, 10 Aug 2026 00:19:34 -0400
Subject: [PATCH v2] rebuild: prevent quadratic snapshot merges on wide
 directories
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-rebuild-wide-directory-index-v2-1-3a977092b7ea@openai.com>
X-B4-Tracking: v=1; b=H4sIAFVReWoC/42NTQ6CMBBGr2Jm7Rh+DIIr72FYtJ1BxmhLWkEM4
 e62eAGXL3nf+xYI7IUDnHcLeJ4kiLMRiv0OTK/sjVEoMhRZUWV11qBnPcqD8C3ESOLZvJz/oFj
 iGU1nykaXR1XVDDExeO5k3vLX9sdh1Pe4Sc1k9BLSfvuf8uT9eTXlmKMytT5pwyUTXdzAVsnBu
 Ce067p+AYHm9OfbAAAA
X-Change-ID: 20260809-rebuild-wide-directory-index-cfc39b34a68e
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>, Chris Ayoub <cayoub@openai.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786335581; l=8711;
 i=cayoub@openai.com; s=20260809; h=from:subject:message-id;
 bh=9VXj7OUFa5XFtJt3jzoTSA0n4h2icwNe252RWgLnB30=;
 b=hmxdLSxp/escyHDTwzWQRnAJFlp7okKqa9QE2HC64VWkFEkt9LV3Q7KB5eKwyP6QtNbuBWwc+
 YyoyxxK1TJODvP644Vp4scrfWt6qqMaQ74ojo+IxoC+Ykl1f+zMskGr
X-Developer-Key: i=cayoub@openai.com; a=ed25519;
 pk=3iLiZIUNdg97frhaiHfDNEIq1uD5UxhezQvebdhCZUo=
X-Endpoint-Received: by B4 Relay for cayoub@openai.com/20260809 with
 auth_id=931
X-Original-From: Chris Ayoub <cayoub@openai.com>
Reply-To: cayoub@openai.com

From: Chris Ayoub <cayoub@openai.com>

Directory entry merging currently performs a linear search of the
destination directory for each source entry. Repeating this operation
for wide directories makes snapshot rebuilding quadratic.

Add a temporary fixed-bucket index keyed by the parent inode and entry
name. Hash keys with the existing xxHash helper and resolve collisions
with list_head chains. Use 1,048,576 buckets to keep chains short for
million-entry rebuilds.

Use fixed list_head buckets instead of the generic hashmap implementation
while preserving the existing merge and replacement behavior. Release the
index when rebuilding finishes.

In the original reproducer, merging 129 layers containing approximately
2.4 million entries did not finish after 1195 seconds. With the index,
the same merge completed in 1.40 seconds. The widest directories
contained 65,212 and 83,318 entries.

Suggested-by: Gao Xiang <xiang@kernel.org>
Assisted-by: Codex:gpt-5
Signed-off-by: Chris Ayoub <cayoub@openai.com>
---
Snapshot rebuild currently performs a linear directory search for every
entry being merged.  This becomes prohibitively expensive for container
images with very wide directories.

The patch adds a temporary rebuild-only index keyed by parent inode and
entry name.  It uses the existing xxHash helper and fixed list_head buckets
instead of the generic hashmap implementation, preserving merge and
replacement behavior.

The original workload merged 129 layers containing approximately 2.4
million entries.  The unmodified rebuild did not finish after 1195 seconds;
the indexed version completed in 1.40 seconds.  The widest directories had
65,212 and 83,318 entries.

A shape-matched 129-layer replay with 2.4 million total entries and 800,000
unique live dentries completed in a 2.48-second median with list buckets,
versus 2.23 seconds with the v1 hashmap.  Their output images were
byte-identical, and fsck.erofs accepted the list-bucket image.

Validation against current dev (v1.9.3) on arm64 Ubuntu 24.04:

- Full builds with LZ4, LZMA, FUSE, and Zstd enabled, plus make check
- Byte-identical base, v1, and v2 output for file replacement, whiteout and
  opaque-directory handling, and an 8,000-entry directory
- Byte-identical v1 and v2 output for a 50,000-entry directory
- Extracted-tree checks for replacement, whiteout, and opaque semantics
- 50,000-entry local rebuild: 0.11 seconds for v1, 0.12 seconds for v2
- fsck.erofs validation and ASan coverage, including early-error cleanup
---
Changes in v2:
- Replace the generic hashmap implementation with fixed list_head buckets,
  as suggested by Gao Xiang.
- Hash parent/name keys with the existing xxHash helper.
- Revalidate output equivalence, wide-directory performance, fsck, and
  early-error cleanup against current dev.
- Link to v1: https://patch.msgid.link/20260809-rebuild-wide-directory-index-v1-1-ac8b7bce3edd@openai.com
---
 lib/liberofs_rebuild.h |  3 ++
 lib/rebuild.c          | 91 ++++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs/main.c            |  4 +++
 3 files changed, 98 insertions(+)

diff --git a/lib/liberofs_rebuild.h b/lib/liberofs_rebuild.h
index 6459dbd..2ab6414 100644
--- a/lib/liberofs_rebuild.h
+++ b/lib/liberofs_rebuild.h
@@ -13,6 +13,9 @@ enum erofs_rebuild_datamode {
 struct erofs_dentry *erofs_rebuild_get_dentry(struct erofs_inode *pwd,
 		char *path, bool aufs, bool *whout, bool *opq, bool to_head);
 
+void erofs_rebuild_dentry_index_init(void);
+void erofs_rebuild_dentry_index_exit(void);
+
 int erofs_rebuild_load_tree(struct erofs_inode *root, struct erofs_sb_info *sbi,
 			    enum erofs_rebuild_datamode mode);
 
diff --git a/lib/rebuild.c b/lib/rebuild.c
index a5308dc..89a7600 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -17,6 +17,7 @@
 #include "erofs/io.h"
 #include "liberofs_rebuild.h"
 #include "liberofs_uuid.h"
+#include "liberofs_xxhash.h"
 
 #ifdef HAVE_LINUX_AUFS_TYPE_H
 #include <linux/aufs_type.h>
@@ -26,6 +27,79 @@
 #define AUFS_WH_DIROPQ		AUFS_WH_PFX AUFS_DIROPQ_NAME
 #endif
 
+struct erofs_rebuild_dentry_index_entry {
+	struct list_head list;
+	struct erofs_inode *parent;
+	struct erofs_dentry *dentry;
+};
+
+/*
+ * Keep chains short for million-entry rebuilds.  The bucket heads occupy
+ * 16 MiB on 64-bit systems and are initialized only when rebuilding.
+ */
+#define EROFS_REBUILD_DENTRY_HASHSIZE	1048576
+static struct list_head
+	erofs_rebuild_dentry_index_storage[EROFS_REBUILD_DENTRY_HASHSIZE];
+static struct list_head *erofs_rebuild_dentry_index;
+
+static unsigned int erofs_rebuild_dentry_hash(struct erofs_inode *parent,
+					      const char *name)
+{
+	u64 parent_addr = (uintptr_t)parent;
+	u32 parent_seed = parent_addr ^ (parent_addr >> 32);
+
+	/* Distinguish identical names belonging to different directories. */
+	return xxh32(name, strlen(name), parent_seed);
+}
+
+void erofs_rebuild_dentry_index_init(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(erofs_rebuild_dentry_index_storage); ++i)
+		init_list_head(&erofs_rebuild_dentry_index_storage[i]);
+	erofs_rebuild_dentry_index = erofs_rebuild_dentry_index_storage;
+}
+
+void erofs_rebuild_dentry_index_exit(void)
+{
+	struct erofs_rebuild_dentry_index_entry *indexed, *n;
+	unsigned int i;
+
+	if (!erofs_rebuild_dentry_index)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(erofs_rebuild_dentry_index_storage); ++i) {
+		list_for_each_entry_safe(indexed, n,
+					 &erofs_rebuild_dentry_index[i], list) {
+			list_del(&indexed->list);
+			free(indexed);
+		}
+	}
+	erofs_rebuild_dentry_index = NULL;
+}
+
+static int erofs_rebuild_dentry_index_add(struct erofs_inode *parent,
+					 struct erofs_dentry *dentry)
+{
+	struct erofs_rebuild_dentry_index_entry *indexed;
+
+	if (!erofs_rebuild_dentry_index)
+		return 0;
+
+	indexed = malloc(sizeof(*indexed));
+	if (!indexed)
+		return -ENOMEM;
+
+	indexed->parent = parent;
+	indexed->dentry = dentry;
+	list_add_tail(&indexed->list,
+		      &erofs_rebuild_dentry_index[
+			      erofs_rebuild_dentry_hash(parent, dentry->name) &
+			      (ARRAY_SIZE(erofs_rebuild_dentry_index_storage) - 1)]);
+	return 0;
+}
+
 /*
  * These non-existent parent directories are created with the same permissions
  * as their parent directories.  It is expected that a call to create these
@@ -76,6 +150,19 @@ struct erofs_dentry *erofs_d_lookup(struct erofs_inode *dir, const char *name)
 {
 	struct erofs_dentry *d;
 
+	if (erofs_rebuild_dentry_index) {
+		struct erofs_rebuild_dentry_index_entry *indexed;
+		unsigned int hash = erofs_rebuild_dentry_hash(dir, name);
+		struct list_head *head = &erofs_rebuild_dentry_index[
+			hash & (ARRAY_SIZE(erofs_rebuild_dentry_index_storage) - 1)];
+
+		list_for_each_entry(indexed, head, list)
+			if (indexed->parent == dir &&
+			    !strcmp(indexed->dentry->name, name))
+				return indexed->dentry;
+		return NULL;
+	}
+
 	list_for_each_entry(d, &dir->i_subdirs, d_child)
 		if (!strcmp(d->name, name))
 			return d;
@@ -134,12 +221,16 @@ struct erofs_dentry *erofs_rebuild_get_dentry(struct erofs_inode *pwd,
 				d = erofs_rebuild_mkdir(pwd, s);
 				if (IS_ERR(d))
 					return d;
+				if (erofs_rebuild_dentry_index_add(pwd, d))
+					return ERR_PTR(-ENOMEM);
 			} else {
 				d = erofs_d_alloc(pwd, s);
 				if (IS_ERR(d))
 					return d;
 				d->type = EROFS_FT_UNKNOWN;
 				d->inode = pwd;
+				if (erofs_rebuild_dentry_index_add(pwd, d))
+					return ERR_PTR(-ENOMEM);
 			}
 			pwd = d->inode;
 		}
diff --git a/mkfs/main.c b/mkfs/main.c
index 929ce7c..7158853 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1680,21 +1680,25 @@ static int erofs_mkfs_rebuild_load_trees(struct erofs_inode *root)
 		return -EINVAL;
 	}
 
+	erofs_rebuild_dentry_index_init();
 	list_for_each_entry(src, &rebuild_src_list, list) {
 		src->xamgr = g_sbi.xamgr;
 		ret = erofs_rebuild_load_tree(root, src, datamode);
 		src->xamgr = NULL;
 		if (ret) {
 			erofs_err("failed to load %s", src->devname);
+			erofs_rebuild_dentry_index_exit();
 			return ret;
 		}
 		if (src->extra_devices > 1) {
 			erofs_err("%s: unsupported number %u of extra devices",
 				  src->devname, src->extra_devices);
+			erofs_rebuild_dentry_index_exit();
 			return -EOPNOTSUPP;
 		}
 		extra_devices += src->extra_devices;
 	}
+	erofs_rebuild_dentry_index_exit();
 
 	if (datamode == EROFS_REBUILD_DATA_RESVSP)
 		return 0;

---
base-commit: 7db78788b000999e2de88decd2ba90654f26171c
change-id: 20260809-rebuild-wide-directory-index-cfc39b34a68e

Best regards,
--  
Chris Ayoub <cayoub@openai.com>



