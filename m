Return-Path: <linux-erofs+bounces-2683-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEA6D106ACD2
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Mar 2026 16:54:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fWtyQ5W4Jz3cH3;
	Fri, 13 Mar 2026 03:54:54 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::836"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773334494;
	cv=none; b=nBC3yiunVo9h/cC/pK/wLlv7fz/SjGG3mcqxUQ0HJYRU1HoHalbpcTd37+0bLzEfw2gK9+JcWJy8kS6t6KW9b7vNkI3gnF+EGkHApA7uzozx49jxYznFrpZCnX/6VKFof8+0e4WmJernVqItt0qG1qyCljEj8MLtlWZ0snZ9d1gDVM8WSEpK7p8nHixoMYJJ71Om/Tycxj6z59lSTxGrRh61n0QYRi4DaWgZ2oiktv55JyXwLO/EEyo0148IjS7uSsQgtDfBpAhZFwDxpwWF2C+OQBU2KPPZA1G869W3vbgyIifyb8YpUn2CQZXOnBx+CL44VcJK2+LL4wMa/jmuBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773334494; c=relaxed/relaxed;
	bh=VQXCfPVu6b6dIVECzm0C8AUD7IL7VvpSkD5+M4S95sw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M/VSuy4awO4QvCQ7yF+4xZ2qkJ6fCx265rCufBqLy4Bimg4x84CMqNAYykIcky1hSoqPcYRY95S+IA5WF0fbN67C3D0qf3N8zWBFgEOrdZOrbuZMsWRizwO+lIoL5k8buI/5G2x6PQ9X0/Vr53TDbz9v8nUn3Cfw5cljtS/L6CfRCA+fVVPuCn5+qs/YDZtlAwrFe99QaxP8M4bqSFHo4Wet2gMZo/a70emb7n5As4dRx5V/2amA0o6AjYgJivAaXlQN9isFpjVYqywZ+vo3hoYh/0/Qnl0zt3fSpfXj3/ZIFrVH8Bv7Jy5Mq4Xki4K5KjzB9lZwFPaCLJ49X3dbKQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; dkim=pass (2048-bit key; secure) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=pBBUqqaE; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::836; helo=mail-qt1-x836.google.com; envelope-from=jgg@ziepe.ca; receiver=lists.ozlabs.org) smtp.mailfrom=ziepe.ca
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=pBBUqqaE;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=ziepe.ca (client-ip=2607:f8b0:4864:20::836; helo=mail-qt1-x836.google.com; envelope-from=jgg@ziepe.ca; receiver=lists.ozlabs.org)
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fWtyP4609z3cGc
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Mar 2026 03:54:52 +1100 (AEDT)
Received: by mail-qt1-x836.google.com with SMTP id d75a77b69052e-509006c070eso10771421cf.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 12 Mar 2026 09:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1773334491; x=1773939291; darn=lists.ozlabs.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VQXCfPVu6b6dIVECzm0C8AUD7IL7VvpSkD5+M4S95sw=;
        b=pBBUqqaETR3PS/n2SAP6IG2ug0A26mYmEqzItIpgYteiCE3RE8spaIfiF7zx7Y6cmG
         0l6DClr/xk0VnndxM4EOWevC4HcQTjIlCFjYvK5SUAS/dZvPc58bUYxv+0+aS0nLdOw5
         6zCA4v6NYTvWZE3LijQ4Pdqs52aOZwSHoPBoeAF2WNXJXS995Vc7RrKYTVsBNpla3xb8
         Gu0WkRuuDBnWHdWDnS0M3LjTgWyDOldd2DdR7EhyT1zZtP4vqQtLK7cubsRMmOlh3Gi5
         gUPT1MzUK4uv1Qx1ee9XY9dSlLKrbk2092gCQRbPTBBK9n3d7qTlHg8x+HSKJyz2UK3j
         mbTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773334491; x=1773939291;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VQXCfPVu6b6dIVECzm0C8AUD7IL7VvpSkD5+M4S95sw=;
        b=HFpRcLEJ7R72qEy8P/7fcelvAui4Eh2oG581Q15pbxsAO2AWpGLNNfMYX8N1v9pqXU
         S5oNedDwUPHD9PqFabA3D0nx51sDScz1tcuHf5/YyNtPK5+0sIE/VvJ10BiUubq3EpQ0
         KpkDL+8PC3TEzOX4j17P05QxGNM/6JEaS+vsaTV+nOHRVVDZyx+ZtFBT/rI70nonnWv+
         0JKj+Te3AB5rZEQmohd6rqrpZLKLBOnGuOF619+G18aOJtvRCU4bJ1zS+FyGdr6NFscD
         3Ymiy+yZzOSV6Db5rqdVP0kUKRgmGOdhjvRwV1qaI2TXYbJEBw4NkdpdapqaEfQmsUq8
         Q8Fw==
X-Forwarded-Encrypted: i=1; AJvYcCVw6wsWsY3pJ6hFGyPHx1iGLU2feaMz7rcSh60hwDaCMQ9E/2YqAZ4Wfi8OOBK2r+PxLkFIQ3PIAucmTw==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YxAOwZQ0xyok98WVONisLkrmxCrwVbg4+kmaycyMmMaAgcVgKTd
	BkOL2bQIQjRvP6KH7rUKB/8e/vJfDCbcW2NDxSneu0AjNilfvZnBq5blEyyY9RZiVPo=
X-Gm-Gg: ATEYQzzPCKVWQouO6kEskzlji7f9w8h79EkU8xO31BshBIJcrXu7owAGnYEsyJt8cWC
	OGWPD6MLHmZYPnKwJX45U6OBof2rxCOSOfpAe1jZ3FfcC0pxfXWYIz1nIA19+8JZ9MqZ+6RF1q4
	5oZ9gIv2ge2k8fxk/IRbdVDczPoBb+JIrrhJHUEtDVfX/HiydKO42rxO5s7zBkYqnslq4uSZ4It
	8cSn4IkBuzwQ01vJyhJVeH1Zdk8SnJ67L9MdmH6i3uBs6Cr2nyt4b7n4MD9VfXOJGgT1G0omBaB
	PxOVpaoTjyEYvFmq2nBlZ5DCjPh0fqKegjwRGIt+MucIGLWUfPIdSBvNndXkNIvpIhQGAkUJFKS
	/aI2p7moA+wHGXUcEQDjVx+t3q/hiWlH64OfP5/myrf9U56gmGaukO1aW/0Bz8dlGr9Wx8K4JB3
	6QQSaWKvfkiFkSB0oM8K/8wzeQPhWgHkD5YBXAEZJ1gI0qCyE+4AmnCai7h3bv/EYadpjRzm5rT
	r26RtSOhE3ccri/f3Q=
X-Received: by 2002:a05:622a:289:b0:509:44c3:5ffa with SMTP id d75a77b69052e-50957e10673mr1403911cf.52.1773334490530;
        Thu, 12 Mar 2026 09:54:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5093a119602sm36658181cf.28.2026.03.12.09.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 09:54:49 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1w0jJA-00000006i8N-40X9;
	Thu, 12 Mar 2026 13:54:48 -0300
Date: Thu, 12 Mar 2026 13:54:48 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>, Philipp Hahn <phahn-oss@avm.de>,
	amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com,
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr,
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
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
Subject: Re: [PATCH 00/61] treewide: Use IS_ERR_OR_NULL over manual NULL
 check - refactor
Message-ID: <20260312165448.GN1469476@ziepe.ca>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <abBlpGKO842B3yl9@google.com>
 <20260312125730.GI1469476@ziepe.ca>
 <f5688b895eaebabae6545a0d9baf8f1404e8454e.camel@HansenPartnership.com>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5688b895eaebabae6545a0d9baf8f1404e8454e.camel@HansenPartnership.com>

On Thu, Mar 12, 2026 at 11:32:37AM -0400, James Bottomley wrote:
> On Thu, 2026-03-12 at 09:57 -0300, Jason Gunthorpe wrote:
> > On Wed, Mar 11, 2026 at 02:40:36AM +0800, Kuan-Wei Chiu wrote:
> > 
> > > IMHO, the necessity of IS_ERR_OR_NULL() often highlights a
> > > confusing or flawed API design. It usually implies that the caller
> > > is unsure whether a failure results in an error pointer or a NULL
> > > pointer. 
> > 
> > +1
> > 
> > IS_ERR_OR_NULL() should always be looked on with suspicion. Very
> > little should be returning some tri-state 'ERR' 'NULL' 'SUCCESS'
> > pointer. What does the middle condition even mean? IS_ERR_OR_NULL()
> > implies ERR and NULL are semanticly the same, so fix the things to
> > always use ERR.
> 
> Not in any way supporting the original patch.  However, the pattern
> ERR, NULL, PTR is used extensively in the dentry code of filesystems. 
> See the try_lookup..() set of functions in fs/namei.c
> 
> The meaning is
> 
> PTR - I found it
> NULL - It definitely doesn't exist
> ERR - something went wrong during the lookup.
> 
> So I don't think you can blanket say this pattern is wrong.

Lots of places also would return ENOENT, I'd argue that is easier to
use..

But yes, I did use the word "suspicion" not blanket wrong :)

Jason

