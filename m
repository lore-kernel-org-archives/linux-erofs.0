Return-Path: <linux-erofs+bounces-3998-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9223AC531F9
	for <linux-erofs@archiver.kernel.org>; Fri, 24 Jul 2026 14:47:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h69nT2m3Lz2yFg;
	Sat, 25 Jul 2026 00:47:25 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::62a"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784904445;
	cv=none; b=ErMhJ4x8fjnOVLNLM7zMfiwHUnPld77KXmHVLWc/iL8HKdOJPkGN38mEnD78GYZzdcIqyxMVtgMNUP4iz86BKsevti0wC9mq5vOgMK7uCtoMCAuFpfFtQO+vh1DJ65zdBECnSTMHMYBChG0eeFoFj4Gar0sWCJyI7VFdbJinP1hSmWbV6CZv134tm0oNp68ZgbFX95NPePLPKspbOZu+7SQx8dWyDqAdA63dBLBrGq4PHeYgiCq4ke/NAyZAef1AkaS961ZhDijUsfhYU20i2KyMg7zPFBAZHPtJRKghS8YA816YNrBapaT7rgVWN9RSkIbFwNMHxjEcfn6nMG8ETA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784904445; c=relaxed/relaxed;
	bh=w+r5Hud6nXe8BM1+YUSSWZXXPmNLOyaLrLAYUcJttnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKF4R+LR3+MY9sHjfgnXw56GF+hJxvFYf/kVOFmWKNc2+8Fum6zRznIBlVpGArnpoEt4ODoWXNDgLgGd7UKOTNNfhMncj3kfZjjeYthwSk5rYPo3OPYC8gm2ymwwYUrhE65JHu2FuvTsVT6UluenOepojsnorQw7/liLUbTXp+WvLUHKSPknOcN4CqGD9b0nd7K3mPGCEMAwjFicwtS5QzmAJiTyl4nV3OTRMmy8nEnWaChM3Qvz0X67zDuS30K/VjD6QxBj7HDEHwAaR07XKsk3LoDErp/oAOj6Jk7eHwjFU/0kFWo3AIAdwh2ATzxEhBwBthq9LJeT+zt2Ndg4IQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ZU1Ev428; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::62a; helo=mail-pl1-x62a.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ZU1Ev428;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::62a; helo=mail-pl1-x62a.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h69nS1LHNz2xnQ
	for <linux-erofs@lists.ozlabs.org>; Sat, 25 Jul 2026 00:47:22 +1000 (AEST)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-2cc97653887so6259795ad.1
        for <linux-erofs@lists.ozlabs.org>; Fri, 24 Jul 2026 07:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784904440; x=1785509240; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w+r5Hud6nXe8BM1+YUSSWZXXPmNLOyaLrLAYUcJttnM=;
        b=ZU1Ev428h3UylTtrRx3De1Nuri3GI+vaLyOMVQtwb4U6FydX0Z2bZyYTbvTzguJIuf
         tL4v6We4nTU96AZqYnDCQ4ZP2/cs4lYg9m04fxT1oWHQ3S+/9FhzTLG5sb81Bh8dUwW6
         NQIcGHCrH96cbSrf/wh323+Q2UL6n2kb6vgx8zXU0/J50fAEeIf6yBwHhgIb/7SpXKj3
         xDflI62spsLA7Hm6qbGCD28p0tuRLlF81RBjz6Vp0BqIknZRH63caRQ24gwsVjz5FA3n
         Ts4Kcwiq+zqDcyS3rQBf38JEYSy909Jhn+Zec/RXoIaE0HiFZtHAjUfJgMcf0BY+dkGa
         2HrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784904440; x=1785509240;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=w+r5Hud6nXe8BM1+YUSSWZXXPmNLOyaLrLAYUcJttnM=;
        b=RvNz0CdiyIYvriujEJOC55JWVoU+oiHKoupnqqdWmPLU2osfx88lH8pNlUphqHJswQ
         GMe+uunIaDcqRSM9vIpM9OMmx2JwmDZig6sbTdm7HysScSLy9Nwi6D12uOqF7jJVcrWT
         /0p5NqVJmcRTz6MVYNhYsSEWXLHtg0dEPkpBp2sPkAnmYuCUM+jUKHm+3/Eta3DVIQgM
         tfpeLjeNnzO9sp5I4wJxYot471JDLTTWHBgWEGRKESYsMi5a8TBgey4NU+4zs5R0I07s
         u9A0EGpNrrORKk3nWQKE6KfDe1CHD6HsM62Jodl1+EyaecQHxRwyltnh4maRFMyOULH1
         4zCQ==
X-Forwarded-Encrypted: i=1; AHgh+RpwD4KtW8LhHfbPjU/x4MB4xemT61PVqrQynPxaX91iY9NkT9T+CHUPZqz575bxu419EktlqkUe97r2jg==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YyRQ4gldkUFD5Nsb+5FEdJMkuXu9CFAMgdvwyIxscxNKdduNLsa
	mp9T/YQbg6hOfO9v5u1BZ/P/WxtDpc//o9KygTcPdvSJn81wSR0+urHw
X-Gm-Gg: AR+sD10bsISdPVYu+JSaWDj4oQUB29kIv3ybc1ALWnlHqHzo+A+CAPWJnDk364iNvXC
	ZJXBtWMpd3JND4dul37Xkd0D3JgT8uo61oaaoMJETfGvfeeXuX9JqO/DxjW42uXUwwdndeVsA78
	ztDiW7gLJKcVqNHdXt8AjL1zr8eciAZbFD4wFlsLpWng/etWAYJSw/5OhehJj5Yibisi76kYphg
	Kg8lcHeBdOLgoou9c95vMm7op/4pI2CeHUwTcp+jMyIT7yJg7BCabAjH+cr0bjSFSpAQvZ9wVtr
	1ekRj4bzDJ4MyIdWyg2d7DrE5PoxuNaRd8Fl221CIUMx8tBjYdgTcEbxNScHcGs0H8w3YYi0dXp
	byG8WI8wnjqBQbOvDR9JtttNcKdrGhQ+fFRs+0k3aq8V05FGlmzRTSupOnKJTnE9NQWmFpXK3Ip
	Zcs0y7+DE9LZvP4bYSKBwFca/xwHQaoNwwqls=
X-Received: by 2002:a05:6a21:6b17:b0:3c3:8044:8b0d with SMTP id adf61e73a8af0-3c44afa7602mr9185759637.12.1784904440338;
        Fri, 24 Jul 2026 07:47:20 -0700 (PDT)
Received: from localhost.localdomain ([157.15.11.68])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc548f5dsm350419eec.17.2026.07.24.07.47.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 24 Jul 2026 07:47:19 -0700 (PDT)
From: Nithurshen <nithurshen.dev@gmail.com>
To: nithurshen.dev@gmail.com
Cc: hsiangkao@linux.alibaba.com,
	linux-erofs@lists.ozlabs.org,
	xiang@kernel.org
Subject: Re: [PATCH v2 2/2] fsck.erofs: implement concurrent directory traversal
Date: Fri, 24 Jul 2026 20:17:13 +0530
Message-ID: <20260724144713.85393-1-nithurshen.dev@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260724143556.80914-1-nithurshen.dev@gmail.com>
References: <20260724143556.80914-1-nithurshen.dev@gmail.com>
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

I have implemented the concurrent directory traversal and ran
the benchmarks to compare it against our single-threaded baseline.
All integrity checks passed successfully. Note that this data is an
average of 5 runs of extraction of the same file with purging all
cache before each extraction.

Here is the extraction time breakdown and performance improvement:

| Alg   | Cluster | ST Baseline | MT Traversal | Improvement |
|-------|---------|-------------|--------------|-------------|
| lz4hc | 4096    | 4.17s       | 3.62s        | 13.2%       |
| lz4hc | 8192    | 6.02s       | 3.73s        | 38.0%       |
| lz4hc | 16384   | 5.34s       | 4.61s        | 13.7%       |
| lz4hc | 32768   | 5.24s       | 3.79s        | 27.7%       |
| lz4hc | 65536   | 4.23s       | 3.61s        | 14.7%       |
| zstd  | 4096    | 4.63s       | 4.62s        | 0.2%        |
| zstd  | 8192    | 4.78s       | 3.95s        | 17.4%       |
| zstd  | 16384   | 4.29s       | 3.68s        | 14.2%       |
| zstd  | 32768   | 4.33s       | 3.68s        | 15.0%       |
| zstd  | 65536   | 4.34s       | 3.82s        | 12.0%       |
| lzma  | 4096    | 56.37s      | 36.57s       | 35.1%       |
| lzma  | 8192    | 64.48s      | 45.00s       | 30.2%       |
| lzma  | 16384   | 69.83s      | 52.34s       | 25.0%       |
| lzma  | 32768   | 74.88s      | 55.37s       | 26.1%       |
| lzma  | 65536   | 80.66s      | 63.64s       | 21.1%       |

Average Improvements:
* LZMA: ~27.5% improvement overall.
* LZ4HC: ~21.5% improvement overall.
* ZSTD: ~11.8% improvement overall.

Regarding bottlenecks:
There is a bottleneck regarding the extraction logic which I think can
be solved by parallelizing the decompression logic. We can adapt our
existing Phase 1 parallel decompression design (the dynamic pcluster
batching worker queue) to handle this. By integrating that existing
design with this concurrent traversal, I hope we can effectively 
decouple the CPU-heavy decompression from the I/O-bound extraction.

Please let me know your thoughts on this patch.

Thanks,
Nithurshen

