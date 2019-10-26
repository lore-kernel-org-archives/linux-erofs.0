Return-Path: <SRS0=J9b1=YT=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E21CA9EB9
	for <linux-erofs@archiver.kernel.org>; Sat, 26 Oct 2019 07:26:38 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D1F0921D81
	for <linux-erofs@archiver.kernel.org>; Sat, 26 Oct 2019 07:26:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SV/1baOb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D1F0921D81
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 470Xbb2XRwzDqsh
	for <linux-erofs@archiver.kernel.org>; Sat, 26 Oct 2019 18:26:35 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::531;
 helo=mail-ed1-x531.google.com; envelope-from=pratikshinde320@gmail.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=gmail.com header.i=@gmail.com header.b="SV/1baOb"; 
 dkim-atps=neutral
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com
 [IPv6:2a00:1450:4864:20::531])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 470XbS65wPzDqgW
 for <linux-erofs@lists.ozlabs.org>; Sat, 26 Oct 2019 18:26:26 +1100 (AEDT)
Received: by mail-ed1-x531.google.com with SMTP id s20so3625317edq.9
 for <linux-erofs@lists.ozlabs.org>; Sat, 26 Oct 2019 00:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:from:date:message-id:subject:to:cc;
 bh=npGq+rFcJLVDJJlWSQ4o7Ba3eO1X32bje8s16xjMaiU=;
 b=SV/1baObgLNlN2VnkyIYMpVHyvtpxBymlYePfeHxskVNfmefzo6eAcqDS+rSxC6eMV
 RObNaDcTBvdc5p6MoJSn/WENW1H3mcPznDt9/QVK+f94i3ZsVjJ1kQQYFwnt0uVULXCt
 BWVCKFBKyvetlWEsn8a2NpikybQ6/UaH+xhiX3CGHxhuSw1Jpw/tZX1RWrt+G6fiJLhb
 h1UQiogu7menbq2k6+N1mPtdqnRT9Dj81tbn2RlAaDD3xb+pXlNZxjHa9cZZt+kuysSH
 csQPApFEmQPcZdV8dmmlAtOnuumUMNscMsEK6R6fCWLydloHPvyzGYlr1ZzeJixjlYSp
 s3bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
 bh=npGq+rFcJLVDJJlWSQ4o7Ba3eO1X32bje8s16xjMaiU=;
 b=kDn/UnxxJ4h93bhBglac3KCp6cixE8IK2sMvDRacFUVqVuo4eHRMSQWA1FUPCKo1AD
 so4q55LUjBFRHXluzd+bM6Hpa56v8Meif1mEkq9nWcpFWdHT+chV0G/rtdwHJUiIdQs2
 AmAQkIHuXrdTvUUM59OqXlB5UBAB+y0MS3wBelNyo6Do4ECy2t5bu8VtejmwUabsw7TA
 mjAzCGQo1YrLxwAnxiErM4d3PtOxGbkwzU++Me+F1CsVzlHxvrE71h0w4vQXIL0BsKzH
 wr4ACHph4DSn321fdJU7H7r4g7jMtThawXDhyZ4c909XvuEFNqoV2W7p9ZQ8OhC1TR3P
 7fIQ==
X-Gm-Message-State: APjAAAW36kxvFQ4z+5TvRB+6TjcYtd2+nyntvjT1mA3lrrQt66wrDTbJ
 bhCz+qfEBzxthAH6uXENWoEzTQ0TRIZd50+0QbQ=
X-Google-Smtp-Source: APXvYqyz9jhMsRDahUyoXNdlmtUKuKjOaUj+3dPQ15CK+W2slg8J6vFXsb1shfRXFQECT3IQ5RBCGhzkd6/TUI/NS90=
X-Received: by 2002:a17:906:d72:: with SMTP id
 s18mr7194705ejh.29.1572074782184; 
 Sat, 26 Oct 2019 00:26:22 -0700 (PDT)
MIME-Version: 1.0
From: Pratik Shinde <pratikshinde320@gmail.com>
Date: Sat, 26 Oct 2019 12:56:10 +0530
Message-ID: <CAGu0czSVS4exiJJPg9SL8MpjwQahPRRuTt5Ho5s8Lcc6BK2D7w@mail.gmail.com>
Subject: New things in erofs
To: Gao Xiang <gaoxiang25@huawei.com>
Content-Type: multipart/alternative; boundary="000000000000f3d95e0595cb2ed1"
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
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

--000000000000f3d95e0595cb2ed1
Content-Type: text/plain; charset="UTF-8"

Hi Gao,

Are there any new features/enhancements coming in erofs. Something that we
can contribute to?

P. S. - I saw your erofs roadmap pdf on github.

--Pratik

--000000000000f3d95e0595cb2ed1
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Hi Gao,<div dir=3D"auto"><br></div><div dir=3D"auto">Are =
there any new features/enhancements coming in erofs. Something that we can =
contribute to?</div><div dir=3D"auto"><br></div><div dir=3D"auto">P. S. - I=
 saw your erofs roadmap pdf on github.</div><div dir=3D"auto"><br></div><di=
v dir=3D"auto">--Pratik</div></div>

--000000000000f3d95e0595cb2ed1--
