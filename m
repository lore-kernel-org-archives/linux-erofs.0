Return-Path: <linux-erofs+bounces-4055-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0B10C55165
	for <linux-erofs@archiver.kernel.org>; Thu, 30 Jul 2026 12:49:43 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h9ptt1fdXz2yDs;
	Thu, 30 Jul 2026 22:49:42 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=202.12.124.149
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785415782;
	cv=none; b=SMo59BNOF4s4KEyKXjA7wpwji9xTM9hhbmXjkIsZR2WYfw1TTz0Tb/LSVBS3VGjsA+vcyBizN5eRunpHguZFhCx0fP877fHo0K+R3yRYGm+c78peBCBAVpyBoCcH7HTOrqTjfpV/FhlPUN58ySdjVWeL979TvtA255pXBUurgqy1SOF2ikzoCKVIsOd0MnylwFTA8NYHwPReHGZRgIBULDzd4Rk0utsCNOQS1CchdCYjypbVi3Dr4KiDEJd3ffVw2YLcfsngttx+JRRNLqTJ8uICL4jZKI4ZRHLL9xRig4P7tf42+j70xnvZllH9wGfwVMFXxv4v+VOeIObdEMNzVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785415782; c=relaxed/relaxed;
	bh=pFIRzIr1hG3HLAm8/4OYgDP05sTVurN0+cr0OYZTuRk=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=FL/12DVRvZF3vmGoVUFzsxnVB2s/MsvybmeuJApSEi8bmMeT1CInuzeZ+FP6bxBB/3gskzBxH/BIHgcm8FTtbv+Wk6pM1JD/Jt3eRU2CltDiSz3Y4ynFalZCyga7KKE0Kxf0IXYlrx803FPRN8wzrICzxVDhJ+VlzDYzPPQnhBd8deGpSa5g0NcoXgSRS/fBS5Y8fKHgd5u3awQ5IS7miFGGaPFjnGSjAwfE805d8eXOy0Z7LXW7h1R4rY6+Y7AQv3TbtHH1E498FTUTVjcpQhTzN/xh2mHydDiq3BsBoND3xIMurfbghAenYI0BGl++rP2o4CObG1tItgHIZfZurg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=verbum.org; dkim=pass (2048-bit key; unprotected) header.d=verbum.org header.i=@verbum.org header.a=rsa-sha256 header.s=fm2 header.b=f1qc/ghu; dkim=pass (2048-bit key; unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=RxLpXTkS; dkim-atps=neutral; spf=pass (client-ip=202.12.124.149; helo=fout-b6-smtp.messagingengine.com; envelope-from=walters@verbum.org; receiver=lists.ozlabs.org) smtp.mailfrom=verbum.org
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=verbum.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=verbum.org header.i=@verbum.org header.a=rsa-sha256 header.s=fm2 header.b=f1qc/ghu;
	dkim=pass (2048-bit key; unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=RxLpXTkS;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=verbum.org (client-ip=202.12.124.149; helo=fout-b6-smtp.messagingengine.com; envelope-from=walters@verbum.org; receiver=lists.ozlabs.org)
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h9ptp2zGpz2xnp
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 22:49:37 +1000 (AEST)
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 722FC1D000B5;
	Thu, 30 Jul 2026 08:49:34 -0400 (EDT)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-04.internal (MEProxy); Thu, 30 Jul 2026 08:49:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verbum.org; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1785415774;
	 x=1785502174; bh=pFIRzIr1hG3HLAm8/4OYgDP05sTVurN0+cr0OYZTuRk=; b=
	f1qc/ghuRdPH+USdxFyPKaVvV/V3o7Yue36hz7nlACO23SoRIfgsZ5yncFuS3giV
	tyozvxXH1xrzHkQtvx/FGnnoCuyV2+pMtEC6g81jIJPX6kJPTibAWYx8DeSaxWXu
	eRAiocWqzFP9L5ViM1hXWmjWqv0Nkuh//dH4WvLxvzJxyTI9Ta508gXDvzgugMQ8
	5asqVd4ThxfTi8dM2vGtiu+RBqDgFb1rELuGqmiWHvweUOyjVQwyfz0vRnhgoouw
	x7rlleKM7fnyeA/WCSFyx3/FkmExl4skXxUmUvoOSTjouuxWw9e/4NoV3oPpeh2j
	WeXtK7IHm2TDY8lPiL9qtQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1785415774; x=
	1785502174; bh=pFIRzIr1hG3HLAm8/4OYgDP05sTVurN0+cr0OYZTuRk=; b=R
	xLpXTkSRiSPMoOpkZVf9Zry1bOLgvqG/LTS42h7Em9pWEmuafXXvVuXlDq7+qxn7
	JDqd2CYr/j8n/x0zwMDLYx7LjFWFOscL3A8Iz/yAjIamvmGtgVSXG1d8k6crtduS
	tAil7biqZctLLLFAbDmqxu02DLjFe7dlB37GiEvIGQE4HKr/9WEh4aWRtk3Izsal
	Na8b1rj69wuHrlSAw3E2+p9+iVWWerscMUZ8RdRiD2DbnpZDMBCqCIWy2LAvFnwD
	1bizkwb3yL6Erf22a1VFCZVc29HU9wJEKoiXTeOTtgNGqOJwr00rElboA1AjCTfo
	2IR4pT1XLq+USaqRJ4g9w==
X-ME-Sender: <xms:XUhran0-ZGhWVaio0x897qStnnP5dPDx5JZ1nflB3qv-YX17hsLmsA>
    <xme:XUhrag69nV_BHFhux3ATqQBiL3pkwG_gsoP_ScTJhHq9PJuOA65H3eKovYM0J6jJp
    FUbH9j3BkzUiIKC_cuMNmTp6GAZ4aN0xBYB92A0bUrnppdWHX-1>
X-ME-Proxy-Cause: dmFkZTFCvpUxLszjvf5XC5TdTE86RAXjQ5Z6oiIFTnP9DSmvwr7JbiHyHgb7E+weDEZLPC
    gRpfbgUK3ejglRv9Q/hSmWw5CWEu7hKmAVlPwYW9mum7CvX/MJKLlCtlaDfvH9rQkIkFQ4
    8gcqAq99O+DOFuOPywhv836mTYObp34fa1uBGqEyVR1cqZxGX+m4LIKPsVJKHoiiBRtmKu
    /sNXmah26bwIdOxeDuWWO7rkvineweho6bEQ44/ETnCUu0E7+rYOY4XiCSxcXZvfQuutdt
    QGM2304rAk4bw1O91maX9fYIR15RSKRHvxM6CyqfkYN6cbAZkJi7qc6s+yJSmOMLP6UGUR
    aHidFeLLPFZVd/Vn0gothlBvdxAqZCPGKzioPhpNrYgGdVHOHqcrox+KgPWBCwYhGLKIAh
    MmsOjgIJLGuTbujuK/g7zQhm8apA8z6Ce4W9+jMksmpW/03se61HgbvthOAke8mNwwlu98
    CfVUfeOpWq4+E9UHnGVU5jnKdCj0ppdrumnl9W+ZzQW7neAAqPCH7F3x4e1pa9nruJ5Omi
    ttk7lomm3hbb5ada/zw7QJXvfuRFc89ebJHmUEBC1VR0c0P/0mIobKsfG0i4t/VRMOPRFP
    mPqhFHM7FZ1KtsoluYkX5cMDwuWrQkOi14g0b1P/vpFOCXptc5ZSMtUg9xeQ
X-ME-Proxy: <xmx:XUhrat7JbF6XDh5eaG59HvegrKbT0VEXRkfgxSGIGuWAfjMeRNK2Yg>
    <xmx:XUhrakSzvV9MLTQgQZapQgf15-PENOddNiIPPJYyQLL_l6oEmcvBjA>
    <xmx:XUhras-pgz0Yt94sw3__YvRgBx9mTsbLWVTwJHi5KNjhjWWrgqDtYg>
    <xmx:XUhralrFq8SC2dZJrDhVYsaoLlyWB2rHz2nvh5PWjaYwh6E7dk0eUw>
    <xmx:XkhrauEcmAhLy8n4ON4_b0Rrwyxs5qn_2cDI761JM8aggpxNSPdM2-vo>
Feedback-ID: ibe7c40e9:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 94D1C780070; Thu, 30 Jul 2026 08:49:33 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
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
X-ThreadId: A_xwXSqtliF3
Date: Thu, 30 Jul 2026 08:49:13 -0400
From: "Colin Walters" <walters@verbum.org>
To: "Eric Curtin" <ericcurtin17@gmail.com>,
 "Al Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>
Cc: "Jan Kara" <jack@suse.cz>, "Jonathan Corbet" <corbet@lwn.net>,
 "Shuah Khan" <skhan@linuxfoundation.org>,
 "Eric Biggers" <ebiggers@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
 "Gao Xiang" <xiang@kernel.org>, "Chao Yu" <chao@kernel.org>,
 fsverity@lists.linux.dev, linux-erofs@lists.ozlabs.org,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 linux-doc@vger.kernel.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-Id: <39c6eade-510e-4210-b914-d5730b98653b@app.fastmail.com>
In-Reply-To: <20260718191551.1703670-1-ericcurtin17@gmail.com>
References: <20260718191551.1703670-1-ericcurtin17@gmail.com>
Subject: Re: [RFC PATCH 0/2] init: boot image-based systems without an initramfs
 (rootimage=)
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sat, Jul 18, 2026, at 3:15 PM, Eric Curtin wrote:
> Image-based Linux systems (bootc-style OS updaters, ChromeOS/Android-like
> A/B schemes, embedded appliances) keep one or more immutable root
> filesystem images as sealed files on a writable filesystem and pick one
> at boot.  Booting such a system today always requires an initramfs, even
> when that initramfs has nothing else to do; its only jobs are to parse
> the kernel command line, mount the state filesystem, verify the image,
> loop-mount it and switch_root into it.

What's the higher level goal? Is it boot speed? That's my guess, but this needs to be stated explicitly and I'd really like to see some numbers on this. If you're using LLMs to do this kind of stuff, there's ~no excuse not to spend the tokens to generate benchmarks and things.

Also, we need to weigh this approach vs "static initramfs binary"; AFAIK it has historically been pretty common in some embedded/appliance style setups to have the initramfs basically be a single statically linked binary (and if I was doing this, it'd be in Rust nowadays). That's a wildly different thing than the typical dracut or equivalent thing, *especially* if you're comparing this approach vs a non-appliance general purpose initramfs.

At least for the composefs case, I bet it'd be quite easy to get to that single static Rust binary, and at a high level putting that into e.g. a UKI seems to me a lot more preferable than trying to push all of this into the Linux kernel core.


