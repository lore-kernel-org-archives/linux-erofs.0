Return-Path: <linux-erofs+bounces-3743-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E653FCDB479
	for <linux-erofs@archiver.kernel.org>; Tue, 23 Jun 2026 23:57:59 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4glMT24Dnmz2yRC;
	Wed, 24 Jun 2026 09:57:58 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782259078;
	cv=none; b=PDZWt2Ul/X6rVwfIsY8bjRTAu2JDouD26DoccPhwh6HE8ljl9unmsiQllA0dSrv6IcrC01O0zqSg5sVQBGbQDrYlrmKC5Ifx29scBVXjE4agMwq1aYS4gB0HGn5Jx/Sq1nwdP75tLrZvEsjAf5lMwQaLwOf6Xnq6t5vrtAt1unHnuu/zwr6ITqLkqH+951q3DVLu0S1sv0XZ6hLFIi9PlwPD2mokX12vdaRGpVAcmUFBFhYuV9xJcn2pZFxeahE0nynMuGzWp1qvRzLbzzMBgBGpbdr+d9SGOND8WU3Dyyta+9zQ2TM7uWPJoN0tNoppdFKvaLTizszHU+6/CkCgug==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782259078; c=relaxed/relaxed;
	bh=vo3jkQBWmueCqXflda8hT63tzPuxvWggLYs1HwSrVm4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hk9nnVKkeq8kxJe9cSKLq0Ph0igvj9v8u1D1tO3EeaL/F2jYbclze2AJ8HqwI3lSQOfrBc8CrQQA2swtsFii+7RordHWylrHbZZUWFhrJuVQbKccf922+/AcmfTd6yXvaOh2WFOQbP522qLmARc7g3296fKp2vFF7qr16NDNhjVKcvAR3tgDX7FLe9cLWuTsIALA3bNNTuK4QPxOIzLm/w8KMsLKOr2LPIfd5kcNKWIapSYIbgilIOBkbfp5OlQVoDVHiYorQ9bYRSr4+2f8Z+vl+j6r3Y9iEwanpR8vbgAUufxj4zOXyV2wUkyb7yd2F/rCamDgG51ksozRjL71DQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TNsrka6j; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=linkinjeon@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TNsrka6j;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=linkinjeon@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4glMT15rVBz2xJT
	for <linux-erofs@lists.ozlabs.org>; Wed, 24 Jun 2026 09:57:57 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C88A64027D
	for <linux-erofs@lists.ozlabs.org>; Tue, 23 Jun 2026 23:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9FE1F00AC4
	for <linux-erofs@lists.ozlabs.org>; Tue, 23 Jun 2026 23:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782259074;
	bh=vo3jkQBWmueCqXflda8hT63tzPuxvWggLYs1HwSrVm4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TNsrka6jYQMLueD/PdSasDs+OjVGkeRSLwKwpfhI7Ix02RkrecnNvRB2Nhyi0eicc
	 NiY9OQO6xlDnlj2Z3HsYdZBLqRAJ8/cA1Fjd3YOmJAlv7+KL850tbn2Vi0rmiNog2O
	 dHpCe9cDf6OMbjE3pPD+XkTxyBIRJkfsR5LJZ9VXiZUPWNSi0ykS52jrP2QKLtzzXF
	 k48+AlWo/FsLD3jxA2JOLBh1lSJRhd3wLl6p8zumHUcrysJGzu4tAHJz1P9uBGniuY
	 kSrEJNzPNHQ7E17CWo2tM8WOPrXeIhG8su2u3MVTkx1I7QOdrwvNQyl69wO5Nua3jz
	 j7lfsBCz1ODXg==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-befee9e5ef7so49157966b.0
        for <linux-erofs@lists.ozlabs.org>; Tue, 23 Jun 2026 16:57:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/V4cWaYe2VxHZTSMSr5iXkF3DDMVAp1PGCD+aexUix28ZTEvHGFCNhp41uFWfH0reFHLrX8HrRq0PliQ==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YwE3rzKxrtVgd2DHmfc33R7D9byiTz63I7jnVxRncjgp7EoKrUz
	oFbUB1lSVzTw7Ue4XqPNA1fc1kyHWVtCjpKltVHkgIcaomMw+8SugrvFr2ltGRk/IeUM64N8qV9
	yV8L1lgmGn47ayLR/yWrjoMngJRRw9Bs=
X-Received: by 2002:a17:907:db18:b0:c0d:a1e4:882a with SMTP id
 a640c23a62f3a-c119de5e576mr32644966b.5.1782259073275; Tue, 23 Jun 2026
 16:57:53 -0700 (PDT)
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
References: <20260623135208.1812933-1-hch@lst.de> <20260623135208.1812933-2-hch@lst.de>
In-Reply-To: <20260623135208.1812933-2-hch@lst.de>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 24 Jun 2026 08:57:40 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-egHG+EKwpOn1c5drMuuMiv_BNgNRtAZCjscShXwbofA@mail.gmail.com>
X-Gm-Features: AVVi8Cc6T1k2fn50nfPiKDEdqJoYNhysDxZSt3v-_fDgmbnKqkaZpC3l_SiSFfk
Message-ID: <CAKYAXd-egHG+EKwpOn1c5drMuuMiv_BNgNRtAZCjscShXwbofA@mail.gmail.com>
Subject: Re: [PATCH 1/2] iomap: consolidate bio submission
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Kelu Ye <yekelu1@huawei.com>, 
	Yifan Zhao <zhaoyifan28@huawei.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 10:52=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> Add a iomap_bio_submit_read_endio helper factored out of
> iomap_bio_submit_read to that all ->submit_read implementations for
> iomap_read_ops that use iomap_bio_read_folio_range can shared the
> logic.
>
> Right now that logic is mostly trivial, but already has a bug for XFS
> because the XFS version is too trivial:  file system integrity validation
> needs a workqueue context and thus can't happen from the default iomap
> bi_end_io I/O handler.  Unfortunately the iomap refactoring just before
> fs integrity landed moved code around here and the call go misplaced,
> meaning it never got called.  The PI information still is verified by
> the block layer, but the offloading is less efficient (and the future
> userspace interface can't get at it).
>
> Fixes: 0b10a370529c ("iomap: support T10 protection information")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
for ntfs, exfat part.
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!

