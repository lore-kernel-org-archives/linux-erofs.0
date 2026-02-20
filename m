Return-Path: <linux-erofs+bounces-2339-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD9B8C5AD55
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Feb 2026 18:34:42 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fHf6n0j3fz30Lw;
	Sat, 21 Feb 2026 05:34:41 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip=85.215.255.23 arc.chain=strato.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1771612481;
	cv=pass; b=m2AdiLc2uK2ZGxU5fpGXo0Gt7XkYgJ5eKDuzj/IDIQDJU0yQRRYhFmH8pDBIUeEkpNppigXlszqd+mYDIKiJm3XsIInyxROdSozXo2j3N11QmhxM67kU0Tik72RmFYIDu3GuLx+Z7ALoG6RrpOy7HPXrZcRZtV7MEzeiPdrOmnWGpibx2LWjkRDa5ag3TsyhPmGTmZiZK4X6xrDa98yk80AF0l96P50V/WyVqYwpdbdoBrNt4IWTJeOzICpb9XIgy9QUNLC5Z6FMpcFOqWhmwes1OXCRrjSk4Dum8NVldfHBm3wIygyQm2lf2yCZRoGLfpWe77S4mbGI8mLDBnQLrQ==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1771612481; c=relaxed/relaxed;
	bh=myVE31X4UclVEY0AKZPM4ycFun98tc+DFGsmLujAb20=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KcvVYi6+uXGTrPcZ4g7TlpPehlBNjhBxludr37kMYxyxEXhNKUTbknV9oNpTnpa9tEtVPGNEP7H5n38Cx86/ZcMXMnkCvwmMai9pQbzAwOfQ7qz9YuRPC6uP+E05naFBiYwblVjol8QoNiiK8vYmE+bk6Q9kiXZqOqP0aZ1WWaQ9B/5nVYsEhpdbGr1LBrmjanUSltzh6pf6WBpKRwe5M0efl+gJ4OFro37vzm2HXz9yzrBAfDj0yjH1dTPFzEBm2eE1z0b4HzbGv5am4pnRlzTXQi83Hngj+bbAyiILueVo5MJ/ECV7mmHaoNHfyu+XOnzwdUowPO9fJuyNekhZ8Q==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=duncano.de; dkim=pass (2048-bit key; unprotected) header.d=duncano.de header.i=@duncano.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=J8Wt8Li2; dkim=pass header.d=duncano.de header.i=@duncano.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=Y13Ym1kx; dkim-atps=neutral; spf=pass (client-ip=85.215.255.23; helo=mo4-p00-ob.smtp.rzone.de; envelope-from=mail@duncano.de; receiver=lists.ozlabs.org) smtp.mailfrom=duncano.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=duncano.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=duncano.de header.i=@duncano.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=J8Wt8Li2;
	dkim=pass header.d=duncano.de header.i=@duncano.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=Y13Ym1kx;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=duncano.de (client-ip=85.215.255.23; helo=mo4-p00-ob.smtp.rzone.de; envelope-from=mail@duncano.de; receiver=lists.ozlabs.org)
X-Greylist: delayed 182 seconds by postgrey-1.37 at boromir; Sat, 21 Feb 2026 05:34:37 AEDT
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.23])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fHf6j3Jhlz30Lv
	for <linux-erofs@lists.ozlabs.org>; Sat, 21 Feb 2026 05:34:36 +1100 (AEDT)
ARC-Seal: i=1; a=rsa-sha256; t=1771612288; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=sP4yUGo9n9LXI1rmix+7GjBnWejFrFxUt6BFR/skf90OBuaWWF48L/VukwlCBRsA2q
    t5df6NPqkstkz3jrO1PqRvppZPtwa9RAwMzern5gL/4qEU3whVIp3KbzFKjrK3KRVmup
    /xwcj+1tzhdvdem/Hr1mevnk4khbRHwbWBw6t4o85IKE5dg+dZrq+L0gjFFXL7b+thYv
    kwK4GJdZT5JGyx/Ke4+ZA6Lb+lJc4+na5/aoD7rWGcr4dsU3MZhlyp/L0ByaLG2mvFjl
    Y7UYl2G0V0JL5x5HupT6RxdlWNxh12OJ0rG4tunyr9qQdO/0Hl3YFGI61DZKKwNAP0+G
    qZvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1771612288;
    s=strato-dkim-0002; d=strato.com;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=myVE31X4UclVEY0AKZPM4ycFun98tc+DFGsmLujAb20=;
    b=dFglRW+tfmU6rbRm/EInFkXQPyzNX3TThQW/wK6EeJUWjc0oiQL1FBGcLObxqAonKD
    f5kTQQjBBZvnZ1PLduApuZQJ0mY0dIr+rFXxhfutKgRTIrSgolV5y8jB6uPVFSCEeeE7
    Ffu9mToLurBWGaTj/zRrt4yH0PkhOsw/d9KY3DRA2CovIpYz5vdR/V8ngdOmfwINZH+7
    iIjrSF7w+uQ3qTfSSiMXwzHvhBD59ED0SXilhjlmbfEgJR09gHamU3cV5LuD6Wr0m8xZ
    mNtTcMjGZS0Ys/Yt7U2Rz5clsnlPLsVQc8qmju4MiTl1DnjD87EZ81OuTJv10JNnN0bH
    +N3A==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1771612288;
    s=strato-dkim-0002; d=duncano.de;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=myVE31X4UclVEY0AKZPM4ycFun98tc+DFGsmLujAb20=;
    b=J8Wt8Li20TwdSLsq3X4XdP0aVzinlcvNbbhPdtn9ImJ2ff0lZCIEm/5o2JNtHcOktw
    kQx61w1Crlv1cgjMeRGm8C4ZSx4sfYOZSfPYWFUF0IeeZvZWcjD+67Sgg5ogwRq7c3lU
    kdKmBtOjkAtF4cF2f8mrr2+oKh1qZcppriSBzqKSuBptQc8+4aelJg6X/CM787BmSm+9
    Ip0LFthrZPO9Vas4S9WD3wfAyJfDEVuKCVaitg0J9OoN94xezcCbKFfC05VYussSpIJu
    W1Tz5VTfZ69mTJu1vSLXi8dA478TmBUjQV4jbbDNYEtZKLnepu1nTCQSGumIKsp7rJr3
    3TKg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1771612288;
    s=strato-dkim-0003; d=duncano.de;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=myVE31X4UclVEY0AKZPM4ycFun98tc+DFGsmLujAb20=;
    b=Y13Ym1kxQoLeZFjXYUThQG98aEIXJH7etnZwUVxl6qCKiTLG/uYz/IsyzVTRGRaIn4
    dS674hlotK3RU4Lf2qAg==
X-RZG-AUTH: ":LWgJfE6haOsnpV80p3phQAHiyBhbjkh7/UneMr/no9OpvY//D2HOgtB23SGaSsPk15/bwmlWgY7RdH+YLM0/K8QOE9FwgChfTGo6z2giTNc="
Received: from tux.localdomain
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id dd35fe21KIVR6Ph
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Fri, 20 Feb 2026 19:31:27 +0100 (CET)
Received: from localhost (tux.localdomain [local])
	by tux.localdomain (OpenSMTPD) with ESMTPA id 95d66eaf;
	Fri, 20 Feb 2026 18:31:27 +0000 (UTC)
From: mail@duncano.de
To: linux-erofs@lists.ozlabs.org
Cc: Duncan Overbruck <mail@duncano.de>
Subject: [PATCH] erofs-utils: fix installing erofsfuse.1 manpage
Date: Fri, 20 Feb 2026 19:31:11 +0100
Message-ID: <20260220183110.2633838-2-mail@duncano.de>
X-Mailer: git-send-email 2.52.0
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
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="us-ascii"

From: Duncan Overbruck <mail@duncano.de>

---
 man/Makefile.am | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/man/Makefile.am b/man/Makefile.am
index c951681..b9b5989 100644
--- a/man/Makefile.am
+++ b/man/Makefile.am
@@ -3,10 +3,12 @@
 dist_man_MANS = mkfs.erofs.1 dump.erofs.1 fsck.erofs.1
 
 EXTRA_DIST = erofsfuse.1 mount.erofs.8
+
+man_MANS =
 if ENABLE_FUSE
-man_MANS = erofsfuse.1
+man_MANS += erofsfuse.1
 endif
 
 if OS_LINUX
-man_MANS = mount.erofs.8
+man_MANS += mount.erofs.8
 endif
-- 
2.52.0


