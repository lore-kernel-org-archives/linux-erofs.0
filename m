Return-Path: <linux-erofs+bounces-4065-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E64DAC5516F
	for <linux-erofs@archiver.kernel.org>; Fri, 31 Jul 2026 15:01:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hBTmH0K4wz2ySg;
	Sat, 01 Aug 2026 01:01:19 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:4860:4864:20::34"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785510078;
	cv=none; b=grBsTAGIbYzExqYjqGgIugUV3SWDrSDEOMPau+QWfyA6PWcVRN6Tirw+gZkQlbQggMcvfhrxT8KJUjyTE2+36vsHlaeA/2pOQXixs+1jEHeFye2OD8jVR0zqhAYLEbHzpa1CBiLRzhShIK5DFW0fyVOa/hBFR4bHGbP5IZPlVDz71DoArZKlggKk7j5R5A6xNz38Rn95t4LxLtwdymtaMQSDTk61QHmi7Txhfi5EzbS1vU0xAZQmBsEd104iUZP4ADgSorJ6a+QW4OT5M5Nfssfgm4u0uQ63rt6t8CTIDprAwi1TkEnYwY37838vTW8vDDIWTVO0ZDwz4Dj3cn0V6A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785510078; c=relaxed/relaxed;
	bh=0QWMMe323FpJCSMO/+srY4nRAHRMTDbNnpPaXX/8/JA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=o1/cXPaxNcAdPNyZiHWdn1gPAFqNPD5ryyWPQLyyZFgcLAiaEjHvcR+2BmACRVg4lUIPA8atDThdAbN2fyKbFCP42dpMeDPvjDVeXso8eB1SCtibJYa4izZsj2gJ/jUcq/c7ppV1dyN1xgIHett9GofG2Y3vIiOaqK4xXj8baVzciGZcoJik1GTEUgrftv+FONoNc+arm+vRDMhLk1kJ0yMRhlQCxLcJ+HtyEUicXEhKJCFEkchxgDLtAFt323/3WK6mNBP2ydwtGmqxXMPnj6y2HJorlVoNOcLt3UgmJAjy6FHpMT9VAm4C+Dr1xVyQSJIGkaEwVzmYUGxUtGWqSA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=kernel.dk; dkim=pass (2048-bit key; unprotected) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=hMLiSwfg; dkim-atps=neutral; spf=pass (client-ip=2001:4860:4864:20::34; helo=mail-oa1-x34.google.com; envelope-from=axboe@kernel.dk; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.dk
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=hMLiSwfg;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.dk (client-ip=2001:4860:4864:20::34; helo=mail-oa1-x34.google.com; envelope-from=axboe@kernel.dk; receiver=lists.ozlabs.org)
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hBTmF0fvyz2xl5
	for <linux-erofs@lists.ozlabs.org>; Sat, 01 Aug 2026 01:01:14 +1000 (AEST)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-456395f4e7bso672390fac.0
        for <linux-erofs@lists.ozlabs.org>; Fri, 31 Jul 2026 08:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1785510070; x=1786114870; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0QWMMe323FpJCSMO/+srY4nRAHRMTDbNnpPaXX/8/JA=;
        b=hMLiSwfgFyokbT/PXozMTYO6ce7KdjEZS1CWJYIntTGTZAQRmotQbuU5ooabmKSeqK
         /oH1HxkDkhHlm5mJB+rAZS/IQKIvO5BZVTMNiSmL1Bdy15dT+gcylrtS9cwsdwzB2xTm
         dZNL3gWHKHipful8LH9jn0GWJtlP6MRtkzp7S9broDoqHafoR8kXsCv+LAhNOwAXV1RA
         oeJ2odE1d/8+M3NZYHD4cr3i4KFT8IUncHKlhCs/ltH/9xpkeqtock5hPVb+lFZdB/hC
         hlVkraty1qc2MUa+a3iSeDRYZIaGxSuFf2PKL9dkk/79ZnhMmubFjf9wsfSBLaOK1/or
         MmIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785510070; x=1786114870;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0QWMMe323FpJCSMO/+srY4nRAHRMTDbNnpPaXX/8/JA=;
        b=ZedLGeq0k5LzS8VVw7hpRmU4N6q9sMWEKRiU3sFbfJwa1AAAgfQ1qLF4kaYEGsJtgU
         hXIKl8W200Ysm0Wlcva+Az34DSb8cY3Q4uIg65wxBZBWJH12H79l7bnUeFGXtBuRJSod
         nE5bFZAdE4IdbGgrJEZ1qjEq84afxMJhC+Nixzjg6OIfIDN781s1KX6TaMX/n543w9kz
         oqaLR2K0g1rp5jUSfUpjiwW0WUPT7KA2c6dZaahWQTyVnbVsx4O05pWBagX9P3EGY6jb
         tBV6iL83MRPe051XHFQiHUjcfE2HvBXaUdMF629IjC+Eno6Vq+u22+iOcwAqhln4M4g1
         y4UQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpky/unqcyrwkrnfeso3vtsyvuodALtnputu3NY1jUPjBzCffisfxqrwG0DbRxsFpTpmNIG+/11vEiQaw==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YwQCyU9/BBU2L9sHz0lC2DuG0tetzdwE1M+pfsNUYLDQsu+etYb
	r2IFPoaBMe0jVdu3xrnNKOTR7K21ASdN5XzCG1WhjU2tI8SVnKJ9JGKkLZrE1rBkaps=
X-Gm-Gg: AR+sD12J3jwRLeWbwncfdD9bIYL1MLL4R/lm0+3ZlFVvCUD4yaUnbLd3595ZPMldJuW
	a8FZL1NSbYxYDwDQAoyhseXsSEPU5dyzjfzo3sfQjsrSufmbCiA18H+Ca2hP8RXpaYs5hkwpwYa
	YRGEUqntpvFsCuMRR+LpHLtBEzRup8rTlgUdInkxmG3osWbr35UxwgHkuExA7c71+USbsv0l1Y3
	Zt0dikH1Rnnx5Fbz1biVQmyepAP32shaO/K35WxAUWbx26QHUVGECk6u/KN/XCNGZHpXTpXwumD
	PPewnWyukn57gWJlKuyzuqhi7xIEmqtyErO456MU8LPkTrtbYTeyRME0rTyKgp8O45OvAry1MOp
	mpceCOs29k5KQOl4pVezgdXbu/x2gYoPYXtzXrag535MrkFtIj8qegXwVp4dy4j6GMH1gvu+Flr
	4ot//KtsN3gk1guDVbmctmlj2JXOs92x5hlTQXuD3ojg43sYLhQo6PyB3mWwISLo19HWzNjJ9j9
	IaHcTh0zo5A3Znzb8UTB1pk1Kfx44oxg2ieZ/f6Cg==
X-Received: by 2002:a05:6870:92c2:b0:455:9e4c:6bd8 with SMTP id 586e51a60fabf-4590572d113mr843225fac.2.1785510069701;
        Fri, 31 Jul 2026 08:01:09 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-458f67655fesm1139402fac.18.2026.07.31.08.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:01:08 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Christian Brauner <brauner@kernel.org>, 
 "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>, 
 Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
 Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
 Chunhai Guo <guochunhai@vivo.com>, Tal Zussman <tz2294@columbia.edu>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>, 
 Hillf Danton <hdanton@sina.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-erofs@lists.ozlabs.org, 
 Christoph Hellwig <hch@lst.de>
In-Reply-To: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
Subject: Re: [PATCH v7 0/5] block: enable RWF_DONTCACHE for block devices
Message-Id: <178551006694.14426.18417795913299417263.b4-ty@b4>
Date: Fri, 31 Jul 2026 09:01:06 -0600
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Thu, 30 Jul 2026 02:57:50 -0400, Tal Zussman wrote:
> Add support for using RWF_DONTCACHE with block devices.
> 
> Dropbehind pruning needs to be done in non-IRQ context, but block
> devices complete writeback in IRQ context. To fix this, we defer
> dropbehind invalidation to task context. Add infrastructure that lets
> bi_end_io callbacks run from a worker, in two forms:
> 
> [...]

Applied, thanks!

[1/5] block: introduce bio_in_atomic()
      commit: 8ed0831b5263e1aa48d99063795a1f20e4e69b50
[2/5] block: add task-context bio completion infrastructure
      commit: 77e73fa61b3888c9765a549af02c928372522cc9
[3/5] iomap: use BIO_COMPLETE_IN_TASK for dropbehind writeback
      commit: efbde6f9f449da3306f5b5d32f08829954ffb44d
[4/5] buffer: set BIO_COMPLETE_IN_TASK for dropbehind writeback
      commit: a2c924c240e74dc2dd14ff763245dc86b93db714
[5/5] block: enable RWF_DONTCACHE for block devices
      commit: 8b5ffb43ae9d27eed9165e1962963d685d879219

Best regards,
-- 
Jens Axboe




