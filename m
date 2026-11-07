Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37494606A32D
	for <linux-erofs@archiver.kernel.org>; Sat,  7 Nov 2026 04:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=cGrDzlGu
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jM36v4cfWz2y7r;
	Sat, 07 Nov 2026 15:32:23 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=103.209.128.105
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794025943;
	cv=none; b=LVA1wTLsjVKQTTEg4gC/KisB1TPn8nawA55RDaR0m3orYa3QYETX1U8tIl34VAnmKisxEim7pKN2LMKxjCratLdLVOaA/sW3eFYR6Rwb3uWvzVHpHjqh+YUdyjFJwWr75PyBxSl826k9kJtUCiCtWRE8+5dpsLbnxQzIM4YY780qHzXPGebUIBd8A3/AhD3aQpSBjpNlhaS8CGCQmfHs4tpSg+F1+wqZLe8F+yKFbjUdpGumE2k/N8TR+Xej8S/ne3egDqYCMEc8FGakRfLNRU7Rxy3RNHMU1fCHAAW8hEmwIO9LWmNneBszxMUH5/iWGnEwpi81roTXFVtkU4MvXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794025943; c=relaxed/relaxed;
	bh=4y3cczytY6lQyn0N1+AiEQO/3JtkQZInu6aENLxVlYE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3uE28IQ1upSO6V1PWlg73gT8ZEUD52fLo0UJLUBOXXLrtpywL2J5jOz7JiTZFTutkxMFpz+0o62QKt7tS3lUh4dY2zHszDLSfw9RmzyDwMqs5rITilwpHsOFBqF8/3HJgCq0W/vP5tWBfrDyur2Ht/JI3X2ry32bzuXE8PqLvidJTq8FnpHZ6bqa2v5OIldWSpmeStmYwZBLYYpKXJtTWfQstaAbCJytxendZj6fLxOqvBgJty96LTfwPD+B1XdHyXd6CQ9Jzq0za1ewGHMFTT4XYT3XB7mAC87BHpgfJzF3Vjw4ETgiLoXoGZfFsV5DQZFaXKkIWsYX/1Gic9Zgg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com; dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=cGrDzlGu; dkim-atps=neutral; spf=pass (client-ip=103.209.128.105; helo=mail-m128105.netease.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org) smtp.mailfrom=deepseek.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=cGrDzlGu;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=deepseek.com (client-ip=103.209.128.105; helo=mail-m128105.netease.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 304 seconds by postgrey-1.37 at boromir; Sat, 07 Nov 2026 15:32:19 AEDT
Received: from mail-m128105.netease.com (mail-m128105.netease.com [103.209.128.105])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jM36q3dkzz2xS6
	for <linux-erofs@lists.ozlabs.org>; Sat, 07 Nov 2026 15:32:18 +1100 (AEDT)
Received: from localhost.localdomain (unknown [124.243.154.168])
	by smtp.qiye.163.com (Hmail) with ESMTP id 53d4b1d08;
	Sat, 7 Nov 2026 12:27:08 +0800 (GMT+08:00)
From: Wenyuan Xu <sereno.xu@deepseek.com>
To: xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH 2/2] erofs-utils: mkfs: fix origin xattrs when merging layers
Date: Sat,  7 Nov 2026 04:27:03 +0000
Message-ID: <20261107042703.3392000-2-sereno.xu@deepseek.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261107042703.3392000-1-sereno.xu@deepseek.com>
References: <20261107042703.3392000-1-sereno.xu@deepseek.com>
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
X-HM-Tid: 0aa1b442a2a403a3kunm1b25b6102ae89a
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaTh8YVh9DTkhIHUxNThoYTFYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKSU9VSU9IVUpOT1VKTUNZV1kWGg8SFR0UWUFZT0tIVU
	pLSUJDQ0xVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=cGrDzlGupRnh7Gn5pFquzOY/ujjlQle0b5aNe3WbkN+pIJDmbtKE9fc3ZFSgWiN7htaYFkg+er1pkROL/yTEcOKy484iqN1WhooRWU1aRvbJW4Unl1AEl2FD+A0uuanzpCc/oQ6HifcsRrKCUqeNvcsGz571oODJRBOdJICh6G0=; s=default; c=relaxed/relaxed; d=deepseek.com; v=1;
	bh=4y3cczytY6lQyn0N1+AiEQO/3JtkQZInu6aENLxVlYE=;
	h=date:mime-version:subject:message-id:from;
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Only supplement empty trusted.overlay.origin xattrs on whiteout parents
during incremental builds or multi-source rebuilds. Ordinary local
directory builds and single-source rebuilds should not synthesize this
merge marker.

Preserve any existing origin xattr instead of appending a duplicate
empty entry.

Fixes: 8680f3cf94ef ("erofs-utils: mkfs: enable incremental builds for local files")
Assisted-by: LLM
Signed-off-by: Wenyuan Xu <sereno.xu@deepseek.com>
---
 include/erofs/importer.h |   1 +
 lib/inode.c              |   2 +-
 lib/xattr.c              |   2 +
 mkfs/main.c              |   2 +
 tests/Makefile.am        |   3 +
 tests/erofs/033          | 122 +++++++++++++++++++++++++++++++++++++++
 tests/erofs/033.out      |   2 +
 7 files changed, 133 insertions(+), 1 deletion(-)
 create mode 100755 tests/erofs/033
 create mode 100644 tests/erofs/033.out

diff --git a/include/erofs/importer.h b/include/erofs/importer.h
index 5141965..b8dcaf8 100644
--- a/include/erofs/importer.h
+++ b/include/erofs/importer.h
@@ -54,6 +54,7 @@ struct erofs_importer_params {
 	bool dirdata_in_metazone;
 	bool hard_dereference;
 	bool ovlfs_strip;
+	bool ovlfs_merge;		/* build involves overlayfs-style merging */
 	bool dot_omitted;
 	bool no_xattrs;			/* don't store extended attributes */
 	bool no_zcompact;
diff --git a/lib/inode.c b/lib/inode.c
index da29b5a..185bcfc 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -2134,7 +2134,7 @@ static int erofs_mkfs_handle_inode(const struct erofs_mkfs_btctx *ctx,
 	/* strip all unnecessary overlayfs xattrs when ovlfs_strip is enabled */
 	if (params->ovlfs_strip)
 		erofs_clear_opaque_xattr(inode);
-	else if (inode->whiteouts)
+	else if (params->ovlfs_merge && inode->whiteouts)
 		erofs_set_origin_xattr(inode);
 
 	if (!S_ISDIR(inode->i_mode)) {
diff --git a/lib/xattr.c b/lib/xattr.c
index a0ac76f..01a8547 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -619,6 +619,8 @@ bool erofs_get_opaque_from_disk(struct erofs_inode *inode)
 
 int erofs_set_origin_xattr(struct erofs_inode *inode)
 {
+	if (erofs_inode_has_xattr(inode, OVL_XATTR_ORIGIN))
+		return 0;
 	return erofs_vfs_setxattr(inode, OVL_XATTR_ORIGIN, NULL, 0);
 }
 
diff --git a/mkfs/main.c b/mkfs/main.c
index 93123c1..06d868a 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1899,6 +1899,8 @@ int main(int argc, char **argv)
 	importer_params.source = cfg.c_src_path;
 	importer_params.no_datainline = mkfs_no_datainline;
 	importer_params.dot_omitted = mkfs_dot_omitted;
+	importer_params.ovlfs_merge = incremental_mode ||
+		(source_mode == EROFS_MKFS_SOURCE_REBUILD && rebuild_src_count > 1);
 	if (importer_params.dedupe == EROFS_DEDUPE_FORCE_ON &&
 	    !mkfscfg.chunkbits && !mkfscfg.total_zcfgs) {
 		erofs_err("Compression is not enabled.  Turn on chunk-based data deduplication instead.");
diff --git a/tests/Makefile.am b/tests/Makefile.am
index 363b93d..bfd1fc2 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -135,6 +135,9 @@ TESTS += erofs/031
 # 032 - check that the xattr layout does not depend on listxattr(2) order
 TESTS += erofs/032
 
+# 033 - preserve existing origin and only add empty origin when merging
+TESTS += erofs/033
+
 # NEW TEST CASE HERE
 # TESTS += erofs/999
 
diff --git a/tests/erofs/033 b/tests/erofs/033
new file mode 100755
index 0000000..1da7bca
--- /dev/null
+++ b/tests/erofs/033
@@ -0,0 +1,122 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0+
+#
+# Only supplement missing origin xattrs on whiteout parents when merging.
+# Existing origin values must survive without duplicate xattr names.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$(echo $0 | awk '{print $((NF-1))"/"$NF}' FS="/")
+
+. "${srcdir}/common/rc"
+
+cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+_require_root
+_require_erofs
+_require_xattr
+command -v getfattr >/dev/null 2>&1 || _notrun "getfattr isn't installed"
+
+rm -f $seqres.full
+
+localdir=$tmp/$seq
+mkdir -p "$localdir/source" "$localdir/base" || _fail "mkdir failed"
+
+# Probe capabilities as root alone does not guarantee CAP_MKNOD/SYS_ADMIN.
+mknod "$localdir/probe" c 0 0 >> $seqres.full 2>&1 ||
+	_notrun "cannot create whiteouts"
+setfattr -n trusted.overlay.origin -v xxx "$localdir/source" \
+	>> $seqres.full 2>&1 || _notrun "cannot set trusted xattrs"
+getfattr -n trusted.overlay.origin --only-values "$localdir/source" \
+	> "$localdir/probe-value" 2>> $seqres.full ||
+	_notrun "cannot read trusted xattrs"
+[ "$(cat "$localdir/probe-value")" = xxx ] ||
+	_notrun "trusted xattrs are not visible"
+setfattr -x trusted.overlay.origin "$localdir/source" \
+	>> $seqres.full 2>&1 || _fail "cannot remove probe xattr"
+
+echo "QA output created by $seq"
+
+for state in absent empty value; do
+	mkdir "$localdir/source/$state" || _fail "mkdir failed"
+	mknod "$localdir/source/$state/whiteout" c 0 0 \
+		>> $seqres.full 2>&1 || _fail "cannot create whiteout"
+done
+setfattr -n trusted.overlay.origin -v '' "$localdir/source/empty" \
+	>> $seqres.full 2>&1 || _fail "cannot set empty origin"
+setfattr -n trusted.overlay.origin -v xxx "$localdir/source/value" \
+	>> $seqres.full 2>&1 || _fail "cannot set nonempty origin"
+echo base > "$localdir/base/file"
+
+# Dumping all matching names also catches duplicate names: getxattr alone
+# would retrieve the same first value for each occurrence of the name.
+check_origin()
+{
+	getfattr --absolute-names -d -m '^trusted\.overlay\.origin$' \
+		"$SCRATCH_MNT/$1" > "$localdir/attrs" 2>> $seqres.full ||
+		_fail "cannot read $case_name/$1 xattrs"
+	cat "$localdir/attrs" >> $seqres.full
+	actual=$(sed -n '/^trusted\.overlay\.origin=/p' "$localdir/attrs")
+	[ "$actual" = "$2" ] || _fail "unexpected origin in $case_name/$1"
+	[ -c "$SCRATCH_MNT/$1/whiteout" ] ||
+		_fail "whiteout lost in $case_name/$1"
+}
+
+build_image()
+{
+	$MKFS_EROFS_PROG "$@" >> $seqres.full 2>&1 ||
+		_fail "mkfs failed for $case_name"
+}
+
+case_name=localdir
+SCRATCH_DEV=$localdir/source.erofs
+build_image "$SCRATCH_DEV" "$localdir/source"
+_scratch_mount >> $seqres.full 2>&1
+check_origin absent ''
+check_origin empty 'trusted.overlay.origin=""'
+check_origin value 'trusted.overlay.origin="xxx"'
+_scratch_unmount >> $seqres.full 2>&1 || _fail "unmount failed"
+
+case_name=single-source
+SCRATCH_DEV=$localdir/single.erofs
+build_image --clean=data "$SCRATCH_DEV" "$localdir/source.erofs"
+_scratch_mount >> $seqres.full 2>&1
+check_origin absent ''
+check_origin value 'trusted.overlay.origin="xxx"'
+_scratch_unmount >> $seqres.full 2>&1 || _fail "unmount failed"
+
+case_name=base
+build_image "$localdir/base.erofs" "$localdir/base"
+
+for case_name in multi-source incremental-localdir incremental-rebuild; do
+	SCRATCH_DEV=$localdir/$case_name.erofs
+	case $case_name in
+	multi-source)
+		build_image --clean=data "$SCRATCH_DEV" \
+			"$localdir/base.erofs" "$localdir/source.erofs"
+		;;
+	incremental-*)
+		cp "$localdir/base.erofs" "$SCRATCH_DEV" || _fail "copy failed"
+		if [ "$case_name" = incremental-localdir ]; then
+			source=$localdir/source
+		else
+			source=$localdir/source.erofs
+		fi
+		build_image --incremental=data "$SCRATCH_DEV" "$source"
+		;;
+	esac
+	_scratch_mount >> $seqres.full 2>&1
+	check_origin absent 'trusted.overlay.origin=""'
+	check_origin empty 'trusted.overlay.origin=""'
+	check_origin value 'trusted.overlay.origin="xxx"'
+	[ "$(cat "$SCRATCH_MNT/file")" = base ] ||
+		_fail "base file lost in $case_name"
+	_scratch_unmount >> $seqres.full 2>&1 || _fail "unmount failed"
+done
+
+echo Silence is golden
+status=0
+exit 0
diff --git a/tests/erofs/033.out b/tests/erofs/033.out
new file mode 100644
index 0000000..c5d2914
--- /dev/null
+++ b/tests/erofs/033.out
@@ -0,0 +1,2 @@
+QA output created by 033
+Silence is golden
-- 
2.43.0


