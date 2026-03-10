Return-Path: <linux-erofs+bounces-2623-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFD69FD2D73
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 13:02:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVYts00Xkz30Lw;
	Wed, 11 Mar 2026 00:02:13 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a0a:edc0:2:b01:1d::104"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773147732;
	cv=none; b=A6IVe92FcltyyFbVtiToYhnIU8SYUeeaqCSzoXgQ7UcqLcHPFIa4lVMZBfmwIJNlClW/wIWw8NEvjQIpEpgJ99CLVAjvFTl+9+sKlqQoBIH7cFc5EonwLqrhBeIoZiz4ktMxqWWvf3CxgE8vdl2y3tsQ1VvK0Npo8pKyxNe0ZIhpSUdy6QU77d5cGXZNqLaRCZp8ScK48dDo5Ij/O0nM8T9FRI4yIJ6UEyxMbvwM4KRvWzXWNQhuLkSPnR6ffbsB16KWV5N93YzSFWdpcYbpohhwk798KZqsn0Wi2lsbc68AW+ilu1+JadQFEJmg3lANmFGbZHlZjz1+3m7f9cRmtg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773147732; c=relaxed/relaxed;
	bh=9nwSoyBFb/J+scDlmZ8YZ+1mFs6NH+0TsiNWJNlzMqA=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aWQQKUADletzCxnNQ3IxvDtwRMdHuh25zTVsBlodUXCVntOoWIwBEC480fPQwQxsy0lcglNG0GbfJmxo6CmuFCIKJ4iH0b6WNJuA6kR1QSwI32hwZo+9sKDuydrRH2k+UoW7wCbSGebrERzJyhEGR1rZf9FK982V1X5RW/7YxOb1mUfzvK6xxCiHB2D2URs9JYgKbXahti45IJfE/V0u90sJs+YkbjURDmF8u8poCwi0ieOalRkRlaOKDGGyAszn/O11p7q4rPeftY8NykFX8nuXalN1VPoY5crKnNocLK2kG0q2xbziQ+fHS9HtJxIQvIpVeU4+cSRlbtb9hZeDlw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass (client-ip=2a0a:edc0:2:b01:1d::104; helo=metis.whiteo.stw.pengutronix.de; envelope-from=p.zabel@pengutronix.de; receiver=lists.ozlabs.org) smtp.mailfrom=pengutronix.de
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=pengutronix.de (client-ip=2a0a:edc0:2:b01:1d::104; helo=metis.whiteo.stw.pengutronix.de; envelope-from=p.zabel@pengutronix.de; receiver=lists.ozlabs.org)
X-Greylist: delayed 1111 seconds by postgrey-1.37 at boromir; Wed, 11 Mar 2026 00:02:11 AEDT
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVYtq4yGpz2xlx
	for <linux-erofs@lists.ozlabs.org>; Wed, 11 Mar 2026 00:02:10 +1100 (AEDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <p.zabel@pengutronix.de>)
	id 1vzwQv-0006Oq-0m; Tue, 10 Mar 2026 13:43:33 +0100
Received: from lupine.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::4e] helo=lupine)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <p.zabel@pengutronix.de>)
	id 1vzwQr-004hMj-0z;
	Tue, 10 Mar 2026 13:43:30 +0100
Received: from pza by lupine with local (Exim 4.98.2)
	(envelope-from <p.zabel@pengutronix.de>)
	id 1vzwQs-0000000081v-2556;
	Tue, 10 Mar 2026 13:43:30 +0100
Message-ID: <ddaacda48df23fb2c009a8727518300ed2b82cb2.camel@pengutronix.de>
Subject: Re: [PATCH 57/61] reset: Prefer IS_ERR_OR_NULL over manual NULL
 check
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Philipp Hahn <phahn-oss@avm.de>, amd-gfx@lists.freedesktop.org, 
	apparmor@lists.ubuntu.com, bpf@vger.kernel.org, ceph-devel@vger.kernel.org,
 	cocci@inria.fr, dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
 	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
 kvm@vger.kernel.org, 	linux-arm-kernel@lists.infradead.org,
 linux-block@vger.kernel.org, 	linux-bluetooth@vger.kernel.org,
 linux-btrfs@vger.kernel.org, 	linux-cifs@vger.kernel.org,
 linux-clk@vger.kernel.org, 	linux-erofs@lists.ozlabs.org,
 linux-ext4@vger.kernel.org, 	linux-fsdevel@vger.kernel.org,
 linux-gpio@vger.kernel.org, 	linux-hyperv@vger.kernel.org,
 linux-input@vger.kernel.org, 	linux-kernel@vger.kernel.org,
 linux-leds@vger.kernel.org, 	linux-media@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 ntfs3@lists.linux.dev, 	samba-technical@lists.samba.org,
 sched-ext@lists.linux.dev, 	target-devel@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net, 	v9fs@lists.linux.dev
Date: Tue, 10 Mar 2026 13:43:30 +0100
In-Reply-To: <20260310-b4-is_err_or_null-v1-57-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
	 <20260310-b4-is_err_or_null-v1-57-bd63b656022d@avm.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
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
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-erofs@lists.ozlabs.org

Hi Philipp,

On Di, 2026-03-10 at 12:49 +0100, Philipp Hahn wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
>
> Semantich change: Previously the code only printed the warning on error,
> but not when the pointer was NULL. Now the warning is printed in both
> cases!

No, rstc =3D=3D NULL is valid (for optional reset controls) and must not
throw a warning.


regards
Philipp

