Return-Path: <SRS0=erY1=ZM=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 348B6C432C0
	for <linux-erofs@archiver.kernel.org>; Wed, 20 Nov 2019 16:52:43 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D77EE2071F
	for <linux-erofs@archiver.kernel.org>; Wed, 20 Nov 2019 16:52:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o0KmJsLD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D77EE2071F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from lists.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 47J7zF0HLFzDqtn
	for <linux-erofs@archiver.kernel.org>; Thu, 21 Nov 2019 03:52:41 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::f2e;
 helo=mail-qv1-xf2e.google.com; envelope-from=vmtran@gmail.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=gmail.com header.i=@gmail.com header.b="o0KmJsLD"; 
 dkim-atps=neutral
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com
 [IPv6:2607:f8b0:4864:20::f2e])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 47J7yy0DG0zDqqD
 for <linux-erofs@lists.ozlabs.org>; Thu, 21 Nov 2019 03:52:19 +1100 (AEDT)
Received: by mail-qv1-xf2e.google.com with SMTP id y18so187024qve.2
 for <linux-erofs@lists.ozlabs.org>; Wed, 20 Nov 2019 08:52:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:from:date:message-id:subject:to;
 bh=rwjMhwh2RV1CJWmg0aX9BTHuKwko/WirVFcQBj0z08s=;
 b=o0KmJsLDT2kEvygS6C/zh5R9Hzh5rJg3keCqsMDkDAECkiNoulTpQWQ1juXZwwk91/
 i324bOt5fAgjjqtRWrCMQQtEFUQCsD5CORQ1WxKZeinXaMx1fXCz4t2eE9gQpZA1dxw2
 PSExhUU/2cEQsL+6Fweqlt01N0JWNMkp8O0l8QnqK1/lOdXmQqT2QbiPgb0BpgMwAdeH
 5F9KcQl9yNb9D7uDMUfA4vwFG6wuNrzndXanAfQ2mc8owZOyWMA7muqofDcc7riqwF2h
 TOw/GNPkx3hVZDaDY9d+TVfSZ4hPo/RJM9yALm0+u6nifEg3jcodEQtYZ+Rubbwdxodq
 mz8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
 bh=rwjMhwh2RV1CJWmg0aX9BTHuKwko/WirVFcQBj0z08s=;
 b=JdQBIX5mOn+MTAJAE/dJV1zzn4vz9rO2j37H8iMsylDeU3jLZ0/MUmojPpufAh3c9A
 3A8MVjUEZ0q8sBP8q4d7xdXk2uEyjxtQ/Ag3C/nMi2HE+u86oWXKyN3AvczzN9WTGsEI
 8tVn2XX6Hb9rWuCA52pEM8B0MS95D+h5Q+lyuHtUjrn4BIT0SuAc9U1FRD65YJc8mY1L
 mce+gf/rAn1pC2/QQO/V8U3hJPY2NjTlwxPjM4i1ot5f0M42dhdkt2rLpvyjaQcvGDv/
 8rzH0bRRu1J8CWlBF48woiQ+3xEaDGSBCg/lgxUwAvpOdCSeFAUS6NQtAOeBrlwz+iOw
 NQvQ==
X-Gm-Message-State: APjAAAXvG/xGxZHWvkl6RIavcFlOV1vgOYeh/FMQTZD/UyTp8SRz6nwz
 Nok0JpvImZYBU3MACGyB6B3sKuv+Ude0sJ0ckg2VekU7
X-Google-Smtp-Source: APXvYqyeRjb+yrIHuS4XPBxl2zisDUFMsxj4pVm/UnWCNr4DUbvQf6ur2Y2ob2to3JcDBu+/4lZKpDYwegiUebUDGoU=
X-Received: by 2002:a05:6214:14b2:: with SMTP id
 bo18mr3552717qvb.72.1574268735519; 
 Wed, 20 Nov 2019 08:52:15 -0800 (PST)
MIME-Version: 1.0
From: Vu Tran <vmtran@gmail.com>
Date: Wed, 20 Nov 2019 11:52:04 -0500
Message-ID: <CAHfisdKeLY8o=b8aAWhKgf9NndaMjBUmfro_D_jhXaGmXQ_6GA@mail.gmail.com>
Subject: EROFS to support XZ compressed file
To: linux-erofs@lists.ozlabs.org
Content-Type: multipart/alternative; boundary="000000000000c2fd620597ca0014"
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

--000000000000c2fd620597ca0014
Content-Type: text/plain; charset="UTF-8"

Hi,

In my understanding, the work for having EROFS to support XZ (in both
kernel and userspace utils) is actively developing.  Is it possible to know
the timeline for when the feature will be available for end users to try
out?

Thank you very much and Best Regards,
Vu Tran

--000000000000c2fd620597ca0014
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>In my understanding, the work for h=
aving EROFS to support XZ (in both kernel and userspace utils) is actively =
developing.=C2=A0 Is it possible to know the timeline for when the feature =
will be available for end users to try out?</div><div><br></div><div>Thank =
you very much and Best Regards,</div><div>Vu Tran</div></div>

--000000000000c2fd620597ca0014--
