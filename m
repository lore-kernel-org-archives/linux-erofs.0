Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8586F606A31C
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 07:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=J94wCc8+
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQqPq2mjVz30Wg;
	Fri, 13 Nov 2026 18:58:23 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::1336"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794556703;
	cv=none; b=H7B1rIJ82y3Un3Z0a+zs/ehZ4PoA3Gd+HixUoWhuzkjOAGstT+JIP5cDfpA2Qn3161fR48tQW/PAQCw5RZBvSQ6J8zfpwjImVGkMfMWN+0A9d+WuTcgw5G/EbAd5o5/4zB2Eu8oPemY1tjHjtpney9lhq5pWAeEfbMPfPGrXp9Ajo4u2OmSzh4nPR0xBk/wwN4Jf9FXtg/R2cfrqy2DM/7Tf/DtDYGs9vkn4GXMPjkoBtsyRQWir+KbqZ/NkjlAHBbXHN40XtvQ8UqMwRekWhZgkX1nl7DwRnqjcMgyH7vnffrGY24kJ3F0Ai7FliQjtULbQbsdOMW39h08C0w8ceQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794556703; c=relaxed/relaxed;
	bh=cRCmrTcuDzuXbT9PHoGFPY3Q2bG+sC/PN/tUK8/S120=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhHOhI2uBDQEJCATRPWdKjKPlQU3hku3vscbhunQP5qvg2tlWUadAogjDGjVGBTmWWnQq72AMaVL63fZ/g21Gcy2BY3u+5XBSwjngTzRZrOnZksNbk6snpOohnGyzMKHs3U38erhMus+xfTPaci/g4uTRYm/j2Xr+EeX7/p0N5agHPbnwXKwnoGKFoM4pkKhRu7e3ttVrJnMyYrno8JEsJB7qzRKRZLKYFeUKrNmF+7DcLnDR79bw6/2UbPMvFOgLMK7rotl8tGNvZOZmLNa4dHoovQqSO5RrFVz0+bk7A9OzVcNO/KibVYdB5Nc+N9YW1vRNM2pwop5mHhqZ8uiTg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=J94wCc8+; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1336; helo=mail-dy1-x1336.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=J94wCc8+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1336; helo=mail-dy1-x1336.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-dy1-x1336.google.com (mail-dy1-x1336.google.com [IPv6:2607:f8b0:4864:20::1336])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQqPp4jjyz3bNr
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 18:58:22 +1100 (AEDT)
Received: by mail-dy1-x1336.google.com with SMTP id 5a478bee46e88-36e795af1d4so469204eec.1
        for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 23:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794556700; x=1795161500; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cRCmrTcuDzuXbT9PHoGFPY3Q2bG+sC/PN/tUK8/S120=;
        b=J94wCc8+ABt98G0UTytOjswfIdeN+YG09o0jxgk0t5CUEcJIJPyef2UvzPwS+f3Ypk
         O+lAYa2qGw4WEtaufarWy7me+8fOvZPwxQhAcwZHmUcuofmZGHshtQ7D022nn3F93LM0
         OzWJX6D/wlqVOPxYhMihIbwkR6GSOuhv5OqpQF4END296IFzUJK167Bf899YTAb652fh
         fHChyKfN9G5E/iX9mdldKwX3s/ruCWMalSzehncqXAEq+3lP1lsuEj3an56J2uOaSSyZ
         eWOyvoxdO3OkHMj99CDYz8yEIvpmzhhUbdowQW3E42FtkBtPPR/zQzQb/Zhua0QPAATt
         7pAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794556700; x=1795161500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cRCmrTcuDzuXbT9PHoGFPY3Q2bG+sC/PN/tUK8/S120=;
        b=HgWj2mSVh8j/AanxxCgFvKI7M3Cp6Vk3BDFMY0F+7Q5wLDFnUbcvhGe5Gdn+c/QHW4
         0s/o9254KZ8lQW2kXaIrbbW33ljgyYkAkohazFNIjNkX1S3/QtfpUiVnvLrGrWWrxsd5
         mS8yLJNcayTwcEJ30BZsMfHzmJvgdOgrqzUVNJziphJ7eJUXpHe4u0FZ9KTRpDcRR2zM
         HXTLEZvDD9XFoK1+ZC40k8wmsvDKPba/sHe0F+LvpYe1mm8bFiW2iCF/6vxyw4yfAlFX
         CRf9x4ch3motCQSQ5dcbrr3x9+3HSSPChB2jd9jdJqhODbt9E5GiWqdD88jvUXw1w32t
         Vg7w==
X-Gm-Message-State: APuU4Z91TKIESzo27sMwKeeMKfAfCpnBiAB/0ZDQ6hXbmWxdsJFxSfWs
	46yxLQgEj2ie/8viXs2THLqw7QwDtAezJ2+LL5NUX7UXi+8Q6aWhJjdqKzl7jkKc
X-Gm-Gg: AYBFou3zzTTl76lukdR/vf5DkqWGrs9OJn8qFIdMGinuYt8GozkOFnxi26P09Y+pLfc
	P5H4rolxN0kvNt4aYJGcNPA6bjJykhGQIv4zFDRLbIzmh/s1AizhM8uV3b4plpmu7ac9PpVG3y6
	H7hI7HjIrqJ26RatDxOj1xmF8gpAJpzfMtuwFVrKA7cyaNJG0EZaZHJHAJNsMtY1jpYgEW/ySJ0
	OYIPrRWoP+sKFVQ97thfwaJPic/5gPMpLC+W0txI3Btcx0cn07bu+EP/bbOlt69kXfg1zYbTWq7
	4E3m6+PSiV7cJ5BrvtZm8a3cOnHD3s0PRgVTSLyY8xwJ7iJkA8t2ePq75x26KMmzE+rCPpfqD4Q
	pruIibzJF4/bBS9tAX7zuXTAUN9tA5RqfzcAk9xWaRqiDp5lgvc/NBJDHFlNiphKNamRRhomWhN
	xElEfpcWYL9WMC/chMhatg39M0D5ZM6I/WVOeoMuyOperndDNqrf7DMOtGVlAZk4EdENdXjRjCo
	1VwA8sxTIKQoF6V4m0t8j8/SEqkVjQMC8geehkbNhrWPjj/uld2vHS0HGmmOBp6SpxRf/89Jfxq
	ecgNyr3kY9W0UQs+BBWBYF9xPRrS2OkQbsqwGrLSmeCkmw==
X-Received: by 2002:a05:7301:d183:b0:371:32df:5ee2 with SMTP id 5a478bee46e88-377e15f0744mr5183821eec.16.1794556700340;
        Thu, 12 Nov 2026 23:58:20 -0800 (PST)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3795591f4f8sm5187207eec.13.2026.11.12.23.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 23:58:20 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	stopire@gmail.com,
	zhanxusheng@xiaomi.com
Subject: [PATCH 2/2] erofs-utils: lib: fix metabox inline reads of compressed files
Date: Fri, 13 Nov 2026 15:58:14 +0800
Message-ID: <20261113075814.1526283-2-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113075814.1526283-1-zhanxusheng1024@gmail.com>
References: <20261113075814.1526283-1-zhanxusheng1024@gmail.com>
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

For an inode in the metabox, a tail-packed pcluster is in the metabox
and m_pa is an offset into it.  "erofs-utils: lib: fix metabox inline
data reads" handles that in erofs_read_one_data(), but
z_erofs_read_one_data() still reads m_pa from the device:

  mkfs.erofs -m4096 -zlz4 -Eztailpacking t.img src
  fsck.erofs --extract=out t.img

fsck.erofs fails with "Failed to extract filesystem", and files whose
last pcluster is tail-packed are extracted with wrong contents.

Read such pclusters through the metabox as well.

Fixes: c6903c7e32a1 ("erofs-utils: dump,fsck,fuse: support metadata compression")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
Complements b9dd73f, which fixes the uncompressed path.

 lib/data.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/lib/data.c b/lib/data.c
index 9b5d00f..8de7162 100644
--- a/lib/data.c
+++ b/lib/data.c
@@ -315,6 +315,19 @@ int z_erofs_read_one_data(struct erofs_inode *inode,
 				   inode->fragmentoff + skip);
 	}
 
+	if ((map->m_flags & EROFS_MAP_META) &&
+	    erofs_inode_in_metabox(inode)) {
+		struct erofs_buf buf = __EROFS_BUF_INITIALIZER;
+		void *src;
+
+		src = erofs_read_metabuf(&buf, sbi, map->m_pa, true);
+		if (IS_ERR(src))
+			return PTR_ERR(src);
+		memcpy(raw, src, map->m_plen);
+		erofs_put_metabuf(&buf);
+		goto decompress;
+	}
+
 	/* no device id here, thus it will always succeed */
 	mdev = (struct erofs_map_dev) {
 		.m_pa = map->m_pa,
@@ -329,6 +342,7 @@ int z_erofs_read_one_data(struct erofs_inode *inode,
 	if (ret < 0)
 		return ret;
 
+decompress:
 	ret = z_erofs_decompress(&(struct z_erofs_decompress_req) {
 			.sbi = sbi,
 			.in = raw,
-- 
2.43.0


