Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 917DDC3DA4A
	for <linux-erofs@archiver.kernel.org>; Mon, 29 Jul 2024 16:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1722272365;
	bh=7342bL6XlId672ZUmqVGLoIQV+uvAdMIHD0PWaxvgpM=;
	h=References:In-Reply-To:Date:Subject:To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=XQapAmkZ2MW7yZI741wa+3+2vWzR/JvoksIrGGuPWnuJauqt5/5rUqlArSoKS0SFF
	 E1pVdcK1WQSqjTsU4aQSlU2ydjWYNTuo7SvIvxHPQD2O52XbR0qDc8OSLbLqqejhLn
	 9ufQrmjyklWhXZNg5WezPh3BRtMQS8+DAcd9RCR3GC2moZvaWs7UWVoti33Af6UNVp
	 tRfgJcLNRtq3mJkagwRoNfWzRbUsN4EeUyziL3Q53yM7Bear25j4rJOhiRhOpog9A9
	 HFjz5ojYwdbf4jQZJcHQ0cLNKhCh+e5E5KXCK3/G4Yz/ccXXsb20ZlKzI0M3fLqxjf
	 JwKm9uMS/Hd9g==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4WXl2P2J6Lz3ckQ
	for <linux-erofs@archiver.kernel.org>; Tue, 30 Jul 2024 02:59:25 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20230601 header.b=dCVZqim2;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=google.com (client-ip=2a00:1450:4864:20::434; helo=mail-wr1-x434.google.com; envelope-from=dhavale@google.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4WXl2H5Zqwz3cYr
	for <linux-erofs@lists.ozlabs.org>; Tue, 30 Jul 2024 02:59:19 +1000 (AEST)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-368f92df172so1573369f8f.2
        for <linux-erofs@lists.ozlabs.org>; Mon, 29 Jul 2024 09:59:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722272356; x=1722877156;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7342bL6XlId672ZUmqVGLoIQV+uvAdMIHD0PWaxvgpM=;
        b=hfuSS4nkuYm0wzkaOdAD/5mGoz2vPrPSCCzYHPNBAgdO5JU30wOJccGArJuEwqMfAa
         wQqLsAcKFGc79gNV3fvOlYyplNEehh/8PTzCrgQ64wW76ybIqbhMkIb9PzHRyD7z/COr
         WdxQzL43Y72VtdBleqMf3iup5QS95u+/PozGxIToTHMTjWdUUHQ9SVnkJSxrfbvZfl+K
         PtOztmEhd/SsnunuJtAOWUQR9OVZa9SrHcUPLkaFqz4rRxu35w8YJBpL906tNFDtRMGF
         iWc1sFce0wnWrbki6VNmMEtRxSGXUGU0ukOiqhh7ks1r2nr4TUNohRP4IvakUAsjOD6f
         +bqw==
X-Gm-Message-State: AOJu0YyQn+6EN+4wMBYHsyv+ezHCOHt1OkllFSoupp0b6jnE/JOzIuKL
	+Ohv9H3Jt+wfw2kq4LNoyr+YzbpkiAy+cfc1FAL6w/nlO/pzsQxDPDRRAOYqW1+gMnXgUqv/15J
	YEAj0KVqdRujpatjAU5gq7zIskXUo58ZxUdJU4n3JNofFwnNahc9/e0U=
X-Google-Smtp-Source: AGHT+IGlMhll40m5dkjsfZVSDrtEpSeX2hMVM6VTPFN3zmsPBBwVvo+DIyNLULkwwDn2nrtnVfzYQMfGOlgXsBnWzR4=
X-Received: by 2002:a5d:6e91:0:b0:367:99a7:42db with SMTP id
 ffacd0b85a97d-36b5d0c9022mr4566704f8f.51.1722272355417; Mon, 29 Jul 2024
 09:59:15 -0700 (PDT)
MIME-Version: 1.0
References: <20240729075027.712339-1-hsiangkao@linux.alibaba.com>
In-Reply-To: <20240729075027.712339-1-hsiangkao@linux.alibaba.com>
Date: Mon, 29 Jul 2024 09:59:04 -0700
Message-ID: <CAB=BE-Seda4hPMqVMX1RHENDEg7miC7cgH=0ppHW6ZMghR0ONw@mail.gmail.com>
Subject: Re: [PATCH 1/2] erofs-utils: lib: allow xattr e_name_index as 0
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
