Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340B0606A31E
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Nov 2026 12:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=O4wHjT+o
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jZwCY41y5z2yLH;
	Thu, 26 Nov 2026 23:02:33 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::32d"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795694553;
	cv=none; b=owb7JpfxXo9SDmVcgogzZZjrxM6aeMwAG2V0JBS5YjNnMwsIFGklqU5jy83q6V4l+15xbKKmU0y0EL3/O01OyYYPOxRNovaktjZV1Y8B29D/IHD9XfKxK4zkdnfO17tx+cbPoB3vcjrhv9eCYeXvVGTrkhsY43ThjELKgjseedz14Rwwghhoi3mOi7iAq7ZEIXDhS8qVEdNAJuwn0mP7lFpsE48dtyWOHE4AFfnDfMJUZViw9ZD7g+ed9RuU1VxPFXop6WX2HpRoshUb01rB+Qfh1HjsiKomW9FK027jYVpC0Fj+O3HRQ0VFJx+IdtCEP6aopEFXcNeyVhJqoVVxFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795694553; c=relaxed/relaxed;
	bh=SV/qCxWa+yQYoDj00pGYYwUKm7NNyQpYSB1VoAmS67I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDrh3sG0er5VOBw/d7LNfYn9KV6ke4gw+YYKTvGfGRQaIckkqUTN/BChWnwKs+82LndmyyaGdIL1NQ5weiRWFCku76hArZvJiLnQNh3R5ETjjSJbhTiWcciuAc3gBUHcpj7amD7Rvaq62A4Wz2zTc65J63/DMkERhYCnjBvFCe1qhXCVBqh95JNBjbBVfzm1JOgYa+vX4TMUcMsdVkcNE1Ho08Sn8W8uSVsQXXhAZt2Q3pnlotFolxjGjnQ6K05Pxp3OYteNiGw60d+GspzsmDihBtAqSP0e0YYi4H1vTSIIJLZDOPkakzDn5Oum7Xmk+N1vCP/+qQgASs+cNlDATA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=O4wHjT+o; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::32d; helo=mail-wm1-x32d.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=O4wHjT+o;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::32d; helo=mail-wm1-x32d.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jZwCX4Kbdz2yLY
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 23:02:32 +1100 (AEDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-4bb702a7548so62591015e9.1
        for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 04:02:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1795694549; x=1796299349; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SV/qCxWa+yQYoDj00pGYYwUKm7NNyQpYSB1VoAmS67I=;
        b=O4wHjT+opcmpHAz8YXHm+W2Q2hsvGCFPcDqjagouRiGRxsYiVSp4OicHTaK/GmTgHy
         Z2mjNQoiyEqFGxumQvhJNmbTsTw2PPwKX1CWF4Hgypzd01c9FihP2q+i3NVo/F62ruBq
         nvT+z2AaLJB9Hf0ZfO7TkVuKcxnGufMAZOrfINVlKuTDKZ+S32+hNNuSgi1JlkmdcZxT
         FZW4px9VM/eweRAh/mno8w9KkdrdePUBnRzKF+RxPvRXo0JOG07LgU1H7hIiwJi7MyA5
         RiM++lvZrk811EW859i8dHprnldIK1c13iG7Yu6KYlCfz7Z10SBMuk8ycswScUyYse/B
         wuvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795694549; x=1796299349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SV/qCxWa+yQYoDj00pGYYwUKm7NNyQpYSB1VoAmS67I=;
        b=gIyXqwvhTxtbiUPo1XhXMrMJdGjKPju74a3G8/CMsqsIQm3NHrY7Am2z+wd97jGgED
         MP6yr4pnko/2C+cDbkxN26zW/QfQ8Sa7FmIU568ZuslABWTS3HSij7YkIVqIPES1OZeZ
         +a+sSVDgiqPALaJd34QAV+3wDw+LNacoN9XpA+T4DkgyIXdpOAFbzlcE2KLIIQL371eC
         rxsytpf3pwRs4LdtF7QdmTEG2oM0TTx3WDDJZH5GocSH4ygJdAfxscqovEigA8fSM0ka
         uF3LRQ3CKD0cxsaM3rnPa829YUxFGxHrVpnz6jnus0bUFmbcXPoSOQUo+g3Hqilb781I
         fseQ==
X-Gm-Message-State: APuU4Z9Bkr+r6T3Mrzuir6jYXyxsl/C6RHun09CVNtdoa5bY0bOBZIwh
	cfeYrxxKymFSjJb2vsuiQLR0qTKPNFYSYZ1ONDS7Cws9U1A61GZEiNtha6RGuT9Q50a77GqnM5M
	ekw5Y5IU=
X-Gm-Gg: AZFdTZe7gmqLvJyCjxbYeMhSGk0GdG2fVhdqmpQQ371Sf245AhB2TlT++spRtxM/y+A
	I2jU0TpVJETglSKkTivBRCOflR1NNXzF+iXhbihoE3K89ktwhPHPcin3iGfT8WvJ7SMhpRBbli2
	HGtgRJjJRS1gzfXKp6WlR2UnSnPWVqmJeaSatMZOixQgCI8qQQ0csf5kb/5ItVex7xzsvu/ejQC
	Q/GruiKwEiMeScXeqzGpqLAnrVEt09Ag9xj2qavankGjI84QNfOcbWLwxw2xqwDaInlFzBYtkhh
	ry3guv+0dGSSqhC/u9Lb+sxZO+/AZOEHxq3ND517bBBtQw8dIIupM7czA3rBRchdR2sJLiy6nbW
	QDNT5mzXieyegAM8qv1yfyAgYZAe6bBCUYHmyoroH2aZhTuKiuIfoG6cIV0YmpPp3rTlnKSVK7k
	ciy4ZXDR4tC/9l9qTd6p4Fse+3917cPq4GMfSr0dtkJsgWRKGzpr7lHSsq8CwhxKOfJY/oIyIMy
	PS7+zHLF3IIPLNx4RWYvW4eTbcd9jpEWfdfuFM/ZZNhwDIZ+r2W4dvItFqnYdAjhz/Gofq3eMBu
	uPV1Pt3J4RmOo+hNcuGBFXiWaHPmbBcTFL/EhjRQlm/KV85qJ3QjvCpm0yvR3fLNPYAjzy2ZRqa
	7HxRD+oJa3DZvqg==
X-Received: by 2002:a05:600c:840d:b0:4bb:6814:738c with SMTP id 5b1f17b1804b1-4bb88820cedmr434704815e9.22.1795694549013;
        Thu, 26 Nov 2026 04:02:29 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:6060:1d3a:5489:cf84])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b7515sm819402455e9.13.2026.11.26.04.02.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Nov 2026 04:02:28 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v3 04/10] erofs-utils: lib: fix hole detection in block maps
Date: Thu, 26 Nov 2026 13:02:15 +0100
Message-ID: <20261126120221.4384-4-xiang.gao@docker.com>
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

Block-map entries store holes as 0xffffffff.  After erofs_blk_t and
EROFS_NULL_ADDR became 64-bit, this value no longer matched
EROFS_NULL_ADDR and holes were treated as mapped blocks.

Compare against UINT32_MAX to recognize the 32-bit hole marker.

Fixes: eeceb2289513 ("erofs-utils: implement 48-bit block addressing for unencoded inodes")
Assisted-by: Codex:gpt-6.1-sol
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 lib/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/data.c b/lib/data.c
index 91809d0..3ccd109 100644
--- a/lib/data.c
+++ b/lib/data.c
@@ -151,7 +151,7 @@ int __erofs_map_blocks(struct erofs_inode *inode,
 		}
 	} else {
 		startblk = le32_to_cpu(*(__le32 *)idx);
-		if (startblk != EROFS_NULL_ADDR) {
+		if (startblk != UINT32_MAX) {
 			map->m_pa = erofs_pos(sbi, startblk);
 			map->m_flags = EROFS_MAP_MAPPED;
 		}
-- 
2.54.0 (Apple Git-157)


