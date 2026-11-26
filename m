Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E186606A321
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Nov 2026 12:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=MSLUK+M9
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jZwCh4WJCz2yRn;
	Thu, 26 Nov 2026 23:02:40 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::329"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795694560;
	cv=none; b=foraFt/RXtTEw3nSJxoTZip8ZEzrLt+4PjFZVIjMZWKyHXeeB2kZa2e3xOvrpiAJprxWKN13D7b+fC20Wa9ClSbb1+C0Q3gqBoyO9lQWfeB7yVichtkPsifjql4I93eUtjrYDFtQdvhShk3pyqqfS5lqbhRAjxdGILSpUY8vx1a9R//4Y+T0pvjIxHBMtO0N5mHcpQ1hNdhiVeTAvLNBqLn4XgdWQECS0geStK1K1RoK6qkvSGJKf89TRW1qyvb12xt/sg/sjq6gIAGiBAHgYpX4OYtbE8ad5ny0F4+B+u5Ks/8yCT1bTzgUKb4YlfZCgNSvzHUadXAyNpH5JjhTYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795694560; c=relaxed/relaxed;
	bh=aiFY+H1tJiRP2r6rZ/RVeUBOG3zpyWowNq86MWWbAR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASa9PFl+h+lY2P44E0MOaqv52qrrqUWRMsBwBYcjhZBJnDvPrs+5q4T4h3DmAg3/yeiuPLL44ZX0ltlUnub2fF/TYioNqUIqZIXGxgwjLY8WPdxXGVp+4kKZdy9cxomWqJqGkig3tl+PQ+2ECwzAITJAsygOGXZnbTPxwXajuMddzzZGSEOKY5WXayKsj+rbyC6YsQFAwIvpi/m7iJdBgj5KfbdN4qiRXGUOZ/U4h+o6mMdJZk4dwSjsBXOemp3mZQ4QbrvdrIss0EUdfbAz3xPTG8KSKtbX5/stguG8MkXQt4lI8Kd6WdK1OjHhRRN19wgsw4DuDl8kt2XtbSvcsw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=MSLUK+M9; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::329; helo=mail-wm1-x329.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=MSLUK+M9;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::329; helo=mail-wm1-x329.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jZwCg4Mrsz2yR1
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 23:02:39 +1100 (AEDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-4bba5e17728so16113655e9.2
        for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 04:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1795694556; x=1796299356; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aiFY+H1tJiRP2r6rZ/RVeUBOG3zpyWowNq86MWWbAR0=;
        b=MSLUK+M9SY07K6pEB9HaAP0olJQhWR8lD+EhSwkeYg7IBBhjTuOnTuhSH1VY7p6upu
         HSTJdaHbLl/k0t3wAGjWfDlgnm6qV6psIDY+nvu/P9ArW0U2Zej34R1icltvbmIYYKYy
         +TDRaq5dPDmKbnxWTjrEkFm0mXa0jBbglWh2eBMb38j/tzRw4yI9VefTLZ6PulldALxS
         HzGBuI9lWDsBtyeR6O9Su7G8oUHQrG/zlGpS2oUKzhMaFjMul+X6oP45ui5RJjBAuiNH
         v3N3gi9pgg8Nm6igM9iAR9VIXo62wQsTYHDPamjpPSVzNvUsZi7qB1UiN+b5oND6bkUW
         fpJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795694556; x=1796299356;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aiFY+H1tJiRP2r6rZ/RVeUBOG3zpyWowNq86MWWbAR0=;
        b=IgHMYUHW+qE8tttSzXvWWN9z/jFtPuuRpfx0dRX2rAyFOtOZ5LNMX2MhfhmoBvff+B
         GSgFt3MH9LKp6bSgrvUoNVwmAT60c9rFPCMns0d0T4dME1KfW1SEhmOGDIKIGEIMvArz
         WdGsNEH9rqCFlPH5pQTrDoRpA+SR3HNA3vYduFfg58k2oz30Zg8k2Fe9o0IWNoxrNV2u
         VV6NqA3sd0Pxojq1N1+s+q9X3JzXPn70/yz6xhrRqjV4fU7cuxSYHrc49kGrm4s5GjJD
         UHPCuiuyY6Epu1oVfRyNoC+1A1gqw1MNjdZ20/UzFIYoCzS+SHulREtmysY4pjS91yvf
         06Bg==
X-Gm-Message-State: APuU4Z8pU4M/hzqtSKCoj9KRApEJi4bQ9zFksUXSj4ZJkmCfqB51S5LJ
	qTWT/tdLPr/GJPJGP/Qc52nh9t4/QBlMsdytsoleFa24L889yRpLpUMv6MCySh8RXbUTJP/Cf+Y
	tOFnGV28=
X-Gm-Gg: AZFdTZcZMo2edleii3H8vPWG4H1I9nSg1cBhbcq1ED++g4unHyhRss6BRlg5j33iuZI
	EdKM2oNSgK/QJ6HTh8q4uzQ2xdkr2r/+OQWtgIy150tWVXXbiLIIssi8Le8cIL9FqkzbkX+tRz8
	Te4bDd6j72heW97dLBj6xSjMMvtjW2iWtlN5ebQwVPQKgiMtgZ8JCIzceNcAcV+uIooCBK1elt4
	/IzDgDs4ws1xzr3yIWFZt0E1SsnyyElv9sYELv1WdUgXe2/ee4pMX93pDcqoO17hWa1+T7dre8H
	ofl9sznqYYgLJOps7zC+wScc44i+GzqeOkU2OdKIwP3MeKioTq0xarm+S4+Wn/NhrhMXrJMREp1
	42fMpCLQJhWOKMsNg7UjZwcqd2/HBqTkjppyKht0jVrUR5YysaiBE3KZWfDyYhdJlv7vgrNPT73
	FFbdT95zek/HAhTm5tJgUltxSY6GJcyu4WcqFfvZmsIScVkUVDfp5Vp/yi8AGl4AIyEnVOAuieK
	3fUor/Eo2fvckIYbi8yQ5MyXH7vjDGCyuXZDArVbvVQzd6/Bay1eDcw3MSg5aFcFDl3GOakPRMl
	zDjIF5iK9gHUyJGdFkgnaVmdTLRaKceMypPSPlq3TEQUdXoUTdTNpk6WNNm1kvComu2Y
X-Received: by 2002:a05:600c:3b8a:b0:4a3:59c9:a754 with SMTP id 5b1f17b1804b1-4bb8892da25mr415898025e9.22.1795694556216;
        Thu, 26 Nov 2026 04:02:36 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:6060:1d3a:5489:cf84])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b7515sm819402455e9.13.2026.11.26.04.02.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Nov 2026 04:02:35 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v3 09/10] erofs-utils: mkfs: give each rebuild source its own device range
Date: Thu, 26 Nov 2026 13:02:20 +0100
Message-ID: <20261126120221.4384-9-xiang.gao@docker.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261126120221.4384-1-xiang.gao@docker.com>
References: <20261126120221.4384-1-xiang.gao@docker.com>
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
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Blob-index rebuilds assume that each source uses only one data device.
This does not work when a source uses both its main image and external
devices, or has more than one external device.

Set up the output device table before loading trees.  Give each source
image and its external devices their own range of device IDs, and update
chunk indexes and compressed extents to use the new IDs.  Keep holes as
unmapped chunks.

Keep source image filenames for VMDK paths and check chunk-index sizes
before allocating their buffers.

Assisted-by: Codex:gpt-6.1-sol
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 lib/compress.c |  4 +--
 lib/rebuild.c  | 37 ++++++++++++++++++-----
 mkfs/main.c    | 81 ++++++++++++++++++++++----------------------------
 3 files changed, 68 insertions(+), 54 deletions(-)

diff --git a/lib/compress.c b/lib/compress.c
index e764e44..088d5b7 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -2562,7 +2562,7 @@ int z_erofs_rebuild_load_metadata(struct erofs_sb_info *dst_sbi,
 				.length = map.m_llen,
 				.plen = erofs_blksiz(sbi),
 				.pstart = (pend != EROFS_NULL_ADDR ? pend : 0),
-				.device_id = inode->dev,	/* FIXME! */
+				.device_id = inode->dev + mdev.m_deviceid,
 				.raw = raw,
 				.inlined = true,
 			};
@@ -2575,7 +2575,7 @@ int z_erofs_rebuild_load_metadata(struct erofs_sb_info *dst_sbi,
 				.length = map.m_llen,
 				.plen = map.m_plen,
 				.pstart = mdev.m_pa,
-				.device_id = inode->dev,	/* FIXME! */
+				.device_id = inode->dev + mdev.m_deviceid,
 				.partial = map.m_flags & EROFS_MAP_PARTIAL_REF,
 				.raw = raw,
 				.inlined = false,
diff --git a/lib/rebuild.c b/lib/rebuild.c
index 6a4aff6..85f263b 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -247,8 +247,9 @@ static int erofs_rebuild_load_chunk_index(struct erofs_sb_info *dst_sb,
 					  struct erofs_inode *inode)
 {
 	int ret;
-	unsigned int count, unit, chunkbits, i;
-	struct erofs_inode_chunk_index *idx;
+	unsigned int unit, chunkbits;
+	struct erofs_chunkitem **idx;
+	u64 count, i;
 	erofs_off_t chunksize;
 	erofs_blk_t blkaddr;
 
@@ -274,11 +275,13 @@ static int erofs_rebuild_load_chunk_index(struct erofs_sb_info *dst_sb,
 	}
 
 	chunksize = 1ULL << chunkbits;
-	count = DIV_ROUND_UP(inode->i_size, chunksize);
+	count = inode->i_size / chunksize + !!(inode->i_size % chunksize);
 
 	unit = sizeof(struct erofs_inode_chunk_index);
+	if (count > min_t(u64, UINT_MAX, SSIZE_MAX) / unit)
+		return -E2BIG;
 	inode->extent_isize = count * unit;
-	idx = calloc(count, max(sizeof(*idx), sizeof(void *)));
+	idx = calloc(count, max_t(size_t, sizeof(*idx), unit));
 	if (!idx)
 		return -ENOMEM;
 	inode->chunkindexes = idx;
@@ -294,16 +297,36 @@ static int erofs_rebuild_load_chunk_index(struct erofs_sb_info *dst_sb,
 		if (ret)
 			goto err;
 
-		blkaddr = erofs_blknr(dst_sb, map.m_pa);
-		chunk = erofs_get_unhashed_chunk(dst_sb, inode->dev, blkaddr, 0);
+		if (!(map.m_flags & EROFS_MAP_MAPPED)) {
+			chunk = erofs_get_unhashed_chunk(dst_sb, 0, EROFS_NULL_ADDR, 0);
+		} else {
+			struct erofs_sb_info *src = inode->sbi;
+			struct erofs_map_dev mdev = {
+				.m_deviceid = map.m_deviceid,
+				.m_pa = map.m_pa,
+			};
+
+			ret = erofs_map_dev(src, &mdev);
+			if (ret)
+				goto err;
+			blkaddr = erofs_blknr(src, mdev.m_pa);
+			/* dif->blocks may be 0; only uniaddr is valid for mapping */
+			if (erofs_blkoff(src, mdev.m_pa)) {
+				ret = -EFSCORRUPTED;
+				goto err;
+			}
+			chunk = erofs_get_unhashed_chunk(dst_sb,
+					inode->dev + mdev.m_deviceid, blkaddr, 0);
+		}
 		if (IS_ERR(chunk)) {
 			ret = PTR_ERR(chunk);
 			goto err;
 		}
-		*(void **)idx++ = chunk;
+		*idx++ = chunk;
 
 	}
 	inode->datalayout = EROFS_INODE_CHUNK_BASED;
+	inode->u.chunkbits = chunkbits;
 	inode->u.chunkformat = EROFS_CHUNK_FORMAT_INDEXES;
 	inode->u.chunkformat |= chunkbits - dst_sb->blkszbits;
 	return 0;
diff --git a/mkfs/main.c b/mkfs/main.c
index ce93166..e9613cb 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1686,7 +1686,6 @@ static int erofs_mkfs_rebuild_load_trees(struct erofs_inode *root)
 	struct erofs_device_info *devs;
 	struct erofs_sb_info *src;
 	unsigned int extra_devices = 0;
-	erofs_blk_t nblocks;
 	int ret, idx;
 	struct erofs_rebuild_params params = { .mergeroot = root };
 
@@ -1704,6 +1703,42 @@ static int erofs_mkfs_rebuild_load_trees(struct erofs_inode *root)
 		return -EINVAL;
 	}
 
+	if (params.datamode == EROFS_REBUILD_DATA_BLOB_INDEX) {
+		/* Assign device ranges in command-line order. */
+		list_for_each_entry_reverse(src, &rebuild_src_list, list) {
+			ret = erofs_read_superblock(src);
+			if (ret)
+				return ret;
+			if (src->blkszbits != g_sbi.blkszbits) {
+				erofs_err("%s: source block size differs from the output",
+					  src->dif0.src_path);
+				return -EINVAL;
+			}
+			if (src->extra_devices >= ARRAY_SIZE(src->blobfd) ||
+			    src->extra_devices >= UINT16_MAX - extra_devices)
+				return -E2BIG;
+			src->dev = extra_devices + 1;
+			extra_devices += src->extra_devices + 1;
+		}
+		ret = erofs_mkfs_init_devices(&g_sbi, extra_devices);
+		if (ret)
+			return ret;
+		list_for_each_entry(src, &rebuild_src_list, list) {
+			devs = g_sbi.devs + src->dev - 1;
+			devs[0].blocks = src->dif0.blocks;
+			/* Preserve the source filename for --vmdk-desc extent paths. */
+			devs[0].src_path = strdup(src->dif0.src_path);
+			if (!devs[0].src_path)
+				return -ENOMEM;
+			erofs_uuid_unparse_as_tag(src->uuid, (char *)devs[0].tag);
+			for (idx = 0; idx < src->extra_devices; ++idx) {
+				devs[idx + 1].blocks = src->devs[idx].blocks;
+				memcpy(devs[idx + 1].tag, src->devs[idx].tag,
+				       sizeof(devs[idx + 1].tag));
+			}
+		}
+	}
+
 	list_for_each_entry(src, &rebuild_src_list, list) {
 		src->xamgr = g_sbi.xamgr;
 		params.sbi = src;
@@ -1713,50 +1748,6 @@ static int erofs_mkfs_rebuild_load_trees(struct erofs_inode *root)
 			erofs_err("failed to load %s", src->dif0.src_path);
 			return ret;
 		}
-		if (src->extra_devices > 1) {
-			erofs_err("%s: unsupported number %u of extra devices",
-				  src->dif0.src_path, src->extra_devices);
-			return -EOPNOTSUPP;
-		}
-		extra_devices += src->extra_devices;
-	}
-
-	if (params.datamode == EROFS_REBUILD_DATA_RESVSP)
-		return 0;
-
-	/* Each blob has either no extra device or only one device for TarFS */
-	if (extra_devices && extra_devices != rebuild_src_count) {
-		erofs_err("extra_devices(%u) is mismatched with source images(%u)",
-			  extra_devices, rebuild_src_count);
-		return -EOPNOTSUPP;
-	}
-
-	if (params.datamode == EROFS_REBUILD_DATA_FULL)
-		return 0;
-
-	ret = erofs_mkfs_init_devices(&g_sbi, rebuild_src_count);
-	if (ret)
-		return ret;
-
-	devs = g_sbi.devs;
-	list_for_each_entry(src, &rebuild_src_list, list) {
-		u8 *tag = NULL;
-
-		DBG_BUGON(src->dev < 1);
-		idx = src->dev - 1;
-		if (extra_devices) {
-			nblocks = src->devs[0].blocks;
-			tag = src->devs[0].tag;
-		} else {
-			nblocks = src->dif0.blocks;
-			devs[idx].src_path = strdup(src->dif0.src_path);
-		}
-		devs[idx].blocks = nblocks;
-		if (tag && *tag)
-			memcpy(devs[idx].tag, tag, sizeof(devs[0].tag));
-		else
-			/* convert UUID of the source image to a hex string */
-			erofs_uuid_unparse_as_tag(src->uuid, (char *)devs[idx].tag);
 	}
 	return 0;
 }
-- 
2.54.0 (Apple Git-157)


