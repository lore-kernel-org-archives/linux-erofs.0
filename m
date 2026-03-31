Return-Path: <linux-erofs+bounces-3133-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F3901061B2B
	for <linux-erofs@archiver.kernel.org>; Tue, 31 Mar 2026 03:33:12 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4flDGZ4v54z2ybQ;
	Tue, 31 Mar 2026 14:33:10 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::102d"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774927990;
	cv=none; b=i3mbH32sDCMf/ZBL/8Z9bCGlONwdtsXgATVX3RmVk3c6jfBXueKqW9+vqIAly3jAWs6y7Y1PK1zqT6q0cqxFvK0YvlU3eKFOoH40lPaEWLJjAOxK7hfHUE+2tL7CZBMy91V5ialibq1e7IgvSr28fLOt9FXK6Pxwm5wqAUtN5MbZ/jPfWVpvlped5cz5PQDMfw0leTmdc3KbZGQl900aJmBNWOAFrfR6rUjcvvXcQ75uc7gEsUQ6GcPcCdZ2cXKjlXUer3FqdTIyip8Z91LQawZgdqMy9b/VFgtADCrr+unzV1CILaPVVMCZLT5agI3UyUJI02DH3IYa4K2/g4fzrw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774927990; c=relaxed/relaxed;
	bh=a5728gVfKW3MwwJedBecCR4nLOtL5eDepwDGgOmB8Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZkKTKMyCQcUxJw1uuroRJeywxs5qMO7ua+AmKNtmfE7AG+FYeAQl0RDJ2hROwQy3pkqp3CLJzyRGtn/k3N5AJd3HdTXz35JI3zoVI43/LtYwToIPvShT3UZULNEcgPyVzs9s2ueHze0hnIJF/bha6+2DT+AGCu6cuD+VSJ6tHT8p+8z9Q/9Iz9+W9OH7T5VJJ8pt/hNhDQjYNL42MgW5HQFcmqttPKFQ2x1whN2OtQ4vRMrAsEAZsxl6aMA1tidFDs0BNLYw97UMAjNg9flra2HrJI2NpledmuYe9TDOUEDRF+SHTzI1guX8YlqQ+07z3PRCyJaa7UnfPy/4NKYiA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rxKvPOvJ; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::102d; helo=mail-pj1-x102d.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rxKvPOvJ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::102d; helo=mail-pj1-x102d.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4flDGY0yB4z2xlK
	for <linux-erofs@lists.ozlabs.org>; Tue, 31 Mar 2026 14:33:08 +1100 (AEDT)
Received: by mail-pj1-x102d.google.com with SMTP id 98e67ed59e1d1-35d90833cacso1815120a91.2
        for <linux-erofs@lists.ozlabs.org>; Mon, 30 Mar 2026 20:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774927986; x=1775532786; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a5728gVfKW3MwwJedBecCR4nLOtL5eDepwDGgOmB8Ic=;
        b=rxKvPOvJQmd9WPoJFyzHUBirzSMzCm1itJEY7Fpk0sMw/E2UxZAT3Fq/XQnFrkFc+9
         VfRjn1pRCgJR9gxDBSHNCbv3G+QbbSQdf0nWsl1RyeIdbif5dsLEODUpKNAy0Qq8cmve
         Bd2XrpcoYoruJR2+2TiljZBhI8MoMF9oGoa0tmlRPb40HOsIJD32nPyd+IkCJIxuTZFR
         VuUATDiBqMwgzDSaZFTa7JYAL8mgkkQjFO5Gyn7MzhoqHY+Uhm3SkDLM4CeigEE6xehG
         Hx7WE9S30JcgvJTTrFq5rcHmg+zVK0o12YDHB0qxz7Xfk0FdvMB6Psja+JFm7KDEjkXV
         8PYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774927986; x=1775532786;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a5728gVfKW3MwwJedBecCR4nLOtL5eDepwDGgOmB8Ic=;
        b=pzKOOHtcvgbBa3taeV+axdiAIoxbsuXwROOWQpYi+sr3JMx4HCeBdJwYge4knt7rcn
         ALH0851/JA7ur5slS0IWTGhZh+GSFq5UO3jD1bpNuigK5w59s2QRzY3HW8X3FOOgzTPy
         Qqp7LYhxxipc08RwRaP/MNyccRmfPNC6CtLTzaegR/XyWICRCIaoXwjQjzIgaCTRgPiY
         WKGRQbmHbOvGSOnh4r9UwpSIo/M9lHUtAyr4wbb27Tl46Fsds6bDDPYchFlJXmpoHfDE
         /jKUYI7xh5e9mHs2vdzDRKlOsogM92orm0wYu8ziCYqLAg7DxpgP6NPcXLvvsDzsy+NE
         c/bw==
X-Forwarded-Encrypted: i=1; AJvYcCXQzbQyawc+iasSCp6jlztuIFuN8HPh75pyid7jJKkoSSx3lQxpUHk3Tf/Yvc8dzATAE1G9ZqqO5qfqxQ==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YyaLNh6rGtugn+RKrDhFlHzBQ0lpucNXDVUiPuVYH3QbuPXMR5V
	KezTCKqvbOYooApnQpMZ9OM+MSQVWuNPk2T9vPnSKzCLWqePPyOlfZsC
X-Gm-Gg: ATEYQzxHHsUU8i/pBf+vnV3MHcv7jCvQM7Nhxl/ZP9kY5CAS487hPaPIxSYOrPKxaq0
	CeqXee3UETlr3//kbwcq/PHsz7QIzUXROzBP7okNDHjRL101m+zrv+XVslKCvhkOatFEjCRdgML
	yPGF5A5fpPtEEULfWLB2sQqpR0qc7GgQNMHOPfxu/+cZMl5XwQMMnnc2ykUthGZIbjFxWIqcmJ/
	TTOktnyBnrZPeV9EFl+HZu+wPfQqSQU2OEByC7S+p1KEH/SXH4/bLXjL5B1ms99aGUrv8l8Hydi
	urg82ofR/1lfOcd0mzocEhqqw0EmnszZQxej7U3yoou1u1Ti976fFhuFJ6FyKJTrnJERhvlRkzg
	P3f+GivaEpDmACt/F1NY0AKbwWPVTqZTrhKI2TwXBkfRfCqKwzMeg/KExjwWOLuxfZjmFPxcAHy
	EuQP5u+DkZqrpQjEtMiql5e8s747b+2sZNxq9uplSVupkcdt8=
X-Received: by 2002:a17:90b:4c:b0:359:8eaa:7f42 with SMTP id 98e67ed59e1d1-35c30056c25mr13513619a91.18.1774927985666;
        Mon, 30 Mar 2026 20:33:05 -0700 (PDT)
Received: from DESKTOP-MOQC9AF.mioffice.cn ([43.224.245.237])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbe624756sm75102a91.5.2026.03.30.20.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 20:33:05 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Zhan Xusheng <zhanxusheng@xiaomi.com>,
	linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH] erofs: fix missing folio_unlock causing lock imbalance
Date: Tue, 31 Mar 2026 11:32:58 +0800
Message-ID: <20260331033300.21366-1-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cd8dd7e1-709b-4b4b-93b8-8d4147293c0c@linux.alibaba.com>
References: 
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
Content-Transfer-Encoding: 8bit

Hi Gao,

Thanks for the detailed explanation.

I see your point that folios attached to a pcluster should
always be managed by EROFS, and the !erofs_folio_is_managed()
case should not happen in practice.

Instead of handling it silently, it makes more sense to
treat this as an invariant and catch unexpected cases
explicitly.

I'll update the patch accordingly by adding DBG_BUGON()
and send a v2.

Thanks,
Zhan Xusheng

