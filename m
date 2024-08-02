Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB6A8C3DA7F
	for <linux-erofs@archiver.kernel.org>; Fri,  2 Aug 2024 21:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1722633742;
	bh=7342bL6XlId672ZUmqVGLoIQV+uvAdMIHD0PWaxvgpM=;
	h=References:In-Reply-To:Date:Subject:To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=gyIl9+9/C6EBP5awoBEYjB3lgS8BTBEX8fonRjLVHXletfhkzNqKa6cu9KkbK6r+U
	 w2CB85krAd1VOwGbNLqqXYg0FHZ/6wHo4szwklSiGk6B1B+h8NrHdUKjjDiIZ3UmZD
	 NePo+BZp/8Ic6K70pm6TOZenPd4NQ80he72djrT4lQMEqn57Cjx8O615ETDIbhVj2B
	 Ri8SLfoiAbvF9OcOiTHJVaf5VYtaSOsiyYdZpWEQTiuFHU7EyKLlbXkFvQIJ0nZtwM
	 aeSn0W7QnGckYIRP4Vr8TRZ4l3snNIzbVU2rvHdSslT2L26EniaT4kEJQKC3zrYqE/
	 B3P4B7U427oNQ==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4WbJgy3n19z3dXB
	for <linux-erofs@archiver.kernel.org>; Sat,  3 Aug 2024 07:22:22 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20230601 header.b=rg/c6qye;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=google.com (client-ip=2a00:1450:4864:20::333; helo=mail-wm1-x333.google.com; envelope-from=dhavale@google.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4WbJgs0LTyz3dL8
	for <linux-erofs@lists.ozlabs.org>; Sat,  3 Aug 2024 07:22:16 +1000 (AEST)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-4281ca54fd3so49431225e9.2
        for <linux-erofs@lists.ozlabs.org>; Fri, 02 Aug 2024 14:22:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722633734; x=1723238534;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7342bL6XlId672ZUmqVGLoIQV+uvAdMIHD0PWaxvgpM=;
        b=PVhr42paO29K1k/mku3lRrOdxLEaj32h66XRSeg1X58kVaGpE/zIn4/o8dKBYK8FEM
         y50oLOlesfpFXNqLLZ+5lT8e0V8E/iAxc8BBo1Zf/pzjntaw5VSrVXUvfWY7OM/2IwKq
         Va+WhBu/rE0jlmmcV2x9+0mgdX348lVEtjhVxrwB4f7hQzz7ZBZWys3RUmV2hLYItzy5
         aw4G/QUvJeU//poDq1BsjTNwKYi5dkYAtaczwZNEYzmRv6IOKNoWsFA37Wn3ltMyhWyl
         S8Cq1u65IS6nnxIzRb1mS51FCdjIufRqiaJ5byNewtijV5aRlG2BsBNGjEDnnG8cf9HK
         MB1w==
X-Gm-Message-State: AOJu0YxqCaEnERBMi1RIsNHmi/b2N3B71X4CotR0szLLev4PToRB5Sg3
	vdUUUyyAdGDev1IElsTyYBPTyzoazO6LG9kwfaC1KrpyXITgtAQlkmMQUcUhhBddj9M/BHsNTWS
	+h1oH3Zdcg6L5Kh5utVeXkqC6RMzflqOlYgKa837KDlsqk2CCbCmoC0Q=
X-Google-Smtp-Source: AGHT+IEnl3KZAPVXPY23x+enN7U3PrlPM+nkKJPZlWBn4WKp9ojVzKq4xeTwB1aZTvUAQ3rtDcqUWkqE1j07tMpVo6M=
X-Received: by 2002:a5d:4849:0:b0:366:eeda:c32d with SMTP id
 ffacd0b85a97d-36bbc0e96aemr2710275f8f.31.1722633733957; Fri, 02 Aug 2024
 14:22:13 -0700 (PDT)
MIME-Version: 1.0
References: <20240802015527.2113797-1-hsiangkao@linux.alibaba.com> <20240802062316.2368403-1-hsiangkao@linux.alibaba.com>
In-Reply-To: <20240802062316.2368403-1-hsiangkao@linux.alibaba.com>
Date: Fri, 2 Aug 2024 14:22:02 -0700
Message-ID: <CAB=BE-RmhN1hAZ1559VY5LffvP11g2LtNaLQi35m-Q8BG_aOSQ@mail.gmail.com>
Subject: Re: [PATCH 4/3] erofs-utils: lib: fix potential memory leak in erofs_export_xattr_ibody()
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
