Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CC7606A336
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 07:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=aRQBx1uJ
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jNzL16FkSz2yCr;
	Tue, 10 Nov 2026 18:48:41 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=160.236.53.111
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794296921;
	cv=none; b=KPtRjbKgldoZwVXD9jt+t1XuIXubhZ4NozkAPTpXMGXvrsyfvFZ7WKMFMTAr1Fl2rqmPQGPNYclzk9vik/vvI8oYXIsw3+xD7X38DkiKOtnv5vrK0D1muz90eWWIcqExjHS/YfVUqya2unwhGJSx2Br3Vd6IrVoLE+TDnXzl6L7owNHXBpI//vseWQdPxzGf3MXCkoXK9vWhZgQoUhCqA6TP59BnKHcDusa7ul+K6elHHOhZVXQj1AsaiRPuJJUFZlfNDottukYprGEJDsxa+vhj+XXALvneDUSqZyrQRNxmza0LQJTDFFOiPG+lgjV1HbasLm+yvDvxmj/pjFwatg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794296921; c=relaxed/relaxed;
	bh=QPl6OZN1H8Yv0JwTE7uDuANMnXcSbOTDVw3hbhdwXnw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQNC+H6z4CeZ8CcGxe8FKT94B3ii0mv0x/C5ANrAFdzT30MyVXCZBiZS8ih8Q054+panaOMZF41bPIcCLkMiTq6vEb0CboCT0J2+jExrnQKuVpaIk/SSJFzFAyfyAHSWANFJPQZfRo/d46ABbAaKWB1asnZ2UG/iRVRi+LbahZm8CgABx/Fm7SdZDjgFeYvQ1CUUHM0XtVMROl/xntgDWjBE2bWbsfXsJTr81QxhfasJHdxfRxpqb5iwW9iyhZraR9lX1DzuvYySWx/nTxuFd+WJnE7Fnf3lS8cNGetUzKpX+N7MFjhl6WIU8/4Mipsy5iYByDhHbIVRwvGEL8nTFQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com; dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=aRQBx1uJ; dkim-atps=neutral; spf=pass (client-ip=160.236.53.111; helo=mail-m16023653111.xmail.ntesmail.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org) smtp.mailfrom=deepseek.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=aRQBx1uJ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=deepseek.com (client-ip=160.236.53.111; helo=mail-m16023653111.xmail.ntesmail.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org)
Received: from mail-m16023653111.xmail.ntesmail.com (mail-m16023653111.xmail.ntesmail.com [160.236.53.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jNzKx0QRFz2yD8
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Nov 2026 18:48:35 +1100 (AEDT)
Received: from localhost.localdomain (unknown [124.243.154.138])
	by smtp.qiye.163.com (Hmail) with ESMTP id 5421a05a1;
	Tue, 10 Nov 2026 15:48:30 +0800 (GMT+08:00)
From: Wenyuan Xu <sereno.xu@deepseek.com>
To: xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH v2 3/3] erofs-utils: tests: cover duplicate overlay xattrs
Date: Tue, 10 Nov 2026 07:48:22 +0000
Message-ID: <20261110074822.292859-3-sereno.xu@deepseek.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261110074822.292859-1-sereno.xu@deepseek.com>
References: <20261110074822.292859-1-sereno.xu@deepseek.com>
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
X-HM-Tid: 0aa1c46e143803a3kunmfb1181274ba07d
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCQx9LVhkZS0seT0sfSkhMS1YVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKSU9VSU9IVUpOT1VKSENZV1kWGg8SFR0UWUFZT0tIVU
	pLSUJDQ0xVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=aRQBx1uJXKMdxXKE17YS+mk806NaenyvbdGoOnOH1NoJwL0ifeKhx21Dtr5Ce6KGBRoxv3nYvliHPZ8AkJQ2El8Vz2hIb8wbGNDtJvOMVF23wddTzWfcNZ0Wqrb/laQAly2pwhVBGHCs6HnXnsyBNGwthOFopAN60VwZUR+QNDg=; s=default; c=relaxed/relaxed; d=deepseek.com; v=1;
	bh=QPl6OZN1H8Yv0JwTE7uDuANMnXcSbOTDVw3hbhdwXnw=;
	h=date:mime-version:subject:message-id:from;
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add erofs/033 to check origin and opaque attributes across local, image
and TAR imports. Verify that existing origin values survive without
duplicate names and that repeated opaque markers remain unique.

Cover local roots, directories without whiteouts and regular files with
absent, empty and nonempty origin attributes in inline and shared xattr
layouts. Exercise PAX attributes and AUFS opaque markers in both orders,
rebuilds, incremental builds and overlay metadata stripping.

Assisted-by: LLM
Signed-off-by: Wenyuan Xu <sereno.xu@deepseek.com>
---
 tests/Makefile.am   |   3 +
 tests/erofs/033     | 289 ++++++++++++++++++++++++++++++++++++++++++++
 tests/erofs/033.out |   2 +
 3 files changed, 294 insertions(+)
 create mode 100755 tests/erofs/033
 create mode 100644 tests/erofs/033.out

diff --git a/tests/Makefile.am b/tests/Makefile.am
index 363b93d..f64ca83 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -135,6 +135,9 @@ TESTS += erofs/031
 # 032 - check that the xattr layout does not depend on listxattr(2) order
 TESTS += erofs/032
 
+# 033 - preserve overlay xattrs without adding duplicate names
+TESTS += erofs/033
+
 # NEW TEST CASE HERE
 # TESTS += erofs/999
 
diff --git a/tests/erofs/033 b/tests/erofs/033
new file mode 100755
index 0000000..1d89142
--- /dev/null
+++ b/tests/erofs/033
@@ -0,0 +1,289 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0+
+#
+# Preserve existing overlay xattrs without duplicate names.
+# Cover local, image and PAX imports, including repeated opaque markers.
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
+command -v python3 >/dev/null 2>&1 || _notrun "python3 isn't installed"
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
+check_origin_xattr()
+{
+	getfattr --absolute-names -d -m '^trusted\.overlay\.origin$' \
+		"$SCRATCH_MNT/$1" > "$localdir/attrs" 2>> $seqres.full ||
+		_fail "cannot read $case_name/$1 xattrs"
+	cat "$localdir/attrs" >> $seqres.full
+	actual=$(sed -n '/^trusted\.overlay\.origin=/p' "$localdir/attrs")
+	[ "$actual" = "$2" ] || _fail "unexpected origin in $case_name/$1"
+}
+
+check_origin()
+{
+	check_origin_xattr "$1" "$2"
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
+# Local imports must retain origin on roots, plain directories and files,
+# even without any whiteouts. Check both inline and shared xattr layouts.
+for state in absent empty value; do
+	tree=$localdir/plain-$state
+	mkdir -p "$tree/dir" || _fail "mkdir failed"
+	echo payload > "$tree/file"
+	case $state in
+	absent) expected= ;;
+	empty) expected='trusted.overlay.origin=""'; value= ;;
+	value) expected='trusted.overlay.origin="xxx"'; value=xxx ;;
+	esac
+	if [ "$state" != absent ]; then
+		for entry in . dir file; do
+			setfattr -n trusted.overlay.origin -v "$value" "$tree/$entry" \
+				>> $seqres.full 2>&1 || _fail "cannot set local origin"
+		done
+	fi
+	for tolerance in 4 0; do
+		case_name=localdir-plain-$state-x$tolerance
+		SCRATCH_DEV=$localdir/$case_name.erofs
+		build_image -x"$tolerance" "$SCRATCH_DEV" "$tree"
+		_scratch_mount >> $seqres.full 2>&1
+		for entry in . dir file; do
+			check_origin_xattr "$entry" "$expected"
+		done
+		[ "$(cat "$SCRATCH_MNT/file")" = payload ] ||
+			_fail "file content lost in $case_name"
+		_scratch_unmount >> $seqres.full 2>&1 || _fail "unmount failed"
+	done
+done
+
+case_name=localdir
+SCRATCH_DEV=$localdir/source.erofs
+build_image "$SCRATCH_DEV" "$localdir/source"
+_scratch_mount >> $seqres.full 2>&1
+check_origin absent 'trusted.overlay.origin=""'
+check_origin empty 'trusted.overlay.origin=""'
+check_origin value 'trusted.overlay.origin="xxx"'
+_scratch_unmount >> $seqres.full 2>&1 || _fail "unmount failed"
+
+case_name=single-source
+SCRATCH_DEV=$localdir/single.erofs
+build_image --clean=data "$SCRATCH_DEV" "$localdir/source.erofs"
+_scratch_mount >> $seqres.full 2>&1
+check_origin absent 'trusted.overlay.origin=""'
+check_origin empty 'trusted.overlay.origin=""'
+check_origin value 'trusted.overlay.origin="xxx"'
+_scratch_unmount >> $seqres.full 2>&1 || _fail "unmount failed"
+
+# PAX attributes bypass the local-directory xattr scanner.
+python3 - "$localdir/source.tar" <<'PYTAR' || _fail "cannot create PAX tar"
+import sys
+import tarfile
+
+with tarfile.open(sys.argv[1], "w", format=tarfile.PAX_FORMAT) as archive:
+    for state, value in (("absent", None), ("empty", ""), ("value", "xxx")):
+        entry = tarfile.TarInfo(state)
+        entry.type = tarfile.DIRTYPE
+        entry.mode = 0o755
+        if value is not None:
+            entry.pax_headers["SCHILY.xattr.trusted.overlay.origin"] = value
+        archive.addfile(entry)
+        entry = tarfile.TarInfo(state + "/.wh.whiteout")
+        archive.addfile(entry)
+PYTAR
+case_name=tar
+SCRATCH_DEV=$localdir/tar.erofs
+build_image --tar --aufs "$SCRATCH_DEV" "$localdir/source.tar"
+_scratch_mount >> $seqres.full 2>&1
+check_origin absent 'trusted.overlay.origin=""'
+check_origin empty 'trusted.overlay.origin=""'
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
+# Exercise opaque PAX attributes and AUFS markers in both input orders.
+python3 - "$localdir/opaque.tar" <<'PYTAR' || _fail "cannot create opaque tar"
+import io
+import sys
+import tarfile
+
+with tarfile.open(sys.argv[1], "w", format=tarfile.PAX_FORMAT) as archive:
+    def directory(name, pax=False):
+        entry = tarfile.TarInfo(name)
+        entry.type = tarfile.DIRTYPE
+        entry.mode = 0o755
+        if pax:
+            entry.pax_headers["SCHILY.xattr.trusted.overlay.opaque"] = "y"
+        archive.addfile(entry)
+
+    def marker(name):
+        archive.addfile(tarfile.TarInfo(name + "/.wh..wh..opq"))
+
+    directory("pax-first", True)
+    marker("pax-first")
+    directory("marker-first")
+    marker("marker-first")
+    directory("marker-first", True)
+    directory("repeated")
+    marker("repeated")
+    marker("repeated")
+    directory("pax-only", True)
+    for name in ("pax-first", "marker-first", "repeated", "pax-only"):
+        entry = tarfile.TarInfo(name + "/top")
+        entry.size = 3
+        archive.addfile(entry, io.BytesIO(b"top"))
+PYTAR
+
+check_opaque()
+{
+	getfattr --absolute-names -d -m '^trusted\.overlay\.opaque$' \
+		"$SCRATCH_MNT/$1" > "$localdir/attrs" 2>> $seqres.full ||
+		_fail "cannot read opaque xattrs in $case_name/$1"
+	cat "$localdir/attrs" >> $seqres.full
+	actual=$(sed -n '/^trusted\.overlay\.opaque=/p' "$localdir/attrs")
+	[ "$actual" = "$2" ] || _fail "unexpected opaque in $case_name/$1"
+}
+
+for state in pax-first marker-first repeated pax-only; do
+	mkdir -p "$localdir/opaque-base/$state" || _fail "mkdir failed"
+	echo lower > "$localdir/opaque-base/$state/lower"
+done
+case_name=opaque-base
+build_image "$localdir/opaque-base.erofs" "$localdir/opaque-base"
+
+for case_name in opaque-tar opaque-rebuild opaque-incremental opaque-strip; do
+	SCRATCH_DEV=$localdir/$case_name.erofs
+	case $case_name in
+	opaque-tar)
+		build_image --tar --aufs "$SCRATCH_DEV" "$localdir/opaque.tar"
+		;;
+	opaque-rebuild)
+		build_image --clean=data "$SCRATCH_DEV" "$localdir/opaque-tar.erofs"
+		;;
+	opaque-incremental)
+		cp "$localdir/opaque-base.erofs" "$SCRATCH_DEV" || _fail "copy failed"
+		build_image --incremental=data --tar --aufs \
+			"$SCRATCH_DEV" "$localdir/opaque.tar"
+		;;
+	opaque-strip)
+		build_image --tar --aufs --ovlfs-strip \
+			"$SCRATCH_DEV" "$localdir/opaque.tar"
+		;;
+	esac
+	_scratch_mount >> $seqres.full 2>&1
+	for state in pax-first marker-first repeated pax-only; do
+		if [ "$case_name" = opaque-strip ]; then
+			check_opaque "$state" ''
+		else
+			check_opaque "$state" 'trusted.overlay.opaque="y"'
+		fi
+		[ "$(cat "$SCRATCH_MNT/$state/top")" = top ] ||
+			_fail "top file lost in $case_name/$state"
+		[ ! -e "$SCRATCH_MNT/$state/lower" ] ||
+			_fail "opaque directory inherited lower file in $case_name/$state"
+	done
+	_scratch_unmount >> $seqres.full 2>&1 || _fail "unmount failed"
+done
+
+# The local scanner bypasses erofs_setxattr(), so check its state too.
+mkdir -p "$localdir/opaque-local/dir" || _fail "mkdir failed"
+setfattr -n trusted.overlay.opaque -v y "$localdir/opaque-local/dir" \
+	>> $seqres.full 2>&1 || _fail "cannot set local opaque"
+for case_name in opaque-local opaque-local-strip; do
+	SCRATCH_DEV=$localdir/$case_name.erofs
+	if [ "$case_name" = opaque-local-strip ]; then
+		build_image --ovlfs-strip "$SCRATCH_DEV" "$localdir/opaque-local"
+	else
+		build_image "$SCRATCH_DEV" "$localdir/opaque-local"
+	fi
+	_scratch_mount >> $seqres.full 2>&1
+	if [ "$case_name" = opaque-local-strip ]; then
+		check_opaque dir ''
+	else
+		check_opaque dir 'trusted.overlay.opaque="y"'
+	fi
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


