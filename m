Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BFB606A31B
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Nov 2026 04:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=dgChi7iD
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jKBqk5RvXz2xGr;
	Wed, 04 Nov 2026 15:12:50 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=156.224.82.216
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793765570;
	cv=none; b=VWfPXS3ZEypJoFto0Qmg7VuDIEv3eX9f3JE0A03189a3U4GkR3Pw/a9T974ZbCtcY73NZi5+A4B8eRurw2LPBIl4gIOA1Ag0pCC8QWBVYWDEacsCGlDpbzz5staOTtgQnOyWL3uESeNS3S9CRKGVhFA/aT/99xMRPQvzBB0Fsez8KM94lgm1/TCQu321/nGTm07YcHcXZkFg86SARWKCemQCTHjQj/F5MXlCDBrQfFytRccauHC/zI2DQZ62gGJ3SsEQqxO2TkaA00Yq0y/Oq7EGRBK817ziS4Zhl9bkgJMjIogfMRl/xS+KDdyFVHW2sB79ogzNRDmaAC+sCoA8Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793765570; c=relaxed/relaxed;
	bh=CTxGSW1oI0uzLDztoTFqBU+l526C9kiiXkibcjaw/PI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZ6UAVFJIz+AkMax5TaqXRnDfiXiOSaZRu8ng7Y1OISFN5X1p8G9/yJl4amnBT/UCwqj2POGOeF3imBf3u0XI5UV97/Sbn+GRLrJFEh52F9fOiClEI6BHb3FRVfrSH+NkVpFNwzOUZEQoyN2P/om98MceekF6QDQ6bRA5HdDSVytSkr3JV7etXwhu0a7JzDlJu5uJsW9HnRyiN7IP5Z8FEhGEID9zXhLyJj/T1gf0LH/zuhpbw+uJbrhog3gVBfY5P1HvzQo+fAn7LoudjUNzPEgAQkZLuPelazhHB6LnuVpbtWo6bVdSOZwP9SzjyTi9xTn4It7EOWRy4kinBdbfQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com; dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=dgChi7iD; dkim-atps=neutral; spf=pass (client-ip=156.224.82.216; helo=mail-m82216.xmail.ntesmail.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org) smtp.mailfrom=deepseek.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=dgChi7iD;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=deepseek.com (client-ip=156.224.82.216; helo=mail-m82216.xmail.ntesmail.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 302 seconds by postgrey-1.37 at boromir; Wed, 04 Nov 2026 15:12:47 AEDT
Received: from mail-m82216.xmail.ntesmail.com (mail-m82216.xmail.ntesmail.com [156.224.82.216])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jKBqg6Yzzz2yDc
	for <linux-erofs@lists.ozlabs.org>; Wed, 04 Nov 2026 15:12:47 +1100 (AEDT)
Received: from localhost.localdomain (unknown [124.243.154.173])
	by smtp.qiye.163.com (Hmail) with ESMTP id 536bdc6fc;
	Wed, 4 Nov 2026 12:07:41 +0800 (GMT+08:00)
From: Wenyuan Xu <sereno.xu@deepseek.com>
To: xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
Cc: sereno.xu@deepseek.com
Subject: [RFC 7/7] erofs-utils: tests: cover manifest input
Date: Wed,  4 Nov 2026 04:07:25 +0000
Message-ID: <20261104040725.2473313-8-sereno.xu@deepseek.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104040725.2473313-1-sereno.xu@deepseek.com>
References: <20261104040725.2473313-1-sereno.xu@deepseek.com>
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
X-HM-Tid: 0aa1a4bdbfd003a3kunma3fc75f17e0ab
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCHhoaVkgaSUJOQhhMHkkaTVYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKSU9VSU9IVUpOT1VKTEhZV1kWGg8SFR0UWUFZT0tIVU
	pLSUJDQ0xVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=dgChi7iDrlosB0DvNVHHkKke0NluNaDYvfqyFPBvkkd4S6ogQ2b2txH1eeheP5z8p6OW+AaEijWnF039HMeuJZHQqBTr4FPE+YnoajmdeUPC+cxxihP/kuKC11TGG07iWmeH3uGnPmh7+KSNLMjb5ej+Yq+yjCfWZmDVigrCZe4=; s=default; c=relaxed/relaxed; d=deepseek.com; v=1;
	bh=CTxGSW1oI0uzLDztoTFqBU+l526C9kiiXkibcjaw/PI=;
	h=date:mime-version:subject:message-id:from;
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add test 033 for complete and two-field records, metadata, path
validation, hard links, symbolic links and whiteouts.

Check binary xattrs, name prefixes, shared storage and local import
options using the existing dump and fsck tools.

Assisted-by: LLM
Signed-off-by: Wenyuan Xu <sereno.xu@deepseek.com>
---
 tests/Makefile.am   |   3 +
 tests/erofs/033     | 637 ++++++++++++++++++++++++++++++++++++++++++++
 tests/erofs/033.out |   2 +
 3 files changed, 642 insertions(+)
 create mode 100755 tests/erofs/033
 create mode 100644 tests/erofs/033.out

diff --git a/tests/Makefile.am b/tests/Makefile.am
index 363b93d..5bb96ed 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -135,6 +135,9 @@ TESTS += erofs/031
 # 032 - check that the xattr layout does not depend on listxattr(2) order
 TESTS += erofs/032
 
+# 033 - manifest rebuild input and validation
+TESTS += erofs/033
+
 # NEW TEST CASE HERE
 # TESTS += erofs/999
 
diff --git a/tests/erofs/033 b/tests/erofs/033
new file mode 100755
index 0000000..5f427bd
--- /dev/null
+++ b/tests/erofs/033
@@ -0,0 +1,637 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0+
+# Manifest rebuild: metadata, binary escapes, hardlinks and rejected inputs.
+seq=`basename "$0"`
+seqres=$RESULT_DIR/$(echo "$0" | awk '{print $((NF-1))"/"$NF}' FS="/")
+. "${srcdir}/common/rc"
+cleanup() { :; }
+_require_xattr
+command -v getfattr >/dev/null 2>&1 || _notrun "getfattr isn't installed"
+export TZ=UTC
+export LC_ALL=C
+echo "QA output created by $seq"
+
+base=$tmp/base
+manifest=$tmp/manifest
+image=$tmp/image
+mkdir -p "$base/sub"
+printf abc > "$base/data =file"
+printf hidden > "$base/sub/unlisted"
+printf outside > "$tmp/outside"
+dd if=/dev/zero of="$base/large" bs=4096 count=20 >> "$seqres.full" 2>&1
+: > "$base/empty"
+if command -v setfattr >/dev/null 2>&1; then
+	setfattr -n user.host -v hidden "$base/data =file" 2>/dev/null || :
+fi
+cat > "$manifest" <<'MANIFEST'
+ / - - 040755 123 456 - 1.1 user.root=root
+//dir/// - - 0040750 123 456 - 2.999999999
+/sub - - 40755 123 456 - 4.0
+///dir//file/// /data\x20=file 3 00100644 123 456 - 1.1 user.text=new user.bin=\x00\xff\x3d\x5c\x20\x0a user.empty= user.a\x3db=v\x3d1
+/hard/// //dir///file/// - @unparsed - - - - -
+/chain /hard/ - @ - - - -
+/symlink/// ../dir//file 12 120777 123 456 - 3.000000007
+/char - - 20600 123 456 259 4.0
+/block - - 60600 123 456 2048 4.0
+/fifo - - 10600 123 456 0 4.0
+/socket - - 140600 123 456 0 4.0
+/large /large 81920 100600 123 456 - 4.0
+/empty /empty 0 100644 123 456 - 4.0
+/payload-slashes /\x2fsub//../data\x20=file 3 100644 123 456 - 4.0
+/payload-dot /./data\x20=file 3 100644 123 456 - 4.0
+/payload-parent /../outside 7 100644 123 456 - 4.0
+/space\x20\x5c\xff= /data\x20=file 3 100644 123 456 - 4.0
+MANIFEST
+# Accept a final record without a newline and a single directory trailing slash.
+printf '/last/ - - 40755 123 456 - 4.0' >> "$manifest"
+SOURCE_DATE_EPOCH=2000000000 "$MKFS_EROFS_PROG" --manifest="$manifest" \
+	"$image" "$base" >> "$seqres.full" 2>&1 || _fail "manifest build failed"
+"$FSCK_EROFS_PROG" "$image" >> "$seqres.full" 2>&1 || _fail "fsck failed"
+
+dump_inode()
+{
+	"$DUMP_EROFS_PROG" --path="$1" "$image" > "$tmp/dump" || return 1
+	# dump.erofs may report a lookup failure without a nonzero exit status.
+	grep -q '^NID: ' "$tmp/dump" || return 1
+	cat "$tmp/dump"
+}
+expect_stat()
+{
+	dump_inode "$1" > "$tmp/inode" || _fail "lookup $1 failed"
+	path=$1
+	set -- $2
+	mode=$1 uid=$2 gid=$3 timestamp=$4
+	access=$(printf '%04o' "$((0$mode & 0777))")
+	case "$mode" in
+	100*) type='regular file' ;;
+	120*) type='symlink file' ;;
+	40*) type='directory' ;;
+	20*) type='char dev' ;;
+	60*) type='block dev' ;;
+	10*) type='FIFO file' ;;
+	140*) type='SOCK file' ;;
+	esac
+	grep -q "  $type\$" "$tmp/inode" || _fail "unexpected type for $path"
+	grep -q "Uid: $uid   Gid: $gid  Access: $access/" "$tmp/inode" ||
+		_fail "unexpected ownership or permissions for $path"
+	stamp=$(date -u -d "@${timestamp%.*}" '+%Y-%m-%d %H:%M:%S')
+	nsec=$(printf '%09d' "${timestamp#*.}")
+	grep -Fx "Timestamp: $stamp.$nsec" "$tmp/inode" >/dev/null ||
+		_fail "unexpected timestamp for $path"
+	if [ "$#" -eq 6 ]; then
+		grep -q "^Size: $5  " "$tmp/inode" || _fail "unexpected size for $path"
+		grep -q "   Links: $6   " "$tmp/inode" || _fail "unexpected links for $path"
+	fi
+}
+expect_stat / '40755 123 456 1.1'
+expect_stat /dir '40750 123 456 2.999999999'
+# Check the entry containing a space, literal backslash and byte 255.
+escaped_path=$(printf '/space \\%b=' '\377')
+dump_inode "$escaped_path" >> "$seqres.full" || _fail 'escaped path missing'
+expect_stat /dir/file '100644 123 456 1.1 3 3'
+expect_stat /symlink '120777 123 456 3.7 12 1'
+expect_stat /large '100600 123 456 4.0 81920 1'
+expect_stat /empty '100644 123 456 4.0 0 1'
+expect_stat /char '20600 123 456 4.0'
+expect_stat /block '60600 123 456 4.0'
+expect_stat /fifo '10600 123 456 4.0'
+expect_stat /socket '140600 123 456 4.0'
+expect_stat /last '40755 123 456 4.0'
+nid=$(dump_inode /dir/file | sed -n 's/^NID: \([0-9]*\).*/\1/p')
+[ -n "$nid" ] || _fail 'missing inode number'
+for path in /hard /chain; do
+	[ "$(dump_inode "$path" | sed -n 's/^NID: \([0-9]*\).*/\1/p')" = "$nid" ] ||
+		_fail 'hardlink inode differs'
+done
+dump_inode /sub/unlisted >> "$seqres.full" 2>&1 && _fail 'unlisted file imported'
+"$FSCK_EROFS_PROG" --extract="$tmp/extract" --no-preserve-owner --xattrs \
+	"$image" >> "$seqres.full" 2>&1 || _fail 'extraction failed'
+expect_xattr()
+{
+	getfattr --only-values -n "$1" "$tmp/extract/dir/file" > "$tmp/value" \
+		2>> "$seqres.full" || _fail "missing xattr $1"
+	actual=$(od -An -tx1 -v "$tmp/value" | tr -d ' \n')
+	[ "$actual" = "$2" ] || _fail "unexpected value for $1"
+}
+expect_xattr user.text 6e6577
+expect_xattr user.bin 00ff3d5c200a
+expect_xattr 'user.a=b' 763d31
+expect_xattr user.empty ''
+getfattr -n user.host "$tmp/extract/dir/file" >> "$seqres.full" 2>&1 &&
+	_fail 'source xattr imported'
+# Unprivileged extraction may skip device nodes.
+if [ -c "$tmp/extract/char" ]; then
+	[ "$(stat -c '%t:%T' "$tmp/extract/char")" = '1:3' ] || _fail 'char device number'
+fi
+if [ -b "$tmp/extract/block" ]; then
+	[ "$(stat -c '%t:%T' "$tmp/extract/block")" = '8:0' ] || _fail 'block device number'
+fi
+cmp "$base/data =file" "$tmp/extract/dir/file" || _fail 'file contents differ'
+cmp "$base/large" "$tmp/extract/large" || _fail 'large file contents differ'
+for path in payload-slashes payload-dot; do
+	cmp "$base/data =file" "$tmp/extract/$path" || _fail "payload resolution failed: $path"
+done
+cmp "$tmp/outside" "$tmp/extract/payload-parent" || _fail 'parent payload resolution failed'
+[ "$(readlink "$tmp/extract/symlink")" = ../dir//file ] || _fail 'symlink contents differ'
+
+bad_record()
+{
+	printf '/ - - 40755 0 0 - 1.1\n%s\n' "$1" > "$tmp/bad"
+	"$MKFS_EROFS_PROG" --manifest="$tmp/bad" "$tmp/badimage" "$base" \
+		>> "$seqres.full" 2>&1
+	rc=$?
+	[ "$rc" -eq 0 ] && _fail "accepted invalid record: $1"
+	[ "$rc" -ge 128 ] && _fail "crashed on invalid record: $1"
+	grep -F "$tmp/bad:2:" "$seqres.full" >/dev/null || _fail 'missing line diagnostic'
+}
+bad_record '/ - - 40755 0 0 - 1.1'
+bad_record '//// - - 40755 0 0 - 1.1'
+bad_record '/bad//./file /empty 0 100644 0 0 - 1.1'
+bad_record '/missing/file /empty 0 100644 0 0 - 1.1'
+bad_record '/hard /later - @ - - - -'
+bad_record '/hard / - @ - - - -'
+bad_record '/bad /empty 1 100644 0 0 - 1.1'
+bad_record '/bad /large 0 100644 0 0 - 1.1'
+bad_record '/bad /sub 0 100644 0 0 - 1.1'
+bad_record '/bad abc 2 120777 0 0 - 1.1'
+bad_record '/bad//file /empty 0 100644 0 0 - 1.1'
+bad_record '/bad /empty// 0 100644 0 0 - 1.1'
+bad_record '/bad //target - @ - - - -'
+bad_record '/bad\x2f/file /empty 0 100644 0 0 - 1.1'
+bad_record '/bad/../file /empty 0 100644 0 0 - 1.1'
+bad_record '/bad/\x2e/file /empty 0 100644 0 0 - 1.1'
+bad_record '/bad\x00 /empty 0 100644 0 0 - 1.1'
+bad_record '/bad\xGG /empty 0 100644 0 0 - 1.1'
+bad_record '/bad /empty 0 100888 0 0 - 1.1'
+bad_record '/bad /empty 0 100644 4294967296 0 - 1.1'
+bad_record '/bad /empty 18446744073709551616 100644 0 0 - 1.1'
+bad_record '/bad /empty 0 100644 0 0 - 1.1000000000'
+bad_record '/bad /empty 0 100644 0 0 - 1.1 user.key=a=b'
+bad_record '/bad /empty 0 100644 0 0 - 1.1 =value'
+bad_record '/bad /empty 0 100644 0 0 - 1.1 user.dup=old user.dup=new'
+bad_record '/bad /empty 0 100644 0 0 - 1.1 user.dup=same user.dup=same'
+bad_record '/bad /empty 0 100644 0 0 - 1.1 user.dup=old user.\x64up=new'
+bad_record '/bad /empty 0 100644 0 0 - 1.1 user.key=\x0'
+bad_record '/bad /empty 0 100644 0 0 - 1.1 user.key=\x'
+bad_record '/bad abc\x00 4 120777 0 0 - 1.1'
+bad_record '/bad /empty\x00 0 100644 0 0 - 1.1'
+bad_record 'relative /empty 0 100644 0 0 - 1.1'
+bad_record '/bad relative 0 100644 0 0 - 1.1'
+bad_record '/bad /empty 0 100644 0 0 - 1.1 user.key\x00=v'
+bad_record '/bad /empty 0 100644 0 0 x'
+bad_record ''
+: > "$tmp/bad"
+"$MKFS_EROFS_PROG" --manifest="$tmp/bad" "$tmp/badimage" "$base" \
+	>> "$seqres.full" 2>&1 && _fail 'accepted empty manifest'
+printf '/file /empty 0 100644 0 0 - 1.1\n' > "$tmp/bad"
+"$MKFS_EROFS_PROG" --manifest="$tmp/bad" "$tmp/badimage" "$base" \
+	>> "$seqres.full" 2>&1 && _fail 'accepted missing root'
+# Root creation uses the same record path as every other inode.
+for record in '/ /empty 0 100644 0 0 - 1.1' \
+	'/ target 6 120777 0 0 - 1.1' \
+	'/ /target - @ - - - -' \
+	'/ - - 40755 0 0 - 1.1 user.bad=\x'; do
+	printf '%s\n' "$record" > "$tmp/bad"
+	"$MKFS_EROFS_PROG" --manifest="$tmp/bad" "$tmp/badimage" "$base" \
+		>> "$seqres.full" 2>&1
+	rc=$?
+	[ "$rc" -eq 0 ] && _fail "accepted invalid root: $record"
+	[ "$rc" -ge 128 ] && _fail "crashed on invalid root: $record"
+done
+# An error after a hardlink must clean up the shared inode safely.
+printf '/ - - 40755 0 0 - 1.1\n/file /empty 0 100644 0 0 - 1.1\n/hard /file - @ - - - -\n/ - - 40755 0 0 - 1.1\n' > "$tmp/bad"
+"$MKFS_EROFS_PROG" --manifest="$tmp/bad" "$tmp/badimage" "$base" \
+	>> "$seqres.full" 2>&1
+rc=$?
+[ "$rc" -eq 0 ] && _fail 'accepted duplicate root after hardlink'
+[ "$rc" -ge 128 ] && _fail 'crashed cleaning up duplicate root'
+
+# Build time does not replace manifest metadata; ignore-mtime permits compact inodes.
+"$MKFS_EROFS_PROG" -T1 --all-root --force-uid=1 --force-gid=1 \
+	--uid-offset=1 --gid-offset=1 --ignore-mtime --ovlfs-strip=0 \
+	-x-1 -x2 --manifest="$manifest" "$image" "$base" \
+	>> "$seqres.full" 2>&1 || _fail 'rejected permitted options'
+expect_stat /dir/file '100644 123 456 1.0 3 3'
+
+# Time option behavior must not depend on where --manifest appears.
+for position in before after; do
+	for options in '-T10' '-T10 --all-time' '-T10 --mkfs-time' \
+		'-T10 --mkfs-time --preserve-mtime' \
+		'-T10 --mkfs-time --ignore-mtime' \
+		'-T10 --mkfs-time -E force-inode-compact' \
+		'-T10 --mkfs-time -E force-inode-extended'; do
+		case "$position" in
+		before) set -- --manifest="$manifest" $options ;;
+		after) set -- $options --manifest="$manifest" ;;
+		esac
+		"$MKFS_EROFS_PROG" "$@" "$image" "$base" >> "$seqres.full" 2>&1 ||
+			_fail "time options rejected: $position $options"
+		case "$options" in
+		*ignore-mtime*|*force-inode-compact*) stamp=10.0; isize=32 ;;
+		*) stamp=1.1; isize=64 ;;
+		esac
+		expect_stat /dir/file "100644 123 456 $stamp 3 3"
+		grep -q "^Inode size: $isize " "$tmp/inode" ||
+			_fail "unexpected inode format: $options"
+		"$FSCK_EROFS_PROG" "$image" >> "$seqres.full" 2>&1 ||
+			_fail "fsck failed: $options"
+	done
+done
+
+# Each directory containing a whiteout, including a hardlink, must be marked.
+cat > "$tmp/whiteouts" <<'MANIFEST'
+/ - - 40755 0 0 - 1.1
+/a - - 40755 0 0 - 1.1
+/b - - 40755 0 0 - 1.1
+/a/deleted - - 20000 0 0 0 1.1
+/b/deleted /a/deleted - @ - - - -
+/b/device - - 20600 0 0 259 1.1
+MANIFEST
+for strip in 0 1; do
+	"$MKFS_EROFS_PROG" --manifest="$tmp/whiteouts" --ovlfs-strip="$strip" \
+		"$image" "$base" >> "$seqres.full" 2>&1 || _fail 'whiteout build failed'
+	for path in /a/deleted /b/deleted; do
+		if [ "$strip" -eq 0 ]; then
+			dump_inode "$path" >> "$seqres.full" || _fail "missing whiteout $path"
+		else
+			dump_inode "$path" >> "$seqres.full" 2>&1 && _fail "whiteout not stripped: $path"
+		fi
+	done
+	dump_inode /b/device >> "$seqres.full" || _fail 'ordinary device stripped'
+	"$FSCK_EROFS_PROG" "$image" >> "$seqres.full" 2>&1 || _fail 'whiteout fsck failed'
+done
+
+# Read h_shared_count using the inode location reported by dump.erofs.
+expect_shared_count()
+{
+	dump_inode "$1" > "$tmp/inode" || _fail "lookup $1 failed"
+	nid=$(sed -n 's/^NID: \([0-9]*\).*/\1/p' "$tmp/inode")
+	isz=$(sed -n 's/^Inode size: \([0-9]*\).*/\1/p' "$tmp/inode")
+	meta=$("$DUMP_EROFS_PROG" -s "$image" | awk '/inode metadata start block:/ {print $NF}')
+	# These fixtures use 4096-byte blocks and 32-byte inode slots.
+	offset=$((meta * 4096 + nid * 32 + isz + 4))
+	count=$(od -An -tu1 -j "$offset" -N1 "$image" | tr -d ' ')
+	[ "$count" = "$2" ] || _fail "unexpected shared count for $1: $count"
+}
+cat > "$tmp/shared" <<'MANIFEST'
+/ - - 40755 0 0 - 1.1
+/one /empty 0 100644 0 0 - 1.1 user.common=\x00\xff user.diff=a user.single=only
+/two /empty 0 100644 0 0 - 1.1 user.common=\x00\xff user.diff=b
+/three /empty 0 100644 0 0 - 1.1 user.common=\x00\xff user.diff=c
+/link1 /one - @ - - - -
+/link2 /one - @ - - - -
+MANIFEST
+for tolerance in default 0 2147483647 -1; do
+	set --
+	[ "$tolerance" = default ] || set -- -x"$tolerance"
+	"$MKFS_EROFS_PROG" -b4096 "$@" --manifest="$tmp/shared" "$image" "$base" \
+		>> "$seqres.full" 2>&1 || _fail "shared build failed: $tolerance"
+	case "$tolerance" in
+	default) one=1; two=1 ;;
+	0) one=3; two=2 ;;
+	*) one=0; two=0 ;;
+	esac
+	expect_shared_count /one "$one"
+	expect_shared_count /link1 "$one"
+	expect_shared_count /two "$two"
+	"$FSCK_EROFS_PROG" --extract="$tmp/shared-$tolerance" --no-preserve-owner --xattrs \
+		"$image" >> "$seqres.full" 2>&1 || _fail 'shared extraction failed'
+	for file in one two three; do
+		getfattr --only-values -n user.common "$tmp/shared-$tolerance/$file" \
+			> "$tmp/value" 2>> "$seqres.full" || _fail 'missing shared value'
+		[ "$(od -An -tx1 -v "$tmp/value" | tr -d ' \n')" = 00ff ] || _fail 'shared binary value'
+	done
+	[ "$(getfattr --only-values -n user.diff "$tmp/shared-$tolerance/two" 2>> "$seqres.full")" = b ] ||
+		_fail 'different xattr values merged'
+done
+
+# Manifest xattrs use custom name prefixes in inline and shared entries.
+cat > "$tmp/prefixes" <<'MANIFEST'
+/ - - 40755 0 0 - 1.1
+/one /empty 0 100644 0 0 - 1.1 user.manifest.long.bin=\x00\xff user.second.long.empty= user.manifest.long.unique=one user.plain=one
+/two /empty 0 100644 0 0 - 1.1 user.manifest.long.bin=\x00\xff user.second.long.empty= user.manifest.long.unique=two user.plain=two
+/three /empty 0 100644 0 0 - 1.1 user.manifest.long.bin=\x00\xff user.second.long.empty= user.manifest.long.unique=three user.plain=three
+MANIFEST
+for tolerance in 2147483647 2 0; do
+	"$MKFS_EROFS_PROG" -b4096 -x"$tolerance" --manifest="$tmp/prefixes" \
+		--xattr-prefix=user.manifest.long. --xattr-prefix=user.second.long. \
+		"$image" "$base" >> "$seqres.full" 2>&1 || _fail 'manifest name prefix build failed'
+	"$DUMP_EROFS_PROG" -s "$image" > "$tmp/super" || _fail 'prefix superblock dump failed'
+	grep -q 'xattr_prefixes' "$tmp/super" || _fail 'missing xattr prefix feature'
+	case "$tolerance" in
+	2147483647) shared_count=0 ;;
+	2) shared_count=2 ;;
+	0) shared_count=4 ;;
+	esac
+	for file in one two three; do
+		expect_shared_count /"$file" "$shared_count"
+	done
+	if [ "$tolerance" -eq 2147483647 ]; then
+		dump_inode /one > "$tmp/inode" || _fail 'prefix inode dump failed'
+		# Header (12), shortened entries (12+12+16), plain entry (12).
+		grep -q 'Xattr size: 64$' "$tmp/inode" || _fail 'name prefixes not used inline'
+	fi
+	"$FSCK_EROFS_PROG" --extract="$tmp/prefix-out-$tolerance" --no-preserve-owner --xattrs \
+		"$image" >> "$seqres.full" 2>&1 || _fail 'manifest name prefix extraction failed'
+	for file in one two three; do
+		for key in user.manifest.long.bin user.second.long.empty user.manifest.long.unique user.plain; do
+			getfattr --only-values -n "$key" "$tmp/prefix-out-$tolerance/$file" \
+				> "$tmp/value" 2>> "$seqres.full" || _fail "missing prefix xattr: $file $key"
+			case "$key" in
+			user.manifest.long.bin) printf '\000\377' > "$tmp/expected-value" ;;
+			user.second.long.empty) : > "$tmp/expected-value" ;;
+			*) printf '%s' "$file" > "$tmp/expected-value" ;;
+			esac
+			cmp "$tmp/expected-value" "$tmp/value" || _fail "prefix xattr differs: $file $key"
+		done
+	done
+done
+
+# The 256th candidate remains inline after 255 shared references.
+awk 'BEGIN {
+	print "/ - - 40755 0 0 - 1.1";
+	for (f = 1; f <= 3; ++f) {
+		printf "/f%d /empty 0 100644 0 0 - 1.1", f;
+		for (i = 0; i < 256; ++i) printf " user.k%03d=value", i;
+		printf "\n";
+	}
+}' > "$tmp/many"
+"$MKFS_EROFS_PROG" -b4096 --manifest="$tmp/many" "$image" "$base" \
+	>> "$seqres.full" 2>&1 || _fail 'many shared xattrs build failed'
+expect_shared_count /f1 255
+"$FSCK_EROFS_PROG" --extract --xattrs "$image" >> "$seqres.full" 2>&1 ||
+	_fail 'many shared xattrs fsck failed'
+# The final sorted entry is inline, after the header and 255 shared IDs.
+offset=$((meta * 4096 + nid * 32 + isz + 12 + 255 * 4 + 8))
+[ "$(od -An -tx1 -j "$offset" -N5 "$image" | tr -d ' \n')" = 76616c7565 ] ||
+	_fail 'inline overflow xattr value'
+
+# More than 256 KiB before sharing, but only five shared references per inode.
+awk 'BEGIN {
+	print "/ - - 40755 0 0 - 1.1";
+	for (i = 0; i < 60000; ++i) value = value "a";
+	for (f = 1; f <= 3; ++f) {
+		printf "/f%d /empty 0 100644 0 0 - 1.1", f;
+		for (i = 0; i < 5; ++i) printf " user.big%d=%s", i, value;
+		printf "\n";
+	}
+}' > "$tmp/bigattrs"
+"$MKFS_EROFS_PROG" -b4096 --manifest="$tmp/bigattrs" "$image" "$base" \
+	>> "$seqres.full" 2>&1 || _fail 'large shared xattrs build failed'
+expect_shared_count /f1 5
+# Read all xattrs without extracting values exceeding host filesystem limits.
+"$FSCK_EROFS_PROG" --extract --xattrs "$image" >> "$seqres.full" 2>&1 ||
+	_fail 'large shared xattrs fsck failed'
+shared=$("$DUMP_EROFS_PROG" -s "$image" | awk '/shared xattr metadata start block:/ {print $NF}')
+awk 'BEGIN { for (i = 0; i < 60000; ++i) printf "a"; }' > "$tmp/expected-value"
+for i in 0 1 2 3 4; do
+	# Four-byte entry header, four-byte suffix, then the value.
+	dd if="$image" of="$tmp/value" bs=1 skip=$((shared * 4096 + i * 60008 + 8)) \
+		count=60000 2>> "$seqres.full" || _fail 'shared value read failed'
+	cmp "$tmp/expected-value" "$tmp/value" || _fail 'large shared value differs'
+done
+
+# Short records import backing metadata and xattrs without scanning directories.
+mkdir -p "$base/short/sub"
+printf backing > "$base/short/data file"
+printf hidden > "$base/short/sub/unlisted"
+ln "$base/short/data file" "$base/short/alias"
+ln "$base/short/data file" "$base/short/not-listed"
+cp "$base/short/data file" "$base/short/copy1"
+cp "$base/short/data file" "$base/short/copy2"
+ln -s 'data file' "$base/short/link"
+ln -s missing "$base/short/dangling"
+mkfifo "$base/short/fifo"
+chmod 640 "$base/short/data file" "$base/short/copy1" "$base/short/copy2" "$base/short/fifo"
+chmod 750 "$base/short/sub"
+for file in 'data file' copy1 copy2; do
+	setfattr -n user.short.common -v 0x00ff "$base/short/$file" || _fail 'set short xattr'
+	setfattr -n user.short.empty -v '' "$base/short/$file" || _fail 'set empty short xattr'
+done
+setfattr -n user.short.single -v only "$base/short/data file" || _fail 'set single short xattr'
+setfattr -n user.short.dir -v directory "$base/short/sub" || _fail 'set directory xattr'
+touch -h -d '@5.000000009' "$base/short/"*
+cat > "$tmp/short" <<'MANIFEST'
+ / /short
+/dir /short/sub
+/data /short/data\x20file
+/alias /short/alias
+/copy1 /short/copy1
+/copy2 /short/copy2
+/link /short/link
+/dangling /short/dangling
+/fifo /short/fifo
+/explicit /data - @ - - - -
+/full /short/data\x20file 7 100644 123 456 - 1.1
+/full-dir - - 40755 0 0 - 1.1
+/full-dir/child /short/copy1
+MANIFEST
+# Exercise host path resolution and a final short record without a newline.
+printf ' /dot /short/sub/../data\x20file  ' >> "$tmp/short"
+"$MKFS_EROFS_PROG" -b4096 -T10 --mkfs-time --xattr-prefix=user.short. \
+	--manifest="$tmp/short" "$image" "$base" >> "$seqres.full" 2>&1 || _fail 'short build failed'
+short_uid=$(id -u) short_gid=$(id -g)
+expect_stat /data "100640 $short_uid $short_gid 5.9 7 4"
+expect_stat /dir "40750 $short_uid $short_gid 5.9"
+expect_stat /link "120777 $short_uid $short_gid 5.9 9 1"
+expect_stat /dangling "120777 $short_uid $short_gid 5.9 7 1"
+expect_stat /fifo "10640 $short_uid $short_gid 5.9"
+expect_stat /full '100644 123 456 1.1 7 1'
+expect_shared_count /data 2
+nid=$(dump_inode /data | sed -n 's/^NID: \([0-9]*\).*/\1/p')
+for file in alias explicit dot; do
+	[ "$(dump_inode /"$file" | sed -n 's/^NID: \([0-9]*\).*/\1/p')" = "$nid" ] ||
+		_fail 'short hardlink inode differs'
+done
+"$FSCK_EROFS_PROG" --extract="$tmp/short-out" --no-preserve-owner --xattrs "$image" \
+	>> "$seqres.full" 2>&1 || _fail 'short extraction failed'
+[ ! -e "$tmp/short-out/dir/unlisted" ] || _fail 'short directory recursively imported'
+[ ! -e "$tmp/short-out/not-listed" ] || _fail 'unlisted source hardlink imported'
+[ "$(readlink "$tmp/short-out/link")" = 'data file' ] || _fail 'short symlink followed'
+[ "$(readlink "$tmp/short-out/dangling")" = missing ] || _fail 'dangling symlink changed'
+cmp "$base/short/data file" "$tmp/short-out/data" || _fail 'short data differs'
+getfattr --only-values -n user.short.common "$tmp/short-out/data" > "$tmp/value" 2>> "$seqres.full" ||
+	_fail 'short binary xattr missing'
+[ "$(od -An -tx1 -v "$tmp/value" | tr -d ' \n')" = 00ff ] || _fail 'short binary xattr differs'
+getfattr --only-values -n user.short.empty "$tmp/short-out/data" > "$tmp/value" 2>> "$seqres.full" ||
+	_fail 'short empty xattr missing'
+[ ! -s "$tmp/value" ] || _fail 'short empty xattr differs'
+[ "$(getfattr --only-values -n user.short.dir "$tmp/short-out/dir" 2>> "$seqres.full")" = directory ] ||
+	_fail 'short directory xattr differs'
+getfattr -n user.short.common "$tmp/short-out/full" >> "$seqres.full" 2>&1 &&
+	_fail 'full record imported backing xattr'
+
+# Local metadata options affect short records, but not complete records.
+"$MKFS_EROFS_PROG" -T20 --force-uid=42 --force-gid=43 --uid-offset=1 --gid-offset=2 \
+	--hard-dereference -x-1 --manifest="$tmp/short" "$image" "$base" \
+	>> "$seqres.full" 2>&1 || _fail 'short local options failed'
+expect_stat /data '100640 43 45 20.0 7 2'
+expect_stat /alias '100640 43 45 20.0 7 1'
+expect_stat /full '100644 123 456 1.1 7 1'
+dump_inode /data > "$tmp/inode" || _fail 'short data lookup failed'
+grep -q 'Xattr size: 0$' "$tmp/inode" || _fail 'short xattrs not disabled'
+"$FSCK_EROFS_PROG" "$image" >> "$seqres.full" 2>&1 || _fail 'short options fsck failed'
+SOURCE_DATE_EPOCH=3 "$MKFS_EROFS_PROG" --manifest="$tmp/short" "$image" "$base" \
+	>> "$seqres.full" 2>&1 || _fail 'short timestamp clamping failed'
+expect_stat /data "100640 $short_uid $short_gid 3.0 7 4"
+expect_stat /full '100644 123 456 1.1 7 1'
+
+# Special backing files are optional where creating device nodes is forbidden.
+for device in char block whiteout; do
+	case "$device" in
+	char) set -- c 1 3 ;;
+	block) set -- b 8 0 ;;
+	whiteout) set -- c 0 0 ;;
+	esac
+	if mknod "$base/short/$device" "$@" 2>> "$seqres.full"; then
+		printf '/ - - 40755 0 0 - 1.1\n/device /short/%s\n/hard /device - @ - - - -\n' "$device" > "$tmp/special"
+		for strip in 0 1; do
+			"$MKFS_EROFS_PROG" --ovlfs-strip="$strip" --manifest="$tmp/special" "$image" "$base" \
+				>> "$seqres.full" 2>&1 || _fail 'short device build failed'
+			if [ "$device:$strip" = whiteout:1 ]; then
+				dump_inode /device >> "$seqres.full" 2>&1 && _fail 'short whiteout not stripped'
+				dump_inode /hard >> "$seqres.full" 2>&1 && _fail 'short whiteout link not stripped'
+			else
+				dump_inode /device >> "$seqres.full" || _fail 'short device missing'
+			fi
+			"$FSCK_EROFS_PROG" "$image" >> "$seqres.full" 2>&1 || _fail 'short device fsck failed'
+		done
+	fi
+done
+if command -v python3 >/dev/null 2>&1; then
+	python3 -c 'import socket, sys; s = socket.socket(socket.AF_UNIX); s.bind(sys.argv[1]); s.close()' \
+		"$base/short/socket" || _fail 'socket fixture failed'
+	printf '/ /short\n/socket /short/socket\n' > "$tmp/special"
+	"$MKFS_EROFS_PROG" --manifest="$tmp/special" "$image" "$base" \
+		>> "$seqres.full" 2>&1 || _fail 'short socket build failed'
+	dump_inode /socket > "$tmp/inode" || _fail 'short socket missing'
+	grep -q 'SOCK file$' "$tmp/inode" || _fail 'short socket type differs'
+	"$FSCK_EROFS_PROG" "$image" >> "$seqres.full" 2>&1 || _fail 'short socket fsck failed'
+fi
+
+bad_record '/bad /short/missing'
+bad_record '/bad relative'
+bad_record '/bad /short/data\x00file'
+bad_record '/bad /short/data\x'
+bad_record '/bad /short/copy1 user.extra=value'
+bad_record '/missing/child /short/copy1'
+for fields in '/bad /short/copy1 7' '/bad /short/copy1 7 100644' \
+	'/bad /short/copy1 7 100644 0' '/bad /short/copy1 7 100644 0 0' \
+	'/bad /short/copy1 7 100644 0 0 -'; do
+	bad_record "$fields"
+done
+printf '/ /short/copy1\n' > "$tmp/bad"
+"$MKFS_EROFS_PROG" --manifest="$tmp/bad" "$image" "$base" >> "$seqres.full" 2>&1 &&
+	_fail 'accepted short nondirectory root'
+printf '/ /short\n/one /short/data\x20file\n/two /short/alias\n/one /short/copy1\n' > "$tmp/bad"
+"$MKFS_EROFS_PROG" --manifest="$tmp/bad" "$image" "$base" >> "$seqres.full" 2>&1
+rc=$?
+[ "$rc" -eq 0 ] && _fail 'accepted duplicate short path'
+[ "$rc" -ge 128 ] && _fail 'crashed cleaning up short hardlinks'
+
+# Both record formats enter the normal file compression pipeline.
+awk 'BEGIN { for (i = 0; i < 4096; ++i) printf "manifest payload\n"; }' > "$base/compress"
+compressed_size=$(stat -c %s "$base/compress")
+chmod 640 "$base/compress"
+setfattr -n user.compressed -v 0x00ff "$base/compress" || _fail 'set compression xattr'
+touch -d '@5.000000009' "$base/compress"
+cat > "$tmp/compressed" <<MANIFEST
+/ - - 40755 0 0 - 1.1
+/full /compress $compressed_size 100600 123 456 - 1.1 user.compressed=\x00\xff
+/short /compress
+/alias /compress
+/hard /full - @ - - - -
+MANIFEST
+for algorithm in lz4 lz4hc lzma deflate zstd; do
+	case "$algorithm" in
+	lz4) [ -n "$lz4_on" ] || continue ;;
+	lz4hc) [ -n "$lz4hc_on" ] || continue ;;
+	lzma) [ -n "$lzma_on" ] || continue ;;
+	zstd) [ -n "$zstd_on" ] || continue ;;
+	esac
+	"$MKFS_EROFS_PROG" -b4096 -T10 --mkfs-time -x0 "-z$algorithm" \
+		--manifest="$tmp/compressed" "$image" "$base" \
+		>> "$seqres.full" 2>&1 || _fail "compressed build failed: $algorithm"
+	expect_stat /full "100600 123 456 1.1 $compressed_size 2"
+	expect_stat /short "100640 $short_uid $short_gid 5.9 $compressed_size 2"
+	for file in full short; do
+		dump_inode /"$file" > "$tmp/inode" || _fail 'compressed inode missing'
+		grep -Eq 'Layout: (1|3) ' "$tmp/inode" ||
+			_fail "file was not compressed: $algorithm $file"
+		expect_shared_count /"$file" 1
+	done
+	for pair in 'full hard' 'short alias'; do
+		set -- $pair
+		nid=$(dump_inode /"$1" | sed -n 's/^NID: \([0-9]*\).*/\1/p')
+		[ "$(dump_inode /"$2" | sed -n 's/^NID: \([0-9]*\).*/\1/p')" = "$nid" ] ||
+			_fail 'compressed hardlink inode differs'
+	done
+	out="$tmp/compressed-$algorithm"
+	"$FSCK_EROFS_PROG" --extract="$out" --no-preserve-owner --xattrs "$image" \
+		>> "$seqres.full" 2>&1 || _fail "compressed extraction failed: $algorithm"
+	for file in full short hard alias; do
+		cmp "$base/compress" "$out/$file" || _fail 'decompressed content differs'
+		getfattr --only-values -n user.compressed "$out/$file" > "$tmp/value" \
+			2>> "$seqres.full" || _fail 'compressed xattr missing'
+		[ "$(od -An -tx1 -v "$tmp/value" | tr -d ' \n')" = 00ff ] ||
+			_fail 'compressed binary xattr differs'
+	done
+done
+
+# Incremental complete records associate only matching old directories.
+incr_base="$tmp/incr-base"
+incr_source="$tmp/incr-source"
+mkdir -p "$incr_base/existing" "$incr_base/to-file" "$incr_source/local"
+printf keep > "$incr_base/existing/keep"
+printf old > "$incr_base/existing/change"
+printf old > "$incr_base/to-dir"
+printf old > "$incr_base/to-file/child"
+printf new > "$incr_source/data"
+ln "$incr_source/data" "$incr_source/alias"
+setfattr -n user.old -v old "$incr_base/existing" || _fail 'set old directory xattr'
+"$MKFS_EROFS_PROG" -T10 "$image" "$incr_base" >> "$seqres.full" 2>&1 ||
+	_fail 'incremental base build failed'
+cat > "$tmp/incr-manifest" <<'MANIFEST'
+/ - - 40755 123 456 - 1.1
+/existing - - 40750 123 456 - 2.3 user.new=new
+/existing/change /data 3 100640 123 456 - 2.3
+/newdir - - 40750 123 456 - 2.3
+/newdir/nested - - 40700 123 456 - 2.3
+/newdir/nested/file /data 3 100640 123 456 - 2.3
+/to-dir - - 40750 123 456 - 2.3
+/to-dir/file /data 3 100640 123 456 - 2.3
+/to-file /data 3 100640 123 456 - 2.3
+/local /local
+/local/full-child - - 40750 123 456 - 2.3
+/local/full-child/short /data
+/short-alias /alias
+/explicit /local/full-child/short - @ - - - -
+MANIFEST
+"$MKFS_EROFS_PROG" --incremental=data --manifest="$tmp/incr-manifest" \
+	"$image" "$incr_source" >> "$seqres.full" 2>&1 || _fail 'incremental manifest build failed'
+expect_stat / '40755 123 456 1.1'
+expect_stat /existing '40750 123 456 2.3'
+expect_stat /newdir/nested '40700 123 456 2.3'
+expect_stat /to-dir '40750 123 456 2.3'
+expect_stat /local/full-child '40750 123 456 2.3'
+expect_stat /existing/change '100640 123 456 2.3 3 1'
+expect_stat /to-file '100640 123 456 2.3 3 1'
+nid=$(dump_inode /local/full-child/short | sed -n 's/^NID: \([0-9]*\).*/\1/p')
+for entry in /short-alias /explicit; do
+	[ "$(dump_inode "$entry" | sed -n 's/^NID: \([0-9]*\).*/\1/p')" = "$nid" ] ||
+		_fail 'incremental hardlink inode differs'
+done
+"$FSCK_EROFS_PROG" --extract="$tmp/incr-out" --no-preserve-owner --xattrs "$image" \
+	>> "$seqres.full" 2>&1 || _fail 'incremental extraction failed'
+cmp "$incr_base/existing/keep" "$tmp/incr-out/existing/keep" || _fail 'old file not retained'
+for entry in existing/change newdir/nested/file to-dir/file to-file local/full-child/short; do
+	cmp "$incr_source/data" "$tmp/incr-out/$entry" || _fail 'incremental content differs'
+done
+[ "$(getfattr --only-values -n user.new "$tmp/incr-out/existing" 2>> "$seqres.full")" = new ] ||
+	_fail 'new directory xattr missing'
+getfattr -n user.old "$tmp/incr-out/existing" >> "$seqres.full" 2>&1 &&
+	_fail 'old directory xattr retained'
+
+echo 'Silence is golden'
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


