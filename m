Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8025606A31C
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Nov 2026 12:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NbGVQMbn
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQKt53c4Lz2y8F;
	Thu, 12 Nov 2026 23:47:41 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::635"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794487661;
	cv=none; b=fIOG9y30HYYrq+zR5mWtJklGH5BG4ItYu6Nrw94M8ALj2MmWoUoa+VbXBLBhyWYko3xNeq2cc32Kfa0dSNtCjR23SQEded13Ng1i+E9q+WSXKfhKcaQNzM8TZbhEtrqHPnFGLcPrrDlVCfLc8aWzWczuCyYRNIy6mMfxXb4A9z5t0hW5iaeYvU4yvcXCnVbVEQ5WNKDc/Bbh9ZqQnyuBzQy3pnqX3T++ttsN1qFkScuVuO3rwKWnG5xfZ/oXIyfxr6MidGfjcwYcyXteyl+/z4fR7juPinH59OBwUWlBErHltQEqz+QixitLLmpdW6aqA5Ctt6TNxRpRlLHJQYLVIA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794487661; c=relaxed/relaxed;
	bh=5RKPezCDyMxn9jAVFrENIEOkLGXzn5FAE3VvbYJHVsg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PBsqoctqoozw4aOjSlFghSwVg/7LifNNM4pTMju+x4q0+iW95OHSVfW32PcL2eEAUapJ332rkeSb+0d9UmY46hA+KFvvfEUxvVdb5a8OpZoBogGnqu0+uPa/Q7m6tRhTSVwLoq1rpLpjJll+YP6jkBsl0JTny5Dqct7Ud6zeCFe2wnHp7qK2mAcXMszvERjzM0LXQ0VitYG2B1zHeEmgM6fm12vvxDK8ec6+YmGv0YU3j6PnQrhXThrduaRLryslF9etL2OyFLnd9roQdp//UB3VzzQyVu72pTK7Qk8SHhVw+TCniU3Mj/b/tK0JXdypCHxt5WoBvN5kKzXJSPtlgg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NbGVQMbn; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::635; helo=mail-pl1-x635.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NbGVQMbn;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::635; helo=mail-pl1-x635.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQKt46X3zz2xly
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 23:47:40 +1100 (AEDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-2e99b1e5b4cso24575005ad.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 04:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794487658; x=1795092458; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5RKPezCDyMxn9jAVFrENIEOkLGXzn5FAE3VvbYJHVsg=;
        b=NbGVQMbnDoteLAUyAlo2jrH2qHjO7LwnSkZsJOnbu+7WArLfPjfbGt7PC/UFtSzvtw
         vDWdz0MMIueg3qagfUaouxOFTOiGIQC8Ptolo7QVrDjSurmcYpmbB70ygizxAt6Y3m0q
         FU9tOSTEzC8z7dG5/u3FmLgAPRFG1hsq1G4arwbxf2kA9No/L19JBjgATLmO1a8VMx+T
         /Uu1raoczGSFu/IeyViaLnxb0iO3+jpcSmRwSfmYyIuE3AwlFCn/cQFwZ9CnNOJy78Oz
         oqHKaph6bDXatTrMRZhiUS6AhPy9InWZadnntuqvtPxaQvCpnEEWZy9yX0FnzZ1333cQ
         XykA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794487658; x=1795092458;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5RKPezCDyMxn9jAVFrENIEOkLGXzn5FAE3VvbYJHVsg=;
        b=GFs4oN/3yH1eaBa3MXNASDDEjcXZHRuyeL8AR+USXmiBPDyXG6Pe+O3MuajmyF9mwe
         7wcjczpD90fJRlQYytswuRlljt7dRePks0RTAyYWnj9er2DocvW/XwoOE4EjE+1VQtBV
         8sfUEL2MC4uLycKgqhjPl+5EahIOEZaFoie3DERao5h+CxLqiu3iQXhQOoQwPmFB7W/9
         5M1g9uOU+vCWPHuZYINUcAw8ZBNuXMVGyTymKe1zyIpMdtg6h0Czca40J85EuPcEzYZN
         vB+qkp/rbpiGGOK05UySUM0zD+wZEI0tk6B+URitSla1F5J7UdpQPCTIO1lAI810TvJ8
         iYDw==
X-Gm-Message-State: APuU4Z+guAyCyOXL22bk4UWyPMYzi0HZ8lInZsqzWAb++OpWlttm1CIb
	uSoZZVzifp1U980XPaHD54ub+fCVsofrGRVKjfIwb4S7X3vh0NuoUc18/hzcBFvQles=
X-Gm-Gg: AYBFou1kF1R1xBuuyzq4jM8/NZZKHb9yabPygPYwe99C3ps4gq6F6yyHGM0P6X/IKRj
	crhKnVbLlHVSaPTi82vPyuRfhBYLREGzubOjliceFq6QuLB6YzxBAHxD/Xx1JBPZUYVEBvAcWCL
	9UrjBElEzjYSgeHMnfud1jo8b4sXhx2yNOO2H6JmzuONhIUtpGM9r4http8Hh7oiORWmHU61olo
	rH1kJUtZ50n8t4EZBx+4K/jb/sYAjMIFuVXdksnRUU5eed0MVInzJTsXn+07sDYAAZS1BTRQBS7
	VRkJjbRh/+6yJ+rZcv7x6By4i6z6vWZpWEcdYad57MpJ5R9zcPf/IT110R5fxbslQLzh8z1beGA
	VV/iSikMTSs6KY8uQImv3wFogJxONJpnfbtVxLj8yFRBcNl84vS5sCuRetIdiS1ueWkZWFdIYGQ
	QyYLZhqiM8Ti1Oy+5kBd/Zqr7+iPBlF/8Wid48rdSDctAsdcqwcj8t6KKD0LDMf8p3ZDAteG6Qw
	Rn02XmUPJK1uDW8rYnEGJ6K6nORuZTFQE7SfG4jt/dlHBlSm764rFoooUvIxNLqk2U1cAfcHfOs
	6fwFwWK9ufNEt16AFAgl3f2tYwlqp74yZqBtsZx7W/fkBoUJePvM49QPO6fp93JHyN6dpQ==
X-Received: by 2002:a17:902:ec8c:b0:2ed:39ab:ea6d with SMTP id d9443c01a7336-2edd73f9143mr63298825ad.7.1794487658450;
        Thu, 12 Nov 2026 04:47:38 -0800 (PST)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6dd2225sm34189905ad.56.2026.11.12.04.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:47:38 -0800 (PST)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: Yifan Zhao <stopire@gmail.com>
Subject: [PATCH 0/8] erofs-utils: fix issues found by LLMs
Date: Thu, 12 Nov 2026 20:47:17 +0800
Message-ID: <20261112124725.2774244-1-stopire@gmail.com>
X-Mailer: git-send-email 2.56.0
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
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series fixes several code issues identified by LLMs. All findings
have been manually analyzed and reviewed.

Yifan Zhao (8):
  erofs-utils: lib: fix arithmetic overflow in large file handling
  erofs-utils: mkfs: fix incremental superblock stack overread
  erofs-utils: tar: fix out-of-bounds access when trimming PAX paths
  erofs-utils: lib: fix buffer leaks in error paths
  erofs-utils: exclude: fix stack overflow when checking long paths
  erofs-utils: lib: fix gzran EOF handling and state leaks
  erofs-utils: lib: fix metabox inline data reads
  erofs-utils: fix read error and short read handling

 lib/backends/fanotify.c |  3 ++-
 lib/backends/nbd.c      |  2 ++
 lib/backends/ublk.c     |  2 +-
 lib/compress.c          |  6 ++++--
 lib/data.c              | 28 ++++++++++++++--------------
 lib/exclude.c           |  7 ++++++-
 lib/fragments.c         | 10 +++-------
 lib/gzran.c             | 27 +++++++++++++++++----------
 lib/inode.c             | 19 ++++++++++++-------
 lib/rebuild.c           |  2 +-
 lib/remotes/oci.c       |  1 +
 lib/super.c             |  8 +++++++-
 lib/tar.c               |  6 +++++-
 mount/main.c            | 10 +++++-----
 14 files changed, 80 insertions(+), 51 deletions(-)

-- 
2.56.0


