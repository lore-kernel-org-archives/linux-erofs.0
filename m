Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D43A2E92FFD
	for <linux-erofs@archiver.kernel.org>; Sat,  7 Oct 2023 07:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1696663013;
	bh=wjRAp+ikeUbb8dodWfwglF0e+RGqAmpSoPEn6UTC54w=;
	h=References:In-Reply-To:Date:Subject:To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=QGD7mZ2qkDLQefqK6PqSNFuDRGYBXByReKBYqJVqI0Fmrkih55w/q9H3AOLG1jTZT
	 pJQZhQFlBi3c/sQkJN4kXJDaqEVZgwevjQTplUBLaE8n4BfU83DtuaKEU9rbNNSciV
	 YjCXbXjQ/oEGH5odGurWTZ3b1R6l/TGJdcqocFw38YNRnooBEH8ELQSRUkqtOtT8uH
	 64uauZBHk0ElSFEfdct+xzxuoIGbXzu7AFgXURU/4VmJb7BKnhic1C7VrrDPjdZ2YI
	 8Um4TmxcMIL1bdbQDdKYRzg+ES8Pc8X+3+5w5DRAOns4db1W+yxj3xt4v6dtUvGacS
	 iNhpiVv3VRaaw==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4S2c6s02xMz3dnN
	for <linux-erofs@archiver.kernel.org>; Sat,  7 Oct 2023 18:16:53 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20230601 header.b=j0NqvEPo;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=google.com (client-ip=2607:f8b0:4864:20::a2f; helo=mail-vk1-xa2f.google.com; envelope-from=dhavale@google.com; receiver=lists.ozlabs.org)
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4S2c6j3VGVz3c8r
	for <linux-erofs@lists.ozlabs.org>; Sat,  7 Oct 2023 18:16:44 +1100 (AEDT)
Received: by mail-vk1-xa2f.google.com with SMTP id 71dfb90a1353d-49aa8518df8so1923046e0c.1
        for <linux-erofs@lists.ozlabs.org>; Sat, 07 Oct 2023 00:16:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696662999; x=1697267799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wjRAp+ikeUbb8dodWfwglF0e+RGqAmpSoPEn6UTC54w=;
        b=QFz7IVFMQ+WexgVfq2m3K35/6DBnWplAG/mumiL+KOul+jsUenWgBOL2VQjVdMzxMZ
         9j6qDmwzQFzMa6yPMmavWY+tWD8VDmuQ0fVMyqDpxCFXTpTRwXgobJCyeJRy/Rb25M2G
         TQu++wpJqlbFPNBxzhCetIzL54H+Mzv97v7q6PoDyiZknNZLHps4fCK+BE9bifqPbWvl
         N1V+0QySmOX8jVdde5efBMjqQon8lsD3hJki8IbJDwhWGBz4dGc4eoLPrCTrveSgclKc
         lIsI3EK8ov9CTqr4Omtmc4FgribbBBegBMI2zxN8UHgU31c4knewI4FsrWFlOH3zXZ5S
         bXug==
X-Gm-Message-State: AOJu0Yzn4wu4I9qnh0RmG+flBfJvW8Jv+UPU7+jjBP8Gc1EJVefRYyCi
	5MItmolskNY89fsLKMzWwbc0JWRdjH+T8x6tUcpDuQ==
X-Google-Smtp-Source: AGHT+IGZOK/wO9HbZS/zAl0YJ++wCFs8mKRV/mTK9VfoQ/IyBmNco1x5ej4K8gxJBHZy1q6wACsZNGppRpBh94OjePI=
X-Received: by 2002:a1f:a090:0:b0:49d:20fb:c899 with SMTP id
 j138-20020a1fa090000000b0049d20fbc899mr3755978vke.4.1696662998728; Sat, 07
 Oct 2023 00:16:38 -0700 (PDT)
MIME-Version: 1.0
References: <20231005224008.817830-1-dhavale@google.com> <531b8a1b-efbb-8fcb-a0f8-018c8650611f@linux.alibaba.com>
In-Reply-To: <531b8a1b-efbb-8fcb-a0f8-018c8650611f@linux.alibaba.com>
Date: Sat, 7 Oct 2023 00:16:27 -0700
Message-ID: <CAB=BE-RR4MsevBPbrmr-QmH8ihzTnQhrQuJoh1Fr6BquP9AS8A@mail.gmail.com>
Subject: Re: [PATCH v1] erofs-utils: Fix cross compile with autoconf
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
Cc: kernel-team@android.com, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Fri, Oct 6, 2023 at 8:27=E2=80=AFPM Gao Xiang <hsiangkao@linux.alibaba.c=
om> wrote:
>
> Hi Sandeep!
>
> On 2023/10/6 06:40, Sandeep Dhavale wrote:
> > AC_RUN_IFELSE expects the action if cross compiling. If not provided
> > cross compilation fails with error "configure: error: cannot run test
> > program while cross compiling".
> > Use 4096 as the buest guess PAGESIZE if cross compiling as it is still
> > the most common page size.
>
> Thanks for your report!
>
> >
> > Reported-in: https://lore.kernel.org/all/0101018aec71b531-0a354b1a-0b70=
-47a1-8efc-fea8c439304c-000000@us-west-2.amazonses.com/
> > Fixes: 8ee2e591dfd6 ("erofs-utils: support detecting maximum block size=
")
> > Signed-off-by: Sandeep Dhavale <dhavale@google.com>
> > ---
> >   configure.ac | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/configure.ac b/configure.ac
> > index 13ee616..a546310 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -284,8 +284,8 @@ AS_IF([test "x$MAX_BLOCK_SIZE" =3D "x"], [
> >       return 0;
> >   ]])],
> >                                [erofs_cv_max_block_size=3D`cat conftest=
.out`],
> > -                             [],
> > -                             []))
> > +                             [erofs_cv_max_block_size=3D4096],
> > +                             [erofs_cv_max_block_size=3D4096]))
> >   ], [erofs_cv_max_block_size=3D$MAX_BLOCK_SIZE])
>
> Actually the following check will reset erofs_cv_max_block_size to 4096
> if needed. But it seems that it has syntax errors.
>
Hi Gao,
If I understand this correctly, the problem here is not having defined
action if we are cross compiling for AC_RUN_IFELSE(). The cross
compilation will fail until we have an action defined.

While at it I specified erofs_cv_max_block_size=3D4096 for the second
action which will be the value if the test program fails to detect the
page size.

With your suggested patch, cross compilation still fails with the error
>configure: error: cannot run test program while cross compiling
>See `config.log' for more details

Thanks,
Sandeep.

> I wonder if the following diff could fix the issue too?
>
> Thanks,
> Gao Xiang
>
> diff --git a/configure.ac b/configure.ac
> index 13ee616..94eec01 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -288,6 +288,9 @@ AS_IF([test "x$MAX_BLOCK_SIZE" =3D "x"], [
>                                []))
>   ], [erofs_cv_max_block_size=3D$MAX_BLOCK_SIZE])
>
> +AS_IF([test "x$erofs_cv_max_block_size" =3D "x"],
> +      [erofs_cv_max_block_size=3D4096], [])
> +
>   # Configure debug mode
>   AS_IF([test "x$enable_debug" !=3D "xno"], [], [
>     dnl Turn off all assert checking.
> @@ -501,9 +504,6 @@ if test "x$have_libdeflate" =3D "xyes"; then
>   fi
>
>   # Dump maximum block size
> -AS_IF([test "x$erofs_cv_max_block_size" =3D "x"],
> -      [$erofs_cv_max_block_size =3D 4096], [])
> -
>   AC_DEFINE_UNQUOTED([EROFS_MAX_BLOCK_SIZE], [$erofs_cv_max_block_size],
>                    [The maximum block size which erofs-utils supports])
