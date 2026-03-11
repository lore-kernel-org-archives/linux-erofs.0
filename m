Return-Path: <linux-erofs+bounces-2676-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50AD1103E2F1
	for <linux-erofs@archiver.kernel.org>; Wed, 11 Mar 2026 23:10:28 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fWRLB4Y8nz3cDg;
	Thu, 12 Mar 2026 10:10:26 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=213.167.242.64
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773270626;
	cv=none; b=M47sHOXdIIpy54wYOc11zosLvSqw4woAIgoenteQEL8e2nylmpjV3w2bKdlgs+ZG8qu2pSYTUJp9G97zLEnji6IhwWV3EBEimHLDU3y0oBxcAdyy+5y2pLpRTmoJsGkIlEIc59+C73WoDJApvJsfJJ2H9Wj8KOUfPMgQyBTPzQ7FpCNndm06XHamSkudzHJPtbvYGJojKfXFZndSFngU0qcMk6m5XRnC99ubJ0hhsczmWWu3zHfWdQvZA6bdR1mocyCH5eMLzZtbRl4RiRlz+UDYtf9NMVVq6OR7OFw2cPG16aegK6/MYezOYxEz7T+/y7qfrpnG4K3lJirpdg7HJg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773270626; c=relaxed/relaxed;
	bh=33EAGUBLBYod3tzyGg7m09477vqXsAXQIQrUfRFHjU8=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Subject:From:Cc:
	 To:Date:Message-ID; b=MHIfn0YX+KjsXifIRihvkbB/SzLgMZfdRL1UU2aGn2dVRjKiqCxHwKc+xoA6bikLPLBcSpL2V7Wn+mNBdrm0MbovF3rtAMDaEP6WTHUlYyk/9obtyqjXjW2YgK27vdDtS2XkWRRpcPgquyjhxR2JvDtWzL51RH/AeTanpptRh72lhK6jcxzIvWgL/oOoWlTSk3uWH8BKRykjXelhYBgSsH912IoBPFw8VUE8kAYYvNj4lQfvrJvibAFpXVC8oHaOAyFNHqR9vf76P3PO84vflSsgSc96iPMdJs3ThRfCyTvD7+Mf2IY6RPo7SbgziezGvkoGipQcJikfLapDf14GFQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=ideasonboard.com; dkim=fail (1024-bit key; unprotected) header.d=ideasonboard.com header.i=@ideasonboard.com header.a=rsa-sha256 header.s=mail header.b=WxcdvAR4 reason="signature verification failed"; dkim-atps=neutral; spf=pass (client-ip=213.167.242.64; helo=perceval.ideasonboard.com; envelope-from=kieran.bingham@ideasonboard.com; receiver=lists.ozlabs.org) smtp.mailfrom=ideasonboard.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (1024-bit key; unprotected) header.d=ideasonboard.com header.i=@ideasonboard.com header.a=rsa-sha256 header.s=mail header.b=WxcdvAR4;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=ideasonboard.com (client-ip=213.167.242.64; helo=perceval.ideasonboard.com; envelope-from=kieran.bingham@ideasonboard.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 402 seconds by postgrey-1.37 at boromir; Thu, 12 Mar 2026 10:10:24 AEDT
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [213.167.242.64])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fWRL80Qs6z3cDf
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Mar 2026 10:10:23 +1100 (AEDT)
Received: from monstersaurus.ideasonboard.com (cpc89244-aztw30-2-0-cust6594.18-1.cable.virginm.net [86.31.185.195])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id CD91E448;
	Thu, 12 Mar 2026 00:02:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
	s=mail; t=1773270149;
	bh=ATo3aRyKmYSXuSYD8x/NeBUp5LJcLKbzHVpozNXQJC0=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=WxcdvAR4zphcUuTNTLXCbLGiiCOKCwemLRMbnRdmW3ARcBHAWQiYVeysDpnfCIDuk
	 B8rMCjKjDjoWJdgj4Zp0scfHxrPnr5P3xl9hFANY/wyWKZBZYHzyf2qsFxVEe9S31Y
	 m9r/HjFnopry9bsUUdk6/id/Q3d97jYK/FiMa+Qw=
Content-Type: text/plain; charset="utf-8"
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
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260310-b4-is_err_or_null-v1-49-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de> <20260310-b4-is_err_or_null-v1-49-bd63b656022d@avm.de>
Subject: Re: [PATCH 49/61] media: Prefer IS_ERR_OR_NULL over manual NULL check
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Mauro Carvalho Chehab <mchehab@kernel.org>
To: Philipp Hahn <phahn-oss@avm.de>, amd-gfx@lists.freedesktop.org,
	apparmor@lists.ubuntu.com, bpf@vger.kernel.org,
	ceph-devel@vger.kernel.org, cocci@inria.fr, dm-devel@lists.linux.dev,
	dri-devel@lists.freedesktop.org, gfs2@lists.linux.dev,
	intel-gfx@lists.freedesktop.org, intel-wired-lan@lists.osuosl.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org,
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-gpio@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mm@kvack.org, linux-modules@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-nfs@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-phy@lists.infradead.org,
	lin@lists.ozlabs.org, ux-pm@vger.kernel.org,
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-sound@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
	sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev
Date: Wed, 11 Mar 2026 23:03:33 +0000
Message-ID: <177327021364.3167621.11851238159935183684@ping.linuxembedded.co.uk>
User-Agent: alot/0.9.1

Quoting Philipp Hahn (2026-03-10 11:49:15)
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
>=20
> Change generated with coccinelle.
>=20
> To: Shuah Khan <skhan@linuxfoundation.org>
> To: Kieran Bingham <kieran.bingham@ideasonboard.com>
> To: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: linux-media@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
> ---
>  drivers/media/test-drivers/vimc/vimc-streamer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/test-drivers/vimc/vimc-streamer.c b/drivers/me=
dia/test-drivers/vimc/vimc-streamer.c
> index 15d863f97cbf96b7ca7fbf3d7b6b6ec39fcc8ae3..da5aca50bcb4990c06f28e5a8=
83eb398606991e9 100644
> --- a/drivers/media/test-drivers/vimc/vimc-streamer.c
> +++ b/drivers/media/test-drivers/vimc/vimc-streamer.c
> @@ -167,7 +167,7 @@ static int vimc_streamer_thread(void *data)
>                 for (i =3D stream->pipe_size - 1; i >=3D 0; i--) {
>                         frame =3D stream->ved_pipeline[i]->process_frame(
>                                         stream->ved_pipeline[i], frame);
> -                       if (!frame || IS_ERR(frame))
> +                       if (IS_ERR_OR_NULL(frame))

Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>

>                                 break;
>                 }
>                 //wait for 60hz
>=20
> --=20
> 2.43.0
>

