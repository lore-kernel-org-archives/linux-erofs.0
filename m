Return-Path: <linux-erofs+bounces-3487-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C13EFCD5BC9
	for <linux-erofs@archiver.kernel.org>; Wed, 27 May 2026 10:08:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gQQLS1HNVz2xLs;
	Wed, 27 May 2026 20:08:32 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.225
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1779876512;
	cv=none; b=gFob+NJ5HLu9DZkf7zDHH8igvgIozFcXGRgt5RmwPQuOoEhlgc2Sgm8s3VcZ8D6rozbdIHO9XBTSBPIC/0pUPNNSmxXRp44fQ17Utk2ITP1ksZJCNFo2mP9qKnCJ1Ih9bV4rQIgKqiq2ZhPIqG2jwzAYqbFi1+/+Q8YvE0IMmZIgJD9pphA51p7MxU9viPy6Wn55voR3Z9yC1ZO3MgHue1r8Rb/NAND9LU0Hq8b45ZppCkOMAyw797gp8s/we6XhooTuqA/BoIOEx9n17/2uNPng5p5kPKWAphIAQcZONjdsJQrJJ9UVzmZCkuXg2fzXPkEIy0cqIBwPECeV/EfqMw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1779876512; c=relaxed/relaxed;
	bh=vv5CFOKfOWIXfO19koIfQYcOXWKsBNGbQr34Ze2RaS8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=RoI7QyNAQ4LYeOVg+ypgiDyiW8Py6DrfQeglHFtBuXoWj7RNIr8yEK8F3pCjrU7z+MKkwuhELYH2zr74XYyqU8ESr1ST4VOKsivJg2JuUsBjR7hnhCTUYAANEwgb1al7xv+P+gpAiW7kH/5AqQ2gAQAtV3OCTJGhzVW6IUTRvzmFXvvqaEokNZb9RP6wNOvRQF/w4WgJ+g1KvxB0qXppD4uX6SXyZSkEO62DbqKBAEwVb7IvlI4ZQ9PtXZL/Espss5C8UWV8Egl7HnZuNWG9geN7pNQkia+NceNrlMwsDDK7hEwYpIgVAZYQfX51kUR8TvlzHNqmgKNcyLyTT8v1Sg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=uFQ80U+N; dkim-atps=neutral; spf=pass (client-ip=113.46.200.225; helo=canpmsgout10.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=uFQ80U+N;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.225; helo=canpmsgout10.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gQQLR1jR0z2xHK
	for <linux-erofs@lists.ozlabs.org>; Wed, 27 May 2026 20:08:31 +1000 (AEST)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=vv5CFOKfOWIXfO19koIfQYcOXWKsBNGbQr34Ze2RaS8=;
	b=uFQ80U+N1hX6+dSvaDJxVEfMz/DD944AdmQGCu0qYqZuudIHkjWHY4a8FvGgwJMXy2nwZcZr2
	ygsKphQ1LPLJv3AAIq1K7hg9pi8jjghXt7gjwZ3hSJ+I7FJQhrzGeYgXPmGzAhUkK2mBhDyVnlO
	QYkvyGiGxNFL7xlTSU5DgBY=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4gQQ9R5ZFjz1K97s
	for <linux-erofs@lists.ozlabs.org>; Wed, 27 May 2026 18:00:43 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 266E340538
	for <linux-erofs@lists.ozlabs.org>; Wed, 27 May 2026 18:08:28 +0800 (CST)
Received: from [100.102.28.251] (100.102.28.251) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 27 May 2026 18:08:27 +0800
Message-ID: <76ec029a-d781-46e5-bd84-53e3e38bfaa7@huawei.com>
Date: Wed, 27 May 2026 18:08:27 +0800
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
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] erofs-utils: build: drop stale liblzma path handling
To: <linux-erofs@lists.ozlabs.org>, <guoxuenan@huawei.com>
CC: <zhukeqian1@huawei.com>
References: <20260527100558.980152-1-zhaoyifan28@huawei.com>
From: "zhaoyifan (H)" <zhaoyifan28@huawei.com>
In-Reply-To: <20260527100558.980152-1-zhaoyifan28@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [100.102.28.251]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100010.china.huawei.com (7.202.195.125)

Hi Xuenan,


Could you help test whether this patch solves your problem?


Thanks,

Yifan


On 2026/5/27 18:05, Yifan Zhao Wrote:
> liblzma now uses PKG_CHECK_MODULES() for path discovery, but a
> leftover assignment still rewrote liblzma_LIBS to plain `-llzma`,
> dropping pkg-config linker flags such as `-L${prefix}/lib`, which
> breaks custom liblzma path discovery.
>
> Remove the redundant logic and drop the obsolete INSTALL.md reference
> to --with-liblzma-{incdir,libdir}.
>
> Reported-by: Guo Xuenan <guoxuenan@huawei.com>
> Fixes: 37ada1b449ae ("erofs-utils: support liblzma auto-detection")
> Assisted-by: Codex:GPT-5.5
> Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
> ---
>   configure.ac    | 7 -------
>   docs/INSTALL.md | 3 ---
>   2 files changed, 10 deletions(-)
>
> diff --git a/configure.ac b/configure.ac
> index 45b8190..f68bb74 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -808,13 +808,6 @@ fi
>   
>   if test "x${have_liblzma}" = "xyes"; then
>     AC_DEFINE([HAVE_LIBLZMA], [1], [Define to 1 if liblzma is enabled.])
> -  liblzma_LIBS="-llzma"
> -  test -z "${with_liblzma_libdir}" ||
> -    liblzma_LIBS="-L${with_liblzma_libdir} $liblzma_LIBS"
> -  test -z "${with_liblzma_incdir}" ||
> -    liblzma_CFLAGS="-I${with_liblzma_incdir}"
> -  AC_SUBST([liblzma_LIBS])
> -  AC_SUBST([liblzma_CFLAGS])
>   fi
>   
>   if test "x$have_zlib" = "xyes"; then
> diff --git a/docs/INSTALL.md b/docs/INSTALL.md
> index 2e818da..0290c2d 100644
> --- a/docs/INSTALL.md
> +++ b/docs/INSTALL.md
> @@ -42,9 +42,6 @@ $ ./configure --enable-lzma
>   $ make
>   ```
>   
> -Additionally, you could specify liblzma target paths with
> -`--with-liblzma-incdir` and `--with-liblzma-libdir` manually.
> -
>   ## How to build erofsfuse
>   
>   It's disabled by default as an experimental feature for now due

