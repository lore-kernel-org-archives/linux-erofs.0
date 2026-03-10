Return-Path: <linux-erofs+bounces-2624-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E0F0FD2D74
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 13:22:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVZKx6vxhz3bjb;
	Wed, 11 Mar 2026 00:22:13 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773148933;
	cv=none; b=asPP8nqx9+xNJqzqym8WVTIgPwzEq1zoRkvlpeS0uK0Anwo1P4Do5semM9taXYj3uFy7WG2vPkqF0Q/vSKJ1plSF4rtuQzZdM71nMZdNfRjFqMu5oPRI4AQTnZwaYoA5S5vb0KipkHDvXJMLkzL+yKgR+L5CcCMs7mD0+SYEdm6YPAvWMDfitSu0PVSpOwCvPxExDYvaI8rSst2BZyLZQxc/tfNRRi3L7Dkv3lEzD28HizTxf7Vz7MzP5R64HklHFvUeqhKqTMGiT25ZEt2EFGjqi+FXQm3hH63MIUVF4gvCH59NBv6quCGfj1UNoY+cBC/3wIJmrer6MOioObHyfA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773148933; c=relaxed/relaxed;
	bh=5/adDEbR57gUpYJcJq84OoDVxrrM3xMPFmZCRo0jKXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=YaYZ94TFVE/MVyojCNR1zejfiJY4scLkT6JngSvwjdo6Z6r2v4AYjzP637tXJTwK1hUz2EqOEFi7CSkGo951R4hN4SLQDEoSYcHAt0fz/joC2apwpi3ORQY2BwNQdkPa7YojAOq/F+NB6jDSjfWiOKXqiXqXNlcuSgQa6mFXh8Nd1Lt/WzcaNV2xRPU6A8/k2KBG92eCDoRI3OSm9IbOZ7m4SrOj/D7CphfzQj6l472hGbQyMWbiGlxOATCx4W7m76Cj72ccSMvLXbyPzHehRJi/Q9uCC3+hcTV/8JfAV9yp9srp3A15YMes3XDydiSe6/0EqjktaZI7afWeFnTDJA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=E51kNjIN; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=E51kNjIN; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=bmasney@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=E51kNjIN;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=E51kNjIN;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=bmasney@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVZKw4nsfz30Lw
	for <linux-erofs@lists.ozlabs.org>; Wed, 11 Mar 2026 00:22:10 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773148927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5/adDEbR57gUpYJcJq84OoDVxrrM3xMPFmZCRo0jKXM=;
	b=E51kNjIN4UKbGW9DyZ5aBLaeo/X1fN08TYjWYCgYq8Q8qw25+tZQtb5W5ajU6MN7BBBW11
	0YDBivfD6ObYrVaZ07AfmguXniohVg3EyJDviAgsAuscNKdssFGgICyGTgh1yznjOgNpE3
	ekU6IHdwiHFWZVShb4nqu/2AD28lhx4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773148927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5/adDEbR57gUpYJcJq84OoDVxrrM3xMPFmZCRo0jKXM=;
	b=E51kNjIN4UKbGW9DyZ5aBLaeo/X1fN08TYjWYCgYq8Q8qw25+tZQtb5W5ajU6MN7BBBW11
	0YDBivfD6ObYrVaZ07AfmguXniohVg3EyJDviAgsAuscNKdssFGgICyGTgh1yznjOgNpE3
	ekU6IHdwiHFWZVShb4nqu/2AD28lhx4=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-W7ePr2QKN_quBgnUs9ubSg-1; Tue, 10 Mar 2026 09:22:05 -0400
X-MC-Unique: W7ePr2QKN_quBgnUs9ubSg-1
X-Mimecast-MFC-AGG-ID: W7ePr2QKN_quBgnUs9ubSg_1773148925
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8cd7ea0bb20so1450840485a.3
        for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 06:22:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773148925; x=1773753725;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5/adDEbR57gUpYJcJq84OoDVxrrM3xMPFmZCRo0jKXM=;
        b=BiY3v7Ob8YGIPiB5eTyR7sd3/1qOmtAwFpGhawyg55iIxPKLlHzDLzAwBMkOA8c9Lv
         G/hVuZUcUT7NoxxRiD2F75k7Ba9apACVBeyElBUK+o1Ew0bfAcCx5DObS/su/PHZO4Sg
         nR5rTG1ciyvePfSu2HpOpcryhPuPZZesGSUtMtv77ZNvX+QFz7RdjLUBe1/7GhmEHkri
         DgjVMubw3J4LwpWf1K9fdeaL/wEXdtaSkj7pZzQbQAafNb7i9dZXxZVZovSDIa5RPsHS
         U8AEqkzz3bUlTDaSJTkugrJ7KpIAi4zeW/IUg/O+rscskgS2JesUkEmhh9axOh6Kprcy
         cybA==
X-Forwarded-Encrypted: i=1; AJvYcCXUSWci/70caMEJdztXL/duqCLA6k4TOn7jKxZLW7yhDwTdUteE/s3kUgNKTo0NUS4WbZbU/dL4NrX6Ew==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YxWpvstUrBElDaoinnFfi4Ueopw2jWzuGmDETX/NWZnX+vnQz9D
	v3eiuI7Pkm8OV+5VeyAQKyu4bUp3Ii1J1okDN1OZmWkojxWuUd6oMcN4RqIbwy9fA8tNoK3UHj+
	vmluJd67KMGBomasM3yCW8r6y8c44lACH7IoZSNU3VoUZd7C+HK1sZ5MkH2/CZIINDQ==
X-Gm-Gg: ATEYQzwfdWzSD/Dt/qIluvoqciDDZvxSh04X/HdjMVaxZS/XahXoiERWgoE/gdzwLpE
	2xh5r6up21SSyogp872L7WR+8dA3KJNpCckWkINAGEO922RdtdbWrSSW+bvL7OOJD/oXujyWB/Q
	CMrSUswgXujZO1nxouCzfb9+i/3Hu0uAmEHULjqQk6e4Wz0ze4HGhwYUdMywho0HbyKsCNwR9ch
	JE2ANOHn3NPdmqwFh6gjYe4T0btulRcIOTmrUxwtYOOTjyim32oeqApK49BnjqxjKjffa0zC8U5
	4GLBTaRKzEKGM+FuSPx1pmF7ehA/G3cHcwdf1/vTXvc2bKSWziSFUHo4YkPCsbSRFqYQLK+Wsqd
	rxmQBYrYT09MDFotF1iVryd+tuYCQ1kLKhe5o4i3afCG9Int4rb5mqj+B
X-Received: by 2002:a05:620a:3713:b0:8ca:1240:4991 with SMTP id af79cd13be357-8cd6d4f9469mr1830786985a.45.1773148924722;
        Tue, 10 Mar 2026 06:22:04 -0700 (PDT)
X-Received: by 2002:a05:620a:3713:b0:8ca:1240:4991 with SMTP id af79cd13be357-8cd6d4f9469mr1830766185a.45.1773148922638;
        Tue, 10 Mar 2026 06:22:02 -0700 (PDT)
Received: from redhat.com (c-73-183-52-120.hsd1.pa.comcast.net. [73.183.52.120])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cd8576db0esm474754485a.47.2026.03.10.06.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 06:22:01 -0700 (PDT)
Date: Tue, 10 Mar 2026 09:21:58 -0400
From: Brian Masney <bmasney@redhat.com>
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com,
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
	tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev,
	Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>
Subject: Re: [PATCH 56/61] clk: Prefer IS_ERR_OR_NULL over manual NULL check
Message-ID: <abAa9vQg4BSxl1BJ@redhat.com>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-56-bd63b656022d@avm.de>
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
In-Reply-To: <20260310-b4-is_err_or_null-v1-56-bd63b656022d@avm.de>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: n1BM9ExcKrGaeDqJTFHBWa5mHAyDOiN3IxNA38xiLcA_1773148925
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 10, 2026 at 12:49:22PM +0100, Philipp Hahn wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
> 
> Semantich change: Previously the code only printed the warning on error,

Semantic ...

> but not when the pointer was NULL. Now the warning is printed in both
> cases!
> 
> Change found with coccinelle.
> 
> To: Michael Turquette <mturquette@baylibre.com>
> To: Stephen Boyd <sboyd@kernel.org>
> To: Daniel Lezcano <daniel.lezcano@kernel.org>
> To: Thomas Gleixner <tglx@kernel.org>
> Cc: linux-clk@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>

With the minor typo addressed:

Reviewed-by: Brian Masney <bmasney@redhat.com>


