Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7488AC3DA4A
	for <linux-erofs@archiver.kernel.org>; Fri,  2 Aug 2024 21:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1722633615;
	bh=7342bL6XlId672ZUmqVGLoIQV+uvAdMIHD0PWaxvgpM=;
	h=References:In-Reply-To:Date:Subject:To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=f5p8XpbVQpnVKKUV5ogYVQjxPH/SvLJgY+S2qzc+A/N2cG3hlUtTWibkfIndnsMO3
	 gJeZd/e6UfH5Ls7agNQ4EpLH8aMF8MfrhErFTrjyk65vPK5hpwwWdzqJ5OeB+c+oYT
	 /tAxqLSuYed/kcpwW144ojuCZ1O+w4YD2M5LGUCBFhTrd33sc2Cc0kgGatMWtNWSV4
	 xAOUrAzoS/TIf6M9URLvM1hKKFZ6OBQSqYP9PbGYNWu2nSpzTjj5TMleVZ6kKI7u4r
	 IWJed64T7UpOPtrqXr/ncm7HdHOAD1KXDoCl/N/3xL4tMlfL0q6i1V1LytcT0rx2It
	 82TodLSR8hIPw==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4WbJdW0kgnz3fSC
	for <linux-erofs@archiver.kernel.org>; Sat,  3 Aug 2024 07:20:15 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20230601 header.b=Vnf60OEE;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=google.com (client-ip=2a00:1450:4864:20::333; helo=mail-wm1-x333.google.com; envelope-from=dhavale@google.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4WbJdN6CSLz3dL8
	for <linux-erofs@lists.ozlabs.org>; Sat,  3 Aug 2024 07:20:08 +1000 (AEST)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-428243f928cso35438315e9.3
        for <linux-erofs@lists.ozlabs.org>; Fri, 02 Aug 2024 14:20:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722633605; x=1723238405;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7342bL6XlId672ZUmqVGLoIQV+uvAdMIHD0PWaxvgpM=;
        b=wLUuwpuVIBY9d1TPuBUl/4IPRtyeG9kgkAPXrDeEcquiUaliwG0FG6VYzvRwYGxxHs
         494ZBOf3HH0ZU9JmlXWg7gjOYhmb3vAGyh2E6WQhetbs7SXlgeW3n0ExNQVZ3q/8HJdq
         LDE1jmCCjDHxgFsY1TzIunEHXLDJhT03QxtM/e5QnlQe1C2ivceAseQOF1cHvaYrI2Mh
         g2r39iytsnGdUB11fTvMsfDUw3nMB7Gr4iTwOhjY61VFPg/0FsZY3n6ytOFqgN4p5vkq
         KSFpozr4+EZJRTpN+nTLuCY1piBzhaMuR5k2ckvf14HqiXrNSveSYTv8CRNxmGOEVf/z
         AbpA==
X-Gm-Message-State: AOJu0YzLA3w2gpJAeldJZHE2nGGJEQWk3AWEHhB0pslKsPiQLTrZD3fK
	lk79/T46Zcnj0aOj/FI6ioKiPOavz4RbpmLXE4t5hWVUiEIxy00ouP+BYQhzw03OzR00SjTHM3+
	gIejfrpkzygMtn9QpcQ57F/hKI29bDjMv8jvVkocpOBpvu0rcAD94fj4=
X-Google-Smtp-Source: AGHT+IHQbkLvycRtUgenI2bFwkadn6u8+Qy7BzgbB2B7r2af2gkO5pIkePAdDU623YARzEK8YnZzU53vLOXtsthk2qs=
X-Received: by 2002:a05:600c:3547:b0:426:63b8:2cce with SMTP id
 5b1f17b1804b1-428e6af2fadmr32097575e9.7.1722633604389; Fri, 02 Aug 2024
 14:20:04 -0700 (PDT)
MIME-Version: 1.0
References: <20240802015527.2113797-1-hsiangkao@linux.alibaba.com> <20240802015527.2113797-2-hsiangkao@linux.alibaba.com>
In-Reply-To: <20240802015527.2113797-2-hsiangkao@linux.alibaba.com>
Date: Fri, 2 Aug 2024 14:19:53 -0700
Message-ID: <CAB=BE-Rri4NDL3cVcu=gG_8_yVZgwpKvzGOGWLK9ys5OZc2SEg@mail.gmail.com>
Subject: Re: [PATCH 2/3] erofs-utils: lib: fix out-of-bounds in erofs_io_xcopy()
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
