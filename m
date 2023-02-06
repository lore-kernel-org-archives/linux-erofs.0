Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C6F7C636CC
	for <linux-erofs@archiver.kernel.org>; Mon,  6 Feb 2023 01:11:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4P97Vv4M2Fz3cLm
	for <linux-erofs@archiver.kernel.org>; Mon,  6 Feb 2023 12:11:03 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20210112 header.b=URtug1Wu;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::529; helo=mail-pg1-x529.google.com; envelope-from=zbestahu@gmail.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20210112 header.b=URtug1Wu;
	dkim-atps=neutral
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4P97Vj3VX9z3045
	for <linux-erofs@lists.ozlabs.org>; Mon,  6 Feb 2023 12:10:51 +1100 (AEDT)
Received: by mail-pg1-x529.google.com with SMTP id 141so7211161pgc.0
        for <linux-erofs@lists.ozlabs.org>; Sun, 05 Feb 2023 17:10:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X8koHqYtcGKtK9ShE60+AKTtKz4cqfXuzvfRTgSACa0=;
        b=URtug1Wu5FhPZFWn4UEncRpKJEjVT8KGu4Mv2T/cbdiuEEXvj04wSTdZAHBTiaWrM+
         9iFnqE1CZuMQB4xBQSUuXX6r+MfKwKd4JhaYnzKGB/bOfWct7x+TC/+5RbygsDP+MDNs
         rW2SMP+E2frDRFZsfGe1oJqq8C8vAVdo2vWRU4MzIiBw2IzfERP6M2VV4u0H6TaFK092
         gP6sHPQtCI7axgzVW9QiVab7R32SFN/6QIpKpNi9zoifg5aPrafER1lU1emc0Sc9Ej+x
         Cin5a3/xLYEcGRYQGTgSs8Lgnb5psb1RKWIpZZSB5Eg7RQ4CViR6sZ+c5dGtWWMXeXfb
         qjWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X8koHqYtcGKtK9ShE60+AKTtKz4cqfXuzvfRTgSACa0=;
        b=Iw71s1KopFVdNGXqhbLwvvvUna6l2ASL1oB/JRJEXntwQjIqx+yjEX6uL4vUX67Rby
         9D0dMSt6STOCCO3aQWWOGeg0xgPYw+MRW8IQo7ahg/0HMTuwqEA+Wk2YCHIwk735Zusv
         ZS/2uLc48tscXNKeYFqqUx7OxnGqCKDqRcGcAfw17apcd9ruLc6WbZJODw6k0EseUiyh
         x5oXfEr9KFAQRR8EnyrOL+A7KMZOXG5HmQawJkyCvQ/f7HbGGgvuNAvw78wkSGPwNKza
         spUUpq1VynoVf9W8HQi/kPOBfeKW9hsTGjVzzlrhPhAwnM3cwahMPAg4+S0+oEB2cDZM
         EkXQ==
X-Gm-Message-State: AO0yUKWHLdjmTzoNsTirkynlyh0DMQ9sxVqmaWDjmp3Y83MqJuN/bbM2
	szs26xwr1Ls3vDcBufx2hKc=
X-Google-Smtp-Source: AK7set8fT3ODZoWF86+1UvsxoUnNGS/nwGtC/D2vrM0qUK8yE/K/FN1lONE6namVd6AjWVKIwnnJCg==
X-Received: by 2002:aa7:8558:0:b0:592:3e51:d881 with SMTP id y24-20020aa78558000000b005923e51d881mr16184226pfn.14.1675645845522;
        Sun, 05 Feb 2023 17:10:45 -0800 (PST)
Received: from localhost ([156.236.96.165])
        by smtp.gmail.com with ESMTPSA id j4-20020aa78004000000b0059242cd5469sm5919068pfi.13.2023.02.05.17.10.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 05 Feb 2023 17:10:45 -0800 (PST)
Date: Mon, 6 Feb 2023 09:16:25 +0800
From: Yue Hu <zbestahu@gmail.com>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: Re: [PATCH 1/6] erofs: get rid of erofs_inode_datablocks()
Message-ID: <20230206091625.00000a70.zbestahu@gmail.com>
In-Reply-To: <20230204093040.97967-1-hsiangkao@linux.alibaba.com>
References: <20230204093040.97967-1-hsiangkao@linux.alibaba.com>
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
Cc: LKML <linux-kernel@vger.kernel.org>, zhangwen@coolpad.com, huyue2@coolpad.com, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Sat,  4 Feb 2023 17:30:35 +0800
Gao Xiang <hsiangkao@linux.alibaba.com> wrote:

> erofs_inode_datablocks() has the only one caller, let's just get
> rid of it entirely.  No logic changes.
> 
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Reviewed-by: Yue Hu <huyue2@coolpad.com>
