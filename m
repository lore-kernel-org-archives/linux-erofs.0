Return-Path: <linux-erofs+bounces-4720-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E22BCC6B03
	for <linux-erofs@archiver.kernel.org>; Tue, 13 Oct 2026 03:37:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3g4b5vrQz3bpH;
	Tue, 13 Oct 2026 14:37:03 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::532" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791862623;
	cv=pass; b=UUL1a2H1mUmtgm/GKdygNnXqGhXupEQ5N4FvKofG3y/risywaOdYCjCAHGrG3fTAlzq1MjcV0s0h67sB7nlxLBtx9M7GPJAbZJ9V3D/ayr4fMr4Jy3xjm31GDdDqGHBKQ2hliUIrcn/dhUwhtIzoB8zHhJ7cnOAAtovkLkG/aP8t1arbhQp7YxmXbqyApWwe7T1ukN5Dbf6IQ3BHW6k3SGSuFRcV9KB4eEcsO8iieioKQDcVHPxJxPmEcdMxcNTpvjFY6b68yjWSATJ110yYsTd7SgRFZvi8MCOd+Xn0Rw1xXeYB1w54YJ9afCHYZPlhXswKrUd7NY36Vy/xDFIlWA==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791862623; c=relaxed/relaxed;
	bh=MGRK5/NtAZoSRjlVvy9rmyNepxflCRrrNBGHVHUG47s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a7zeINQaVV+NizDSVlnLJmKMiaEztBnv4tdq/rrQBfH2UBoaKkLHsK7Q9Jc/4qZGsLxOYsaxVkDwNOzMlTtqrVnOvUgJ8v1UFhesG9lgBZOUINSBMcAC+EmGbSS1iYNOgJx81L/+4dous3CKLHjClRRF70yoEAbzQgpWRkA5veU2znwj7yH6rRyCAZYo7Cc6jB3ODwpz4DWIQiPZxjYfUyX7Vxj7w0AIYeZndg8fi0G1utN9d8KIxqCAEjg8XvGh9AnJVIfzaoKMqeXYwHAgNfO3WC510kn0L1clOgScTSnOADmfx67C5Y8z3s1ZK5mQRU28KYmi38qbpi8jCBo9Fg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=mjbyNaJF; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::532; helo=mail-ed1-x532.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=mjbyNaJF;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2a00:1450:4864:20::532; helo=mail-ed1-x532.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3g4Z6hkdz30VV
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 14:37:02 +1100 (AEDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-6acb9c018ffso3954461a12.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 20:37:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791862620; cv=none;
        d=google.com; s=arc-20260327;
        b=f83n5S+wLs6Zr1IbFuy0joUHRK+bKeL+5t3+i3Jk4zhG7hO53P4+gBQcnfiHfSeoyJ
         vfCbULaD3xAnCQnrMql/poGfYrxDP31F4nPK0ykuHqOVDrfDO+kyf33DP1NU3gOXo/zS
         MrhT7nwEKPHGsLmRd7NmNIlSxa8S/WJMLNBKiWU6DxBIZf/tbE9lv1vApiS/11MwBKlH
         oDuLitDlCURybU69fU8dNhx0sz0y0LoZXNPQo0LoHk2uWQD2YwyvugMeQ9Yd6NmQ+JQz
         Ij0tQz+bsYrdYVe1kzYB5K6Sh9Lbgn9YhAt6ycef7rwuJTtLD8YyC0J6g/mcn43f8uif
         E3UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=MGRK5/NtAZoSRjlVvy9rmyNepxflCRrrNBGHVHUG47s=;
        fh=OsEGx0VXgTr5IbiTnn8Sna0AWtepoGbBtrh8BYh5c3Q=;
        b=RjK75OQRjIsUF2lkaGQugciwdwRRzxpNwy11sXJP1nq4+5u2V6s9gqSO1CKNvkoNav
         sFLI6xG4JeOqFkTfTryG1bafGj3CxWN+fq5cN3ay+kL+ErXMezDIwW5xWXCF7lz+OxWA
         AbltUeFi/juzPidKrAZ2zRvID+tTbWBCa/4B3aKCIam27IKncxR3R5SwsVVzUdWTvTSt
         yjOTVIcrPoDiAB/kUTeJC4T1Wzj6c3/eQL+yayfC7IJvnjNeA1fb1SAlXw81fm2P5tSK
         Fhh8cbEzoKOn4XGP2M/gEah2EY1OOf/1v1BfWne7iSdg/dLaQ8iD8+8pJb/x9MdPAkjr
         lUZA==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791862620; x=1792467420; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MGRK5/NtAZoSRjlVvy9rmyNepxflCRrrNBGHVHUG47s=;
        b=mjbyNaJF7lgMKflJk2xwOWzJ0CjCzuFzbRDADU7XhnvdLl52+IOTzU1jGbg0xJpO63
         E7IN2l9G5vKUleVcu+gilDQZuY2u4L/LO9LH0uoxG9Oq3abQv9UNc2uhfRKuPtp9pske
         krrQ9gfSCssCLiPzQnAmDtYwFZIUqr09JLBYs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791862620; x=1792467420;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MGRK5/NtAZoSRjlVvy9rmyNepxflCRrrNBGHVHUG47s=;
        b=ZlFoZ4kla49IFvVtl0+2WmUxqDhcIbLPFtZLAAx95gp52YEQlotoa2kzvpgllCEwr7
         3hS5+RPjSMapVplY+5mqU6OKBgPJRCheecGKnnOCdfec7z8IMx949j40OJWC+0yB4FFs
         QA7Rjx13gLjhQW6892thoJQRjIgdqyx+z7G32Oz7T3UYenyvO2MAUXIOZZORnJaNOeCF
         +zsaIus53IrAOUCK6SRaR7XA7NF3Fvdl6OP56YdSNbs++3MdCs3IZ/Nk9r24VmRu1jgn
         JrvLSC1ZU9MwpDr8uDkHWHr//Eui+JTFb/66J7i6qJqMxpwD3efI4bQuGJLFwSeOFmFw
         Rj6w==
X-Forwarded-Encrypted: i=1; AKwUvByK40eTdW/6gnzGvjbURgTXd4ZanVf9tjc2+CXbkNzMxl2ExGce622cZ1r0uexE+EHg9XuAT+JyHfIFFw==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYIV7x94ON5iPrqy8jOcFLAtEcjKfmRP03UAI2i0NsMrsfv5MuER
	34abVObbtk0A0eKOflc3tFPiD1KO4/5c7Ldg7oaNpbCnRFh2ywATyOd+GMwzX1AXAUOQVuiVO4g
	7hwT12xwXJzM2e20AdMuLxQzX12DAiPy7GcYqJaSI
X-Gm-Gg: AYBFou080W3JuqzW7AB0ArWGubBT0nTGUoWwwM0L7SxQwxl4QNf6IEr0uzYXr9yhYNn
	AhXcuG160nxZhiZ9OVMkdHaZxuQU2CJpaNg1OO2l/xj0MVVJv53WbqbOo4kwd2p1bd3u2s6LcVt
	hKA3qr2ZjHnTooSsO523Yse7XzVGncCJ0DIEFbEdf76QovkytsdXNDEthSFuUzPMs4ASlCixBo6
	+Rjbvzco7IMxWheXCZeqxGp9GOQee0eiBp4rgitQG4qW20HUPv2BXtDqaBvJksC19iuLDlv3H8Y
	NibuQzXegE4kvhymEkOpTNtlB0Haida/W0v3iat2JgIckIa/wdmzN7Qh3w==
X-Received: by 2002:a05:6402:4046:10b0:6b1:e072:763b with SMTP id
 4fb4d7f45d1cf-6b1e072769amr1174182a12.5.1791862619770; Mon, 12 Oct 2026
 20:36:59 -0700 (PDT)
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
References: <20261012140048.214059-1-heinrich.schuchardt@canonical.com> <20261012140048.214059-9-heinrich.schuchardt@canonical.com>
In-Reply-To: <20261012140048.214059-9-heinrich.schuchardt@canonical.com>
From: Simon Glass <sjg@chromium.org>
Date: Tue, 13 Oct 2026 04:36:43 +0100
X-Gm-Features: AclHuK9eMFSCbpaMTgcMw2HIYw5JBOzIecy9gUFBmDud5Hwe-av0W9GrCs-G0z0
Message-ID: <CAFLszTi920A9kZ1Kw2959rz=BJNxqRP_dkdESNdXGZRBj2CErA@mail.gmail.com>
Subject: Re: [PATCH 8/9] test: env: allow optional date field in ls output assertion
To: heinrich.schuchardt@canonical.com
Cc: Tom Rini <trini@konsulko.com>, Simon Glass <sjg@chromium.org>, 
	Huang Jianan <jnhuang95@gmail.com>, Daniel Munic <v-dmunic@microsoft.com>, 
	Tony Dinh <mibodhi@gmail.com>, Alexey Charkov <alchark@flipper.net>, 
	Vincent Jardin <vjardin@free.fr>, joaomarcos.costa@bootlin.com, 
	Aristo Chen <aristo.chen@canonical.com>, u-boot@lists.u-boot-project.org, 
	linux-erofs@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"

Hi Heinrich,

On 2026-10-12T14:00:39, Heinrich Schuchardt
<heinrich.schuchardt@canonical.com> wrote:
> test: env: allow optional date field in ls output assertion
>
> fs_ls_generic() now prints a date between the file size and filename
> when the filesystem sets FS_CAP_DATE (currently FAT and ext4).
>
> Adjust the assert in test_env.py().

test_env.py is a file, not a function, so the brackets are wrong. I
think you mean test_env_ext4(). Please can you also say why the old
string match fails, as in the previous patch: with a date present
there is no longer a run of three spaces between the size and the
name.

>
> Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
>
> test/py/tests/test_env.py | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

> diff --git a/test/py/tests/test_env.py b/test/py/tests/test_env.py
> @@ -523,7 +523,7 @@ def test_env_ext4(state_test_env):
> -        assert '8192   uboot.env' in response
> +        assert(re.search('8192 .*uboot.env', ''.join(response)))

run_command() returns a string, not a list, so ''.join(response) does
nothing and can be dropped. The rest of this file writes 'assert
re.search(...)' without the outer brackets (see line 197), so please
follow that.

As with patch 7, ' .*' no longer checks the layout. With patch 5 in
place the ext4 file should always have a valid date, so the test can
check for it:

    assert re.search(r'8192 +\d{4}-\d\d-\d\d \d\d:\d\d +uboot\.env', response)

If you want the test to also pass on builds without the date, make the
date group optional with '(...)?'. What do you think?

Regards,
Simon

