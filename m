Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EFACE7717D
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Dec 2024 06:39:43 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Y8fp56N5yz3bSr
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Dec 2024 17:39:41 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1734071980;
	cv=none; b=m5M/WKZVZQbYudzpo95EdUOwskvfrW4cnIgZ6EGTH7u+j8va3Y0obyb75Qb1E5SbszIemhB0Rt14itnHnm709aIkYOPjMPnE5p3qCnsPTo7ZeZkUJlmegVbv9MCF52AecNh+ZwUAFIqEx4x0nW01YCr0Xo62l/Qip5jZnvopOhT3gAUAN15Se9E2z/1ZBjhnfqK7JCGSjgFYWLVmPrfnwVW3LUDIFGT1vBDYT4Kdxwm/CDCiGpafacjqu0wJZLV34SeKGRpqGVYNgV/T74rdeASEJDuZjJtLt1IOGOjSCcpFsPiVjKjto6DcEdC+wnyvLZGxdJ3I/UMyrcIJO/u2Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1734071980; c=relaxed/relaxed;
	bh=d+/ojMztkQ0TdS5Qa608puNUzRgOV21b7U/xGq06BDs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b0EhOf3DpqsC51P0hmgDJVSBrVJQwrbn9a4PhFRmYLGP/2gQok7I7v9sgY30maWSMZ8dJkeJplEsxPEqb5gBg4jRb/x9MZbgWWhUhpCxECaErB98/aWPCyNya7A/Q3rOeR0tQm3GuH7w5nuvQJjbzhet1lE+lwQgeZqKb5XijijuFDEjU2N6ope2xWI2rUqajwD+PFoFPnoluB7BMgA8QE/rlhs73b0w/QpHD7P8tPlRoVH9JR9qBB9l4yQq/Zxb+sA+ymOypfOiXAEK8pwONi3JTwlB+c9lhON1a9fzoSuEJ2kxpzhoubdSafcGjjQCYI04r4nomJXPzgkuY94ytA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=A0T3lRYW; dkim-atps=neutral; spf=pass (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=A0T3lRYW;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Y8fnz2xbCz2yhM
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Dec 2024 17:39:33 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734071967; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=d+/ojMztkQ0TdS5Qa608puNUzRgOV21b7U/xGq06BDs=;
	b=A0T3lRYW5D74IfuH6o1Kqi+tqnW6tiGpKYmkg5GWSVOTLUSPijh+JYuqOKCe8653F+SJ2exfMfsb3DdKNOwW+rAo0Bot7UIbor2RVrkInVTV5PkVDvifVUVXP2IuJ66RSrlLf5nyTCRr+h3KplGT5WGO5Fu3PJFP0jHnp0QH1qQ=
Received: from 30.221.130.36(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WLO8fYi_1734071965 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Dec 2024 14:39:26 +0800
Message-ID: <c70d771a-ad46-404c-80c0-4285e0f3ca72@linux.alibaba.com>
Date: Fri, 13 Dec 2024 14:39:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] erofs-utils: lib: correct erofsfuse build script
To: ComixHe <heyuming@deepin.org>
References: <8725A28257A20420+20241213063250.314786-1-heyuming@deepin.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <8725A28257A20420+20241213063250.314786-1-heyuming@deepin.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Comix,

On 2024/12/13 14:32, ComixHe wrote:
> Some of the symbols required by erofsfuse are provided by liberofs.
> When option 'enable-static-fuse' is set, all these object file should be
> exported to liberofsfuse.a

Could you give more hints why `lib_LIBRARIES` doesn't work?

I fail to get the point why `lib_LTLIBRARIES` is needed for
static libraries...

https://www.gnu.org/software/automake/manual/1.7.2/html_node/A-Library.html

Thanks,
Gao Xiang

> 
> Signed-off-by: ComixHe <heyuming@deepin.org>
> ---
>   fuse/Makefile.am | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fuse/Makefile.am b/fuse/Makefile.am
> index 1062b73..50186da 100644
> --- a/fuse/Makefile.am
> +++ b/fuse/Makefile.am
> @@ -11,9 +11,9 @@ erofsfuse_LDADD = $(top_builddir)/lib/liberofs.la ${libfuse2_LIBS} ${libfuse3_LI
>   	${libqpl_LIBS}
>   
>   if ENABLE_STATIC_FUSE
> -lib_LIBRARIES = liberofsfuse.a
> -liberofsfuse_a_SOURCES = main.c
> -liberofsfuse_a_CFLAGS  = -Wall -I$(top_srcdir)/include
> -liberofsfuse_a_CFLAGS += -Dmain=erofsfuse_main ${libfuse2_CFLAGS} ${libfuse3_CFLAGS} ${libselinux_CFLAGS}
> -liberofsfuse_a_LIBADD  = $(top_builddir)/lib/liberofs.la
> +lib_LTLIBRARIES = liberofsfuse.la
> +liberofsfuse_la_SOURCES = main.c
> +liberofsfuse_la_CFLAGS  = -Wall -I$(top_srcdir)/include
> +liberofsfuse_la_CFLAGS += -Dmain=erofsfuse_main ${libfuse2_CFLAGS} ${libfuse3_CFLAGS} ${libselinux_CFLAGS}
> +liberofsfuse_la_LIBADD  = $(top_builddir)/lib/liberofs.la
>   endif

