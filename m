Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8191606A31C
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Nov 2026 07:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xC3x25SI
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jTGX30rllz2y2B;
	Tue, 17 Nov 2026 18:27:15 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::429"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794900435;
	cv=none; b=X5LotLSfut0OFrpDc86FVxo7lHZzS0b7lV7r4FSRS51CSGvQGaMCDKAdZTfajzSzKFPFPmK82AkshaXQ+3IlIFqgj6RzfgPal5bJn4aY+xOuxRnVhe/4gKiCsxltX8iDSR3H078//+XGWMin2S1blj83IWb6ucjmPZN+RpM8fjQkK1V14zhVMDuhSBIr9XFLOQCzvw3VsW9GOdrdjT+F9w+W/do4TqIDueDQJt5vhSU5nPCO1yE4AiSz/6TbwOfd/GH4Lvg1Cp1qia6jinPsVE1l8cDAUIeA7oD5AeUCGx1Ds9DRzq4qX+mbl9g1BDz8B4lhXul4bdSeu2Y9XtOdxA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794900435; c=relaxed/relaxed;
	bh=nulKLSDVoO04RkyHS8ZaNk6hUq+RiR0yz5unKqo3XOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXPcnGHpnEFLbEXMoBzdA5J2aIMziEv2ZgeNfahoEklhBcy1oz5NZdVdYX6+ncNrNwSQYODsmeBb8rnV3+PgZ8rInRhfAwRbSOI5CVV9dK4WpBBUG9VYj9RUMFx6MQ9NEOpiZpTfy+2IIx6l91kj2kKFpq1f15H5nM2x+CYXLrec7tKNEguzqxcAHUTorelnn6WtQgoBKKKA1yWXJiRV798qagPbBK1lXaQFSqWxQU8+svIdnPHxMJtBsoqrhj0aD+B5fQCuRlugvTMIQee+jIC9PZYHTOqSl83QUB4yeOft+45Wve/aB2MPB/O7giO8deOC7cmmZs0BNvweXpq8ag==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xC3x25SI; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::429; helo=mail-pf1-x429.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xC3x25SI;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::429; helo=mail-pf1-x429.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jTGX23RlSz2xPb
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 18:27:14 +1100 (AEDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-8b6a88e4341so1753606b3a.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 16 Nov 2026 23:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794900433; x=1795505233; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nulKLSDVoO04RkyHS8ZaNk6hUq+RiR0yz5unKqo3XOg=;
        b=xC3x25SI3Wu99KthrSndEheRc64lI9LmO1E2klKczX0TOc3zgT92U+3xVSTJWXk9Ty
         7/NmJLABNrPbISG/PNKDf8f+U2FXoGd3Xkr+pS0NqAWqhkPayG9s8XwAUGsifKMl55QK
         a5MUpziLTRIZB2ylzCsRe/tUiuLW4Yx1pIftWeb8L0OPuExi+I36AU6+OLFPIYby3EcR
         eWuaPLD3Fc2c3vLjg/WrWhnonpJCbaRbulNwJIfav1sDLzZ3izhPLUsu38SoPA7QER/q
         EgAcSU+RhbK+3AnSaUzz/9otZMRF0lCfCZMThrlkEQ+/Fc17TZfbMKWzL1Qxlt68lWw7
         06RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794900433; x=1795505233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nulKLSDVoO04RkyHS8ZaNk6hUq+RiR0yz5unKqo3XOg=;
        b=hhzKTM4ZhR68y2MYl1TV/c7bcEjZVBjuabSB/izN4C2SIsMxYPdYhsxnWBeTpzli6b
         h33Ix2ksa8Uk5yBijlOQ3vguCLnLPh3BFG+9hGzJFGd99++FzP+G6QYWLEf6/h6MuIup
         FcZRIs4EEDJSGiOV6mQorPpEYbPu3yqv4MwVnrPpcG0HpDKUSyBP/zUKt9Q3GXrkFm4S
         DRBWR+KwdXd/Mqm1Bz1NvcYT96fmGbYPulxVgnbZHtLsC82gfkecvM9KTCblvt8jpt0l
         P9PqAvctkzsWPwPW7Ku5Di/ZbmwP1AYfZqkoAWKL7SjdvfB09/zPTAkRt4Qg1eq1Q7HZ
         ZrdA==
X-Gm-Message-State: APuU4Z+sE7rtkU7y24lLiD4emgWPSnQmMgCMNkffSP8n8yitSOTREhGs
	uKvPVPpOo0aB2QtI76Qsb5u3DCopfS1OLQsIHSigOlNXTerOYDTyRWtQZd4HNNegWXU=
X-Gm-Gg: AYBFou1l8QOZ9Pj4hw1EYi1UdmCAoM+xj0MkrIsGsCsoPPh7aguDFDSMPV9Kh2m0W7x
	nkroAkNjdcmVE0iIvxOTfYLkuBnnbl9Bh+/MbMoyZaIFTeEr8X3GC+fXAjubjcBiLPCHIivfqUb
	I+T1gXXr0fBI9Y+FdJN4avz2Gsm2FEzcDGjcYpbjMSa3PVnmeaEMMCVIFv1ARS/+gPqXLgNQiRB
	WLxeIdpAj7AqLxAv1xJ/n4l987f9UVwb/ZTkrmzhOac3owMziFQsp59T5IAGORNhykHmp+Gx39z
	dK2H/HmhDaN+r9butSFGe/RMaLaAfMI7FTpM7tN4iHaMLefWp/7ribiVQcuBPf0HGqukkUnt8vj
	5rYx6UL7w7JL4bIC2S7vfuxGmy+SgqDrAipIkMVaSgna0cptT205au9bFVy3SU/hkATVqtcGXic
	n29rBp+suX8VZQmmVYx9aoScKUI0OreS8sILOq8sNSIzZNmyYBTPRSRc9vp5UcIQftpzLn3+7fR
	MhGcowsVCDRfHjwHeUSsDwEB/ceSDk/Hh8QrJsYAI2oCi1YXbGsTnZYVapfFVgNHWR+oR2sGSXB
	PUzNZwx4EpVXO7nDIgAKNpzgRd0tl9xwPma15ZNX2lpwXFId
X-Received: by 2002:a05:6a00:4214:b0:8a9:95d6:31f4 with SMTP id d2e1a72fcca58-8beb677f6c7mr11355340b3a.32.1794900432763;
        Mon, 16 Nov 2026 23:27:12 -0800 (PST)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed2055031sm4940716b3a.39.2026.11.16.23.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 23:27:12 -0800 (PST)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	Yifan Zhao <stopire@gmail.com>
Subject: [PATCH v2 7/9] erofs-utils: lib: return negative errno from erofs_io_{fstat,ftruncate}
Date: Tue, 17 Nov 2026 15:26:27 +0800
Message-ID: <d1d42d51752b2be3ae3d95fd9d84278b9f7d6831.1794899782.git.stopire@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794899782.git.stopire@gmail.com>
References: <20261112124725.2774244-1-stopire@gmail.com> <cover.1794899782.git.stopire@gmail.com>
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

Allow callers to propagate the correct error codes.

Assisted-by: Codex:gpt-6-astra
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/io.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/io.c b/lib/io.c
index 2b61f9d..1775c39 100644
--- a/lib/io.c
+++ b/lib/io.c
@@ -53,6 +53,8 @@ static ssize_t __erofs_io_write(int fd, const void *buf, size_t len)
 
 int erofs_io_fstat(struct erofs_vfile *vf, erofs_os_stat_t *buf)
 {
+	int ret;
+
 	if (__erofs_unlikely(cfg.c_dry_run)) {
 		buf->st_size = 0;
 		buf->st_mode = S_IFREG | 0777;
@@ -61,7 +63,8 @@ int erofs_io_fstat(struct erofs_vfile *vf, erofs_os_stat_t *buf)
 
 	if (vf->ops)
 		return vf->ops->fstat(vf, buf);
-	return erofs_os_fstat(vf->fd, buf);
+	ret = erofs_os_fstat(vf->fd, buf);
+	return ret < 0 ? -errno : ret;
 }
 
 ssize_t __erofs_io_pwrite(int fd, const void *buf, size_t len, u64 pos)
@@ -217,7 +220,8 @@ int erofs_io_ftruncate(struct erofs_vfile *vf, u64 length)
 	length += vf->offset;
 	if (S_ISBLK(st.st_mode) || st.st_size == length)
 		return 0;
-	return ftruncate(vf->fd, length);
+	ret = ftruncate(vf->fd, length);
+	return ret < 0 ? -errno : ret;
 }
 
 ssize_t erofs_io_pread(struct erofs_vfile *vf, void *buf, size_t len, u64 pos)
-- 
2.56.0


