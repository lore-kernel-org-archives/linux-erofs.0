Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56541C3DA7F
	for <linux-erofs@archiver.kernel.org>; Mon,  5 Aug 2024 18:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1722882454;
	bh=7342bL6XlId672ZUmqVGLoIQV+uvAdMIHD0PWaxvgpM=;
	h=References:In-Reply-To:Date:Subject:To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=RFLe8RPNji3fBOoPeyQEHYCudvMKUKtIBGJyocgdhiaobZx1+uYe2eZ/GYrRk+AUb
	 7HFl2e3Fd/Y3zBZ5y/Cp4ulVbxG1ABw2F/G/IHlKmlxynlBmyOzN0SVV/1+T8c0Mnl
	 5o1ppDRMt45BTtNxuR4jQI+qFkfjUivFknyTNdexE3MmycZfv8fYjBQIvEInTrrlxx
	 O6V/qpsZBvTK/UJPHEBy+7wldMGEGqO7s00zqt3/5pI1WX7iMHsMJpkwJnur0RgUFo
	 vE5xC6+D10GjDjNTZU1OkH0k9IxWeVhUbCIs2vTZPfgkZAqH14UJegJ8Cj1A6J8Sa5
	 nCoeKjKHKVzJA==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Wd4ft0CdXz3cTl
	for <linux-erofs@archiver.kernel.org>; Tue,  6 Aug 2024 04:27:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20230601 header.b=jVXPk3hY;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=google.com (client-ip=2a00:1450:4864:20::436; helo=mail-wr1-x436.google.com; envelope-from=dhavale@google.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Wd4fm4lDlz3cTl
	for <linux-erofs@lists.ozlabs.org>; Tue,  6 Aug 2024 04:27:27 +1000 (AEST)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-3687f91af40so6451015f8f.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 05 Aug 2024 11:27:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722882444; x=1723487244;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7342bL6XlId672ZUmqVGLoIQV+uvAdMIHD0PWaxvgpM=;
        b=f2Ies8IiRackOoH0kWDrc35VtzDZhUJmXyx2aQv9rvuIjG7Qfu+/IU0cQ2P1mXdep4
         JlTtIMzI2vHcQ/AzJ2ktUyvW9HRiC0nhEnp7XrfiGOzXhEonVLwO0ne6++sAPC5wCZpc
         +6OQWZG8tlhYTDmvSNYsSPPD0XqryjXUQE1zyC5IuzobwK+d5yX4FE4t9Dy79lTniesV
         Sj3MKPAukzXOaM5YHzElXY7fZe+1Hu1+wd6WFVKJZlKDZVszoROgh7OC+EP6apEeQUqb
         J9VfVWlWdeqAn5Q/skWOrMQjGoRnFErNf/kac0PL0gvy1W9fKZ1nkylE777HVmD7pigx
         INAg==
X-Gm-Message-State: AOJu0Yx8yuD8pcqZPlXHiVixo6EzCoI8En/YKoart48fPPfSC/rUao5I
	G6GCreBHgeaW6QA2gcIUFZe00peb+1e+lNDFKG3Wu2UyGyKJZ72FwSAxSP14cZswJzOd/vMJRwA
	O57cdjvt2hCxCaTc+z8y8Dkk3z4GmVUbaJaQA/V0N31RxM2KLQt9uRB0=
X-Google-Smtp-Source: AGHT+IFqMLrntWNlwDRZ3LZva7yAfOPhkq0ZRTU2rd+nu2hT8ds7YZdF/ePBhdWm753yDUrhxJVb12yNA7g/S7q928Q=
X-Received: by 2002:adf:f345:0:b0:368:31c7:19dd with SMTP id
 ffacd0b85a97d-36bbc0ce408mr7531135f8f.5.1722882444024; Mon, 05 Aug 2024
 11:27:24 -0700 (PDT)
MIME-Version: 1.0
References: <20240805024408.2598464-1-hongzhen@linux.alibaba.com>
In-Reply-To: <20240805024408.2598464-1-hongzhen@linux.alibaba.com>
Date: Mon, 5 Aug 2024 11:27:12 -0700
Message-ID: <CAB=BE-RvceO_6qPaOyk6Cai-4kvc4rAoXp5eqbS+68zco_9-MA@mail.gmail.com>
Subject: Re: [PATCH] erofs-utils: fix invalid argument type in erofs_err()
To: Hongzhen Luo <hongzhen@linux.alibaba.com>
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
