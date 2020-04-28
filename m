Return-Path: <SRS0=1VuQ=6M=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.7 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B68D4C83004
	for <linux-erofs@archiver.kernel.org>; Tue, 28 Apr 2020 07:21:13 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5D77E20774
	for <linux-erofs@archiver.kernel.org>; Tue, 28 Apr 2020 07:21:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XJ71UfYO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D77E20774
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 49BCjz4ph4zDqwb
	for <linux-erofs@archiver.kernel.org>; Tue, 28 Apr 2020 17:21:11 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::342;
 helo=mail-ot1-x342.google.com; envelope-from=waterbird0806@gmail.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256
 header.s=20161025 header.b=XJ71UfYO; dkim-atps=neutral
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 49BCjs3RdDzDqsX
 for <linux-erofs@lists.ozlabs.org>; Tue, 28 Apr 2020 17:21:01 +1000 (AEST)
Received: by mail-ot1-x342.google.com with SMTP id i27so30942547ota.7
 for <linux-erofs@lists.ozlabs.org>; Tue, 28 Apr 2020 00:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:from:date:message-id:subject:to:cc;
 bh=7daqCy4hLnuNyTT0nQH81My9rSNrPu35cjRqOAeQC2k=;
 b=XJ71UfYO5BnXf/HesbmIS1U/N80D5XdDFDcaCnRm5SHMt1eiEp5ne9K52jVcoe+OF0
 NH/q8alYNBA9PMisnDMYAnI332wZukuCKh1nikbeEwiw36M5a+a8jLMNI+L4BDAV6eqq
 cKXGrtvCA0ciSbvlWYvk+u1JC+e2L4ZkFx1qdYH41p0DPtFf2qsa0zSkttZKtzlk7K/c
 UE9WqJnD/3nMn0l/qLyYZp9Xfxc+b8AgiBw9w3OImGw5IG7aj6df49mlcf6sTPpyxEZg
 hH6zsyfJowGnc23FRdzq4wUy71Rfs7V/0bLVYBDKHTmyz6adACeXyY5Va5L/3O3Bu86B
 emHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
 bh=7daqCy4hLnuNyTT0nQH81My9rSNrPu35cjRqOAeQC2k=;
 b=Ssdzj4f+Nmp+e0TXOm1WTiS+JzyN8mU9rvHWzcSHYxSz94FQbpbVDkV7XF7zluZgx/
 h5LsrPa/EEk4+p+sAVcuXiV72kS51Loh2jThTjc06t6iHw+CB962QcGK5mg4WrLmZuhE
 H7vwMOf2uZm7sYut+NLzKb8MDIlOV3dI4VW05Yrdw3xngSNVTk03SZNDFohp5I8Nm9M+
 NS7s/qZATQpNm0BEkj8oED30skrt2a0bxicboKsbganpEgjFLaKbKf1pu45vRsOiv72e
 Esl33X044Hb65BOf6LBFxDWFOnDZp3tHM/3VDQjade/H8dFdRhRavFSahJ2y1xpD1YuI
 7v7Q==
X-Gm-Message-State: AGi0Pubv5DKM7uiQ6EZvgU9W9YYKCNy/ytu/srwRjr6JnMeOFMxlkXlf
 dpuuhj/Ob16mmK5b06rLEDJrZB0GmzlyeHarbPkVOyzmY8q5q1KK
X-Google-Smtp-Source: APiQypKt6RPkRDZxdCHApyU7na5xzIfRPpV3OEjMdaVHVYGvEbPXFzrFZPrPmdNc0rdH7iNKHEbVUXdicIa0ZHOKaiQ=
X-Received: by 2002:a9d:7645:: with SMTP id o5mr19057356otl.272.1588058458203; 
 Tue, 28 Apr 2020 00:20:58 -0700 (PDT)
MIME-Version: 1.0
From: Shung Wang <waterbird0806@gmail.com>
Date: Tue, 28 Apr 2020 15:20:45 +0800
Message-ID: <CAKkk4bLEWNpY+AZ0-mQ9eU9gjwWD8nhi3kCsf01Nh7hZWRsPQA@mail.gmail.com>
Subject: [mkfs.erofs]Do you have plan to support selinux file_context
To: linux-erofs@lists.ozlabs.org, miaoxie@huawei.com, fangwei1@huawei.com
Content-Type: multipart/alternative; boundary="00000000000048aa6905a454ac69"
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
Cc: gaoxiang25@huawei.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

--00000000000048aa6905a454ac69
Content-Type: text/plain; charset="UTF-8"

Dear developers,
Current mkfs.erofs doesn't support read sepolicy from file_context .
Do you have plan to support that?

thanks
best regards,
Xiong

--00000000000048aa6905a454ac69
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Dear developers,<div>Current mkfs.erofs doesn&#39;t suppor=
t=C2=A0read sepolicy from file_context .</div><div>Do you have plan to supp=
ort that?</div><div><br></div><div>thanks</div><div>best regards,</div><div=
>Xiong</div><div><br><div><div><br></div></div></div></div>

--00000000000048aa6905a454ac69--
