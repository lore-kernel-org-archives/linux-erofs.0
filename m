Return-Path: <linux-erofs+bounces-4249-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06776C5B572
	for <linux-erofs@archiver.kernel.org>; Mon, 17 Aug 2026 17:07:21 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hNzlq6mr7z2y8G;
	Tue, 18 Aug 2026 03:07:19 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::1032" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786986439;
	cv=pass; b=VyhVlzhj9prsINhe+v1vhrvKsJ9MLJO6k35cJLm0Jf2bB6cahjyNj1MmUgbk1t0j4I8069RSZFISbnf4ucgv35qRUIuzdfWQVinDrEYjYJEfvjTsr5n+b1mXNgkkJlQvxkzrITuiK18fAZ1ZtAZi1wtXHg0zf8R6n8QgsmZ5oYStAzpnNd3NcqMBshNnE25o/dSfWPkQopr4hVJGKN5u0tWYeG/qL3K8eKvm9sjCz/wyCxJK7i7HYn9s022RpBReUrYc/kblfsLYVzc+0yc04b2nXJ5wAr8Ab8IsyvKX3beIyGhLQsrN9qTayJWUcvpwIdEwo+8bt6PRR27dY+LWgw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786986439; c=relaxed/relaxed;
	bh=JCTohkxVKDZy1z5sbhAMxIz17RkLuhNUaF/Z6s1PMZc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=dazaDnjySfp2EOFCiyw1Q/WwMJtHDDZT/Um26ua9hsAJg8FR+ZX5fjHFUxZdNE4kNXWLotfr7OjpzcveBpJtPppBnY4qCqxWjtRHevpDbjuVLk84YJX++4+KJfCT2+Fnj6bUwQhrnjJIb6txhgVe4TuJ/X8eTDudTO96ZVHhZePJgecu89086yuMHmrlxZ7uJOQxRq4aQYtWIrbKQZPKFq6bqlGRFv6MhRrvECwZ8ZhO3DJs6F8igQa+inkRP/i1RGVgEhXtg9wfx3d8kQuRuZvFBBtWDU7RRFjwKPr5ljAZ4VVipJmYCBJ9ldMhGQCQ8X/kENKcY1zOIY3pmaNoKQ==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YqKMtCAR; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1032; helo=mail-pj1-x1032.google.com; envelope-from=isaiahdw@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YqKMtCAR;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1032; helo=mail-pj1-x1032.google.com; envelope-from=isaiahdw@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hNzlp0Wqrz2xl5
	for <linux-erofs@lists.ozlabs.org>; Tue, 18 Aug 2026 03:07:16 +1000 (AEST)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-3811f512167so5170365a91.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 17 Aug 2026 10:07:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786986434; cv=none;
        d=google.com; s=arc-20260327;
        b=NOAOD5C2ehhD3MAUh5EwdNHewCJw0jJh+gUHI2xuCeSc08Yrg+ih6ybPrYGdev5z1H
         uSM1OcmP/Hzx5EWTVpQzoWanvJkzPPHztUReGzJXU0OJJmTfQhBNdOkRmBUJkD6jLevV
         Uhwfi6/DB3sJWuTwwm73ZZ2IyeY8R3uuJx/tnMmqo/0f+XnmbgagtwENWEit/tI7LSg/
         oCKXVrU7gMj5XC1LprIc0h24HywGmktIyLjRdmQJkxzsdVIIO8zZarTJnfjR1iZwvtTI
         qmvp8PCGYmcxRy6a7YLNW505cCDApquh1WvZGOjeL8r2mqUzYBjCYiaAg2EryA5BxT9v
         j0qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=JCTohkxVKDZy1z5sbhAMxIz17RkLuhNUaF/Z6s1PMZc=;
        fh=JcF7iGUjJsVSaM7oSS1RWcr27vz0aVsrVNsuXyQexrw=;
        b=RQ7kFSNvTplAWpT8DSs06QGoyZ+2oLB3miorrrNZbcOh3jykuxck41Gow4D1FZ0VMG
         jksytHhK4XhYIUoWz7/PJvGEc/RPwFHojZvlZ9PZ/X1BB4wvaV1v2l+eQ2A+/TGBZnXs
         VuQqNMllk0SoctsmceM8Oso2J1VcBkuhIGL80HGZFCv3HskxG8afAMS7yO8h5OWhjoI4
         0GsU9AfyTlMcI3oVMcaWImkSa1ScYdXOnEYO/qdMkSfmNjElnuHhzRf3JeJJRauvc2sM
         0bgpgOc1Y/Qxx25xd2qMj39A584kdgQi/PTXnf906AYb4ty5Fs8ABDBi3Wb1YXN1yVD7
         Sjbw==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786986434; x=1787591234; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JCTohkxVKDZy1z5sbhAMxIz17RkLuhNUaF/Z6s1PMZc=;
        b=YqKMtCARKtN51tX6I223NvO5om7fZNG94kEmdohGCR/jj4bbzM5+G3UdrUV+5WA0gq
         hcxc7QArQlVZEMn0ExsA4ZNHhyhE3htLKM2uQk6GxYMStp/U+iKZ6R1zDxOUEB15J2GN
         ecngTC1GrZ3LiifUJNuO6Wfm5a3dXyeCZMwD3DBDNGd/Z/Ul2G/nOvBU6r19es4fyfsj
         nHsuJ6LhRhkG3RMjMOwEJYO3gmUPGfECsAoVai2LMBXWgzIRCp/Sk5jyNhlfx+ZNXT9g
         uroIpG48SRxykKUv+ywzLtazbFxIrfgbkLtg1RbVSLc3/Df89SM7E+sqUYbnhf5h9N9d
         oYPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786986434; x=1787591234;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JCTohkxVKDZy1z5sbhAMxIz17RkLuhNUaF/Z6s1PMZc=;
        b=SWGhxhRCmwd7l8bQRGj6QIiiRcaFSTuKy8ITrE2KBqDrHOb4meUrKznEJ1C4/BAt0m
         zlJ9hTNLA16EfYecRJmJFwDcFr/VY+M/cir6WKjpyHybb7iZHF2IrBzYX68T/CKkaxiD
         sTo7rygU+FDD1P+IkTlDDmpzje7lwNLWYx0Rsba6QLJ5PBqg+PKn2/5u3tDcforxT0hz
         fPNE2zI1avfC80p7D2xyeW8H90rKWI+kVhk387Wv44mYlgTaMRIAB3VMkzYQpV7IEqeZ
         RkHRR8TsEVTUcVvlPZjw5lnzcRPJWZY6kMnQ181oq9JFVnq0yA9uK87kdmWVIzzxgIao
         M3kw==
X-Gm-Message-State: AOJu0YwMeFOIZbjQ+uoY4IMxIO/Uu4FSfEJI85P+Qf1KreB57FZCoWIZ
	uqlai+8iPo5wqUdiWGKLb5yXuKT+E9Tzq+rVM0JQbB+YtzHMZr3WJThy/+Q7apyaXN8sg0Kf5W4
	uyNpBtln+O9DjlAW+gB2K5Sy47JrZQEyF4y1f2b93
X-Gm-Gg: AR+sD134U+bX3cuXLeQ2PmzYMo8XxeZgy8nY5Se2n0px+kPiwfG4purY5HPLBbESoUS
	ltjjLU3YcSODMz5Ch+abQDgBLa59rOOWYQzzEKjoM7ay+l2lQ4LzYgwUTI4FmWtrUVQywba7SbJ
	sqXS76r6IBW6C6RwvbbKGzI4AvKskcs5DkwkTAkQmol9kuFIvmRANoTw0gN/ih5wJr7r6YZagmx
	0Oz3fvfEiTRPsbx4YsI0zEsuhOUxnEOqkVUmdB1mL4UTCBg/BO6pCFsitMb3Y2ZuMgzKFuJGDC1
	qi+BFfgrbQRCb7+nUODCnZ8W8kjtYaFORdRGKm38a0tL7/MOLaIeEJMOZ1MzgpCRb+M/FZyAbEf
	k
X-Received: by 2002:a17:90b:4984:b0:38e:8300:af51 with SMTP id
 98e67ed59e1d1-3955a762459mr1842239a91.8.1786986433407; Mon, 17 Aug 2026
 10:07:13 -0700 (PDT)
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
From: Isaiah Derose-Wilson <isaiahdw@gmail.com>
Date: Mon, 17 Aug 2026 10:07:01 -0700
X-Gm-Features: AcwNN1XjnnsqpLEvfFsWJOxe9iWOQIH53vl9zG0OhDBdXIu3S0GCQ26h9g82FuU
Message-ID: <CAMTkE+Te5f7v9MV4B6sBnHdC5XLcJtPQiS29PhFhVhqHtr+uJQ@mail.gmail.com>
Subject: [PATCH] erofs-utils: mkfs: fix uninitialized z_erofs_mt_ctrl.mutex
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org
Content-Type: text/plain; charset="UTF-8"

z_erofs_mt_ctrl.mutex guards the multi-threaded compression idle
work-item list but is never initialized: z_erofs_mt_global_init()
initializes g_ictx.mutex and g_ictx.cond, not this one.

A zero-filled pthread_mutex_t happens to be a valid initialized mutex
on glibc, so Linux builds are unaffected by accident.  On macOS a
zeroed mutex is invalid: pthread_mutex_lock() fails with EINVAL and,
since the return value is not checked, the idle-list critical sections
in z_erofs_mt_compress() and erofs_mt_write_compressed_file() run with
no mutual exclusion at all.  The torn list can hand the same work item
to two owners, which corrupts the workqueue and crashes mkfs.erofs
non-deterministically (NULL work dequeued in worker_thread(), SIGABRT,
or corrupted output).  --workers=1 does not help since the race is
between the producer and the reaper thread.

Initialize the mutex statically.

Fixes: 830b27bc23342 ("erofs-utils: mkfs: introduce inner-file
multi-threaded compression")
Closes: https://github.com/erofs/erofs-utils/issues/53
Signed-off-by: Isaiah DeRose-Wilson <isaiahdw@gmail.com>
---
 lib/compress.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/compress.c b/lib/compress.c
index 48a18b9..9262afa 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -110,7 +110,9 @@ static struct {
  struct erofs_workqueue wq;
  struct erofs_compress_work *idle;
  pthread_mutex_t mutex;
-} z_erofs_mt_ctrl;
+} z_erofs_mt_ctrl = {
+ .mutex = PTHREAD_MUTEX_INITIALIZER,
+};

 struct z_erofs_compress_fslot {
  struct list_head pending;
-- 
2.55.0

