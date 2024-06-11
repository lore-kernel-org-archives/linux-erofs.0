Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12987C27C55
	for <linux-erofs@archiver.kernel.org>; Tue, 11 Jun 2024 02:58:30 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=nn7iP8iO;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4VytfD0Hqkz3cGY
	for <linux-erofs@archiver.kernel.org>; Tue, 11 Jun 2024 12:58:28 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=nn7iP8iO;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2607:f8b0:4864:20::b2c; helo=mail-yb1-xb2c.google.com; envelope-from=keiichiw@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Vytf252pQz30Sx
	for <linux-erofs@lists.ozlabs.org>; Tue, 11 Jun 2024 12:58:17 +1000 (AEST)
Received: by mail-yb1-xb2c.google.com with SMTP id 3f1490d57ef6-df78b040314so5206538276.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 10 Jun 2024 19:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1718074694; x=1718679494; darn=lists.ozlabs.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=G7/8lIqDQyik1aMoV4fwgNhp0T43vZVJkhwbTwnsyrU=;
        b=nn7iP8iOKabANBikygmzONn7ru8pnX9laK7ECmt5N3/NHZfa5Y32M6mAVXvdOOydQy
         6ptRV0IoxZt4gzwj3MA/ER1msbT04hXDI4mzLG+n2N/2vV/MuY6Ogxxb3vy9+ko8rGIp
         vjcuTRg6beYLRFN/HwbBlJYJfwNA1Wkn2fIEg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718074694; x=1718679494;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G7/8lIqDQyik1aMoV4fwgNhp0T43vZVJkhwbTwnsyrU=;
        b=O6QhZgMXn29AhTGMoQg8FBB3HqL0rqGQPWQhmh1++XmSk7gX09TDalfIqI0jz0+Pjs
         /Xe78TszlnoP4qtWn9u9QxscOI0tJdm6n0qVyPnWnRd2KS/Dc/SyDYxKXZpK7mIItQUs
         C/3BvNcxPLSAeP3GZsI3ccqgF7XNnyh9Eyw1DtIO5gYe3S+2D2/1kwrrenu3q2WoLfet
         67txvMJ8vGqIGl+zGuVE3g3IA1PdQdRpujTXSH7mMleLfAlW4k7YYDNiXbNNZjdXCyaA
         6dxrJC7wB1aABJAEn+83xzHe6eMMHp+hv5eHcsKmH3rL5XjZ7nCE2ngu8FuKH303XDzc
         o+PA==
X-Gm-Message-State: AOJu0YxmYcxga/UtKTIjeiQ9h4aDD9hvdi9Y8cK6F+13P0nFm8uwc4CP
	7e6z5SP1hdDAbDTB7ap/MeT7n76eR4KZ8qhbV4s4yC5btQExuWIMzZROry4gRrtgp3wBUZcXfIj
	B4hbDWf/e9SsHA5uRtmObcQKZbTYnvqADz3hMRmzUr/hyW7KEAw==
X-Google-Smtp-Source: AGHT+IFfUUzpkw+4irJbNtuWw6RpozNu6riJwG0qTkU0zlJpC4WT5mub8AJ82NYe4p73rN57C2r4RHqkphdBJDtezP4=
X-Received: by 2002:a05:6902:2408:b0:df7:955f:9b99 with SMTP id
 3f1490d57ef6-dfaf66d275emr11105643276.47.1718074693779; Mon, 10 Jun 2024
 19:58:13 -0700 (PDT)
MIME-Version: 1.0
From: Keiichi Watanabe <keiichiw@chromium.org>
Date: Tue, 11 Jun 2024 11:58:01 +0900
Message-ID: <CAD90Vcbzx_Qz_V3CLJXHkvEfRX=E3Rkf-nHoTc=NDQPZDesJQw@mail.gmail.com>
Subject: Can mkfs.erofs keep specified files uncompressed?
To: linux-erofs@lists.ozlabs.org
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
Cc: sarthakkukreti@google.com, Junichi Uekawa <uekawa@chromium.org>, Jae Hoon Kim <kimjae@chromium.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi,

Is it possible to exclude specific files from compression when running
mkfs.erofs?
I found The --compress-hints option allows me to specify different
algorithms for files thanks to [1]. It would be great if I could
specify "uncompress" in the hint file.

[1]: https://github.com/erofs/erofs-utils/commit/dac31f7eb228601c457c6338e6df8dabfcbb039b

Best regards,
Keiichi
