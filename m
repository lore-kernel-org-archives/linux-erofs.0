Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F533606A883
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 20:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zrXPRENf
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSzN03x1wz2xnn;
	Tue, 17 Nov 2026 07:04:16 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::42b" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794859456;
	cv=pass; b=YhAuBklwFHi0M8BhGwhPu7DhUbPyETvf+R6UwNdT37ZTaZognkKsKc8ayLK03/fHPlFBgTYSmOE394f1Eqn7wk41hzlAvVNVasTGXVPrhEnJ7GzVdQPwMc9jtSCYspUo3nEU2o+dUKre3Dk7hfVkosix6sP3VLuvg5P0pCzMyoL5HeP6o5vo8YtVqi8cQyeWSz8rNJUFDf1r3EJPYkEBZ6Qb9r1Kl76GADi4DiVxQHfU8poMrRJmnETJAsE7h3majS9A1ONfGIPa3ouEQXIAjVsp7fwv5V9tv3WQ3PH7TeioKTRWwK8UBW1aitciJaMPgZv7AY8ivMZ/dtrNkbAtzg==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794859456; c=relaxed/relaxed;
	bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AoCQAeiEi6Slhx8HqVDlt/LfuIZ1Z9GtyjvUMNZKN44cRNsLFzm0Hs51Mvuy4QLBXnEMYLce2vi/OvxjOi27atr0XiJhhQG1idichGkz2Ju1r4qd5OnnemifLgLlJnw3+lxPD0QxY9PQMthrhBLUwtiHkyhvF9ROhLhhDZLTXtynpdNI7XP45BvROa+8IH0zeZ0Pl1eFRdLbR7wxH/F4xQHkRf7Y7OXWeaynU8p+oHP0fkkTFPC0+z0U6Fc6QHjg8t1WjVT3hDv/ockYMZJ+Iva5fBmm3Cc9iwtge3q08WtLXqvgmNueyDy32yjxQP1+YTS2wj07En6sTvchyJlavQ==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zrXPRENf; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::42b; helo=mail-wr1-x42b.google.com; envelope-from=andrii.nakryiko@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zrXPRENf;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::42b; helo=mail-wr1-x42b.google.com; envelope-from=andrii.nakryiko@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSzMy5B69z2xdR
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 07:04:13 +1100 (AEDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-48e47347279so1838157f8f.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 16 Nov 2026 12:04:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794859448; cv=none;
        d=google.com; s=arc-20260327;
        b=WVILEfRRzvVZ3dMMVWuexYzRn2dgM2rEAbzh0T2Du4aMSjBUGe29+uKnQwYoX6pwaq
         iP18bL8yPLcmhNPNhOZ/uOj22B967lSCMiq1CPpzTRhVw5xXGh1mQ0mRYJi8hNAbbSgN
         gymFkFLPjhh+QPvhwMQdmUY9YgK89dSeimVASVCv8pXYD5yQZXxdVQH2HkPgfLrr/ppz
         XpyABeBT72j/NseUIygTNc2pUpnMYey22TaHX3LIhgYqq8zEyjuiwWe0NpwoRTPDePSG
         4QwBSlbSkHzgFSaEOKk32PnheZzkvYZ8dj1rmd2nU2jLn9onR1Q84Wr89LZ8k4p9n90X
         sRYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
        fh=hOfJQLX+F172+uDyP2RUetp86UrOdlN4Y/iQcrtmypw=;
        b=n4Q5WjEvnQJmFcH3btGA6tVXhDHC/xQbFYvgJkxd5ENcNVDgnEFbGLSsVwZV8bCXkL
         ODfVomVMK16u0xT66RCb+MGHq5ut9Z4IlZkWyj5suj+52tKLzxozLQKYVqJ4bQZ0suQI
         PxmwQ+UTDAMCBjg5ZtuTuxuufTeGcTcoTsICpXHtarZDo+slsqqJdlYVmjBu/jKSuRsd
         t8PuwPzhHAIydsj3l1xQTJVMA5AIZSkainVMO+WNAj6zybMehv2AgVPOdrnEXOIEPoQm
         rCaR+dhA+L0p0DHYW5ovU78kkPB2FI3HZsvPIg3eDQPE0O+E2xivL65c9An+5qVt8EPY
         g2Tw==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794859448; x=1795464248; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
        b=zrXPRENf/BfgI4+5aC3zQ1MzFoVAOap/SBCCBe4jAYmQC/hvvAKaYWZfEJgS7h8kjU
         T2YQ32S3PsR23mJZr3ZlUXCLu2UqeMcuUiPV8s3E8Fxz3rfTNTLK0RwBqsF1a5a6zRw2
         6xUWssv5Brn22R7z7IUbRjyx8xC5kvRoPO32cCJkLCWHVAjr7eGH0CoVdkVhl7pqvEEh
         TOvQxBHjnMi3NOEFjtlQ0WLB53CfG9JOexRqAAxlY3U/BMGoUya92i8SvhFwNfiFhdkN
         gXQ1jj6gJAn5VSJa4D3jvZV2usoRHynpReIEYt7blLbhWpW6QgGZFU4Mg5CN1+tZcLXc
         ckJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859448; x=1795464248;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
        b=vqreSYfkHLbtPRGftsCFziAWDVYKKZtq01AsSOu5G0xp3Z1pL6wmb/I4ExOcHhoyGT
         Oj9R747CsD7fEzmpYgXI5NxCUo28YnW0cvE21TiNbLKoAUxA6XLW6l5xPwuf1V0SN4+B
         d9uMUkuz7TbqqfS/Po6YvUakd+qbnhCGKcgom0wTRdJILg7oDzogHGdrCwl8AO+/qsMd
         /0kj+URXLDqoI/P67I5DnXaJJpqeFxZ+kIQ4o5hcVoMmasBO38tE2BP/B97siE8ASvDA
         a//KWoc8B17aWksAS/5yK/Z+iCvQ/nrhyGYLh6B1DlQeNE+F1Ow1xWcdaxRZJ79vPIXf
         Sumw==
X-Forwarded-Encrypted: i=1; AL+hErGtP42r3mqKx7R5la2NGb+g0UkYYGe4zg2ECWxH5Jj1qIFtmKYhaHlMICCjtqs0rA6nsNDGs5LY+F5mUA==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z+237MtHVR6rFr/9IQRGozb15D9Uqr62UOYnrrJ4rJDLY2rfE/a
	4LmyL+vBXAeQnXCllOyUDrxfhVeAgoUMCN5Tr+f2RTFcsGWblm8NJGlhqaPHDPjHCB5+t2FAajq
	+3Rsl6wJAvywmaXaav76MATRTuRNR1iQ=
X-Gm-Gg: AZFdTZf7JvhnKXbpen/bGdgtnRQo3+NKACBVJRFOhAhA8xfmDtLNal2+DrjiqhFJ37L
	672iwVT8G6UvfKN++UXGa4o4mxHoxDVodNKri7FZW5JhdLokrhM/bQkWkXkH5LJTrwTwj7SyXRl
	qb6Q4Oh2wLon1cuG8tWoi2/GWwDSa7b2wvak4GwOBtOIw/AGDQZhVwQj2CddoGM8ggd9ZzXvk3F
	3rDE7jvVF3183a4u4uzTXwk8pANaRfxp/fy+4NQuw/xFL99tegMbHIGrYhpbevSSXYLwe38BZvv
	LlyvsClgZ/hJ2+wxnu6VmeBis/lvaaEvqiZh1P3I8C5e1Pi8Xt1lCJvVgIyO/pxgQBVO+UvJ4sr
	CSpaNSJf/TE4WuEMVpKx7azbyA9bmg9mDtSTOwW29FB5Kzmgq8ag/KNkImtfKjr4KkgrY2PJ96/
	z8VFJHNgsRaBIZr/6UCjs=
X-Received: by 2002:a05:6000:4692:b0:491:3fdd:af34 with SMTP id
 ffacd0b85a97d-49d61c80db3mr13343868f8f.36.1794859448335; Mon, 16 Nov 2026
 12:04:08 -0800 (PST)
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org> <20261116-work-loop-pseudo-v3-9-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-9-8cbbea1cf34f@kernel.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Mon, 16 Nov 2026 12:03:57 -0800
X-Gm-Features: Aa3M54q6P4M0RFDCKQ8HHGNCWJafItTSPdWR1qNwVGtToDAv2VOv8vDfWHzYR6A
Message-ID: <CAEf4BzbLFVawibuX0wk=8uzy0WZSYHbkgK55d7rqLab2qAM1Fg@mail.gmail.com>
Subject: Re: [PATCH RFC v3 09/44] bpf: use fc_init_pseudo() for bpffs
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, 
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org, 
	Alexander Mikhalitsyn <alex@amutable.com>, Chris Down <chris@chrisdown.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 3:21=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> Initialize bpffs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  kernel/bpf/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Acked-by: Andrii Nakryiko <andrii@kernel.org>

> diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> index c6f328e4752e1..57cf3775c0766 100644
> --- a/kernel/bpf/inode.c
> +++ b/kernel/bpf/inode.c
> @@ -15,6 +15,7 @@
>  #include <linux/namei.h>
>  #include <linux/fs.h>
>  #include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
>  #include <linux/fs_parser.h>
>  #include <linux/kdev_t.h>
>  #include <linux/filter.h>
> @@ -1197,8 +1198,6 @@ static int bpf_fill_super(struct super_block *sb, s=
truct fs_context *fc)
>         sb->s_magic =3D BPF_FS_MAGIC;
>         sb->s_op =3D &bpf_super_ops;
>         sb->s_xattr =3D bpf_fs_xattr_handlers;
> -       sb->s_iflags |=3D SB_I_NOEXEC;
> -       sb->s_iflags |=3D SB_I_NODEV;
>         sb->s_time_gran =3D 1;
>
>         inode =3D bpf_get_inode(sb, NULL, S_IFDIR | 0777);
> @@ -1261,6 +1260,7 @@ static int bpf_init_fs_context(struct fs_context *f=
c)
>         opts->delegate_attachs =3D 0;
>
>         fc->s_fs_info =3D opts;
> +       fc_init_pseudo(fc);
>         fc->ops =3D &bpf_context_ops;
>         return 0;
>  }
>
> --
> 2.53.0
>
>

