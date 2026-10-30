Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922DC606A31C
	for <linux-erofs@archiver.kernel.org>; Fri, 30 Oct 2026 03:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XHdkd5og
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jG6cy4SSnz2y32;
	Fri, 30 Oct 2026 14:52:50 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip=172.234.252.31 arc.chain=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793332370;
	cv=pass; b=DdsVjZdi1HYHnzdLObuKqZhK45frRH4Z+j0/N/QLJtJBDe9K3E15pGp9u86qATiABfUReH+u8G5Q35CIL2hIJPGW0u/njR4kg97UXmgQXr27AE2HVNWj/0lWmH9Tpch57JjRl/vXy7eZK1lTNKPQ8pbGqBF2YOKXzjJPNNWr5hOObRduPJwoT8pTBf0xqjp0DgS1sLoARg40wM5p7HLdtN38oLv16EMVyi6PuPoGbPBl1XEOsRg4gnkY6L5Vhdx2YqB1NZE/h8gYp++CStEGtd0y86sDEtTuukKOEumjpa2O7i1f5rgtldJFQ+CVoUtDXendSX9Bz5dnEuhvFfC/BQ==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793332370; c=relaxed/relaxed;
	bh=iysMAEzBYuRpLgnQMNCkF8C+wwy010ieTKcmJAPE1LY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=lm3ZI0nULDMGNdWgZOhcFrCq3CQMpxTIdDst2SiHrEbHb19BozkugIhWFSXAgzbMSSytCBRiNx2iTWf+YZi9MIjgGbSCNrJjxdbv+udU3tyei+h6/ZrxQ0u5lLKtrFkYAgSoyh25VyRFH1KALUfdiAKLZhtI93dony5H2l3+FT+edqJEi81SW19B0KntYy6TlKC3Nvin6E7+Zng2zjnGqYMClqMoPcUzvMzgqpaWCz2OvkseFjhbNCkTacUe+260GyLrtXH5mpmibe4wkJBkRniiEFtQ66aiJ7dK1Cpih7QMHY/0pXd3kMcCcv+63hjOmyet5wq+gljEyeQN8fIJlg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XHdkd5og; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=devnull+daejun7.park.samsung.com@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XHdkd5og;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=devnull+daejun7.park.samsung.com@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jG6cx0wzwz2xqh
	for <linux-erofs@lists.ozlabs.org>; Fri, 30 Oct 2026 14:52:48 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B81040284;
	Fri, 30 Oct 2026 03:52:45 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793332365;
	b=NIAFCn6Gp942P6YuC4F1Rck4ykmuGKnOhUV0THIcHm/9OAzp2Gk8z4bspeZCt3h1QNB+
	 hSNgaXJqJlItvJE8fihRXRiWHlc5mlVSh3NrcxUGf15om0jzHHgiRM4QmfWETHAG0Y99+
	 OPckIrlPesQJDuGq94ixnfGA9Xua3bd1oObWBtYej5lNV/EVZmNBKalyRQqkRCa5z/SBX
	 hMh1AJAiwU7RL7ix7h4B1ZOFU3hXKlApDaCPvkW/wpWlusaCBhakw4B2/ar3V+o7tOLFg
	 NPbqd5zVoVeB7/Px9umfDuZY6mFcGvnWr2xdx+uZXYBzErcXJFMbIe839fOijXCEdew==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793332365;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To:
	 Content-Transfer-Encoding;
	bh=iysMAEzBYuRpLgnQMNCkF8C+wwy010ieTKcmJAPE1LY=;
	b=M7Kw+saMKBhIJM8P0O5CmEEIRtVx73GB/noMs0wff7/Dk4ONciuZeOI6fI2tIixno9Az
	 BhyWIHappbAk6JC27FRu8HOSjwD9xCI5sraGeA6GynAe7lPoZiGZCUNnNg4UJ6G+EjNeE
	 ixzc5uJRvoRh90SbuVmhmyOr85F3Ox2mDdZ9uZJlU1A/fVpF6mKA2r1xfabGasHXXqVUp
	 W5L5skiDy6cDkt2VRHfedOVTt+Mgy0RZylVh5HjP0N1vamkPrG2uWRtR+l9VRweJud3A1
	 y/X+JJvgGcfNsM9epI0t5sRNlRAZ7yykoM8QSAxx86kOTCgE73uVocP2I+xj6iSSadA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id CC5FF1F000C1;
	Fri, 30 Oct 2026 03:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793332365;
	bh=iysMAEzBYuRpLgnQMNCkF8C+wwy010ieTKcmJAPE1LY=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=XHdkd5og36XBX6Y0CKOirURH4O86UuKspW7B0vwL6GEdcv9KiUKw9f5b0BF1Jw1av
	 sKkNAjmnbVli9io0JC42m2CgBPk6EMScyP3JZcE9TA63WImPALjQwsinIvIwdoDOm/
	 DyHIWmqL3dO8guWKZRkLc8pgzSTzqVyIuUzQzjDYlc5d4MWlBwes22sziV4dCbxSPb
	 vNARyKDxLW25rSzGASzokJFfvsbcREraKe5lQprsSfoR8Zwv2maAQ1fqfupwfHGI7W
	 +bWLU3ffIhlH8WzROEIfHQHXejit1DaIdO042LqyK5oA3K6uB13rSJ3JpBZcNq73jI
	 MrzLVQsK3iEVw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 293474363D;
	Fri, 30 Oct 2026 03:52:44 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Fri, 30 Oct 2026 12:52:44 +0900
Subject: [PATCH] erofs: apply the stacked fs check to extra file-backed
 devices
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
Message-Id: <20261030-erofs-stacked-extra-devices-v1-1-39f7df7ac01b@samsung.com>
X-B4-Tracking: v=1; b=H4sIAIsU5GoC/x3MQQqDQAxA0atI1g1MRrGlV5EuwiTaUNCSiAji3
 R1cvsX/B4S6acC7OcB1s7BlrqBHA+XL86RoUg055Z5SfqH6MgbGyuWngrqvzig1LBooT6aOhBO
 1LdTD33W0/b4Pn/O8AHOgu11tAAAA
To: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>
Cc: Yue Hu <zbestahu@gmail.com>, Jingbo Xu <jefflexu@163.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793332363; l=2715;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=ewjS8koWFn8Z4rafq/egOLIaNXTnJqYTfaJQKrbMB9s=;
 b=Bxud52oBS6RR96umz1PtXO37YvER3b+2EfdcZL8t9uPHVWsq+/Uz3ePCKWAOKbZTXGR7NGnva
 nFn3KIa7gzFAP/HdYKb9DQZFWkBJqKLaV5LyPa3JI2b8LA9yVJcSgKT
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Daejun Park <daejun7.park@samsung.com>

erofs_fc_fill_super() rejects a file-backed mount whose image is on a
file-backed EROFS or on a filesystem with s_stack_depth set. This
bounds the nesting of reads. Extra devices given by device= are not
checked. File-backed mounts can still nest through them without limit.

Apply the same check to extra devices.

Fixes: fb176750266a ("erofs: add file-backed mount support")
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
Tested on erofs dev in a QEMU guest with KASAN and lockdep:

- Blobs on a file-backed EROFS or overlayfs now get -EINVAL.

- Blobs on XFS or a loop-mounted EROFS still mount and read back.

- Lockdep warns about devs->rwsem vs i_rwsem for a device= path inside
  an EROFS mount, with or without this patch.
---
 fs/erofs/super.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index ce05557bd9..ee01a5ef85 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -122,6 +122,14 @@ void *erofs_read_metadata(struct super_block *sb, struct erofs_buf *buf,
 	return buffer;
 }
 
+/* see the comment in erofs_fc_fill_super() */
+static bool erofs_is_stacked_file(struct file *file)
+{
+	struct super_block *sb = file_inode(file)->i_sb;
+
+	return (sb->s_op == &erofs_sops && !sb->s_bdev) || sb->s_stack_depth;
+}
+
 static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
 			     struct erofs_device_info *dif, erofs_off_t *pos)
 {
@@ -161,6 +169,11 @@ static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
 		} else if (!S_ISREG(file_inode(file)->i_mode)) {
 			fput(file);
 			return -EINVAL;
+		} else if (erofs_is_stacked_file(file)) {
+			erofs_err(sb, "%s: file-backed devices cannot be on stacked fses",
+				  dif->path);
+			fput(file);
+			return -EINVAL;
 		}
 		if (!dif->dax_dev && test_opt(&sbi->opt, DAX_ALWAYS)) {
 			erofs_info(sb, "DAX unsupported by %s. Turning off DAX.",
@@ -701,9 +714,7 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 		 * It MUST change if another fs plans to support them, which
 		 * may also require adjusting FILESYSTEM_MAX_STACK_DEPTH.
 		 */
-		inode = file_inode(sbi->dif0.file);
-		if ((inode->i_sb->s_op == &erofs_sops &&
-		     !inode->i_sb->s_bdev) || inode->i_sb->s_stack_depth) {
+		if (erofs_is_stacked_file(sbi->dif0.file)) {
 			erofs_err(sb, "file-backed mounts cannot be applied to stacked fses");
 			return -ENOTBLK;
 		}

---
base-commit: 209108a5456171ab430e25b54b2dfe083455bfb6
change-id: 20261028-erofs-stacked-extra-devices-d7a141da0133

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>



