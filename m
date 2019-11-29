Return-Path: <SRS0=V3BH=ZV=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED258C432C3
	for <linux-erofs@archiver.kernel.org>; Fri, 29 Nov 2019 20:22:44 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8F8B121721
	for <linux-erofs@archiver.kernel.org>; Fri, 29 Nov 2019 20:22:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E8gwu6NP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F8B121721
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from lists.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 47PmCQ3XXbzDrH6
	for <linux-erofs@archiver.kernel.org>; Sat, 30 Nov 2019 07:22:42 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::435;
 helo=mail-wr1-x435.google.com; envelope-from=fedora.dm0@gmail.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=gmail.com header.i=@gmail.com header.b="E8gwu6NP"; 
 dkim-atps=neutral
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com
 [IPv6:2a00:1450:4864:20::435])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 47PmCK4Q4SzDr3h
 for <linux-erofs@lists.ozlabs.org>; Sat, 30 Nov 2019 07:22:33 +1100 (AEDT)
Received: by mail-wr1-x435.google.com with SMTP id c14so11980795wrn.7
 for <linux-erofs@lists.ozlabs.org>; Fri, 29 Nov 2019 12:22:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:from:date:message-id:subject:to;
 bh=XvG6ZbXzmAcc5v4vD2yyLi9mBlhe0pjhbt9CQkgsIMg=;
 b=E8gwu6NPV8X7yZC+pdOq5N4ELqAHlb8j9N28N8t+QbV1cYkNmFnRLPFAOaQH6HOQD1
 gO28bYGfo+hBJpS1NnklZ9f8ltgFG1pR/B4aEJw+PKvP3U/eRKdB1sAKqiDxtO/M1gjb
 aAJco8s2o9Gwn/roS9iqJHIRMbNP59GHZQlZI+YiM9a64KPX7VsoNJUUeyZtEM2YUhNl
 neRkjLiDjNHOJmbZl13TGckKPyG5FkhXfkFSX3tbsDY4ivZ30Pe6wRf4yFdItQlUcTDL
 HfrNcGJQ+ZqA0fgmG+H4E2e85OhBf2NsWjSOGe0cGjINDCbx+DqjrJvgsU44Cv6G7pY8
 YOlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
 bh=XvG6ZbXzmAcc5v4vD2yyLi9mBlhe0pjhbt9CQkgsIMg=;
 b=sJklyOn/gzJCTQQU0gDrP48fpDIWsKdk3r82MrFP/6M25l75jxmyiFlwY1WGeu3A4V
 XeIElnMFS5ZCjAgIkAJaWK1Yr/j7/xDHxUH1fgpfn1TTNR9voMsKS8MN7uTiVB7ARMK7
 UgKVzv/71iJx4iDzmwYuLW5jUNMZr1888nuhPiV84MwT+smAouFzOlNqJq8AgrLBnqlG
 toilh58RTZXu+FW4nC2nN1OGLCXpE0xMk8l0k7zkzajvAc65x1dpOE8JTNGcRVlZa0mQ
 lL8qxiTY2apazubeiNFkZs/30NMgb5YICjzMqVGU9CoG+SDU1wGpSV7dPPPP6U23HSJz
 CPVQ==
X-Gm-Message-State: APjAAAX+xJJxvPr2pr/X+tcn8TrT4XL0elRC6Unha0Qb5K6hhBwZkUuD
 vOlSRRy1wo5E9JvEduCMe/1aLnOyomFQxPtpKtWIFKAd
X-Google-Smtp-Source: APXvYqwP7HxAB4VR4RmyODfsOwEja4PAudG+a3B7S3AmYzZdeEcG85fbVU1gRqmULE3DAh7hKQmpFtLStv4zZ96TvBo=
X-Received: by 2002:a05:6000:1612:: with SMTP id
 u18mr32190957wrb.306.1575058946482; 
 Fri, 29 Nov 2019 12:22:26 -0800 (PST)
MIME-Version: 1.0
From: David Michael <fedora.dm0@gmail.com>
Date: Fri, 29 Nov 2019 15:22:15 -0500
Message-ID: <CAEvUa7nxnby+rxK-KRMA46=exeOMApkDMAV08AjMkkPnTPV4CQ@mail.gmail.com>
Subject: Compatibility with overlayfs
To: linux-erofs@lists.ozlabs.org
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi,

I tried to test EROFS on Linux 5.4 as the root file system and mounted
a writable overlay (with upper layer on tmpfs) over /etc, but I get
ENODATA errors when attempting to modify files.  For example, adding a
user results in "Failed to take /etc/passwd lock: No data available".
Files can be modified after unlinking and restoring them so they're
created on the upper layer.  This is not necessary with other
read-only file systems (at least squashfs or ext4 with the read-only
feature).  I tried while forcing compact and extended inodes.

Is EROFS intended to be usable as a lower layer with overlayfs?

Thanks.

David
