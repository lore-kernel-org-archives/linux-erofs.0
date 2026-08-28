Return-Path: <linux-erofs+bounces-4359-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDCACC61DC6
	for <linux-erofs@archiver.kernel.org>; Fri, 28 Aug 2026 08:29:45 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hWWlW3MXWz2xlw;
	Fri, 28 Aug 2026 18:29:43 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::529"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787905783;
	cv=none; b=nH/CfUtBlyzJMJk+vn2POO6vU6n2MrjfzeSHGUgvN9ywkuixB93y+ciYmW6hacgHUEZinjIGp9EkKtuRktUU/cb0fbaHL0eno21VSbnp9YDPtXgvPfyj/rg+MDQDnzLqDZH0N6j+uqZjXE8jPkY2tewFS2xh4yHx9hHVhol+w9c1nliQoPwscbU7HPms6qo3yT0ubD0uksecWmYSSag9kRCptFQrxwssdqTnQzCGU14pwA1LQWtC2ZBY0fcRZmVW6ONG5mJG3wU9TYqT7xI8crF82E+nK48zA9L9ymCBeJ9HF09v4oU8JEhkyOnY+1R8vb0XoQaCmtDi3eSf5pVcnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787905783; c=relaxed/relaxed;
	bh=gDHilEvtPHK2Vxd0gYLHlN4AcBdNt4q/vaPNeJoJC5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gY0Z2UHW6pdaVXtvcy0uP9ncIJtMpDtOnOI014C9eaZjUgkWdy1SPmQ6QKL8/5E+mJhRpU4n6XQRTFWALKNtTvF4Fq25MIdoGOA+EjDlSDT3sb7yed/epEZbvBvBoEc8DEymSCTwn5P31YVJUIHx0hZAFHr2V1waceualUl04koQ76+KkA7DMoPCsjjW1KSL+GzOk9Y7p3MGjNjc7xcgm+q2vRBymhohwX8kL8VaEfZMnkMVdlfb1Lt2n7f57vhTZmVLGKAnT1c4qzzHGZNJtSLYJ8AoCQAf1YsUQOxuEKTuxvXUJ2gkWn9blRFTXmPVEVJ3IAYO7kzX7UhFx//eZA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=mkpc8SAK; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::529; helo=mail-pg1-x529.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=mkpc8SAK;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::529; helo=mail-pg1-x529.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hWWlT3FDjz2xLG
	for <linux-erofs@lists.ozlabs.org>; Fri, 28 Aug 2026 18:29:40 +1000 (AEST)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-cc1c73645a1so602828a12.1
        for <linux-erofs@lists.ozlabs.org>; Fri, 28 Aug 2026 01:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787905777; x=1788510577; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gDHilEvtPHK2Vxd0gYLHlN4AcBdNt4q/vaPNeJoJC5Q=;
        b=mkpc8SAKxAxnadlp5/TTeg5C8Y2aXEB87FDDAdDIbUDfnDTEBt36+8YSk3FiDuwnbR
         IApGfk0+HiUBCwxQTMd0icOTDoOlxl4Apo8ZTctPkUyDm4wSu/8dwmW1ZEd6cqvWcGb3
         cx7zstu8HTDrgD42EHjw60GxkcuAjuFzw40kxMwDFoilWBNKZCMP/PFIecQWUBCXGDq/
         N4ZNezEJYKpzh0i9aXEEfxbZmv+vvde9pcPRA7T8uHGq3sMvTqJX5wTyvTsDwNfdkV5r
         M2cDReYL1UNoOeTM9OjRB3efO6BfhTOzwiat1Ao06XpE430kBU942K7xMIIr3iRy20TT
         9vyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787905777; x=1788510577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gDHilEvtPHK2Vxd0gYLHlN4AcBdNt4q/vaPNeJoJC5Q=;
        b=cqfmvGi8NYJRIJUh5hzBwPQO70OYMnl6SZ6HPxbw2v/HGIdmSUri0I1xjRs0EKnHsO
         VtCiXL59pOjG7RiRhp/0ryfsStQz9h8a0/N2d7DKAnM83uoFGLUfOkvN4PcA67I4XTsk
         5gxJT1jdaetYoFZFd4kQyYpOUdxj7EaOB//MpMC08F77ZY2wZoJzowErrn/D7cSPb+4/
         oIIY0qYylhnFvLiZnZleEUvdVNQ9oi8tlM73RwurTlouY5GzM7fZaWKXE0uEOiAjWBq5
         g+X/7tqSSEVOLvNJix34iRdom8r4/3I7Jt9FkysPzcxMxR15/FqmBnjdoLuVOF0t5OMh
         vbVQ==
X-Gm-Message-State: AFuF++nqC9Dh5wew/3sV7IPM0ryOQeRE/JgVProjviIMH4H4+7LKBxSk
	+pE10nA/05I5/e1IeBocx/qjKx/v9GjgfBcEntsvLCO3lgUdKbVp45xF1/6pxAKf
X-Gm-Gg: AR+sD13sgWr72GPg8tHByGP/q/1Q4alIkV89hjWXyQeCVHChyP0YCeNicOzlj/QTTrf
	TD7/h83VHa+TBV6G7oOF0tVN/gJySx+Qv+QKxNttj7U/sQyh39ggp6sqokn9T7hfzbztkiJsvOz
	V9fewGHQx+ethAbLUhrKrBdT8gX6uhNN6XEypW3rpypA5U0eUF/jGhA3rWqqiHhVm08N0GP0Bm+
	9nOxg0Qqpg35pGA7RISs2XeGlx7m3yWhnfpiENCi1tCKGJxcT1xNzUKm8kGa05u+j6qrk5PHxBH
	pP6ItEEnt4+3qbf7FQfeRrCs5IhTxm2zB02cy/IkIdGRr9Gke6IS4zdX68a7QTlNjD+R/U+ff3+
	p4/mAVcwTfkzKPoVBnk0FwHCMcq501Neiq2nirfDf1ozH3cTy5cNAlwZ2dEDoTuH3ERIOngJDbi
	zUNVaSHkFvSSWewCZmdBtej+8hEySP9O92vIi5YOEbmGUgqFhVQsGjZElM7KYNJwmh+9u0iwMqe
	t+AcNScI9Y5EvSGXco5kWHAqTv53GzZI/tyigo=
X-Received: by 2002:a17:90b:3c8a:b0:38e:524:8797 with SMTP id 98e67ed59e1d1-396d10076e9mr10770661a91.13.1787905776913;
        Fri, 28 Aug 2026 01:29:36 -0700 (PDT)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.58])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396afff2650sm6321493a91.0.2026.08.28.01.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 01:29:36 -0700 (PDT)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org,
	xiang@kernel.org
Cc: stopire@gmail.com
Subject: [PATCH v2] erofs-utils: fix incorrect field conversions
Date: Fri, 28 Aug 2026 16:29:30 +0800
Message-ID: <20260828082930.1626829-1-stopire@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827020629.1305900-1-stopire@gmail.com>
References: <20260827020629.1305900-1-stopire@gmail.com>
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
Link: https://patch.msgid.link/20260827020629.1305900-1-stopire@gmail.com
Signed-off-by: Gao Xiang <xiang@kernel.org>
---
Changes since v1:
- v2 only adds the missing cpu_to_le16() conversion for the 16-bit
  startblk_hi field in lib/blobchunk.c.

 dump/main.c     | 4 ++--
 lib/blobchunk.c | 2 +-
 lib/compress.c  | 4 ++--
 lib/gzran.c     | 4 ++--
 lib/inode.c     | 2 +-
 lib/namei.c     | 2 +-
 lib/super.c     | 2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

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
diff --git a/lib/blobchunk.c b/lib/blobchunk.c
index d307a4f..f969cf2 100644
--- a/lib/blobchunk.c
+++ b/lib/blobchunk.c
@@ -245,7 +245,7 @@ int erofs_write_chunk_indexes(struct erofs_inode *inode, struct erofs_vfile *vf,
 		startblk &= addrmask;
 		idx.device_id = cpu_to_le16(chunk->device_id);
 		idx.startblk_lo = cpu_to_le32(startblk);
-		idx.startblk_hi = cpu_to_le32(startblk >> 32);
+		idx.startblk_hi = cpu_to_le16(startblk >> 32);
 		DBG_BUGON(!_48bit && idx.startblk_hi);
 
 		if (unit == EROFS_BLOCK_MAP_ENTRY_SIZE)
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
index 25116fe..98e1711 100644
--- a/lib/super.c
+++ b/lib/super.c
@@ -222,7 +222,7 @@ int erofs_writesb(struct erofs_sb_info *sbi)
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

