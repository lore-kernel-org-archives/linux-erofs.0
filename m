Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EEA606A325
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=L8BSGOFw
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1qW6q9Wz3cgw;
	Tue, 10 Nov 2026 20:40:55 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.130
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794303655;
	cv=none; b=OY5kHKlEQMsgGs2LSRE40+UeyJf6iBFYLVoNUk7SzdJd6fztMvDY1+EnpCBvJu8xy83w1+u9EvUNjC1IXyar7k7aW7LjSxekwe86B9t65HFe/kjoeVl+RymonZhD8k5u9Hx4DmYfX+1Hzyn3qCax4caDlCoa+Ff+az8MuiQRJmck6LFcp3NAYPn5uX+bhQamNCarOGkVwhw5ZfEPO4RwBseoK3KCkEz5oBilQdY5VZM2HQEdIyRcM3VgSmNEO14fVawCODOal9eXfJkRyoyMG0bVX2iJGAqIg1tYrwIFH1rBCikgN70d9UswTtGd3T6MLFPHXRQwDvMJphrGLPoHaA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794303655; c=relaxed/relaxed;
	bh=4gbWuM/vC4fCaFTbsTbBNQEHlZ37btPdWOOg4bxky0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLZiV+UH5wK808VNPrjIqnubRKkqzplRidVppx2LaBU5GNwSBvXtpEuRXg/+HO1QVPr2NHbNDxbUPuvKPA25fgKtojw+9wLAGAksIgO0JOXe1RIXnU4bxn9H4iuDpjp53u+8y+FudOtagUQ40kDqobQMNjE+ugBwMpkRZb718DmqAUXn+88Cw5gNTyGhMYIXDC2N188oAPSdX4twPIpCHpNWrUBRHRxMZMe8OtiyujHyNzwc0osIq4Df72d337GnMM1E3pFDncnbzZc50WiljDRTDeFBXtZ1emSIciCjeNN4YxcsBituZYnwGOuJaZuJbRoM2W2NXCZ3N16xPRiBDw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=L8BSGOFw; dkim-atps=neutral; spf=pass (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=lanbingying.lby@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=L8BSGOFw;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=lanbingying.lby@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1qS6fJRz3bxf
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Nov 2026 20:40:52 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794303646; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=4gbWuM/vC4fCaFTbsTbBNQEHlZ37btPdWOOg4bxky0Y=;
	b=L8BSGOFw/CRut3l0FdYg1YE2uyV4cxInyizWYF9E84vZOAzW5eptQe/OC8utpY48HBKLfdLNFLdMFUiU4KEAj+COL0B+FtPabskSAQIVcHEPnM/kZvn9kWeGybzQEo/UegUPh4di1DiJAFAnyeLK9Q9wyih8VuX4RYI+TJd1UAY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=lanbingying.lby@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0XEUy1oy_1794303642;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:lanbingying.lby@linux.alibaba.com fp:SMTPD_---0XEUy1oy_1794303642 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Nov 2026 17:40:43 +0800
From: bingying lan <lanbingying.lby@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org
Subject: [PATCH 3/3] erofs-utils: mkfs: add opt-in plain xattr prefix reservations
Date: Tue, 10 Nov 2026 17:40:12 +0800
Message-ID: <20261110094012.1820140-4-lanbingying.lby@linux.alibaba.com>
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

Add --xattr-prefix-reserve to allocate a fixed 64 KiB region for plain
xattr prefixes, including empty tables. Record the reservation with a
compat feature bit and the existing prefix address, without changing
record encoding or adding address and capacity fields.

Use existing reservations in later incremental builds and append only
new prefix records. Explicitly requesting a reservation on an unreserved
image relocates the merged table even when its entries are unchanged.
If the new start exceeds the address limit, warn and reuse an unchanged
table; reject the operation when new entries require a new table.

Keep reservation opt-in, preserve the original record write lengths,
and leave packed and metabox tables on their existing paths. Document
the allocation overhead, compatibility constraints and rebuild fallback.

Signed-off-by: bingying lan <lanbingying.lby@linux.alibaba.com>
---
 include/erofs/internal.h |   1 +
 include/erofs/xattr.h    |   5 +-
 include/erofs_fs.h       |   2 +
 lib/xattr.c              | 124 +++++++++++++++++++++++++++++++--------
 man/mkfs.erofs.1         |  33 ++++++++++-
 mkfs/main.c              |  27 ++++++++-
 6 files changed, 165 insertions(+), 27 deletions(-)

diff --git a/include/erofs/internal.h b/include/erofs/internal.h
index 19e38fb..b46136f 100644
--- a/include/erofs/internal.h
+++ b/include/erofs/internal.h
@@ -194,6 +194,7 @@ EROFS_FEATURE_FUNCS(xattr_filter, compat, COMPAT_XATTR_FILTER)
 EROFS_FEATURE_FUNCS(shared_ea_in_metabox, compat, COMPAT_SHARED_EA_IN_METABOX)
 EROFS_FEATURE_FUNCS(plain_xattr_pfx, compat, COMPAT_PLAIN_XATTR_PFX)
 EROFS_FEATURE_FUNCS(ishare_xattrs, compat, COMPAT_ISHARE_XATTRS)
+EROFS_FEATURE_FUNCS(xattr_prefix_reserved, compat, COMPAT_XATTR_PREFIX_RESERVED)
 
 #define EROFS_I_EA_INITED_BIT	0
 #define EROFS_I_Z_INITED_BIT	1
diff --git a/include/erofs/xattr.h b/include/erofs/xattr.h
index fb960d2..ef8a69b 100644
--- a/include/erofs/xattr.h
+++ b/include/erofs/xattr.h
@@ -9,6 +9,8 @@ extern "C"
 
 #include "internal.h"
 
+#define EROFS_XATTR_PREFIX_RESERVE_SIZE	65536
+
 static inline unsigned int inlinexattr_header_size(struct erofs_inode *vi)
 {
 	return sizeof(struct erofs_xattr_ibody_header) +
@@ -36,11 +38,12 @@ int erofs_xattr_insert_name_prefix(const char *prefix);
 /*
  * Merge base prefixes for incremental plain tables; other paths are unchanged.
  * plain selects storage for a new table, not conversion of an existing one.
+ * reserve requests a fixed-size reservation and requires plain storage.
  * ishare_prefix_id is the CLI digest ID (0 if omitted), remapped on success;
  * sbi holds the resulting digest configuration, including inherited settings.
  */
 int erofs_xattr_prepare_name_prefixes(struct erofs_importer *im,
-				     bool incremental, bool plain,
+				     bool incremental, bool plain, bool reserve,
 				     u8 *ishare_prefix_id);
 int erofs_xattr_set_ishare_prefix(struct erofs_sb_info *sbi,
 				  const char *prefix);
diff --git a/include/erofs_fs.h b/include/erofs_fs.h
index 5d12049..ae6f3e5 100644
--- a/include/erofs_fs.h
+++ b/include/erofs_fs.h
@@ -19,6 +19,8 @@
 #define EROFS_FEATURE_COMPAT_SHARED_EA_IN_METABOX	0x00000008
 #define EROFS_FEATURE_COMPAT_PLAIN_XATTR_PFX		0x00000010
 #define EROFS_FEATURE_COMPAT_ISHARE_XATTRS		0x00000020
+/* 64 KiB at xattr_prefix_start * 4 is reserved for plain xattr prefixes. */
+#define EROFS_FEATURE_COMPAT_XATTR_PREFIX_RESERVED	0x00000040
 
 /*
  * Any bits that aren't in EROFS_ALL_FEATURE_INCOMPAT should
diff --git a/lib/xattr.c b/lib/xattr.c
index 66a36a6..23a6f4b 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -206,8 +206,11 @@ struct ea_type_node {
 
 static LIST_HEAD(ea_name_prefixes);
 static unsigned int ea_prefix_count;
-static bool ea_prefixes_reuse;
 static bool ea_prefixes_plain;
+static bool ea_prefixes_reserve;
+static bool ea_prefixes_incremental;
+static unsigned int ea_prefixes_base_count;
+static unsigned int ea_prefixes_base_size;
 
 bool erofs_xattr_prefix_matches(const char *key, unsigned int *index,
 				unsigned int *len)
@@ -882,6 +885,10 @@ int erofs_xattr_flush_name_prefixes(struct erofs_importer *im, bool plain)
 	const struct erofs_importer_params *params = im->params;
 	struct erofs_sb_info *sbi = im->sbi;
 	bool may_fragments = params->fragments || erofs_sb_has_fragments(sbi);
+	bool reserved = erofs_sb_has_xattr_prefix_reserved(sbi);
+	bool reserve = reserved || ea_prefixes_reserve;
+	bool table_unchanged = ea_prefix_count == ea_prefixes_base_count;
+	bool need_new_reservation = ea_prefixes_reserve && !reserved;
 	struct erofs_vfile *vf = &sbi->bdev;
 	struct erofs_bufmgr *bmgr = sbi->bmgr;
 	struct erofs_buffer_head *bh = NULL;
@@ -889,12 +896,13 @@ int erofs_xattr_flush_name_prefixes(struct erofs_importer *im, bool plain)
 	struct ea_type_node *tnode;
 	erofs_off_t *ppos = NULL;
 	s64 start, offset = 0;
+	unsigned int i = 0, size = 0;
 	int err;
 
-	if (!ea_prefix_count)
+	if (!ea_prefix_count && !reserve)
 		return 0;
 
-	if (ea_prefixes_reuse) {
+	if (table_unchanged && !need_new_reservation) {
 		erofs_sb_set_plain_xattr_pfx(sbi);
 		return 0;
 	}
@@ -916,8 +924,20 @@ int erofs_xattr_flush_name_prefixes(struct erofs_importer *im, bool plain)
 	if (plain)
 		erofs_sb_set_plain_xattr_pfx(sbi);
 
-	if (bmgr) {
-		bh = erofs_balloc(bmgr, XATTR, 0, 0);
+	if (reserve) {
+		list_for_each_entry(tnode, &ea_name_prefixes, list)
+			size += EROFS_XATTR_ALIGN(sizeof(__le16) +
+				 sizeof(struct erofs_xattr_long_prefix) +
+				 tnode->type.prefix_len - tnode->base_len);
+		if (size > EROFS_XATTR_PREFIX_RESERVE_SIZE)
+			return -EOVERFLOW;
+	}
+	if (reserved) {
+		offset = (erofs_off_t)sbi->xattr_prefix_start << 2;
+	} else if (bmgr) {
+		/* DIRA allocates block-aligned metadata, separate from the SB. */
+		bh = erofs_balloc(bmgr, reserve ? DIRA : XATTR,
+				 reserve ? EROFS_XATTR_PREFIX_RESERVE_SIZE : 0, 0);
 		if (IS_ERR(bh))
 			return PTR_ERR(bh);
 		bh->op = &erofs_drop_directly_bhops;
@@ -925,12 +945,32 @@ int erofs_xattr_flush_name_prefixes(struct erofs_importer *im, bool plain)
 		offset = erofs_btell(bh, false);
 	}
 
-	if ((offset >> 2) > UINT32_MAX)
+	if ((offset >> 2) > UINT32_MAX) {
+		if (reserve) {
+			erofs_bdrop(bh, true);
+			if (ea_prefixes_incremental && table_unchanged) {
+				erofs_warn("cannot reserve xattr prefixes beyond the address limit; %s. Rebuild a new image from complete contents with --xattr-prefix-reserve to reserve space",
+					   ea_prefix_count ? "reusing the old table" :
+							     "keeping the table empty");
+				return 0;
+			}
+			erofs_err("xattr prefix reservation start exceeds the address limit; rebuild a new image from complete contents with --xattr-prefix-reserve");
+		}
 		return -EOVERFLOW;
+	}
 	start = offset;
 
-	sbi->xattr_prefix_start = (u32)(offset >> 2);
-	sbi->xattr_prefix_count = ea_prefix_count;
+	if (reserved) {
+		offset += ea_prefixes_base_size;
+	} else if (reserve) {
+		err = erofs_io_fallocate(vf, start,
+					 EROFS_XATTR_PREFIX_RESERVE_SIZE, true);
+		if (err)
+			return err;
+	} else {
+		sbi->xattr_prefix_start = (u32)(start >> 2);
+		sbi->xattr_prefix_count = ea_prefix_count;
+	}
 
 	list_for_each_entry(tnode, &ea_name_prefixes, list) {
 		union {
@@ -943,6 +983,8 @@ int erofs_xattr_flush_name_prefixes(struct erofs_importer *im, bool plain)
 		} u;
 		int len, infix_len;
 
+		if (reserved && i++ < ea_prefixes_base_count)
+			continue;
 		u.s.prefix.base_index = tnode->base_index;
 		infix_len = tnode->type.prefix_len - tnode->base_len;
 		memcpy(u.s.prefix.infix, tnode->type.prefix + tnode->base_len,
@@ -959,16 +1001,24 @@ int erofs_xattr_flush_name_prefixes(struct erofs_importer *im, bool plain)
 	}
 
 	if (bh) {
-		err = erofs_bh_balloon(bh, offset - start);
-		if (err < 0)
-			return err;
+		if (!reserve) {
+			err = erofs_bh_balloon(bh, offset - start);
+			if (err < 0)
+				return err;
+		}
 		erofs_bdrop(bh, false);
-	} else {
+	} else if (!reserved) {
 		DBG_BUGON(bmgr);
 		if (ppos)
 			*ppos = offset;
 	}
-	erofs_sb_set_xattr_prefixes(sbi);
+	if (reserve) {
+		sbi->xattr_prefix_start = (u32)(start >> 2);
+		sbi->xattr_prefix_count = ea_prefix_count;
+		erofs_sb_set_xattr_prefix_reserved(sbi);
+	}
+	if (ea_prefix_count)
+		erofs_sb_set_xattr_prefixes(sbi);
 	return 0;
 }
 
@@ -1610,8 +1660,11 @@ void erofs_xattr_cleanup_name_prefixes(void)
 {
 	erofs_xattr_cleanup_prefix_list(&ea_name_prefixes);
 	ea_prefix_count = 0;
-	ea_prefixes_reuse = false;
 	ea_prefixes_plain = false;
+	ea_prefixes_reserve = false;
+	ea_prefixes_incremental = false;
+	ea_prefixes_base_count = 0;
+	ea_prefixes_base_size = 0;
 }
 
 void erofs_xattr_prefixes_cleanup(struct erofs_sb_info *sbi)
@@ -1657,29 +1710,40 @@ static struct ea_type_node *erofs_xattr_alloc_prefix(unsigned int base_index,
 }
 
 int erofs_xattr_prepare_name_prefixes(struct erofs_importer *im,
-				     bool incremental, bool plain,
+				     bool incremental, bool plain, bool reserve,
 				     u8 *ishare_prefix_id)
 {
 	struct erofs_sb_info *sbi = im->sbi;
 	LIST_HEAD(prefixes);
 	struct erofs_xattr_prefix_item *pfs = NULL;
 	struct ea_type_node *tnode, *entry;
-	unsigned int count = 0, i, infix_len;
+	unsigned int count = 0, i, infix_len, base_size = 0;
+	unsigned int base_count = sbi->xattr_prefix_count;
 	u8 ishare_id = 0, base_ishare_id;
-	bool reuse;
 	int err;
 
-	if (!incremental)
-		return 0;
+	if (incremental && erofs_sb_has_xattr_prefix_reserved(sbi)) {
+		erofs_off_t start = (erofs_off_t)sbi->xattr_prefix_start << 2;
+		erofs_off_t end = erofs_pos(sbi, sbi->dif0.blocks);
 
-	if (sbi->xattr_prefix_count) {
+		if (!erofs_sb_has_plain_xattr_pfx(sbi) ||
+		    start % erofs_blksiz(sbi) ||
+		    start < round_up(EROFS_SUPER_OFFSET + sbi->sb_size,
+				     erofs_blksiz(sbi)) ||
+		    start > end || end - start < EROFS_XATTR_PREFIX_RESERVE_SIZE)
+			return -EFSCORRUPTED;
+	} else if (incremental && base_count) {
 		/* Follow the reader's address space, even without the plain bit. */
 		if (!erofs_sb_has_plain_xattr_pfx(sbi) &&
 		    (sbi->metabox_nid || sbi->packed_nid))
-			return 0;
+			goto nonplain;
 	} else if (!plain &&
 		   (erofs_sb_has_metabox(sbi) || im->params->fragments ||
 		    erofs_sb_has_fragments(sbi))) {
+		goto nonplain;
+	}
+	if (!incremental) {
+		ea_prefixes_reserve = reserve;
 		return 0;
 	}
 	base_ishare_id = erofs_sb_has_ishare_xattrs(sbi) ?
@@ -1700,6 +1764,13 @@ int erofs_xattr_prepare_name_prefixes(struct erofs_importer *im,
 		}
 		tnode->index = EROFS_XATTR_LONG_PREFIX | count++;
 		list_add_tail(&tnode->list, &prefixes);
+		base_size += round_up(sizeof(__le16) + sizeof(*pf->prefix) +
+				      pf->infix_len, 4);
+	}
+	if (erofs_sb_has_xattr_prefix_reserved(sbi) &&
+	    base_size > EROFS_XATTR_PREFIX_RESERVE_SIZE) {
+		err = -EFSCORRUPTED;
+		goto out;
 	}
 
 	list_for_each_entry(tnode, &ea_name_prefixes, list) {
@@ -1769,12 +1840,14 @@ int erofs_xattr_prepare_name_prefixes(struct erofs_importer *im,
 		pfs[i++].infix_len = infix_len;
 	}
 
-	reuse = count && count == sbi->xattr_prefix_count;
 	erofs_xattr_cleanup_name_prefixes();
 	list_splice_tail(&prefixes, &ea_name_prefixes);
 	ea_prefix_count = count;
-	ea_prefixes_reuse = reuse;
 	ea_prefixes_plain = true;
+	ea_prefixes_reserve = reserve;
+	ea_prefixes_incremental = true;
+	ea_prefixes_base_count = base_count;
+	ea_prefixes_base_size = base_size;
 	erofs_xattr_prefixes_cleanup(sbi);
 	sbi->xattr_prefixes = pfs;
 	sbi->xattr_prefix_count = count;
@@ -1785,6 +1858,11 @@ int erofs_xattr_prepare_name_prefixes(struct erofs_importer *im,
 		erofs_sb_set_ishare_xattrs(sbi);
 	*ishare_prefix_id = ishare_id;
 	return 0;
+nonplain:
+	if (!reserve)
+		return 0;
+	erofs_err("--xattr-prefix-reserve requires a plain xattr prefix table");
+	return -EINVAL;
 out:
 	if (pfs) {
 		for (i = 0; i < count; ++i)
diff --git a/man/mkfs.erofs.1 b/man/mkfs.erofs.1
index 96340ad..9bf50cb 100644
--- a/man/mkfs.erofs.1
+++ b/man/mkfs.erofs.1
@@ -477,7 +477,7 @@ supplement the base image's table.  Existing entries retain their order and
 prefix IDs, including duplicate entries.  Prefixes already present in the
 table do not add entries; new distinct prefixes are appended in command-line
 order.  If no entries are added, the existing table is reused at its original
-location.
+location, unless \fB\-\-xattr-prefix-reserve\fR requests a new reservation.
 
 Inherited prefixes are also available when encoding xattrs for newly built
 inodes, without repeating these options.  The first matching table entry is
@@ -485,6 +485,37 @@ used: inherited entries are considered in their original order, followed by
 new entries in command-line order.  A later, longer matching prefix does not
 take precedence over an earlier match.
 .TP
+.B \-\-xattr-prefix-reserve
+Reserve a fixed 64 KiB region for a plain on-disk xattr prefix table,
+including an empty table.  This option is disabled by default.  The region
+starts at a filesystem block boundary, after the superblock and necessary
+configuration data in a full build.  Its allocation and alignment increase
+the image size.  The capacity accommodates the current format's maximum
+128 entries of up to 260 bytes each, including alignment.
+
+For incremental builds, an existing reservation is used even when this
+option is omitted.  Unchanged tables are not rewritten; new entries are
+appended within the reservation without changing old entries or their IDs.
+Specifying this option for an unreserved plain table allocates a reservation
+in the appended area and copies the merged table there, even if the table
+is unchanged.  Repeating the option does not allocate another reservation.
+
+Only the reservation's start must fit in the existing 32-bit, four-byte-unit
+offset; the region may extend beyond 16 GiB.  If an incremental build cannot
+represent the new start and no entries were added, it warns and reuses the
+old table (or keeps an empty table), without reserving space.  If entries
+were added, it fails.  To establish a reservation in this case, rebuild a
+new image from complete contents with this option; a partial incremental
+source is insufficient.
+
+Packed inode and metabox prefix tables are not supported by this option
+and are not automatically converted.  For a new table, use
+\fB\-E plain-xattr-prefixes\fR if necessary to select plain storage.
+The reservation uses a compat feature bit without changing prefix records
+or offsets; readers supporting the existing plain table format may ignore
+the bit.  Mixing older writing tools is not supported: they may invalidate
+the reservation while preserving its flag.
+.TP
 .BI "\-\-zfeature-bits=" #
 Toggle filesystem compression features according to given bits #.
 Each bit in the value corresponds to a specific compression feature:
diff --git a/mkfs/main.c b/mkfs/main.c
index 8311686..78b8142 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -105,6 +105,7 @@ static struct option long_options[] = {
 	{"MZ", optional_argument, NULL, 537},
 	{"xattr-prefix", required_argument, NULL, 538},
 	{"xattr-inode-digest", optional_argument, NULL, 539},
+	{"xattr-prefix-reserve", no_argument, NULL, 540},
 	{0, 0, 0, 0},
 };
 
@@ -260,6 +261,7 @@ static void usage(int argc, char **argv)
 #endif
 		" --xattr-inode-digest=X specify extended attribute name X (\"" EROFS_EA_INODE_DIGEST_DEFAULT "\" if omitted) to record inode digests\n"
 		" --xattr-prefix=X       X=extra xattr name prefix\n"
+		" --xattr-prefix-reserve reserve 64 KiB for a plain xattr prefix table\n"
 		" --zfeature-bits=#      toggle filesystem compression features according to given bits #\n"
 #ifdef WITH_ANDROID
 		"\n"
@@ -488,6 +490,7 @@ static struct {
 
 static bool mkfs_no_datainline;
 static bool mkfs_plain_xattr_pfx;
+static bool mkfs_xattr_prefix_reserve;
 
 static int parse_extended_opts(struct erofs_importer_params *params,
 			       const char *opts)
@@ -1497,6 +1500,9 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 				return err;
 			}
 			break;
+		case 540:
+			mkfs_xattr_prefix_reserve = true;
+			break;
 		case 'V':
 			version();
 			exit(0);
@@ -1770,6 +1776,7 @@ int main(int argc, char **argv)
 	};
 	struct erofs_inode *root = NULL;
 	bool tar_index_512b = false;
+	bool early_xattr_prefixes;
 	u8 cli_ishare_prefix_id;
 	struct timeval t;
 	FILE *blklst = NULL;
@@ -1876,6 +1883,7 @@ int main(int argc, char **argv)
 
 	err = erofs_xattr_prepare_name_prefixes(&importer, incremental_mode,
 					      mkfs_plain_xattr_pfx,
+					      mkfs_xattr_prefix_reserve,
 					      &cli_ishare_prefix_id);
 	if (err) {
 		erofs_err("failed to prepare long xattr prefixes: %s",
@@ -1962,6 +1970,19 @@ int main(int argc, char **argv)
 			goto exit;
 	}
 
+	/* Reserve after mandatory configs, before shared xattrs and file data. */
+	early_xattr_prefixes = mkfs_xattr_prefix_reserve ||
+			       erofs_sb_has_xattr_prefix_reserved(&g_sbi);
+	if (early_xattr_prefixes) {
+		err = erofs_xattr_flush_name_prefixes(&importer,
+						    mkfs_plain_xattr_pfx);
+		if (err) {
+			erofs_err("failed to flush long xattr prefixes: %s",
+				  erofs_strerror(err));
+			goto exit;
+		}
+	}
+
 	if (source_mode == EROFS_MKFS_SOURCE_LOCALDIR) {
 		err = erofs_load_shared_xattrs_from_path(&g_sbi, cfg.c_src_path,
 						mkfscfg.inlinexattr_tolerance);
@@ -1971,7 +1992,8 @@ int main(int argc, char **argv)
 			goto exit;
 		}
 
-		err = erofs_xattr_flush_name_prefixes(&importer,
+		if (!early_xattr_prefixes)
+			err = erofs_xattr_flush_name_prefixes(&importer,
 						      mkfs_plain_xattr_pfx);
 		if (err) {
 			erofs_err("failed to flush long xattr prefixes: %s",
@@ -1985,7 +2007,8 @@ int main(int argc, char **argv)
 			goto exit;
 		}
 	} else {
-		err = erofs_xattr_flush_name_prefixes(&importer,
+		if (!early_xattr_prefixes)
+			err = erofs_xattr_flush_name_prefixes(&importer,
 						      mkfs_plain_xattr_pfx);
 		if (err) {
 			erofs_err("failed to flush long xattr prefixes: %s",
-- 
2.53.0.apsara


