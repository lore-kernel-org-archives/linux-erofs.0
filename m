Return-Path: <linux-erofs+bounces-4722-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CBBFCC6B03
	for <linux-erofs@archiver.kernel.org>; Tue, 13 Oct 2026 03:37:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3g514s0vz3bqD;
	Tue, 13 Oct 2026 14:37:25 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::529" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791862645;
	cv=pass; b=T9+LSJoGrG7OPjH6WS7yCktbyjoIlRPx9b4iWuF/sIuHyUw33dxSr8cgloJO51w+/8rtQDtM4uiWXFdp/KL7vGJPsZcD+32EOvSJqthiCiYfRLxaQ3TJ2FvYQbyYXqQ9s2s7ONtAUgTvf8oU4kX0OY0a7v8pxmVn9I7+i97ufA1rwbqxoJj0+I8klTq2/SYHQeVvdyA2MNxRD8CZKIrXbsx+cof02Q/NpTv7GT/E9E58GbGiF3DHValImieAcfk7VcPxgzjxWuvO8VkfWaRhds+oWRoeNW0M5KynF0/HpxTwJ9Squ6ERy591L3GGBfVGtO+ItLPHbp3bGFIBl4Fw9g==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791862645; c=relaxed/relaxed;
	bh=qLzuJ/sJ/zlaD9S+mPNemyOXBthSgeIM9WPueYAk3jg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d8aMAqZdMt5DKIrng/cdc5oXU053pYdEYuANtsM4JLXj9V42hGajg1EcYG+E4hSxpENuSYsUnInWZeR7ojQWoZLSRfpf8B5BGMQ5fmDM3qjUpGri3Vd8jsvLxzATANPIGpGUBg4USmdwgl71ivZflo6VDmfp/o8wUkTrJ0/tkwXen4TRC2SV7Tyt7I6VryGaUlz04bBNDpUN4TA631g17wPRINc3bbOaXet234W3vaR7c1Sjga0T608HnvlorUFhzrrPL2ybOWVUT1aJfTK2QkbNh2aSQ/dRvweCghPUCgI/pnLoeMRFSPtlz93AKosljn7vt26JH4153K1iNejwfw==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=Z/YA1ECT; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::529; helo=mail-ed1-x529.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=Z/YA1ECT;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2a00:1450:4864:20::529; helo=mail-ed1-x529.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3g502mwrz30VV
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 14:37:24 +1100 (AEDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-6b1aa2848d2so2692376a12.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 20:37:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791862641; cv=none;
        d=google.com; s=arc-20260327;
        b=fD0HW4TK996M7zEXvVcykxX92mGx1rCK1gRH3taoqGeL/fx2/rpjqDp4kFOv/KqZV2
         u0PYsOVUHUXfB0hupPwnKWZELls7ycNGGAd0RS/X0Wgx4yKclPBHvnAdeIXefQJqv5oN
         yXL2+2x1nxPdFGDlSEg8KfbHj0lQ3VL195gIy3f2C8ps5VdDvPMCOoeBIwAuRbClBu65
         7Mqn2yefALh4p1ntN0bPmxWEq5V+WF9lnSJ7SA6ZalNVLeb9hr3Wgjf+pJW8tDS1hP9p
         r8k+4z75Kioqkie8ratsg9ZfRr/L2YbUqBiqsKNMWiXLLhLw59/6qvIm52hYdiYPIj/V
         bbvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qLzuJ/sJ/zlaD9S+mPNemyOXBthSgeIM9WPueYAk3jg=;
        fh=WevmgtO2Ikg0F/Iadll9iSp+Lt1Jp6O/jghNg3VgH7Q=;
        b=UqvOTR1N+N1f2bsIQAKsS7Wtz9X2zxC6SuCPQ8GyHor4HZoAUMRSGVY9phKEgMAXZ6
         QMuXye4O+PGCse9qpwv15503G8reImNbp7msJZ5I4wSECWtOa6A4GtEK2+3swhWIRp6/
         bGMH5szX8BuzGHyppDw7FD9MvcWtFjUE4HoiqgceZd+UbcqgrYWx9sqwyzIyAVrQuSXt
         /cNMzKnvKegR/0rSCZhUcYGBFk6l1FSjEtxPNYlkY30hQR3DaYntws6cjCOoJKiXRwH/
         G454VCkggWOa3BIzaotPUO/j/7CNERLAFTzTcPuWWxpnkAl7AdyIq9WD1Enux7/sci/R
         2dkA==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791862641; x=1792467441; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qLzuJ/sJ/zlaD9S+mPNemyOXBthSgeIM9WPueYAk3jg=;
        b=Z/YA1ECTW3iBfmijkZDCx+GbwttfnNSF51JG/JJ8aL7CJMrwWLoq2/kx3YrQclHHpK
         fN1QhIW7MBemB/zDwqxD1tftQyv9M/EEtMst3poS3V1HPoIDsDYxSOziAFJr+mj/94v/
         2fU/trJJZ4hYd8PO3I4tztf9cX3vYD+mLPhHs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791862641; x=1792467441;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qLzuJ/sJ/zlaD9S+mPNemyOXBthSgeIM9WPueYAk3jg=;
        b=bDepMIKWeHJKMt4bVY6wt19SnsPTsamPu+zNLMF3P5ajsNZgxGKkY9cRAPGFkJn2se
         2uP24JWtLsHRBBE206IRl1aW/yoGt/Jau7yWk7j0RTZF6gD4T8/jH2EG63BCvy4yW6zn
         Rad3MfH7MgFkhuNkB60vPZTcAdnGefrvstacaqB6QsIliJFDtY2a468rI2w1X986FI1c
         Y3+QhdtBlxU5ODgGzyvod+reECHYLqBAp0LPrJKxfRIeos5ajFO9zHKE8pbloVurM1zn
         uQSE6Poq65jCT2hFTexgijCYjrG/36YGP5uR3Cq3wml7h/HRJQmu9LJ5toSrjOUmqPmR
         dbhQ==
X-Forwarded-Encrypted: i=1; AKwUvBxg1km4kG2Btf70JL/s1AWMQI9DmjpenMtIB9d7W9kYTiMdp0qWvRuVmC1cVqG4CpeZn6rb5Y4kwp945w==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYIQclKTFVVv6Qj04bOWm84bOZ5YpMCEL7oNSgBQnvMErFfuyrYK
	QRQnQNBuzPr1z/0YM3kiZliPSpP96iFMDB+CSpZ66rZkxqpoeiWvJfAzr7/ZcE2h+UFtzNfiFr5
	wYr6m8GSENLeVgPzksyeahpElwLqUwghW6PFhL/oo0YzAo9A9PIuADUU7
X-Gm-Gg: AYBFou1mHxKLOhqC+83GxYOeGvIx3tXmAKpP/i8MqqfppdV06nQtSkWLE4jrmsRjBnv
	9p9+JtpmTWMUU1yVzM3RiBfrIQ0ai0vJlxe1wUZDwkYVhU7dLq9ksxKVOpRZukYt4MFSV0uq8qH
	AZ+HU0/0AfXE7OC71Bw5VLEsLHxUfJlAWy3SuI8T16SLnwBeY9R6l4UxemGWM9MNJ9+8cnSR/07
	7//gAxA7bhGqpOxKgGjNGRS/sjmWi17ZdjW2dxQ+/MYgWkd4DYmDU41q29DzPSXopQIDPYT3Yp9
	FaSZHasopU/ZwBzJxqxkhUDQQcRTc58uwE0emJXuIGSD3na4zcbCLP8VsFqfC9ss5RA=
X-Received: by 2002:a05:6402:24a1:b0:6ac:934e:a9ca with SMTP id
 4fb4d7f45d1cf-6b17c163361mr9153538a12.0.1791862641072; Mon, 12 Oct 2026
 20:37:21 -0700 (PDT)
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
References: <20261012140048.214059-1-heinrich.schuchardt@canonical.com>
In-Reply-To: <20261012140048.214059-1-heinrich.schuchardt@canonical.com>
From: Simon Glass <sjg@chromium.org>
Date: Tue, 13 Oct 2026 04:37:06 +0100
X-Gm-Features: AclHuK852lavvUqEOZ_11Z0nkBRVxLadcgmzEsj4JoilfijlxO3NXq21ChN1QGs
Message-ID: <CAFLszTjfzpSOmjm4f2wT+V62q_PDNbkMS0t3LgWnQ8_wvxiWCQ@mail.gmail.com>
Subject: Re: [PATCH 0/9] fs: improve change date handling
To: heinrich.schuchardt@canonical.com
Cc: Tom Rini <trini@konsulko.com>, Simon Glass <sjg@chromium.org>, 
	Huang Jianan <jnhuang95@gmail.com>, Daniel Munic <v-dmunic@microsoft.com>, 
	Tony Dinh <mibodhi@gmail.com>, Alexey Charkov <alchark@flipper.net>, 
	Vincent Jardin <vjardin@free.fr>, joaomarcos.costa@bootlin.com, 
	Aristo Chen <aristo.chen@canonical.com>, u-boot@lists.u-boot-project.org, 
	linux-erofs@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Heinrich,

On 2026-10-12T14:00:39, Heinrich Schuchardt
<heinrich.schuchardt@canonical.com> wrote:

> * Let the ls command print the change date for FAT and ext4 files.

Patch 2 also cuts the gap between the size column and the name for
every filesystem that uses fs_ls_generic(). That includes squashfs and
erofs, where no date is printed. If that stays, please can you mention
it in the cover letter, since scripts or tests that match on ls output
will notice.

> * Adjust tests.

Please can you fold each test change into the patch that causes it. As
it stands, patches 2 and 3 break test_fs, test_env and test_erofs
until patches 7=E2=80=939 land, which makes the series hard to bisect. The =
new
patterns in patches 7 and 8 also match the old output, so those could
simply go at the start.

> * Correctly update the change date when writing ext4 files.

The tests only loosen the regexes so that the date is optional.
Nothing checks that the right date is printed, or that ext4write now
stores the RTC time. Sandbox has an emulated RTC whose time can be
set, so a test could write a file with fatwrite and ext4write and then
check the date that ls shows. That would cover patches 2, 3 and 5
together.

Regards,
Simon

