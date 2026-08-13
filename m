Return-Path: <linux-erofs+bounces-4217-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48CF9C5CFDB
	for <linux-erofs@archiver.kernel.org>; Thu, 13 Aug 2026 09:40:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hLL1n3CPqz2yKD;
	Thu, 13 Aug 2026 19:40:13 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=156.147.23.53
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786614013;
	cv=none; b=SxICDKvqX0Uo9ssh6ZqjWy9lPMxmWP1Bjp4Iq99WLpbL+B3+SgR5H3spcI+s66Fs9eCXeSDuLDqddRuo9GGpAeAQFB/ExMdBmTa4NmFTm5pT6TWLPnWupzvHvdRFKclKUEmr6q0Of8rxQbSjLzcFkRMYojMgh8qrO1kG+VOLfyyUC/fWbbsQL2mP4+PH/a4EN9Z5GnLdzXY51HjmNWPWZNj7fwpkHGfxXeSOMSAR3mE7UDOOUKCdt7NYVFFx8P6uM0RxwvaJJ7Om0PtVUMZ3NdURmB9WuSfX2ZeQ2YaabiePZ/vJRfU3MnvNxYAeY3rhadbylDzvq828wMXePghstw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786614013; c=relaxed/relaxed;
	bh=NwLkza2EkavFk8sFbA2VeNqasQDs+LVbLwylGx0XpBQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gUNH5LKhUp1qhLpYHWNi8JAEAMj8I8nv5rnDJARZU8FoisDPrCsfUl8+sMcFHiJeMYxAH2mydzfjxNcbS17e7cFVQS1zcltyHOvFuhoGY1GY/bQ66d3BojaSfdkzMMUl0jI9jDmY/3wT7QcmZFcrG6294BKvK6SBXU8FXRWZ34l0OjOvBANeaQZfCP7WWwBHBKIKXpBCEQWLdEYtvE5IdjcCYSQ/dRzYPs+u+TvUjtBANri35PRIsa7ENo7vpVthaiFHr4EHnzCSQo0cUH6BDVCELI7DrBxz+QGVK5cfL8sZ9dQ7ETjfziBVnOHd/mzuaT6B2ACWhey48qKycjf/Aw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass (client-ip=156.147.23.53; helo=lgeamrelo13.lge.com; envelope-from=seula2.lee@lge.com; receiver=lists.ozlabs.org) smtp.mailfrom=lge.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=lge.com (client-ip=156.147.23.53; helo=lgeamrelo13.lge.com; envelope-from=seula2.lee@lge.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 75 seconds by postgrey-1.37 at boromir; Thu, 13 Aug 2026 19:40:11 AEST
Received: from lgeamrelo13.lge.com (lgeamrelo13.lge.com [156.147.23.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hLL1l6c2yz2y32
	for <linux-erofs@lists.ozlabs.org>; Thu, 13 Aug 2026 19:40:11 +1000 (AEST)
Received: from unknown (HELO lgemrelse6q.lge.com) (156.147.1.121)
	by 156.147.23.53 with ESMTP; 13 Aug 2026 18:38:52 +0900
X-Original-SENDERIP: 156.147.1.121
X-Original-MAILFROM: seula2.lee@lge.com
Received: from unknown (HELO aotp..) (10.157.70.65)
	by 156.147.1.121 with ESMTP; 13 Aug 2026 18:38:52 +0900
X-Original-SENDERIP: 10.157.70.65
X-Original-MAILFROM: seula2.lee@lge.com
From: seula2.lee@lge.com
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>,
	seula2.lee@lge.com
Subject: [PATCH] erofs-utils: lib: fix erofs_is_packed_inode() on the read path
Date: Thu, 13 Aug 2026 18:38:49 +0900
Message-Id: <20260813093849.3607625-1-seula2.lee@lge.com>
X-Mailer: git-send-email 2.34.1
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
Content-Transfer-Encoding: 8bit

From: Seula Lee <seula2.lee@lge.com>

erofs_is_packed_inode() compares i_srcpath against the global
EROFS_PACKED_INODE identifier.  i_srcpath is only assigned by
mkfs.erofs and has no on-disk counterpart, so it is never set for
inodes filled in by erofs_read_inode_from_disk(), and the helper always
returns false on the read path.

fsck.erofs therefore treats the packed inode as an ordinary regular
file at all four of its call sites, for any image with fragments and a
non-zero packed_nid:

- erofsfsck_extract_inode(): the guard never fires, so
erofs_extract_file() writes the packed data to fsckcfg.extract_path
itself, which is still the top-level directory because main()
checks the packed inode before the root inode. Extracting the root
then fails in erofs_extract_dir():

$ mkfs.erofs -zlz4hc -Efragments img.erofs dir
$ fsck.erofs --extract=out img.erofs
<E> erofs: erofs_extract_dir() Line[697] path is not a directory: out
<E> erofs: main() Line[1256] Failed to extract filesystem
$ file out
out: ASCII text # 603720 bytes, the packed inode itself

- erofsfsck_set_attributes(): the packed inode's mode, timestamps and
xattrs are applied to the extraction root directory.

- erofs_verify_inode_data(): the packed inode's own compressed data is
decoded and hashed as if it were file data.

- the -p accounting: fragment bytes are counted both as file data and
as packed inode data, so the reported ratio is too low.

Restore the nid-based test, which is how the packed inode is already
identified elsewhere on the read path: z_erofs_read_one_data() compares
inode->nid against sbi->packed_nid directly, and the
erofs_sb_has_fragments(sbi) && sbi->packed_nid > 0 idiom used here is
the same one in fuse/main.c, dump/main.c and fsck.erofs' own
erofs_packedfile_init() call.

The i_srcpath comparison has to stay first rather than be replaced:
while mkfs.erofs builds the packed inode its nid is still
EROFS_NID_UNALLOCATED and sbi->packed_nid is 0, so a nid-only test
would return false there and break fragment dedupe and
pclusterblks_packed handling in lib/compress.c.

This restores the v1.8.x behaviour at every call site, where the helper
was nid-based; in particular the packed inode is again excluded from the
decompression check that --extract performs, as it was before v1.9.

dump.erofs is affected the same way and prints "Path : (packed file)"
again as intended.

erofs_is_metabox_inode() shares the same idiom, but it has no read-path
caller (all callers are in lib/compress.c and lib/inode.c), so it is
left alone.

Fixes: 7928074b7643 ("erofs-utils: introduce metadata compression [metabox]")
Signed-off-by: Seula Lee <seula2.lee@lge.com>
---
Affects v1.9 through v1.9.3; v1.8.x used a nid-based helper in
include/erofs/compress.h and is fine.

Tested on v1.9.3:

- --extract now works on lz4/lz4hc/fragments/all-fragments/dedupe
images, with `diff -r` against the source tree clean;
- check-only runs and fragments-less images are unchanged;
- corruption injected into the packed inode is still detected in 18 of
20 cases, the same as before this patch -- it now surfaces via the
fragment reads rather than the direct decode of the packed inode;
- mkfs.erofs output is byte-identical, including --incremental onto an
existing fragments image. Note that comparing mkfs output requires
pinning the nondeterministic fields, e.g.
-U <fixed-uuid> -T0 --mkfs-time.

   	include/erofs/internal.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/erofs/internal.h b/include/erofs/internal.h
index 2cc9cc8..c9c7873 100644
--- a/include/erofs/internal.h
+++ b/include/erofs/internal.h
@@ -577,7 +577,11 @@ extern const char *erofs_frags_packedname;
 
 static inline bool erofs_is_packed_inode(struct erofs_inode *inode)
 {
-	return inode->i_srcpath == EROFS_PACKED_INODE;
+	if (inode->i_srcpath == EROFS_PACKED_INODE)
+		return true;
+	return erofs_sb_has_fragments(inode->sbi) &&
+		inode->sbi->packed_nid > 0 &&
+		inode->nid == inode->sbi->packed_nid;
 }
 
 int erofs_packedfile_init(struct erofs_sb_info *sbi, bool fragments_mkfs);

base-commit: 7db78788b000999e2de88decd2ba90654f26171c
-- 
2.34.1


