Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04430C433F5
	for <linux-erofs@archiver.kernel.org>; Tue,  1 Mar 2022 06:06:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4K76G658FNz3bqx
	for <linux-erofs@archiver.kernel.org>; Tue,  1 Mar 2022 17:06:54 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1646114814;
	bh=Ju6c2yXl8BT53AY8+YoJlYYYMS/s2G+8xxrXJ/xSZjE=;
	h=References:In-Reply-To:Date:Subject:To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=QtxDgpZl+KDptvLhBuI+5xsx1XaoBRigiwsrjVyqXzbCf4ZvPQWLffpjhG4yx69nR
	 HKFfCy24QXSxJ1Xuna36uvdD/dXAEd9PyDo0yTuyfHBIl6oSvXJV9V+0D1U6FD1smb
	 aFtikLlJS/oTgSReXSp016X45TO1ihF2rlfdleOAtJ1mFX3hca3rL5ZHazIeNjlC93
	 IorHkHbo6k9eMhhfHj1SMkVFK+unAiOpga3WQAaOykNPoGL8MgTda336K4KNE/R25x
	 ud/UcyjMQ59S/NyoWaBbLrKTVSzgQTAtKVF+eK27PQ+bxZN80J9o8lqc6Ag7eBSLKX
	 rbgZ+UR8fPTPg==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=google.com (client-ip=2607:f8b0:4864:20::e33;
 helo=mail-vs1-xe33.google.com; envelope-from=dvander@google.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256
 header.s=20210112 header.b=TqNnLu4P; dkim-atps=neutral
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com
 [IPv6:2607:f8b0:4864:20::e33])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4K76Fz5n0dz3bdL
 for <linux-erofs@lists.ozlabs.org>; Tue,  1 Mar 2022 17:06:47 +1100 (AEDT)
Received: by mail-vs1-xe33.google.com with SMTP id y26so15418672vsq.8
 for <linux-erofs@lists.ozlabs.org>; Mon, 28 Feb 2022 22:06:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Ju6c2yXl8BT53AY8+YoJlYYYMS/s2G+8xxrXJ/xSZjE=;
 b=3Ylv782IFNqezX/ayk8UWK4J6sStOlOR//yGpPUybqrlFs/v8cVi2qlA75GMdnOsp9
 2+lGsWQIwYwPOYhTaleAIfce3oKsrjdtES7rK+EqYZtt1ZNKY76RroJsiJ0NqZ3A0KW/
 5O3wwnLXtToncskkdcbzp/rHzXKPU8wVijB4F/yd54utt4Lroh4OXPbpxCirPYYkyB6V
 LEsxY/Gpqv2DYfzkr6lujKwv2497Td9AwtqbDgnJFxYeZm+L/dRY+ccn3JqDCt0JewXQ
 O3E0ncV8Rp/wxLlgOy3SL5M2fFuB3KSuLJuGznPX3/n29uxMQOOj68ZRN1mJRR4pXeR6
 lKCA==
X-Gm-Message-State: AOAM533bBh4zlzYlZb+4jMDA3mJHwmktPF1fEq5YlJ1VJ7Bh3WMnFLaM
 IJ6Xf3tLH4dtC65paJiqYywn6q/daZFum0gU44WeNr1ZhU1AIw==
X-Google-Smtp-Source: ABdhPJxSXblaRBDdCwEwmruyNTl4VC70o9pOFoDHTz71uxT3s0dMt2ibGKySR2+47ppXJoaYUSSI/zTtJBPd9ljPrTk=
X-Received: by 2002:a67:ab4d:0:b0:31c:3539:9569 with SMTP id
 k13-20020a67ab4d000000b0031c35399569mr10249784vsh.67.1646114804947; Mon, 28
 Feb 2022 22:06:44 -0800 (PST)
MIME-Version: 1.0
References: <20220301041037.2271718-1-dvander@google.com>
 <Yh2sc2TOmyBdV3b7@B-P7TQMD6M-0146.local>
In-Reply-To: <Yh2sc2TOmyBdV3b7@B-P7TQMD6M-0146.local>
Date: Mon, 28 Feb 2022 22:06:33 -0800
Message-ID: <CA+FmFJB0iDzcPLqAtZsqQFj+j-pvhqs9YXmhjkmCYyqPgHpxnA@mail.gmail.com>
Subject: Re: [PATCH] erofs-utils: mkfs: Use extended inodes when ctime is set
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
From: David Anderson via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: David Anderson <dvander@google.com>
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Mon, Feb 28, 2022 at 9:17 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
> How about introducing some option like '-E preserve-time' since
> compact inodes are mainly used for reproducible builds, which I think
> per-file timestamp is useless...
>
> Also after I checked ociv2-brainstorm, they'd like to avoid timestamp as
> well, which can be effective used by EROFS compact inodes...

Sounds good, I'll post a new patch with this option.

Best,

-David
