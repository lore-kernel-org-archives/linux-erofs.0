Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59671606A320
	for <linux-erofs@archiver.kernel.org>; Sun, 22 Nov 2026 03:12:10 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jXDdN1dHbz2yQl;
	Sun, 22 Nov 2026 14:12:08 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795317128;
	cv=none; b=UORsrSggEDt0/L18JcyUAF/7cwK5uqT5v6bgOg93eFvdSTYnhBP55DWm3K7vBfX/poZ+inku7CIG4l/qxmogTP2UC4JPrQB5jf7hO7mSJGEMPZt+BiY2h3TJLB1zHRnjLxrj7Ot7Ni2aH5rBoE5zWsDv09Zwa0TqMXOw+hKdRTAe63g04wkoVgVG3EtPz4seiDUTJBI2DqJOAhzZtdUZq/oDq8NtEbGYAclkGrJKaYryLfhM6AmnYRNfYBE+FZT1KTE8gdNFkXHJCfHljLjbmDrbexdiD5ZOjAbxHXlggrpFqoXHQpPCshTPE+spN7hZKvFGRlGYpboGPC5FnJzfxw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795317128; c=relaxed/relaxed;
	bh=ZZwiHr5OLPJ3nb4+YqlG60fr7dpbgNMCg8tg5KDmx5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaYuQ5gYBQawy+ynxoPlxJ2OKZY6ZJVAIYZqHE6xiamX+kLMnmhiEDoqadYcT5miUHT0AyFuakEMPMEqHuYfJLUtgMCtcoUno27TW8Dc9ykx870IenMjBu9UThbo/yvskxiqG2MaaviECX2EUz0Nb/x+T3vou+VT16n9f5H3iNi/SaK0oiVTgEAGSeVcn+QebLoYmKflj7Igvt4AQTDXOfEMPImPPs6DugLDtRqaYcqq+aCV61xRQcYD3sqSVqC8WTFmPGD0F9qdz1FZjdaNWQ4sjaLZ1GHBb9V7M4EmVOoedIwkn71XzVhvgQmZ2ZhOHVO882Gxe3l07xNmcr+N2g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn; spf=pass (client-ip=159.226.251.21; helo=cstnet.cn; envelope-from=yanmengdie24@mails.ucas.ac.cn; receiver=lists.ozlabs.org) smtp.mailfrom=mails.ucas.ac.cn
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=mails.ucas.ac.cn (client-ip=159.226.251.21; helo=cstnet.cn; envelope-from=yanmengdie24@mails.ucas.ac.cn; receiver=lists.ozlabs.org)
X-Greylist: delayed 445 seconds by postgrey-1.37 at boromir; Sun, 22 Nov 2026 14:12:06 AEDT
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jXDdL4Lm6z2xgv
	for <linux-erofs@lists.ozlabs.org>; Sun, 22 Nov 2026 14:12:05 +1100 (AEDT)
Received: from localhost.localdomain (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowAAnUvy6WwJrpQZzAQ--.19540S6;
	Sun, 22 Nov 2026 11:04:33 +0800 (CST)
From: Mengdie Yan <yanmengdie24@mails.ucas.ac.cn>
To: linux-erofs@lists.ozlabs.org
Cc: Mengdie Yan <yanmengdie24@mails.ucas.ac.cn>,
	Gao Xiang <xiang@kernel.org>,
	Chengyu Zhu <hudsonzhu@tencent.com>
Subject: [PATCH 4/4] erofs-utils: mkfs: support hot file lists for full OCI imports
Date: Sun, 22 Nov 2026 11:04:23 +0800
Message-ID: <0c5524252aabc257fed4d638210cb19435b002e8.1795283998.git.yanmengdie24@mails.ucas.ac.cn>
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
X-CM-TRANSID:qwCowAAnUvy6WwJrpQZzAQ--.19540S6
X-Coremail-Antispam: 1UD129KBjvJXoWxCr1xAFykKw47WFWkuFWUtwb_yoWrJr4Dpr
	Wa9a45JrWkJr1jywn3u3W0gF1fW3s7JFWakayrArn7Can8Grn7AF10ywnY9FyUWr1rZFWj
	yF4YyrW7G39rZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr
	1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr0_
	Cr1UM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4
	xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv67AKxVW8Jr0_
	Cr1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI
	8I648v4I1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU8Sdy
	UUUUU
X-CM-SenderInfo: 51dqzv5qjgxvysu6ztxlovh3xfdvhtffof0/
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Prepare hot paths after OCI import using the same final-tree lookup and
file scheduler as full TAR inputs. Select the source explicitly so a
local path matching an image reference cannot affect hot-list parsing.

Signed-off-by: Mengdie Yan <yanmengdie24@mails.ucas.ac.cn>
---
 man/mkfs.erofs.1 |  6 +++---
 mkfs/main.c      | 12 +++++++++---
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/man/mkfs.erofs.1 b/man/mkfs.erofs.1
index 983f385..9cbf436 100644
--- a/man/mkfs.erofs.1
+++ b/man/mkfs.erofs.1
@@ -312,7 +312,7 @@ Dereference hardlinks and add links as separate inodes.
 .TP
 .BI "\-\-hot-file-list=" path
 Read a newline-delimited list of image-relative hot file paths for local
-directory or tar full sources.
+directory, tar full, or OCI full sources.
 Leading slashes refer to the image root.  Empty lines and lines starting
 with # are ignored; other spaces are part of the filename.  Use ./ to list
 a filename beginning with #.
@@ -320,8 +320,8 @@ Hot regular files are scheduled in list order before cold files while keeping
 compression enabled.  Unlisted files retain their relative traversal order.
 Hardlink aliases share the earliest matching rank.
 Symlinks, including intermediate ones, are resolved within the image root
-and are prioritized together with their targets; for tar sources, matching
-uses the final imported tree.
+and are prioritized together with their targets; for tar and OCI sources,
+matching uses the final imported tree.
 Parent directories are also prioritized.  Entries ending in \fI/\fR prioritize
 the directory without recursively marking its children hot.
 Hot files are never packed into fragments, since that would move their
diff --git a/mkfs/main.c b/mkfs/main.c
index 8ebd3a0..3cfd555 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -215,7 +215,7 @@ static void usage(int argc, char **argv)
 		" --gid-offset=#         add offset # to all file gids (# = id offset)\n"
 		" --hard-dereference     dereference hardlinks, add links as separate inodes\n"
 		" --hot-file-list=X      specify newline-separated hot file paths for\n"
-		"                        local directory or tar full sources\n"
+		"                        local directory, tar full, or OCI full sources\n"
 		" --ignore-mtime         use build time instead of strict per-file modification time\n"
 		" --max-extent-bytes=#   set maximum decompressed extent size # in bytes\n"
 		" --mount-point=X        X=prefix of target fs path (default: /)\n"
@@ -341,6 +341,10 @@ static bool mkfs_hotfile_supported_source(void)
 		return !erofstar.index_mode &&
 		       dataimport_mode != EROFS_MKFS_DATA_IMPORT_RVSP &&
 		       dataimport_mode != EROFS_MKFS_DATA_IMPORT_ZEROFILL;
+	case EROFS_MKFS_SOURCE_OCI:
+		return !mkfs_oci_tarindex_mode &&
+		       dataimport_mode != EROFS_MKFS_DATA_IMPORT_RVSP &&
+		       dataimport_mode != EROFS_MKFS_DATA_IMPORT_ZEROFILL;
 	default:
 		return false;
 	}
@@ -1588,7 +1592,7 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 		return -EINVAL;
 	}
 	if (hotfile_list_path && !mkfs_hotfile_supported_source()) {
-		erofs_err("--hot-file-list is only supported for local directories and tar full mode");
+		erofs_err("--hot-file-list is only supported for local directories, tar full mode, and OCI full mode");
 		return -EOPNOTSUPP;
 	}
 
@@ -2086,7 +2090,9 @@ int main(int argc, char **argv)
 	if (err < 0)
 		goto exit;
 
-	if (hotfile_list_path && source_mode == EROFS_MKFS_SOURCE_TAR) {
+	if (hotfile_list_path &&
+	    (source_mode == EROFS_MKFS_SOURCE_TAR ||
+	     source_mode == EROFS_MKFS_SOURCE_OCI)) {
 		err = erofs_hotfile_prepare_tree(root);
 		if (err)
 			goto exit;
-- 
2.50.1 (Apple Git-155)


