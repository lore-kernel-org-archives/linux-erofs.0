Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E83A606A320
	for <linux-erofs@archiver.kernel.org>; Sun, 22 Nov 2026 03:12:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jXDdS5cxpz2yMP;
	Sun, 22 Nov 2026 14:12:12 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795317132;
	cv=none; b=edcP7EQhJYCGH4LRDxwUeFj1g6mtzTY02FVXZZgNnysLpeWJTBMF7F0DQdVAHkzdPjo7yv+ZEXXZn0wIvg9ymdC96QCSZLgZyXC4ZdfF/9W+Dizs4Ub6SuvBXoetMj7PGHRnM9i6kw3ozgvZULE5ikUmW1dLFVTFGh+wcHK0pQbjl4klKAKH82mAXV61BLgTjjM2WUnh2CxzqlB6J0Vo9g9nWcgU7cVN9dXwWMHBLv3SKMSMmha8II8JeLeimbg/l1vpAQqRfCcftpdXRkGiMnc/eEX2znVzV79Q9kjHAks9tr29rJi5ouuAtRhhuRS4And5Fcautglku7XHRPznbw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795317132; c=relaxed/relaxed;
	bh=qVfvY7oCmpW6uohH0sP+Yaz5J/a/8IeClxRcF/6Dev8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNVMm/xHUThct7PRDey015RfvHEVTIVNZ7/N+0sjsGPsmIq4j80UO0REmPI1lGHAivsKC/GrYJltZKTC6vOCh1/DZ55Uwt0HXBbqH+mCQk/AS9EgD+KPQ+UT9U5syJGldjtPErVtZD0CIGQZLogiZoT7Lcq8z0MSxAl7Q2cyRbodT0qGEec9HXazSRMF4TeEfP47m5NLiACR4FBgfSZO1s2/fM9fos/26KXKk29cFtA3pbDjMuQIhNoar6eRen9z0wvm/dh7alFs0jW6ljpR4IUJV6NomuxKblPtZjRCXSoCltIxgeZxORV77OgtV3u8uhjvgw/Szt+iNiXm6+N+sw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn; spf=pass (client-ip=159.226.251.21; helo=cstnet.cn; envelope-from=yanmengdie24@mails.ucas.ac.cn; receiver=lists.ozlabs.org) smtp.mailfrom=mails.ucas.ac.cn
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=mails.ucas.ac.cn (client-ip=159.226.251.21; helo=cstnet.cn; envelope-from=yanmengdie24@mails.ucas.ac.cn; receiver=lists.ozlabs.org)
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jXDdL4dRrz2yMl
	for <linux-erofs@lists.ozlabs.org>; Sun, 22 Nov 2026 14:12:05 +1100 (AEDT)
Received: from localhost.localdomain (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowAAnUvy6WwJrpQZzAQ--.19540S5;
	Sun, 22 Nov 2026 11:04:33 +0800 (CST)
From: Mengdie Yan <yanmengdie24@mails.ucas.ac.cn>
To: linux-erofs@lists.ozlabs.org
Cc: Mengdie Yan <yanmengdie24@mails.ucas.ac.cn>,
	Gao Xiang <xiang@kernel.org>,
	Chengyu Zhu <hudsonzhu@tencent.com>
Subject: [PATCH 3/4] erofs-utils: mkfs: support hot file lists for full TAR imports
Date: Sun, 22 Nov 2026 11:04:22 +0800
Message-ID: <fb2136f22d53f6faff514f229a27c6d10f54d33a.1795283998.git.yanmengdie24@mails.ucas.ac.cn>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1795283997.git.yanmengdie24@mails.ucas.ac.cn>
References: <cover.1795283997.git.yanmengdie24@mails.ucas.ac.cn>
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
X-CM-TRANSID:qwCowAAnUvy6WwJrpQZzAQ--.19540S5
X-Coremail-Antispam: 1UD129KBjvAXoW3KFW7GrW5tFWkKr48Wr4kJFb_yoW8Gw48Wo
	WxZ3ZxWF1rWF1UJF4UCw13tryxu3y5Cw1UW39xArWjgr9rWr4UKr97W3W8X34fXr4rGrWr
	Jwn7Zas8Gr4ktr1fn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUOU7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20EY4v20xva
	j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r1rM28IrcIa0x
	kI8VCY1x0267AKxVW8JVW5JwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84AC
	jcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j6F4UM2
	8EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr1j6F4U
	JwAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0V
	AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4U
	JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20V
	AGYxC7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
	wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc4
	0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AK
	xVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr
	1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjeMKJUU
	UUU==
X-CM-SenderInfo: 51dqzv5qjgxvysu6ztxlovh3xfdvhtffof0/
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Defer imported hot paths until the final TAR tree exists. Build a
temporary lookup index and clear shared inode ranks before aggregating
only surviving aliases.

Reuse the directory scheduler and reject incompatible TAR modes and sort
options. Missing paths remain a no-op and replacement aliases are ranked
from the final imported tree.

Signed-off-by: Mengdie Yan <yanmengdie24@mails.ucas.ac.cn>
---
 include/erofs/hotfile.h |   5 +-
 lib/hotfile.c           | 242 ++++++++++++++++++++++++++++++++++++++--
 man/mkfs.erofs.1        |   6 +-
 mkfs/main.c             |  34 +++++-
 4 files changed, 270 insertions(+), 17 deletions(-)

diff --git a/include/erofs/hotfile.h b/include/erofs/hotfile.h
index 3fcdc1a..9dc3a7e 100644
--- a/include/erofs/hotfile.h
+++ b/include/erofs/hotfile.h
@@ -9,7 +9,10 @@ extern "C"
 
 #include "defs.h"
 
-int erofs_hotfile_load(const char *path);
+struct erofs_inode;
+
+int erofs_hotfile_load(const char *path, const char *root);
+int erofs_hotfile_prepare_tree(struct erofs_inode *root);
 void erofs_hotfile_exit(void);
 bool erofs_hotfile_enabled(void);
 
diff --git a/lib/hotfile.c b/lib/hotfile.c
index 777117a..7e8fc45 100644
--- a/lib/hotfile.c
+++ b/lib/hotfile.c
@@ -27,7 +27,11 @@ struct erofs_hotfile_manifest {
 };
 
 static struct erofs_hotfile_manifest hotfile_manifest;
+static struct erofs_hotfile_entry *hotfile_input;
+static unsigned int hotfile_nr_input, hotfile_cap_input;
 static const char *hotfile_root;
+static bool hotfile_prepared;
+static struct erofs_inode *hotfile_tree;
 
 /*
  * Cache successful local directory lookups only while reading the hot list.
@@ -52,6 +56,73 @@ static void erofs_hotfile_drop_dir_cache(void)
 	hotfile_dir_cache = NULL;
 }
 
+/* Final-tree lookup only; do not change the imported dentry order. */
+static struct erofs_hotfile_dentry {
+	struct erofs_inode *parent;
+	struct erofs_dentry *dentry;
+} *hotfile_dentries;
+static size_t hotfile_nr_dentries, hotfile_cap_dentries;
+
+static int erofs_hotfile_dentry_cmp(const void *a, const void *b)
+{
+	const struct erofs_hotfile_dentry *lhs = a, *rhs = b;
+	uintptr_t lp = (uintptr_t)lhs->parent, rp = (uintptr_t)rhs->parent;
+
+	if (lp != rp)
+		return lp < rp ? -1 : 1;
+	return strcmp(lhs->dentry->name, rhs->dentry->name);
+}
+
+struct erofs_hotfile_lookup_key {
+	struct erofs_inode *parent;
+	const char *name;
+	size_t len;
+};
+
+static int erofs_hotfile_dentry_key_cmp(const void *a, const void *b)
+{
+	const struct erofs_hotfile_lookup_key *key = a;
+	const struct erofs_hotfile_dentry *entry = b;
+	uintptr_t kp = (uintptr_t)key->parent, ep = (uintptr_t)entry->parent;
+	size_t len = entry->dentry->namelen;
+	int ret;
+
+	if (kp != ep)
+		return kp < ep ? -1 : 1;
+	ret = memcmp(key->name, entry->dentry->name, min(key->len, len));
+	if (ret || key->len == len)
+		return ret;
+	return key->len < len ? -1 : 1;
+}
+
+static int erofs_hotfile_index_dentry(struct erofs_inode *parent,
+				    struct erofs_dentry *dentry)
+{
+	if (hotfile_nr_dentries == hotfile_cap_dentries) {
+		struct erofs_hotfile_dentry *entries;
+		size_t cap;
+
+		if (hotfile_cap_dentries > SIZE_MAX / 2 / sizeof(*entries))
+			return -ENOMEM;
+		cap = hotfile_cap_dentries ? hotfile_cap_dentries * 2 : 64;
+		entries = realloc(hotfile_dentries, cap * sizeof(*entries));
+		if (!entries)
+			return -ENOMEM;
+		hotfile_dentries = entries;
+		hotfile_cap_dentries = cap;
+	}
+	hotfile_dentries[hotfile_nr_dentries++] =
+		(struct erofs_hotfile_dentry){ parent, dentry };
+	return 0;
+}
+
+static void erofs_hotfile_drop_index(void)
+{
+	free(hotfile_dentries);
+	hotfile_dentries = NULL;
+	hotfile_nr_dentries = hotfile_cap_dentries = 0;
+}
+
 static int erofs_hotfile_cmp(const void *a, const void *b)
 {
 	const struct erofs_hotfile_entry *lhs = a;
@@ -124,6 +195,33 @@ static int erofs_hotfile_add_plain_path(const char *path, bool dir_entry,
 	return err;
 }
 
+static struct erofs_inode *erofs_hotfile_lookup_tree(const char *path)
+{
+	struct erofs_inode *inode = hotfile_tree;
+	const char *p = path;
+
+	while (*p) {
+		const char *end = strchr(p, '/');
+		struct erofs_hotfile_lookup_key key;
+		struct erofs_hotfile_dentry *found;
+
+		if (!end)
+			end = p + strlen(p);
+		if (!S_ISDIR(inode->i_mode))
+			return ERR_PTR(-ENOTDIR);
+		key = (struct erofs_hotfile_lookup_key){ inode, p, end - p };
+		found = hotfile_nr_dentries ?
+			bsearch(&key, hotfile_dentries, hotfile_nr_dentries,
+				sizeof(*found),
+				erofs_hotfile_dentry_key_cmp) : NULL;
+		if (!found)
+			return ERR_PTR(-ENOENT);
+		inode = found->dentry->inode;
+		p = *end ? end + 1 : end;
+	}
+	return inode;
+}
+
 /* Prefixes passed here contain neither symlinks nor dot components. */
 static int erofs_hotfile_lookup(const char *path, mode_t *mode, char **target)
 {
@@ -134,6 +232,21 @@ static int erofs_hotfile_lookup(const char *path, mode_t *mode, char **target)
 
 	*mode = 0;
 	*target = NULL;
+	if (hotfile_tree) {
+		struct erofs_inode *inode = erofs_hotfile_lookup_tree(path);
+
+		if (IS_ERR(inode))
+			return PTR_ERR(inode);
+		*mode = inode->i_mode;
+		if (S_ISLNK(*mode)) {
+			if (!inode->i_link)
+				return -EOPNOTSUPP;
+			*target = strdup(inode->i_link);
+			if (!*target)
+				return -ENOMEM;
+		}
+		return 0;
+	}
 	if (hotfile_dir_cache) {
 		u32 hash = erofs_crc32c(~0U, (const u8 *)path, strlen(path));
 
@@ -394,26 +507,25 @@ static void erofs_hotfile_sort(void)
 		hotfile_manifest.dir_paths, hotfile_manifest.nr_dirs);
 }
 
-int erofs_hotfile_load(const char *path)
+int erofs_hotfile_load(const char *path, const char *root)
 {
 	FILE *fp;
 	char *line = NULL;
 	size_t linesz = 0;
+	unsigned int nr = 0;
 	ssize_t nread;
-	erofs_os_stat_t st;
 	int err = 0;
-	unsigned int nr_input = 0;
 
 	fp = fopen(path, "r");
 	if (!fp)
 		return -errno;
-	if (cfg.c_src_path && !erofs_os_stat(cfg.c_src_path, &st) &&
-	    S_ISDIR(st.st_mode))
-		hotfile_root = cfg.c_src_path;
+	hotfile_root = root;
 	if (hotfile_root)
 		hotfile_dir_cache = calloc(EROFS_HOTFILE_DIR_CACHE_SIZE,
 					   sizeof(*hotfile_dir_cache));
 	while ((nread = getline(&line, &linesz, fp)) >= 0) {
+		char *input;
+
 		if (memchr(line, '\0', nread)) {
 			err = -EINVAL;
 			break;
@@ -425,7 +537,21 @@ int erofs_hotfile_load(const char *path)
 		/* a leading # starts a comment, use ./#name for such files */
 		if (!nread || line[0] == '#')
 			continue;
-		err = erofs_hotfile_add_resolved_path(line, nr_input++);
+		if (hotfile_root) {
+			err = erofs_hotfile_add_resolved_path(line, nr);
+		} else {
+			input = strdup(line);
+			if (!input) {
+				err = -ENOMEM;
+				break;
+			}
+			err = erofs_hotfile_add(&hotfile_input,
+						&hotfile_nr_input,
+						&hotfile_cap_input, input, nr);
+			if (err)
+				free(input);
+		}
+		++nr;
 		if (err)
 			break;
 	}
@@ -439,13 +565,16 @@ int erofs_hotfile_load(const char *path)
 		return err;
 	}
 	erofs_hotfile_sort();
-	erofs_info("loaded %u hot paths from %s", nr_input, path);
+	hotfile_prepared = hotfile_root != NULL;
+	erofs_info("loaded %u hot paths from %s", nr, path);
 	return 0;
 }
 
 bool erofs_hotfile_enabled(void)
 {
-	return hotfile_manifest.nr_files || hotfile_manifest.nr_dirs;
+	return hotfile_prepared ?
+		hotfile_manifest.nr_files || hotfile_manifest.nr_dirs :
+		hotfile_nr_input != 0;
 }
 
 static unsigned int erofs_hotfile_find_rank(const char *path,
@@ -524,9 +653,102 @@ static void erofs_hotfile_clear_paths(void)
 	hotfile_manifest.cap_dirs = 0;
 }
 
+static int erofs_hotfile_walk_tree(struct erofs_inode *inode, const char *path,
+				  bool clear)
+{
+	struct erofs_dentry *d;
+	unsigned int rank;
+
+	if (clear) {
+		inode->hot_rank = EROFS_HOT_RANK_NONE;
+	} else {
+		/* hardlinks take the earliest rank of all surviving names */
+		rank = erofs_hotfile_rank(path, S_ISDIR(inode->i_mode));
+		inode->hot_rank = min(inode->hot_rank, rank);
+	}
+	if (!S_ISDIR(inode->i_mode))
+		return 0;
+	list_for_each_entry(d, &inode->i_subdirs, d_child) {
+		char *child = NULL;
+		int err;
+
+		if (is_dot_dotdot(d->name))
+			continue;
+		if (clear) {
+			err = erofs_hotfile_index_dentry(inode, d);
+			if (err)
+				return err;
+		}
+		if (!clear && asprintf(&child, "%s%s%s", path,
+				       *path ? "/" : "", d->name) < 0)
+			return -ENOMEM;
+		err = erofs_hotfile_walk_tree(d->inode, child, clear);
+		free(child);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+static void erofs_hotfile_clear_input(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < hotfile_nr_input; ++i)
+		free(hotfile_input[i].path);
+	free(hotfile_input);
+	hotfile_input = NULL;
+	hotfile_nr_input = hotfile_cap_input = 0;
+}
+
+static int erofs_hotfile_prepare_paths(struct erofs_inode *root)
+{
+	unsigned int i;
+	int err;
+
+	erofs_hotfile_clear_paths();
+	for (i = 0; i < hotfile_nr_input; ++i) {
+		err = erofs_hotfile_add_resolved_path(hotfile_input[i].path,
+						    hotfile_input[i].rank);
+		if (err)
+			return err;
+	}
+	erofs_hotfile_sort();
+	erofs_hotfile_clear_input();
+	hotfile_prepared = true;
+	return erofs_hotfile_walk_tree(root, "", false);
+}
+
+/*
+ * For archive sources, hot paths can only be resolved once the final tree
+ * has been imported (later entries may replace or remove earlier ones).
+ */
+int erofs_hotfile_prepare_tree(struct erofs_inode *root)
+{
+	int err;
+
+	if (!erofs_hotfile_enabled())
+		return 0;
+	hotfile_tree = root;
+	/* Clear shared inodes before aggregating only surviving aliases. */
+	err = erofs_hotfile_walk_tree(root, NULL, true);
+	if (err)
+		goto out;
+	if (hotfile_nr_dentries)
+		qsort(hotfile_dentries, hotfile_nr_dentries,
+		      sizeof(*hotfile_dentries), erofs_hotfile_dentry_cmp);
+	err = erofs_hotfile_prepare_paths(root);
+out:
+	erofs_hotfile_drop_index();
+	hotfile_tree = NULL;
+	return err;
+}
+
 void erofs_hotfile_exit(void)
 {
 	erofs_hotfile_clear_paths();
-	hotfile_manifest = (struct erofs_hotfile_manifest){};
+	erofs_hotfile_clear_input();
 	hotfile_root = NULL;
+	hotfile_tree = NULL;
+	hotfile_prepared = false;
 }
diff --git a/man/mkfs.erofs.1 b/man/mkfs.erofs.1
index f06ff9b..983f385 100644
--- a/man/mkfs.erofs.1
+++ b/man/mkfs.erofs.1
@@ -312,7 +312,7 @@ Dereference hardlinks and add links as separate inodes.
 .TP
 .BI "\-\-hot-file-list=" path
 Read a newline-delimited list of image-relative hot file paths for local
-directory sources.
+directory or tar full sources.
 Leading slashes refer to the image root.  Empty lines and lines starting
 with # are ignored; other spaces are part of the filename.  Use ./ to list
 a filename beginning with #.
@@ -320,7 +320,8 @@ Hot regular files are scheduled in list order before cold files while keeping
 compression enabled.  Unlisted files retain their relative traversal order.
 Hardlink aliases share the earliest matching rank.
 Symlinks, including intermediate ones, are resolved within the image root
-and are prioritized together with their targets.
+and are prioritized together with their targets; for tar sources, matching
+uses the final imported tree.
 Parent directories are also prioritized.  Entries ending in \fI/\fR prioritize
 the directory without recursively marking its children hot.
 Hot files are never packed into fragments, since that would move their
@@ -331,6 +332,7 @@ This is file-level data ordering: directory compression, metadata zones and
 metadata allocation can place metadata elsewhere in the image, so a complete,
 independently usable hot prefix is not guaranteed.
 This option cannot be combined with \fB--incremental\fR.
+This option cannot be combined with \fB--sort=none\fR for tar input.
 .TP
 .B "\-\-ignore-mtime"
 Ignore the file modification time whenever it would cause \fBmkfs.erofs\fR to
diff --git a/mkfs/main.c b/mkfs/main.c
index 299f2cd..8ebd3a0 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -215,7 +215,7 @@ static void usage(int argc, char **argv)
 		" --gid-offset=#         add offset # to all file gids (# = id offset)\n"
 		" --hard-dereference     dereference hardlinks, add links as separate inodes\n"
 		" --hot-file-list=X      specify newline-separated hot file paths for\n"
-		"                        local directory sources\n"
+		"                        local directory or tar full sources\n"
 		" --ignore-mtime         use build time instead of strict per-file modification time\n"
 		" --max-extent-bytes=#   set maximum decompressed extent size # in bytes\n"
 		" --mount-point=X        X=prefix of target fs path (default: /)\n"
@@ -332,6 +332,20 @@ static enum {
 	EROFS_MKFS_SOURCE_REBUILD,
 } source_mode;
 
+static bool mkfs_hotfile_supported_source(void)
+{
+	switch (source_mode) {
+	case EROFS_MKFS_SOURCE_LOCALDIR:
+		return true;
+	case EROFS_MKFS_SOURCE_TAR:
+		return !erofstar.index_mode &&
+		       dataimport_mode != EROFS_MKFS_DATA_IMPORT_RVSP &&
+		       dataimport_mode != EROFS_MKFS_DATA_IMPORT_ZEROFILL;
+	default:
+		return false;
+	}
+}
+
 static unsigned int rebuild_src_count;
 static LIST_HEAD(rebuild_src_list);
 static u8 fixeduuid[16];
@@ -1568,8 +1582,13 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 		erofs_err("--hot-file-list conflicts with --incremental");
 		return -EINVAL;
 	}
-	if (hotfile_list_path && source_mode != EROFS_MKFS_SOURCE_LOCALDIR) {
-		erofs_err("--hot-file-list requires a local directory source");
+	if (hotfile_list_path && source_mode == EROFS_MKFS_SOURCE_TAR &&
+	    erofstar.try_no_reorder) {
+		erofs_err("--hot-file-list conflicts with --sort=none");
+		return -EINVAL;
+	}
+	if (hotfile_list_path && !mkfs_hotfile_supported_source()) {
+		erofs_err("--hot-file-list is only supported for local directories and tar full mode");
 		return -EOPNOTSUPP;
 	}
 
@@ -1811,7 +1830,9 @@ int main(int argc, char **argv)
 	}
 
 	if (hotfile_list_path) {
-		err = erofs_hotfile_load(hotfile_list_path);
+		err = erofs_hotfile_load(hotfile_list_path,
+				source_mode == EROFS_MKFS_SOURCE_LOCALDIR ?
+				cfg.c_src_path : NULL);
 		if (err) {
 			erofs_err("failed to load hot-file list %s: %s",
 				  hotfile_list_path, erofs_strerror(err));
@@ -2065,6 +2086,11 @@ int main(int argc, char **argv)
 	if (err < 0)
 		goto exit;
 
+	if (hotfile_list_path && source_mode == EROFS_MKFS_SOURCE_TAR) {
+		err = erofs_hotfile_prepare_tree(root);
+		if (err)
+			goto exit;
+	}
 	err = erofs_importer_load_tree(&importer,
 				       source_mode != EROFS_MKFS_SOURCE_LOCALDIR,
 				       incremental_mode);
-- 
2.50.1 (Apple Git-155)


