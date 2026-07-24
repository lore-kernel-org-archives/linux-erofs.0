Return-Path: <linux-erofs+bounces-4000-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1C9DC53215
	for <linux-erofs@archiver.kernel.org>; Fri, 24 Jul 2026 15:32:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h6Bny5vmDz2yfD;
	Sat, 25 Jul 2026 01:32:54 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::b135" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784907174;
	cv=pass; b=HBrD8nQc4nsks0jvbwcBGS5/Nh1yXeKb7LJZHoQ8iwSk+6Xhv9aqY3oEWifitCCpvXvZXY15nOlpFg/+RIoV4zZG/yITNwZcYJFqQRJR4z0aJXLxrt2Jj2K+cOX0Ri91BsLZ8gXtDKtH6lH0YHwiCSunJfOhkqc5/tsiM6ca1oQqfL+hNbuL5DV1eMdoU7jeKGiSU9hlAhB1+buX6m5OP/x48RIaFT0x3Csfcfq+t9nBcNaanb4VstfHGXW6Zb7l9FTRty8lsl3GqX5P8rdES4PXBzPwg18UmOA3BXYL945fx37Wl2L42W333HeE6pS3JrlpXJF8LaHT9QTQiFLw7A==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784907174; c=relaxed/relaxed;
	bh=LAVUMhjTsI0e2FV9qsLG0HM2WzpbKmjCFS2vLVf5RwU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=CnawaCwpiPI3WvtvhqTQfK/M0Es8virnxWEBoZWxeE9WR/VglOKfe+vtERGfMSO556JU9mE8Xu6oSY5VlO0KI7VASsK38IR+gAMA7I6YWdkx/g9tG3BdhMg/o80+2D5iSmLZ/BHfe2J1268WSmVZ9/cuRrOeu6xRJlEjvUMn8nwQSWSuLklxFCob0anZgBwr0KjZwU+USLyofLVDGTXIc8gwDt+lSVxfFugHdIDire38/SRql44tJDQYENZ0u0p5/leEuhAkXwyqkHPihgDeV6FAvwcRk4/yr31uHnew/jhbj5j1ayweRfTdpZF3zKQiFw/y96xLZDQc458W7Qrjxg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OwdEqyp8; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::b135; helo=mail-yx1-xb135.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OwdEqyp8;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::b135; helo=mail-yx1-xb135.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-yx1-xb135.google.com (mail-yx1-xb135.google.com [IPv6:2607:f8b0:4864:20::b135])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h6Bnx3rRMz2yFg
	for <linux-erofs@lists.ozlabs.org>; Sat, 25 Jul 2026 01:32:52 +1000 (AEST)
Received: by mail-yx1-xb135.google.com with SMTP id 956f58d0204a3-664b05d408bso443062d50.1
        for <linux-erofs@lists.ozlabs.org>; Fri, 24 Jul 2026 08:32:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784907170; cv=none;
        d=google.com; s=arc-20260327;
        b=TOGd57/upljehoJZnC1seFNhGI5n3fpVIBZMZCjAQvENu8REpkQbnCH9004YzM4KIL
         UzkL0mfMIV5KJxTQMM1VG7ptMTpuTqF4w8I5KQqThNjIIqmE1NCW7/5MLqz+sjoJfzmo
         zvMV6Pn/mHgqcopkW7XNdDcc0ELJ7kblG3+6xCF8HNOSgAHC9Dyt4/KzI3ioRtmCGU1q
         OvGArNjvPh14Pm76yDmC4EEIqRPabdWBUoC2X419zzIMdFAJYnbwRcR4xBDDwx7tqXZJ
         /FEUzbzcfYePK3W0nO36aQyjL9NO4WuIrRJoO8Feuj7bJYZgL21iWtSQRfq3kma/zINI
         JRGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LAVUMhjTsI0e2FV9qsLG0HM2WzpbKmjCFS2vLVf5RwU=;
        fh=8SmXArI5i6zxioSmgCnySzgfpE6VP7tikBB9CeTzdbc=;
        b=LbB0ccwEHhHoC+QLmg0g2nz6IWwq6HxV7uUp9Yexg99lzFF9xFug7RsEP/uAkrycOc
         QcXE97Ko+a1iSw/Qp45Cc/svhAZLddjrfW1SAfBuOZnzJiQOI4ckLZeUDJJf4VXHA6Ph
         bjy26aiiDfpGLv4VxE6AxyZBVrctMiGOFtsqn0wiUdWYYJtHm4/WJf8mvM7f2I+y0lA0
         e392IzlK6vHeTeoAjXJfldA88B6Iz40CWTWtCMCsHoLexruZFdn4nVfWrtek4CYMAOsB
         r91Zqx0E3yRVtnJk4nNSCif05YTNLghKFPEbuImxAIgLjR+vDmeFBuRpSY/2lIN/1pVj
         W4wA==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784907170; x=1785511970; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LAVUMhjTsI0e2FV9qsLG0HM2WzpbKmjCFS2vLVf5RwU=;
        b=OwdEqyp8WixyBw6F+8g8kSuuZE0pSI6+UlkoAg0F922+C/CK2Pl8DqTRQqvg/UBVQ+
         M3D7W71eA5us6/GVSTsOTsZsg2iSCluQLXV8xvX10Mjz2VdaqFtfttuI/J1X60a4gnRR
         BBG+TcVDd+XDxkihCcF2mVFoRn1+o4tIeBQNhaHp8pBOWS6PhPmWYzoRYJRnXEd4AD5M
         DK/uXxUO3LcXKwR98BRX+4UhKUIoVpQ2OWkMXoDEzpIRp7GrPEcGcUd727MOg/Y9KFa9
         xEchmipMiB6HUfVEAKnj/q+x/RXwUzuD1xvGtxGjsVfhMZt57jSuSlXiS1IDhMRd/skl
         ZyIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784907170; x=1785511970;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LAVUMhjTsI0e2FV9qsLG0HM2WzpbKmjCFS2vLVf5RwU=;
        b=A/wz8JgGmS8R+EfWmpn3zuGa5QbN9Wmv2wIt+MYQifZYVXcZ09vsVPgJtlTrUnH7uO
         tQxJr9OW1IsdXhftsNCEvjI+dADNh4v+q/GDUlIQAeRPCkEB0wkXxkOtFN5WfNVKckVQ
         LASYSoW2LAPJEpXGQClDz2uVyKPOC1rZkVWOEKqR8nzj8hM0CgLMDMeCoMOG/ysC7cQ/
         3CAMoGlH5y72mS6a5FUZQYsCc6XbY3nhLOzq+Zy6Q/KyFxMQOpdyGmslhF9GTEq5YfV4
         TETbRC2DaGkHA3reNimOWUZLWWTAKCecfzeepONZI26OIJv5nllnWZeMjpbEPIiP3QWM
         Yu8w==
X-Forwarded-Encrypted: i=1; AHgh+RqjB9FpB9y4mz8Gjr3DD3CNDbiWGrTP3LOw9DAjMmi/Dw1EiNSaPRv7SL/4DQa//Zxe2i1yFyf+HTLTyg==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YxVky9oA1WSAjcIKRCNcHx2Q6sSFgWaq7cdB+hE5apxIU/JjS1n
	HHkdOytuqred+0adjxVzNeGlegyU+bsg0WqpDIlXgnziJFxFBwyhobnugZI4XfgwfK9HEsK7R9S
	fwb27o4hIut3tw4sI9fJdeXDnKEq8LakgzA==
X-Gm-Gg: AR+sD10waSWi59xXMCWmO+Ud5zuCY14HMTTAL57Z+qCDOv48Fx0c5wz/h6TFEdBE+gG
	Qod9Cjm9XojHdWtmcpyUz/i9RK3xsTZ91pFi/cBWrCmWxf4uG/L+vrT8RYJ3P4PRQ8EFf8casLB
	dHZzL5963gHAzY/iGCdK6T72b6r/TZ1D8ih01K+swQEwC4jhkFmVOTY8/robhFt8xRlGJYzOGvB
	7olnCY+yGxfcOkXKVnCgIWgTnbom6fcpVbN9zyGF/b/Rv2s1FiwOn5mZz97
X-Received: by 2002:a53:cb0e:0:b0:668:99c7:9c24 with SMTP id
 956f58d0204a3-668a4d7347bmr1614126d50.58.1784907169780; Fri, 24 Jul 2026
 08:32:49 -0700 (PDT)
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
Precedence: list
MIME-Version: 1.0
References: <20260724143556.80914-1-nithurshen.dev@gmail.com>
 <20260724144713.85393-1-nithurshen.dev@gmail.com> <amOEndBYjdJ8uAeb@debian>
In-Reply-To: <amOEndBYjdJ8uAeb@debian>
From: Nithurshen Karthikeyan <nithurshen.dev@gmail.com>
Date: Fri, 24 Jul 2026 21:02:38 +0530
X-Gm-Features: AUfX_mwdgHdtTEF-MRv7Vl5yGP8Q3Nz0xP-peWGX8eVqkkOTlQJfp5YPHpN0z_8
Message-ID: <CANRYsKiNaBnNrf_vG5eX9+3U+T=TRNDqDxJQh+hLPKgULZHopA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] fsck.erofs: implement concurrent directory traversal
To: Nithurshen <nithurshen.dev@gmail.com>, hsiangkao@linux.alibaba.com, 
	linux-erofs@lists.ozlabs.org, xiang@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 24, 2026 at 8:58=E2=80=AFPM Gao Xiang <xiang@kernel.org> wrote:
>
> As I told you the merging policy, each patch should have no
> regression, if concurrent directory traversal is useful, please
> just implement it as a base, I won't accept PATCH 1/2 since
> it has regression and useless.
>
As I told in the email, I am just stating that this patch is a definite
improvement and meets the merging policy, and I will implement
parallelised decompression on top of this patch only in a few days.

I hope you could review this patch and let me know your thoughts.

