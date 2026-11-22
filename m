Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A68606A320
	for <linux-erofs@archiver.kernel.org>; Sun, 22 Nov 2026 03:12:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jXDdR5Twcz2yMk;
	Sun, 22 Nov 2026 14:12:11 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795317131;
	cv=none; b=fZyuRQU9u0bAta1AJizXxoRPZ/8spb0O+4NO5ZpgNy2zpbnWNCQW4pk8HwFpfZz+Nn12GkGIOxFIUjwzo2CwutQonvHUL4pQaRj8NRg8B2MUyoCpK9heB6OPeX4fxX8wPrnYpSiFzs7buVokeCraZZWluDEtARDmJwCp1ym/QsxnEpbO4K9ii63fyIEFcnxPgoaHVFVOgDQ7MAbUT/HKRrp1OaVTAebHWofQ3chB+5RgAHux9R8kClZLFs7BvTFujS5gza0+kaYCFMIu1MMKfxCPbhFb1BVCdp/IiObd1hJaSeMNAe6B1HGZPELNBqTDZOr7mKj0fhT/4mFqbi2PmA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795317131; c=relaxed/relaxed;
	bh=CiHCt/6ywjpOw7NYMUwbkbU2j7qoIzofHPU+v+aosKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HeM7lCt72gUbKdIM5cH2/KM/c774aSE1yyxQnq1Cbj2lDQDFLfZWw805rRrPjcAG6UvtIXX7a4wysaNcdWmFA1KSAciWVMlZPlUWpmIcgxBbJao9gdCzytrcMV5QLhGNjobZffLBWbUjwWw/VJBpMczu5PBZe0jNfNvKo5J2hRO1tcEokNEDAEhRS+cKVTswAL2ede3SLmNSOPPadND6sURHDKOu2XaGlJ9L7Jj4FpcncI7BvONsCapYKZwyD4zWhm4JcxfaKW38fcUfQEgZqrJFtKrmDOnSnPWCL3t+z9xzyUVZbWkDlCuw3CppJv9dMbO3vcWFD4V2JQOSThGkiQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn; spf=pass (client-ip=159.226.251.21; helo=cstnet.cn; envelope-from=yanmengdie24@mails.ucas.ac.cn; receiver=lists.ozlabs.org) smtp.mailfrom=mails.ucas.ac.cn
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=mails.ucas.ac.cn (client-ip=159.226.251.21; helo=cstnet.cn; envelope-from=yanmengdie24@mails.ucas.ac.cn; receiver=lists.ozlabs.org)
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jXDdL4V25z2yMP
	for <linux-erofs@lists.ozlabs.org>; Sun, 22 Nov 2026 14:12:05 +1100 (AEDT)
Received: from localhost.localdomain (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowAAnUvy6WwJrpQZzAQ--.19540S4;
	Sun, 22 Nov 2026 11:04:33 +0800 (CST)
From: Mengdie Yan <yanmengdie24@mails.ucas.ac.cn>
To: linux-erofs@lists.ozlabs.org
Cc: Mengdie Yan <yanmengdie24@mails.ucas.ac.cn>,
	Gao Xiang <xiang@kernel.org>,
	Chengyu Zhu <hudsonzhu@tencent.com>
Subject: [PATCH 2/4] erofs-utils: mkfs: preserve hot file placement during compression
Date: Sun, 22 Nov 2026 11:04:21 +0800
Message-ID: <e6411ea79c5b54e64c2b16fdf8772600ad93986a.1795283998.git.yanmengdie24@mails.ucas.ac.cn>
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
X-CM-TRANSID:qwCowAAnUvy6WwJrpQZzAQ--.19540S4
X-Coremail-Antispam: 1UD129KBjvJXoW3Jr4fWrykJFyxCF4UWryUZFb_yoW7ZFWxpF
	1Fka48X395XFyjk3WxZr4FqFyYgFWfJr4UWw1rXrn3t3W5GFyIqF10yrn8AFWUWrZ5X3yq
	vwsFv34Uur4DG3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1l84
	ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr0_Cr1U
	M2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64
	kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv67AKxVW8Jr0_Cr1U
	McvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I64
	8v4I1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AK
	xVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrx
	kI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v2
	6r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
	CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU5LvKUUUU
	U
X-CM-SenderInfo: 51dqzv5qjgxvysu6ztxlovh3xfdvhtffof0/
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Allow hot files to be compressed, but keep them out of fragment packing.
Fragments move file tails into the packed inode, which is written after
all other data, so hot tails would end up far away from the hot area.

Since hot files are not packed, their tails can be inlined even if
fragments are enabled.  Don't mark them as interlaced in that case,
as inline pclusters are never interlaced.

Inline tails, data deduplication and extent deduplication only place data
next to the inode or reference data written earlier, so they are kept as
is.

Signed-off-by: Mengdie Yan <yanmengdie24@mails.ucas.ac.cn>
---
 lib/compress.c   | 19 +++++++++++++++----
 man/mkfs.erofs.1 | 10 ++++++----
 mkfs/main.c      |  6 ------
 3 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/lib/compress.c b/lib/compress.c
index e764e44..56e559b 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -599,7 +599,8 @@ static int __z_erofs_compress_one(struct z_erofs_compress_sctx *ctx,
 	bool is_packed_inode = erofs_is_packed_inode(inode);
 	bool tsg = (ctx->seg_idx + 1 >= ictx->seg_num), final = !ctx->remaining;
 	bool may_packing = (params->fragments && tsg && final && !is_packed_inode &&
-			    !erofs_is_metabox_inode(inode));
+			    !erofs_is_metabox_inode(inode) &&
+			    !erofs_inode_is_hotfile(inode));
 	bool data_unaligned = ictx->data_unaligned;
 	bool may_inline = (params->ztailpacking && !data_unaligned && tsg &&
 			   final && !may_packing);
@@ -1343,6 +1344,7 @@ int z_erofs_compress_segment(struct z_erofs_compress_sctx *ctx,
 	struct erofs_inode *inode = ictx->inode;
 	bool frag = params->fragments && !erofs_is_packed_inode(inode) &&
 		!erofs_is_metabox_inode(inode) &&
+		!erofs_inode_is_hotfile(inode) &&
 		ctx->seg_idx >= ictx->seg_num - 1;
 	struct erofs_vfile *vf = ictx->vf;
 	int ret;
@@ -1978,7 +1980,8 @@ void *erofs_prepare_compressed_file(struct erofs_importer *im,
 	struct erofs_sb_info *sbi = inode->sbi;
 	struct z_erofs_compress_ictx *ictx;
 	bool frag = params->fragments && !erofs_is_packed_inode(inode) &&
-		!erofs_is_metabox_inode(inode);
+		!erofs_is_metabox_inode(inode) &&
+		!erofs_inode_is_hotfile(inode);
 	bool all_fragments = params->all_fragments && frag;
 
 	/* initialize per-file compression setting */
@@ -2018,6 +2021,9 @@ void *erofs_prepare_compressed_file(struct erofs_importer *im,
 	}
 	ictx->im = im;
 	ictx->inode = inode;
+	/* hot files are never packed, skip the fragment tail queue */
+	if (erofs_inode_is_hotfile(inode))
+		ictx->tofh = ~0U;
 	ictx->device_id = !params->fragments && !params->dedupe &&
 		!erofs_is_packed_inode(inode) &&
 		!erofs_is_metabox_inode(inode) &&
@@ -2067,8 +2073,12 @@ void *erofs_prepare_compressed_file(struct erofs_importer *im,
 			params->max_compressed_extent_size;
 		ictx->data_unaligned = false;
 	}
+	/*
+	 * Hot files are not packed, so their tails may be inlined; inline
+	 * pclusters are never interlaced.
+	 */
 	if (params->fragments && params->dedupe != EROFS_DEDUPE_FORCE_ON &&
-	    !ictx->data_unaligned)
+	    !ictx->data_unaligned && !erofs_inode_is_hotfile(inode))
 		inode->z_advise |= Z_EROFS_ADVISE_INTERLACED_PCLUSTER;
 
 	init_list_head(&ictx->extents);
@@ -2094,7 +2104,8 @@ int erofs_begin_compressed_file(struct z_erofs_compress_ictx *ictx)
 	const struct erofs_importer_params *params = ictx->im->params;
 	struct erofs_inode *inode = ictx->inode;
 	bool frag = params->fragments && !erofs_is_packed_inode(inode) &&
-		!erofs_is_metabox_inode(inode);
+		!erofs_is_metabox_inode(inode) &&
+		!erofs_inode_is_hotfile(inode);
 	bool all_fragments = params->all_fragments && frag;
 	int ret;
 
diff --git a/man/mkfs.erofs.1 b/man/mkfs.erofs.1
index f8157b4..f06ff9b 100644
--- a/man/mkfs.erofs.1
+++ b/man/mkfs.erofs.1
@@ -316,13 +316,15 @@ directory sources.
 Leading slashes refer to the image root.  Empty lines and lines starting
 with # are ignored; other spaces are part of the filename.  Use ./ to list
 a filename beginning with #.
-Hot regular files are scheduled in list order before cold files.
-Unlisted files retain their relative traversal order.
+Hot regular files are scheduled in list order before cold files while keeping
+compression enabled.  Unlisted files retain their relative traversal order.
 Hardlink aliases share the earliest matching rank.
-Symlinks are resolved within the image root, including intermediate components.
+Symlinks, including intermediate ones, are resolved within the image root
+and are prioritized together with their targets.
 Parent directories are also prioritized.  Entries ending in \fI/\fR prioritize
 the directory without recursively marking its children hot.
-This option currently requires uncompressed builds.
+Hot files are never packed into fragments, since that would move their
+tails out of the hot area.
 Data deduplication and chunk sharing are kept, so hot files may still
 share physical extents with other files.
 This is file-level data ordering: directory compression, metadata zones and
diff --git a/mkfs/main.c b/mkfs/main.c
index f5044ba..299f2cd 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1940,12 +1940,6 @@ int main(int argc, char **argv)
 	if (err)
 		goto exit;
 
-	if (erofs_hotfile_enabled() && g_sbi.available_compr_algs) {
-		erofs_err("--hot-file-list requires uncompressed output");
-		err = -EOPNOTSUPP;
-		goto exit;
-	}
-
 	if (importer_params.dedupe == EROFS_DEDUPE_FORCE_ON &&
 	    g_sbi.available_compr_algs) {
 		err = z_erofs_dedupe_init(erofs_blksiz(&g_sbi));
-- 
2.50.1 (Apple Git-155)


