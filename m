Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E14AC3DA4A
	for <linux-erofs@archiver.kernel.org>; Mon,  5 Aug 2024 18:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1722882130;
	bh=7342bL6XlId672ZUmqVGLoIQV+uvAdMIHD0PWaxvgpM=;
	h=References:In-Reply-To:Date:Subject:To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=Nl/DQWgPYIdDNhjGDALo7fSBu8+SJbE7JLaV0GLh71kaT46DfJ93RgN3uF3l5yNOV
	 AMnwH+ROD6hpd9vnERxMpFvdLZ+4LxdXjRnUG0TZJP0rXSn23rwh13Vr21MT+l1yxT
	 D97Wf6coxOvyZ1aqGrhYeBkN72xG3BHzSV6jbxTFi1XsMvT7qI6MJh3VxvOEwwCwF+
	 uaWXjq3CxD1z09C3LyccgqhnOgDPmp7yW+CgWvYbBqCpm6DhwJkxUrHbeM2dU4rPMp
	 iQRS2KpOszPRB5EbBuOeBEvo55QWsJ8NsF25d9WEnXodd2sujkS8tG6E+wCnFbQTPq
	 dj15PPoxG46Ew==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Wd4Xf174jz3cj7
	for <linux-erofs@archiver.kernel.org>; Tue,  6 Aug 2024 04:22:10 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20230601 header.b=SFRN9a+I;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=google.com (client-ip=2a00:1450:4864:20::335; helo=mail-wm1-x335.google.com; envelope-from=dhavale@google.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Wd4XX02G4z3cBP
	for <linux-erofs@lists.ozlabs.org>; Tue,  6 Aug 2024 04:22:03 +1000 (AEST)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-42809d6e719so75556115e9.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 05 Aug 2024 11:22:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722882115; x=1723486915;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7342bL6XlId672ZUmqVGLoIQV+uvAdMIHD0PWaxvgpM=;
        b=VNgsdUHXriZKHvAaATq9HFwEG04vW72wIFEs+C4fO+Rm7IBa96wmz+LbJLjf3vWYgq
         pcxQKsvdtdE6VuQvReb1YeaU+VsTIhGYha85bf06vpj9gOHdnJBCpBETsiMRwfw28WCQ
         dXRQ/4tnqayMABZZnqF50HMF3tP0SGzM/0Y9RkoIYjaKQQgjAh3G1cnr/5jRTeYy9sxE
         twH9pQwa0sAzV0p8ubpgXKdyCMwcKxnSjN9YRtYZ0Fv2l7+LXyRhTDaBbIbKV1Rpl5xS
         eeW5Ag+YKbZ21Ol0Z9aQ0Hm2gt+MmhykUONNfxWUXg6mo0vQ4bFfgr9fIRr7UP3RIlQL
         Nkuw==
X-Gm-Message-State: AOJu0YzwT1YkJhAFWZApqgXdR4lOCsnfxtVW5wLhE5KPK46Ct8fjgMP5
	OcoMrdbmqk7dA9camdp9Rcixyai9sGXid/8X21D43/tX3iSe/71SKvxzU+vdGUpz8Z52698w4bG
	Sk6HNQ7vyfz5np4sTvHfrVn2H6s9k/EeNQZ97IXuK5jjmwe1aWB4su+g=
X-Google-Smtp-Source: AGHT+IEi4R095QzrXRyMSUiD/CyzW5l4RKHDco4NiHoPHpsNObnhOaqat27LvSE977By2Rc9OGt0QV25H5y+AzgWuRU=
X-Received: by 2002:a05:6000:1e97:b0:368:74c0:6721 with SMTP id
 ffacd0b85a97d-36bbc14a6edmr8146539f8f.38.1722882114834; Mon, 05 Aug 2024
 11:21:54 -0700 (PDT)
MIME-Version: 1.0
References: <20240805022826.2581887-1-hongzhen@linux.alibaba.com>
In-Reply-To: <20240805022826.2581887-1-hongzhen@linux.alibaba.com>
Date: Mon, 5 Aug 2024 11:21:43 -0700
Message-ID: <CAB=BE-TtHqEdeqpkgnV7fBL_K8am=WedpPqSzbQFpumnYE8X0A@mail.gmail.com>
Subject: Re: [PATCH] erofs-utils: fix extra argument to erofs_err()
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
