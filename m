Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D18B606A320
	for <linux-erofs@archiver.kernel.org>; Sun, 22 Nov 2026 04:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VJ4xEBja
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jXGkW6zNLz2xnn;
	Sun, 22 Nov 2026 15:46:43 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25" arc.chain=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795322803;
	cv=pass; b=hzYYa0AIlT4Ru5QMZP/Njx6ZdVj6EkXwD6jDYW50+GJ4+p5dE0m/TbFc6IimE9A0raw5NSv+BNIn+sMdfghIIPcoDDHeTjaPcwSozXlhhqBwut4FhM8PXplEm4K9paMHlt5TWwa1UxogH6QYZqqhKhNcG42nZvtgiWrlmU62g+4ce2OBd+shDw7yZHsWyDqzF40q76Hgh7BpvBjbyndVJTjEq7RpC621aF34vHRmra91Zfi7U122hKA/saLfZmU/Q3TaPt2wFYC5NYXeiM82kCoy3GOfuEAt3y/PBlqKcxWoNK98BYrsMoEF5mrtA0oydZKa+0Vn+yFjwaJKtLCIBw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795322803; c=relaxed/relaxed;
	bh=pyQU61KeZxRqKIv4fEq3sjbu3NAiZ06/nU9zOmL3X/I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=GUpl/ABUR6PX7DldHOVnqQ+mfP11PPQse0fCzrZxAUSOyEAtDoa5SXe4GEe9Tw1k32rbXlTzqO3omILGe7TIznlfNwljZFy+qveSbUyholmC80H/qAIfiU4NYY5VodXDLd9YbX0ILjwCbYi9PLA2biP7fIq92jJg9VoCMWIL6bBr0Lhe6KA5jW4rM/d64o1ctQd8IDC53O7AuKzX3Oy+l0Uybj38+IPe4dEDxK5ocSzIT2xXL/8eLxsW9ArM8+mhfTLiWqVjtwtqWwgdkTZEcv/fA2w2+ZUJmTalhUb2hewPAaIChRqwbNqPqWCJc6e2pzfH4h+AI6zj0L3dze+KuA==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VJ4xEBja; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=devnull+fadouse.pm.me@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VJ4xEBja;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=devnull+fadouse.pm.me@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jXGkW0xGtz2xdY
	for <linux-erofs@lists.ozlabs.org>; Sun, 22 Nov 2026 15:46:42 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C59944E26;
	Sun, 22 Nov 2026 04:46:40 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795322799;
	b=umwiJrG1J4XO9tHzqGuMirU1YXb/7Vs9ybM4s5bklA0se1as8jPkUqg0gyl5XI+uVPjQ
	 Qpfchn9nN/Pb0CJS7vT5gydYDmrxYW7IVlyl3YrLUWzeUY8n2VYaUikCgBp/um/teQ5d6
	 DafekOfx1ee5Tzj8ZkvOgsp3F15XqHp7r2k7KZaFzfjMtQI5S+EXeWEa6pwwwyebZYTgq
	 RetDOOHJlDc+JhIGFaFLzcPMoGEpPKq/i7gjF5zgbgHOeF3KMNZRNmNeQ17s8j3uto5eT
	 Bwti44VGmaYoyDYvAkv7GydMg50/qlJ3yfABE40ATggMiCXVAy7WCwryYdlOQAnsQpA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795322799;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=pyQU61KeZxRqKIv4fEq3sjbu3NAiZ06/nU9zOmL3X/I=;
	b=PDLWyQJ1j/R2PP4q6DsnsQUisfexp4Et4BypfdqCZeQyQLn8DMCHS3tuE1mmCOaUnDmP
	 zetFoYsIs+aQnjRbQAO/evdVShE4LQm81lggG6Nkgm9M4T35SRjghuVxDHEDfbzWCDDaX
	 UMS/I6IQEtjYMMF7HnkJX5skkb0rUFD/f9RtyR3UV2v9lUUzvSsYC82emWU9lIc+kMUR6
	 EtuiJYzXKQJ8bnuAfmCwEP0R3jBecwvTHzncoWND1MRAZZM59OwMdsBQMcD7cyyN2Xts6
	 nKdz1a7rthIl6TF28OxL8MKLPmrver3SFG9K0mfpSAvXe2e9gVaJo0Wjdb2V2tepkZw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 3E5841F000C4;
	Sun, 22 Nov 2026 04:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795322799;
	bh=pyQU61KeZxRqKIv4fEq3sjbu3NAiZ06/nU9zOmL3X/I=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=VJ4xEBjasfMcTjsZkJqQNi3JpnOdaeX64+s3aXzb+ceWx8WfYF0quLwby2Myg7MYG
	 qc6jMyLJjN78MqBrFtlUrk/X662RoYxP9pLKu+uIGqZ19ikoZafLqSmFKBqx6s0xbl
	 2KscfNrJNnaAQZVzA0R5u1tGwDj++B4iT0R3tis+tQny1rxi0nUYaEu6SY5vmmdEUl
	 xDF2sgxOOsfZLNlORlhhFnNd5xDfE1czr0itm59nN3WGR8HUe2bLjj2IMMQaYmU/Ba
	 Gd4l8rRdi9nDYQnmVAsSfFJEjaQ22enKufltaj/MLdS1xdTORB58EQgUxIUGjbFzTZ
	 ZYjbiUoZ4PTuw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 97DF84BEDC;
	Sun, 22 Nov 2026 04:46:38 +0000 (UTC)
From: YanXin Li via B4 Relay <devnull+fadouse.pm.me@kernel.org>
Date: Sun, 22 Nov 2026 12:46:23 +0800
Subject: [PATCH v2] erofs: validate fsoffset alignment and bound page reads
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
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261122-b4-01-erofs-fsoffset-oob-v2-9c629f3ad714-v2-1-2cfb14e36120@pm.me>
X-B4-Tracking: v=1; b=H4sIAJ5zAmsC/yWNywrCMBBFf0WydjCZDGnqr4iLPCY2Io0ktSil/
 26ry3O4nLuIxjVzE+fDIirPueUyboDHgwiDG28MOW4sUKJRChE8gVTAtaQGqZWUGk9QiocZoQ8
 G+6Rd7BRB8Nqx1F2QNogt96yc8vt3dbn+ub38ncO09/eFd43BVzeGYVeVH+4DuzwFIiUpaUMYX
 YdSGZKEBjWT1Wi1cZxitCzW9QuEh/V20gAAAA==
X-Change-ID: 20261122-b4-01-erofs-fsoffset-oob-v2-9c629f3ad714-cb3ae037c08c
To: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>
Cc: Yue Hu <zbestahu@gmail.com>, Jingbo Xu <jefflexu@163.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
 Chunhai Guo <guochunhai@vivo.com>, Sheng Yong <shengyong@oppo.com>, 
 Wang Shuai <wangshuai@vivo.com>, linux-erofs@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795322797; l=7178;
 i=fadouse@pm.me; s=b4-relay-20261122; h=from:subject:message-id;
 bh=Wvl+4siWCTHC5VLaWnvqO2sRLCn+iDgqK8uK0hXOfC8=;
 b=/nf+CJBS+fU27OaAersTWTnqJ8v1KBQ51nisN8qdUoJWZiXmbE5xvy2CtsTCSWvxkHvpW+v5K
 49/2XXmC6j6D840PoK8YWrYHPV95HfNIIVC9Nm8CWkeGJrCMrp6/jNa
X-Developer-Key: i=fadouse@pm.me; a=ed25519;
 pk=b4DyzHJDRd8853IHUSKPA5wwzChj8eF4MTnZuyPz1PQ=
X-Endpoint-Received: by B4 Relay for fadouse@pm.me/b4-relay-20261122 with
 auth_id=1597
X-Original-From: YanXin Li <fadouse@pm.me>
Reply-To: fadouse@pm.me
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: YanXin Li <fadouse@pm.me>

erofs_fc_parse_param() stores an arbitrary 64-bit fsoffset= mount
option into sbi->dif0.fsoff without checking alignment, and
erofs_fc_fill_super() calls erofs_read_superblock() before checking
whether fsoffset is aligned to sb->s_blocksize.

In block-device mode, erofs_init_metabuf() sets buf->off to
sbi->dif0.fsoff, and erofs_bread() maps a single PAGE_SIZE page via
kmap_local_page() and returns buf->base + ((buf->off + offset) &
~PAGE_MASK).  erofs_read_superblock() calls erofs_read_metabuf(&buf,
sb, 0, false) and adds EROFS_SUPER_OFFSET (1024) to the returned
pointer.  When (fsoffset & ~PAGE_MASK) + 1024 + sizeof(*dsb) exceeds
PAGE_SIZE (including a valid 1024-byte-aligned fsoffset=3072 on a
1 KiB-block image, or an unaligned fsoffset=4095), dsb points past
the end of the mapped page.  On a 1 KiB-block EROFS image mounted
at fsoffset=3072, Generic KASAN reports:

  BUG: KASAN: use-after-free in erofs_fc_fill_super+0x2b04/0x36c0
  Read of size 4 at addr ffff88800f8c1000 by task test_erofs_fsof/102
  ...
  erofs_fc_fill_super
  get_tree_bdev_flags
  erofs_fc_get_tree
  vfs_get_tree
  fc_mount
  path_mount
  __x64_sys_mount

The KASAN classification reflects that the adjacent physical page was
free; the source-level operation is an out-of-page read at offset
0x1000 past the mapped folio page.  Two related out-of-page reads
occur on the same path: erofs_superblock_csum_verify() checksums up
to (1 << blkszbits) - 1032 bytes past dsb->checksum before fsoffset
alignment is checked (reading up to 2048 bytes past the page for a
4 KiB-block image at fsoffset=2048), and erofs_read_metadata() bounds
each memcpy() chunk by sb->s_blocksize - erofs_blkoff(sb, *offset)
without accounting for buf->off (reading past the mapped page during
z_erofs_parse_cfgs() even for a valid block-aligned fsoffset=2048).

Mounting EROFS on a block device requires CAP_SYS_ADMIN in the
initial user namespace.  A relevant boundary is a privileged image
mounter or container runtime passing a caller-influenced fsoffset=
option or mounting an EROFS image embedded at a sub-page block
offset.

Reject fsoffset values that are not 512-byte aligned in
erofs_fc_parse_param(), read the superblock via
erofs_read_metabuf(&buf, sb, EROFS_SUPER_OFFSET, false), verify
fsoffset alignment against (1UL << sbi->blkszbits) in
erofs_read_superblock() before erofs_superblock_csum_verify(), pass
dsb directly to erofs_superblock_csum_verify(), and clamp each copy
in erofs_read_metadata() by PAGE_SIZE - offset_in_page(buf->off +
*offset).  With this change, a valid 1 KiB-block image at
fsoffset=3072 and a valid 2 KiB-block compressed-config image at
fsoffset=2048 mount cleanly without KASAN reports, while misaligned
fsoffset=2048 (4 KiB blocks) and fsoffset=4095 are rejected with
-EINVAL before any checksum or out-of-page access.  Z3 SMT checking
confirms all three out-of-page conditions are unreachable for any
valid block size and offset after the fix.  A test case and full
validation logs are available on request.

The vulnerable code is present in upstream mainline v7.4-rc3.
Runtime verification and fix validation were performed in an x86-64
QEMU/KVM guest running v7.4-rc3 with Generic KASAN, UBSAN, and
lockdep.

Fixes: c36ec00d7f67 ("erofs: add 'fsoffset' mount option to specify filesystem offset")
Cc: stable@vger.kernel.org
Signed-off-by: YanXin Li <fadouse@pm.me>
---
Changes in v2:
- Resend via B4 Relay because the original email gained extra blank lines.
- No code changes.
- Link to v1: https://lore.kernel.org/r/20261122030055.8408-1-fadouse@pm.me
---
 fs/erofs/super.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index e92a7fa90ae..66ba9dbd8ff 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -38,9 +38,9 @@ void _erofs_printk(struct super_block *sb, const char *fmt, ...)
 	va_end(args);
 }
 
-static int erofs_superblock_csum_verify(struct super_block *sb, void *sbdata)
+static int erofs_superblock_csum_verify(struct super_block *sb,
+					struct erofs_super_block *dsb)
 {
-	struct erofs_super_block *dsb = sbdata + EROFS_SUPER_OFFSET;
 	u32 len = 1 << EROFS_SB(sb)->blkszbits, crc;
 
 	if (len > EROFS_SUPER_OFFSET)
@@ -109,7 +109,7 @@ void *erofs_read_metadata(struct super_block *sb, struct erofs_buf *buf,
 	*lengthp = len;
 
 	for (i = 0; i < len; i += cnt) {
-		cnt = min_t(int, sb->s_blocksize - erofs_blkoff(sb, *offset),
+		cnt = min_t(int, PAGE_SIZE - offset_in_page(buf->off + *offset),
 			    len - i);
 		ptr = erofs_bread(buf, *offset, true);
 		if (IS_ERR(ptr)) {
@@ -268,16 +268,14 @@ static int erofs_read_superblock(struct super_block *sb)
 	struct erofs_sb_info *sbi = EROFS_SB(sb);
 	struct erofs_buf buf = __EROFS_BUF_INITIALIZER;
 	struct erofs_super_block *dsb;
-	void *data;
 	int ret;
 
-	data = erofs_read_metabuf(&buf, sb, 0, false);
-	if (IS_ERR(data)) {
+	dsb = erofs_read_metabuf(&buf, sb, EROFS_SUPER_OFFSET, false);
+	if (IS_ERR(dsb)) {
 		erofs_err(sb, "cannot read erofs superblock");
-		return PTR_ERR(data);
+		return PTR_ERR(dsb);
 	}
 
-	dsb = (struct erofs_super_block *)(data + EROFS_SUPER_OFFSET);
 	ret = -EINVAL;
 	if (le32_to_cpu(dsb->magic) != EROFS_SUPER_MAGIC_V1) {
 		erofs_err(sb, "cannot find valid erofs superblock");
@@ -289,6 +287,11 @@ static int erofs_read_superblock(struct super_block *sb)
 		erofs_err(sb, "blkszbits %u isn't supported", sbi->blkszbits);
 		goto out;
 	}
+	if (sbi->dif0.fsoff & ((1UL << sbi->blkszbits) - 1)) {
+		erofs_err(sb, "fsoffset %llu is not aligned to block size %lu",
+			  sbi->dif0.fsoff, 1UL << sbi->blkszbits);
+		goto out;
+	}
 	if (dsb->dirblkbits) {
 		erofs_err(sb, "dirblkbits %u isn't supported", dsb->dirblkbits);
 		goto out;
@@ -296,7 +299,7 @@ static int erofs_read_superblock(struct super_block *sb)
 
 	sbi->feature_compat = le32_to_cpu(dsb->feature_compat);
 	if (erofs_sb_has_sb_chksum(sbi)) {
-		ret = erofs_superblock_csum_verify(sb, data);
+		ret = erofs_superblock_csum_verify(sb, dsb);
 		if (ret)
 			goto out;
 	}
@@ -569,6 +572,10 @@ static int erofs_fc_parse_param(struct fs_context *fc,
 			clear_opt(&sbi->opt, DIRECT_IO);
 		break;
 	case Opt_fsoffset:
+		if (result.uint_64 & (SECTOR_SIZE - 1))
+			return invalfc(fc,
+				       "fsoffset %llu is not 512-byte aligned",
+				       result.uint_64);
 		sbi->dif0.fsoff = result.uint_64;
 		break;
 	case Opt_inode_share:
@@ -758,9 +765,6 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 			return -EINVAL;
 		}
 	}
-	if (sbi->dif0.fsoff & (sb->s_blocksize - 1))
-		return invalfc(fc, "fsoffset %llu is not aligned to block size %lu",
-			       sbi->dif0.fsoff, sb->s_blocksize);
 
 	if (test_opt(&sbi->opt, DAX_ALWAYS) && sbi->blkszbits != PAGE_SHIFT) {
 		erofs_info(sb, "unsupported blocksize for DAX");

---
base-commit: c44104f3642da720164042623e4832836aefdd8e
change-id: 20261122-b4-01-erofs-fsoffset-oob-v2-9c629f3ad714-cb3ae037c08c

Best regards,
--  
YanXin Li <fadouse@pm.me>



