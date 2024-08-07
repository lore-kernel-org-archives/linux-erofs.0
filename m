Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B613C52D73
	for <linux-erofs@archiver.kernel.org>; Wed,  7 Aug 2024 18:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1723057184;
	bh=7342bL6XlId672ZUmqVGLoIQV+uvAdMIHD0PWaxvgpM=;
	h=References:In-Reply-To:Date:Subject:To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=REfemmP9Caw1YWusaWksOM0gsN35N2MqiA4Tbx6co9esdBqu6brT4kIu7h9nAGhH5
	 p3LP8UvV2X3Z60xHwwCyf7HwG4sGBUGTplesDokOrVmP4Xs8BD31nnjGYHbJgMpXZP
	 Ds5TQlNmf3SbnAEiWzEx+NxXuoMpHaAdMLRJWkZwBt7aUYbaKuGRZvQweEPFdLokIy
	 irLK8g38+2vFmO66kcfytuDpxWwBzJS3YSKY/SH+3pAyMKt9B+kV+Dq5ICYlXe67qQ
	 VbKm4E820jaSxFB9gpRcMk4aSU/SounDU4WKW7h3sXZSlsKf6/d+17HOvsdC5wPZjH
	 G1tcFpiIBYkdA==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4WfKH46Gy4z3dKL
	for <linux-erofs@archiver.kernel.org>; Thu,  8 Aug 2024 04:59:44 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20230601 header.b=jziZF86/;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=google.com (client-ip=2a00:1450:4864:20::434; helo=mail-wr1-x434.google.com; envelope-from=dhavale@google.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4WfKGy1YjDz3d8M
	for <linux-erofs@lists.ozlabs.org>; Thu,  8 Aug 2024 04:59:37 +1000 (AEST)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-3684eb5be64so88441f8f.3
        for <linux-erofs@lists.ozlabs.org>; Wed, 07 Aug 2024 11:59:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723057171; x=1723661971;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7342bL6XlId672ZUmqVGLoIQV+uvAdMIHD0PWaxvgpM=;
        b=HWQhE1nkTErrQF3Zc441/nz+n9mjWNXW6BimoXSfcRopsKBA7D545orInqJXRaB/ET
         jQF8XW+BRMZ11mvg6Cnfad3HiBq4psp8IOaG/xW2lF53pw+NL3DKJ4GtzzEXDxc3CamA
         bnOVzx60aYz8MnMgiSxLkw7ZWPH9oMlkYESESEpxr985v6xihW6CJn7K8kLMQJu73MKB
         4T1uqcO4rX88RUnwcssI1FcQffwnR5L8GzNQBQsD0dFv6jvr3UYxeOy3B1oxkGm3C1Jc
         E3nkdVhL9TwCh2AIW8xG9jmqaCMRJL04sVF+GmNf5Y/2kRiajByn1Nwa15w44xxlllR2
         DDhA==
X-Gm-Message-State: AOJu0Yxi/GXh0AMsRBiYmU0eKf3cWIhqdWWEUicpD03dIAR7skEPZiI/
	Ox8qQDY0IBrUE5Lfyrp781QIrCUnuebJ/RvUZF/irMJuoU4neJLrAPh9SC1qjrDwkNAwaCreo7j
	Y8kHGohKG3lXtIVeBGfKDhtUgBjNxhBDLkMrvr1jh3lnNitFDJhHC
X-Google-Smtp-Source: AGHT+IG9RyqDrVwzhw+v/TalYkf9vW1ovw37/YHTvZ2KbgkeHIs144E4vRejAaM6FY1GE1obzUwVIOAOLT+65PEEW+U=
X-Received: by 2002:a5d:6112:0:b0:368:5a32:f5bc with SMTP id
 ffacd0b85a97d-36bbc1b6f58mr12527102f8f.38.1723057170713; Wed, 07 Aug 2024
 11:59:30 -0700 (PDT)
MIME-Version: 1.0
References: <20240807085413.717066-1-hsiangkao@linux.alibaba.com>
In-Reply-To: <20240807085413.717066-1-hsiangkao@linux.alibaba.com>
Date: Wed, 7 Aug 2024 11:59:18 -0700
Message-ID: <CAB=BE-TaOjPHTGQye=psPTLPAUeD4cfvzp7NDDq8r1i83tUAGA@mail.gmail.com>
Subject: Re: [PATCH] erofs-utils: enable multi-threaded support for `-Eall-fragments`
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
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Reviewed-by: Sandeep Dhavale <dhavale@google.com>

Thanks,
Sandeep.
