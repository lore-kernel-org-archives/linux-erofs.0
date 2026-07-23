Return-Path: <linux-erofs+bounces-3988-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CFABC44524
	for <linux-erofs@archiver.kernel.org>; Thu, 23 Jul 2026 08:22:39 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h5PHx6Tc3z2yFg;
	Thu, 23 Jul 2026 18:22:37 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::82d" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784794957;
	cv=pass; b=jQlCpocV8j5fuLEw3HN3KikJawWElG5UWirxbksuQd211xp8I+HVCr6IUyqdmttPncbv2c6/IkJDMExPS+MVd2e76db5ZzSMWoqRY6VF/oZFWlLyFiF7qD+zpxSQAvmE52/yqyNC3m8Fm+IyizsOv/UadPQiZcWeCzGD8xWFYQbNjaMnLyt8L/XImlYCIf16uobkF0z2f2jhytasBS6K8gImmS7+CSFVhKkpDCL9aP8EWa1BpkDm21sRopi/yWBprTiWRO0zyFjJVdp7oQkQAeSuyCLdv8G++ajz5mppzk+wZlbYTuq9Zfzghyjoj99ZtK59J+aTf0tX3HyJEmMVnQ==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784794957; c=relaxed/relaxed;
	bh=yrgNUo4LIyDIRSBo4rDxodSFyTnV5NyKbJ74rO2CKL8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hVz9OQgcQ+/1sbY/NBGvXa4GDVZ3Lf2U2VeXeop8sZ38oBsXWoBNgM8FpEe7iy1q0KV3erp7GmDhpbwgfGVQibWemZSyr0+tKMBgjG2ivt/4vY9P6XIDfMlPoLbM26tVFhYnQs907xvOJ+wwxUa2Ma9ivg1LoTxZFhSvIHsrvDhhZ71Zl/+q5tsNzt3Si7p7DdR9Q301eDc+AoSxXcjlfDSU3qBbWDcZkSLfQdWj9RG4HXOLv3Y4DsHt2D6+IQt6sUl4vd+PRuVNS9IgooC3CvXS+IJ1tCgjBNmydpMwjKji8Sf2YGxNQ+dR2fyB8YUakIJE6JjtmbmYpS58pdR7Ug==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; dkim=pass (1024-bit key; unprotected) header.d=szeredi.hu header.i=@szeredi.hu header.a=rsa-sha256 header.s=google header.b=rMlb+LNO; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::82d; helo=mail-qt1-x82d.google.com; envelope-from=miklos@szeredi.hu; receiver=lists.ozlabs.org) smtp.mailfrom=szeredi.hu
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=szeredi.hu header.i=@szeredi.hu header.a=rsa-sha256 header.s=google header.b=rMlb+LNO;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=szeredi.hu (client-ip=2607:f8b0:4864:20::82d; helo=mail-qt1-x82d.google.com; envelope-from=miklos@szeredi.hu; receiver=lists.ozlabs.org)
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h5PHw6KTkz2xJT
	for <linux-erofs@lists.ozlabs.org>; Thu, 23 Jul 2026 18:22:35 +1000 (AEST)
Received: by mail-qt1-x82d.google.com with SMTP id d75a77b69052e-5218927884fso4901651cf.3
        for <linux-erofs@lists.ozlabs.org>; Thu, 23 Jul 2026 01:22:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784794953; cv=none;
        d=google.com; s=arc-20260327;
        b=BccNG8BvYRQiXg5LmeF6+nIZpO1f0BBqEr1qjQ7aJ6wzphQFsbm0BkE+ImICpsfpgr
         a7JdIcxVndnVAu0CpAdT1QSrYPKn4725rSTxAuetta6vykykw3aXSVBJcI3nbPtFeRyA
         biI0ZM+mdNhIl9C4D4BnMhYuIYewFlRVnzO/F+9IGoq3S6WN6q2Yx3rA9b9Hrxo2tXnR
         LQhe+gd7S8LuLYxj/JPc/81Y4ZPsS+QNsVF0Lc+czy28JL0UOx3b04RGeLbUn8UEy+Bb
         QYLOgHV+ucIHq95lLLE7MssTFRbljQ1q+cIu4gQ4KmP2QiQusqhwWmspbR5abkxNNDBb
         uItQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=yrgNUo4LIyDIRSBo4rDxodSFyTnV5NyKbJ74rO2CKL8=;
        fh=Olr1ZwW7sqxApGArjT4iuwiQCPN+gKKTX4zVnnnQMH4=;
        b=poTV7YRCrObOn9dWB3AvxMTqyJmogsXrP77mnqnoZtF/brJJdRibfuLh1ziVXn3wwT
         8f5Czk5fUXsNKQEl6Ef5hs3jYL/weKA6TRGeSZM/b477rjjaiNnHtd3jYc9IMB/oTfjh
         ukdjgNZRHD6OV0KLC13VkOZsoPEnTKWXYBbb4vHvnne7AR2AhRy87GoYUCC0smQRfvKs
         s6AsmhCVK2RV2Akyc0TUeQMUpJZV6yY+zDCgE3FHFIYmPRXmu4VyAdBkpPmDuoW6pm9u
         IFpdEYRb2QegCe5hKiESlTicxSthl4YdzF7iXQ3pyoYsNabFYJwxkCkPWOBsnQ5kHcOF
         H9TA==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784794953; x=1785399753; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yrgNUo4LIyDIRSBo4rDxodSFyTnV5NyKbJ74rO2CKL8=;
        b=rMlb+LNOZT+yt1m9GbpN+LZwNJAbTaj5Pxkbt5gtTk/Ln6d7u0XC7zvbzKdlrhOk9Y
         L2KOL1uRoXssWp2xEewnJCTkgvLK5YhZUvqFHSsUUOFTVMBYs7hDPth8QSsZvmnBiO/b
         KwePalUQk2DFBb15p/IUS6z6VFxtVhPUPXhAI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784794953; x=1785399753;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yrgNUo4LIyDIRSBo4rDxodSFyTnV5NyKbJ74rO2CKL8=;
        b=qbRnwwjFXgfRIwdfOHlhcv3u8huG3IS2VSnmB58768lIAw58nuuvsWUG9DSR75MdZd
         Uoi3vDh4DT++gGfkl3/R7b3XRGCGfeMoY5Sp5M2eEtDv+kcit20S/n3EZRyNUTopXKwx
         wgLOerH2T5CiA+x1EWyZ+mysdn0gkDiiqFl0SoWy+Rj7f120nDXiYGpd+DUdZkR4PWM8
         afudfHrbdUQtRCwxY1tn0qj0GCyRcaPnSy4NXDjZOjl038/fEdcVSNGMD05xs13h9/yl
         dBf9bX/AWAemoXUXZ58V7s8bbEK4vLp2bXqjv9e1pX0wM8vXyIK8TaNe5+K19E4ob+jX
         bsAA==
X-Forwarded-Encrypted: i=1; AHgh+RrR6xqTiBdeTMBEkn798SYIt14rbXBeQFq7fAqgxWTxulIkqu0oo4mFxuFoP0eEzP1Ti5UjQGRiKoxJtQ==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YzWEAMM72++XFG9EQzzXM++2gKcgwG/RzKwK0Hq0RjOLHwdfhPt
	APAdB42YNXF8pvoparkcGWVhY7p+VP3qv41V9jTUoUN8BI44B236+Vnp7+sBn5QpBGLThcUP3hd
	IobkHwNIdwiY8vmgm7VEBS6ujBROYiCa0LU0V1Z19GA==
X-Gm-Gg: AR+sD11F+j2f5FsdU7jxZftmW7MhHTs91U2jQx80LfUAEBlD2nXsuZQkTbrasxlz1MK
	vJG3F7autdUPo8NIML87+whpsxL1MN8VMpH2Jo4OtZeH8WbAaKb6AQYs7xQDvF0U8iP10wvm1c5
	OOMqd1e/9kB5GmvkF5SNx+G5Y9+n+Mq7sqAiZ2V6yn6yoNGn5423cR33JDI2fZBNDRyCOQjKn/b
	v3fCGs2MazfCALf04PbTWQ9LSPFFVGPIUNsgkgOu2HYBKo7c38GKRZ7epFolKDQETjW3r9oAEja
	u/q+QM7B1vSQqh7EUQ==
X-Received: by 2002:a05:622a:14c8:b0:51c:7b12:5fd4 with SMTP id
 d75a77b69052e-5283e012098mr18036511cf.80.1784794952935; Thu, 23 Jul 2026
 01:22:32 -0700 (PDT)
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
 <CALCETrU9KdLsvZzUE-5sh7KkP5-cPh=hwErGmN=THsDatFJLfA@mail.gmail.com>
In-Reply-To: <CALCETrU9KdLsvZzUE-5sh7KkP5-cPh=hwErGmN=THsDatFJLfA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 23 Jul 2026 10:22:21 +0200
X-Gm-Features: AUfX_mw-0nrqXevHRitoGqWVZtjfkA0y47FHySyo3TiICVfrOazHUs2Vr34P9VI
Message-ID: <CAJfpegupwNTaVNZtdQTmvtz9x=ehH59hzsRT7D0=VbhOZvaqrQ@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Andy Lutomirski <luto@amacapital.net>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <mszeredi@redhat.com>, 
	Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>, 
	Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 22 Jul 2026 at 18:36, Andy Lutomirski <luto@amacapital.net> wrote:

> Other than that question, I think I generally agree with you.  The
> interesting operations here (getting an fd to something that was
> previously inaccessible) are different enough from normal path lookups
> that I think they deserve to be explicit syscalls or syscall modes,
> not magic links.

This is a super specialized use case.

I sort of agree that doing statmount() as a syscall was not a bad
idea.   But new syscall for getting a backing layer, that makes sense
on just a couple of filesystems?

And that leaves us with ioctl.   And ioclt() returning an open fd has
it's own problems, besides ioctl being a generally bad interface.

And we have all these powerful concepts and interfaces for
filesystems, why the big resistance to actually using them?.

Sure, it's easy to misuse, but I don't yet see why this particular
case would be a misuse.  Enlighten me please.

Thanks,
Miklos

