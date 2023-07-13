Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F0F4C001DE
	for <linux-erofs@archiver.kernel.org>; Thu, 13 Jul 2023 23:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1689289736;
	bh=7MIq8bTzHJaUBMG7MB1mjwVxSlLGLbSF+iBBc0I9Blo=;
	h=References:In-Reply-To:Date:Subject:To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=FuCBCXGbnqt4FyMKgXmv1M6bmcXU1i2YAiIwIJcouzfQNQP2Av2Fzcx+l/m4xHT3f
	 VkrvdXdtsq2TmRw0wEX6fRjTjbDgR54t7ltn9JMhgyWrMzT0ZPTcdv9evLXdu5oRVt
	 +3NZp0tk39J90kgdwlY/3qjlo3gOUA8Wg3bdM7jNiiqVxswMBt6rmzLGHzOE5AO4AS
	 El4Y0t3YGGJxV2PbDYknsbVRIkwxz5Gz8WF6fu/MNn3bgjmLqixvoAzCsoOJ64iOiw
	 mtDrfYhL1RB0XeEaCflJC1F1mKCN141NXlXFqhs0z12XywfRZgWKa9djvZNou+PFsE
	 xndqnfcfJE2+w==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4R29K46P53z3c5P
	for <linux-erofs@archiver.kernel.org>; Fri, 14 Jul 2023 09:08:56 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20221208 header.b=GmGWN0bF;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=google.com (client-ip=2a00:1450:4864:20::336; helo=mail-wm1-x336.google.com; envelope-from=dhavale@google.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4R29Jz36rtz3bNm
	for <linux-erofs@lists.ozlabs.org>; Fri, 14 Jul 2023 09:08:50 +1000 (AEST)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3fbc54cab6fso12074495e9.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 13 Jul 2023 16:08:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689289721; x=1691881721;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7MIq8bTzHJaUBMG7MB1mjwVxSlLGLbSF+iBBc0I9Blo=;
        b=JHXDoQvFHAwQcDPNGfCWclJGW58B0mgEsTDOQaRkmU1qM5jA5fSkeizeKhPY7WxSOW
         aZ+T5S+E7KroZMIXFxs4mZnALqqUac6UAfA7jCBvvtija+wKJC9Wqr+30IN0HPtiigK+
         DFoA3rmbNup0LLtnnheDLMKhs65ANQhI2BlyeJlYBf6Wf0EJRrmsIOZnLn8I1slOlkBe
         FujfbGIg8QfhyWSdLsgpgeiR0theU8koi28Kme/9BPikt6M1EICgmNZ7dsq+CGZsZ+Tc
         MUNnMz7SPQJJZhL57MHH2LJTin1Q9vR8YZNJ3AitByvhMPC2S/QKPrgyPpVqAsukqgUh
         yVEg==
X-Gm-Message-State: ABy/qLZnIuX5FrmEzPocNdEySSympS0Q53oOqzA5BoJnORTsY76brjS3
	3L4APQomiax5GhWFHd1j9dsIJQCYLmbrkvNqlAeRgQ==
X-Google-Smtp-Source: APBJJlEXzrAclXWVxYwGAmtlIpk6nS9KAbCBTtui9wvHi9uUzxWq0odQGTMSmxgCGTjogJzTvdm61WONNB0CrmpkFeo=
X-Received: by 2002:adf:ff8c:0:b0:313:eadf:b827 with SMTP id
 j12-20020adfff8c000000b00313eadfb827mr2503418wrr.56.1689289721521; Thu, 13
 Jul 2023 16:08:41 -0700 (PDT)
MIME-Version: 1.0
References: <f124e041-6a82-2069-975c-4f393e5c4137@linux.alibaba.com>
 <87292a44-cc02-4d95-940e-e4e31d0bc6f2@paulmck-laptop> <f1c60dcb-e32f-7b7e-bf0d-5dec999e9299@linux.alibaba.com>
 <CAEXW_YSODXRfgkR0D2G-x=0uZdsqvF3kZL+LL3DcRX-5CULJ1Q@mail.gmail.com>
 <894a3b64-a369-7bc6-c8a8-0910843cc587@linux.alibaba.com> <CAEXW_YSM1yik4yWTgZoxCS9RM6TbsL26VCVCH=41+uMA8chfAQ@mail.gmail.com>
 <58b661d0-0ebb-4b45-a10d-c5927fb791cd@paulmck-laptop> <CAB=BE-QSaRKvVQg28wu6zVoO9RwiHZgXJzUaEMdbtpieVLmT8A@mail.gmail.com>
 <39923da8-16a1-43a8-99f1-5e13508e4ee4@paulmck-laptop> <CAB=BE-QNFhOD=xe09hiZOLmDN7XQxnaxyMz1X=4EeU7SFKaRKA@mail.gmail.com>
 <32b8c9d5-37da-4508-b524-fc0fd326c432@paulmck-laptop>
In-Reply-To: <32b8c9d5-37da-4508-b524-fc0fd326c432@paulmck-laptop>
Date: Thu, 13 Jul 2023 16:08:29 -0700
Message-ID: <CAB=BE-SwUTDkVvd5s3-NjEzBTqoZnHFdZg0OU-YVK+h3rxnEuw@mail.gmail.com>
Subject: Re: [PATCH v1] rcu: Fix and improve RCU read lock checks when !CONFIG_DEBUG_LOCK_ALLOC
To: paulmck@kernel.org
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
From: Sandeep Dhavale via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Sandeep Dhavale <dhavale@google.com>
Cc: kernel-team@android.com, Will Shiu <Will.Shiu@mediatek.com>, linux-erofs@lists.ozlabs.org, Frederic Weisbecker <frederic@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, Josh Triplett <josh@joshtriplett.org>, Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, Matthias Brugger <matthias.bgg@gmail.com>, linux-mediatek@lists.infradead.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Joel Fernandes <joel@joelfernandes.org>, Gao Xiang <hsiangkao@linux.alibaba.com>, Zqiang <qiang.zhang1211@gmail.com>, Neeraj Upadhyay <quic_neeraju@quicinc.com>, Boqun Feng <boqun.feng@gmail.com>, linux-arm-kernel@lists.infradead.org, AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

>
> Sorry, but the current lockdep-support functions need to stay focused
> on lockdep.  They are not set up for general use, as we already saw
> with rcu_is_watching().
>
Ok, understood.

> If you get a z_erofs_wq_needed() (or whatever) upstream, and if it turns
> out that there is an RCU-specific portion that has clean semantics,
> then I would be willing to look at pulling that portion into RCU.
> Note "look at" as opposed to "unconditionally agree to".  ;-)
> > > I have no official opinion myself, but there are quite a few people
> > ...
> >
> > Regarding erofs trying to detect this, I understand few people can
> > have different
> > opinions. Not scheduling a thread while being in a thread context itself
> > is reasonable in my opinion which also has shown performance gains.
>
> You still haven't quantified the performance gains.  Presumably they
> are most compelling with large numbers of small buffers to be decrypted.
>

Maybe you missed one of the replies. Link [1] shows the scheduling overhead
for kworker vs high pri kthread. I think we can all see that there is non-zero
cost associated with always scheduling vs inline decompression.

> But why not just make a z_erofs_wq_needed() or similar in your own
> code, and push it upstream?  If the performance gains really are so
> compelling, one would hope that some sort of reasonable arrangement
> could be arrived at.
>
Yes, we will incorporate additional checks in erofs.

Thanks,
Sandeep.

[1] https://lore.kernel.org/linux-erofs/20230208093322.75816-1-hsiangkao@linux.alibaba.com/
