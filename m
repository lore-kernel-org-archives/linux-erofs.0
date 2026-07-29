Return-Path: <linux-erofs+bounces-4032-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B333C53200
	for <linux-erofs@archiver.kernel.org>; Wed, 29 Jul 2026 19:57:31 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h9NQx3DNGz2xwP;
	Thu, 30 Jul 2026 05:57:29 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=37.120.164.117
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785355049;
	cv=none; b=QlXa1t3HunJE+Vwu+PohnsdRIbz9LzhBvDXrefVRCGE+wMnIg0wdnbH0Io0DW1L+TCrJJC1O0w5iQdo/8HiiPo/gAzQqlNO6GWR6BjuEyJScJPatMPyOvHJVntx67D14GeWbPpcj0TdPOuzFJIwdClGbQjTcZugXbvXdg2uoruGF1TGAN7oOmv5g4sRHiyXU2lwJQG90uQEJB61v8tTAteRmZSSWOkF61sk9f/v56JjbUrmZu4DtPIqAcHZOMkOLCzWp3LZDAOvJ0DP75SpIaYcEJR+nVajp23AlFDhGvvVL5I28JGq1kDKn/38nhrRB8n/Z6ffNY+rdrhrOBDiTfg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785355049; c=relaxed/relaxed;
	bh=SBEUFOAolSKqYeDYtWCw2pBbqmUF3RgJ7xfj3QFRiI4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=lfLKo6kK8GkHHGwUEwXId/f0AhT/jLNdkVFmt11TNUlWH4wqRspkuSxTA0Q3dQv6b9Faf6xf9kQ/HkdiCT3MB88fjjD4BdjE4GSvEowQismPs0iM19uYJbism2T8fxkLjo5iXpi37Mq0LA+qLRE433VmyXfRCU7me27pYypsV6xhGTvia8VcYEn4oPQU2JRsY7w3TV0ScuPvIPDO7P6ysC0GfQnf2Ww7alf5tuZK1bwNEsQM9WO13DYlJ73mIpB5NtEPGJJH78q2oRMpNWVqvak6GC078kxXBpeF0OPw5TB7gPFpFRsKHJmA0Fh6/ZS+eVqjRiuEjFRWrYFN4YUKSA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=piware.de; dkim=pass (2048-bit key; unprotected) header.d=piware.de header.i=@piware.de header.a=rsa-sha256 header.s=2025 header.b=ZjAv+cgw; dkim-atps=neutral; spf=pass (client-ip=37.120.164.117; helo=mail.piware.de; envelope-from=martin@piware.de; receiver=lists.ozlabs.org) smtp.mailfrom=piware.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=piware.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=piware.de header.i=@piware.de header.a=rsa-sha256 header.s=2025 header.b=ZjAv+cgw;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=piware.de (client-ip=37.120.164.117; helo=mail.piware.de; envelope-from=martin@piware.de; receiver=lists.ozlabs.org)
X-Greylist: delayed 310 seconds by postgrey-1.37 at boromir; Thu, 30 Jul 2026 05:57:25 AEST
Received: from mail.piware.de (mail.piware.de [37.120.164.117])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h9NQt01KVz2xg8
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 05:57:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=piware.de; s=2025;
	t=1785354729; bh=ajDVHpB8wjp3iSsXmXv6y8idletV8Hbb4flUl5PIwrg=;
	h=Date:From:To:Cc:Subject:From;
	b=ZjAv+cgwTmyKkoDMf7NFPby/E6k84g40S0lJGwzyqfiXvJpaR5Cy8PhpbV9ChSHEq
	 350zHGJYRqySdQehtJllCPissvyBfRYo2O/G0FAEtafPdK7qQe+B1Wcxey2S2Q2hcj
	 4Pmsfz85Rf4y+/E+381qIiaVtqVc0ldu33jjpqaKgWRrUOvGRFSZ2vapv3eoF1+c98
	 jOqQ6Ovm9OcQYdOXqfc/5kANN8gTYXTaSWnk7ul2vsD8FfWcMDY+RMpSGNTAaK8NXZ
	 KnmOz5+PisbZnpwM57qLHMyTMMK0WYWziSjUF4i4Ig06yJNypXIAx82xLl6DTuqjhR
	 ljOLsaEq7WpSw==
Received: from piware.de (localhost [127.0.0.1])
	by mail.piware.de (Postfix) with SMTP id 75D37FF88A;
	Wed, 29 Jul 2026 21:52:09 +0200 (CEST)
Date: Wed, 29 Jul 2026 21:52:08 +0200
From: Martin Pitt <martin@piware.de>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>, Yifan Zhao <zhaoyifan28@huawei.com>
Subject: [PATCH] erofs-utils: mkfs: emit an inode's xattrs in a canonical
 order
Message-ID: <ampZ6MVV1nN3YzQ_@piware.de>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

listxattr(2) makes no promise about the order it reports: while e.g.
ext4 returns a reproducible order, tmpfs varies it from inode to inode,
so building the same tree twice can lay the same set of xattrs out
differently and yield images that differ byte for byte. This makes the
erofs images unreproducible.

Insert into the inode's list ordered by attribute name instead, and move
inline attributes onto the on-stack list with list_add_tail() so the
emitted order matches. This is the same approach as the shared attribute
pool already does with comp_shared_xattritem().

Signed-off-by: Martin Pitt <martin@amutable.com>
---

See the attached reproducer below (that was written by Claude Opus 5). With
$TMPDIR pointing to tmpfs (most modern distros should have the default /tmp/ on
tmpfs), it does 8 runs with lots of jitter:

> run  1  listxattr: gpt_label gpt_type_uuid mount_point            sha256: d81df9744f252cf3
> run  4  listxattr: gpt_label gpt_type_uuid mount_point            sha256: 6bad887d59e1e404
> run  7  listxattr: gpt_label gpt_type_uuid mount_point            sha256: a16c9aca9449e61b
> [...]
> 
> FAIL: mkfs.erofs output depends on listxattr(2) order

With the fix, the shas are all identical.

fsck.erofs is happy with images carrying shared, inline and multi-prefix
attributes.

The script needs setfattr/getfattr from attr, and a tmpfs $TMPDIR to vary the
reported order; it says so when the order came out stable, so a pass on ext4
does not mean much. I have not proposed the reproducer as a patch since the
repo has no tests. But if you want me to do that, let me know.

Also: Kernel process newbie here, sorry if I messed up formatting/structure.

Thanks,

Martin


#!/bin/sh
# Reproducer: mkfs.erofs output depends on listxattr(2) order.
#
# mkfs.erofs stores an inode's extended attributes in the order listxattr(2)
# reports them. That order is not specified, and tmpfs varies it from inode to
# inode, so building the very same tree twice can produce different images.
#
# Every run below writes identical content and sets the same three xattrs on the
# root inode in the same order; only the staging directory (hence its inode)
# differs. That is exactly what systemd-repart does when it builds a DDI: it
# stages each partition in a fresh mkdtemp() directory and sets its
# user.validatefs.* xattrs there before calling mkfs.erofs.
#
# Usage: ./xattr-order-reproducer.sh [path-to-mkfs.erofs] [runs]
#
# Exit status: 0 output is independent of listxattr order, 1 it is not,
# 77 prerequisites missing (autotools "skipped" convention).

set -eu

MKFS=${1:-mkfs.erofs}
RUNS=${2:-8}

# -x first: command -v does not look up a bare relative path such as mkfs/mkfs.erofs.
[ -x "$MKFS" ] || command -v "$MKFS" >/dev/null 2>&1 || { echo "cannot run $MKFS"; exit 77; }
command -v setfattr >/dev/null 2>&1 || { echo "need setfattr from the attr package"; exit 77; }
command -v getfattr >/dev/null 2>&1 || { echo "need getfattr from the attr package"; exit 77; }

WORK=$(mktemp -d "${TMPDIR:-/tmp}/erofs-xattr-order.XXXXXX")
trap 'rm -rf "$WORK"' EXIT

echo "mkfs:     $MKFS"
echo "work dir: $WORK on a $(stat -f -c %T "$WORK") filesystem"
echo

i=1
while [ "$i" -le "$RUNS" ]; do
	src=$WORK/src$i
	mkdir -p "$src/dir"
	echo payload > "$src/dir/file"

	# Always set in this order; listxattr(2) need not report it back this way.
	setfattr -n user.validatefs.gpt_label -v root-x86-64 "$src"
	setfattr -n user.validatefs.gpt_type_uuid \
		-v 2c7357ed-ebd2-46d9-aec1-23d437ec2bf5 "$src"
	setfattr -n user.validatefs.mount_point -v / "$src"

	order=$(getfattr -d --absolute-names "$src" |
		sed -n 's/^user\.validatefs\.\([a-z_]*\)=.*/\1/p' | tr '\n' ' ')

	# -T and -U pin the timestamp and the filesystem UUID, so the xattr order
	# is the only thing that can differ between runs.
	SOURCE_DATE_EPOCH=1739577600 "$MKFS" --quiet -T1739577600 \
		-U 5230d7cf-f2ce-43ed-9ae2-39e7e2fe48ca "$WORK/img$i" "$src"

	printf 'run %2d  listxattr: %-46s sha256: %s\n' \
		"$i" "$order" "$(sha256sum < "$WORK/img$i" | cut -c1-16)"
	i=$((i + 1))
done

echo
distinct=$(sha256sum "$WORK"/img* | awk '{print $1}' | sort -u | wc -l)
orders=$(for f in "$WORK"/src*; do
		getfattr -d --absolute-names "$f" |
			sed -n 's/^user\.validatefs\.\([a-z_]*\)=.*/\1/p' | tr '\n' ' '
		echo
	done | sort -u | wc -l)
echo "$RUNS identical trees: $orders distinct listxattr order(s), $distinct distinct image(s)"

if [ "$distinct" -ne 1 ]; then
	echo "FAIL: mkfs.erofs output depends on listxattr(2) order"
	exit 1
fi

if [ "$orders" -eq 1 ]; then
	echo "PASS, but inconclusive: this filesystem reported one stable order."
	echo "Point TMPDIR at a tmpfs to vary it, e.g. TMPDIR=/dev/shm $0 $MKFS $RUNS"
else
	echo "PASS: output is independent of listxattr(2) order"
fi

 lib/xattr.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/lib/xattr.c b/lib/xattr.c
index 051fdd8..cc74e16 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -400,17 +400,39 @@ static struct erofs_xattritem *erofs_get_selabel_xattr(struct erofs_sb_info *sbi
 	return NULL;
 }
 
+static int comp_inode_xattritem(const struct erofs_xattritem *a,
+				const struct erofs_xattritem *b)
+{
+	int ret = memcmp(a->kvbuf, b->kvbuf, min(a->len[0], b->len[0]));
+
+	if (ret)
+		return ret;
+	if (a->len[0] != b->len[0])
+		return a->len[0] < b->len[0] ? -1 : 1;
+	return 0;
+}
+
 static int erofs_inode_xattr_add(struct list_head *hlist,
 				 struct erofs_xattritem *item)
 {
-	struct erofs_inode_xattr_node *node;
+	struct erofs_inode_xattr_node *node, *pos;
 
 	node = malloc(sizeof(*node));
 	if (!node)
 		return -ENOMEM;
 	init_list_head(&node->list);
 	node->item = item;
-	list_add(&node->list, hlist);
+
+	/*
+	 * Keep each inode's xattrs ordered by name.  listxattr(2) makes no
+	 * promise about the order it reports, and tmpfs varies it from inode
+	 * to inode, so appending in listing order would emit the same set of
+	 * xattrs differently from run to run and make images unreproducible.
+	 */
+	list_for_each_entry(pos, hlist, list)
+		if (comp_inode_xattritem(item, pos->item) < 0)
+			break;
+	list_add_tail(&node->list, &pos->list);
 	return 0;
 }
 
@@ -1091,10 +1113,10 @@ char *erofs_export_xattr_ibody(struct erofs_inode *inode)
 		item = node->item;
 		list_del(&node->list);
 
-		/* move inline xattrs to the onstack list */
+		/* move inline xattrs to the onstack list, order preserved */
 		if (item->shared_xattr_id < 0 ||
 		    header->h_shared_count >= UCHAR_MAX) {
-			list_add(&node->list, &ilst);
+			list_add_tail(&node->list, &ilst);
 			continue;
 		}
 
-- 
2.55.0


