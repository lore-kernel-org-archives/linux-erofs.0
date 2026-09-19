Return-Path: <linux-erofs+bounces-4578-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C9C2C982D8
	for <linux-erofs@archiver.kernel.org>; Sat, 19 Sep 2026 15:15:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hnCj03sMZz2xYg;
	Sun, 20 Sep 2026 01:15:00 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:3b::1f"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789830900;
	cv=none; b=VZIr8aCgT/DF/ijE84H9F8HjPsu1YZG7vqStPwpocFfE0a7umGkUwmqjr+/YhCrJ2WpqgGnr4SBfKvkn/ndRuNkO2hQsiqhjXH95tFbLdW7J44J9Pe/PQ3ZO+cUnGGJRDafqylFnwzsW5TUkVXHOZbPaobKlBsZrtyiKbzp+VDwnOdxofEtwcZ4jc8QsnP3lwbw5s9yaoeMn4ecTm5dAvkyx+JgUVXMtVyDODji74ig3e7jTXuTvJr7xD8XsJVzlt5cqRDuozPmFPff3Ct5ei+V3TByf6cJBgRI3Exma1tnPczpOjrCPjQcVGZDTyCiWZ4KM2bTd4VpkWFFjQqrORw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789830900; c=relaxed/relaxed;
	bh=l7wwrg+eXCNK47Bi+NO1MlnjVe1Dzuy3rU549mNY9sc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DoWS5ReZvU5fP1Zg+HC1DN9XtSUjfP5roJIjYCpD/9tsapdLPgOat3U3PL16etYqHaTckHyhXF1XiyKk/iIx7jzrqq/jD2RGxthzTzKufzllDMhf3GlEClGHGAAxVKQZDoyghAnTQZVdQS+MJ/+U3Jq2cw+4F+CexjEmlEe+sRRNa69zBBU3qrNTg42bUUllq9tUKMjxLsHyaVggBQuCpNGdEyTXYdvjaBSTTcJEVRPD1lcN4dMSE+h4HQMfaK6pmGE0niUrmZGuBaUImeHUD1W+viU8Cc8Ft8RJoupqxi+KllwpJgbHo2cYm7+s3vdU+v0JvJDwbrdxXi7cNvyXAw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=DIdYn56I; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:3b::1f; helo=mail-pz2-x1f.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=DIdYn56I;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:3b::1f; helo=mail-pz2-x1f.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pz2-x1f.google.com (mail-pz2-x1f.google.com [IPv6:2607:f8b0:4864:3b::1f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hnChy4qDrz2xSg
	for <linux-erofs@lists.ozlabs.org>; Sun, 20 Sep 2026 01:14:57 +1000 (AEST)
Received: by mail-pz2-x1f.google.com with SMTP id 41be03b00d2f7-cc1cea50dc3so1170368a12.3
        for <linux-erofs@lists.ozlabs.org>; Sat, 19 Sep 2026 08:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789830895; x=1790435695; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=l7wwrg+eXCNK47Bi+NO1MlnjVe1Dzuy3rU549mNY9sc=;
        b=DIdYn56IBSfeyxDxjUfAdvbzvCcWldjSnctn6E1/yy3a3wqCnJeCM6pdpN2JWHe/bi
         OucT2ufhpyIwOJyYC+KugfbJ1L1QADdLnFc5hH77KsdPNJpaDD8czhyqihoVu9GM5tXv
         +gVndufyQJRPDHGLAVf+PSdhTgkeGHwa0+MrHHjQYKHGREezkyHq2A0xQqDzCNH8s1Ow
         ViwSBil6nW3+FcY9WZLsHlH0TA1iX1/3dBCaZZg41y2k4rqjxHZKRi7lCzZmSKFaM7q5
         HBcYp6cBnVqLh5W5x2nbrqI2uQl6XmLcSkFMaz5qUcW0w902l0bCR4a3ly9HxwEco0h7
         yWBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789830895; x=1790435695;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l7wwrg+eXCNK47Bi+NO1MlnjVe1Dzuy3rU549mNY9sc=;
        b=LQhC/yemhBGCNSmrCfgYtgzZyTr8bcx98EQEaIF39z1U1ti9zynUD1j9d2TYxBO2hJ
         ST2ba7848IsOx1U4n8V1ekqS+uzGWoiZGvUz+4uMKM11gjVgcXhKPy4uCFZhjfqGMqrr
         PdWmDNF6SM/NekDw8uFMsG2kMYEHZlxn4NlRyeXKAVtsIpQGkhUgw7rE8hckrG0Y/p8k
         i44lTvngsHw/eMEWVCvwqhTUpbSYxHVoRacNg0BbVWuww7s0HZOdeXmvrwQVdeMBBwKB
         qvsV4fBTgDVOsDa8SyaTnHEy/L7lp1PxAvVLGOWAzg/syaBm3S+um65VTvoF7FnpEoKN
         b8hg==
X-Gm-Message-State: AFuF++nf7wy2prwS9xDQH4+qWN/T2tutRc2pDsANpJ9/qvtv5Nqh6HGL
	BKhrJBtP9WYU0Ylp0KjgOx+iXZ0r6UToh7+uuxr/nzRXimFhCYazELVOfbh62g==
X-Gm-Gg: AYBFou1o8d5nBHmGjufbw1B4WkvBaQO/MuP6ZG4XlFqzzGWJB/zIRzSAMWSool0Jeto
	fwDaiKu5pJwW0fIp9Kp9Vcz9qQ8HSRftWlojcxIOzA5JtaEapSzXDbsBHXGd2fM02gi7zmsbq0V
	s7kfHoqJnqdk6Ktagss7Ok7vCSG4AEHyzmt7NiTmpRLRykyKIi2nq6PIvg+c65+l3OwUxV+mVrn
	wxI9HW19eg7bLp89cMdjlYZZW+Znp/PqZZ3SojWVA8R8dOjQqOC+ArkI6iILNQbAtFgBkK2L0dW
	Dt899kQTzKIsG2Pgn5XDkDl1lT7O5k70DwJovobJtGv1tz/RgfGSy60shwPOjky2bJXNA6dk74a
	xWkyPW3jCnk9wV7Zf2KhZ4ir/JoB0SaNKel/7UGxbW5Rxv6o4GtgBvZkZJMBqjUKaAEb+MXkX+5
	LtgLD50jhPC1Y3eCxPUCV3wncdfx0IXxd5eiShmV9yVXVC3RVb4WO/+z5Z4Q7GQ5+wet1BZil64
	I3RVla1qGDfMhNNHXoxuj6qPiAp2HQ29Q==
X-Received: by 2002:a05:6a21:6083:b0:3cd:9f99:3381 with SMTP id adf61e73a8af0-3dd8c1eeb19mr10346590637.0.1789830894534;
        Sat, 19 Sep 2026 08:14:54 -0700 (PDT)
Received: from localhost.localdomain ([103.27.167.84])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc72aee368asm1039661a12.26.2026.09.19.08.14.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 19 Sep 2026 08:14:53 -0700 (PDT)
From: Nithurshen <nithurshen.dev@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	hsiangkao@linux.alibaba.com,
	hsiangkao@gmx.com,
	Nithurshen <nithurshen.dev@gmail.com>
Subject: [PATCH 0/2] fsck.erofs: implement concurrent extraction and decompression
Date: Sat, 19 Sep 2026 20:44:41 +0530
Message-ID: <20260919151443.29012-1-nithurshen.dev@gmail.com>
X-Mailer: git-send-email 2.52.0
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

fsck.erofs currently traverses the filesystem and verifies inodes
synchronously. While data decompression can be offloaded, large
CPU-intensive workloads block the main thread, bottlenecking the
I/O-heavy directory walk. 

This series resolves thread starvation by decoupling traversal
producers from decompression consumers.

Key Changes:
  1/2 Localizes shared global states (fsckcfg.extract_path,
      fsckcfg.dirstack) into task payloads and dispatches them to
      a dedicated traversal worker pool.

  2/2 Introduces a per-CPU worker pool and asynchronous reading
      context to batch and offload decompression of files >128KB,
      utilizing pwrite() for concurrent out-of-order output.

Benchmark setup:
  - Test hosts: Acer Nitro 5 (WSL), Raspberry Pi 4, Mac Book Pro M4 Pro
  - Formats: lz4hc, zstd, lzma; cluster sizes [4096, 8192, 16384, 32768, 65536]
  - 10 runs per configuration

Results (best of 10 runs; ST Base = current master, MT Trav = 1/2,
MT Comb = 1/2 + 2/2; ImpP1 = improvement from 1/2 alone,
ImpP2 = additional improvement from 2/2, ImpAll = total vs master):

Minimum Execution Times (Best of 10 runs)
|Alg  |Clust|ST Base|MT Trav|MT Comb|ImpP1|ImpP2|ImpAll|
|-----|-----|-------|-------|-------|-----|-----|------|
|lz4hc| 4096|  3.80s|  2.75s|  2.74s|27.6%| 0.4%| 27.9%|
|lz4hc| 8192|  3.55s|  2.68s|  2.60s|24.5%| 3.0%| 26.8%|
|lz4hc|16384|  3.43s|  2.59s|  2.58s|24.5%| 0.4%| 24.8%|
|lz4hc|32768|  3.52s|  2.57s|  2.44s|27.0%| 5.1%| 30.7%|
|lz4hc|65536|  3.37s|  2.33s|  2.33s|30.9%| 0.0%| 30.9%|
|zstd | 4096|  4.33s|  3.00s|  2.86s|30.7%| 4.7%| 33.9%|
|zstd | 8192|  4.21s|  2.88s|  2.84s|31.6%| 1.4%| 32.5%|
|zstd |16384|  4.00s|  2.75s|  2.69s|31.2%| 2.2%| 32.8%|
|zstd |32768|  3.98s|  2.61s|  2.58s|34.4%| 1.1%| 35.2%|
|zstd |65536|  3.89s|  2.59s|  2.56s|33.4%| 1.2%| 34.2%|
|lzma | 4096| 51.44s| 33.39s| 14.23s|35.1%|57.4%| 72.3%|
|lzma | 8192| 61.08s| 42.71s| 15.11s|30.1%|64.6%| 75.3%|
|lzma |16384| 65.37s| 47.38s| 15.77s|27.5%|66.7%| 75.9%|
|lzma |32768| 70.51s| 52.73s| 16.44s|25.2%|68.8%| 76.7%|
|lzma |65536| 76.19s| 58.38s| 17.83s|23.4%|69.5%| 76.6%|

Mean +/- Standard Deviation (10 runs)
|Alg  |Clust| ST Base  | MT Trav  | MT Comb  |ImpP1|ImpP2|ImpAll|
|-----|-----|----------|----------|----------|-----|-----|------|
|lz4hc| 4096|5.37+/-6.98s|4.21+/-0.99s|3.30+/-0.85s|21.6%|21.6%| 38.5%|
|lz4hc| 8192|7.42+/-13.7s|3.98+/-0.51s|3.14+/-0.77s|46.4%|21.1%| 57.7%|
|lz4hc|16384|4.06+/-0.95s|3.27+/-0.86s|3.02+/-0.77s|19.5%| 7.6%| 25.6%|
|lz4hc|32768|5.33+/-3.29s|2.88+/-0.47s|2.76+/-0.28s|46.0%| 4.2%| 48.2%|
|lz4hc|65536|4.40+/-2.11s|3.11+/-1.19s|2.65+/-0.56s|29.4%|14.7%| 39.8%|
|zstd | 4096|5.96+/-3.65s|4.01+/-1.97s|3.08+/-0.36s|32.7%|23.2%| 48.3%|
|zstd | 8192|4.99+/-2.23s|3.08+/-0.33s|3.03+/-0.16s|38.4%| 1.7%| 39.4%|
|zstd |16384|5.42+/-4.06s|3.13+/-0.53s|3.03+/-0.46s|42.2%| 3.1%| 44.0%|
|zstd |32768|5.34+/-3.90s|3.96+/-3.19s|3.05+/-0.52s|25.8%|23.0%| 42.9%|
|zstd |65536|6.08+/-4.36s|3.86+/-3.24s|2.87+/-0.39s|36.5%|25.6%| 52.8%|
|lzma | 4096|52.16+/-0.6s|34.38+/-2.1s|16.06+/-3.1s|34.1%|53.3%| 69.2%|
|lzma | 8192|61.45+/-0.4s|43.34+/-0.9s|15.85+/-0.6s|29.5%|63.4%| 74.2%|
|lzma |16384|65.69+/-0.5s|47.78+/-0.4s|16.30+/-0.4s|27.3%|65.9%| 75.2%|
|lzma |32768|70.79+/-0.3s|53.02+/-0.3s|17.15+/-0.4s|25.1%|67.6%| 75.8%|
|lzma |65536|76.50+/-0.4s|58.71+/-0.3s|18.10+/-0.2s|23.3%|69.2%| 76.3%|

Summary of Improvements:
Patch 1/2 alone provides a reliable 24-35% reduction in minimum
execution times across all tested formats and cluster sizes simply by
parallelizing the traversal walk. 

Patch 2/2 targets CPU-heavy decompression, delivering a massive
secondary impact for LZMA. LZMA extraction drops by a further
57-69% on top of patch 1/2, resulting in a 72-76% total execution
time reduction compared to the current master. Lz4hc and zstd are
fast enough to bypass the background worker pool, so their ImpP2
remains negligible, as intended.

Nithurshen (2):
  fsck.erofs: implement concurrent directory traversal
  fsck.erofs: add multi-threaded decompression

 fsck/main.c              | 580 +++++++++++++++++++++++++++++----------
 include/erofs/cond.h     |  31 +++
 include/erofs/internal.h |  16 +-
 include/erofs/lock.h     |   2 +
 lib/data.c               | 377 +++++++++++++++++++++++--
 lib/global.c             |  12 +-
 6 files changed, 848 insertions(+), 170 deletions(-)
 create mode 100644 include/erofs/cond.h

-- 
2.52.0


