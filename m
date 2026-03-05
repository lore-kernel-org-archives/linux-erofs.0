Return-Path: <linux-erofs+bounces-2501-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B327EFCE56
	for <linux-erofs@archiver.kernel.org>; Thu,  5 Mar 2026 00:48:55 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fR9s141rPz3bf8;
	Thu, 05 Mar 2026 11:48:53 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::1030"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772671733;
	cv=none; b=AMx52Ww18O2BI/n5e2J+SF/OzLYtJu4SmujX+i1+q5fpqkeF4yN0jQ704AhCeDeuNz3lu+pEpU8SpCFGtEZJw6wy7g0A9EtWMQApb/eHjGjBHgqnIhQs9rhRqHP5Hx60nEaJiWT//rvs1L+biuG2hcTDzxJujjmhZ4nwsdaoDv/JNsVf3QcQqCK3p5hMGYwlJwau0Rt2tmExjs2XlNLo+mQPU58MRaDFBhrFjKmwq66AaOcFG7ZQ+rjnFOmP85WUjKKgxkEJYU90a3Fedzl1399la8fJ2z39a8vSfItKzFy+A768lXjZKL8yb4/wMsZ6fS5N6AFGsEDTJW6xJwGSBw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772671733; c=relaxed/relaxed;
	bh=3I5m4DPupdd9UGvOs9KSHWpJhZmVAbbmMJPcMgNxiKg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iR5CAWA5D7WSLdZV9JOyVP+rEd0SmG2my+35BgreTmomWvpIqMyI6aHpdjbjqCUF2HJuSNdGvPK0t6nn04NyzjinhDz2NzHIATNduVKIRCxC6vhpn7Juw4Ixu3mBHcVMFxl8Tk2JJlSu/KLX8QkybDmN2YLdQ2X04giQjojMPUH8UmZUpTnN+8j+/iM+vsi67DdIIAstZ6sePiQKIEMUH6l6hmLRLtS3/BMtzcCqkT7W/O8WGfIIopfCW2a5eiq/gZngubgACNVl/4+A9v1c/HBclvPTfA5jGlUcYtlWA/ih7wFuLxmu+kUssKmgt74jNrBzAxg9tW3zD4wHj8z+yQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=X4Vu6nS2; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1030; helo=mail-pj1-x1030.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=X4Vu6nS2;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1030; helo=mail-pj1-x1030.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fR9s06Gb2z30FF
	for <linux-erofs@lists.ozlabs.org>; Thu, 05 Mar 2026 11:48:52 +1100 (AEDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-354bc7c2c46so4146607a91.0
        for <linux-erofs@lists.ozlabs.org>; Wed, 04 Mar 2026 16:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772671731; x=1773276531; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3I5m4DPupdd9UGvOs9KSHWpJhZmVAbbmMJPcMgNxiKg=;
        b=X4Vu6nS2V/GXLf6UoRvvY+9PWVNCFxCrMXSRXRlHg91WijaJ0KeJB/QDnfjo+B7THv
         if6J6vvFNPGqr3No1BO7E/Uaxp3Iy9O2OgaaGf778EngmzuiZ3osrjQTsKrAZ1Nsa7Uo
         qU6FFf5ikB9J3QZ/vpA5Ce9DjtS0Q9+TkkOr/d0AnnmtQkGda0iw4gvqlvcRrTpOxkBD
         klesdZqTJwH5Ax9zvLfeZyo1yrK2o65kUMJzLp/qldwfGf1xLHZIIzONk+0RGEKfmzWF
         7v5FnUTfjtXyi3GixfS7tLYoNiFustMxUf+2tKwa5XFkCbRxvcbXnAjBlt1BecUpoeaN
         kcZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772671731; x=1773276531;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3I5m4DPupdd9UGvOs9KSHWpJhZmVAbbmMJPcMgNxiKg=;
        b=hS06PGMigD7k0zM5wujqt5FY1tgD5oS7wzSmKfhUODZX4EyeKCJ5i/hVKjrWeWX42E
         5Q0cw8mQOCTX71oQc0iKcT/C4jVmhSg/RdzO5ly3cCt47FzGQsYG45fG24OLeYjfvO1F
         MZdgnbrYAJvkaBJL3GcRN2g1EaQlYJIWwdj9qYRMs4h1kgUZqhftxqfaJPu0MRptjmI3
         8Jzeos1U+IaK/HqbmN91olAtTst3TKEn7fd2crMYMnO8X0oOK9DU5Hd4G7k6zATnLp/X
         an03zM6WXVgm2pnMLFk2n+fe0hKAQVeuHaDdApr4/z1tddyR0mYgzaeLe9AFfddYKIxc
         lgrA==
X-Gm-Message-State: AOJu0YzRyv0K1WR5/KpnOtVwtLSJjVuCQ80o79AeSgbQKbVTOSoS0cpl
	OuO/j6yjgZxtQOt2FHX6AXS8mV8dd8biVHynEyPQz84DNM8mdksjZRxXVGAyjZAu
X-Gm-Gg: ATEYQzxBnfSZ52Mk0Vk4dpu8unAcMXoPEooQCVmMVSgIFX1+TBP2AC+xIQ33auntS1L
	65YGubyV1QlT7GCtXD4ehLPAXMZcy99CzUA9zOvVSo5xRav+LMKNo00LTdn4ofP6RUU2yrsWF+U
	9hOI2uoBpQ7OAj7gV3efF0Oikcjq879a1mfi5DGle8HpP0CA8VFn8M4Hy0VofXhemhakDG8bH8P
	xSYoas0NlWXpyb4pOEIY9RTp7zB2ImzSHj3OqH4jjmx/6VPTe9e4k2QKuUaq6zThOcazIcKw2Dx
	XOEKxV2tMuM5Mnfd82wBKxRRfMgU5chXVclnpQyOfsCOBD0sbK5rOIyLZR67QCRWzSzF9NoRei1
	QM30tKwaRemAPV8bfV8PND1X2mqrS0TTAumXpPFqyc2N3Hnjbw7OQh89Xw4VOFfMuj2N2Xw24mK
	dV+vu7FCPStMVtZEu7MOGfpsSMYQOhn5UMf6zs
X-Received: by 2002:a17:90b:3b50:b0:359:91a0:98fc with SMTP id 98e67ed59e1d1-359a6a4a5b6mr3473047a91.21.1772671730810;
        Wed, 04 Mar 2026 16:48:50 -0800 (PST)
Received: from ubuntu-arm-nithurshen.SNU.IN ([45.114.151.85])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70fa6203a6sm17815147a12.8.2026.03.04.16.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 16:48:50 -0800 (PST)
From: Nithurshen <nithurshen.dev@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	hsiangkao@linux.alibaba.com,
	Nithurshen <nithurshen.dev@gmail.com>
Subject: [PATCH] erofs-utils: fix memory leak in z_erofs_qpl_get_job()
Date: Thu,  5 Mar 2026 06:18:35 +0530
Message-ID: <20260305004835.39574-1-nithurshen.dev@gmail.com>
X-Mailer: git-send-email 2.51.0
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

If qpl_init_job() fails, the previously allocated job memory
is not freed before returning. Fix this by adding a `free(job)`
call in the error path.

Signed-off-by: Nithurshen <nithurshen.dev@gmail.com>
---
 lib/decompress.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/decompress.c b/lib/decompress.c
index 3e7a173..e7ec83e 100644
--- a/lib/decompress.c
+++ b/lib/decompress.c
@@ -149,6 +149,7 @@ static qpl_job *z_erofs_qpl_get_job(void)
 		status = qpl_init_job(execution_path, (qpl_job *)job->job);
 		if (status != QPL_STS_OK) {
 			erofs_err("failed to initialize job: %d", status);
+			free(job);
 			return ERR_PTR(-EOPNOTSUPP);
 		}
 		erofs_atomic_dec_return(&z_erofs_qpl_reclaim_quot);
-- 
2.51.0


