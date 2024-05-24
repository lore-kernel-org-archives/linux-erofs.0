Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11EFBC25B74
	for <linux-erofs@archiver.kernel.org>; Fri, 24 May 2024 07:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1716534501;
	bh=p7x1twet5RPnivrXniE5a/6hYyvmJ0b1bq8goFKQemU=;
	h=References:In-Reply-To:Date:Subject:To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=PpS/7QTXhTEytKbTT5UEzN1vhnyq4Vw7t0AigWkmtf4aN8K4j8Ch/aUF0VMa5ZFDQ
	 1IXVU621QBVLmsd4ddDqvCsLa0k5Cc+LdWAmexNUbxkcTH0gZgZs3JM2sG35zDzIR5
	 Fu/U/pSE0WtFrMhNt61Ux5MKVaiNjci1tGdhTT2kon6yMiqDnuHLVgu0EdU8dMOIo1
	 KDuXO6vFHK2ImqOCdaJMt9mq41ZGvWvyJ8eJOIC0aStbJDlAE9nSokJLRHKVRYrGnS
	 B8DjCPGLPDLKcDqRPH237wIy3ridWgWMco9NkBOnRT9h00t07cKhHwunacWVBkn6mk
	 EOWCasRHZubbw==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Vlx2s1Tt2z87Fg
	for <linux-erofs@archiver.kernel.org>; Fri, 24 May 2024 17:08:21 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20230601 header.b=txWcMh2N;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=google.com (client-ip=2a00:1450:4864:20::133; helo=mail-lf1-x133.google.com; envelope-from=dhavale@google.com; receiver=lists.ozlabs.org)
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Vlx2j293pz87Dw
	for <linux-erofs@lists.ozlabs.org>; Fri, 24 May 2024 17:08:12 +1000 (AEST)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-52232d0e5ceso8828956e87.0
        for <linux-erofs@lists.ozlabs.org>; Fri, 24 May 2024 00:08:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716534480; x=1717139280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p7x1twet5RPnivrXniE5a/6hYyvmJ0b1bq8goFKQemU=;
        b=xQE59snqrRGRRqQiH+gc41nt9j4ywC6nhgb3Nknd0UYYAmDpn6uCGh92aEWjrE7/Fe
         KNBno4gkptVjqCe7jpSuMBQXhSof/BPvRppXnmg7jPh9Yu+NT7nwR6VZSxmEIcwnwOZZ
         KbwtQOb7pKDroKCNCAyVQleqIM3RtTFa9pa/4L5PyQH32JmnfqKkrdUNCnzTlmIo4yX8
         9Caz9XSCwyR5r93vNrI5oFXbGSGy/e1Xi5P6EQ9VRW9fllE3sJceCnrUNwSW+ltOCxPw
         6r6sofDwItDEyJEP87iDJBCwfPrlazTqAYNjbdvGkytgbgnXJ3S8ijCIBZIyAsmOegLi
         sBow==
X-Gm-Message-State: AOJu0YwArwXOTf2XQBnSLcqbLmJ7n8cgy7ip+Acgl4iB2A9gAp0NYtUD
	i3pG+0o+zKi2EJZDOYFNBGsluRyaBuDje7RHinaAmRJUIAXEaHzwB01QfSSjyQZKzSwZme3j58d
	ESfRtB8oq1NOMwjXU+4oPnRfEP2Z9hpQu0WqA
X-Google-Smtp-Source: AGHT+IGgxpwpciRqgAYYVzrzaVeax/ORWCWE519HSaqzXzxe94xNTRNDSlz7KGBDkN7JYScg8ZlH+bD5t2fM9MdwXvU=
X-Received: by 2002:a05:6512:1309:b0:523:90df:a9c6 with SMTP id
 2adb3069b0e04-529661f2e0emr707082e87.50.1716534480021; Fri, 24 May 2024
 00:08:00 -0700 (PDT)
MIME-Version: 1.0
References: <20240523210131.3126753-1-dhavale@google.com> <20240523210131.3126753-3-dhavale@google.com>
 <9c08c099-6fb2-4032-b8f6-1d6008e1375a@linux.alibaba.com>
In-Reply-To: <9c08c099-6fb2-4032-b8f6-1d6008e1375a@linux.alibaba.com>
Date: Fri, 24 May 2024 00:07:48 -0700
Message-ID: <CAB=BE-S78NcJ_YfWNBPXQkeWXd4RUdx6K29FABc6QjOCcb97Mw@mail.gmail.com>
Subject: Re: [PATCH 2/2] erofs-utils: lib: improve freeing hashmap in erofs_blob_exit()
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
Cc: kernel-team@android.com, linux-erofs@lists.ozlabs.org, junbeom.yeom@samsung.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Thu, May 23, 2024 at 10:28=E2=80=AFPM Gao Xiang <hsiangkao@linux.alibaba=
.com> wrote:
>
> Hi Sandeep,
>
Hi Gao,
> On 2024/5/24 05:01, Sandeep Dhavale wrote:
> > Depending on size of the filesystem being built there can be huge numbe=
r
> > of elements in the hashmap. Currently we call hashmap_iter_first() in
> > while loop to iterate and free the elements. However technically
> > correct, this is inefficient in 2 aspects.
> >
> > - As we are iterating the elements for removal, we do not need overhead=
 of
> > rehashing.
> > - Second part which contributes hugely to the performance is using
> > hashmap_iter_first() as it starts scanning from index 0 throwing away
> > the previous successful scan. For sparsely populated hashmap this becom=
es
> > O(n^2) in worst case.
> >
> > Lets fix this by disabling hashmap shrink which avoids rehashing
> > and use hashmap_iter_next() which is now guaranteed to iterate over
> > all the elements while removing while avoiding the performance pitfalls
> > of using hashmap_iter_first().
> >
> > Test with random data shows performance improvement as:
> >
> > fs_size  Before   After
> > 1G     23s      7s
> > 2G     81s      15s
> > 4G     272s     31s
> > 8G     1252s    61s
>
> Sigh.. BTW, in the long term, I guess we might need to
> find a better hashmap implementation (with MIT or BSD
> license) instead of this one.
>
Ok, sounds good. I have not seen any more problems (yet). But will be
good to see if something better is available.
> >
> > Signed-off-by: Sandeep Dhavale <dhavale@google.com>> ---
> >   lib/blobchunk.c | 8 +++++++-
> >   1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/lib/blobchunk.c b/lib/blobchunk.c
> > index 645bcc1..8082aa4 100644
> > --- a/lib/blobchunk.c
> > +++ b/lib/blobchunk.c
> > @@ -548,11 +548,17 @@ void erofs_blob_exit(void)
> >       if (blobfile)
> >               fclose(blobfile);
> >
> > -     while ((e =3D hashmap_iter_first(&blob_hashmap, &iter))) {
> > +     /* Disable hashmap shrink, effectively disabling rehash.
> > +      * This way we can iterate over entire hashmap efficiently
> > +      * and safely by using hashmap_iter_next() */
>
> I will fix up the comment style manually, otherwise it
> looks good to me...
>
Ok, thanks!

> Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
>
> Thanks,
> Gao Xiang
