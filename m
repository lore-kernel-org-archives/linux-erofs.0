Return-Path: <linux-erofs+bounces-2392-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0279EF3C991
	for <linux-erofs@archiver.kernel.org>; Tue, 24 Feb 2026 15:16:38 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fL1XP1lqCz3cNP;
	Wed, 25 Feb 2026 02:16:37 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::232" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1771946197;
	cv=pass; b=VlPN+j+1i0MZH5eY4k26kub9kHpSMDKmMVBxQ5/bD9n45DzbKZLE2gPj/oxKdlf7mEXlTNiiiVwS4exjW0EF9uK1yYwoczrrpXHmCkL4VrkN13p1O0AH6zvcwloJ4yE4jXgnHKBodSDLp8pFK5pObng62x/h67lvBjO2HyY1RSpiE7SauhtqhSjvVeu0MDrJHyjZ87eB1U+qsSnomOiqkOQeUBQzsIgbLWwDnApR4Y2xaKxmZ7b8Kg+tUKXYHGPZehnbs9YAbrb39RaGlWtOpR72I06d7/upcPG0aRIhcaR6sVEZtoGTd8ZiT6qnu8Zj2FsXsNitX2p8C6yFoo5eew==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1771946197; c=relaxed/relaxed;
	bh=Ii4RifInROCrLQ8CeU+bOkSJY5FCeHflMA9/WNg4Jqg=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Content-Type; b=ZO8TgNy6gDeHJLVcIaSHhowVLWwg/wcoaSV6J1bSDv14l6R/fqitzjXWrldXWnu7C87+v0X8/HK4uLJiyNAUeI3W7/ZPzGpHmoUat91einCtGS/D1MmuRW8fXg88AlztNoUqOq6lE1d+HuQ/mziRbbX/FolglH1Hzko4eXiaOwQPZeDGnw/+1GXayAjetO+/LtFwrxdFmAL1bLTG3UE/H3FJXMdrbHWpJuSzX/emiMuOthb2Gmw8iKJEunU1ileke793k9z6x1Bjnka70zAuOZcVxLUUFu41Z8gVatAEI47f/dWFYe0Y5vd9XkL15Obk7z+kRyll29S6HQInPecCxA==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=raspberrypi.com; dkim=pass (2048-bit key; unprotected) header.d=raspberrypi.com header.i=@raspberrypi.com header.a=rsa-sha256 header.s=google header.b=IJRR9oxa; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::232; helo=mail-oi1-x232.google.com; envelope-from=matthew.lear@raspberrypi.com; receiver=lists.ozlabs.org) smtp.mailfrom=raspberrypi.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=raspberrypi.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=raspberrypi.com header.i=@raspberrypi.com header.a=rsa-sha256 header.s=google header.b=IJRR9oxa;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=raspberrypi.com (client-ip=2607:f8b0:4864:20::232; helo=mail-oi1-x232.google.com; envelope-from=matthew.lear@raspberrypi.com; receiver=lists.ozlabs.org)
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fL1XM0ZNlz3cND
	for <linux-erofs@lists.ozlabs.org>; Wed, 25 Feb 2026 02:16:33 +1100 (AEDT)
Received: by mail-oi1-x232.google.com with SMTP id 5614622812f47-4638e238094so2654787b6e.3
        for <linux-erofs@lists.ozlabs.org>; Tue, 24 Feb 2026 07:16:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771946190; cv=none;
        d=google.com; s=arc-20240605;
        b=jeae7rBMdIU5Qls35YrZ8L3ydv+rUKAsVA0dQG9Sxxl8CakUGIKyCIQwZlS6uXe5kA
         ANfxrPMciY8IKyPH7V8Fso0gfvls3PMbsmfEhoVf5+NYzjuMh/MPvIJAGO3+FMaPqfeC
         bPZ5Yn4q8ppqAxvJAjxJ1u7eocmSlITG/00caVRoSXQ0ZhANmUEnMQAH8Ps6R3y1iPwY
         XCiH82WghPpWrdGDvus5pm5NiyjVeyCRTeeW9bk1j89GfMRSO0k/HEuJCnEY0ht0zUX0
         sFF0yoaEycG/MUA46mK0kaaOaFAUw9cmfr2gKhqvmK5gcA2+Elq2++u3XEzViWjWTNQx
         L9HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:mime-version
         :user-agent:from:dkim-signature;
        bh=Ii4RifInROCrLQ8CeU+bOkSJY5FCeHflMA9/WNg4Jqg=;
        fh=wOhGMmq2KH+KOElLlPuS8ws9o9ArjDb4wH58JVHh4Vg=;
        b=eF7khNW+lhEH09n6DIDhtWHR2drNK8kmcnvzhRWmr3+Kp0bVlt78BMEih3no71a9bf
         7ORoGsPkV6YQ5aJkgsf1jt6iavCovCSPYtYpOhI6m+8GjCn8lTduASq+XACRH0C/haU4
         VfFnzO9sHTxae6vH6ekP4e6EII+DqPwNlQX/YhLToSa5xaHitlQoKmKjmAUc//Ch3SDn
         sRpkR2PTf159uipucd+YOPOcYIyNfB16M8m10bKgX5iYUwd6hWVHle7OzHwGVOZ6gR5S
         AZnSg8kvMUOCEqrr2SDDFRcbdHAbqsSjwzgGwA11AmIFL/+9zSvqiPLCV217HYFmRMYl
         QntQ==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.com; s=google; t=1771946190; x=1772550990; darn=lists.ozlabs.org;
        h=content-transfer-encoding:to:subject:message-id:date:mime-version
         :user-agent:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ii4RifInROCrLQ8CeU+bOkSJY5FCeHflMA9/WNg4Jqg=;
        b=IJRR9oxagbhmkZwwEy0XILwrbV+XN19KWpBUTHJknNV5TFS4CnURlIQpxgAFNb8NBS
         08z6h+FHKDgXtw+Jj0mlYRpPOe3cEw9kd7RDHuOSiByn7RUwI288UcqYHfRIqggLYf/0
         gkneweZwMx1/bftodMYys/SDRctw8ECfV7H0go1LWFXVtSbizPz+L4OWzDLALMEK9rsN
         EHQkLYkleaQbjiNtzmo22sEqphFy2aEsBAxOEz119iRQLHic0sS8a5L6PDfm2ucNeVFi
         IrkxcH3xAQ/lrHfacoPMl15CzeEbC81gKe3ZEN1UCK1ePghbDPEI+JQKgwyW5whq6YgO
         Zvfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771946190; x=1772550990;
        h=content-transfer-encoding:to:subject:message-id:date:mime-version
         :user-agent:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ii4RifInROCrLQ8CeU+bOkSJY5FCeHflMA9/WNg4Jqg=;
        b=JwE1yC5zWR7N+gqNq2xMVxiS0r5iwF8Gwz5a50NwFOTzTCc45axInCiwZBR+XRFoRs
         6uA/0Osc+MoYyytaIeWbTwSmH3W28gaHq+e9lmCqqnNiPF0lBIEvY63aZmVCQ2e4ulBS
         foGScFn5nKhnSmpwX9iQ5K9OPVIvc6MxWUGsaXk+vHCT9no5knZ/pROCEAEtnLDA7ThM
         S1MOjLF0bwwZliu4u1aetACNd99lRqpH3zPeaI/YNHvFC9skASr6rU/6czf8JwtRqNLj
         FqE55a1VdaN9yQHF0VIv0LWpjL71gwjf3m7w9NpoPf0OBIDSYGrplnMLLOr/fVUHD4Xa
         vK6A==
X-Gm-Message-State: AOJu0Yx5MMq02PetbcadWa8G49tjRl8oyJIIhGtzQrkzEdkIEDXqQdx8
	jGDQ9IiA1lIps5irdtWW3RItwoozJdHC7GM9P8aN18CMbir9fws6uXqWrLsz5cOE5z4EUMFExfv
	UU81H5yosmR6nYKF3Hfo6KYXyWXnUyDeG8BuwNsOB/MSF5BCC7w4G
X-Gm-Gg: AZuq6aLx6QmGRaenPN5r98bpToFzul/+veoHFOSzdI6lFfBbszQePGJrx25chZwck2p
	sFHcJmDK7qiGIL3sTY/qIMAvG3aAN9q97Geo9qhkHO4/Rcd9Sas+pLryATj//qSQjxxcdkcyogQ
	9Qv9fhT4zJm5T1L19OkNk0+nTVwjnX8Fvc2al83dYOhNQrokb6qUaYo6UqEDRp+i/zAUH2ZM3vf
	nGxy6JRqvNnXBSvDa5b10QACym7YgD/MA1KLuTZWAYQF2r/pBgBjgXVF1Jr3sohPXMgCmHKHMEo
	Gu+Uon7w
X-Received: by 2002:ac8:5f14:0:b0:4eb:9eaf:ab4d with SMTP id
 d75a77b69052e-5070bcbfedfmr191243291cf.62.1771945797475; Tue, 24 Feb 2026
 07:09:57 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 24 Feb 2026 10:09:57 -0500
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 24 Feb 2026 10:09:57 -0500
From: Matthew Lear <matthew.lear@raspberrypi.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
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
Date: Tue, 24 Feb 2026 10:09:57 -0500
X-Gm-Features: AaiRm51FaRolxuThjkZ_SrnywirqHIh8j67Zqt9CoY6iJ8t_c1z9qbOjzP1sDcQ
Message-ID: <CAPrOGNDb=Y1yt_m=NgMSj01Np0yCDF2TYTV_dY_nV585=eX6aA@mail.gmail.com>
Subject: mkfs.erofs: should MAX_BLOCK_SIZE be tied to build host page size?
To: linux-erofs@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,
I'm writing to ask if there is scope to change how mkfs.erofs handles
its max block size ceiling.

MAX_BLOCK_SIZE currently defaults to the page size of the system where
erofs-utils is built, not where it executes. This means a that compiled
mkfs.erofs built on a 4K page host permanently inherits the build
host's 4K block size limit, even when running on a system with a 16K
page kernel (e.g. like our 2712 Raspberry Pi5 kernel):

$ getconf PAGE_SIZE
16384
$ mkfs.erofs -b 16384 test.img /lib
<E> erofs: invalid block size 16384

Passing MAX_BLOCK_SIZE=3D16384 at erofs-utils configure time results in a
binary that successfully creates 16K block images, regardless of the
page size of the host it's executing on. The restriction seems to be a
build-time constant rather than something which has runtime
justification.

Also, since modern kernels now support large block sizes (LBS) where
block size > page size, this seems to add weight to removal of the
inherited host page size cap.

Without this, users on 16K page kernels are forced into the experimental
sub-page compressed block path:

erofs: (device mmcblk0p4): EXPERIMENTAL EROFS subpage compressed block
support in use. Use at your own risk!

If I build erofs-utils on a 4K host and use its mkfs for a 16K target,
the binary rejects -b 16384. I need to configure with
MAX_BLOCK_SIZE=3D16384 in order to use -b 16384 otherwise=C2=A0I'm forced t=
o
produce 4K-block images that trigger the experimental sub-page warning
on the target device. This isn't a problem, but it does feel like the
utility should decouple its validation logic from the host's
page size.

The baked-in behaviour also affects official distribution packages,
which may typically be built on 4K page size build farms. So this is
possibly a wider issue for the 16K page size ecosystem.

Is there scope to increase the default block size ceiling of mkfs.erofs
to 16K (or perhaps increase it to 16K for aarch64 compilations)?

Cheers,
-- Matt

