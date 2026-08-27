Return-Path: <linux-erofs+bounces-4353-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B79AC61DBD
	for <linux-erofs@archiver.kernel.org>; Thu, 27 Aug 2026 02:06:53 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hVlJD0TlZz2xWY;
	Thu, 27 Aug 2026 12:06:52 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::1029"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787796411;
	cv=none; b=nBV1+cidRiCKLkbjHXsTLHjsynRUFBqqk+gtWUemwt7O8xih0yBU5Tm7GBqL2vqcm51oaDserEyLPsenpUrBqjD0Hr7rQES4sSGlZOJR1MFAcjWe3UdUNhkpFH41hX2BGlNKsBgj37rS3BT+qWcylEhY4lI1lPAo12Gr+YabuuKwRucWm4qQ00Mo8fmvJS6epe+cqkxk86Jd79+rujzqiR0QDALwTsHZyOfj1IwltB7+ZLZEjJIuT3VD3efcLZP7LjkbCWym4m6/u+NdnyBJYOhh7ArmSE0jdWof6/ppC1CY0O8341Bi2UBOWgdTbzJ2obOvT2UnVT20cSt2q5dBTw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787796411; c=relaxed/relaxed;
	bh=t9hzZqjJ1DQhJU2KnYeEURVUo1IxO2R21wKwoHqdIEY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OJMs4eVhk9WlzpXKE1fa5929736zd+2XvcOclMfXwjx4LhpS+xPdVBXKyyHCAyeTCfc+JdXAItXhtBoYoYsBKtmpiDCL6A7R9QVMqVq3rd/WEuOVDqoNuVsxsiLFRXKRafuY1zDyuS6xmDjqwZCwkvafTOhdQMRW44hv7H6Zo+uC3Iacdsaciy1GXFyCWPWThZXIDi1cv7B3GVFXIe6L5QBM95FMDf18/imVF3pcoHCr0O5cAd/iOCo0ooeIADD6dVhjF4xsqJdY3OzCi/KQnQOFonjRBz014oLlaDx6dc88C6gxnadqUfr0Sgg1yRU9Ekew4bILO9CFtp71a/IB3Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=C1bHShJf; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1029; helo=mail-pj1-x1029.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=C1bHShJf;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1029; helo=mail-pj1-x1029.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hVlJB6GBjz2xLG
	for <linux-erofs@lists.ozlabs.org>; Thu, 27 Aug 2026 12:06:49 +1000 (AEST)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-38dfe7eb825so1549865a91.0
        for <linux-erofs@lists.ozlabs.org>; Wed, 26 Aug 2026 19:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787796407; x=1788401207; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=t9hzZqjJ1DQhJU2KnYeEURVUo1IxO2R21wKwoHqdIEY=;
        b=C1bHShJfR4uEAFMa82apf1cXv7iHugnOPIy2c5O3J41x1OEWXrqpy+jWa2SCZ/VpcO
         Frdc1l+JlurvO0bQ5Xj9ORtfXHPXA7SgFW92GrbhSL1hky0oQndHQGFlmg8jfIkq7h2P
         msV/D4g4eh93pSpXQvXCbWzd0S8uLURqm3oEB3LRqNv2K7B8SWEpNzNLDoTq4f1UMOOS
         QO9agI3X+EpRD+sdGlFqdbCpWtfFZ50DBPzh21tnQWZfIKhsiH6SOtc/M6bcrFDP+tVs
         YiiAcCum5gcGOGkvb4nIajh2IZHGFIzFKIIElS/vVHRUMhRwECHrtLmRVOjznXbPLsB6
         GETA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787796407; x=1788401207;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t9hzZqjJ1DQhJU2KnYeEURVUo1IxO2R21wKwoHqdIEY=;
        b=DB7caUBFjvpq/a5eQRQFbm95LiRKykjIV2iNMcyM1v1qUrYWZ93X2Y6rYxQc34oJIy
         uaE61+obw25jMx8OdgnqLPrP7rMESBxLcOdg/zFOZ8pj4YzYDWF0HCfC0e+ZRySd6O3A
         F5k7T+zPBbGsfs8aU2YyMW5SMxvBqhSElFMmxZvQUjKbM61QxUJUtgaArBMMpVLJRdUR
         bm35CYvsJnjtcRAPQDsnrCwcQZzTVbIbdqRkm6WgJnjFpVI1HmvxahQoZWc6Rhs3NPgn
         4BPZgNMYZyWh4qvPhUcyAXvBcPtVOuOEkKH0LB9U0VzcJplzd9hWRZKBsiAYF9tThOs0
         Wmjg==
X-Gm-Message-State: AFuF++m5JHgVoENgrRwrv2jo4GgqAqPCAkgO9kG6JlhZEblQ1pNt3DHK
	OxXe90aSKETBUax4CnIl+wNL4lKtOUnszFwWLRr1Cvd7DymwYN3AurVRDjeuMhUxP5A=
X-Gm-Gg: AR+sD11Nud0n+fQe55fgBQ/XasD+Fb+0AflnTpQa2nhsfPrvMJBsfyYtPW3gSq4QfVp
	UJV6qcPirrdixwOJissiptD22MyNkBUryf5udigf6YiyPFW4HaIkY+WBDdPRrxjFg+Jm+WIZb26
	GZmtCSXcBJgknVMBMzx+zRCDGr4u0ndxLoS36elPkoWCy1CNJn/F96TZAMaXtD+MHDIT1s7rZpv
	VDRpZgKXnQuQqZU1GdYBDksdgqr0w0Ze59wUyZFFOtdbGJ6dVclIFpod1MehwcuW78l5yuDPc4r
	suSri4rwKmQVqz62YhoOVsupS9SpcMIf18+zm2mVe9DX4td/ah97HMf4GnnPQJtNPYaaA/N2iFY
	ErvaDMD98/jOFDMIeNVBami082Oo/Gj68W9Ts8dYY7biMbDGbNRWWA7iwsti+HaV9N8PXhjp5Wk
	5RFZmUOqu2QLlr9VMNSwoXjWAY3qwNlofvQO8bqB6EKgABuRAgbkiHbHsXui/t0be1iIa5917Ab
	p/dq3PybY8gIE1p7x3PmFBVX5AOwlBN352pNj8=
X-Received: by 2002:a17:90b:380b:b0:38d:ddc2:7ccb with SMTP id 98e67ed59e1d1-3966d13a242mr21430202a91.1.1787796407087;
        Wed, 26 Aug 2026 19:06:47 -0700 (PDT)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b186807bsm616944a91.12.2026.08.26.19.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 19:06:46 -0700 (PDT)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org,
	xiang@kernel.org
Cc: Yifan Zhao <stopire@gmail.com>
Subject: [PATCH] erofs-utils: fix incorrect field conversions
Date: Thu, 27 Aug 2026 10:06:29 +0800
Message-ID: <20260827020629.1305900-1-stopire@gmail.com>
X-Mailer: git-send-email 2.55.0
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

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 dump/main.c    | 4 ++--
 lib/compress.c | 4 ++--
 lib/gzran.c    | 4 ++--
 lib/inode.c    | 2 +-
 lib/namei.c    | 2 +-
 lib/super.c    | 2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/dump/main.c b/dump/main.c
index 9eebcb8..28f104b 100644
--- a/dump/main.c
+++ b/dump/main.c
@@ -694,7 +694,7 @@ static void erofsdump_show_superblock(void)
 	for (i = 0; i < ARRAY_SIZE(feature_lists); i++) {
 		if (!feature_lists[i].compat)
 			continue;
-		if (le32_to_cpu(g_sbi.feature_compat) & feature_lists[i].flag) {
+		if (g_sbi.feature_compat & feature_lists[i].flag) {
 			fprintf(stdout, "%s ", feature_lists[i].name);
 			if (feature_lists[i].lkver > minkver)
 				minkver = feature_lists[i].lkver;
@@ -704,7 +704,7 @@ static void erofsdump_show_superblock(void)
 	for (i = 0; i < ARRAY_SIZE(feature_lists); i++) {
 		if (feature_lists[i].compat)
 			continue;
-		if (le32_to_cpu(g_sbi.feature_incompat) & feature_lists[i].flag) {
+		if (g_sbi.feature_incompat & feature_lists[i].flag) {
 			fprintf(stdout, "%s ", feature_lists[i].name);
 			if (feature_lists[i].lkver > minkver)
 				minkver = feature_lists[i].lkver;
diff --git a/lib/compress.c b/lib/compress.c
index 9262afa..9bbb127 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -2153,9 +2153,9 @@ static int z_erofs_build_compr_cfgs(struct erofs_importer *im,
 		} __packed zalg = {
 			.size = cpu_to_le16(sizeof(struct z_erofs_deflate_cfgs)),
 			.z = {
-				.windowbits = cpu_to_le32(ilog2(
+				.windowbits = ilog2(
 					max_dict_size
-						[Z_EROFS_COMPRESSION_DEFLATE])),
+						[Z_EROFS_COMPRESSION_DEFLATE]),
 			}
 		};
 
diff --git a/lib/gzran.c b/lib/gzran.c
index 3973c1f..a75756c 100644
--- a/lib/gzran.c
+++ b/lib/gzran.c
@@ -208,7 +208,7 @@ struct erofs_gzran_iostream {
 	struct erofs_vfile *vin;
 	struct erofs_gzran_cutpoint *cp;
 	u32 entries;
-	u32 span_size;
+	u64 span_size;
 };
 
 static void erofs_gzran_ios_vfclose(struct erofs_vfile *vf)
@@ -346,7 +346,7 @@ struct erofs_vfile *erofs_gzran_zinfo_open(struct erofs_vfile *vin,
 	ios = (struct erofs_gzran_iostream *)vf->payload;
 	h = zinfo_buf;
 	ios->entries = le32_to_cpu(h->have);
-	ios->span_size = le32_to_cpu(h->span_size);
+	ios->span_size = le64_to_cpu(h->span_size);
 
 	v2_size = sizeof(*c) * ios->entries + sizeof(*h);
 	if (!len || v2_size == len) {
diff --git a/lib/inode.c b/lib/inode.c
index 0547b60..a69439c 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -851,7 +851,7 @@ int erofs_iflush(struct erofs_inode *inode)
 
 		u.dic.i_uid = cpu_to_le16((u16)inode->i_uid);
 		u.dic.i_gid = cpu_to_le16((u16)inode->i_gid);
-		u.dic.i_mtime = cpu_to_le64(inode->i_mtime - sbi->epoch);
+		u.dic.i_mtime = cpu_to_le32(inode->i_mtime - sbi->epoch);
 		u.dic.i_u = u1;
 
 		if (nlink_1) {
diff --git a/lib/namei.c b/lib/namei.c
index f19e4b1..9d04693 100644
--- a/lib/namei.c
+++ b/lib/namei.c
@@ -96,7 +96,7 @@ int erofs_read_inode_from_disk(struct erofs_inode *vi)
 		vi->i_nlink = le32_to_cpu(die->i_nlink);
 
 		vi->i_mtime = le64_to_cpu(die->i_mtime);
-		vi->i_mtime_nsec = le64_to_cpu(die->i_mtime_nsec);
+		vi->i_mtime_nsec = le32_to_cpu(die->i_mtime_nsec);
 		vi->i_size = le64_to_cpu(die->i_size);
 		break;
 	case EROFS_INODE_LAYOUT_COMPACT:
diff --git a/lib/super.c b/lib/super.c
index d138f84..e263f65 100644
--- a/lib/super.c
+++ b/lib/super.c
@@ -212,7 +212,7 @@ int erofs_writesb(struct erofs_sb_info *sbi)
 		.rb.rootnid_2b  = cpu_to_le16(sbi->root_nid),
 		.inos      = cpu_to_le64(sbi->inos),
 		.epoch     = cpu_to_le64(sbi->epoch),
-		.build_time = cpu_to_le64(sbi->build_time),
+		.build_time = cpu_to_le32(sbi->build_time),
 		.fixed_nsec = cpu_to_le32(sbi->fixed_nsec),
 		.meta_blkaddr  = cpu_to_le32(sbi->meta_blkaddr),
 		.xattr_blkaddr = cpu_to_le32(sbi->xattr_blkaddr),
-- 
2.55.0


