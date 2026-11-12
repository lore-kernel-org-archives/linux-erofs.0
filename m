Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8460606A321
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Nov 2026 12:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=t8kh5lWG
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQKtM694Wz30V0;
	Thu, 12 Nov 2026 23:47:55 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::631"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794487675;
	cv=none; b=hcXfeJHLFOa3nlEZLF3Ie+esjFKXGQTz1ztdnVPqeFsBlakZTuFZaRr87NmD4XAsI1HHbIRzOgUlRvW70vXuzAUWbZT4TtlBJ3/09iDlb0goYF045/WN9WH7BiypSLhwXE+dNWtx4uTcygKbCER1TE5aUPfcha1TE3yuPaTnU0jD5pw8ZdNomrI9w8kJhM/UzCkz8yRwCXRSEdjLTOUJf7HlvEwbtG+gCwItq/JvJSOcu1V9jO1uY+3SE7rdyx5teaa32dHoa+XT90sTNaU9t3KPycisR7jwJkVKxNwJWaPBnDzIdFYQ7K6HDwqiJm2ryfODCW6jZoMM6CNJJP9/mA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794487675; c=relaxed/relaxed;
	bh=OCF7bPRB49mMFwuc2l9yrdsABP4d/Uf6DaIKeZhPaDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSMlPal9sJe1vRR5ZS+RQJmxXipk30iA37Tz+Gds7xAf5BwwLTQUbdaROrKclk7+19+zQvt4W/t5a0hP5YxCfyZ753h7J6zKiuhCrA3pfZteXB4/J2yNw7+wKjp0TDD30kLS4GkgPcop1BlWbjbWmile4BXGqaO5E9lxUzzKDHEbvJre8AZ1dITABIFu462pl0GbH157FL1+IxLEA+T/5qmhYCwNv6ZaT7KQr3D6tSfVA8Sp72nmU+oxPkIlq990/UZ3uQ81hYLuV7vycvjxUniCtl8mIt0hJXFr0OPaBTACi02pI+QorjNXISatzyN1uoHrblNhWxS/B0zhOh0Yaw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=t8kh5lWG; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::631; helo=mail-pl1-x631.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=t8kh5lWG;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::631; helo=mail-pl1-x631.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQKtM1dbCz2xly
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 23:47:55 +1100 (AEDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-2ed2bfe3252so16167945ad.3
        for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 04:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794487673; x=1795092473; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OCF7bPRB49mMFwuc2l9yrdsABP4d/Uf6DaIKeZhPaDo=;
        b=t8kh5lWG+VGhFFyTCVVmSV4O9FSgFEEX/xaP1g7fi55LCSp6IXmWnWGCMKaDZWSFb6
         DH3I/Xx2zlPThfcKmCuZizucabywv36XcGGkZpzlEy+Xyk33VcCU4x5vhtPNuolb9bxF
         6Hs2xzjv/gyu/j3AETDQ+YXfIdmlcAQio7IK2O3vATl1obE11gftviO0ksViV70MfYO4
         6rOfgzGIGHCXUTFZX11AA1qbvCBCE/Z0nPTPFAbPTs9blTw/INEU779ASP7cyVRa4yPn
         xx6M+QnNmJ7T/r4UYgp03zLTZtJ66piVk0dUbPHIom9pRu+o91z1xu5Qbnnt4FaVXVBP
         +skg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794487673; x=1795092473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OCF7bPRB49mMFwuc2l9yrdsABP4d/Uf6DaIKeZhPaDo=;
        b=LrPBy4NiAh7qT9EIwYt6Hq1yFZpvUm2QCW3SjAzp57cAMIH6N3ntNYu20SbOHTqc9d
         oynr9YMk3iSlhXiimv39O/RdEU3o8jyOgvoWZMU+Oc6h+piIlrxtaAuByXA4niblUN6s
         iy1En6cD9YRTCJjUKGOhU7UmO33/y/Yg5qL1gMJdWQpTnJx2X+MrkuZW1l+9GDB8ZknY
         +4V+vLDSLnwheRHbZvkNTGsPpVF53ZWParj3HPY9pYwUGlLEi7jJ868o433AjL6thMqq
         b+sIBdy/R2+x4ckPrKwEP4cLSOJ0FfC2QoTQmr77j9e0GJEVWT8AcL3H8N8UH3/9Lwtf
         4xpQ==
X-Gm-Message-State: APuU4Z+H93Oc8nPhL3NTZpyjYYyC46/1c6NZZ8HrL3kZMjJstfNH37y6
	A8OuiPr43N1FTsKWZg2x2D/FbzTqiTtT2GQy5R1gZFpmmz9PykrUz0AcyBE4zATxY40=
X-Gm-Gg: AYBFou20xftCfNWKvZxLdoPVIQdnWEC659d63pvdspF8E5ssEGmIV2ytyQYcCcfdcdU
	QINvUpwenRDRRP2q8AF553jUnXBzKDWyW/9u57EGoDUt3PymAiUdRK5i4GoB14/JrLs1j/pKaNl
	1xa33iPeUZ3b/kTWs6WYxcKT7tPjt2Po6ZA8CiPyw5c21OexxQCIjALuLXb4eSS7cgoAzqld9pX
	kFV84fAYuaIqXWFgCiBmd4W9CTDF6SdP2A6Tlurc7tNF03JAgK0ToeuILvv8q9D0E0azIJPrkq9
	OAk8GJKfbu46xGJBqEiWB+5XfEUx3so/HhhsUH3mn03DE2zp08XbS0iu5yECWdVbWPTj6XCS+7L
	KZHZ5/ICHXZH0ApJ7cPiuPOnmvXangJkZG/HoRKHgkFQxgFB+jNdOassr48gynLyw99XX/kfcQw
	pUyNMsZsnhNVWyibb+JFHCRQWxkpvGYYTSHl5feF4gZ1D6LjJ1ZFiQQTJ0uU+VhAJBMlCVCOP4o
	9WRs7+NSP2H1lQnCdF4+MQrRZYStO2AvHcmGmar3TESZngJ0WQEgYNFKaA0+x4z+sMfN6vPvZ8m
	F80odoGx/qYfkeJWqmoBxc7X9fzABVsI25E8LC20oWrq6+lD
X-Received: by 2002:a17:902:d583:b0:2ed:4ea4:2dc9 with SMTP id d9443c01a7336-2edd770aaacmr56851845ad.21.1794487673003;
        Thu, 12 Nov 2026 04:47:53 -0800 (PST)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6dd2225sm34189905ad.56.2026.11.12.04.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:47:52 -0800 (PST)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: Yifan Zhao <stopire@gmail.com>
Subject: [PATCH 6/8] erofs-utils: lib: fix gzran EOF handling and state leaks
Date: Thu, 12 Nov 2026 20:47:23 +0800
Message-ID: <20261112124725.2774244-7-stopire@gmail.com>
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

An initial EOF can produce an invalid inflate input length, and the
state allocated by inflateInit2() is never freed.

Let's reject initial EOF with -EIO and call inflateEnd() on all exits
after successful initialization.

Fixes: 80b2ba447fb0 ("erofs-utils: lib: add gzran virtual file support")
Assisted-by: Codex:gpt-6-astra
Assisted-by: Claude Code:deepseek-v4.1-flash-1017
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/gzran.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/lib/gzran.c b/lib/gzran.c
index a75756c..dcc4497 100644
--- a/lib/gzran.c
+++ b/lib/gzran.c
@@ -231,7 +231,7 @@ static ssize_t erofs_gzran_ios_vfpread(struct erofs_vfile *vf, void *buf, size_t
 	bool skip = true;
 	u64 inpos, remin;
 	z_stream strm;
-	int ret;
+	ssize_t ret;
 
 	if (offset == ~0ULL) {
 		DBG_BUGON(1);
@@ -257,8 +257,10 @@ static ssize_t erofs_gzran_ios_vfpread(struct erofs_vfile *vf, void *buf, size_t
 	remin -= inpos;
 	ret = erofs_io_pread(ios->vin, src,
 			     min(remin, (u64)sizeof(src)), inpos);
-	if (ret < 0)
-		return ret;
+	if (ret <= 0) {
+		ret = ret < 0 ? ret : -EIO;
+		goto out;
+	}
 	if (u.bits) {
 		inflatePrime(&strm, u.bits, src[0] >> (8 - u.bits));
 		strm.next_in = src + 1;
@@ -294,10 +296,10 @@ static ssize_t erofs_gzran_ios_vfpread(struct erofs_vfile *vf, void *buf, size_t
 				ret = erofs_io_pread(ios->vin, src,
 						     min(remin, (u64)sizeof(src)),
 						     inpos);
-				if (ret < 0)
-					return ret;
-				if (!ret)
-					return -EIO;
+				if (ret <= 0) {
+					ret = ret < 0 ? ret : -EIO;
+					goto out;
+				}
 				inpos += ret;
 				remin -= ret;
 				strm.avail_in = ret;
@@ -306,8 +308,10 @@ static ssize_t erofs_gzran_ios_vfpread(struct erofs_vfile *vf, void *buf, size_t
 			ret = inflate(&strm, Z_NO_FLUSH);       /* normal inflate */
 			if (ret == Z_NEED_DICT)
 				ret = Z_DATA_ERROR;
-			if (ret == Z_MEM_ERROR || ret == Z_DATA_ERROR)
-				return -EIO;
+			if (ret == Z_MEM_ERROR || ret == Z_DATA_ERROR) {
+				ret = -EIO;
+				goto out;
+			}
 			if (ret == Z_STREAM_END)
 				break;
 		} while (strm.avail_out);
@@ -318,7 +322,10 @@ static ssize_t erofs_gzran_ios_vfpread(struct erofs_vfile *vf, void *buf, size_t
 
 		/* do until offset reached and requested data read, or stream ends */
 	} while (skip);
-	return len - strm.avail_out;
+	ret = len - strm.avail_out;
+out:
+	inflateEnd(&strm);
+	return ret;
 }
 
 static struct erofs_vfops erofs_gzran_ios_vfops = {
-- 
2.56.0


