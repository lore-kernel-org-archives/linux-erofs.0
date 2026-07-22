Return-Path: <linux-erofs+bounces-3981-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C618AC44539
	for <linux-erofs@archiver.kernel.org>; Wed, 22 Jul 2026 14:51:55 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h4xzZ0dVfz2yVd;
	Thu, 23 Jul 2026 00:51:54 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::52c" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784731914;
	cv=pass; b=bKzY/nXk/hDdgZjJLIMCXYza4oxcEdLAoa+e67weOyUdLd1T99ULKv/bY1b2z1OouIodO5UaFBjtjj8h8RPxSVJRx9vlzAsxudzJZ0w/MeVc1h9WREsFLRTenNbz5SnkSWCn2P7OUQ7MlW1rSr96x6LpyDhAQjFaEoBrylmjFEe4XviYMeePfxfzZz9tpGfqcmZp880xCHuhRKOpknw2yocka2CHdkObfueEDPUpNSJ/FOXoLhtpt+0ArhgST9Bi3z3t7jIj4f5GwD+JrTNopcImVMU9FmsY8X0f0ukmR03BJ82EW4rVnshbcac/+3ORZwpYHX+S5rxpR+jBeO5wDA==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784731914; c=relaxed/relaxed;
	bh=+KGIjEyMqE/ArpiMuHGmGvt5tD+DXkhxxitb3c1zV8I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JxSNTC+1N72GtnaYMBhZgqvHEtDldu42YsFO3gXbuo7b0bzb0kdsYADO5AmaQd8GwgQgcdzBtkhrytQJGal8O2JeHQEwHMa9ftsSrm8il1VXPF8wnt2z7G7Gp2I5So1b5ZSXAj46CBbk2KKDI+ZcDxBSvgCD3s9mGYXbcwry61k4PFzDPTvR4hQuXvUbE+OSZBrLbJdbIDZY0mS2naHSW+9nXDx61F854Su0Wx5n8JJb1kp99GMj1pMrg4muSGnAGVdcJNlDJ6ZL/01lIrAvRGL96H2RcXdygdNZGA2KguybUQ2wcN/4i3JSEq6zD2s157vgtqqnHelpHY6S3t2rJg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; dkim=pass (1024-bit key; unprotected) header.d=szeredi.hu header.i=@szeredi.hu header.a=rsa-sha256 header.s=google header.b=jry//FLa; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::52c; helo=mail-pg1-x52c.google.com; envelope-from=miklos@szeredi.hu; receiver=lists.ozlabs.org) smtp.mailfrom=szeredi.hu
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=szeredi.hu header.i=@szeredi.hu header.a=rsa-sha256 header.s=google header.b=jry//FLa;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=szeredi.hu (client-ip=2607:f8b0:4864:20::52c; helo=mail-pg1-x52c.google.com; envelope-from=miklos@szeredi.hu; receiver=lists.ozlabs.org)
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h4xzV2nfYz2yFK
	for <linux-erofs@lists.ozlabs.org>; Thu, 23 Jul 2026 00:51:48 +1000 (AEST)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-ca766c1c9ccso7647395a12.0
        for <linux-erofs@lists.ozlabs.org>; Wed, 22 Jul 2026 07:51:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784731905; cv=none;
        d=google.com; s=arc-20260327;
        b=bslMEYllOJNv8D/UvO2F2MX68fTvA1kCT/9QYLXaVOwFc6UefVDxJZG4tUIEFUxHt3
         fVOQVKHdAxu6WaNKi0tCCCZZ7LPNYwKDFwltocJp52bU8q9oMywxiV/arXlM3Xwh12pr
         MPKEPNyijjMFfGvtY8NwwkHktEKBqt0+ueNXYFqsx5/wQIh9RoF6+xLJsok/RAtz/s5d
         ZTQ7R6bQ8EMKJF2lm+KrYvsEgfkR2lIE6zR/T9eVUQjgoh2Hoxr1uh4Ap4lMGbKo4krs
         A51Hw02NecVEf5bibdEfqIEeDFl/4yNtiVk7KoUKEsJui3U75eaNGpePubXsC2Ai+4Ve
         Ltlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+KGIjEyMqE/ArpiMuHGmGvt5tD+DXkhxxitb3c1zV8I=;
        fh=13j+jPm79SEGnSO701iTsvd5muyC0uu92BNjkSMhxbs=;
        b=DEBUBK+xB1VK1Fgx9mMW15gKtjrJPyXfZ5KN+5ffnTF+0mQx9d0Uc+8/1yXVZLPjPk
         1M3v8P8ukHumx+PnGvRipdMtgoS+H9LThl44wwhQEQ1W9glQjh18X1tgF1Ss1yKwwXbv
         4tR474GQJMvRI+GikeBo+4dye1Jf5O0mmMAajMBtLwCiwnrpdZQnuqkisQL+r2qPOzmD
         I1vHRwn8Pqtb/se9jgE1aZZEMnM5n3720gW3pp8FmnFgGUu0vKZSkpztg3E37D3JMSSB
         gyNBr+pwjbg9wgUNIF51C/TsMfMKf+F379K7Y0+kXMtkNKGvku0Wm11z4ThucFh36xUM
         d3Ew==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784731905; x=1785336705; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+KGIjEyMqE/ArpiMuHGmGvt5tD+DXkhxxitb3c1zV8I=;
        b=jry//FLaVZg1J71IZ+/sZ3QSTEGwLtaifhqkbO9OGsP30yTkvF7AWoM2cy8P1NVl2L
         SOczwDPcniaNX9cvOeHPAxJvk8vlTpmx90g6qSwUqmk0iupFAhwH/0DLMXvrzGr7LXsg
         p5cM3h+ODR3OXpi6aLlRgtl73Mh6uA39tnsDA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784731905; x=1785336705;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+KGIjEyMqE/ArpiMuHGmGvt5tD+DXkhxxitb3c1zV8I=;
        b=kHvoJ8CouVUyw0g5HqI5qtGQPAHBbevHQNkIp8k0eg0Bwf2HDMQrJuX0+8ngQa9jRB
         /f3eje4n09S4Kyak8Bo8WLeLmKGcwAftwVi0TDfhQOsefK6ve8m8LYN0bzBzuEoBJ60u
         q3TW7Dp1469iy7POTsCYkqmOdVaAs5briv0cEwN5tkX0Gub7018ZhgAcd6nJ5hUzRGCw
         udv3VD4ueeXujwmWH/FOQf6KWJGmIWCP6BvWHqYVjhlfxBadnzifKgRT2u+NJ08JI0wU
         bquFjK0o4QsDccDM4t/Worgu/AV50UkEy9IfM9pTzoyCMzi5+sxaTEsnlYwmrYuHPGqV
         veVw==
X-Forwarded-Encrypted: i=1; AHgh+Rq9l9QVv9E1t5ocfclS/U8FfQ9uwVC3Iz6hQWQOorfoeyYJBcoUOh9hfBTvORmmuzzB2RbDWKbFL5yvgQ==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Yyn/eOT7c6G9Lf0whmREiXwzAYyUdiu4u0IEgzDcA5rcSq6KL6Y
	96Core/Lel6gxB7BwcnGxb5UvFBj1AKpNoWTYMTVNP+snB38x34VK+hnHp3tZpSLgfST+9ICmzV
	cKAgv3Nk3k4g28Jj2TXaovF5a8YAnjBTak5/RTCv4/w==
X-Gm-Gg: AR+sD10lcXFNu84Fzj4re+v6nsE1GACjwT5f0cIETrBwFj6JSqflktCzoMzJZSr6eVu
	NAs3EsjBp44M4dynanV1ArySp2NVqVrpJIlFFBSI6zafOpw6PEbi2HbI9JMXUCKFeIDm7mplL1y
	1iPKl/QfNRRlH7GgHvu50UrqUN4bqBwza+scC7aQTHvTgH0PwU3uXjxVfxlLrGteszmnJkbg94d
	U9a5JXZJ4dk1wrRZPI9NasQuNPASVqhLTVn7zT29iOeeFQwrQL3/GmTwejUI/I9UMyggs93SJmw
	LJSoha4VK61+F9Ia5Q==
X-Received: by 2002:a05:6a20:d492:b0:3c3:a1a4:862c with SMTP id
 adf61e73a8af0-3c3ada53e11mr26768547637.68.1784731905213; Wed, 22 Jul 2026
 07:51:45 -0700 (PDT)
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
References: <20260715101107.973997-1-mszeredi@redhat.com> <CALCETrXYHX+OSwm6vhzQqvdk9Fkbxzh_dGuVm2tjvPJG_x1XdA@mail.gmail.com>
 <CAJfpeguxCOw4cURjPVOMj5-A7JnLrmy8zx4qE9uwxg7x_Wr+zg@mail.gmail.com> <20260722-erraten-hinblick-erlesen-2520fd1a3726@brauner>
In-Reply-To: <20260722-erraten-hinblick-erlesen-2520fd1a3726@brauner>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 22 Jul 2026 16:51:33 +0200
X-Gm-Features: AUfX_myoOxogLBx3AVNQWfe_n3afhoBfiMuTAn8Y0Wpj1xcWwQS0hNa4Avph51g
Message-ID: <CAJfpegu1mzQGQUvRTqLbNOp4B4_QqddUnXyQFs0MLuNFa4xAoA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Christian Brauner <brauner@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Miklos Szeredi <mszeredi@redhat.com>, 
	Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>, 
	Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 22 Jul 2026 at 16:25, Christian Brauner <brauner@kernel.org> wrote:

> I'm still vehemently opposed to stuffing more creepy apis into procfs.
> So this gets clear opposition from me.

Let's try to leave out loaded terms from a technical discussion.  I
never said this was creepy, Andy was qualifying the O_ALT thing.

Other than that, do you have a specific issue with the proposed interface?

Thanks,
Miklos

