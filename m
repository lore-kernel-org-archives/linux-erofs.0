Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AD26C48BF6
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Feb 2024 07:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1708499297;
	bh=L6zbD+r4iAQVkolpUdqaC5kdIDlOZs92K4PNPYeqx8Y=;
	h=References:In-Reply-To:Date:Subject:To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=eED+QxCWmPoXJDUXVpEZV0Q2CEYl3o4XCyRL4H4R0HLay1K/WrU3ynU7tJuTZ7jf8
	 IiHYhvt0gOGj9TOVSwmTZUtdzGpFyNmRW0HLhlov7XZXJ73lN5DSbwmuV1zReuP5hA
	 0y8g9crXWDvJPRYgIlpBKtWiVARcOdX6I4SEU0qwTt7l5movbxC4RmHaKKTDWJ4GUz
	 +Q2p9GscwhZ0mGNlI/zbJoyy1ytcR8tX9vtBPj4DbKVpg8fy5WhbPnAQqbToN9E8E3
	 U+9KaJdkyehSpz1Htno9VmReBqeWtnFtLA8f9Jmz0bu56nUhGJuiGJD8fz1TOshOSf
	 03durXTwZmT5A==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4TfnRj3hxwz3cNl
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Feb 2024 18:08:17 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20230601 header.b=ziY2Zdpv;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=google.com (client-ip=2a00:1450:4864:20::12c; helo=mail-lf1-x12c.google.com; envelope-from=dhavale@google.com; receiver=lists.ozlabs.org)
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4TfnRZ4tb2z2yk8
	for <linux-erofs@lists.ozlabs.org>; Wed, 21 Feb 2024 18:08:09 +1100 (AEDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-512b3b04995so321124e87.3
        for <linux-erofs@lists.ozlabs.org>; Tue, 20 Feb 2024 23:08:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708499285; x=1709104085;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L6zbD+r4iAQVkolpUdqaC5kdIDlOZs92K4PNPYeqx8Y=;
        b=gDJltsNWHKeBEg6Vsf6KOYiJdAY8TgddKgOURNnHu0wixQRYIOtD7T9Ga3p1ngMLd1
         0p/KRHXl44KX+P7KtN9YMdaVxtkcE5JoLA6DF4eednqEz2Jg9O7zOXTMMR8vGaWJ3/Rx
         EsYwDZvd13rWRJpdVtX5niWUQJpA4jYYGyvRObIhjrOOccIhbrYm3IU7jZQoyq5JrUxA
         uRq1q1U10UbvpIOJGqF+7FuvHIzxfJdMXuauWSiO8MZeihqiic96FA10VK/jUjFKxF/X
         UAZzzS1Rdi8a7IANe4ff+ThOazmXbqBef1luuv2QEDeULYu2/s4Gk7ehTQdqYgtq/04S
         kg/g==
X-Forwarded-Encrypted: i=1; AJvYcCUdQAgNoZ0Cxhrad4Vky8XUzM88iRkHANWZtSl04tCdrsdVKmSjuPm1gtdxQrkeuojPsZNVOA4je+1MsITArLlOZliaRLZ33SEFgw/G
X-Gm-Message-State: AOJu0YxN5tD0RSqh/r6OcygOauQudw4A7ep1/HmHQFLg4cyx4RQ6JGzX
	hpmGzPJU0+j8XtJn76xEJ5jgsTK4vA2KGJcTRL9h1oAeOCnVZZis90y8g+JdO1mtoPNPR2IiUxj
	28CWoEnyjo7b1pjJyis3qN9FB6hZSvXnJNavr
X-Google-Smtp-Source: AGHT+IHa365tMHI74PcJwpoL4by21xl2KdQYoT7uJGyPBKgsElto/rB7Qh2SvL3fkLhg7dgdD64D4s6+6hqom1eKg68=
X-Received: by 2002:a05:6512:2107:b0:512:d6ca:71ae with SMTP id
 q7-20020a056512210700b00512d6ca71aemr61918lfr.31.1708499284887; Tue, 20 Feb
 2024 23:08:04 -0800 (PST)
MIME-Version: 1.0
References: <20240220191114.3272126-1-dhavale@google.com> <6c2d5345-98bc-49b1-adc7-bcc349a0a6bb@linux.alibaba.com>
In-Reply-To: <6c2d5345-98bc-49b1-adc7-bcc349a0a6bb@linux.alibaba.com>
Date: Tue, 20 Feb 2024 23:07:52 -0800
Message-ID: <CAB=BE-Se6nO_VTncA9CH7k65xRPtyxo=xSH__i_OhV8++LfEYQ@mail.gmail.com>
Subject: Re: [PATCH v1] erofs: fix refcount on the metabuf used for inode lookup
To: Gao Xiang <hsiangkao@linux.alibaba.com>
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
From: Sandeep Dhavale via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Sandeep Dhavale <dhavale@google.com>
Cc: linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, quic_wenjieli@quicinc.com, Yue Hu <huyue2@coolpad.com>, kernel-team@android.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

>
> If it looks good to you, could you resend a formal patch? Thanks!
>
Hi Gao,
This looks better and more readable. I will send a v2.

Thanks,
Sandeep.

> Thanks,
> Gao Xiang
