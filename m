Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446BF606A325
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=P0g7RZXY
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1qV6zFgz3c5y;
	Tue, 10 Nov 2026 20:40:54 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794303654;
	cv=none; b=jER+5Q2rSh8HzSeM8ujCGnNEw+cHjs59c9dHmCxioDfFrFuo4OdQ2vxm+f5wJeQ85rSN1GvE1hIOyjDvN4deQPwoYENpknbc/f9WfL/g2zwaf3DeHSXdAcTxDhvV9CJvTxb6mjmOC07U61/OlblU1FIeW9Zl/vG/49YsiClBl4wTVXFP0OSxY1kN0SSO7YWJndyUtywQsDqRBJmtYr8j9tE4S/9IzHMdrY3avkH58gUaUQTq/ATMTvo4xnqZrJFWW6mlmyKXqtl1ENYQeVXcH/nU4z/NQLYHnVcAwR5drUob9+JAm2POVel5MUGv3HVPVO78dfZZuNXzGfdFhKggYg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794303654; c=relaxed/relaxed;
	bh=eZWnNI/Ev/Ga+jMETWLfKs4eD8LfsScx+EvYWWom3Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lt5lRYXuNBj9IUkefUUzLdHlDPR58TFfIf4oqM2tTbgH2haDkY+tUyN5cWCjWhxcgNrcF2sXYWuBUiH+koIy8w1y8hsfPm1TfXKrQCHDW2n7pqhoq7bwAoj4LA1m5r/bf3FEZUlXKM/8LR32SkyOhRMOgLNhkmbZAry9puSdc1mVpIIUxZJPb4WDJ2QIQBHwQCScVxQlGxYRuNpTZUjz2BOV2iX32lKWQLCTBgY1C9IOf3d5MZQ7VhjIgisZj0sxkIWIZEn54d5JWuD9AqCW6iFZhajwYlQviGXssDN/gOTDKa4uxwBaTWrgvcT6HnjIE5m1XADdktaSGMWDcduEGQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=P0g7RZXY; dkim-atps=neutral; spf=pass (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=lanbingying.lby@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=P0g7RZXY;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=lanbingying.lby@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1qS30T3z3bqh
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Nov 2026 20:40:51 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794303645; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=eZWnNI/Ev/Ga+jMETWLfKs4eD8LfsScx+EvYWWom3Ug=;
	b=P0g7RZXYlME8L1kwVx8jjx7QKiORONBX8cwxOH33OOGwfqo+bsNlRumhOFShOM5CwQ4UrggzBafNC1TUBeOcTnQ4L72Lm9uAVWf/XiaQ2gyO5rx8EPjVE+10/tTvGGdgV8SQHRIfT3v5q/nPZ6B42LLnyN+IewOMk94Xh2hkb6E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=lanbingying.lby@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0XEUy1oO_1794303641;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:lanbingying.lby@linux.alibaba.com fp:SMTPD_---0XEUy1oO_1794303641 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Nov 2026 17:40:42 +0800
From: bingying lan <lanbingying.lby@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org
Subject: [PATCH 2/3] erofs-utils: mkfs: preserve plain xattr prefixes in incremental builds
Date: Tue, 10 Nov 2026 17:40:11 +0800
Message-ID: <20261110094012.1820140-3-lanbingying.lby@linux.alibaba.com>
X-Mailer: git-send-email 2.53.0.apsara
In-Reply-To: <20261110094012.1820140-1-lanbingying.lby@linux.alibaba.com>
References: <20261110094012.1820140-1-lanbingying.lby@linux.alibaba.com>
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
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replacing a prefix table with the current command-line list can change
indices still referenced by inherited inodes. Preserve every base slot,
including duplicates, and append only newly requested prefixes. Use the
merged list for new inodes and reuse the original table when no entries
are added, including when the image has grown beyond 16 GiB.

Apply this preparation only to plain tables, including legacy physical
tables without PLAIN_XATTR_PFX. Remap the requested inode digest prefix
before checking its identity. Ordinary incremental builds inherit an
omitted digest setting and may enable digests for newly built files, but
cannot rename an existing digest.

Build temporary prefix lists and decoding arrays before replacing the
old state. Release the old array using its old count. Prepare prefixes
before shared-xattr scanning and retain the existing prefix flush call
order. Document the changed incremental behavior.

Signed-off-by: bingying lan <lanbingying.lby@linux.alibaba.com>
---
 include/erofs/xattr.h |   9 ++
 lib/xattr.c           | 188 +++++++++++++++++++++++++++++++++++++++++-
 man/mkfs.erofs.1      |  18 ++++
 mkfs/main.c           |  13 +++
 4 files changed, 226 insertions(+), 2 deletions(-)

diff --git a/include/erofs/xattr.h b/include/erofs/xattr.h
index d12c292..fb960d2 100644
--- a/include/erofs/xattr.h
+++ b/include/erofs/xattr.h
@@ -33,6 +33,15 @@ char *erofs_export_xattr_ibody(struct erofs_inode *inode);
 int erofs_load_shared_xattrs_from_path(struct erofs_sb_info *sbi, const char *path,
 				       long inlinexattr_tolerance);
 int erofs_xattr_insert_name_prefix(const char *prefix);
+/*
+ * Merge base prefixes for incremental plain tables; other paths are unchanged.
+ * plain selects storage for a new table, not conversion of an existing one.
+ * ishare_prefix_id is the CLI digest ID (0 if omitted), remapped on success;
+ * sbi holds the resulting digest configuration, including inherited settings.
+ */
+int erofs_xattr_prepare_name_prefixes(struct erofs_importer *im,
+				     bool incremental, bool plain,
+				     u8 *ishare_prefix_id);
 int erofs_xattr_set_ishare_prefix(struct erofs_sb_info *sbi,
 				  const char *prefix);
 char *erofs_xattr_get_ishare_prefix(struct erofs_sb_info *sbi);
diff --git a/lib/xattr.c b/lib/xattr.c
index 8c7bbcf..66a36a6 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -206,6 +206,8 @@ struct ea_type_node {
 
 static LIST_HEAD(ea_name_prefixes);
 static unsigned int ea_prefix_count;
+static bool ea_prefixes_reuse;
+static bool ea_prefixes_plain;
 
 bool erofs_xattr_prefix_matches(const char *key, unsigned int *index,
 				unsigned int *len)
@@ -892,6 +894,11 @@ int erofs_xattr_flush_name_prefixes(struct erofs_importer *im, bool plain)
 	if (!ea_prefix_count)
 		return 0;
 
+	if (ea_prefixes_reuse) {
+		erofs_sb_set_plain_xattr_pfx(sbi);
+		return 0;
+	}
+	plain |= ea_prefixes_plain;
 	if (!plain) {
 		if (erofs_sb_has_metabox(sbi)) {
 			bmgr = erofs_metadata_bmgr(sbi, true);
@@ -1588,17 +1595,25 @@ char *erofs_xattr_get_ishare_prefix(struct erofs_sb_info *sbi)
 	return name;
 }
 
-void erofs_xattr_cleanup_name_prefixes(void)
+static void erofs_xattr_cleanup_prefix_list(struct list_head *head)
 {
 	struct ea_type_node *tnode, *n;
 
-	list_for_each_entry_safe(tnode, n, &ea_name_prefixes, list) {
+	list_for_each_entry_safe(tnode, n, head, list) {
 		list_del(&tnode->list);
 		free((void *)tnode->type.prefix);
 		free(tnode);
 	}
 }
 
+void erofs_xattr_cleanup_name_prefixes(void)
+{
+	erofs_xattr_cleanup_prefix_list(&ea_name_prefixes);
+	ea_prefix_count = 0;
+	ea_prefixes_reuse = false;
+	ea_prefixes_plain = false;
+}
+
 void erofs_xattr_prefixes_cleanup(struct erofs_sb_info *sbi)
 {
 	int i;
@@ -1611,6 +1626,175 @@ void erofs_xattr_prefixes_cleanup(struct erofs_sb_info *sbi)
 	}
 }
 
+static struct ea_type_node *erofs_xattr_alloc_prefix(unsigned int base_index,
+						   const char *infix,
+						   unsigned int infix_len)
+{
+	struct ea_type_node *tnode;
+	char *name;
+	unsigned int base_len;
+
+	if (base_index >= ARRAY_SIZE(xattr_types) ||
+	    !xattr_types[base_index].prefix || infix_len > UINT8_MAX)
+		return ERR_PTR(-EFSCORRUPTED);
+	base_len = xattr_types[base_index].prefix_len;
+	tnode = calloc(1, sizeof(*tnode));
+	if (!tnode)
+		return ERR_PTR(-ENOMEM);
+	name = malloc(base_len + infix_len + 1);
+	if (!name) {
+		free(tnode);
+		return ERR_PTR(-ENOMEM);
+	}
+	memcpy(name, xattr_types[base_index].prefix, base_len);
+	memcpy(name + base_len, infix, infix_len);
+	name[base_len + infix_len] = '\0';
+	tnode->type.prefix = name;
+	tnode->type.prefix_len = base_len + infix_len;
+	tnode->base_index = base_index;
+	tnode->base_len = base_len;
+	return tnode;
+}
+
+int erofs_xattr_prepare_name_prefixes(struct erofs_importer *im,
+				     bool incremental, bool plain,
+				     u8 *ishare_prefix_id)
+{
+	struct erofs_sb_info *sbi = im->sbi;
+	LIST_HEAD(prefixes);
+	struct erofs_xattr_prefix_item *pfs = NULL;
+	struct ea_type_node *tnode, *entry;
+	unsigned int count = 0, i, infix_len;
+	u8 ishare_id = 0, base_ishare_id;
+	bool reuse;
+	int err;
+
+	if (!incremental)
+		return 0;
+
+	if (sbi->xattr_prefix_count) {
+		/* Follow the reader's address space, even without the plain bit. */
+		if (!erofs_sb_has_plain_xattr_pfx(sbi) &&
+		    (sbi->metabox_nid || sbi->packed_nid))
+			return 0;
+	} else if (!plain &&
+		   (erofs_sb_has_metabox(sbi) || im->params->fragments ||
+		    erofs_sb_has_fragments(sbi))) {
+		return 0;
+	}
+	base_ishare_id = erofs_sb_has_ishare_xattrs(sbi) ?
+			 sbi->ishare_xattr_prefix_id : 0;
+
+	if (sbi->xattr_prefix_count > EROFS_XATTR_LONG_PREFIX)
+		return -EFSCORRUPTED;
+
+	/* Keep every old slot, including duplicates: existing inodes use its ID. */
+	for (i = 0; i < sbi->xattr_prefix_count; ++i) {
+		struct erofs_xattr_prefix_item *pf = &sbi->xattr_prefixes[i];
+
+		tnode = erofs_xattr_alloc_prefix(pf->prefix->base_index,
+						pf->prefix->infix, pf->infix_len);
+		if (IS_ERR(tnode)) {
+			err = PTR_ERR(tnode);
+			goto out;
+		}
+		tnode->index = EROFS_XATTR_LONG_PREFIX | count++;
+		list_add_tail(&tnode->list, &prefixes);
+	}
+
+	list_for_each_entry(tnode, &ea_name_prefixes, list) {
+		struct ea_type_node *match = NULL;
+
+		list_for_each_entry(entry, &prefixes, list) {
+			if (entry->base_index != tnode->base_index ||
+			    entry->type.prefix_len != tnode->type.prefix_len ||
+			    memcmp(entry->type.prefix, tnode->type.prefix,
+				   tnode->type.prefix_len))
+				continue;
+			if (!match)
+				match = entry;
+			/* Preserve the digest's exact ID even with duplicate slots. */
+			if (tnode->index == *ishare_prefix_id &&
+			    erofs_sb_has_ishare_xattrs(sbi) &&
+			    entry->index == sbi->ishare_xattr_prefix_id) {
+				match = entry;
+				break;
+			}
+		}
+		if (!match) {
+			/* TODO: define a policy for exhausted historical prefix slots. */
+			if (count == EROFS_XATTR_LONG_PREFIX) {
+				err = -EOVERFLOW;
+				goto out;
+			}
+			match = erofs_xattr_alloc_prefix(tnode->base_index,
+					tnode->type.prefix + tnode->base_len,
+					tnode->type.prefix_len - tnode->base_len);
+			if (IS_ERR(match)) {
+				err = PTR_ERR(match);
+				goto out;
+			}
+			match->index = EROFS_XATTR_LONG_PREFIX | count++;
+			list_add_tail(&match->list, &prefixes);
+		}
+		if (tnode->index == *ishare_prefix_id)
+			ishare_id = match->index;
+	}
+
+	if (ishare_id && base_ishare_id && ishare_id != base_ishare_id) {
+		erofs_err("--xattr-inode-digest prefix must match the base image");
+		err = -EINVAL;
+		goto out;
+	}
+
+	/* Keep the decoded array valid for later reads of inherited inodes. */
+	if (count) {
+		pfs = calloc(count, sizeof(*pfs));
+		if (!pfs) {
+			err = -ENOMEM;
+			goto out;
+		}
+	}
+	i = 0;
+	list_for_each_entry(tnode, &prefixes, list) {
+		infix_len = tnode->type.prefix_len - tnode->base_len;
+		pfs[i].prefix = malloc(sizeof(*pfs[i].prefix) + infix_len);
+		if (!pfs[i].prefix) {
+			err = -ENOMEM;
+			goto out;
+		}
+		pfs[i].prefix->base_index = tnode->base_index;
+		memcpy(pfs[i].prefix->infix,
+		       tnode->type.prefix + tnode->base_len, infix_len);
+		pfs[i++].infix_len = infix_len;
+	}
+
+	reuse = count && count == sbi->xattr_prefix_count;
+	erofs_xattr_cleanup_name_prefixes();
+	list_splice_tail(&prefixes, &ea_name_prefixes);
+	ea_prefix_count = count;
+	ea_prefixes_reuse = reuse;
+	ea_prefixes_plain = true;
+	erofs_xattr_prefixes_cleanup(sbi);
+	sbi->xattr_prefixes = pfs;
+	sbi->xattr_prefix_count = count;
+	if (count)
+		erofs_sb_set_plain_xattr_pfx(sbi);
+	sbi->ishare_xattr_prefix_id = ishare_id ?: base_ishare_id;
+	if (sbi->ishare_xattr_prefix_id)
+		erofs_sb_set_ishare_xattrs(sbi);
+	*ishare_prefix_id = ishare_id;
+	return 0;
+out:
+	if (pfs) {
+		for (i = 0; i < count; ++i)
+			free(pfs[i].prefix);
+		free(pfs);
+	}
+	erofs_xattr_cleanup_prefix_list(&prefixes);
+	return err;
+}
+
 int erofs_xattr_prefixes_init(struct erofs_sb_info *sbi)
 {
 	bool plain = erofs_sb_has_plain_xattr_pfx(sbi);
diff --git a/man/mkfs.erofs.1 b/man/mkfs.erofs.1
index 65ec807..96340ad 100644
--- a/man/mkfs.erofs.1
+++ b/man/mkfs.erofs.1
@@ -460,12 +460,30 @@ Set the number of worker threads to # (default: number of CPUs).
 .TP
 .BI "\-\-xattr-inode-digest=" name
 Specify extended attribute name to record inode digests.
+
+For incremental builds using plain on-disk xattr prefixes, an existing digest
+name is inherited when this option is omitted.  Specifying a different
+digest name from the base image is rejected.  Enabling digests for the first
+time does not add them to inherited files that are not rebuilt.
 .TP
 .BI "\-\-xattr-prefix=" PREFIX
 Specify a customized extended attribute namespace prefix for space saving,
 e.g. "trusted.overlay.".  You may give multiple
 .B --xattr-prefix
 options (Linux 6.4+).
+
+For incremental builds using a plain on-disk prefix table, these options
+supplement the base image's table.  Existing entries retain their order and
+prefix IDs, including duplicate entries.  Prefixes already present in the
+table do not add entries; new distinct prefixes are appended in command-line
+order.  If no entries are added, the existing table is reused at its original
+location.
+
+Inherited prefixes are also available when encoding xattrs for newly built
+inodes, without repeating these options.  The first matching table entry is
+used: inherited entries are considered in their original order, followed by
+new entries in command-line order.  A later, longer matching prefix does not
+take precedence over an earlier match.
 .TP
 .BI "\-\-zfeature-bits=" #
 Toggle filesystem compression features according to given bits #.
diff --git a/mkfs/main.c b/mkfs/main.c
index f75225b..8311686 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1770,6 +1770,7 @@ int main(int argc, char **argv)
 	};
 	struct erofs_inode *root = NULL;
 	bool tar_index_512b = false;
+	u8 cli_ishare_prefix_id;
 	struct timeval t;
 	FILE *blklst = NULL;
 	int err;
@@ -1803,6 +1804,9 @@ int main(int argc, char **argv)
 	else
 		importer_params.build_time = 0;
 
+	/* The base superblock may overwrite the requested digest prefix ID. */
+	cli_ishare_prefix_id = g_sbi.ishare_xattr_prefix_id;
+
 	err = erofs_dev_open(&g_sbi, cfg.c_img_path, O_RDWR |
 				(incremental_mode ? 0 : O_TRUNC));
 	if (err) {
@@ -1870,6 +1874,15 @@ int main(int argc, char **argv)
 	if (err)
 		goto exit;
 
+	err = erofs_xattr_prepare_name_prefixes(&importer, incremental_mode,
+					      mkfs_plain_xattr_pfx,
+					      &cli_ishare_prefix_id);
+	if (err) {
+		erofs_err("failed to prepare long xattr prefixes: %s",
+			  erofs_strerror(err));
+		goto exit;
+	}
+
 	/* Use the user-defined UUID or generate one for clean builds */
 	if (valid_fixeduuid)
 		memcpy(g_sbi.uuid, fixeduuid, sizeof(g_sbi.uuid));
-- 
2.53.0.apsara


