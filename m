Return-Path: <linux-erofs+bounces-3989-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5423DC531CD
	for <linux-erofs@archiver.kernel.org>; Thu, 23 Jul 2026 09:01:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h5Q8T1qP9z2xyj;
	Thu, 23 Jul 2026 19:01:13 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::332"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784797273;
	cv=none; b=MCUnwWQgL4Rb0X2yKNYJ1FtRVvxe415+milE7hrxJ4dtQF+phPREh3ovylCkgFZWVfD6xQmIDegSICnpwtQrljkrWG7LeJS1Ov9r7Zg97brnhnKgeMwZbUll2rgeKbF7SSTxdUkuOdN6ahyCFnmDeq1EAc7wnCZrNn+70FL+/oZYb6I/bazPU/fV4yAoix1SJlghzeCimwKtE7jboDcTVXU9l2Wek8CNvbOdZW24h97bc2clwMEVc6GN351LqO4aIlomq8FgGlM6O4E0FKISheg+8ZPL4kTzp8SAWIfyVHknqZ+6cbhffhZYj8ZQrna5CCt+Kl9WjhWnGmZlCN71Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784797273; c=relaxed/relaxed;
	bh=/tPr3qdcawiWwA2VysdP5ZIB8M9hpvOF1iQApSBfOK4=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=h9IeIzXs+2s0Gl/MjBHtfLdfRdxr/CrmiTaQpCUUvPqh/vVY3Ev0PAaPKeM5LgoUfA7p247QOp62zPCIDNzgTLMxuL8acqAeKR2rR6OXVk13i18hS6igrbTa36EJjA4FQmR8+MQOFeD7b6djtR7byYdOotwUbmckJLmpjgFEL18au9A9++e/AS5b75IaV4H2+HLU4kK2ejhbn2mQ8HbF+QJ6cus8vH+QMMz7zok0WO5nsS42dG70ar8bKQlQju+JW0OFG9V+GId6OIkq/hHmn6f4iTERsBvPrhoW3NplDzxdpUEgeO0DVkeLqQwuI9xd2Dc9xpgx2iTMR6W2NrukUw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amacapital.net; dkim=pass (2048-bit key; unprotected) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=qbPrMqFk; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::332; helo=mail-ot1-x332.google.com; envelope-from=luto@amacapital.net; receiver=lists.ozlabs.org) smtp.mailfrom=amacapital.net
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=qbPrMqFk;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amacapital.net (client-ip=2607:f8b0:4864:20::332; helo=mail-ot1-x332.google.com; envelope-from=luto@amacapital.net; receiver=lists.ozlabs.org)
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h5Q8R1pVdz2xs1
	for <linux-erofs@lists.ozlabs.org>; Thu, 23 Jul 2026 19:01:10 +1000 (AEST)
Received: by mail-ot1-x332.google.com with SMTP id 46e09a7af769-7e6128bd9b3so175004a34.1
        for <linux-erofs@lists.ozlabs.org>; Thu, 23 Jul 2026 02:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1784797267; x=1785402067; darn=lists.ozlabs.org;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:content-type:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/tPr3qdcawiWwA2VysdP5ZIB8M9hpvOF1iQApSBfOK4=;
        b=qbPrMqFkhOCMGF4SKDXnDZPtg2JIRrdjoWP5cM+ZtJfr7Xi6tbGVwPU0/lRY8qXoSg
         xTAnNUcm3Fv4UN+AFU8/1mprsAxRsJX4Kb4gs4Akht7GmMWhHoyWDOrV8GB7oPsuWJwn
         BZjsxLr9VQu1Pcj8x6ldqW/fOyCDgYopfyr+wXg8OOeT2oxV2RoUfFEIW/ljCOboxZrW
         vIAXmmeQ3XaWCymRu3RqBQWUbC7zNCEeXqk6SvamPuL9ihGoEoM8qj4BLh7/GW0b4bAr
         myF+FJIdJkC428k6U7mqiFMmrbJrwR0d7TidomyAQTgUPlgEA6wC/TVNvLN5taBQulLW
         rQdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784797267; x=1785402067;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/tPr3qdcawiWwA2VysdP5ZIB8M9hpvOF1iQApSBfOK4=;
        b=dCZaS5G7bemXpjz8JYBVnul0wZlMqVHpNveS62qzZtgMvsB+TDoucQoWDk2FozrE4x
         6C5CwQJZA8Kt8s5RneCFVHOOzxn4Tn/tA2T6m7f78BBx7uN15Afj987M8DsByslCKHTY
         CVPFC65br+Hp1OAqjEZuxMmCv190qe/LgwNu0KuMVq9d8Xs1VXqnMTXpjrxXi4JlFk7P
         UMWEADExuwuc2IRfwMOhCzivqRVDuzl3LrUYspGrytl0HQp+YTLoRygHN4bRxrLjCkHU
         A+73eMr06jY7E04Bljh3IQZD17BBhm/DcZB1d2JRhkoqBNm0oOnHOSoCUnZNPAxrx26w
         XnKA==
X-Forwarded-Encrypted: i=1; AHgh+Rqktact+qLAVSrJz26Z3kqTF7z5SNVG2Ns8M85Txm7V5QlPnE+Y5dHBdvvHijlIi3Ub0wsfRGSM3jcCwg==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YwpXPXlbCpYwZircMPK7LVRo8hMrg5tTVRlndt5iyQNkp9Nz4Gv
	gXNwoHuPW2vCI0/uNpSNGxV3PKyPFO+T2idQVoGuVI+UYVnZrxm+E2thesjYjBsj/w==
X-Gm-Gg: AR+sD13juTZB3U45bhqkFFKeumX+SUlr5C6YBTFXv3y6kJVe5GcP0Soes1i/0v0SVzK
	o9DituVDZ+T1d21W6FcMcNGZ3pwLzyhlsEvzGXy/Bsmw/a5DVM/B++MoMFTRL9K7IaFIMN87Uyi
	czu+wjuYUXYYr4fuYfvv46AmEzX+K4SMlQi3e/ENu/c+NnnsNZWtQv5NQlDTYh2gknhhGZbQ5nm
	/IZWAYSvaeBcy++sDZkHROP4Byfpug3P9IgSyizd3IGoq9YwnsVVmLLnZc1Fr49K9k4495H39+/
	/0SLWg043a2nI6WAoq5A48txKFEWYLVXdFUNWEJVr6RHunh16zcOeN+irXmSbKcY72VH4MG3Q/8
	9D6iIqNtYG77BTzOx861ImnoCbFqDyyMUS15u1HC+T8mPSBTGV2Pn5DQTQT93d8cd4SMIBM3Mq+
	e88QDdK/s3UFcdSRd08Tf3O9+mCDyZMsI=
X-Received: by 2002:a05:6830:3692:b0:7e7:5e4:ee11 with SMTP id 46e09a7af769-7ee4417fc9fmr1388710a34.16.1784797267490;
        Thu, 23 Jul 2026 02:01:07 -0700 (PDT)
Received: from smtpclient.apple ([172.58.164.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ee2a03c856sm3082411a34.13.2026.07.23.02.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 02:01:06 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Andy Lutomirski <luto@amacapital.net>
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
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
Date: Thu, 23 Jul 2026 11:00:53 +0200
Message-Id: <6C96C8A7-345E-4388-8EDC-D94E9463D214@amacapital.net>
References: <CAJfpegupwNTaVNZtdQTmvtz9x=ehH59hzsRT7D0=VbhOZvaqrQ@mail.gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
 Miklos Szeredi <mszeredi@redhat.com>,
 Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>,
 Xiang Gao <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAJfpegupwNTaVNZtdQTmvtz9x=ehH59hzsRT7D0=VbhOZvaqrQ@mail.gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
X-Mailer: iPhone Mail (23F77)



> On Jul 23, 2026, at 10:22=E2=80=AFAM, Miklos Szeredi <miklos@szeredi.hu> w=
rote:
>=20
> =EF=BB=BFOn Wed, 22 Jul 2026 at 18:36, Andy Lutomirski <luto@amacapital.ne=
t> wrote:
>=20
>> Other than that question, I think I generally agree with you.  The
>> interesting operations here (getting an fd to something that was
>> previously inaccessible) are different enough from normal path lookups
>> that I think they deserve to be explicit syscalls or syscall modes,
>> not magic links.
>=20
> This is a super specialized use case.
>=20
> I sort of agree that doing statmount() as a syscall was not a bad
> idea.   But new syscall for getting a backing layer, that makes sense
> on just a couple of filesystems?
>=20
> And that leaves us with ioctl.   And ioclt() returning an open fd has
> it's own problems, besides ioctl being a generally bad interface.
>=20
> And we have all these powerful concepts and interfaces for
> filesystems, why the big resistance to actually using them?.
>=20
> Sure, it's easy to misuse, but I don't yet see why this particular
> case would be a misuse.  Enlighten me please.
>=20

I think there are are a couple of complications involved with open, openat, e=
tc that aren=E2=80=99t present with explicit for-the-purpose syscalls:

- O_XYZ flags to open() are all kinds of awful, for historical reasons that a=
re not fundamental to the concept.

- symlinks. If we have a new API where opening /proc/something/magic/blah ca=
n access something that ought to be inaccessible when accessed intentionally=
 and with privilege, a symlink pointing at /proc/something/=E2=80=A6 can cau=
se the API to be used inadvertently.  Admittedly we have this problem with b=
asically all symlinks, so this isn=E2=80=99t exactly unique.

- our nasty fs permission model. We gave a sort of gnarly mix of a bit of fd=
-based permission and mostly mode/ACL-based permissions for path traversal a=
nd opening, and mapping this nicely only new APIs (as opposed to actual file=
s and directories) can have unpleasant results.

Of course, I=E2=80=99m busy arguing (slowly and without a concrete proposal)=
 that we should have proper capability-like fds, and maybe that=E2=80=99s ki=
nd of an answer to this:

What if we had an API to get an fd to the =E2=80=9Ccontrol filesystem=E2=80=9D=
 for a superblock, like your O_ALT but as a real syscall or maybe only acces=
sible via one of the newer and less janky open variants?  And what if the re=
sulting fd and the filesystem tree it represented had a few properties that m=
ade it very different from normal directory fds:

- You cannot mount anything on it or its subdirectories, nor can you open_tr=
ee or otherwise mount it anywhere.  But you can open_tree the very specific t=
hings in it that point outside of the special API (e.g. the overlayfs layers=
).

- Privilege is fully captured by the original call that gets you the fd.  cu=
rrent->cred is not checked when *using* it except to the extent that you mig=
ht need privileges over your own namespaces to do operations that might affe=
ct them.

- You can=E2=80=99t fchdir or (hypothetically) fchroot into it.  (Not sure h=
ow important this is.)

- Maybe you can=E2=80=99t follow /proc/pid/fd/N links into it either?  Or ma=
ybe that would break CRIU too badly.

The basic idea here is to try to treat it like an API that happens to use th=
e open machinery but not as part of the filesystem hierarchy.

One could go even farther and try to remove a bunch of the parts that make i=
mplementing it tedious.  For example, if this hierarchy had =E2=80=9C/layers=
/1/options=E2=80=9D, there is really no reason to over open an fd to layers o=
r layers/1, and if we had a readfile syscall there wouldn=E2=80=99t be a rea=
son to open an fd to options either.  But maybe this is a silly direction to=
 move in.

> Thanks,
> Miklos

