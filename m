Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A85CC3DA7F
	for <linux-erofs@archiver.kernel.org>; Thu, 15 Aug 2024 17:33:36 +0000 (UTC)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="::1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1723743214;
	bh=B6SvPk6k8eQwlac6xAyfgf+HUTQZsBAGxCgYZcLkU1s=;
	h=References:In-Reply-To:Date:Subject:To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=cCd3gA2qwIjNAu/xcfIrUM1tyynNbaJYvdFewl2oHh2VlBunwePBLc4ubFw7DXAM2
	 JQVsErI/5+e2mJjQe5eT+cb0VflJIEsq0l8N3oHHIm4O1bs1EhvoNzcnJqgek8kk+w
	 x+VbGRirVuGzUSHXZH366jG1ZqT+m8FvcY7ZhNy2uzFCsIqeqqU463UGfL3mqnXG56
	 7GqvLW8xoXwgz0Vb7NPNNA3IJZ+thvR233WuLlwaLD/EoVmqMcXsPVbXQdfq+Lvv4O
	 Jlg9jNO2TguSYZoqrYwDYh5L2CE4Eqlb/9yUCXKzsroihvsakes7MFD/t55WUPh3Ou
	 MSJZ41Qb911qQ==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4WlBzy50nHz2ynR
	for <linux-erofs@archiver.kernel.org>; Fri, 16 Aug 2024 03:33:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::335"
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20230601 header.b=LXdPvs3g;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=google.com (client-ip=2a00:1450:4864:20::335; helo=mail-wm1-x335.google.com; envelope-from=dhavale@google.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4WlBzq53K5z2yZ7
	for <linux-erofs@lists.ozlabs.org>; Fri, 16 Aug 2024 03:33:26 +1000 (AEST)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-429e29933aaso7835555e9.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 15 Aug 2024 10:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723743201; x=1724348001; darn=lists.ozlabs.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=B6SvPk6k8eQwlac6xAyfgf+HUTQZsBAGxCgYZcLkU1s=;
        b=LXdPvs3gdpFZpqDeCe1dYX9FkdOZn+iqXuqrfyfYXKTlU0OzVf/R1VmakR8WL7uvxF
         CNEmXTdeOJnnMT2BX9Sl88LSS76Lgyjzed2nPgqgO12mHMgsy5K1FfEbDDAa870Tsi/Y
         tEuWxhT6RwuTUOI9jazRKa0whX69GhENJbF+f0ym18At7NNlzXUsPUR3xAWilzZcixOQ
         JA+fX310m2jZG9mzXzSkBBmwYZ9mHu5ojG4mVOr8eaZs9TxAtST+qr0hN1OggkXCpLtM
         Zcz76BUvnxNKyviGVaJmFVuKsjT+MpHQC+9SZxD8uAYc4pXHbWY53l/szcHxR0vtL3QC
         hNyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723743201; x=1724348001;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B6SvPk6k8eQwlac6xAyfgf+HUTQZsBAGxCgYZcLkU1s=;
        b=k8TFNvbKu7zFjRmnzPKL5moyT/GyOFvykXkOeV4iLcarMCJrvr7/Szpe98XcqieQdj
         yw/xst8Mh3RTwTQxeAIxGaiU4ScWTh3fEKTAFlUIRYbEteK3CFw1QlhI4eZRpyyaMyx3
         JR8jIbPwhotgXAtiveqZpwZtISjomlb6dm8y/pkO2qMbFhvefQQiCc752TYp30ZVaEgP
         HdtUCbQsFIdxTqUsQLL6OZUG3+r09Yo9lSCbTW39he0JSNIuw0bhyLPoOvQPNeFUq17V
         MME8e+5oodO7EMiBvwLXEAD9wO7aCwrE+Zmax+Dg7bn5rsjLmA8Nz8RcLFYR1bpUzTYg
         eqgA==
X-Forwarded-Encrypted: i=1; AJvYcCUqIpTXTYGbi2xKdzK+Kd3f6sJgTO07Dr9Ul2AS/DgCXfKtf/siCz9ex+x+D7xRYGxQKZJnkL+AczvypOT6kIH1mP5EBYZ0hR2AXgRK
X-Gm-Message-State: AOJu0YzicBbsr5QJxG0IpHsr280fjx3wu7zRl46JiivLgzov3SJdhMSQ
	L89T/eS50Pw6HOBY4fEhlLIoVVaukYLH7DEevJMGPDpNz9e5APixuX7fMEuOUdbsN9CcFvfEsfF
	gnEuClMd+K4Bot3BTqcMq8DC+/7BlU6wMFVWn
X-Google-Smtp-Source: AGHT+IEIZQh7IaEqJsqxbzpSl7b+LHCBFXJZxwUc5KAibQ6tql5CIKETHcGJbjBU3gqP1fXTixFm6yctQ9N9Muv3w28=
X-Received: by 2002:a5d:5a15:0:b0:366:f041:935d with SMTP id
 ffacd0b85a97d-371946bcb41mr79829f8f.60.1723743200452; Thu, 15 Aug 2024
 10:33:20 -0700 (PDT)
MIME-Version: 1.0
References: <20240813102723.640311-1-guochunhai@vivo.com> <d6f177fe-0263-489b-968f-189a923e089b@linux.alibaba.com>
 <52c4bcf8-dfb2-43ac-9b94-91b4bd7821ba@vivo.com>
In-Reply-To: <52c4bcf8-dfb2-43ac-9b94-91b4bd7821ba@vivo.com>
Date: Thu, 15 Aug 2024 10:33:09 -0700
Message-ID: <CAB=BE-S4iH-+JupZ2N=Z7phx0E4jq61oq_GGbY16BdnWd95c+w@mail.gmail.com>
Subject: Re: [PATCH] erofs: allocate extra bvec pages from reserved buffer
 pool first by default
To: Chunhai Guo <guochunhai@vivo.com>
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
Cc: "huyue2@coolpad.com" <huyue2@coolpad.com>, Gao Xiang <hsiangkao@linux.alibaba.com>, "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

> I do not have a good number for it now. While the modification is minor
> and without any side effects. I suggest that we make the change.
>
> Thanks,

Hi Chunhai,
Even though it may not be easily visible in comprehensive tests like
app launch in android, probably it's worth trying with microbenchmark
and profile just this small function/path to quantify the benefits.

Thanks,
Sandeep.
