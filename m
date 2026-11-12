Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1663A606A327
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Nov 2026 12:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xHHvhcOr
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQKtP5dvQz30V6;
	Thu, 12 Nov 2026 23:47:57 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::630"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794487677;
	cv=none; b=eV+9Fpy9ssmdUxz7wFDytB5IcZO5gRSPKMBlFLprZRVJPwHs5so2po5Sfp/hAcExlFD2znf2ySCBl4Z7LbE9nDKT+3C2EYjssauH1gh0iBQc3O3GCpxZuKW7HDutJL7PFOOA1QvGk4AEksyybt4Kxfajs7yYFdbMX+EshoSU4rA9pAsPA7b4dHRe8RHk5ygg1FnQ3mAigEHl5qPNp/LaRe4g8Cf1EIZ8Go+RnTsFZaF2gDu7lbaaPAQSmLbvSI/oVpDO25t6bZMe7p35JaY+F6EUDPhJByrcPk9ja6KNKHHsMjQKQUrK+XZEtiCWCE2/keD8/y8CE7qip/0p4qzSKw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794487677; c=relaxed/relaxed;
	bh=xtoFpYlb8kmoVPBa+FWpJTxGYrlQvrbMm75XOL/dKE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1mWR/sHW+/JmNX9gEmPGaBjKNpRpJwptO/TXidr2tGdQwzeoMl8dc2Wor1uvvPmoW90jYIb2UC/dwRgnZLGeffr65xHsG4bRWJA33jtZUgMBOt0BK5XWYZUDAuhICaqftXuyp4moUC3j//2vDCwHoH72g+08yojQFmB9ROv+6ESaioADb+XphXX12GRPhFUWqPYGdfqpewh/UZrU0+DrBbDtOANUn2qa1Vin5fXAg1LMvYhK5stNr8vIFZ6JxNAd9XHSeRYbWcB/JKKHA8QL73dSWJ/oy1iqxz9JHqumAydMk2JR7GWXUUP11Z8z699AsNT+Ks2C0vOgpFDNcmHRA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xHHvhcOr; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::630; helo=mail-pl1-x630.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xHHvhcOr;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::630; helo=mail-pl1-x630.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQKtP1Bqmz2xly
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 23:47:57 +1100 (AEDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-2e9995ce866so30335185ad.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 04:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794487675; x=1795092475; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xtoFpYlb8kmoVPBa+FWpJTxGYrlQvrbMm75XOL/dKE8=;
        b=xHHvhcOr9u/cPE3nwpxA5aFJNYRWkSCNF/DIxAmXzLgTyMn9e3EmaVAIvtZwL5Dpdq
         VQuxDU1JiuYRNiut6LQzXHzrml4jiGysgz/fqLcPBiufhRG2AzWG9Q54BlsQH2UFEdG9
         FmMK7SY/fQ2LK7seBntpWVe0OOBUhjsTBSekhr9aoHdUC/grWbl8rrxnDUQVtLyWgINA
         +SEoQgs19uxZIVWqeZrOxiAsVTep12sAluuZJv1w7D4NDdIRqFKXNbv+MgKwu4W09/SP
         lKU9CxgIIzz0hhnhylY3xYKKVVFwAduRKTGbKE2yHtww44XVfhGsDWcwP2EwM4UCeVv5
         h3Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794487675; x=1795092475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xtoFpYlb8kmoVPBa+FWpJTxGYrlQvrbMm75XOL/dKE8=;
        b=L/Ghun52dofkFacvwMO/TGu0Rx5TTvVwA0B8u3hjLEXuQHpfU1Tv6A+PdifZlujFLO
         hzALAYaAzTAOte66ck+pR63uJNn95HqSxUPsQsWR9dEjhPJWHalu6IhfWHHxMPG0W2Tt
         jqUaFsiCrPl1JaVwqStP/givT436s+QY+zVOXREu0454a/F4+O/RgIEi6FyMxLWMZ8d9
         gP2ltobU7GovMNN5uLBUrGsycmsrxRaFLphurnkBWiB9zOf4JfCUC0Omkoktre58tgv1
         G6E/Na8YIW5sbn+ER0jtt6y+qtIMWShR3vsjx8K6g6SbMLR5ELltIuKGISeES9FBiYUC
         h5Yw==
X-Gm-Message-State: APuU4Z+n6qr+STFYqWIKp0eJ806n70cjeBMqT2nSbt1NcYYun3QarpcL
	Tk5Qr9B5LA63gvKeuyVi96l+9WicNsjsBtr4eZ6p3MpvFc9FfMMeHeCJ7HkYkZ0jBdw=
X-Gm-Gg: AYBFou0KvfoUwOo2mYFcvIyyiRClT+i1cO+NiCnwAlewICkaYuSl+m73CBYQzNn7jSO
	uC6wT7IlRCaZ3GBZG3f06lAwserg2cHxF+SWGmx34i3hOTcQdxZHO9r4MY19IZy+ZPRMALJD6/W
	f+FEg9UGTss0hk7T7xac0e7LpYyMG9/CCEJEm8JYg/PQ9WZj0DIYMzcuMyHd38JNPHPve5FBkM7
	WS4jke7U1wk1Zm8i4ZPx5zZGC7OTvP9S+ITbHOT2CDN7zUOge0z/TafZnLMsiPSb25CnDb68trO
	mCIMvqlq+BNgYFomZY/V0U2LOAE6AqseCXNxDLhNNnqnRDMF5lxe9w1TsrnHbqyLAJAxO4eYAku
	vb9ZYSgX0/5LAvbTzrK0FjfkNrrYhpvPFseX+PR4vZxlfcKlW26DGbgc8wfCmdSiihmTSJ0opqG
	/KLlxZ0Sp74Jj15LitUd0tZp8QkNQXffCbG/dq4aureahYYuDIRGGogelYCic98NEvBVUoymfXX
	7iqCeaH9UQiFrYRe1iqDi2NwHGLbsM0dohfjWZO+YNyXMy89vx2L5FXsmB/FmpV6BeHFd/Wm62d
	/nABM2pW7odbBWtiquZj25KZ7x9iXNYLbwq9cGAd3nwv64H1
X-Received: by 2002:a17:902:f681:b0:2ed:2b2f:8632 with SMTP id d9443c01a7336-2edd773eeb5mr57381085ad.22.1794487674910;
        Thu, 12 Nov 2026 04:47:54 -0800 (PST)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6dd2225sm34189905ad.56.2026.11.12.04.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:47:54 -0800 (PST)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: Yifan Zhao <stopire@gmail.com>
Subject: [PATCH 7/8] erofs-utils: lib: fix metabox inline data reads
Date: Thu, 12 Nov 2026 20:47:24 +0800
Message-ID: <20261112124725.2774244-8-stopire@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112124725.2774244-1-stopire@gmail.com>
References: <20261112124725.2774244-1-stopire@gmail.com>
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
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

fsck reads inline data in metabox through:

  erofs_verify_inode_data()
          |
          v
  erofs_read_one_data()
          |
          v
  erofs_dev_read()  <-- metabox offset used as physical image offset

Let's move metabox inline data handling from erofs_read_raw_data()
to erofs_read_one_data().

Fixes: c6903c7e32a1 ("erofs-utils: dump,fsck,fuse: support metadata compression")
Assisted-by: Codex:gpt-6-astra
Assisted-by: Claude Code:deepseek-v4.1-flash-1017
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/data.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/lib/data.c b/lib/data.c
index c73cbe3..91809d0 100644
--- a/lib/data.c
+++ b/lib/data.c
@@ -215,6 +215,19 @@ int erofs_read_one_data(struct erofs_inode *inode, struct erofs_map_blocks *map,
 	struct erofs_map_dev mdev;
 	int ret;
 
+	if ((map->m_flags & EROFS_MAP_META) &&
+	    erofs_inode_in_metabox(inode)) {
+		struct erofs_buf buf = __EROFS_BUF_INITIALIZER;
+		void *src;
+
+		src = erofs_read_metabuf(&buf, sbi, map->m_pa + offset, true);
+		if (IS_ERR(src))
+			return PTR_ERR(src);
+		memcpy(buffer, src, len);
+		erofs_put_metabuf(&buf);
+		return 0;
+	}
+
 	mdev = (struct erofs_map_dev) {
 		.m_deviceid = map->m_deviceid,
 		.m_pa = map->m_pa,
@@ -253,20 +266,7 @@ static int erofs_read_raw_data(struct erofs_inode *inode, char *buffer,
 		eend = min(offset + size, map.m_la + map.m_llen);
 		DBG_BUGON(ptr < map.m_la);
 
-		if ((map.m_flags & EROFS_MAP_META) &&
-		    erofs_inode_in_metabox(inode)) {
-			struct erofs_buf buf = __EROFS_BUF_INITIALIZER;
-			void *src;
-
-			src = erofs_read_metabuf(&buf, inode->sbi,
-						 map.m_pa, true);
-			if (IS_ERR(src))
-				return PTR_ERR(src);
-			memcpy(estart, src, eend - ptr);
-			erofs_put_metabuf(&buf);
-			ptr = eend;
-			continue;
-		} else if (!(map.m_flags & EROFS_MAP_MAPPED)) {
+		if (!(map.m_flags & EROFS_MAP_MAPPED)) {
 			if (!map.m_llen) {
 				/* reached EOF */
 				memset(estart, 0, offset + size - ptr);
-- 
2.56.0


