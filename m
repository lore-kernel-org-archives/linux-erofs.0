Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84280C3DA4A
	for <linux-erofs@archiver.kernel.org>; Fri,  2 Aug 2024 21:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1722633680;
	bh=7342bL6XlId672ZUmqVGLoIQV+uvAdMIHD0PWaxvgpM=;
	h=References:In-Reply-To:Date:Subject:To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=b3bossZJ21OWkBRdhKB5irbZCs3wiI9T7sB85eBeQGbaVlSca8r/jPeyBDdjvq6lM
	 R6Xoip7lYX6GpY3QEI0fOBgFuyFMY3n1lzfleWX5l8D6Kb36YghEvJ2R1lAr+d6IS1
	 7yKRVCZsiDvLIpcOz4fxWOaSHkel1zR52Z+dliYxZngCgFzVZeq6SBdF6ORPYELGJD
	 d+04ofdsm5GUlQNdmOPdFQvn9vdBSdFOUG1oOSHcE8mspIdDFO0JmLy4BL3T6vRS4F
	 tDipL7GeKP8lgyvbMTNtg0+VNfRAjUfWdvTJUQ/T1LUZAJInwWu1q55JINeRRcW3DE
	 k8BmLLCcoXNzg==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4WbJfm5ny1z30fM
	for <linux-erofs@archiver.kernel.org>; Sat,  3 Aug 2024 07:21:20 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20230601 header.b=koygeyk5;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=google.com (client-ip=2a00:1450:4864:20::436; helo=mail-wr1-x436.google.com; envelope-from=dhavale@google.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4WbJfg59Zxz3dL8
	for <linux-erofs@lists.ozlabs.org>; Sat,  3 Aug 2024 07:21:15 +1000 (AEST)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-368712acb8dso4070014f8f.2
        for <linux-erofs@lists.ozlabs.org>; Fri, 02 Aug 2024 14:21:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722633672; x=1723238472;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7342bL6XlId672ZUmqVGLoIQV+uvAdMIHD0PWaxvgpM=;
        b=Ee7HQVjndXeMx81bn82pcajtiyu1+6wgwRTA7CSircIo23yq4DYmplq1KwowDsTl6m
         KWvAH/AbhZ5UJ59dEmiW1q8SW0czzTaDGpfYhrYBQuWj0hu77jbe9x1qjSVZ5Dm3zBHb
         akS2QpJ11Vk2+KboZN+0vjTAtdCwSohcAHGPS9x5N4C3f1Z8F5dQK7PYid4BBptkEc/C
         NpwRCFJTh1fUHOCHoTmi2oQk7PCTf+MVUW2dL3WEGeXDgXiyRfWixl8OyvmTlF1UMv3B
         lcEFS3B+MZns950MQyW0wmHO4AZQOaIrq8SC3EQEWA0TGirV+HfimLL8rCZQ5wXADv2Z
         LsPQ==
X-Gm-Message-State: AOJu0YyAEx59lHFRdJs4ihdOiXGMXJkL96AL1UOev+KizJboZ9zQPAg0
	/s6ApFw+4QpRCr1qMOTInC/lUtrP+n4Ocy2yeW4Ggw+Fquy/LSd6L89H+xyNp80kSWv2kwjyzXH
	+FsZ3eZrAN/jFQDLsU0TnQqCUFPEmXRz637D9
X-Google-Smtp-Source: AGHT+IGSzzZeALEwhK3OaV1UZVosAiQB0hJEZ2mHKFhtvSWg1ERM6Gs+ZNOIOW6lD0FMvujL9laMcIRjbGA76qEL8NE=
X-Received: by 2002:a5d:6b10:0:b0:367:8a2e:b550 with SMTP id
 ffacd0b85a97d-36bbc182304mr2899580f8f.60.1722633671498; Fri, 02 Aug 2024
 14:21:11 -0700 (PDT)
MIME-Version: 1.0
References: <20240802015527.2113797-1-hsiangkao@linux.alibaba.com> <20240802015527.2113797-3-hsiangkao@linux.alibaba.com>
In-Reply-To: <20240802015527.2113797-3-hsiangkao@linux.alibaba.com>
Date: Fri, 2 Aug 2024 14:21:00 -0700
Message-ID: <CAB=BE-Q+r8QrCLaS8GjzAP75XzJsJ4s=8JisLG4aLiqKDA+KeA@mail.gmail.com>
Subject: Re: [PATCH 3/3] erofs-utils: lib: fix fd leak on failure in erofs_dev_open()
To: Gao Xiang <hsiangkao@linux.alibaba.com>
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
From: Sandeep Dhavale via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Sandeep Dhavale <dhavale@google.com>
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Reviewed-by: Sandeep Dhavale <dhavale@google.com>

Thanks,
Sandeep.
