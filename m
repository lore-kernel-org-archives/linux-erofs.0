Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70DF2C4345F
	for <linux-erofs@archiver.kernel.org>; Thu, 11 Apr 2024 18:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1712858441;
	bh=+xoq/sXDkK3DSRmnUSU07f6nURlDA/s2BY7gqYG2upo=;
	h=References:In-Reply-To:Date:Subject:To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=NzCxR+7h84NxJBInJRqfcz379rhC94YDa3fv5YnrFKhlPcQMSc0OaXzx05XerMPc+
	 EMsF7P7pJXgllrSl2u8T94X/Nsx2JRRgLCT2i9ct5l+GoHH9Nr6jWwIMcYdLYiR3UX
	 QfgNIanbKqz1WZgGu3GeHq6GiRp1d48ARyI8bIrf4OBQGownFerOj4+v8iGQ/Ij4+x
	 4dcZHkTjUhrCmwy6GAjqOsN3yjKBkpimA4rPeUEARZtKoPIWmT6Sfz0LiNKZ6+xP9Y
	 X/rGN7JW7OpHR95h+2u9yfLss0CK4CN5rHCegaVYhOF4+zYjUQ1R4Z0rGnH/MqHaVg
	 mOVWMkXJXhpdA==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4VFnYN6p9qz3vY9
	for <linux-erofs@archiver.kernel.org>; Fri, 12 Apr 2024 04:00:40 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20230601 header.b=DIPSqE/i;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=google.com (client-ip=2a00:1450:4864:20::42f; helo=mail-wr1-x42f.google.com; envelope-from=dhavale@google.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4VFnYD2K4Hz3d2c
	for <linux-erofs@lists.ozlabs.org>; Fri, 12 Apr 2024 04:00:31 +1000 (AEST)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-3455ff1339dso24442f8f.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 11 Apr 2024 11:00:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712858425; x=1713463225;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+xoq/sXDkK3DSRmnUSU07f6nURlDA/s2BY7gqYG2upo=;
        b=siD1oOOYOfCYHyUavVhah7E7VRVf8XEC7S+9dmp32OeHUuU+12NAy0+97Y+PlyXiy9
         +Y6p017UeWr1uNNusl7WWB4FXiur7ZCn8PpADXgplob4myxdgzS3fqQ4DPYEKUSyeb4w
         BAoGd8tLwldXuteRebL4WBRGtcV0ci0nBWGryfey5Q+BQz+tnpINh3FWVk4VJtfhtqmM
         TzXeJbTgEW9VPZ9G3gSkO+loupERzSoI4ECvJR5SS8bfqp6DZu8ryLgvdqjsejJ46phY
         i0ID3zMgGuUaoqXbKjbdMAo/xItCc+J8bI4mJPK7h0Z8dcTOJHJZnOPBajK8Uf2C2k6C
         ABjA==
X-Gm-Message-State: AOJu0YxH0DdDOPfNeD/3jUKmBHsYYpioXrPahKDdrOBeFnAVyHRkxK37
	qVeqDJ703I8KPPRzpZB9mdt7mrXK2s2qzwYd+TZkRkncP+6FXX1GDR6yHLVyM/l/LRDB64vLDHj
	p46RUDVOwDiU0uILEY5pvKJDPc6sJC/E/mc5ZR65pcLnxkS63wQ==
X-Google-Smtp-Source: AGHT+IGJO7I8CxPoUmprcshcJLp+kZvBlwDNXiTz0/Hr/iCaoSJ/QEJGs7YKWYUmlUoDKof9j181bsemnA5JjqTdIqs=
X-Received: by 2002:adf:fa8b:0:b0:346:c912:3e97 with SMTP id
 h11-20020adffa8b000000b00346c9123e97mr215057wrr.44.1712858425093; Thu, 11 Apr
 2024 11:00:25 -0700 (PDT)
MIME-Version: 1.0
References: <20240411100039.197417-1-hsiangkao@linux.alibaba.com>
In-Reply-To: <20240411100039.197417-1-hsiangkao@linux.alibaba.com>
Date: Thu, 11 Apr 2024 11:00:12 -0700
Message-ID: <CAB=BE-S8JrXQ7e22Ja4P_hZe9dz3Pa0wfd=eA_553LQjDexDhQ@mail.gmail.com>
Subject: Re: [PATCH] erofs-utils: lib: fix tarerofs 32-bit overflows
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

Looks good.

Reviewed-by: Sandeep Dhavale <dhavale@google.com>

Thanks,
Sandeep.
