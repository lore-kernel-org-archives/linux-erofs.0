Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E77F606A320
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Nov 2026 07:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=UylIE8HA
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jVVsK1LYnz2y0B;
	Thu, 19 Nov 2026 18:46:29 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::234"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795074389;
	cv=none; b=CxOlze7tNv6zzRFJ+Tj2dPa8DyRu5cyXU9rsjm0nS4SsysxuUU/wHgWuqQBDymXC/ZBwqeme3bX1Pe7VkJGmozZksqHdjvqWdNpbwxPI+ClCbtOy447tRRfS0ndCcW9FemqMiyV/mxbtpOO0fYdgBuvSgMqgZLqG34CBwsHzyg8VbA4lUdAq1LCvf3EFjx+hLGbVqWxqwWFH/fwG/KIzw/y7X081eUfBTzomRVfXZpHfec0ios1+L8FTcdXsuDnrK70+MAjip3C8DgkZLymV6OKFFIwvQqekDSPNUnuswekbaq6sj48XhmLelf8GhA0oDExeNzxMBwCrmlehChYtXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795074389; c=relaxed/relaxed;
	bh=UZs/dyfpjoJoO16/1CzXQFr98TVpXrDM+hkMGo/Y928=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Uk5sWRj6JhsX5CQWEiTuPj5T2DbvRmzgDPFl7gOfOAP5MYIfqCioiljEmRvpT1mCxV3W9xqAn6sN/sxl4yld/quHwqmIe6M1jiueevJhlLpFBwN6cH5Rs8RwS4OJ76e9NLB+Ef0fGjBQAHvaN+n4/zY7DX/UUnBzbrAF/T8wFzka+XQMqarItEWosRTe8runESH0JLajzRQjvsevVaELhGFyGb52yQgitqbf3eiCgkRjCfE5OsM/1W3qm0FJjFIPJYNO4IXViL5WomygCDUzeyQtxCbtfG47i5+fDvMjunXlnYS/fynZIvt4IblzjYGh+Qjv2TaNs2PzDVyjfOMGCw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=UylIE8HA; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::234; helo=mail-oi1-x234.google.com; envelope-from=uekawa@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=UylIE8HA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2607:f8b0:4864:20::234; helo=mail-oi1-x234.google.com; envelope-from=uekawa@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jVVsH2mkcz2xlk
	for <linux-erofs@lists.ozlabs.org>; Thu, 19 Nov 2026 18:46:26 +1100 (AEDT)
Received: by mail-oi1-x234.google.com with SMTP id 5614622812f47-563a0462094so908541b6e.1
        for <linux-erofs@lists.ozlabs.org>; Wed, 18 Nov 2026 23:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795074383; x=1795679183; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UZs/dyfpjoJoO16/1CzXQFr98TVpXrDM+hkMGo/Y928=;
        b=UylIE8HAmPoipzPDkF7b1ERWYIzQQA7yGTdhTKHwW7BwXfsE68D7KpVshTsllc8TaI
         jQRYKR/jcM5pRLTrXgXBHgPLUSshIOJ4wyg8HK7LMBMQzauFx1RcZCv4rsxLiZOirH1O
         TNqJC7QQ0uiap/e47Kga5t6uccHPpIrKS3HpA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795074383; x=1795679183;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UZs/dyfpjoJoO16/1CzXQFr98TVpXrDM+hkMGo/Y928=;
        b=YJpp40vr/CU1laDw7gZuLDZ576XzTt/RYQsXkIraQD4Gl8AOB0a+SzcjDSHtfwLEZu
         rlTSsXtnAJs1IuNr9BIBvm6sJeAylvR0ESvXJ0x19rTpvIIcKIeuSgDY77yT6TWDZLli
         2fqcgF0PU3Am66+FCN7UJeA84i2YC8FhDvdshyS6yzccCU8FitD9zgH6utV6KhTLSld6
         qIMuLqLIf/8SuwEz1B2xer0g+9OI4AbpwjQnSoNmbKB/oBm+Zy9A4ZwvzrquX6MUDhwc
         VuA+aFmmw+DgOCWJQrpOSCqyWwt31tbGKMoA4tdlw4PverwYkQjSMt1c+leFP3Ox+a1j
         uTvg==
X-Gm-Message-State: APuU4Z/FlPaxEsCt2Ei+XfAAkUr+HXARrtNU0vYai8vBAl7WStIH2ILQ
	UUpdgCh0JdYDxj8MEgJBf0Yo5Z2pBOQkwc6HunvBUTZaGV3Gf0Fay0ceLF6gQOfPidFpknB9ucF
	aGH2JfeyG
X-Gm-Gg: AYBFou3rCB/OpsXLWyWHLJ+n6zctnOQkqYxC6+anxhhs0Ws0zPYF1sSTybHF8qogQnn
	CpPYb+XzZ/m2uNft5l+9UB3zrrJfUlqrQ+cGnpweXjdcGHpFhmgBQzWCy/ict05z8e2et2YVPO+
	SCiiGRnw3aKtpYyo2P2a+okYIAfy9oTION4+eKuwcVG9121QwYFdOwGsJARopgEpPmQ/ICoqZIq
	trhkWy4SeiYFSCnOmJ46v24YdVICkg0vZkbVUrV3NdeY/DRijNzCudPFRVsIswx9/FLtB1978nN
	FPgjFHk00UUZO/nrX4DJOIgjPpGsqDLgolZAw64s3otuqapZ6nUx5O/qKF6pM8/le8YOpAy0RDS
	HPV9120k6CVFQXr8Tc3Gxg113SkPLwtM3ArHsRZQBS8v8b8+7SvuyjGn2laMntj8O+PkOgDs05Y
	+VYeHMZhj+S1c0bEJdkEFcCv8esl7C2ff0xnL5jv2Ikxtp2bsByX1APZpcQqje9dCobYPRMw0Ga
	UeUztkxVQhfbClDXKWIGIB4Sd+eMS2PI3AwmjvF4a6+05Ib3fsY92IJHPKoSmIRT+frQwJlUg9T
	Z3ZChYEfriiU/62w3lA8gZideAVt77d66ucaXzagR325EsUsjUSaVKsb7vILWla6PBDvHYQ=
X-Received: by 2002:a05:6808:1513:b0:576:4595:9837 with SMTP id 5614622812f47-57742f42bf2mr5751842b6e.46.1795074383478;
        Wed, 18 Nov 2026 23:46:23 -0800 (PST)
Received: from localhost (139.118.171.34.bc.googleusercontent.com. [34.171.118.139])
        by smtp.gmail.com with UTF8SMTPSA id 5614622812f47-5777a2bbc1bsm3397857b6e.5.2026.11.18.23.46.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:46:22 -0800 (PST)
From: Junichi Uekawa <uekawa@chromium.org>
To: linux-erofs@lists.ozlabs.org
Cc: hsiangkao@linux.alibaba.com,
	sarthakkukreti@google.com,
	jaegeuk@google.com,
	Junichi Uekawa <uekawa@chromium.org>
Subject: [PATCH 1/2] erofs-utils: lib: use one-shot EVP_Digest() in erofs_sha256()
Date: Thu, 19 Nov 2026 16:46:21 +0900
Message-ID: <20261119074622.2199394-1-uekawa@chromium.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
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

Commit 26ea086bf721 ("erofs-utils: prefer using OpenSSL for SHA256")
calls EVP_MD_CTX_set_flags(md.ctx, EVP_MD_CTX_FLAG_ONESHOT) in
erofs_sha256(), which breaks compilation against BoringSSL because
BoringSSL does not define EVP_MD_CTX_FLAG_ONESHOT. It also heap-allocates
and frees an EVP_MD_CTX on every one-shot erofs_sha256() call, and leaks
md->ctx if EVP_DigestFinal_ex() fails in erofs_sha256_done().

Use one-shot EVP_Digest(..., EVP_sha256(), NULL) in erofs_sha256() under
__USE_OPENSSL_SHA256 (matching s3erofs_sigv4_header() in
lib/remotes/s3.c), and free md->ctx unconditionally in
erofs_sha256_done(). OpenSSL's EVP_Digest() already sets
EVP_MD_CTX_FLAG_ONESHOT internally, while BoringSSL's EVP_Digest() uses
a stack-allocated context with zero heap allocations.

On AMD EPYC 7B13 (x86_64 SHA-NI), median erofs_sha256() throughput:
- LibTomCrypt scalar (--without-openssl): 216.2 MiB/s (4 KiB),
  210.4 MiB/s (32 KiB)
- EVP_MD_CTX_new + EVP_MD_CTX_FLAG_ONESHOT (OpenSSL 3.6.5):
  1332.6 MiB/s (4 KiB), 1481.4 MiB/s (32 KiB)
- EVP_Digest() one-shot (OpenSSL 3.6.5): 1341.3 MiB/s (4 KiB),
  1469.5 MiB/s (32 KiB)
- EVP_Digest() one-shot (BoringSSL): 1468.2 MiB/s (4 KiB),
  1509.2 MiB/s (32 KiB)

Fixes: 26ea086bf721 ("erofs-utils: prefer using OpenSSL for SHA256")
Signed-off-by: Junichi Uekawa <uekawa@chromium.org>
---
 lib/sha256.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/lib/sha256.c b/lib/sha256.c
index 6eefda4..cf14c3c 100644
--- a/lib/sha256.c
+++ b/lib/sha256.c
@@ -38,9 +38,9 @@ int erofs_sha256_done(struct sha256_state *md, unsigned char *out)
 	if (!md->ctx)
 		return -1;
 	ret = EVP_DigestFinal_ex(md->ctx, out, &mdsize);
+	EVP_MD_CTX_free(md->ctx);
 	if (ret != 1)
 		return -1;
-	EVP_MD_CTX_free(md->ctx);
 	return 0;
 }
 #else
@@ -228,14 +228,18 @@ int erofs_sha256_done(struct sha256_state *md, unsigned char *out)
 void erofs_sha256(const unsigned char *in, unsigned long in_size,
 		  unsigned char out[32])
 {
+#ifdef __USE_OPENSSL_SHA256
+	unsigned int mdsize;
+	int ret = EVP_Digest(in, in_size, out, &mdsize, EVP_sha256(), NULL);
+
+	DBG_BUGON(ret != 1);
+#else
 	struct sha256_state md;
 
 	erofs_sha256_init(&md);
-#ifdef __USE_OPENSSL_SHA256
-	EVP_MD_CTX_set_flags(md.ctx, EVP_MD_CTX_FLAG_ONESHOT);
-#endif
 	erofs_sha256_process(&md, in, in_size);
 	erofs_sha256_done(&md, out);
+#endif
 }
 
 #ifdef UNITTEST
-- 
2.56.1.750.gf70dc682cf-goog

