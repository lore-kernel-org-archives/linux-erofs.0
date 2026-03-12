Return-Path: <linux-erofs+bounces-2684-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CAFC106ACE3
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Mar 2026 19:40:50 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fWydr4TfFz3cHH;
	Fri, 13 Mar 2026 06:40:48 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=116.203.167.152
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773344448;
	cv=none; b=S4lhCAlhTLzRIcCeGPruVwSijUBjEIEXIeHYApQvqWVMcLNTvR75DiDNImLzOiVpgApHZTj0ajSS6yJGsRlkTcV8YxVwOe1F1ycnsBrwZmn0IBDl5xziE7ma+9oXZmLnm7XrSzVaMzFUDvTVNqX/qr+rSzofQPzzQezOxwQzUsyAfxeuquZWac35KrVeaepUrLFn2VVhFoh99/t6N2tODz+cjtrmiq1r+jVD141P2Bf1RqeOnGisu4ArTw8rvHFx/I75hmunOgS3p4FOF/p4d4W9Fyiy+zxAKNDQ4UhJW2JS2e7iOaYiQ0IFwJbZYGrDHe3j11bPCso6QS1LbIINNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773344448; c=relaxed/relaxed;
	bh=VQ4I1//oujMg/wMbvtHZ1fNg62i5rEhIWcPKRohhj4U=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=CzPciRDKpznxsIS/9OXno2bGsiamn6aDwxdJTUgqpcTMAbYoiAagMqvbRAq2zXp1C+OBE1FrLIIFn9OVozXr09FUyzdXv12eLa4TIZCKti8sUH3srZKzoK4cOZ/o03ZQErKBtOLW70EkyvCBAaHfqQOZDsAD/+bQiSx3sbHWnxVYPg75vvWcVYV2djyWmqg23zh00WvLg6LwtEvCLnnTW2Fpi1Zo5GzkCvqsdqT5Mn9f0nTUwXeGQb1Y3F03Y2otAfKdvqcvUbOEkY3XhUYWt6PHEuKWWiA/R4LMj00tY2tvRmmrLnC74zLJhKTGzbdkCKaRHvuOLvJzJevECj4RCQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=nod.at; spf=permerror (client-ip=116.203.167.152; helo=lithops.sigma-star.at; envelope-from=richard@nod.at; receiver=lists.ozlabs.org) smtp.mailfrom=nod.at
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=nod.at
Authentication-Results: lists.ozlabs.org; spf=permerror (SPF Permanent Error: Unknown mechanism found: ipv4:195.201.40.130) smtp.mailfrom=nod.at (client-ip=116.203.167.152; helo=lithops.sigma-star.at; envelope-from=richard@nod.at; receiver=lists.ozlabs.org)
X-Greylist: delayed 417 seconds by postgrey-1.37 at boromir; Fri, 13 Mar 2026 06:40:47 AEDT
Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fWydq2KwPz3cGf
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Mar 2026 06:40:47 +1100 (AEDT)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 4DE582C14A8;
	Thu, 12 Mar 2026 20:33:44 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id yCwNT8mwVvHB; Thu, 12 Mar 2026 20:33:43 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 8A34D2C14AA;
	Thu, 12 Mar 2026 20:33:43 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 3HN7guaAFMsE; Thu, 12 Mar 2026 20:33:43 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lithops.sigma-star.at (Postfix) with ESMTP id ABF4A2C14A6;
	Thu, 12 Mar 2026 20:33:42 +0100 (CET)
Date: Thu, 12 Mar 2026 20:33:42 +0100 (CET)
From: Richard Weinberger <richard@nod.at>
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx <amd-gfx@lists.freedesktop.org>, 
	apparmor <apparmor@lists.ubuntu.com>, bpf <bpf@vger.kernel.org>, 
	ceph-devel <ceph-devel@vger.kernel.org>, cocci <cocci@inria.fr>, 
	dm-devel@lists.linux.dev, 
	DRI mailing list <dri-devel@lists.freedesktop.org>, 
	gfs2 <gfs2@lists.linux.dev>, 
	intel-gfx <intel-gfx@lists.freedesktop.org>, 
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
	kvm@vger.kernel.org, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-block <linux-block@vger.kernel.org>, 
	linux-bluetooth@vger.kernel.org, 
	linux-btrfs <linux-btrfs@vger.kernel.org>, 
	linux-cifs <linux-cifs@vger.kernel.org>, linux-clk@vger.kernel.org, 
	linux-erofs <linux-erofs@lists.ozlabs.org>, 
	linux-ext4 <linux-ext4@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-gpio@vger.kernel.org, 
	linux-hyperv <linux-hyperv@vger.kernel.org>, 
	linux-input@vger.kernel.org, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	linux-leds@vger.kernel.org, 
	linux-media <linux-media@vger.kernel.org>, 
	linux-mips <linux-mips@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, linux-modules@vger.kernel.org, 
	linux-mtd <linux-mtd@lists.infradead.org>, 
	linux-nfs <linux-nfs@vger.kernel.org>, 
	linux-omap <linux-omap@vger.kernel.org>, 
	linux-phy@lists.infradead.org, linux-pm <linux-pm@vger.kernel.org>, 
	linux-rockchip <linux-rockchip@lists.infradead.org>, 
	linux-s390 <linux-s390@vger.kernel.org>, 
	linux-scsi <linux-scsi@vger.kernel.org>, linux-sctp@vger.kernel.org, 
	LSM <linux-security-module@vger.kernel.org>, 
	linux-sh <linux-sh@vger.kernel.org>, 
	linux-sound <linux-sound@vger.kernel.org>, 
	linux-stm32 <linux-stm32@st-md-mailman.stormreply.com>, 
	linux-trace-kernel <linux-trace-kernel@vger.kernel.org>, 
	linux-usb@vger.kernel.org, 
	linux-wireless <linux-wireless@vger.kernel.org>, 
	netdev <netdev@vger.kernel.org>, ntfs3 <ntfs3@lists.linux.dev>, 
	samba-technical <samba-technical@lists.samba.org>, 
	sched-ext@lists.linux.dev, target-devel@vger.kernel.org, 
	tipc-discussion@lists.sourceforge.net, v9fs <v9fs@lists.linux.dev>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, 
	Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <1584421372.26258.1773344022512.JavaMail.zimbra@nod.at>
In-Reply-To: <20260310-b4-is_err_or_null-v1-48-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de> <20260310-b4-is_err_or_null-v1-48-bd63b656022d@avm.de>
Subject: Re: [PATCH 48/61] mtd: Prefer IS_ERR_OR_NULL over manual NULL check
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
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF148 (Linux)/8.8.12_GA_3809)
Thread-Topic: Prefer IS_ERR_OR_NULL over manual NULL check
Thread-Index: 0l8CyewQmrWlgaG6N3QgQFfukutRbA==

----- Urspr=C3=BCngliche Mail -----
> Von: "Philipp Hahn" <phahn-oss@avm.de>
> -=09if (gpiomtd->nwp && !IS_ERR(gpiomtd->nwp))
> +=09if (!IS_ERR_OR_NULL(gpiomtd->nwp))

No, please don't.

This makes reading the code not easier.

Thanks,
//richard

