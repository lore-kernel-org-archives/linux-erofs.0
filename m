Return-Path: <linux-erofs+bounces-3985-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E16AC44532
	for <linux-erofs@archiver.kernel.org>; Wed, 22 Jul 2026 16:29:42 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h508P0xNrz2yfy;
	Thu, 23 Jul 2026 02:29:41 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::133" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784737781;
	cv=pass; b=SRKCZ661I+XFbS0aRVaxbEtjHFSpwLe+I4dJXeVdSptp3VHKVSIrL7V98sLP/5kX9wrURy2Amk5BF8DuHMMVUI0lZM9oE3fINKrqAT5H5fV23IxltyScc73WHFh2s917hksuIuyUBjiymxfnsCJzrI46Trs0It1x7ByR3kx1o0AjESAO5BVGI1uPf73Nv4UmypP1RxnfqA7C4yL267vw/6y+I/Z6Th7FOvoJOfulK5NXl39LZ1IKe9XFwOfcL3XY4R3acrT4YsCGnDCkNEijPsV62CvYR3xhB3rt17nXL7hMxix336SX/TbDRz8p8l8v5tBv+X+ltfHyttZF/zUNaw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784737781; c=relaxed/relaxed;
	bh=InkY2TqArSmQXaSwMOCoeFzsMAyO72A+PE6OTrxgjrQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mbHZOxQ0zYD2/HmNWIyaWdeztfbxCs5SFUOQEd4dkxkk8MnOwQzx9yVJ5suEnDh4iETth8NdrJhG8Ld52ZZn9CjY7boIfbPBzklZEa4abPpME2VhkyDLZZJ9Ey4a8k/Baoxt9Lc5kNMNrrOlX/YOSU+7R3eu4B75FcuJ1AxjBFliV6+EhutSs3g7qG0NTYKRDeI7BJdzxBaadeuxS84UuKUI7MOf0VLZkUPTmr9LdMUuU+mz/qk18zkT1/V0LPC55KqcyONbn0yJtuovmXpcVFsxPXXL7D6E98fJ+C0vnFaDvEgoy59AF7HvLVzhO+NARkjyRjHIcS56bWUKgs6ISw==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amacapital.net; dkim=pass (2048-bit key; unprotected) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=U4mZVlLx; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::133; helo=mail-lf1-x133.google.com; envelope-from=luto@amacapital.net; receiver=lists.ozlabs.org) smtp.mailfrom=amacapital.net
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=U4mZVlLx;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amacapital.net (client-ip=2a00:1450:4864:20::133; helo=mail-lf1-x133.google.com; envelope-from=luto@amacapital.net; receiver=lists.ozlabs.org)
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h508M2hcGz2yfS
	for <linux-erofs@lists.ozlabs.org>; Thu, 23 Jul 2026 02:29:39 +1000 (AEST)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-5b0117d49dcso11732638e87.3
        for <linux-erofs@lists.ozlabs.org>; Wed, 22 Jul 2026 09:29:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784737774; cv=none;
        d=google.com; s=arc-20260327;
        b=VYjfR3bwoc7TaukiHYhD8c82NKvenSY5gFxXtiGGww5AIaawdSBXlxwfY8a1eD2tAn
         cC0c39bjqmyP8IZEGi7yx79t4yuEPSqCfpbiRHu6VZJCTKN67n2OxJgklx30SU+Hno6i
         VPmi+kFS1WEQJa9bw96MqD1QZzgb4HdrEMSP+GvqMvdzvqelsqZe2vLaYVrykayQepBp
         EFMEIhVxJMXIz+P+F83EoWseX1XGXbCX+SstoaAaJ/IyuZPq24vpsBGyt5mx/MzrhsyU
         j4ZDk23t3+l9lKgFAYV+30dZ4fKi1SYeqWGFtVmcQGwI+8bXnPDlW+n5zMR1uvk8r0ZT
         i0fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=InkY2TqArSmQXaSwMOCoeFzsMAyO72A+PE6OTrxgjrQ=;
        fh=LppZgXKLdILyG6yl29RjuUckzPzLlN3qkKQ22AxqDGQ=;
        b=kG6qYs1dGRMAiFz6xCz7hih9ZAjtDx30On3xtqfCpiY55ttKZCWl8Vm4q/Q0clP35x
         9asf9JRLjXBlZABOaHO+VdUzkwUqJrmtknYmuEAclCrh68XACqJt78jtIaTlrsAScgAy
         hhmraUhdWcoAeuRdkPQ9Yxpl12l4Dk1PeqMlkrh6XB2UcDwL8Fb5t0yCw9tZHwN9fTl2
         l04iRt095x2VvzHXxy77h+Nwnv3QKMZnelNeHYfdk3Q3RhWdax9ud/Tp5P57O23bv2O2
         U5rOKAx8pGB5weiHr14DDHP7/ViYFNEU9ZAWxFOnbA0R8JQuYyLWw6FFHZld+sjRkeCL
         iYsg==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1784737774; x=1785342574; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=InkY2TqArSmQXaSwMOCoeFzsMAyO72A+PE6OTrxgjrQ=;
        b=U4mZVlLxtBrzcI+QDW3CpIIU9mLUICGj2hJLNeHFOZdh7H4uJ5AjoDVHHuXzeDRcN2
         qEfbsh5PvnGoeMjnF/MaTE+NmhLlXDvRAJxD+BvekdWkZol5P2qNw94DxL520HFwpmJI
         +ri29M17GrwMszX0aVR7pqVwTVoDPRszL4R97TEmq1odO/TNFzmTL1mw7zpOYvyvyTna
         KPMnbbvRv1DZnhGeMfWPKMip4+PTWKTvYZ1N1ia6QCbxMSHFquSNjdvGOThTohcFPtLP
         MQcIBlFkZ9kT+/3VToQaEEC8hdZmwx+ZPPnWjQ8PDRVkT7dB4NFb29WN8YRMt107EYQl
         37SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784737774; x=1785342574;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=InkY2TqArSmQXaSwMOCoeFzsMAyO72A+PE6OTrxgjrQ=;
        b=fgi4Z8JUc5X7h6vOzuudVtHTj/HtgMyxFa8TT3Nx6f7fsPBpFHvuRLmWiQhAgQLHiY
         QYNfkpUBOQHMW1m+Q93D4v6oqJXbPPjV8+wThmYvo0x5RJ/v0zk2NFdtO4j86G1F9mYz
         rC9UliTPanqyS0sg4VoFTmBhuWpvvC85s9H1WVrdE9HyHF5iBsG8p0uN6FlwHeCcX15F
         oM2N3ExpwLOk8G4r2pQ22j4I3WnXQXK0FYBqKobR+PrvqPwXq6mR1gEZgXhM5tZwOfhV
         GmtkUe7XLsIPxj+Rc8Rc9gQ/z60UyBRg3TzATp/IpkdkTQOva9PI/lDGRzhdf5Q7hwgW
         Vwyw==
X-Forwarded-Encrypted: i=1; AHgh+RrcaAXZT/AUnUkRTrwpomtsHUP7eNmV3FnoSYFs3bJxb6YKw+TcgJspMSb0XKzwaaoXOMKmtXhs1nCsdw==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YzwE/pKevH7zi85Zy99pN22hzVLNgrsi4c1rs7e+gWWsqZDlq7Z
	BocLg089KnNmLvYgqaxLcjQ6FGKZBVZSjG3IWYk2i7PUhCKbw3OqFuhOrLOVk5L8xEVMz/WszBo
	DWm5dSwg/jkCmiLf20D2R9rEVRiq+V0DD+H63abZd
X-Gm-Gg: AR+sD118VXL79nbVjo+ol0tEfIs92jQLg6k5iLTn0iTfNR6RKuuzYDi39bVlKHlg+YG
	lDo9liJUt3Bl64A+tzSdPh2nes88+JD6eV7bgBcc8+6rMF02y+03VTkbVUteo8e32BqIb3qlYCV
	WhHE7rDgW5X2/5n8k7K5vZRy0SU25POpfDbmn11VdaJIcS2Wy8yPLZCKWopkDAa8ijZEuLYteHA
	oYA6B43rbR2t0FREOoBYyRcmZuBiyXWVYvhIlC6UXTHrqIVSEilnAtmUrp+6A==
X-Received: by 2002:a05:6512:1328:b0:5b0:eda:de2a with SMTP id
 2adb3069b0e04-5b28f998d04mr4374814e87.35.1784737774129; Wed, 22 Jul 2026
 09:29:34 -0700 (PDT)
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
References: <20260715101107.973997-1-mszeredi@redhat.com> <20260722-fundort-zogen-kormoran-09fb867f1b59@brauner>
In-Reply-To: <20260722-fundort-zogen-kormoran-09fb867f1b59@brauner>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 22 Jul 2026 09:29:22 -0700
X-Gm-Features: AUfX_mwycQYWu9rMPFRhnxWdDLtR5J98EpUP47SKtC-4N4S0g7pVJ9n5XWZrccs
Message-ID: <CALCETrU9KdLsvZzUE-5sh7KkP5-cPh=hwErGmN=THsDatFJLfA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>, Giuseppe Scrivano <gscrivan@redhat.com>, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	Amir Goldstein <amir73il@gmail.com>, Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 9:06=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:

> Like I said before: I'm fine with an API where we can use open_tree() to
> see through into underlying layers, and given the right permission pull
> a mount out of it. That is a narrow, checkable primitive and it needs
> none of this. No new open flag, no second ->show_options, no metafs, no
> mnt_devname surgery. That part we can potentially do.

What, exactly, do you mean as the distinction between "[seeing]
through into underlying layers" and "[pulling] a mount out of it".  I
have a guess, but I'm not convinced that my guess is right.


Other than that question, I think I generally agree with you.  The
interesting operations here (getting an fd to something that was
previously inaccessible) are different enough from normal path lookups
that I think they deserve to be explicit syscalls or syscall modes,
not magic links.

--Andy

