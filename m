Return-Path: <linux-erofs+bounces-2812-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19FD9FED9E8
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Mar 2026 16:59:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZyq548Tvz2yhV;
	Wed, 18 Mar 2026 03:59:13 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::f31" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773766753;
	cv=pass; b=PNwDTN9w80pD7MCs26xiAkrVgsgk997yeXaczTH7HpIm9LaMIjgPVFnXa3pbD4YNa+OUED3VprNQEsV9mjjWCrjuevrjc2WaWGVk9UWJUJq4Hro8I1F4r+p4QZLa2O8pJMdtG1m4ACDWMv8VkaYWTY9XqlyxrSWDcB251Dc9SaP7yrJo1XMBAzg7rEQWGfMOwDrdEPIjD3tQ7SzYyL+q/xxK3C0Gd0xzzRH2fAdodXGjqpRX/v+0/ymeCEB1u0sduKsv0+9hvVwmTG2MMuAzJRl7qKFS8v0gwPNOPgiEASJC7FXevTLgk7aREXNbIuXXs+1Iau9fpDmJzh4DA0pHDg==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773766753; c=relaxed/relaxed;
	bh=eNTmBtxH8loCp9ozCtpke57x5DTKCyb2ChJvL4R17xU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=n6IPJNU/NLEjqDMkyyk5aj7A4/lnxwNLtgSsEew875Z5xxlZ7UbtNRT9l/rMv5G0YQLQOtiQeHGBcECcYA6UIEF2ay62bdHQUVvcAmklUyszTkpDXfwuseX0rBosRdF/3ldTOG+5ESwaQqqQLwgrsJjw9lJbWcUeLxg0n/x7X2sCJ1GeOjqN7ngbFhi7Pgu31byhE7KkvDme5/FlRWmpiAQkAiXozuJajJftcZor+Mk1/R7DgCp6J2kflZol3QyDRoy2k5JzFd0NoqtGEJDWWJiTfTnh2SohtlRhBejfjGN1G1Z69DebTJwWiej2iq8xqzV3yw957SImtqUdNxUDog==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=X3DblNrH; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::f31; helo=mail-qv1-xf31.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=X3DblNrH;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::f31; helo=mail-qv1-xf31.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZyq43mNVz2yFd
	for <linux-erofs@lists.ozlabs.org>; Wed, 18 Mar 2026 03:59:11 +1100 (AEDT)
Received: by mail-qv1-xf31.google.com with SMTP id 6a1803df08f44-89c4739376aso3710876d6.2
        for <linux-erofs@lists.ozlabs.org>; Tue, 17 Mar 2026 09:59:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773766749; cv=none;
        d=google.com; s=arc-20240605;
        b=grubPwCK++XWtozWZn4sA6HalXkrxNCdebWnts7N4BOVimmTXylXDU4TuQJxkCTvoF
         mCtXdLKjIIqUUJ0fOn8kBXx5uAYzARRAVcAhitHCiHCm2KZOMMvQaUASIcF2RUKqmMoe
         JetdkOurLahEJS3gm1TMSHLiwDKH8mVCrmrl4kk8Ic2aSZkgh4a8DCCEdM/7kQNi2rmP
         VUs+CnZUWpEOxb5pt1s5kasDY9OFRRWqiH+ugCQfi05aLSMW8KjENy6w999omtIlGHjl
         dc4Qyz9aVT/ZaB+Oaid02fvo1a2q0kB81kFOSTdWxl+Q1YY0hM8VFEsUI9V+wjy53umI
         T7vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :dkim-signature;
        bh=eNTmBtxH8loCp9ozCtpke57x5DTKCyb2ChJvL4R17xU=;
        fh=TNB7gxPMLJJQw88allq3+q3OrqBZh/WrWBhlQZUXDfU=;
        b=OyXpeYL6i5D/znMfK13OgRN/PKc1qnf4syo/6W3bUl1wHeybDbJFUusqm3cy1KF4ma
         txuIIuou846TYoKmIzBHlMQaWHraPgog4ZyqDY9CVr71oYnGkDU7ypUWQtInhbxMssa0
         k2QbmUzJsF2zX2ttpQh3dW3oLqGbFOEcil+6U3luYepO2Z0sqPLzRM19oC9wu2ofyJcN
         Iiv70XHx6WjgpfJ/jzSxDPbxV6egqk+XeAGv/ZLe3cRH5wRUShxkcXzNkEIY3oQC0vaf
         Oz138C1bQR4Ag4sNahJFFIApxawYxhyIyhvnY/PlC3rlPLUBo+C4RrNfEq6TL/fIIGnM
         BzaA==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773766749; x=1774371549; darn=lists.ozlabs.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eNTmBtxH8loCp9ozCtpke57x5DTKCyb2ChJvL4R17xU=;
        b=X3DblNrHPKWqrPvsOH6ABzoraro6MRnVUZeGNJPW2bN44zwWrzrcqICw2fZaQ/Pb4u
         v/5s56wFDe8p2CtfhDahrT6JRBvFMJ2+i86MN5k67gi6uJOSchR0HUCVWKuIsHsijTLB
         vGtwzZOeOlTlGBY4a91vQBLflL+c5nONn5QGaSvIznB8CKFxiuVdc/UUcXza+8lBqY0l
         uMtEC21UPVzQ/MAotZ7ewMFwo+AIx0eqGhgyAioU2cHSaj2ZWgEd67sNKaCmzogShxap
         m+UEn3h3nGr0bsw1awjuMsYSJoWHdlXlueze+mJlTxPULqqtQxrhKggkrc5UyCvoUOy+
         Npow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773766749; x=1774371549;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eNTmBtxH8loCp9ozCtpke57x5DTKCyb2ChJvL4R17xU=;
        b=CgQzxJAfHrCAsCVaE/z7Jonsa7Ii83m/t1TI2ofj/QIwCQQzKWHuuT8u17qNUuySqn
         5lV3nBiznsWWaL+ZUNJwHlDZpszT8aW/iNKX5JQRlKU7ROEm4aNCl/g6FDJ61f3OGYPp
         O1i0vAz220WWTHPnbo42LoQW/tziulKX52lxEeJJlRRZExy/QSF2IiF/IAmEgm1Z9f/5
         FX0OAjAg39kXxK4eW5XKfGOumSSpOcwfPt+1ppkSyXWrVCwRK29WhrJMu3BsGdMPbDls
         H+fdQLW1a9pRjkiFJE9UHuucfo9RZ87rqxOIiyQxQBwAUGfQJfZMO0g/Q4owQWtTQoV2
         ShlA==
X-Forwarded-Encrypted: i=1; AJvYcCWp5HSOGLunxazZUrDYbocyia/rXLyagFf61cyzr1BQVXr6/a3M2xRnNzLb5WszOidjA9us9zPq9GjxZQ==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YzR1ng2ai/nyVk1M6uBEOsHv4oY96om+Mfh3Kr8JdUHpRC1Q4kl
	bbadK5Ffui59B0sCWMZ7prRDh7bwf5DFgbg1lLQ5YSDiy8SBKnBjOQrlnbySfdRg7uRZzUXLc6i
	otUfswJaX3o8pGHbS8mfjgSTkQFOvBP0=
X-Gm-Gg: ATEYQzz5aPNUBjOrt9iNW6bChTbxiVyriFL90w90MjNoi1vgsFHGJ9V3eudk+JNq7ft
	TqNXKTnN2Xow/LBDQkSkfEEo01eem6kp1e5nPkaFog/mTXEQLfUGM25yFsDXoqerCA36WfmzQL3
	sZ17jsEk5CCD6iN04k2sVC2qVd6thWfj5LYEYS+mNxW0rwG2Yop94h6L1en1gbhk1PqrWAi+En5
	DjkZcetLUWWuvgnIEUVCldquRsXCMQ8mjmj+MhS/AQ3aF2aREqrzBoyzSacT6zSbgCg06p/ular
	qzCHyBNVK8SrUpXmAG9eAS58aeWi8ZKoMUv5Pm6waWiJTH6yHJVTPRDiuQPMHa+OIOPc
X-Received: by 2002:ad4:5bc8:0:b0:89a:7d14:66d4 with SMTP id
 6a1803df08f44-89c6b721eaamr2780386d6.7.1773766748550; Tue, 17 Mar 2026
 09:59:08 -0700 (PDT)
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
References: <20260317152439.5738-1-singhutkal015@gmail.com>
 <20260317164135.24892-1-singhutkal015@gmail.com> <abmF9Nn85cz35C1k@debian> <abmHBmJ1SjhHTuOp@debian>
In-Reply-To: <abmHBmJ1SjhHTuOp@debian>
From: Utkal Singh <singhutkal015@gmail.com>
Date: Tue, 17 Mar 2026 22:29:00 +0530
X-Gm-Features: AaiRm53dO23OEQExMq22azTh0xsL_xGJBUw7FBODWR6QPUn_a9Lz25Fi_VA5vDU
Message-ID: <CAGSu4WOop42Dh_7kni3uK5fsjB4zDRkqvVWyZ=+AqbXoEACCsw@mail.gmail.com>
Subject: Re: [PATCH v3] erofs: validate h_shared_count in erofs_init_inode_xattrs()
To: Utkal Singh <singhutkal015@gmail.com>, linux-erofs@lists.ozlabs.org, xiang@kernel.org, 
	yifan.yfzhao@linux.dev, linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000f63a43064d3b4057"

--000000000000f63a43064d3b4057
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

>
> Hi Gao,
>
> Sorry about this. The mismatch between the commit message and the code
> slipped through when I revised the patch =E2=80=94 I updated the implemen=
tation to
> use sizeof(__le32) but forgot to update the commit message to match. The
> changelog was also wrong (v2 mislabeled as "initial").
>
> I wrote this myself, just didn't review carefully enough before resending=
.
> I'll be more thorough going forward.
>
> Will send a clean v4 shortly.
>
> Thanks, Utkal
>

--000000000000f63a43064d3b4057
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_quote gmail_quote_container"><blockquo=
te class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px =
solid rgb(204,204,204);padding-left:1ex"><p class=3D"gmail-font-claude-resp=
onse-body gmail-break-words gmail-whitespace-normal gmail-leading-[1.7]">Hi=
 Gao,</p><p class=3D"gmail-font-claude-response-body gmail-break-words gmai=
l-whitespace-normal gmail-leading-[1.7]">Sorry about this. The mismatch bet=
ween the commit message and the code slipped through when I revised the pat=
ch =E2=80=94 I updated the implementation to use <code class=3D"gmail-bg-te=
xt-200/5 gmail-border gmail-border-0.5 gmail-border-border-300 gmail-text-d=
anger-000 gmail-whitespace-pre-wrap gmail-rounded-[0.4rem] gmail-px-1 gmail=
-py-px gmail-text-[0.9rem]">sizeof(__le32)</code> but forgot to update the =
commit message to match. The changelog was also wrong (v2 mislabeled as &qu=
ot;initial&quot;).</p><p class=3D"gmail-font-claude-response-body gmail-bre=
ak-words gmail-whitespace-normal gmail-leading-[1.7]">I wrote this myself, =
just didn&#39;t review carefully enough before resending. I&#39;ll be more =
thorough going forward.</p><p class=3D"gmail-font-claude-response-body gmai=
l-break-words gmail-whitespace-normal gmail-leading-[1.7]">Will send a clea=
n v4 shortly.</p><p>



</p><p class=3D"gmail-font-claude-response-body gmail-break-words gmail-whi=
tespace-pre-wrap gmail-leading-[1.7]">Thanks,
Utkal</p>
</blockquote></div></div>

--000000000000f63a43064d3b4057--

