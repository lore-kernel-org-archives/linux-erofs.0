Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2B5CC64ED6
	for <linux-erofs@archiver.kernel.org>; Wed,  1 Mar 2023 11:15:51 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4PRWr61hcCz3cK8
	for <linux-erofs@archiver.kernel.org>; Wed,  1 Mar 2023 22:15:50 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20210112 header.b=gC9kwfJv;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1035; helo=mail-pj1-x1035.google.com; envelope-from=zbestahu@gmail.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20210112 header.b=gC9kwfJv;
	dkim-atps=neutral
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4PRWqx6JNJz3bTc
	for <linux-erofs@lists.ozlabs.org>; Wed,  1 Mar 2023 22:15:39 +1100 (AEDT)
Received: by mail-pj1-x1035.google.com with SMTP id bo22so1433779pjb.4
        for <linux-erofs@lists.ozlabs.org>; Wed, 01 Mar 2023 03:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677669338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W4C06o/XbMAV0i3lyzT7jaufQDDSIWpgX7SM03hr6AY=;
        b=gC9kwfJvPa5EgAGcgduP9RyNOeMHkDMX1/AcxoCYoicW/70pf6bm0kfYRWaYDKL9jq
         yeDhf+SJugSgF8ZQPINTQ+2SIBUjJww5vLuDOw4OlAUn9XxHaSsLhTVQY8k5hI2s6FCF
         BNkiYZGV3afoZzGjdUf13/kicNt5DwKuRRE7DqL3oNvh/L35fmLpfANNx/OnK44PyN6Y
         2fvUrDm1M6dv38oqPOuMtzRAlYLVckp9ZA1UIA+r9Jaiu+WDhIBSuu8Y9Kdwzv54xibl
         sFSIi940LSsaZZ5orBdNvjW40/CdujjohOPyTlggdZpmpEXferZ8aXmMbXT9XPX7y8nP
         FFYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677669338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W4C06o/XbMAV0i3lyzT7jaufQDDSIWpgX7SM03hr6AY=;
        b=cuo/5i5Nas6Gj/EASiFPPobABaEx7YtvKoJ1jsOcFbp/52U21BxVzHumVeUaFPtvNj
         1ASJJxCph6aT5IduG32q7X9BluPtt+M/xrE1zA9DcvyJA3FZayvjanKlZxX7EyHztQ3C
         BlcQRdw46yIheobVL1Rr8uf949e4gyP0MfYEU1J3IkfTHCi7FCkDWeSEVA3RlrITHZ2l
         5sc0/4KFM+2oPAM8DqU3NH9v4NQVqwV1AbbKGozZpFXkSaMgx/Cln2QXOtA6C2kPuByq
         BvLnhhHKurhsR5PDUtUcDXdNMVz2WyltRkj2fYBhwLfOKQsR6aWkaxONkQ4iRm9x0G31
         kO3Q==
X-Gm-Message-State: AO0yUKUquur0llHZZqlC8p+4VS6kCRop676MPe6ZPCDGSNp2Ej07tWe0
	mmyXR/OH1FAVsxKgBw8S1c52rMeY2Lo=
X-Google-Smtp-Source: AK7set+DJ8Rk8q3PTygS6pRyDS2gZeCUi3HsEPCWJ643ncrT+xcX4VdCvxVH2NKoQlZ2wVT6V8X2fQ==
X-Received: by 2002:a17:902:c407:b0:19c:d0c9:8fdd with SMTP id k7-20020a170902c40700b0019cd0c98fddmr7252514plk.52.1677669337816;
        Wed, 01 Mar 2023 03:15:37 -0800 (PST)
Received: from localhost ([156.236.96.165])
        by smtp.gmail.com with ESMTPSA id l10-20020a170902d34a00b0019c93a9a854sm8115584plk.213.2023.03.01.03.15.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 Mar 2023 03:15:37 -0800 (PST)
Date: Wed, 1 Mar 2023 19:21:49 +0800
From: Yue Hu <zbestahu@gmail.com>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: Re: [PATCH 3/3] erofs-utils: add `-Eall-fragments` option
Message-ID: <20230301192149.000070db.zbestahu@gmail.com>
In-Reply-To: <20230228185459.117762-3-hsiangkao@linux.alibaba.com>
References: <20230228185459.117762-1-hsiangkao@linux.alibaba.com>
	<20230228185459.117762-3-hsiangkao@linux.alibaba.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
Cc: linux-erofs@lists.ozlabs.org, zhangwen@coolpad.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Wed,  1 Mar 2023 02:54:59 +0800
Gao Xiang <hsiangkao@linux.alibaba.com> wrote:

> It's almost the same as `-Efragments` option, except that will
> explicitly pack the whole data into the special inode instead.
> 
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Tested-by: Yue Hu <huyue2@coolpad.com>
