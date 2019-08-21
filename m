Return-Path: <SRS0=D63+=WR=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB5CC3A59E
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Aug 2019 21:38:51 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C9CA522CF7
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Aug 2019 21:38:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RbBqg9V8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9CA522CF7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46DLdN56pxzDr1K
	for <linux-erofs@archiver.kernel.org>; Thu, 22 Aug 2019 07:38:48 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
 spf=pass (mailfrom) smtp.mailfrom=gmail.com
 (client-ip=2a00:1450:4864:20::343; helo=mail-wm1-x343.google.com;
 envelope-from=richard.weinberger@gmail.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=gmail.com header.i=@gmail.com header.b="RbBqg9V8"; 
 dkim-atps=neutral
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com
 [IPv6:2a00:1450:4864:20::343])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46DLcG3bWHzDqTv
 for <linux-erofs@lists.ozlabs.org>; Thu, 22 Aug 2019 07:37:47 +1000 (AEST)
Received: by mail-wm1-x343.google.com with SMTP id d16so3611290wme.2
 for <linux-erofs@lists.ozlabs.org>; Wed, 21 Aug 2019 14:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=CGamQBqn1keeDQN/dGpkbx0uGpXlzGw+M6ZDH31XElA=;
 b=RbBqg9V8SrwdXevvHNV0QKavqk/28xEtPZ3W/OlWlz8+aKGa9kG5/6fWjPax/AByHW
 6mYDCOBP2FfikHJCKQZ1o8qe5bpRJMZkibEAZTCohh1gbMxJJp1VlYMfoAwcgbKsz1Iv
 CeXTP4sT9dAup43HxREz/U1SvMxD0fW/dUdFRqSRuNMA4Flc+ya5pwFtjR3Ulbk05IHk
 dYsUAg3Ahqp3d6sCv28s3axERBLG+O982Co8NF5XSCkK7I1KbqKpypTuhODD9VOlI+pu
 Q+ltJtwjnlVEwd+AUU0UuKUCX6ei/l6y28QyKzzzkPcqzmNH6MzlBRh128CzrxtHExgA
 noLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=CGamQBqn1keeDQN/dGpkbx0uGpXlzGw+M6ZDH31XElA=;
 b=mm2eRP02lQSCNeAZNEO6vNpMocWvbiokaKXJlnSyb0dsdf4T1i8DhcmeN9tPGR21Vx
 DZ0LQtHH/KxBooOfMbicxRKu1WxpjE8dMLDhBafVHx50Ccuixe4TzWxnIwfA0FUIUb9t
 DsyEIoMnEiZ1c5PS/qD1ZCnWz0j016qcoGrleWGpjXafh5KownoFqnthfabkMv4KpuBJ
 d279mUaBjsPOr9Nx3pslWuBU1u2SIAdkQW1TQoiKCQ1s+9YfhpK09RwF/PndA8nZp8Sn
 4i7eo8pWxFUc6COZJ1sjpKTbD4hLRHZqLkutV2W0cYIPz4fV0AtwrsPjTVpc0s9X1tTF
 rQ2w==
X-Gm-Message-State: APjAAAUjXRzbArBpF/IN3oyYXHPTgo3tNvRD40VRElfA3Rk9H3sKdAI4
 uU+ijfSNUxHzmbscOyySyvQ8ogi9FlJNm6lcqi4=
X-Google-Smtp-Source: APXvYqxoaRWdCrsG/kgUVdNL3EM8gAOA2OOvXziMDbBBHuofOfCBAtKBmJ71Tdi0++f91VjW0Uc3UJepG9e22e4bECM=
X-Received: by 2002:a7b:c155:: with SMTP id z21mr2225753wmi.137.1566423461598; 
 Wed, 21 Aug 2019 14:37:41 -0700 (PDT)
MIME-Version: 1.0
References: <1323459733.69859.1566234633793.JavaMail.zimbra@nod.at>
 <20190819204504.GB10075@hsiangkao-HP-ZHAN-66-Pro-G1>
In-Reply-To: <20190819204504.GB10075@hsiangkao-HP-ZHAN-66-Pro-G1>
From: Richard Weinberger <richard.weinberger@gmail.com>
Date: Wed, 21 Aug 2019 23:37:30 +0200
Message-ID: <CAFLxGvxr2UMeVa29M9pjLtWMFPz7w6udRV38CRxEF1moyA9_Rw@mail.gmail.com>
Subject: Re: erofs: Question on unused fields in on-disk structs
To: Gao Xiang <hsiangkao@aol.com>
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 Richard Weinberger <richard@nod.at>, linux-erofs@lists.ozlabs.org,
 linux-kernel <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Gao Xiang,

On Mon, Aug 19, 2019 at 10:45 PM Gao Xiang via Linux-erofs
<linux-erofs@lists.ozlabs.org> wrote:
> > struct erofs_super_block has "checksum" and "features" fields,
> > but they are not used in the source.
> > What is the plan for these?
>
> Yes, both will be used laterly (features is used for compatible
> features, we already have some incompatible features in 5.3).

Good. :-)
I suggest to check the fields being 0 right now.
Otherwise you are in danger that they get burned if an mkfs.erofs does not
initialize the fields.

-- 
Thanks,
//richard
