Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A3C2C3DA4A
	for <linux-erofs@archiver.kernel.org>; Mon, 29 Jul 2024 17:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1722273674;
	bh=ldg+LbqnHJ9gwDMdSZ9tPLEGrNZoIczhjCXH+CAGglY=;
	h=References:In-Reply-To:Date:Subject:To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=dXCg2++17XjpIMW9NYk7KiswY2rRAkIx9m6XYUU1mINf07ciBD0ydGlx6gehUKIwg
	 EA5/ZaPoDyyDcmjaaui1pwQeEuGuB+spsEn1QKRft+M2EMToMNfevKdKeHas3b0qgB
	 7V5r+rA7I6vISYLYyxnmJVyBWOSWalrBLg3tgfJkxVyhKn3nrZnLj31K0up2GxbCPF
	 ehXw7+EaL9h5gTUiNhU1jDCT6v+2XewhW88Awf9jDxieDAz4h13ASAEiQ4PyMi96w8
	 96tpX7sVYfW4a3vpy4tRVzuMzQyOlWTwneonNzsLhAah98+KQSkt0UrWu1iMHYPLrU
	 b0e3/uzAWKH9w==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4WXlWZ639vz3cl3
	for <linux-erofs@archiver.kernel.org>; Tue, 30 Jul 2024 03:21:14 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20230601 header.b=sjmtfOdn;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=google.com (client-ip=2a00:1450:4864:20::332; helo=mail-wm1-x332.google.com; envelope-from=dhavale@google.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4WXlWP5KMCz3cYb
	for <linux-erofs@lists.ozlabs.org>; Tue, 30 Jul 2024 03:21:04 +1000 (AEST)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-4280bbdad3dso19462505e9.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 29 Jul 2024 10:21:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722273661; x=1722878461;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ldg+LbqnHJ9gwDMdSZ9tPLEGrNZoIczhjCXH+CAGglY=;
        b=u67cQUA8Ae4uMDUbPKIcMCShnbDotFn8cYBGSy7/JLyJGAF95TnX9qjbUaIpLYAyc5
         crb2/xyMNlzhD7+SQkR/wrXOgTl60pwXhsEkT6c0ed9AMFCbryrCUooclsiGpyMqAChp
         /4ASRvpYwpo8JOfiB8bDOoSU9ixelcfE8qYXa9qZrOs7ao6+hTbzLJlbtk7e69gFpakW
         CGyiii61UzT5M6QL025eoQ+5JI7ZN2+wi8E0u4VGnywSbsWJnkVRwN/fCVOqRYA55Ws8
         nbLX0Rn+zj6dgQqq5xdUV7RjySPeDuvOGFfr94bYUqAPwKqJ00+eolMLFR9J/f4Mb7zt
         vn0g==
X-Gm-Message-State: AOJu0YwqLNNGu93x2JCtNRvtCvFnRkg9VDAQkfzySwNqHRYQRkbRLHwh
	nL7eEXq/AlEwjzifTEWveXXB5p0Osf9Yb0fEzrn1Xpn8z3oQMToLFgbMZTty9COLJLsgx8o/qQA
	1zIzTmocasoKiaTY8CidvtzMw/hPoewfriIM0qNlc04Vw9WI0Gg20Rws=
X-Google-Smtp-Source: AGHT+IFhS8eLmEgTTMdRsaJPmwkdiSJ7oTWq9RCTcIkVIgVjxm43R26NT2/6yTydLP7tpdedzPwEeHAil3j7MVd+eN8=
X-Received: by 2002:a05:6000:1f83:b0:368:36e6:b23a with SMTP id
 ffacd0b85a97d-36b5d09db7amr5620888f8f.55.1722273660704; Mon, 29 Jul 2024
 10:21:00 -0700 (PDT)
MIME-Version: 1.0
References: <20240729075027.712339-1-hsiangkao@linux.alibaba.com> <20240729075027.712339-2-hsiangkao@linux.alibaba.com>
In-Reply-To: <20240729075027.712339-2-hsiangkao@linux.alibaba.com>
Date: Mon, 29 Jul 2024 10:20:49 -0700
Message-ID: <CAB=BE-TtW78x7yJ8TDDF5hsuF2WjuTKua6P67-y0ba7v4ePmvg@mail.gmail.com>
Subject: Re: [PATCH 2/2] erofs-utils: mkfs: support inline xattr reservation
 for rootdirs
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

LGTM.

Reviewed-by: Sandeep Dhavale <dhavale@google.com>

Thanks,
Sandeep.
