Return-Path: <linux-erofs+bounces-2730-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8B73F013CC
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Mar 2026 07:58:45 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZ6sv3w5bz2ygh;
	Mon, 16 Mar 2026 18:58:43 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::636"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773647923;
	cv=none; b=C2Dc3H0imYahw5Imq7N3MaCCXp3UQJ5mQP/TY29fikR3K0QUk0nyqYia2F8ujg1zKvPZ4UCqZJ9/moJuhlU3M0BTMjU3dqwNgHeOUhulxqrX/k5B3XQTGgYYMctF+w5irlJFUCF2rFRXGsppsg6M7z/vAWwJ8MThyB9cUDatuiMINDaW04kMEJBg4XcHl0tIBVD2dHlobcfQzO5XSH2hISbzaQi7WlQB33l9Xh0f1TMUrTDilWvL+gb1/YJqVJeGhFADD8DRhDiQHGA/dVOyoXcbYjzw0H34ZrSel69MV2irAaoBHeHpa3KoUsbuPCGKqTBK6kiuXXwHZ0qmxqDjlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773647923; c=relaxed/relaxed;
	bh=20DWZIEPhk3Wxt6WQ4zMMLXfwgjdpkbq2EWQvGpx6/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQ6g4Gr9LMIxvkOxTGdKms7eHzD5VFL60JWwkOwUk8Yy6tu0tsgD41fcdLMwe/TcvH31z3ckom2KKOEU2lmBar+kwgXQRcXJR0509W2Q/kfRYl/kg5cWh3ZcA+7oPGlDO5dEVyJduwT8/UATuGfGLC8hz4m4yoiNFCZ2EMYHi1o5GPMvWfDyTXIypDmRM92NKThL639vkotOJlJx5Kn9bOy3hBVyLc9QIpTrJNe21xFHevuO/BNkGGnojWy7JZGXFrlbSx3U+zHLJS3P152ELjBXzblZknXE4Sw/M3bg+Og+UG4xC0qeTVUap0AQ7YqnE0ysSt8/2h1OY8LkD5t1Jg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=NyWC8chY; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::636; helo=mail-pl1-x636.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=NyWC8chY;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::636; helo=mail-pl1-x636.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZ6st5kPvz2xln
	for <linux-erofs@lists.ozlabs.org>; Mon, 16 Mar 2026 18:58:42 +1100 (AEDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-2aecab39ad2so2736825ad.2
        for <linux-erofs@lists.ozlabs.org>; Mon, 16 Mar 2026 00:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773647921; x=1774252721; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=20DWZIEPhk3Wxt6WQ4zMMLXfwgjdpkbq2EWQvGpx6/8=;
        b=NyWC8chYMi6AV5Snnc4wN2CagjGTboXwLgGSL6rfbJrJ3LqDIx1YvbiFv0BGQ48rTu
         y8OlPQrUvMjm610x+Q5+0pMIqcEsE/L9r4ysN10AAhA4NFqnbUcLM7mjNqotl4agvuMJ
         gerpS9MxjBSKCWAPQ3l0KcRupyj3f0+EeGjDmxeu8JPkxunFu3hqmF8drk4o1rHzIEbu
         KPRh8uXwSz71LWjOvWN3zKmOX5Lxg2bGnqzFYyuVoa6/KDPOUcAl5jP5hS6l1cjZdACt
         sQqBU1RjNrcvjljfxwzEO4iIL+Z1+Ij9I9IoQ2frXl94JBVavd54Zg6HrN91tjIGC/ou
         PYQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773647921; x=1774252721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=20DWZIEPhk3Wxt6WQ4zMMLXfwgjdpkbq2EWQvGpx6/8=;
        b=bU/Bbbnzzot/vL0Xx/rYqsVmlc0lS0p0wUSHFqRjgwoBUfdf+EvrmkcmLnh6XU6aIY
         XRryq+C0qHcMfVKDgl+JOwQgitE3PUi47s135fpp+EGW9JHcvZOatRZktDNI2KIh1uRP
         QVmp1S4m+PpGL7L7muYe3DQxu/WHgis+ag2JPNRpfp60lD28SMAaj4T7DktF1RaaDkDW
         edCHWwE3j4PN5oUBWJda6zLJD2ZwARwbdEXvNlEF6zPWKZEnm25diR3IbwZZF+9DEcQX
         KlMjqPCkKK5ot4QECErGEvdtEv1zQu7TUwIJK38MBjK3UwjsKl6i9oHlm6cvf7gDxRu7
         +oMQ==
X-Gm-Message-State: AOJu0Yw5DYgUpc3dSynDWq9VuBcR4Gk67M4sqNiOcCCrkYbOmHkw/Yds
	gAvXXBx54Y8JnwOnK7PvCdr1+d2FKQR+gGJgKQ/mSQ6CGL2VboxBi0qol7MXiuJz
X-Gm-Gg: ATEYQzxQ0t7oGyNpY4IC7iJ5pnr77ZwOQ4aKruwy/37WcrTp+4o5cUf4uqgYHilnAfH
	o2kRkvsCV6uw1SlwqRV2Bu2t4p+bXdPe0hdfmY0ChnENdLmTxYJQX8LSgmbvCUhiUj2ZpRxzOu5
	4JRtZ4ncd7npwgMmi6CIo2yKxINv1Po+tXaCEns9Hyym8eI5Cs5f1q3MsSQmp6YkZuDujheZqGE
	wr1puAKN5fJu707u2blbRVaYgkFBmV4oKz8WZ5BGBA7CsKkaEjhwkuCJzqguQFcT9F0Nfivut4l
	Php+PP98BDp5ByD2LFSu/J6UsSApJrm0GbgcWVl/VER+448GkofT8WspBwBQTqP5mIjFAYWfX+5
	BsCZOanhzTx6MDyfqQoUQYPz7NXOnxhd8aIZlpUSb4GqxOPxiRYuHHtiVZdWG4Yg+oK5BMBSDBy
	Danb+wDvnSiuuYD4KD0w+JyrEKEshEWwOgYCrUzFAItwD+dMo0lBhQk8Nm2wDawDmw3ZBBSM7uJ
	OqJxvU6hjunKkGhizP24yTsqR4yjWbZfm4i+wJ9s3Iv3cSm
X-Received: by 2002:a17:903:18d2:b0:2ae:cacf:fc57 with SMTP id d9443c01a7336-2aecad0132amr46656195ad.4.1773647920588;
        Mon, 16 Mar 2026 00:58:40 -0700 (PDT)
Received: from DESKTOP-PU4IGQQ.localdomain ([117.203.246.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece7ed753sm124225025ad.45.2026.03.16.00.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 00:58:40 -0700 (PDT)
From: Utkal Singh <singhutkal015@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	yifan.yfzhao@foxmail.com,
	Utkal Singh <singhutkal015@gmail.com>
Subject: [PATCH v3 2/2] erofs-utils: lib/tar: reject negative size= value in PAX header
Date: Mon, 16 Mar 2026 07:58:31 +0000
Message-ID: <20260316075831.35495-3-singhutkal015@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260316075831.35495-1-singhutkal015@gmail.com>
References: <20260316075831.35495-1-singhutkal015@gmail.com>
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
Content-Transfer-Encoding: quoted-printable

The PAX extended header size=3D field is parsed into a signed long
long but no check is made for negative values before assigning to
eh->st.st_size. A crafted PAX header with size=3D-1 passes the
existing format check, resulting in a negative file size that can
cause incorrect memory allocation and heap corruption in subsequent
read or seek operations.

Add an explicit check to reject negative size=3D values with -EINVAL.

Reproducer (base64-encoded minimal crafted tar):
  echo "Li9QYXhIZWFkZXJzL3Rlc3QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAwMDA2Nj=
YAMDAwMDAwMAAwMDAwMDAwADAwMDAwMDAwMDEzADAwMDAwMDAwMDAwADAxMTA3NgAgeAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB1c3RhciAgAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAxMyBzaXplPS0xCgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=3D" | base64 -d > crafted-negative-=
size.tar
  mkfs.erofs --tar=3Df out.img < crafted-negative-size.tar

Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
---
 lib/tar.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/tar.c b/lib/tar.c
index be86984..6fa2cda 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -546,6 +546,11 @@ int tarerofs_parse_pax_header(struct erofs_iostream *i=
os,
 					ret =3D -EIO;
 					goto out;
 				}
+				if (lln < 0) {
+					erofs_err("invalid negative size=3D in PAX header");
+					ret =3D -EINVAL;
+					goto out;
+				}
 				eh->st.st_size =3D lln;
 				eh->use_size =3D true;
 			} else if (!strncmp(kv, "uid=3D", sizeof("uid=3D") - 1)) {
--=20
2.43.0


