Return-Path: <linux-erofs+bounces-4148-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4117EC5AD5A
	for <linux-erofs@archiver.kernel.org>; Sun,  9 Aug 2026 21:44:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hJBH91c7pz2xyl;
	Mon, 10 Aug 2026 07:44:21 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786311861;
	cv=none; b=Gs/aO3cPeu9k4Awo46TGwlbQr0TC1N4tpG3mgJvkGGrMhohWaSWOGFNT6cW7xaoljrTUPahQfWaL2FilU7UwLVsc/HkfcgDRVtMaPRjH2D/832I0a6ceQCCdb/A8l0tlzuQF4LQYZLwHXnleDx7KEgwYS99vdHWyC6CNU9Z23FLNc5EDYmqOURNVVvEBXnI87HLN9CMXhN6Xu5vxSEk6wn7t0zMj+TkNv8hABMySKsCm4GsxdukmR5ooLjOrmuLPCdEnRehbsM3Gu/SdrlVK3L0pZHwXt9uIDMR78KBLIzSue1h1CY6GoopCuwAqmvIBQQcKXFOvIz2gVqOgOybMIw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786311861; c=relaxed/relaxed;
	bh=GxGfMpsqqkQyMWVFrw7O4sy4FH2jslpr8gDnt+DeiOw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Vnxgo+YW5HmG3t9Xd88kXqtjc8dGjYvUdYQrQo3VpHobbJYjJcIZiqw9HWMVPZYP43mOzuVXkr9PGAZAxCnysz5gAEpagWnEzPwuU5eVrJahkn53pA47PhDnKYyas60VJrxwub8qAJfQpd4Zio0rpIQrSzZU4KlJqI/Ts8k9Wc6PHGg4xdP0Yw6m9poNpVHbwoglvfSoZXCovGQWaNlnUFirNs460CITWHEw7jCdzRSXiGjKoXsU76FN7Gl0sicyy0V8Sv3FBuG9ldtxFqx1nBcFatVMzMXVM/fFU8BSwqRa4VUYiFF2pYkZ1aL/2yVA57JEM6U7IbOUxqfnANmAsA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=inK0MqSh; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=devnull+cayoub.openai.com@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=inK0MqSh;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=devnull+cayoub.openai.com@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hJBH802hqz2xLf
	for <linux-erofs@lists.ozlabs.org>; Mon, 10 Aug 2026 07:44:19 +1000 (AEST)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AFEDF600AB;
	Sun,  9 Aug 2026 21:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6766AC2BCB9;
	Sun,  9 Aug 2026 21:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786311856;
	bh=6bQwa1L0z4DsJxmGSn/LkMVqhof//MHqF3PubMLEXmY=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=inK0MqShNS3yE8WnLmihKPHsdULXLkWtJiYDa0JgxQrqqtqhA2P4UntDx4u76p3tj
	 H0Af4FrNcdUFL9bOJelcAcOvZgjek8cqtqKnFP+PNbpAVFv4oSF1DTNjnkE9/rRhpp
	 U6cFIktRUa+NP8NqGM6O0l3fgvy74G8TbM/KlUt3ZQoTm4sjEVPcQq1vi2gwEuyg2e
	 X9yZC/0SIjZ3lXqH6XBF5xM9gPdik87H4dyZlVPopDJNaKsvNlF3SwYhxiVStEFy8j
	 bdPtSRjqNjE73W+tTvSOz1ZYOVXyEq+i8P7Wgt79y8ib1OU3doQJh/xuW3ke6Kg4sv
	 JhGKrgwBc0v+A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B7FC5AD5A;
	Sun,  9 Aug 2026 21:44:16 +0000 (UTC)
From: Chris Ayoub via B4 Relay <devnull+cayoub.openai.com@kernel.org>
Date: Sun, 09 Aug 2026 17:44:08 -0400
Subject: [PATCH] rebuild: prevent quadratic snapshot merges on wide
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
Message-Id: <20260809-rebuild-wide-directory-index-v1-1-ac8b7bce3edd@openai.com>
X-B4-Tracking: v=1; b=H4sIAKj0eGoC/yXMQQ6CMBBG4auQWTtJBULAqxgXtPOjY0wxU1AI4
 e5WXX6L9zZKMEWiU7GR4aVJx5hxPBQUbn28glWyqXRl41rXscHP+hB+q4BFDWEabWWNgoXDEKr
 OV3XftKC8eBoGXX778+XvNPt7br5P2vcPcxcFcoAAAAA=
X-Change-ID: 20260809-rebuild-wide-directory-index-cfc39b34a68e
To: linux-erofs@lists.ozlabs.org
Cc: Chris Ayoub <cayoub@openai.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786311855; l=7696;
 i=cayoub@openai.com; s=20260809; h=from:subject:message-id;
 bh=65h6clNdJx8afXIqr6z/hZcjnoCtwLeXPuzlS5DrzaU=;
 b=qPgwM4xbonj3gBlxiaI3Cf42kln4YKjOmukWfkC9sQPqez9KcJY7uUIPVFtdCIgZeON50IhfR
 71tFUTdeUHuDoncgh3NTs+Kiv3S7a8EGT78jghJufrsAbLj2OiGWuW4
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

Add a temporary hashmap keyed by the parent inode and entry name during
rebuild. Use the index to find existing children while preserving the
existing merge and replacement behavior, and release it when rebuilding
finishes.

In the original reproducer, merging 129 layers containing approximately
2.4 million entries did not finish after 1195 seconds. With the index,
the same merge completed in 1.40 seconds. The widest directories
contained 65,212 and 83,318 entries.

Assisted-by: Codex:gpt-5
Signed-off-by: Chris Ayoub <cayoub@openai.com>
---
Snapshot rebuild currently performs a linear directory search for every
entry being merged.  This becomes prohibitively expensive for container
images with very wide directories.

The patch adds a temporary rebuild-only hashmap keyed by parent inode and
entry name.  It preserves the existing merge and replacement behavior and
releases the index after all source trees have been loaded.

The original workload merged 129 layers containing approximately 2.4
million entries.  The unmodified rebuild did not finish after 1195 seconds;
with the index, it completed in 1.40 seconds.  The widest directories had
65,212 and 83,318 entries.

Validation against current dev (v1.9.3) on arm64 Ubuntu 24.04:

- Full build with LZ4, LZMA, FUSE, and Zstd enabled
- make check
- Byte-identical output versus unmodified v1.9.3 for file replacement,
  whiteout and opaque-directory handling, and an 8,000-entry directory
- Extracted-tree checks for replacement, whiteout, and opaque semantics
- 8,000-entry local rebuild: 0.23 seconds before, 0.01 seconds after
---
 lib/liberofs_rebuild.h |   3 ++
 lib/rebuild.c          | 100 +++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs/main.c            |   4 ++
 3 files changed, 107 insertions(+)

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
index a5308dc..f697c40 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -11,6 +11,7 @@
 #include "erofs/print.h"
 #include "erofs/inode.h"
 #include "erofs/dir.h"
+#include "erofs/hashmap.h"
 #include "erofs/xattr.h"
 #include "erofs/blobchunk.h"
 #include "erofs/internal.h"
@@ -26,6 +27,85 @@
 #define AUFS_WH_DIROPQ		AUFS_WH_PFX AUFS_DIROPQ_NAME
 #endif
 
+struct erofs_rebuild_dentry_index_entry {
+	struct hashmap_entry entry;
+	struct erofs_inode *parent;
+	struct erofs_dentry *dentry;
+};
+
+struct erofs_rebuild_dentry_index_key {
+	struct erofs_inode *parent;
+	const char *name;
+};
+
+static struct hashmap erofs_rebuild_dentry_index;
+
+static unsigned int erofs_rebuild_dentry_hash(struct erofs_inode *parent,
+					      const char *name)
+{
+	return strhash(name) ^ memhash(&parent, sizeof(parent));
+}
+
+static int erofs_rebuild_dentry_index_cmp(const void *entry,
+					  const void *other,
+					  const void *keydata)
+{
+	const struct erofs_rebuild_dentry_index_entry *indexed =
+		container_of((struct hashmap_entry *)entry,
+			     struct erofs_rebuild_dentry_index_entry, entry);
+	const struct erofs_rebuild_dentry_index_key *key = keydata;
+
+	(void)other;
+	return indexed->parent != key->parent ||
+		strcmp(indexed->dentry->name, key->name);
+}
+
+void erofs_rebuild_dentry_index_init(void)
+{
+	hashmap_init(&erofs_rebuild_dentry_index,
+		     erofs_rebuild_dentry_index_cmp, 0);
+}
+
+void erofs_rebuild_dentry_index_exit(void)
+{
+	struct hashmap_iter iter;
+	struct hashmap_entry *entry;
+
+	hashmap_disable_shrink(&erofs_rebuild_dentry_index);
+	entry = hashmap_iter_first(&erofs_rebuild_dentry_index, &iter);
+	while (entry) {
+		struct erofs_rebuild_dentry_index_entry *indexed =
+			container_of(entry,
+				     struct erofs_rebuild_dentry_index_entry, entry);
+
+		DBG_BUGON(hashmap_remove(&erofs_rebuild_dentry_index,
+					 entry) != entry);
+		free(indexed);
+		entry = hashmap_iter_next(&iter);
+	}
+	DBG_BUGON(hashmap_free(&erofs_rebuild_dentry_index));
+}
+
+static int erofs_rebuild_dentry_index_add(struct erofs_inode *parent,
+					 struct erofs_dentry *dentry)
+{
+	struct erofs_rebuild_dentry_index_entry *indexed;
+
+	if (!erofs_rebuild_dentry_index.table)
+		return 0;
+
+	indexed = malloc(sizeof(*indexed));
+	if (!indexed)
+		return -ENOMEM;
+
+	indexed->parent = parent;
+	indexed->dentry = dentry;
+	hashmap_entry_init(&indexed->entry,
+			   erofs_rebuild_dentry_hash(parent, dentry->name));
+	hashmap_add(&erofs_rebuild_dentry_index, &indexed->entry);
+	return 0;
+}
+
 /*
  * These non-existent parent directories are created with the same permissions
  * as their parent directories.  It is expected that a call to create these
@@ -76,6 +156,22 @@ struct erofs_dentry *erofs_d_lookup(struct erofs_inode *dir, const char *name)
 {
 	struct erofs_dentry *d;
 
+	if (erofs_rebuild_dentry_index.table) {
+		struct erofs_rebuild_dentry_index_key key = {
+			.parent = dir,
+			.name = name,
+		};
+		struct hashmap_entry *entry = hashmap_get_from_hash(
+			&erofs_rebuild_dentry_index,
+			erofs_rebuild_dentry_hash(dir, name), &key);
+
+		if (!entry)
+			return NULL;
+		return container_of(entry,
+				    struct erofs_rebuild_dentry_index_entry,
+				    entry)->dentry;
+	}
+
 	list_for_each_entry(d, &dir->i_subdirs, d_child)
 		if (!strcmp(d->name, name))
 			return d;
@@ -134,12 +230,16 @@ struct erofs_dentry *erofs_rebuild_get_dentry(struct erofs_inode *pwd,
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



