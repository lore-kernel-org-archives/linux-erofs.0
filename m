Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4D6606A320
	for <linux-erofs@archiver.kernel.org>; Sat, 21 Nov 2026 12:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RCHQjHfk
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jWrVb1dcgz2xXB;
	Sat, 21 Nov 2026 23:04:55 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::42e"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795262695;
	cv=none; b=WpKavJiuOGL4cNyz1WSk8kKooz2vtjc6OppqsJIbDd3T7hX3binP2NALlwQ/Pnb1b6ZBs1yyBrwCkWnRuhtXnzdtT4J4e6oh1AXuA3uUEwXTw2Un5owcx1RNJwDPrWupWr3z1U//LtsSZEBRH47KRO2y5LBv1scLkOoXXv0WuQsBsQ3gG3MaY+SHMPvu0EJwvSnmFWFz7avVi5ux4QE4Bt56v9nM2viigXTSb2wHcnL9/Xu7sq+TnEiWsCWMFrjJ3qjtYhBVbOEwgdgfU/0plVyCPYAElPWrmGlScMUeR/z9jUct7jnYdK4dnPfC7/T9JaiGUxei1WCTe1tUJgi8WA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795262695; c=relaxed/relaxed;
	bh=dN/n9AzHd+n9YrG6FDO5xTjed4c6qvLn1q/yzJlqm8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=acHVix9UDS7SCWJFLsb30wiCt4wG9S9Tlbtql6q//pLkpdS0mDW9fWUIsCpu1ljyDB372tBSdVP7bNhCPnIdRniCnCM2CVPcIhAshfSy0/byIxqvk2Ily2QpI77RVYaiEMvy2bC6bR3FsahSo4z0sh+M2C1xYlvj18JFhX/NLpqm3Nggnw1iLoZ8HOgqrHXRogdgPp+qOCDzV/wQ5SEnFdFDlvf5s6lZzmbFpjFb9Ni72dUQJt0oWylf5mbGeBEj5oAEH3hpcVuA34ShztxSLZzZuY4tb5W7fiUH3UENkF6pPMrcec2sLI4RHfy5GJFI+8vRRMxUbNyBAM6YLz9uzg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RCHQjHfk; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::42e; helo=mail-pf1-x42e.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RCHQjHfk;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::42e; helo=mail-pf1-x42e.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jWrVY63cpz2xLt
	for <linux-erofs@lists.ozlabs.org>; Sat, 21 Nov 2026 23:04:52 +1100 (AEDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-8a0880a46e7so1152466b3a.1
        for <linux-erofs@lists.ozlabs.org>; Sat, 21 Nov 2026 04:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795262689; x=1795867489; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dN/n9AzHd+n9YrG6FDO5xTjed4c6qvLn1q/yzJlqm8Y=;
        b=RCHQjHfkL7FHWrTkJKbuEqSmgk1UVMIo2o1JM2sbXGcnplmSYPA0eoICxDd+EDtCi+
         VdXQ2lqItcM4/bbi1NK4LqA/O8aFPgS4amhMzZ0RnMq1KM1rxhO2I7JUv8sQk4U79DYn
         0FZdhsWNG4/UlFMYDEjkhKbijEIKhommaSDSimzz5eTJZmZB+dpFYGQRuwEIwLlJzytw
         ZOgjzbCPP/3fA4SA75H+xz320e56Q3hoU63uM90dDSQjJac82NpRqVTGWvERHk0eIwsi
         BDkE00+ezAVQQj3mhN77mrHv8ufv6xxr2VrgIQbSORIhZ6gTDSQAqFUzTo6da0ct5W3U
         hOuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795262689; x=1795867489;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dN/n9AzHd+n9YrG6FDO5xTjed4c6qvLn1q/yzJlqm8Y=;
        b=aYDxjolnMcdKGdl5KzOmz6XZ4Rv3sPFtfHYv9gHBCXwzdPOella8rh1MCUrWeCtRDy
         OvSzXxdig2tkNsIc/I5ICC8jd7LDodg0v66p3RpC7EDFUGZwQFT8OFBsHNNeQDagtpmK
         sEhRvAkLrKNnWuRmsJtOR1X+m48/4+6dilXEJbNaMkgfPpN/ofj65tMgRtUg9EjDk4Kn
         A5riC9g3qc7tNTnQgjIWQYt9O8hNpbN03qJ9GGVvCoGVK8FBV4unkDTEX06s+MUFSiAK
         fD/v8HMCGcC3ADKWFq/FlJMsdJcR+kOLKjQrRXJH6cg/yGHjHQ30ac4eCAJTM6/2yYiT
         ieqw==
X-Gm-Message-State: APuU4Z9IcbY3ats6WQG2ZBmNgTIUZmLDa5S0MqZExrsNxyIuu1/PEx0y
	gW7ApuaZcBpAtg3g3WuIwmFo1fjktvVWPmBgUVOOsBHxFJKPCD1aL8tLOu0AyQ==
X-Gm-Gg: AZFdTZcvDgOa/ckBsL4lCPw9mfoU2RH+Yt869HCuKu3WBSlCNjNEf9XqjOXESFg6+9r
	hxMGmawFISgpMFzYYd2EaEi23gIaHzOdAprNKU/zv0sH3LXxvlU+TViSj1IVP/Y18es1xv2NrlQ
	mLAQiBEJEAQ+IVYj64c1tvS8aDL2WqHtmifF6q3We/e3nTiPNLgb6CzJ87rMxAo/0iOBfAmQLt2
	zuxyMxoCW7MtziQ79mmKvLDRg63XnaJcCgpGWPFWM7Go923HuBGPZr8d3IJNZBSQRcZZoYbX7Gw
	9aEBGbMtYe7k6xyWbDP8ni1YdPSRp7zaFNfOt4/it+025nLJCtuVBSnQm+WkSnPkkX6xHlTTmoi
	Mng+qHk6Qpw/Mg/98qIr6GkjHc0G8T1y0r6Vl6783rdHvAE9KB3bmKs+tT2DwLkmTOu6MaZhJKY
	zhvjsmNhpp4I2kWRCi857Vikpvaookg0mqQQjcP9JM+j2lRxP1FBS2UCaPqMFcbC97AcA8nzIzM
	9pq79pgb4jhi4k+qkS1MrX9IdMiSKdNBFcBlXB8Vzg9TgHX7aq6q1gLcsYwzNByyFVfwYbbP0VK
	ABq6Y5tF7CVKckH4+Ah3ODo+5/2Rcg8zNaYYVJoXqsCa+Q==
X-Received: by 2002:a05:6a00:1251:b0:8b8:8971:66de with SMTP id d2e1a72fcca58-8c7db1edc15mr4845585b3a.3.1795262689489;
        Sat, 21 Nov 2026 04:04:49 -0800 (PST)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c872e4d7basm2701933b3a.21.2026.11.21.04.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 04:04:48 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	zhanxusheng@xiaomi.com
Subject: [PATCH] erofs-utils: lib: return -EFSCORRUPTED for oversized tail pclusters
Date: Sat, 21 Nov 2026 20:04:45 +0800
Message-ID: <20261121120445.943995-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
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

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

z_erofs_map_blocks_fo() prints "invalid tail-packing pclustersize" when
a tail-packed pcluster crosses a block boundary, but err is still 0
there, so the mapping succeeds.  With h_idata_size of a file in an
-Eztailpacking image set to 4080, fsck.erofs prints the message and
exits with 0.

Return -EFSCORRUPTED, as the check did before it was moved here.

Fixes: 97ad172b79b7 ("erofs-utils: lib: clean up header parsing for ztailpacking and fragments")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 lib/zmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/zmap.c b/lib/zmap.c
index 5b44b60..40a376b 100644
--- a/lib/zmap.c
+++ b/lib/zmap.c
@@ -501,6 +501,7 @@ static int z_erofs_map_blocks_fo(struct erofs_inode *vi,
 		if (erofs_blkoff(sbi, map->m_pa) + map->m_plen > erofs_blksiz(sbi)) {
 			erofs_err("invalid tail-packing pclustersize %llu",
 				  map->m_plen | 0ULL);
+			err = -EFSCORRUPTED;
 			goto out;
 		}
 	} else if (fragment && m.lcn == vi->z_tailextent_headlcn) {

base-commit: 8a8d4892b6b09919053ba3561d289af76095c625
-- 
2.43.0


