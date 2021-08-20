Return-Path: <SRS0=LfZ1=NL=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E81C432BE
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Aug 2021 13:43:18 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B1EDF61131
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Aug 2021 13:43:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B1EDF61131
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GrjWm2nKYz3cLY
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Aug 2021 23:43:16 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=IaC1FKGG;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=xiang@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=IaC1FKGG; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GrjWj1N7Nz3bnK
 for <linux-erofs@lists.ozlabs.org>; Fri, 20 Aug 2021 23:43:12 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69CCC60FE6;
 Fri, 20 Aug 2021 13:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1629466990;
 bh=X5QL1gh1lptSTmcs5lKjLvElC6JSwyBdeLCEHmDLJUQ=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=IaC1FKGG0biojkDtaQDwhp/1T6A9EkEFkb36thCierZFP6ntaKE0X1SFf9BsQMhkR
 Bn4UHMtI9cd6jLkrZsdNl/4RAM/D8/45/+0P/gwulLQIr4QLkIb3dwBHE8jHByWhIv
 oRBZnH17SpblpM7vcmsIiXPbd/2ulxtOU0RBIp6QbbzeRjW2mEJTLj7eNkCOxdmBDp
 Am3K4fgV6sDy8ZylRlw8cZ1muTtCL3Fov0+DmPJ/po0HpO6QPivAAYqSIyOPbDXcsc
 6wyyTXKnr0jSxfy62FpONLQQQdrqdAZmUtpyO2DMFF8OGmub6gTkO4zH+UlE7NW/kY
 JV1psY65wnLbA==
Date: Fri, 20 Aug 2021 21:42:53 +0800
From: Gao Xiang <xiang@kernel.org>
To: Igor Eisberg <igoreisberg@gmail.com>
Subject: Re: An issue with erofsfuse
Message-ID: <20210820134248.GB25885@hsiangkao-HP-ZHAN-66-Pro-G1>
Mail-Followup-To: Igor Eisberg <igoreisberg@gmail.com>,
 linux-erofs@lists.ozlabs.org
References: <CABjEcnGniBcadC4DDV4xCio8UmZyhSGWt+_gi_ESbYwoOQ2E0w@mail.gmail.com>
 <20210820124831.GA25021@hsiangkao-HP-ZHAN-66-Pro-G1>
 <CABjEcnEg6TSuCCTfpttXBT+Ue+iGGKv1PWNAn+WrpVE4qEQmfw@mail.gmail.com>
 <20210820132656.GA25885@hsiangkao-HP-ZHAN-66-Pro-G1>
 <CABjEcnFcM+Yib-SzNHBegabTjhoNvv7vH6WAkdZO1Vx13s-9xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABjEcnFcM+Yib-SzNHBegabTjhoNvv7vH6WAkdZO1Vx13s-9xw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Fri, Aug 20, 2021 at 04:35:52PM +0300, Igor Eisberg wrote:
> You're right, this is definitely what's missing:
> 
> >       linux-vdso.so.1 (0x00007ffeb2163000)
> >        libfuse.so.2 => /lib/x86_64-linux-gnu/libfuse.so.2
> > (0x00007ffb2d6b7000)
> >        libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0
> > (0x00007ffb2d694000)
> >        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007ffb2d4a3000)
> >        libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007ffb2d49d000)
> >        /lib64/ld-linux-x86-64.so.2 (0x00007ffb2d728000)
> >
> 
> And actually when running configure, I notice this:
> 
> > checking lz4.h usability... no
> > checking lz4.h presence... no
> > checking for lz4.h... no
> >
> 
> Not sure what I'm missing here though...

Maybe "sudo apt install liblz4-dev" for debian.

(Anyway, I may need to add another erofsfuse package for Debian sid,
 I may seek some time to do this.)

Thanks,
Gao Xiang

> 
> $ apt list --installed | grep lz4
> > liblz4-1/now 1.9.3-2 amd64 [installed,local]
> > lz4/now 1.9.3-2 amd64 [installed,local]
> >
> 
