Return-Path: <SRS0=hMKD=WS=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D122C3A5A1
	for <linux-erofs@archiver.kernel.org>; Thu, 22 Aug 2019 14:30:15 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DF04721726
	for <linux-erofs@archiver.kernel.org>; Thu, 22 Aug 2019 14:30:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iyDcrcA+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF04721726
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46Dn4N5H1vzDrRH
	for <linux-erofs@archiver.kernel.org>; Fri, 23 Aug 2019 00:30:12 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
 spf=pass (mailfrom) smtp.mailfrom=gmail.com
 (client-ip=2a00:1450:4864:20::42c; helo=mail-wr1-x42c.google.com;
 envelope-from=richard.weinberger@gmail.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=gmail.com header.i=@gmail.com header.b="iyDcrcA+"; 
 dkim-atps=neutral
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com
 [IPv6:2a00:1450:4864:20::42c])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46Dn4C1J2hzDrJP
 for <linux-erofs@lists.ozlabs.org>; Fri, 23 Aug 2019 00:30:00 +1000 (AEST)
Received: by mail-wr1-x42c.google.com with SMTP id b16so5628640wrq.9
 for <linux-erofs@lists.ozlabs.org>; Thu, 22 Aug 2019 07:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
 bh=tLNXP86xJdI97QkQX4COi/mM+VMKt9pcSlHlaNIVz3o=;
 b=iyDcrcA+H5zHrvrLuvsD0FGyWdEnoRBnP5IbVJbAX47byUeQcv8lHU84Xm5VT5nGYG
 S2FtpHG9cc3I2vlacEXtugl8kiRwpnCL2UvkqcWshkSUztVfYMywxMfmv8wlWPJkEQ1c
 lg1A+MIWM75RofPFS0CELUC4f0lhWgxu9tdBm43G6o2QGw/ViERIKzaORmguy7iEPRfF
 ZPN24ZzULsp2RNdtWZKHMujvyksYfzpeN/PSL699h/tNMh2/OFcLT63+WEM1fr/lF/NT
 EkJjPsY8DEnEe1sMTWpKKLtwlfUO2yFZv0KwscFI1z7+/NAVcMO1F+nNxKWmloP6J3cH
 rbOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to;
 bh=tLNXP86xJdI97QkQX4COi/mM+VMKt9pcSlHlaNIVz3o=;
 b=EzL4AgvefORjNsmWib9VwYqBYdj8KsMxbWPi8UU+64geImoxp2VWeNvOqD8P+kotOW
 QW07m5R1mKgQpvjhuy+dXgztORRBh6rFKb55Rq1TEzlZbPO8okGfx6V6MycnYDurpwTo
 OkjlplVITLdc/BQu6OBjLT4+p2bMWmfx/UbAcZGvt/MUmCUFmyqHC3F1zHaGoHoCKVL5
 ranJAYY1SwmyWswjjFI59BdFbtOXrLPpiyUW0F6WvIk4YkEF5fcqY+EbdgUKsdQrHvKU
 gYXfLfOX2j889xSfZ6/0/iex+smzXehbtGe//iV3OYLuBqPuRk0hjb/1XfQPEyt69U5l
 P0Aw==
X-Gm-Message-State: APjAAAUCvk5u0KInDruc9hmFFLSS6N2gs99RK+gjfJ7EzVhStlw1JFxN
 P4OFF3JwGb3yl1QKbwJHD4tmVOTyHN9euY6ycoU=
X-Google-Smtp-Source: APXvYqxzEvl4Wcc2eUsw9vwyB9jMPZsmg4spjFSLqSHbNLUQD5btzjrokrfIgE3/duKUgktNGPkNfh/tXryV41xqJu4=
X-Received: by 2002:a05:6000:12c3:: with SMTP id
 l3mr47095595wrx.100.1566484196685; 
 Thu, 22 Aug 2019 07:29:56 -0700 (PDT)
MIME-Version: 1.0
References: <1323459733.69859.1566234633793.JavaMail.zimbra@nod.at>
 <20190819204504.GB10075@hsiangkao-HP-ZHAN-66-Pro-G1>
 <CAFLxGvxr2UMeVa29M9pjLtWMFPz7w6udRV38CRxEF1moyA9_Rw@mail.gmail.com>
 <20190821220251.GA3954@hsiangkao-HP-ZHAN-66-Pro-G1>
 <CAFLxGvzLPgD22pVOV_jz1EvC-c7YU_2dEFbBt4q08bSkZ3U0Dg@mail.gmail.com>
 <20190822142142.GB2730@mit.edu>
In-Reply-To: <20190822142142.GB2730@mit.edu>
From: Richard Weinberger <richard.weinberger@gmail.com>
Date: Thu, 22 Aug 2019 16:29:44 +0200
Message-ID: <CAFLxGvzGEBH2Z+Bpv68OMeLR1JH0pe6bHn6P-sBG+epLTXbR6w@mail.gmail.com>
Subject: Re: erofs: Question on unused fields in on-disk structs
To: "Theodore Y. Ts'o" <tytso@mit.edu>,
 Richard Weinberger <richard.weinberger@gmail.com>, 
 Gao Xiang <hsiangkao@aol.com>, Richard Weinberger <richard@nod.at>, 
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-erofs@lists.ozlabs.org, 
 linux-kernel <linux-kernel@vger.kernel.org>
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Thu, Aug 22, 2019 at 4:21 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:
> It might make life easier for other kernel developers if "features"
> was named "compat_features" and "requirements" were named
> "incompat_features", just because of the long-standing use of that in
> ext2, ext3, ext4, ocfs2, etc.  But that naming scheme really is a
> legacy of ext2 and its descendents, and there's no real reason why it
> has to be that way on other file systems.

Yes, the naming confused me a little. :-)

-- 
Thanks,
//richard
