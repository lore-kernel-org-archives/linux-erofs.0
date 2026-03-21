Return-Path: <linux-erofs+bounces-2906-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA8991094463
	for <linux-erofs@archiver.kernel.org>; Sat, 21 Mar 2026 09:35:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fdDmp2NyRz2yYq;
	Sat, 21 Mar 2026 20:35:06 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::431" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774085706;
	cv=pass; b=TCNgzvE4vw0n92G7ZcpwTFDiVK1V3S5cXMFQ45R8nr1WUGmwbsQYfywPQZH8l9OIKCmn0EZRk1fvmC7iji+lFLkY+cD9YywRFV68v6OFyIj0bC5Xnd0HIR6MgcJwph+Upx4soLwOYTQNB3YbXfUlnHmZH86kxfE335TBZW4/mIbPYIUtq1P2Ucuo6alD8uyPz55mghI/Y9VlL/fhWn3feTNyeYdYcHk8f7jZ3XF47WG1kygRygLIT3KXypbu+4dkFKTDMSp8Wzs08yuQGlJ5DwKj7RkiRv7yCzyRa7lJfbVD9q6yu2QyLHEbmDgHuhmb6x7kMsw8TTR1U4dejaDV+Q==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774085706; c=relaxed/relaxed;
	bh=1XwGxeUp/7jCY5T5k8KBVdHU2hZIKUfOUoHcYwxzlsk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U6XJVYbG7l23xWLMyOMsqGxT6EhJUFA2oxF4fh8ZfE8Mk8ym0zsRTAdEUdpmUMEDRC+vQOYlErC4+NuUcyCfEhrM565S73ECRvgsi54P9RuNtJPgJkA7VhYW5AH0DEjsjJ1mELDrBAUw3+AlCvn3objKBSbub9QkMItNL8hM+/uGuxp9Jyb0lG6nM9aHMb1cpxUdaEjZzX7Sl/r4BbGR0kyhcOhqs5xCssqgwfLYICtcPk5oazIVX/FAAj3oplKoDpsK2vu+p1FdJ6aUZY2s4ANn9fHeb3M186ik6vybP5FpTtB+6brdE61q7u2y72ZQLvZg32jVs8FM4fwTDidRuw==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=FNTaKTCb; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::431; helo=mail-wr1-x431.google.com; envelope-from=newajay.11r@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=FNTaKTCb;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::431; helo=mail-wr1-x431.google.com; envelope-from=newajay.11r@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fdDmn1yM5z2yWy
	for <linux-erofs@lists.ozlabs.org>; Sat, 21 Mar 2026 20:35:04 +1100 (AEDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-439d8dc4ae4so2279469f8f.2
        for <linux-erofs@lists.ozlabs.org>; Sat, 21 Mar 2026 02:35:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774085701; cv=none;
        d=google.com; s=arc-20240605;
        b=Y2tmUy70OL/Mb2sSJXA5MFLhNRi9IS5KxeG+y/voyD+kbz0428fFtaiz5oiO3PsHOP
         1lBAT3PoERXg85shoupQHOJFBJyH7L8vgAJLGM8/y5yWg7xcxudn21FgIFzTWagCYdZx
         Fc+IDT+jJ+tsIMMp3pKgLjZ0XeaG7w7j+brJPiAn2xbueKlc/SnwVBOBTiTY51PeR07Y
         7+fG1XNE1xj7CTFEMiNbm/6zTp5Lr/Ugh0tv0lTYx4Mc3uu/0gdBsVOz5/JwuSHTDce+
         T7Rdmlp7gL096w7quBaSHKLzXr8idpRi7iU4w1I1diSU64C35P4xcyMNwxNhB+5ipMoi
         mZCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1XwGxeUp/7jCY5T5k8KBVdHU2hZIKUfOUoHcYwxzlsk=;
        fh=h6uq7XjWFSBY/jwInOiPeoemBJWA2pJ/g0xZ2uxEeMY=;
        b=CkK0UAIpXHmc8biuS4Yg+7kfn+sqrhJZ0YCWQ4a4Lme9fUaELfB1TsgjcviARksCfa
         n3v6s7BcA3tDi1i1Yb3+0N9OxQtOu19lpuvILgGjSQeZpcl5bjnAf5vxBOL070kVO9Mu
         U/zPp7A8GDVTJROpm+KT5cYFCNXF2eMZbQ8jy8VYarJPLI9Dsgmr3Qr11tC1kTyMiwEP
         qtDYvyOfWOE4l5PclHVhu/lsOfRcTDmlSqVxVmotgDe2ojmJo8BaJ+tfpGgEsP48HWzW
         zWUhUKTGQAW+35JZ4yVTn11CrqUIBKFFv3c56+cfZaSeJYWhM8pCQAwg73GVfiP84UtG
         wc1g==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774085701; x=1774690501; darn=lists.ozlabs.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1XwGxeUp/7jCY5T5k8KBVdHU2hZIKUfOUoHcYwxzlsk=;
        b=FNTaKTCb6Y4d1J3juI2z2NbrkhSzfI2jS3KtP0rNiLdYZI4icOFp2CSzoBY81szI6v
         UT1Rn6fQeh8F86JHJ/vszrO9WCb/gxHqzdNpWKhdqB8VrLA3PhDJC65g58BsI8EsWwJw
         5uM9znhunc65zYAzf4bnafuIKtlj4GEcc9WgEy7oq19bXzCwD5/y+cNlADW2vDtRomJv
         qc9zMVB4HriRd+SxfhElWYdBEpfaTuWqoZENFAblIuZFMtnQBq0f2RQ6zZ8tuYqXW/4y
         n/PVt7YkQyvAF1rl7SeRLRgtnK+psIEc96uij6E3wYsCy1KjJja3vKx5EBYcqcjZkImU
         NAVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774085701; x=1774690501;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1XwGxeUp/7jCY5T5k8KBVdHU2hZIKUfOUoHcYwxzlsk=;
        b=gsYDHxqYF1nSii1cu8n7yfrloIIWmYNb8K+4xrHo6Ub6Db4xx/MSm+UUPhsOv3F0s/
         8zucZIXzkboS2yjPTa14ybEuV3S1AityD4ezDJzMmmvAq6fo0Piryxf7Lor6+ZOvwOSf
         Yy2dFttJhNI1rrBOXzp7BbiGIlo4GYXWvbjV9kvdNjv5ukeoS0MNnpZ97ygZYvArAN1z
         egb1bnw1OpvhNZZwSXN31dIktWBo8LSMI7ibajSDKW9AQd1y0v1j6Ld9iRqZaFpuXofN
         FLLUVoK3jJ3VRiN/jqUE5pjvDGntwZLWPkXyeapSpLLdxoR+BaPM/T2XU7aIf7LEFAfB
         9dtw==
X-Gm-Message-State: AOJu0YwMowIl4YcjFdH2kVrApYHXurjd2vZsflZK1Dmn6VSFcy7lecf/
	LqOhrwq0dFoEOU0iwCQqhuj+4b2vJlTgVs4p2HAGO5PktNINig1StkaHPJAW/JgQqfvk6J1uBnI
	IMypURrvRGMim2m7KpNUsTWMIyHEVniM=
X-Gm-Gg: ATEYQzxOdMMN8Zg96fUTiC5sOdo8mnkcXSuRc2yBS35feKL6jlJTTNpxK/pt1Ii4MPm
	cT+5Uz185VmmXofvfjA1cLrAWPnVyO9EFEZmnrbJMS6dpP+/5dzGYP+dPHojL2zm30LRYC2blPR
	0GFPB/kzICkX7mknnlkFCCkoJDkwI2iKLtnNoCbX4MercyMBMHZGqVKe1kKAnGDJFCJgX9OL4H2
	HGNr11wYZVV9vzTwSQQnOwoKX+UgyU3CUmX6UoH3tczKsLOfSNMxTwOl07GtOMObYJ9hD0lVqdI
	Uiof6WPesotqpBVXs6m6y+XjPe4RTkUkKk4Qcin8Cw==
X-Received: by 2002:a05:6000:2907:b0:43b:4361:fde8 with SMTP id
 ffacd0b85a97d-43b6426d6a2mr10241064f8f.41.1774085701347; Sat, 21 Mar 2026
 02:35:01 -0700 (PDT)
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
References: <20260321062604.1905-1-newajay.11r@gmail.com> <20260321062604.1905-2-newajay.11r@gmail.com>
 <e06d4f47-5fd8-4a7d-95c8-b4fa0fde62d6@linux.alibaba.com>
In-Reply-To: <e06d4f47-5fd8-4a7d-95c8-b4fa0fde62d6@linux.alibaba.com>
From: Ajay Rajera <newajay.11r@gmail.com>
Date: Sat, 21 Mar 2026 15:04:46 +0530
X-Gm-Features: AaiRm51OhTFzIJn3s9FYXbz92Ftpd7ujKTCp6MPdICPwY6g2qu3b0nMiDd18EPE
Message-ID: <CAMhhD9gF8gtsfaqAfPQC9gegELXaie04kGWboXJhNbTUVuBwmQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] erofs-utils: lib: fix memory leak in
 erofs_gzran_builder_init error path
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org
Content-Type: text/plain; charset="UTF-8"

yeah, I just sent patch v3.
Thanks, Ajay.

On Sat, 21 Mar 2026 at 12:51, Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>
>
>
> On 2026/3/21 14:26, Ajay Rajera wrote:
> > When inflateInit2() fails, erofs_gzran_builder_init() returns an ERR_PTR(-EFAULT)
> > but forgets to free the previously allocated erofs_gzran_builder struct (gb),
> > resulting in a memory leak.
> >
> > Fix by calling free(gb) before returning the error.
> >
> > Signed-off-by: Ajay Rajera <newajay.11r@gmail.com>
>
> The same issue.

