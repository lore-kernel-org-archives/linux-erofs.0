Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8A1AC43334
	for <linux-erofs@archiver.kernel.org>; Sat, 11 Jun 2022 23:17:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4LLDHj6cHGz3c96
	for <linux-erofs@archiver.kernel.org>; Sun, 12 Jun 2022 09:17:05 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20210112 header.b=MkUznwHR;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1133; helo=mail-yw1-x1133.google.com; envelope-from=sudipm.mukherjee@gmail.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20210112 header.b=MkUznwHR;
	dkim-atps=neutral
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4LLDHd68CBz3bwk
	for <linux-erofs@lists.ozlabs.org>; Sun, 12 Jun 2022 09:17:00 +1000 (AEST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2ef5380669cso21343387b3.9
        for <linux-erofs@lists.ozlabs.org>; Sat, 11 Jun 2022 16:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7tY0AdLKGQcBZThRCKqEnHHKhqjAUktylGqxkcbwV5M=;
        b=MkUznwHRAxP9+dhosAeqvGb2QHCUqhvglnLe+Ay0eMDpsTrsROFrqBqQNV907jqR1k
         PE2DZB0piQZii/9kYn3Nn6qK4782QU37QOcmw7/isWdIyQV+2HSeVQdT43sMKW2+E8JI
         dhOaGyLje/PreClJgBIcQ6/7fcZqE4h66uDkBxHR/kjW+qZwvD5X9qTF+pX9Ulcqw6XA
         P3abM7JyEvmvQmqbrIwWVbuRM2ZH8kxFqEIKDrMHJjfFKdsDBG/HUMY4NmC/FetK5vbt
         q9BwbuOnI+NtI6u57xBjA1qJzpd2I2vWt4s2kFz6zP9JEHmDYIQhgT8OsOrjWu2Qs1BM
         7PeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7tY0AdLKGQcBZThRCKqEnHHKhqjAUktylGqxkcbwV5M=;
        b=HphgffPCjkWt1cQTq4umBdnd7M+xYiFfn4MQp7ArN1AYYhNqMnm/ZMirSkf4ydCj5N
         D9FT7JmFA/qkJof5h2yrO+3/yj6eCJzlz3bOXay9SfqRAD+Doa8wfSqoY8XkXE0QlsO0
         2uNe+Dnw7KjyU9NQ+b0kEQ3zpmkceYNCwzZHHM+wKof/38YHBv5J7ZtGbgFcG6FL0TJw
         GqMNs3PifOByIebxaK7Nf1WJfFjB4m4KnD0jSnqCYcOBbhX0QPXjv9V/VGg6oWFznKux
         55BDrbgQjzWaTmJ21e3IlcCh7DsBckKFY0iab67nF+1A3rjZxYS7bPU/RfLGlh9FdMdr
         GxYQ==
X-Gm-Message-State: AOAM530Sjch0LDTwzQvthF7OkG3C4wqOBUFG/FiqaVF64NqXTBW1Jdf7
	5UBMZanpWuBA57noWUmhDlKrk9wp/+cGJmpArBQ=
X-Google-Smtp-Source: ABdhPJzlwYpvKTPyyPdeXtV2pl9MFSrG58VQNbCZMgzIM4+A3xkdjLHgnk9bXvveXs22MFjk8SlQTB1IJrT1XFksgVA=
X-Received: by 2002:a81:25cc:0:b0:30f:ea57:af01 with SMTP id
 l195-20020a8125cc000000b0030fea57af01mr54129487ywl.488.1654989417608; Sat, 11
 Jun 2022 16:16:57 -0700 (PDT)
MIME-Version: 1.0
References: <YqRyL2sIqQNDfky2@debian> <YqSGv6uaZzLxKfmG@zeniv-ca.linux.org.uk>
 <YqSMmC/UuQpXdxtR@zeniv-ca.linux.org.uk> <YqSQ++8UnEW0AJ2y@zeniv-ca.linux.org.uk>
In-Reply-To: <YqSQ++8UnEW0AJ2y@zeniv-ca.linux.org.uk>
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Sun, 12 Jun 2022 00:16:21 +0100
Message-ID: <CADVatmOJvTj21vrL5cnAVjWx46cB4r_kB+T2ankDj+mKH2-7=w@mail.gmail.com>
Subject: Re: mainline build failure due to 6c77676645ad ("iov_iter: Fix iter_xarray_get_pages{,_alloc}()")
To: Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
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
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dominique Martinet <asmadeus@codewreck.org>, linux-kernel <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, linux-cachefs@redhat.com, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, linux-erofs@lists.ozlabs.org, linux-afs@lists.infradead.org, devel@lists.orangefs.org, Mike Marshall <hubcap@omnibond.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Sat, Jun 11, 2022 at 1:56 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Sat, Jun 11, 2022 at 12:37:44PM +0000, Al Viro wrote:
> > On Sat, Jun 11, 2022 at 12:12:47PM +0000, Al Viro wrote:
> >
> >
> > > At a guess, should be
> > >     return min((size_t)nr * PAGE_SIZE - offset, maxsize);
> > >
> > > in both places.  I'm more than half-asleep right now; could you verify that it
> > > (as the last lines of both iter_xarray_get_pages() and iter_xarray_get_pages_alloc())
> > > builds correctly?
> >
> > No, I'm misreading it - it's unsigned * unsigned long - unsigned vs. size_t.
> > On arm it ends up with unsigned long vs. unsigned int; functionally it *is*
> > OK (both have the same range there), but it triggers the tests.  Try
> >
> >       return min_t(size_t, nr * PAGE_SIZE - offset, maxsize);
> >
> > there (both places).
>
> The reason we can't overflow on multiplication there, BTW, is that we have
> nr <= count, and count has come from weirdly open-coded
>         DIV_ROUND_UP(size + offset, PAGE_SIZE)
> IMO we'd better make it explicit, so how about the following:

Thanks. Fixed the build for me.


-- 
Regards
Sudip
