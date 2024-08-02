Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AA6FC3DA7F
	for <linux-erofs@archiver.kernel.org>; Fri,  2 Aug 2024 21:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1722633464;
	bh=r04eKtbuaYaKRL/5KXeRievNb3xfp24xr5gAiqG5g7Q=;
	h=References:In-Reply-To:Date:Subject:To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=fHvnBn0wpZGWegCjBbYBxPKiMXjYmzlF3xfJhEZmnJuruqrS1BB6JVHe51CPr7/SA
	 hSK4SfvNUAkqS7XVsqKo/wjg+ysgEwIRAxUFlj4LsIrNGjgLNcn8yFC6uQc+B2w1YB
	 Yf4S52idWX/iIGF336fm9/zBgMaXH/9PuaoaiJS4OQTO9+kYieYvDJT61MFZTQqZ6x
	 EYj4pWHljlSrPzi65klzsxUgBh0gPj0Elh8cI2RH+Z3UrH3XXll6IZWdTrDNdm9JPK
	 G0bsOSZYPKGNuQTfHN3hOChswkpxMcFOK8CUGYx6SSDoMsnYi3/3od3vnHBVNUb0nV
	 ulrMfir3drIAg==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4WbJZc28P4z3fT8
	for <linux-erofs@archiver.kernel.org>; Sat,  3 Aug 2024 07:17:44 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20230601 header.b=Kf8dXFDT;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=google.com (client-ip=2a00:1450:4864:20::42b; helo=mail-wr1-x42b.google.com; envelope-from=dhavale@google.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4WbJZT2C01z3dL8
	for <linux-erofs@lists.ozlabs.org>; Sat,  3 Aug 2024 07:17:36 +1000 (AEST)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-3685b9c8998so3801084f8f.0
        for <linux-erofs@lists.ozlabs.org>; Fri, 02 Aug 2024 14:17:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722633446; x=1723238246;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r04eKtbuaYaKRL/5KXeRievNb3xfp24xr5gAiqG5g7Q=;
        b=Bdk6Fn18P97jnqq1Ck5fZNHx5tmA3hpNicb8WDeNkyfusE4CeuCJr/dXUgriR6wpUJ
         evwku62OdAI5qFnbgi+LFA4pntRxwxr1piGFf2EEyfUm3x7MFgPOOXSzbXGzbT30IfRD
         7eLaiK5WrmFdT4U5jlu6FFilzXQkB+iqeRZi/xz0JKgXZXM0v4qXsL5TSMCuocq0WBrX
         +Uy+YYGwG7nLQfubMEvHiVtAKPaVNBUlEtY+H9Mf5lgir7DOGjRmzESCRrbuq73jkwFT
         hjLczPDA3zdNem95dJKS2eWLeIW7h3FRvaxpeAnWNNqFnGmQeNJ/I6Cdw4irX3UOda2j
         sutw==
X-Gm-Message-State: AOJu0YyP+96kgau5hJnF3ahyva50bl24wzwJ88BbInMH3mlqPQUHH5Yo
	f6kSadUdsBnauLarbfpBLG28Mktf6GY38s+1oOxxwUIVYVvjZ095yDymebSbLllrs/GaesULHRv
	+dx0XZmBy6G7OjUdGGHEAimugM7tv09rjXhLU
X-Google-Smtp-Source: AGHT+IH45K+Qq5g4K1Q24RzERe3TgOhOrE4LWT8azg5sggJyFqNCuPvKMXOgRR+uh8Jz88Oea28t3H9b9o7OPHzqwTk=
X-Received: by 2002:adf:b606:0:b0:368:4da7:5c35 with SMTP id
 ffacd0b85a97d-36bbc11bab2mr2329565f8f.30.1722633445351; Fri, 02 Aug 2024
 14:17:25 -0700 (PDT)
MIME-Version: 1.0
References: <20240802015527.2113797-1-hsiangkao@linux.alibaba.com>
In-Reply-To: <20240802015527.2113797-1-hsiangkao@linux.alibaba.com>
Date: Fri, 2 Aug 2024 14:17:12 -0700
Message-ID: <CAB=BE-QZog8YH8DckC5s2T1sU28p4vN60wd86CAeuuSv3XAhOQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] erofs-utils: fsck: fix fd leak on failure in erofs_extract_file()
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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
From: Sandeep Dhavale via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Sandeep Dhavale <dhavale@google.com>
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Gao,

On Thu, Aug 1, 2024 at 6:55=E2=80=AFPM Gao Xiang <hsiangkao@linux.alibaba.c=
om> wrote:
>
> Ignore the return values as other close()s instead.
>
> Coverity-id: 502331
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> ---
>  fsck/main.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/fsck/main.c b/fsck/main.c
> index fb66967..bbef645 100644
> --- a/fsck/main.c
> +++ b/fsck/main.c
> @@ -702,11 +702,9 @@ again:
>
>         /* verify data chunk layout */
>         ret =3D erofs_verify_inode_data(inode, fd);
> +       close(fd);
>         if (ret)
>                 return ret;
I think we can get rid of this if block and should be just
return ret;
> -
> -       if (close(fd))
> -               return -errno;
>         return ret;
>  }
>
> --
> 2.43.5
>
You can just do that while applying,

Reviewed-by: Sandeep Dhavale <dhavale@google.com>

Thanks,
Sandeep.
