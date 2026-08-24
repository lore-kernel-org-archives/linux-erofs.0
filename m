Return-Path: <linux-erofs+bounces-4337-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56154C5DF9C
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Aug 2026 21:10:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hTNq332MTz2y2c;
	Tue, 25 Aug 2026 07:10:23 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::735" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787605823;
	cv=pass; b=FI8QwNmyQqPYJJ1sAZiYR0TVaM+JMnYYqFi6kaTHpk50/3SCyAJ4r879dyv8HETHV63tfI/DY0SPnpL6lD3ZVKISx307e3krSfsRwPEBoF2Y8soAnva2gMIlb9kVFnZUIyidlCSrN97U9ehN+6q6HWP0Tzs83XACNYV/QZ+KQmasYiq/09Z/Q9/F1SqoIV9mnD+6hqfiwmoPFykOJbZon6RpRw9m/V6IZq1TiriJ+rWWiGeO9k3pEMNzrdSG+SqTlbr8X195eLBtIj6iDPmuVvxd006QN43U+J9l2XNZtX03tyqRU0DLaHZRPZVHQioUo87E0UDlnv/IFWrRflXBAA==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787605823; c=relaxed/relaxed;
	bh=QBhxnZ+HTnh0pfPdCIhrG9H61+4BdpcmSoOUGM6I0k0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bbkSo5bEq8DCeVI08Minln1oU1fmCqShq1jAr+eVzLF9PTytn5E6nUFlJci4lsZ9TkHcU37+fCgS1vVn9Cd+GsTTqnKsrCzclyOHqYp4w732j9Utphqp6ZsJS/Gwall182jytqA0CrzR5d58ZP0QyAqo9isKnrunmh1v9g9dB9s63cDouTfJvy49cWN+ALJ2JzAfQHBCRjKixi79VSgmFR1sDZrpu7t6d6J2nwsTC0ibH8N15xo3kXNYg2xIYDz9gF/YDhwCgxaAdWy/QBKqQg6x6tjZw5vM4qgwwnYbSJMq1nDqyVuyz/ERt9Bm0r7poF7UuYIRCUxV5FYX9kt42Q==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=openai.com; dkim=pass (1024-bit key; unprotected) header.d=openai.com header.i=@openai.com header.a=rsa-sha256 header.s=google header.b=AVv3WIzo; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::735; helo=mail-qk1-x735.google.com; envelope-from=cayoub@openai.com; receiver=lists.ozlabs.org) smtp.mailfrom=openai.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=openai.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=openai.com header.i=@openai.com header.a=rsa-sha256 header.s=google header.b=AVv3WIzo;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=openai.com (client-ip=2607:f8b0:4864:20::735; helo=mail-qk1-x735.google.com; envelope-from=cayoub@openai.com; receiver=lists.ozlabs.org)
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hTNq15z6Sz2xZh
	for <linux-erofs@lists.ozlabs.org>; Tue, 25 Aug 2026 07:10:20 +1000 (AEST)
Received: by mail-qk1-x735.google.com with SMTP id af79cd13be357-936c02e58dfso224636785a.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 24 Aug 2026 14:10:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787605818; cv=none;
        d=google.com; s=arc-20260327;
        b=OYdvLaWRHjjDI53HKBEbR040R6jcPANYj5HuGRu6wm0UGFs8zCbWiIVpVYrJmjEOb4
         JSXW9ui+HsmcvplIgWfF48o4JQyqh/ToiDQy5AX70a7nyzUcV0ubUFkpkLd99dHxl2S7
         m+jeTkwEDVOwZHDtKuh2sFIhDUzvRGqFxhRqXtmVdwpoy/fjKvcw1gNcPY61HWtUwEaP
         UXWnx6T6uoiFiBgS2JFmPmrDUTz1b8/n6HaWUpLKWlVSe32eQ1PnoUA/d7DixiyGVyVr
         8CN4oY1UkKa6Y5TbCV+4Oi47pXbT5lsb3GGNKMyQ7q0p94Ho584Z6albDrVCNt9SRu+V
         TJ3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QBhxnZ+HTnh0pfPdCIhrG9H61+4BdpcmSoOUGM6I0k0=;
        fh=ynEUiyZNWeCos8XWuGiLwTXUyx9jGmklxoHKYE8Jf4k=;
        b=Oxp35OwXULCNn2xvWXoeOKQA/7tfImPf4G/oP0uH4UkxwtpmVONBr7iDmnGfl/wmoi
         UNr+1VNxQLpXEz+fviAbHAUcG0w5rcgIEvYdrxME/u13xgctNJ222v0Hkw8gAySn0d4a
         t1sfTXLAqrCPY3Yv4QaT0GFWV5zK/0Ogl2vVd/1BQDxRIYwI/76xElg6M2KUTjxldXvi
         97yts4VpFCB0PxoxWLilXAsDfgegVDFiQWWKjUhq6dy1gGZvC3qcBgStGnfGT4KHP9dT
         w9PH6o3UYt3ADJPIj6WQ+NjGANjdzyW87/uP6IrKGL4hY5zhG6etsUvHEAu0UdAgMBps
         q+KQ==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1787605818; x=1788210618; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QBhxnZ+HTnh0pfPdCIhrG9H61+4BdpcmSoOUGM6I0k0=;
        b=AVv3WIzol6gmzxE7itoBDPZs9se5vNwB/IvZkMfI11QN/imW0d76qB5+sf1FSGn8t/
         A9m+Bz2/Rq7pKiP64hDmsjrrYiVZl1hAfIovk/hqKgy/OlBUri4JPdUK3TxGsgg5gt4S
         pESKSoAWG6J3XNes8vg7lJnOLjoLp+LK+1dZg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787605818; x=1788210618;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QBhxnZ+HTnh0pfPdCIhrG9H61+4BdpcmSoOUGM6I0k0=;
        b=e0bj4fyygOFO+y4STIVox6y23DeOPqEhXA7n8UJdblxDkhWlBmWdabjOb5F1Wjvwgr
         v/NWz68OpAM1rHgpoRQUrh5aRzeapmShyMmHuI64TuF0hzXxiM6I8xQqI81SOqO3R9CW
         aCvf+Y7bK4hsA7XzExrMIXe0yHW2d076yaoECvyxZFLOsDowJCIyxtK4rPNKy3GVhwGa
         osw2z5+RLvxzfLxoCM/CFax79O+XdsOn78763AdTlZIPfzTKrbNw2OTGlEp19dLyoQum
         f5Rw8+fz2WGi7XiSz6r+pb3XPohx8myzNBz/94Z2nQF8VFpou01esXfJdzmLrhsgHaDz
         OpkA==
X-Gm-Message-State: AFuF++mEoL4GLCo0+iwOCnPBUlfzRg5eqfZaCltIjwcu5N2z4wlyJCIX
	w3qizxSiB0+weHJDV432+aMit54cs/WdbV0hbY4me3cG7XjgFaEelvO0n7t7TM2C/tWy9wqeisp
	y8I39R4VoPSzrdiU0sGZ+xp/FGErP2dcqIwUznFPwGVT/l1wl8oeVBwI=
X-Gm-Gg: AR+sD13HeKZaMjzVyDS6vlhIqBgTtdRmZ+r9iDnvVTVUEGVgHLB9dqvcygw32Bbys/Z
	Z5P8zs69ANxfYr94cwiUQi9FN8RBwK7meKqxXFgJ124czGDzBwbyiOABflRJWBAx47UAH3e6fAp
	vmBYyAaAP5E/7q1vU6UHi27PrvN2/vXecCyMUaZHmVoKwXN8WVWSBNoCex3ef6eWp2wtL5daRdk
	hBUqX+MRazxnsYK5oXiFea+Nv/wCrRHOfrscRwoFC8nf+UjzzHs2XSGhTkr6/aQ5yrqGZmYYmV7
	307nN6F/6fyUk5O/GRMaMHEZOnOoap+OnK5HHCmborUpbnO0ExBkeWBU1Yom0voPSQXp1m6ogXS
	+y0AKS1fQRxhWXGJ6syLBOahod3CD7AjtSjzVNSv/mxuW/Ylx
X-Received: by 2002:a05:620a:678:b0:92e:6637:d98 with SMTP id
 af79cd13be357-9376f9a1284mr195743785a.18.1787605818135; Mon, 24 Aug 2026
 14:10:18 -0700 (PDT)
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
References: <20260810-rebuild-wide-directory-index-v2-1-3a977092b7ea@openai.com>
In-Reply-To: <20260810-rebuild-wide-directory-index-v2-1-3a977092b7ea@openai.com>
From: Chris Ayoub <cayoub@openai.com>
Date: Mon, 24 Aug 2026 14:10:06 -0700
X-Gm-Features: AcwNN1XcgBCH02yE-YHKb7s0N1emZkAZyKAqc2oAtrUXX2MC13dw3ZIPGB5UDoY
Message-ID: <CADh04Ha-okHEq+GbD0hizFVPcxE=aqFbgvJpz550yFBV6wsF7Q@mail.gmail.com>
Subject: Re: [PATCH v2] rebuild: prevent quadratic snapshot merges on wide directories
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Gao,

Gentle ping on this v2. Please let me know if any further changes are needed.

Thanks,
Chris

