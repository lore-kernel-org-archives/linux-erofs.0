Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64DA3C7EE26
	for <linux-erofs@archiver.kernel.org>; Tue, 23 May 2023 02:32:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4QQJHz4vJNz3chV
	for <linux-erofs@archiver.kernel.org>; Tue, 23 May 2023 12:32:31 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1684809151;
	bh=Oy1fEYOjdw9GRZ4W/gqIzqsxA2jpxKh6oxmTgbjHp2I=;
	h=References:In-Reply-To:Date:Subject:To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=o1YMZKHj9r37HonLcwj1AVyw/FnbR18iN5HQgTQrr9Xfjr+TivX5coX5L543mYL23
	 ZYbrFH8K9v3PpQMgGgAeNU4VuYs7zFMW0SOcM1l7Iyd6vpv37jtrOPgmhTDdE3BkGD
	 3QZxoPkgm5NZP3EUbUSCuI8HiTZs0v/igOZPHA4CjpsCVD6ifjCHBl99LGieYaI5fZ
	 eheLt2KegP+ah7CJ8Wl2RUIHiyaFFr67CSRicaDbLdhBqgHwFXOFpqh2pQpAy+Z3+C
	 bkqaVdck67Bo+keY3ybTSNwSb7Vy2JTxiwVW4/XYc6YawRaoFEaGlMqoNDt1GdxBFM
	 HbQ2Zi1jbxrjA==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=google.com (client-ip=2a00:1450:4864:20::42f; helo=mail-wr1-x42f.google.com; envelope-from=dhavale@google.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20221208 header.b=0JwIPCtN;
	dkim-atps=neutral
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4QQJHr1wNjz2yw0
	for <linux-erofs@lists.ozlabs.org>; Tue, 23 May 2023 12:32:22 +1000 (AEST)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-3063433fa66so4236528f8f.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 22 May 2023 19:32:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684809136; x=1687401136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oy1fEYOjdw9GRZ4W/gqIzqsxA2jpxKh6oxmTgbjHp2I=;
        b=LgWPjsS1hABfXm4RArR8pvOW4JFVYFaX0BmKp3Z5YcpLQUkwkGQE9c6oQG2lbnr9Lg
         okd2XCoau/FelORKS9UTUrEJ22VInB1An3Ji2M6YPjnxpjKySRrg2QRQL7HTdVLg0/N/
         SMZQeLBHofPbxacEsXBd4vQMBULj39d1uAxaEqgvFnjpmUfj7oPN+vdgBdyXEQgN+LNC
         fnLXLViOm6ym1QZcEUztG4ERvRs+T82iaGDxWOYHSE6HuYAyDv4msX/8uRw1zNDdcyU4
         pb4xrtU9tG96YEuhvjUKHL//Ol9aO0uxhKBbFgQNiFnu983bsWsoV/m/m7eta+VZYM23
         9NlA==
X-Gm-Message-State: AC+VfDyACNo6SQ/VoJlXvn0KCPUERjVCfP+K8qNGhIxj5NwWfenPIaw8
	tIZE65XF/gN0CFuebEh5ie2aGMDNDHkKWFkRQLibwg==
X-Google-Smtp-Source: ACHHUZ7P5cOtJ5G1n3f/+I3nC83p/qIPzpIoOw6MEvl2GQi+Sl82dBsdIOXmtafJDiaOi4usXg3TH7IrlGlVsxGBbqY=
X-Received: by 2002:a5d:5448:0:b0:307:83a4:3d3b with SMTP id
 w8-20020a5d5448000000b0030783a43d3bmr7054212wrv.54.1684809136467; Mon, 22 May
 2023 19:32:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230522092141.124290-1-hsiangkao@linux.alibaba.com>
In-Reply-To: <20230522092141.124290-1-hsiangkao@linux.alibaba.com>
Date: Mon, 22 May 2023 19:32:05 -0700
Message-ID: <CAB=BE-TQsa+D9WZ01Zi_ByAjaLMcHGZBXAuGzmRSEdgeio7UJA@mail.gmail.com>
Subject: Re: [PATCH] erofs: use HIPRI by default if per-cpu kthreads are enabled
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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
Cc: linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Mon, May 22, 2023 at 2:21=E2=80=AFAM Gao Xiang <hsiangkao@linux.alibaba.=
com> wrote:
>
> As Sandeep shown [1], high priority RT per-cpu kthreads are
> typically helpful for Android scenarios to minimize the scheduling
> latencies.
>
> Switch EROFS_FS_PCPU_KTHREAD_HIPRI on by default if
> EROFS_FS_PCPU_KTHREAD is on since it's the typical use cases for
> EROFS_FS_PCPU_KTHREAD.
>
> Also clean up unneeded sched_set_normal().
>
> [1] https://lore.kernel.org/r/CAB=3DBE-SBtO6vcoyLNA9F-9VaN5R0t3o_Zn+FW8Gb=
O6wyUqFneQ@mail.gmail.com
> Cc: Sandeep Dhavale <dhavale@google.com>
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> ---
>  fs/erofs/Kconfig | 1 +
>  fs/erofs/zdata.c | 2 --
>  2 files changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
> index 704fb59577e0..f259d92c9720 100644
> --- a/fs/erofs/Kconfig
> +++ b/fs/erofs/Kconfig
> @@ -121,6 +121,7 @@ config EROFS_FS_PCPU_KTHREAD
>  config EROFS_FS_PCPU_KTHREAD_HIPRI
>         bool "EROFS high priority per-CPU kthread workers"
>         depends on EROFS_FS_ZIP && EROFS_FS_PCPU_KTHREAD
> +       default y
>         help
>           This permits EROFS to configure per-CPU kthread workers to run
>           at higher priority.
> diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
> index 92f3a01262cf..3ba505434f03 100644
> --- a/fs/erofs/zdata.c
> +++ b/fs/erofs/zdata.c
> @@ -367,8 +367,6 @@ static struct kthread_worker *erofs_init_percpu_worke=
r(int cpu)
>                 return worker;
>         if (IS_ENABLED(CONFIG_EROFS_FS_PCPU_KTHREAD_HIPRI))
>                 sched_set_fifo_low(worker->task);
> -       else
> -               sched_set_normal(worker->task, 0);
>         return worker;
>  }
>
> --
> 2.24.4
>
Looks good!

Reviewed-by: Sandeep Dhavale <dhavale@google.com>
