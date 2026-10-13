Return-Path: <linux-erofs+bounces-4733-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAD7ECA9ED2
	for <linux-erofs@archiver.kernel.org>; Tue, 13 Oct 2026 11:49:43 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3t122ZDYz3brx;
	Tue, 13 Oct 2026 22:49:42 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=35.83.148.184
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791892182;
	cv=none; b=VDuTKU58eneYpCGL5yYB0pKXxRzEuNPoJtJapLeC697tvLEdpP0nrkpzKhgtfusLJTTjPBtWU06BXUkGgD+ybqqI9szmpoQ2EYtEcN+/xaf+MM6fV0WmFDfUWO+mpw1u/BcWzvW5UNguJ8jM0mVNUrLgrFusew/JzVa7T3bBu98OTxrI9pdXWWm8NdEkueVX9/bzS6tP3qY2PrxNTKmgzR8h/XLo9F0Pj4204c/uhxt6FQ6iC1mdzgTMLxpRAhfAYhx992dHi5WZ+cKmOZQLVhRvoCpaWSKKuVjRIjBpGehlo6Bbr5HmAgvPgTtYfsTkoyyZgMl5Mb0yV0gWaUB73g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791892182; c=relaxed/relaxed;
	bh=d1/3CR8iNFzg6a+c2iFJKHRtJ9jB+pXXqdrPAFY9eqQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XnHZWwGbUDYxMijBz7yknp2bc8HkPs88AbqyZn30By932nRdhBVSc70kUEbG1DQoUyCV47ZXsaGcbBZkGJu1TBsbhP7VtnYiT9FIsi+3mNgK38H9mkS2Kp+JZMCKL0DNZ1JBPllPt8zp/La76zk33rpKzwcUjQO6sreoCd5ciRrjPcqxBb6vR2lD71iGQ7CclVUJ/7cSl/DxF/AqpCQBIMS5rKH+WHrbjLAro9OU7aFdm3h9jpeIDOpa1jOsgfU1KyIe6jwuqMKFGA2xObvbvkYpsMQR7hyFgyExKT2Pz+M922a/jyEZQXwSdOOpTlVxzEC2jew7IjC0t714zZDBig==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; dkim=pass (2048-bit key; unprotected) header.d=amazon.de header.i=@amazon.de header.a=rsa-sha256 header.s=amazoncorp2 header.b=ci+rxSLn; dkim-atps=neutral; spf=pass (client-ip=35.83.148.184; helo=pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com; envelope-from=prvs=739b1bba0=gyokhan@amazon.de; receiver=lists.ozlabs.org) smtp.mailfrom=amazon.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amazon.de header.i=@amazon.de header.a=rsa-sha256 header.s=amazoncorp2 header.b=ci+rxSLn;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amazon.de (client-ip=35.83.148.184; helo=pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com; envelope-from=prvs=739b1bba0=gyokhan@amazon.de; receiver=lists.ozlabs.org)
Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3t101BdNz3brr
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 22:49:39 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1791892180; x=1823428180;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=d1/3CR8iNFzg6a+c2iFJKHRtJ9jB+pXXqdrPAFY9eqQ=;
  b=ci+rxSLni4BH/aiDIeDleRnojQ0texCKeO2Xasx22oJLhjPr6HeT/bNc
   x3tA4yWKQA8hBXnpbijyHwH4hvN1fgqPbAFsgPmscgtm5DtccJOnZRGsG
   IhVXfl4Bir7ZAJRa7hZQQP0DmXgbEJPcWsTfjF5KauZcsiMmMNNU5b3wH
   lR95ijFXL9keZbVtpIi0+pUXNYfzfIgFBW5H2rPB4tvYwK1whbhj9MxMB
   hoWGmQhIujatXPM58eohR2iw4KlwH0RcVsOtUGzHcrZp6SEZq6H5Sx1xJ
   N/WaWn54rbY38DuZdmG7jagBXvJ/XHH+yvV62b1Q52Mwtq/G5D+nk7Y66
   w==;
X-CSE-ConnectionGUID: +hVgvGnySviiWalscu6ICg==
X-CSE-MsgGUID: A66rsOw7TTWNZ0M0YLN++w==
X-IronPort-AV: E=Sophos;i="6.27,155,1787011200"; 
   d="scan'208";a="30918700"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2026 11:49:34 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:24991]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.1.91:2525] with esmtp (Farcaster)
 id d5f6198b-e63f-4fd2-a0c5-44c5a33f4cee; Tue, 13 Oct 2026 11:49:34 +0000 (UTC)
X-Farcaster-Flow-ID: d5f6198b-e63f-4fd2-a0c5-44c5a33f4cee
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Tue, 13 Oct 2026 11:49:33 +0000
Received: from dev-dsk-gyokhan-1a-87ab81cc.eu-west-1.amazon.com
 (10.253.85.128) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.53; Tue, 13 Oct 2026
 11:49:31 +0000
From: Gyokhan Kochmarla <gyokhan@amazon.de>
To: <linux-erofs@lists.ozlabs.org>
CC: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu
	<zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale
	<dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, Chunhai Guo
	<guochunhai@vivo.com>, <stable@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Gyokhan Kochmarla <gyokhan@amazon.de>
Subject: [PATCH] erofs: use on-disk blkszbits for lz4 max pcluster bound
Date: Tue, 13 Oct 2026 11:48:52 +0000
Message-ID: <20261013114852.174175-1-gyokhan@amazon.de>
X-Mailer: git-send-email 2.50.1
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
Content-Type: text/plain
X-Originating-IP: [10.253.85.128]
X-ClientProxiedBy: EX19D031UWA004.ant.amazon.com (10.13.139.19) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

z_erofs_load_lz4_config() rejects a valid LZ4 image when the kernel's
page size differs from the image's block size. It bounds the on-disk
max_pclusterblks with erofs_blknr(sb, Z_EROFS_PCLUSTER_MAX_SIZE), which
expands to Z_EROFS_PCLUSTER_MAX_SIZE >> sb->s_blocksize_bits.

At the point this runs, sb->s_blocksize_bits still holds PAGE_SHIFT:
erofs_fc_fill_super() seeds s_blocksize_bits to PAGE_SHIFT before
reading the superblock, and only corrects it down to the on-disk
blkszbits after erofs_read_superblock() returns. The LZ4 config is
parsed inside erofs_read_superblock(), before that correction, so the
bound is computed with the wrong shift.

On a 64K-page kernel mounting a 4K-block image (e.g. one built with
mkfs.erofs -C 262144 on a 4K-page host), the bound evaluates to
1 MiB >> 16 = 16 blocks instead of the correct 1 MiB >> 12 = 256
blocks. The image's legitimate max_pclusterblks of 64 then fails the
check, mount returns -EINVAL, and booting from such an image as the
root filesystem panics:

  erofs (device dm-0): too large lz4 pclusterblks 64
  Kernel panic - not syncing: VFS: Unable to mount root fs

sbi->blkszbits already holds the on-disk block size at this point, so
compute the bound from it directly. This makes the check independent of
the host page size and of superblock-parse ordering.

commit 3acea5fc3354 ("erofs: avoid hardcoded blocksize for subpage block
support") already handled the same ordering hazard for the superblock
checksum path by using sbi->blkszbits in erofs_superblock_csum_verify();
the lz4 config path was missed.

Fixes: 3acea5fc3354 ("erofs: avoid hardcoded blocksize for subpage block support")
Cc: stable@vger.kernel.org
Assisted-by: Kirocrew:gpt-5.6-sol
Signed-off-by: Gyokhan Kochmarla <gyokhan@amazon.de>
---

Tested on arm64 (Graviton) with CONFIG_ARM64_64K_PAGES=y (64K pages),
mounting an LZ4 EROFS image built on a 4K-page host with 4K blocks and a
large pcluster (mkfs.erofs -zlz4 -C 262144 -b 4096, max_pclusterblks=64):

  - Before: mount fails, dmesg "erofs: too large lz4 pclusterblks 64".
  - After:  mounts cleanly; file contents verified byte-for-byte.

A 4K-page kernel mounts the same image before and after (no regression).

 fs/erofs/decompressor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index 3c54e95964c9..00055d103da9 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -27,7 +27,7 @@ static int z_erofs_load_lz4_config(struct super_block *sb,
 		if (!sbi->lz4.max_pclusterblks) {
 			sbi->lz4.max_pclusterblks = 1;	/* reserved case */
 		} else if (sbi->lz4.max_pclusterblks >
-			   erofs_blknr(sb, Z_EROFS_PCLUSTER_MAX_SIZE)) {
+			   Z_EROFS_PCLUSTER_MAX_SIZE >> sbi->blkszbits) {
 			erofs_err(sb, "too large lz4 pclusterblks %u",
 				  sbi->lz4.max_pclusterblks);
 			return -EINVAL;
-- 
2.50.1


