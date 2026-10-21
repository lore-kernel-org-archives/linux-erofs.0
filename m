Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5A0606A320
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Oct 2026 09:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ie+TBEdi
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j8kqR0KPtz2xSF;
	Wed, 21 Oct 2026 20:43:15 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::52f" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792575794;
	cv=pass; b=CXRrf1tWWll2NJbKFbJZTl0qwGu1qr6/8rcdgl1tP+VXA/BTyoBVHmm7kNUV8PlRgMI7nq9hJnM4HH0Qm+7WicbJe5kyZZN1Qf0R3UOs1EmuykD1Q5iOH0dOfm3JeoYQDdsYNlP8l2tHBusb3Ue4khGNfJG75RWdOPjSB0EfXMqhQsCG+rRNCYUDiPcwACvLhI6cj1uWfXViXW8BHRhaoCbTin0gb759jECk8B33ALm4XvsoH4oPDTxtyejsonkGOzOF5H0rnu4Q6NpnLRPa9R9GMxjWZPofxe7LgC7VjWM7j9pIwseOdA0bOdTIihNdh3DqeI8TAH+fTZqHwIYEtg==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792575794; c=relaxed/relaxed;
	bh=MntThF0zJNx5wgWPLxaCNehOSFPp3KxM+IXJC9mIRCA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fy9n7KjA6ruYquiqHuLkQXg/obZewm933j88N91Lk3/G/8cANHlEIpo/N6YuUiqk7mdLIQP/x2N8ay61Y5LakUmCf1DxTyPyqPdW9Zr2p+QecHkzIkuh3lC7/ekBxi/C8eFRALeyn7JJ2OUu21vpxh8nyxQ7MiFruOS9RgI86ie3eWfqXT9HgNw3FGfTFbQrCGHSZs6+6Tj+v2X7+c2MCKi6k+OX9YF7xYfUEEJwGxL8CHtEofIGmXQtPxdgbAhUqyKHJDBEwRzQeOdGDjA+oaIzpECqq5BCz61UBcDRM5Wv44woxm8Vro28nsg78ZbRrF3+o7H4aHFl66rkYGYmaw==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ie+TBEdi; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::52f; helo=mail-ed1-x52f.google.com; envelope-from=amir73il@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ie+TBEdi;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::52f; helo=mail-ed1-x52f.google.com; envelope-from=amir73il@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j8kqP02Rzz2xPW
	for <linux-erofs@lists.ozlabs.org>; Wed, 21 Oct 2026 20:43:12 +1100 (AEDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-6b1aa2848d2so516450a12.3
        for <linux-erofs@lists.ozlabs.org>; Wed, 21 Oct 2026 02:43:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792575787; cv=none;
        d=google.com; s=arc-20260327;
        b=YYXNlkC9HP9pcmlmijSxe95BLRao0TBVfRiOOSoTx8LHw2fGO13H3C5hqvnFbpLHDe
         1e9yWV0iqaIeCfkAlRcKuUDda5Mlc5HsFGPzEdq1+TLzQdgBC6+SOuOhxEHPe17PKxVL
         QFmANb51m/kRZC44TzSEORZqiRNqzUmo86oiymIbOawiQxzrteD5pSTjBpVZDgZZCkgv
         kWWY9dipdURkXXlJy6cJj5VRrrMGN2seA42pC1wbNMkWzraRq0lFs6OpuyONAlrihAlK
         Hr4cBg14unWAMLvKiXvZHO7mjYA7enJQQTBwwdztjzFh+epLOLPymvCPW0rq/h2DFQuC
         hm3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MntThF0zJNx5wgWPLxaCNehOSFPp3KxM+IXJC9mIRCA=;
        fh=oDgb3odVRGZHGQ7BKyda+Ksl38Kdt7HGJntOQaKVkrk=;
        b=K83smSftm/UEMmmhTqpSHTG5pYD6YstcAPdRRrGMyau7Z+Rj360RNYK6Tkj7gPvj4w
         h73tnpdAnnk43wR6lIk7+8wA0PIpUGElYh8fUsvVx7uaVsLYX9KCE+tLWBml1iuODOWM
         d38Oy90kUdKWWvKmg0xp4aS34fpJpQ0YAGv4ZMi30xyCH1Q6u3FHl7kJ41NNdqrZZRBe
         q17KHSlpEWa6mvwUra9nEJs97vhXf/WHkE2CE+/7nQGi4eeSkk8aTYYZ6hZ6dTlO13Z1
         Yb5zcLn2KiAT9ysNGlKMEmvF4N7/GOBMfsWatn77SbrSy19hPCVA6NPkoz6w4Ngo0gga
         Z43A==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792575787; x=1793180587; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MntThF0zJNx5wgWPLxaCNehOSFPp3KxM+IXJC9mIRCA=;
        b=ie+TBEdibfP8SJOGONWybBcm78dOcrsLdP4YcN9c4lFm7jvmtaDiYBy7KxRD87818l
         40F/XEOZB0uoHsZ+CDe0bj/H0hjiqcto3hY60RjOPlNoNyW3xoY+U8A1M7e4ORy7aKke
         Fy/1UoNxhf6BEGewX6yYL+hcooxiSi0627BCisp6F5T2TIk4C47LdMnfrlkpZ0HQlypQ
         BRzRbo7mPpboPrAAe0erWhSWCpikcma1Mj0jvcbVdUoi9svv6RsdnUOhC8kyzOdSxnQY
         SbSRYkkxa6DRYgSWUkSJ2tqvuOBTN1TCyIZFsxbhDEy0MlsBnvQ0cqVbcbuzy6wmbnhC
         ECOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792575787; x=1793180587;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MntThF0zJNx5wgWPLxaCNehOSFPp3KxM+IXJC9mIRCA=;
        b=WQ3diYWogTjV0uxt0JxksbrCYWoRidsA4UKE14rRjXxPjAiurUxP+Vp30rw+jzEJEO
         i+z+zQF34lFLflsGDXkMeHja89HkO9ICo7UomI4VHEwkpsoJEvZGBNQ7hnfY6USD+r6I
         rQVGBqryDVm6nOh0DCtjViLalhdrXOhhyygTzdyJNZvr7WDEG/Ays/rTgKAYGIRRg1Ox
         WU17L7v5RBxmO/8xWPD6BRQuz0UitwH8Fl3JpO5E/EMrVoLji2854LoCoH61t57Ybijw
         bfu2ruIF6tiShFJQVsDCCdfYh0KdOBZMf1/h+CJnSEweOnUst9Thi4utEI4xGh5KoSOP
         01IQ==
X-Forwarded-Encrypted: i=1; AKwUvBxN+maJQcR+vXbUx4Ik75uP7jeB7Rd3BymJj2P2qWKnUzzWEM/EtdEz1PD3brw3unIcXhuPwEtrCiwSeA==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYIrdhhlRxrwn5hdkVb+BxXA0XxPBZ5F454nl6UTnwB32Ad9bE7b
	CaTrRVNpoNXHdc82eTO2T4ATxNO18iFVFhyDPQM/OSQSt7lj5H02sMhBpAxUJzTGhI0hjOWSZL0
	Fv37kaI9TyI9f1UxMFVsSGWlvnRHXI7Q=
X-Gm-Gg: AYBFou3cmqQZFSKLhqL7DSm3VCQ24PgRq8EWGqqbeBdpBNhwFx/EWK15o4qVLZzgPSO
	SgasUq/cqEt1qhREC1Lir4o8ZuaOMLLj901uncxhtbL+uUoK+4I8p4uNEoR9p7tZVUQStLOnrMz
	L19tHwmbYyQEpY6XVoZdtV3rtsYdTRNAyEnzL7IYIki4xa6BTN+ncCkzbPHUuT5gsGbMA9tSg3D
	56Qhu8Ed5cB0kuJa9jD1qjEI3kNhm7mozGg5fD31oN6fouixhYh8EmcueTbKjZqgH7kbniprHt/
	CDzKflF7JDXN4On2xMUg6z5bThS2/5tArTeLt6xBJRn8UEOoGSvRyrgJJ/PIAUcznf3gKw2+SFH
	x7i5W5XENSHT6B+f83e8M8em2jEFn81luQVXV
X-Received: by 2002:a17:907:c499:b0:c41:f29:72b1 with SMTP id
 a640c23a62f3a-c4679b52fb4mr128636066b.47.1792575786748; Wed, 21 Oct 2026
 02:43:06 -0700 (PDT)
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
References: <20261010094000.2036805-1-friendy.su@sony.com> <asqsNhtlXaEOrEky@XiangdeMacBook-Pro.local>
 <TY0PR04MB6191A63F6B79E4109D185F41FD9F2@TY0PR04MB6191.apcprd04.prod.outlook.com>
 <athyOw_WoXy9-NDR@MacBookPro> <TY0PR04MB619129E92AA946EDDB179AC1FD662@TY0PR04MB6191.apcprd04.prod.outlook.com>
In-Reply-To: <TY0PR04MB619129E92AA946EDDB179AC1FD662@TY0PR04MB6191.apcprd04.prod.outlook.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 21 Oct 2026 11:42:54 +0200
X-Gm-Features: AclHuK86ptQxjZGSQZAMWjUka8c9G1xaaTLy_CNP4cKT7z-xfVp4iAf5A8vRYgY
Message-ID: <CAOQ4uxjWf2A57sKvGtLU9A1AAjtPD2fvk9GXKXLX_b98NYZZPw@mail.gmail.com>
Subject: Re: [PATCH v1] erofs: enable SB_I_ALLOW_HSM to support fanotify pre
 access event
To: "Friendy.Su@sony.com" <Friendy.Su@sony.com>
Cc: Gao Xiang <xiang@kernel.org>, "chao@kernel.org" <chao@kernel.org>, 
	"linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"Yuezhang.Mo@sony.com" <Yuezhang.Mo@sony.com>, "Daniel.Palmer@sony.com" <Daniel.Palmer@sony.com>, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 11:43=E2=80=AFAM Friendy.Su@sony.com
<Friendy.Su@sony.com> wrote:
>
> Thanks for your comment.
>
> I will send patch v2.
>
> ________________________________________
> From: Gao Xiang <xiang@kernel.org>
> Sent: Wednesday, October 21, 2026 16:05
> To: Su, Friendy
> Cc: Gao Xiang; chao@kernel.org; linux-erofs@lists.ozlabs.org; linux-kerne=
l@vger.kernel.org; Mo, Yuezhang; Palmer, Daniel (SGC); Amir Goldstein; Jan =
Kara
> Subject: Re: [PATCH v1] erofs: enable SB_I_ALLOW_HSM to support fanotify =
pre access event
>
> (+cc Amir, Jan) On Wed, Oct 21, 2026 at 07:=E2=80=8A18:=E2=80=8A06AM +000=
0, Friendy.=E2=80=8ASu@=E2=80=8Asony.=E2=80=8Acom wrote: > Hi Gao, > > Sorr=
y for late reply. > > We have considered fanotify in erofs-utils. I think i=
t must be used with > file-backend mount. It
>
>
> (+cc Amir, Jan)
>
> On Wed, Oct 21, 2026 at 07:18:06AM +0000, Friendy.Su@sony.com wrote:
> > Hi Gao,
> >
> > Sorry for late reply.
> >
> > We have considered fanotify in erofs-utils. I think it must be used wit=
h
> > file-backend mount. It actually utilizes FAN_PRE_ACCESS on ext4 or xfs.
> > Also file-backend mount can not support DAX mount.
> >
> > But for our case, file-backend mount can not be used. Firstly, there is=
 no
> > ext4 or xfs file system in actual environment to put a sparse erofs ima=
ge
> > file. We have to mount a normal block device. Secondly, mount must be D=
AX.
> >
> > The basic flow is file content is fetched from remote then filled into
> > local erofs file on the DAX mounted block device in FAN_PRE_ACCESS hand=
ler.
> >
> > "/dev/loop0" is just an example, not our actual use case. The actual bl=
ock
> > device is something like /dev/pmem0.
> >
> > In order to make SB_I_ALLOW_HSM only set under block device backend,
> > we can do like this:
> >
> > if (!erofs_is_fileio_mode(sbi)) {
> >         /*
> >          * Allow HSM to support fanotify pre access event
> >          */
>
> nit: single line /* Allow HSM to support fanotify pre access event */
>      according to EROFS code style.
>
> >         sb->s_iflags |=3D SB_I_ALLOW_HSM;
> > }
>
> I am fine with that as long as you limits SB_I_ALLOW_HSM **only if**
> s_bdev is valid (IOWs, I hope we don't need to bother it with EROFS
> SB_I_ALLOW_HSM + file-backed mounts; it aligns with other filesystems).
>
> Also I think it would be better to add a testcase to check the basic
> EROFS SB_I_ALLOW_HSM functionality in erofs-utils (see
> experimental-tests). You don't need to add support for EROFS
> SB_I_ALLOW_HSM directly in erofs-utils; but a basic functionality
> testcase for this is needed.
>
>
> BTW, for your use cases:
>
> > mount must be DAX.
>
> As for virtio-pmem, why not just use userfaultfd on the host for
> virtio-pmem lazy pulling? for example,
> https://urldefense.com/v3/__https://github.com/firecracker-microvm/firecr=
acker/issues/5740__;!!O7_YSHcmd9jp3hj_4dEAcyQ!1I4HPp-ti8SbtdVUzxl0B0QuNCpDM=
YyUh1CGGxNZEvFSg_lZnXaDitDh6Clg2me7wzbPbUl2X5E_vw$
>
> Personally I still don't think monitoring FAN_PRE_ACCESS of EROFS for
> this kind of usage is a good idea.

Personally I agree that this is odd, but practically, this allows getting
FAN_PRE_ACCESS events with extra range info on erofs file's access.

I don't see the risk in allowing that so I have no reason to object.

Thanks,
Amir.

