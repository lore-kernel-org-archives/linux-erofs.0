Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21382C43334
	for <linux-erofs@archiver.kernel.org>; Fri, 10 Jun 2022 23:20:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4LKcPk36WXz3c7N
	for <linux-erofs@archiver.kernel.org>; Sat, 11 Jun 2022 09:20:10 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (1024-bit key; unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=Aoxxrgfm;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linuxfoundation.org (client-ip=2a00:1450:4864:20::62c; helo=mail-ej1-x62c.google.com; envelope-from=torvalds@linuxfoundation.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=Aoxxrgfm;
	dkim-atps=neutral
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4LKcPb1PXsz2yyh
	for <linux-erofs@lists.ozlabs.org>; Sat, 11 Jun 2022 09:20:02 +1000 (AEST)
Received: by mail-ej1-x62c.google.com with SMTP id me5so779631ejb.2
        for <linux-erofs@lists.ozlabs.org>; Fri, 10 Jun 2022 16:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mFUZ/4X/JukFzJtRWCj5IwVqnR0commkjm8Ld9IJoQA=;
        b=AoxxrgfmaiG7fB01rWVX7//fR7hc8pfPaO6KuFkmEJpDpFR/HpqhwLdFQM6dVgzan3
         DB7+Ryy9LWRyARZSjDc1y62fbB3v6E3HNwslaXd4JIbxny9dkIOf8ftYNIIBC41esAeu
         4Gv6sMSeEfJjJ4Ad3imZr/QdI/L/mCWsQLeaA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mFUZ/4X/JukFzJtRWCj5IwVqnR0commkjm8Ld9IJoQA=;
        b=ZYZ1240m3yTeFH7+u0uBEAAwqsp4KaFDEmoJIshy9Sa8F8JQ5VCedkSAxykEdJLtJO
         bDN1HaFO6IrbNdEwjwLvQ+GosfyqxJAyCUrP93MtKQYvxj/LSrrTG3CXbJqVyOFFaj35
         nFX3eUKNfG8lSCs64IIRCbl4ymnylATu4WYUPpSsllplfYUKYhPiqLeXQZDBoHhH9vW1
         b9cCRv8o8I7svZZSOnEWj1yP1y7YjE7StRBw+Vdl+UtLGZ+ZNlxW+iHLRjKaL2nASngs
         sfU+lRkS4/Y5dHEg1FHZfc86IurDSAuRHo4hixGeYOOlaK70PW4i7gIG93DGH1SReECL
         GnKA==
X-Gm-Message-State: AOAM531f5lVGqXrbqFJfDFLF5S3Lhv9fXL5qMxHDf8Dh9wOY9w6N8Dlq
	mkQ5Wjal8LStpvZ17vTANg8J39OW1QxVuQ75
X-Google-Smtp-Source: ABdhPJylxCGfjdZQ/z5i/+h2IYTgJHdh/JCFqrFFi6vKs2+exMU1Ss0ekJfUdg1CaDi8d4mfNaVtdQ==
X-Received: by 2002:a17:906:4786:b0:6fe:a20a:fcd1 with SMTP id cw6-20020a170906478600b006fea20afcd1mr40982145ejc.442.1654903196356;
        Fri, 10 Jun 2022 16:19:56 -0700 (PDT)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com. [209.85.128.50])
        by smtp.gmail.com with ESMTPSA id pv17-20020a170907209100b00704757b1debsm219875ejb.9.2022.06.10.16.19.55
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jun 2022 16:19:55 -0700 (PDT)
Received: by mail-wm1-f50.google.com with SMTP id m125-20020a1ca383000000b0039c63fe5f64so363498wme.0
        for <linux-erofs@lists.ozlabs.org>; Fri, 10 Jun 2022 16:19:55 -0700 (PDT)
X-Received: by 2002:a05:600c:3485:b0:39c:7db5:f0f7 with SMTP id
 a5-20020a05600c348500b0039c7db5f0f7mr2015707wmq.8.1654903194928; Fri, 10 Jun
 2022 16:19:54 -0700 (PDT)
MIME-Version: 1.0
References: <165489100590.703883.11054313979289027590.stgit@warthog.procyon.org.uk>
In-Reply-To: <165489100590.703883.11054313979289027590.stgit@warthog.procyon.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 10 Jun 2022 16:19:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgeW2nF5MZzmx6cPmS8mbq0kjP+VF5V76LNDLDjJ64hUA@mail.gmail.com>
Message-ID: <CAHk-=wgeW2nF5MZzmx6cPmS8mbq0kjP+VF5V76LNDLDjJ64hUA@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/3] netfs, afs: Cleanups
To: David Howells <dhowells@redhat.com>
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
Cc: CIFS <linux-cifs@vger.kernel.org>, "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>, Jeff Layton <jlayton@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-cachefs@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, v9fs-developer@lists.sourceforge.net, ceph-devel@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-afs@lists.infradead.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Fri, Jun 10, 2022 at 12:56 PM David Howells <dhowells@redhat.com> wrote:
>
> Here are some cleanups, one for afs and a couple for netfs:

Pulled,

               Linus
