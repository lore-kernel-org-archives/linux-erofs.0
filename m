Return-Path: <linux-erofs+bounces-4713-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AA44CA9EDE
	for <linux-erofs@archiver.kernel.org>; Tue, 13 Oct 2026 03:29:46 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3fw82w54z30DY;
	Tue, 13 Oct 2026 14:29:44 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::531" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791862184;
	cv=pass; b=MdBm+FTYat1PdySqh/BDqawO1bxDWEt1RvZRlC+rOxvDsVuHHYnGvQ83jUxXd9ZEwFTbJgN6F9cgvQPNKbZy10rsuVRkMPvDTzIz2DmgfFI0/EVJfjmGAzHQkKhaVwHrw5v3fMs4vfGMKSj4XxsW6U8CNbPiJfG3XxrQdqA3BduWyfPZUIqG1hgTkKAVEDasBe50UMWstX4Hpy3KE8ahTn73G2Vqi+sANDbwWv9NAB1VxEYfpavoH5ip7VRduiJaHv7QWhq7QAVj4+viVj0Aw3A4gzf0cMrc+6qZgFyMtgb9Pj7AinWLIgzxLT9zLPHlgSrQsIDYsJZ0QmrBsUyOXg==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791862184; c=relaxed/relaxed;
	bh=Ov5sd7UEltON2XCXxeeAfnk+dnRFhC/otLkRbcqOuwQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ctHrz0KlfGLUrRGnqWdLQ6oZx3WbkPim/Z60c2RhaYZHc2igv0OKu9Ilyu1LhhVHnn7Dy/1TgB0fviK6C0c+kc/fxJ94d1mlKEW8Aj+sPZAr/55v5O94/McdV+fTvZDAmQotIkGjrs6/g3Fhh05ELEsUyXPcVBjNkNxJXOGF4uHbc2mKes3HRflbHSobbIKV3POs3drj4tkLgAWhoky/3IrmA4XrTDs1thaa+RpHuSzc2oBnCHFns5TicmSyB/5oTfYEF7BFOdrwjj7BF8C8/8AMuevIN4vbWQtI1omcyeQahYiy7525Z/Bz8Ldokngh4cMtA5Dpn5l6I1JA7OpJkw==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=NF3PQXue; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::531; helo=mail-ed1-x531.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=NF3PQXue;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2a00:1450:4864:20::531; helo=mail-ed1-x531.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3fw64XbTz2yLY
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 14:29:40 +1100 (AEDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-6afbc363efeso2852184a12.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 20:29:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791862177; cv=none;
        d=google.com; s=arc-20260327;
        b=g/8/pMp02rVBrUpQ0vWqOTxEbpCFZKQvML6ueux7y6DQbix2RsmHBwb5L5OpHa3I4i
         V/7mh43pL4Y6VviUJYTRWSqfFv2zDAZ4TsmAt1enBMG/mgH3fqdmgekEhABpPEu4p9Z/
         aPUPj9Zmj/SKNXRrCRRdgqxrg9yzKQz+cMpBJv39GgMAb1HzAA6ZAVyWMeuJQZCguz9z
         wsOGYYzK3XvNYKx1u78aptZWQVQUmt9XpZofKC8RcYchJo0dlgYAui/oQwI8BDvJJK3H
         RvlCeybO9LZ14c0nG8SINJL9mDKTqonMxzRaZZXRsftkZCQwRaSYaKX6ETW7uUUheFup
         xqjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Ov5sd7UEltON2XCXxeeAfnk+dnRFhC/otLkRbcqOuwQ=;
        fh=399eZN+p2oMWXCvOnre8cDd9laKI9nY4UEPe7E5UVRo=;
        b=gZ9g9he3KGStL3Sp9ncjUFbjE6ET6m5oTndjE+8XhtxwrkhglxTWH7Rn8r71+XIK5r
         VZgqrAWkal1AJkRJcP70O0aQEeH/yXELk2d+VgOEJ2DWqH9cp2WthajjG7KtJUueR5qF
         on5ypK4VGmXnSaR9NGOQzlwWLDtDPWivjurEsSZxNXvrFLJdwk7z1RnTiwv/woiofbjz
         FMDgo19c7A1R4uPD3yLQ4l0VW5dgw+52yoxTzDhO9HjcNYQq+tanOmh+Ir4Nt5rk6hHb
         NdJDhErOXHYHFnSRgPqEro29Kn50YNV/Fg4LJhXBo3L61gzfU7W5sV4s/jEKb3REfog4
         0Cxw==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791862177; x=1792466977; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ov5sd7UEltON2XCXxeeAfnk+dnRFhC/otLkRbcqOuwQ=;
        b=NF3PQXuevUmj7H8YAl1G59MiSes+D5H6vuaw+YzXSeGO/KHA8UIl1anIme4o21FuLQ
         ADcjYYGoRApf35c9KMKuXWXoSX2CpOo0B4LS/EQWoEdg6aPKK8ehncWnxjjJeNFZZbGo
         MHEqHTNnNk1sjrq+IDw+qKpKkl9H8TV6XBHlM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791862177; x=1792466977;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Ov5sd7UEltON2XCXxeeAfnk+dnRFhC/otLkRbcqOuwQ=;
        b=LDN0sTfmEuL6Lz/mGqAI/R0VdxhcZRzuzmuG+nOE/hh0twQrQAd05TsxJ9EXenk5P1
         +7MllYcGr/CrGRj50gtqkILXr2ZUCzxil1HIiCXUonEeQxOLODd6vbhC8CSZiGlFdQs3
         KarujUJicBefHjjfqglmtM8yA4sOcF9k7af6I8Nd1NrqTeT1OSd6Y+oQ5BPiKOvNhOMX
         kLKV3rNWfSkBWm7MMqf9fz0t4xeM3EwtvyJzxFLZEMxHGfn0c8h6/Rz7WaYTm3DO9wWe
         cd9ai1Kf9KCLg7SMR7C16cDjI/nMHLH89w7RrHOBly+6QzKWUIwcpMsSpPfylzU+nKpr
         gjdA==
X-Forwarded-Encrypted: i=1; AKwUvByV3WS1hninkisqrgDBbYgXDmQndp3XCxOIgT11TkDK9gz8mCMW5prPO/4n1aHx24RpxMAPdjMkp3lP1Q==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYLEzK+vUTzs7Mr//vGxLrahAYBmuFnS1xjngeID2YNgD+pW1kS5
	rFngxy8S432WKeKRwLGsmTZuetpCPnzTrxyxfq7rJVUCZ6CWgfPWu6nZeZCVAb5SkhIMkeVbP+e
	vR53YA13FPezK2DtlUDF+1r9WFD1wk4qUi/41Tv63
X-Gm-Gg: AYBFou3zAO1QxntE8YWWM7SkH3ZNXRIjrIfCSw7L//nuJsy+3aR2lvfnZRufWK3SpV0
	iK2OgIRHc2eIlX+jCwUND4pyKdqlpKJxsW8OrSjBmMzFkHJtipTYKDPs8b5m3PH3wGO19xKo7tt
	2yCQ5VS8zPRAOZGiWbhUEwGJ8kgpKfL5CJD/swCDvxA4wQjisSeAHtaMNBGYXDt0SK+GrxHLXxj
	LlcQqwNHCIKhj4vS2ssDYSh/rWKudYkfsuor1kVGrXHepmOI+DVVFzm4b/iW3k27jf9CKe5bCVB
	BUECyZbBGxOLF91F6qvt8reKImOqvWCJGN27OMcUUhtN2J7lIilcpILZixyJm70DVpg=
X-Received: by 2002:a05:6402:46c5:b0:6aa:9fd4:35fb with SMTP id
 4fb4d7f45d1cf-6b17c2a3a96mr7674418a12.8.1791862177462; Mon, 12 Oct 2026
 20:29:37 -0700 (PDT)
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
References: <20261012140048.214059-1-heinrich.schuchardt@canonical.com> <20261012140048.214059-2-heinrich.schuchardt@canonical.com>
In-Reply-To: <20261012140048.214059-2-heinrich.schuchardt@canonical.com>
From: Simon Glass <sjg@chromium.org>
Date: Tue, 13 Oct 2026 04:29:24 +0100
X-Gm-Features: AclHuK9Enk1cPH-G0431jhOG7sJwzObWyvpg0E85X-2iTH5dV_xuQDuOrQtlEKM
Message-ID: <CAFLszTgOVwBQ3JYeahw8jXw1_+Ng3N-sLCY9ELtpGMJuodXhxg@mail.gmail.com>
Subject: Re: [PATCH 1/9] fs: move struct fstype_info definition to top of file
To: heinrich.schuchardt@canonical.com
Cc: Tom Rini <trini@konsulko.com>, Simon Glass <sjg@chromium.org>, 
	Huang Jianan <jnhuang95@gmail.com>, Daniel Munic <v-dmunic@microsoft.com>, 
	Tony Dinh <mibodhi@gmail.com>, Alexey Charkov <alchark@flipper.net>, 
	Vincent Jardin <vjardin@free.fr>, joaomarcos.costa@bootlin.com, 
	Aristo Chen <aristo.chen@canonical.com>, u-boot@lists.u-boot-project.org, 
	linux-erofs@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"

On 2026-10-12T14:00:39, Heinrich Schuchardt
<heinrich.schuchardt@canonical.com> wrote:
> fs: move struct fstype_info definition to top of file
>
> Structure definitions should precede code using them.
>
> Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
>
> fs/fs.c | 86 ++++++++++++++++++++++++++++++++---------------------------------
>  1 file changed, 43 insertions(+), 43 deletions(-)

Reviewed-by: Simon Glass <sjg@chromium.org>

