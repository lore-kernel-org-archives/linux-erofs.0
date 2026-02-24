Return-Path: <linux-erofs+bounces-2397-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D062F3C9B2
	for <linux-erofs@archiver.kernel.org>; Tue, 24 Feb 2026 16:32:39 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fL3D55jlrz3cYh;
	Wed, 25 Feb 2026 03:32:37 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::1231"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1771950757;
	cv=none; b=e/mtSj3pDtr907yHWfLp86N/9bpcgdTuall5YzWcRO8CAkyhdbVVAksASN5DBH6l6r+vTE3MPrdi7ygYBbImvme8aqgagiooCo9HMZQ0Q0xGHy6NPahvYKzBQpr7fqWwML2KR+fLVILDS5lLDrV21c3gPJS34aYhKBFia7cNCGwRrvPacyotMo4kOiqdKQeanTqYP176vluPHtV1YfJ2Mj0iqhkqfyN7DzLsUSu61zLXCFRfOZqv5MMYN7cZQCUM92YizJWwGgkNI5bPmRXz23qdjPSfyWR3VTfSyYk4aAOerR4MmWUHYl+zQrMb7FMsslsf4KMWM/tqEF59ZScdcw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1771950757; c=relaxed/relaxed;
	bh=8xugeUJMa7+Ivtgc79qfyWPvr49/iomwZ5d4Y3d701w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gLqcRmXvJzKcd4zl8j7yjBQnWWEnYL2+CrjVA55Yhr2n0CbdDWCKKCepKe2OViVr2jmMZXW6iLvKiZbuN00ppCa77IzX0poIRT6vdrUJQme2J1pn5C0xzRzDClZmYt8SuF4/GARU5X6F5dYTHlVfIELR82jwNjLJkuVRauIOcJJCppNYPpIWQF6m+1qZgI6t9m+iGNRU+90G7TE1ZMrpEPjGp9w07AOtkWzDDKsWL3HxV3gKVN65HW8WDYpdFSevHUsfwXcgN9gEMEUD+ykgh/JCKPCpsUXHOzZS5dKu/fhLWl9Rc/gofH4vwFnw8GAMi1WsnVu3ySr7Zs9SKjPzjQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=e9avvm2X; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1231; helo=mail-dl1-x1231.google.com; envelope-from=yester1324@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=e9avvm2X;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1231; helo=mail-dl1-x1231.google.com; envelope-from=yester1324@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-dl1-x1231.google.com (mail-dl1-x1231.google.com [IPv6:2607:f8b0:4864:20::1231])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fL3D41HZCz3cYb
	for <linux-erofs@lists.ozlabs.org>; Wed, 25 Feb 2026 03:32:35 +1100 (AEDT)
Received: by mail-dl1-x1231.google.com with SMTP id a92af1059eb24-1275750cf9cso4699323c88.0
        for <linux-erofs@lists.ozlabs.org>; Tue, 24 Feb 2026 08:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771950753; x=1772555553; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8xugeUJMa7+Ivtgc79qfyWPvr49/iomwZ5d4Y3d701w=;
        b=e9avvm2XYO03WPw0lppw2d5Cxzd/S0Bmb1gXhKNB8rBzy7nS6yDuhvPyYFR5fbvukK
         tW0IPZNFielU7WT65pCQ2bpEM7puJTe9ea1TZRWiXXUTknYF45xwjgjYADvNnTwap//n
         jJQZBfr2P/9gCfSY2ZZ7WpG3iArg4BmP8GfHDJxx8Akli110mywx9dJIEQCztQx6Da8+
         46lou75T18tsnshhLMRWX5bpQqkbMsbrXc8NFd/vppCIWXui/Eh7I2vJgGLKwbImy+PY
         G/l4E+2eN9nAcgKVoTB61IiIqaT/E/dk538Cjaz1oymeLaLJx1tJ3zpqwQp14h4uSRAj
         3dwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771950753; x=1772555553;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8xugeUJMa7+Ivtgc79qfyWPvr49/iomwZ5d4Y3d701w=;
        b=QB0O4g9mhpjKug5MvWu5ur+lp82c23dovgv4tKAYUQ737/6IclKdYW5YxOS9F034Mu
         sRT1mWc30dAnwzhD3WdatB8XgP6cPaBVx3FzEJyIwm3JwX70KrJdsJvVojezjmlVeFya
         3Zoo3aj3gJrlhRrqJdTwXFhqAXduDT21P+3RvmV82r3mIwWw48JSzoeAz9Droqtkbafo
         9ZW7sdXsM/aLEUQbhXtNIiLjJyqvT1mXa1LncWez/haN9asW5pw0D48U4zDJs96Jp6hp
         poLLuyOOO3XHLB6vH9kwbvpDt+1BPsnisf5Hfv7Z+DPfhTkUJqN7J4wrKV1hQ6+lwjYA
         5Z+w==
X-Gm-Message-State: AOJu0YwlH5EsLi31k/VBc11c3RC9jWxvK9KoSPv9plgu/bJkG6VnY4q4
	EBTW6HFfZJOHSo6a4Ky99cBw5ztRScKcuYys8iiCZZw437XxWgPmXHpj666ZdcL/
X-Gm-Gg: AZuq6aJHcTntu7bUG9HdE7N2pNqVicxz/fktkbmBHLUvbSogirOm+tWQ6Ca8OOAbWpb
	jIqY0cv7l4fOnMcjLAsj40YE7JxrthIibomDxipkHHeX/Za1ZsduO20kGzhaMPcn+QG1Gd6NM5o
	fmC4nz10OumP6KZjfHrtY0hG4oO/OQ13kEsEdIHj4tUGuT1s4usPZrSHmpLqzdz+Uz4b5Dl1wef
	xEmhwal3dQ0H96K8899GMFuMNbbUqxXUrhW+BvPjetCLiDDb0FYPqVduM7h6mFB25aE27QbBg+L
	EmKauJGQMp+8olbn3r08RFK1OslzQ5saYwC/4JJgEchLI9opEdewE6Lj+W/g5TA7lGjR/ViuTvA
	UAmqL9xa2E8tAGCY0YG1SxZyvdbKM/Ty+Ita0cZOwQlRQWM1PRt2QRp8ljz1+qDGy0ueERN9TLF
	aCRmREHuki7bkjxmzCnfbWJcUMaA==
X-Received: by 2002:a05:7022:2214:b0:11a:273c:dd98 with SMTP id a92af1059eb24-1276acc4db8mr5376446c88.20.1771950752873;
        Tue, 24 Feb 2026 08:32:32 -0800 (PST)
Received: from cptpc.hsd1.ca.comcast.net ([2601:207:380:51c0::3c2c])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1276af8c936sm11488274c88.14.2026.02.24.08.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 08:32:32 -0800 (PST)
From: Ashley Lee <yester1324@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: hsiangkao@linux.alibaba.com,
	yester1324@gmail.com
Subject: [PATCH] erofs-utils: lib: converted division to shift in z_erofs_load_compact_lcluster
Date: Tue, 24 Feb 2026 08:30:28 -0800
Message-ID: <20260224163149.60016-1-yester1324@gmail.com>
X-Mailer: git-send-email 2.53.0
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

perf on fsck.erofs reports that z_erofs_load_compact_lcluster was 
spending 20% of its time doing the div instruction. While the function
itself is ~40% of the fsck.erofs runtime. In the source code, it seems 
that the compiler can't optimize the division by vcnt despite it only 
holding powers of two.

Running a benchmark on a lzma compressed freebsd source tree 
on x86 yields a ~3% increase in performance. The following 
test was run locally on an x86 machine.

$ hyperfine -w 10 -p "echo 3 > /proc/sys/vm/drop_caches; sleep 1" \
  "./fsck.erofs ./bsd.erofs.lzma"

With shift optimization
Time (mean ± σ):     360.0 ms ±  12.0 ms    \
  [User: 236.3 ms, System: 120.6 ms]
Range (min … max):   342.3 ms … 379.8 ms    10 runs

Original Dev Branch
Time (mean ± σ):     371.1 ms ±  16.1 ms    \
  [User: 254.8 ms, System: 115.0 ms]
Range (min … max):   354.8 ms … 404.4 ms    10 runs

Signed-off-by: Ashley Lee <yester1324@gmail.com>

---
 lib/zmap.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/lib/zmap.c b/lib/zmap.c
index baec278..1ba52b5 100644
--- a/lib/zmap.c
+++ b/lib/zmap.c
@@ -112,7 +112,7 @@ static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
 	const unsigned int lclusterbits = vi->z_lclusterbits;
 	const unsigned int totalidx = BLK_ROUND_UP(sbi, vi->i_size);
 	unsigned int compacted_4b_initial, compacted_2b, amortizedshift;
-	unsigned int vcnt, lo, lobits, encodebits, nblk, bytes;
+	unsigned int vcnt, vdiv, lo, lobits, encodebits, nblk, bytes;
 	bool big_pcluster = vi->z_advise & Z_EROFS_ADVISE_BIG_PCLUSTER_1;
 	erofs_off_t pos;
 	u8 *in, type;
@@ -144,13 +144,16 @@ static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
 	pos += lcn * (1 << amortizedshift);
 
 	/* figure out the lcluster count in this pack */
-	if (1 << amortizedshift == 4 && lclusterbits <= 14)
+	if (1 << amortizedshift == 4 && lclusterbits <= 14) {
 		vcnt = 2;
-	else if (1 << amortizedshift == 2 && lclusterbits <= 12)
+		vdiv = 1;
+	} else if (1 << amortizedshift == 2 && lclusterbits <= 12) {
 		vcnt = 16;
-	else
+		vdiv = 4;
+	} else {
 		return -EOPNOTSUPP;
-
+	}
+
 	in = erofs_read_metabuf(&m->map->buf, sbi, pos,
 				erofs_inode_in_metabox(vi));
 	if (IS_ERR(in))
@@ -160,7 +163,7 @@ static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
 	m->nextpackoff = round_down(pos, vcnt << amortizedshift) +
 			 (vcnt << amortizedshift);
 	lobits = max(lclusterbits, ilog2(Z_EROFS_LI_D0_CBLKCNT) + 1U);
-	encodebits = ((vcnt << amortizedshift) - sizeof(__le32)) * 8 / vcnt;
+	encodebits = (((vcnt << amortizedshift) - sizeof(__le32)) * 8) >> vdiv;
 	bytes = pos & ((vcnt << amortizedshift) - 1);
 	in -= bytes;
 	i = bytes >> amortizedshift;
-- 
2.53.0

