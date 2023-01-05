Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2F65C3DA7A
	for <linux-erofs@archiver.kernel.org>; Thu,  5 Jan 2023 11:14:39 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4NnkQ61Dmqz3bZ4
	for <linux-erofs@archiver.kernel.org>; Thu,  5 Jan 2023 22:14:38 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1672917278;
	bh=qMRjHUwJUvRGpT0uK5naDeFxSpoQz5G/C8mDQel+RtE=;
	h=References:In-Reply-To:Date:Subject:To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=KUG4kqebnG6nk+CU3GvV1PFMgSpSt1u/2n3R87MS4jWDY9ZoNxmGIWgb1rxXb2tlK
	 A0GI1jaLMwUeSuvmflO7q2sGcIbGHnomFNoZw75D2K4bPzYzKrFf58MPbYIpJcVPpM
	 2NPHX/QDlJ/QNmT8S8XRd+lMo4krNuRag70PKd78YXuCqTyp5W5V+27mFsPw/eG9Le
	 imM0MWbyxQwV/QiMeNSxbzalj8aM1DW7zI7qpJXNLrfcYZKbv6YHYGeR/JIFPXh0in
	 t3Ee1YRDMFZ9w1QMbT2POX+VjibtLWzBjYMD/FJqepRzLM9ACDC5jJq9udi5LFV2cO
	 roMxmrIhgcDGQ==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=google.com (client-ip=2607:f8b0:4864:20::e33; helo=mail-vs1-xe33.google.com; envelope-from=nogikh@google.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20210112 header.b=f2VaMp8w;
	dkim-atps=neutral
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4NnkQ05jW6z2xvL
	for <linux-erofs@lists.ozlabs.org>; Thu,  5 Jan 2023 22:14:32 +1100 (AEDT)
Received: by mail-vs1-xe33.google.com with SMTP id 3so37715970vsq.7
        for <linux-erofs@lists.ozlabs.org>; Thu, 05 Jan 2023 03:14:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qMRjHUwJUvRGpT0uK5naDeFxSpoQz5G/C8mDQel+RtE=;
        b=ALAL06CQ/FcilCWrZF1kOO3HvzqOG4iHc7d7jRpWbF/mM4i1fRb4alKte5+mEudxql
         YuXOiDQqU5u9IspgIy1VblAN1SfL8jbG/y9J0539gmIdv0HO2KAkKs12LYj7NWimX2SX
         ZrJv/7bBlqD6IhBHk2NvxPQVOc6CyqHoxSvB945TRtZUfcAx+dFEaYD7so7Wx1HWaS76
         aIygsigmpU3HFqazdI6XYN08uEUBY0IM31bB9Ixxr7QNEHbwlD8pBGcQ6TwdSck7pmwG
         d/LISAP6BCAnxroiFSjOsi0N7AyUneO6U43m6eADiYaejaWfFJem7XaFrvpUP4y7kTIe
         OZ+Q==
X-Gm-Message-State: AFqh2kpsgKs3Wsx2AMBswCugqKpWbzRC49+bp81uzJWhYNzzLiYfcsZ1
	SYYidcmxKxZ0GKOrMGslJT1TnmGk7SDDsrXkbGLkUA==
X-Google-Smtp-Source: AMrXdXu3qt6GSNBK0DAgHXtuNuKyf7FK7GkUKwWLAta6G5qZTKO6FTIf3n0KgIq8UrBgua6uqEOv0OJ9IUU8u6c6Pms=
X-Received: by 2002:a05:6102:3ca8:b0:3ce:88b3:bdca with SMTP id
 c40-20020a0561023ca800b003ce88b3bdcamr2111697vsv.48.1672917268961; Thu, 05
 Jan 2023 03:14:28 -0800 (PST)
MIME-Version: 1.0
References: <000000000000c0a08805f07291a0@google.com> <f126fc95-fdbe-cc2e-5efb-ab704d13bd41@linux.alibaba.com>
In-Reply-To: <f126fc95-fdbe-cc2e-5efb-ab704d13bd41@linux.alibaba.com>
Date: Thu, 5 Jan 2023 12:14:17 +0100
Message-ID: <CANp29Y63rCdepVtantxdJEcvbRv0D61gfY_oGV7dgrmEGgPdLw@mail.gmail.com>
Subject: Re: [syzbot] [erofs?] WARNING: CPU: NUM PID: NUM at
 mm/page_alloc.c:LINE get_page_from_freeli
To: Xiang Gao <hsiangkao@linux.alibaba.com>
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
From: Aleksandr Nogikh via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Aleksandr Nogikh <nogikh@google.com>
Cc: syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux-erofs@lists.ozlabs.org, syzbot <syzbot+c3729cda01706a04fb98@syzkaller.appspotmail.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi,

On Thu, Jan 5, 2023 at 11:54 AM Xiang Gao <hsiangkao@linux.alibaba.com> wrote:

> I wasn't able to build the kernel with this kernel config, it shows:
> "...
> FATAL: modpost: vmlinux.o is truncated. sechdrs[i].sh_offset=1399394064 > sizeof(*hrd)=64
> make[2]: *** [Module.symvers] Error 1
> make[1]: *** [modpost] Error 2
> make: *** [__sub-make] Error 2
> "

Could you please tell, what exact compiler/linker version did you use?


> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/0c8a5f06ceb3/disk-f9ff5644.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/be222e852ae2/vmlinux-f9ff5644.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/d9f42a53b05e/bzImage-f9ff5644.xz
>
> Finally I tried the original kernel image, and it printed some other
> random bug when booting system and then reboot, like:
>
> [   36.991123][    T1] ==================================================================
> [   36.991800][    T1] BUG: KASAN: slab-out-of-bounds in copy_array+0x96/0x100
> [   36.992438][    T1] Write of size 32 at addr ffff888018c34640 by task systemd/1
< .. >

Interesting!
I've just tried to boot it with qemu and it was fine.

qemu-system-x86_64 -smp 2,sockets=2,cores=1 -m 4G -drive
file=disk-f9ff5644.raw,format=raw -snapshot -nographic -enable-kvm

So it looks like it's some difference between these VMMs that causes
that bug to fire.

>
> May I ask it can be reproducable on the latest -rc kernel?

We can ask syzbot about v6.2-rc2:

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
88603b6dc419445847923fcb7fe5080067a30f98

>
> Thanks,
> Gao Xiang
>

--
Aleksandr
