Return-Path: <linux-erofs+bounces-4007-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AD20C531CC
	for <linux-erofs@archiver.kernel.org>; Sun, 26 Jul 2026 11:02:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h7JjC16tbz2yFP;
	Sun, 26 Jul 2026 21:02:39 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::529"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785063759;
	cv=none; b=YQSPy5YPvH1wsHV5r2k8giIbDeinEDYaE4iuZyHWh1YjoPc2ovaEs3vVi9Ds6TDfmABVyPtDHZmrpjG+uq9PvrCB1xYG6fKx9j0OJ5HMDGyQm0ZmoiJ2aqrUOB9dWh1HrsgYBMqcPe1g2PEa9WSiVF5qnT0kiOl6/hcaahqbEFODHPf5sWX3/z7b/YSIgCkk+I1/N4kiS9pAhoiJ04UTzH6FeWfWjKGro8DwO/FMxv5irDyMFOqUDHyhWdUzzEojJXLGnrfxv43pUZLcbr8Zbc1l02agOapzfcl++Q5E+tsafycqAIRA2oB/pj9s1E6XzmrviqNjitMBKxj/HkiMuw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785063759; c=relaxed/relaxed;
	bh=NKheCSJZPz3m6h4n/zb/BXEDQNT1d2Jff15QSa8u4G4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPMoLM0AlkvOiTMKqKNrKhUaA2Otc3T72oGMCDrDzdb5w84LN2UzDVPGEekrGg35tFUZf9JKKN+YTQVcy5xorqtCzj0GFd62S9uALExPZWEKBIur4h63/2PodChgOPk/nbTeqIaVpOfWKrqXvElwqrPhUKSvarDKNrhIPJxNNW9Bed0g6p4uokY7rMv4R9a2AiWkWdDU5dPXDAUShtigc3MIMkxOi/L+4VkTk2frTnC/DJlmQ/QfzgBhnf8BHXtEuWdrK/JE/EklIqJBBydozC0HPNR1wOSZOjVF91uyUrZ6QJU0xQCUbuMqkFDmFUelzh1b8PPcRIFYPaV54tzTvA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Z8gKKTLS; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::529; helo=mail-pg1-x529.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Z8gKKTLS;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::529; helo=mail-pg1-x529.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h7JjB3hSVz2xyk
	for <linux-erofs@lists.ozlabs.org>; Sun, 26 Jul 2026 21:02:38 +1000 (AEST)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-cbb85186d43so865689a12.3
        for <linux-erofs@lists.ozlabs.org>; Sun, 26 Jul 2026 04:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785063756; x=1785668556; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NKheCSJZPz3m6h4n/zb/BXEDQNT1d2Jff15QSa8u4G4=;
        b=Z8gKKTLSh7+9bXVInm0bnXEDl44MEWkX11SwupOjGmYcoeflJ3A1VlB+iw/psArCow
         CF0dxX9I4QzJCgbMqIMyN1KGdSCBIWhk+BiilfdI6roIrxtuIq7uOnZlHWNufcyNwBSp
         aNUBjmAZ7yXMbqgMgGTOvt/UVOFY+2JMF27dp7+IH09xqNLH9Q2kDjcIR9crXBF9idne
         IYAIC3e3MBgYY71O2OXkByZejekhLGynWb+4vChsariS7TopLhCPx0A+nPlrinvgj/o6
         YzEP+OrgCjW8bm9UTDg0AQKCfmM8gVi/eAINpkOdtv20vMkPQ2KoVTx6kmKjhnVzflbv
         iJyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785063756; x=1785668556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NKheCSJZPz3m6h4n/zb/BXEDQNT1d2Jff15QSa8u4G4=;
        b=aGDs6Resvi8vioJOH59VHFGLdp36EYuv3fg4ijdgbS+AtDUNWWOiYgE+AxCHu4kyFN
         Luhsn035Vu4dRNJ6k6ZQHzddLn9eq5UTIeK7sp1IZvFcZ+QV3dSN7R0oCHDgCW9LPzMQ
         ZFfQE3J9znW+4qnONEdOCWGC9/f0QO/4zrWFK0Cszhgpvpb3ClguR3+UeWg7Noqw7hMo
         XiDvo6/2xVGR8DXZpom5/R2/j2Txz3Kh59116zHTSNF4IGoEgwzVMKDOExrTIO3jcuN+
         B9zDRvGehZp9ZqRjtSiTT0iuPGGNuY4zBDxoNu6a34r+gTKRBWbalYO4AX2pVlMjxeRS
         xRBw==
X-Forwarded-Encrypted: i=1; AHgh+Rq3WXf1rEJ4kavhd4xbjP9z31BODzv3Tac/BcD0MB4lHPBY2y+I7WL0pAiVyHkv6UKlgN+1nITCVigSIw==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Ywoo6nPdNVt7lgHPZB1iSn2YJ8N6KDegJAbzfS5ivBEEd7mNJqn
	7b7ctlbJ6Dw3/cyowXYjSfBYQ4j3Y0EZbeBwH7nl/5X8Mxte9UH3xov1QPXf0Q==
X-Gm-Gg: AR+sD13xpvplrw/ZCqu0bPOX7yfju4GMqXO3OV6maDPldL/ruhn+dfXYBFkMSRsngNg
	voeo+7JRHELvvryUO/F5VMQO53MEwJu8E1H2xVBerDxugdDgRyW2bD8O5qwAm4dcEHZwbf885DX
	0epxyuIXYhMA5jZ2qQR8/CuIBtUqAwN0kUnSc/oopnk5QleQM32+Q6+yDYDeAXnIRj9yh3DMpdA
	Cv0GnaGHvLnuU9c8HO8Ps410hI5SUKfqPi09Nc0jiyCtpHQmku9XmlQV5WrZZgnNz3pq8jupJki
	TK33Fk0cQW9yguzSX5uWXU9o7xGw1qMwR36QM/FKMtEc/YXTH3BBWYJwZwEI8ic2T3+6pHm66aH
	NxnqL9vjx01mTe2pLldSKu3UEBI2Ad3b2Ki5KGrGtnlvaVNxHrL02AcgWE6UV/DaS4F/droeDwt
	GnS1MAVfQMDtrtWZ7vv2xDBzrKkGPlcyBVxy4=
X-Received: by 2002:a17:90b:398c:b0:37f:e1b6:4c7d with SMTP id 98e67ed59e1d1-38f293cd1fcmr4674276a91.6.1785063755860;
        Sun, 26 Jul 2026 04:02:35 -0700 (PDT)
Received: from localhost.localdomain ([157.15.11.68])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc447f6bsm22420378eec.12.2026.07.26.04.02.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 26 Jul 2026 04:02:35 -0700 (PDT)
From: Nithurshen <nithurshen.dev@gmail.com>
To: nithurshen.dev@gmail.com
Cc: hsiangkao@linux.alibaba.com,
	linux-erofs@lists.ozlabs.org,
	xiang@kernel.org
Subject: Re: [PATCH v6] fsck.erofs: add multi-threaded decompression
Date: Sun, 26 Jul 2026 16:32:30 +0530
Message-ID: <20260726110230.62386-1-nithurshen.dev@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260726110116.61634-1-nithurshen.dev@gmail.com>
References: <20260726110116.61634-1-nithurshen.dev@gmail.com>
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

Hi Xiang,

I have integrated the multi-threaded decompression framework on
top of the concurrent directory traversal patch and ran the
benchmarks against our single-threaded baseline. All integrity
checks passed successfully. Note that this data is an average of
5 runs of extraction of the same file with purging all cache
before each extraction.

Here is the extraction time breakdown and performance improvement:

| Alg   | Cluster | ST Base | MT Trav | MT Comb | Imp(P1) | Imp(P2) | Imp(All) |
|-------|---------|---------|---------|---------|---------|---------|----------|
| lz4hc | 4096    | 4.17s   | 3.62s   | 3.38s   | 13.2%   | 6.6%    | 19.0%    |
| lz4hc | 8192    | 6.02s   | 3.73s   | 3.56s   | 38.0%   | 4.6%    | 40.9%    |
| lz4hc | 16384   | 5.34s   | 4.61s   | 4.24s   | 13.7%   | 8.0%    | 20.6%    |
| lz4hc | 32768   | 5.24s   | 3.79s   | 3.34s   | 27.7%   | 11.9%   | 36.3%    |
| lz4hc | 65536   | 4.23s   | 3.61s   | 3.49s   | 14.7%   | 3.3%    | 17.5%    |
| zstd  | 4096    | 4.63s   | 4.62s   | 3.75s   | 0.2%    | 18.8%   | 19.0%    |
| zstd  | 8192    | 4.78s   | 3.95s   | 3.84s   | 17.4%   | 2.8%    | 19.7%    |
| zstd  | 16384   | 4.29s   | 3.68s   | 3.65s   | 14.2%   | 0.8%    | 14.9%    |
| zstd  | 32768   | 4.33s   | 3.68s   | 3.18s   | 15.0%   | 13.6%   | 26.6%    |
| zstd  | 65536   | 4.34s   | 3.82s   | 3.31s   | 12.0%   | 13.4%   | 23.7%    |
| lzma  | 4096    | 56.37s  | 36.57s  | 20.60s  | 35.1%   | 43.7%   | 63.5%    |
| lzma  | 8192    | 64.48s  | 45.00s  | 18.49s  | 30.2%   | 58.9%   | 71.3%    |
| lzma  | 16384   | 69.83s  | 52.34s  | 21.97s  | 25.0%   | 58.0%   | 68.5%    |
| lzma  | 32768   | 74.88s  | 55.37s  | 20.88s  | 26.1%   | 62.3%   | 72.1%    |
| lzma  | 65536   | 80.66s  | 63.64s  | 19.81s  | 21.1%   | 68.9%   | 75.4%    |

*(Imp(P1): Improvement of MT Traversal over ST Baseline)*
*(Imp(P2): Improvement of Combined Patch over MT Traversal)*
*(Imp(All): Total Improvement of Combined Patch over ST Baseline)*

Average Overall Improvements:
* LZMA: ~70.2% improvement overall.
* LZ4HC: ~26.9% improvement overall.
* ZSTD: ~20.8% improvement overall.

Regarding performance:
By combining concurrent directory traversal with the multi-threaded
decompression pipeline (featuring algorithm-aware batching and fast-
path bypasses), we have successfully decoupled CPU-heavy compute
from I/O-bound extraction.

Please let me know your thoughts on this combined patch.

Thanks,
Nithurshen

