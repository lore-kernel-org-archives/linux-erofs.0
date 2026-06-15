Return-Path: <linux-erofs+bounces-3588-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2046CD8CA8
	for <linux-erofs@archiver.kernel.org>; Mon, 15 Jun 2026 02:45:22 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gdvcK2Njrz3bqD;
	Mon, 15 Jun 2026 12:45:21 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::631"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781491521;
	cv=none; b=gCUfANoqTTD+xMrHZbRsAvnD0Mc/wp6SpYgQin+Wtgvl2m4E6P9tjPiQW1x4SkKdMphEzipcQvrb+qgk60nHedhyGLelSu0/D8CPbpwfQYFN3Xs2njEfotPcWthBR5wLoSXvDSad44MwEbJt+d2WJL0qDHq8VdHCWwZdXD6hpWlREXfADwtG4PM5UYIWCWcSjvaMDIb9Qrz0nm33KX85o1/7LtJD7rC/0jOrNnngmlEk3Lnb2Wgbauxn89FLp8gj91malBaYrzORl5QqHdOi2j7dNJ7WvfABVbB5t6rLa4SZ8WPluMx16jS5pE47SIdkz08p/jBtCNzXoKg+G6rokg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781491521; c=relaxed/relaxed;
	bh=5vNyzKH84DR1hv4ulYF/RyW72TXwcFWsow16w4/msNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bA+b7nOTPaCOOdIl1hffTAmLjh3y/ANLpFNaOofi6RgqV0gCWdnlQt2RbrVFSJv2yqp1+wXiuBnLJl7n+B621Yx84pQBy16NECfLH+YAzaS2GNG8toKpGVWDQYew+RMNDWW7VDzZWdXuxF4fUkB+Scv79pBPuTU/S20XwsWQs30vPpx09xjKYsZviqfCBQ6wLyvD8Dq5PY932UiRl9Uh3KRnlBsZTE009oc9XE/yoHWV1ZVhQ/50dIZAJh2VUyUtoKx2jAtOAJpKTjzI4V1pyOEj+2xdXWQRljAvr4P2QKiRpguL5dvwLt7Y7wstRywbGWspXEIv7VpKvsUhX9Z/AQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=UTOuIjcc; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::631; helo=mail-pl1-x631.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=UTOuIjcc;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::631; helo=mail-pl1-x631.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gdvcJ3tXPz2yT0
	for <linux-erofs@lists.ozlabs.org>; Mon, 15 Jun 2026 12:45:20 +1000 (AEST)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-2bf30d530bdso28590515ad.3
        for <linux-erofs@lists.ozlabs.org>; Sun, 14 Jun 2026 19:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781491518; x=1782096318; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5vNyzKH84DR1hv4ulYF/RyW72TXwcFWsow16w4/msNI=;
        b=UTOuIjcch51HgqnN4047mLLHqi1OeAg+ZPzSfFdlOwsRqKGNBBybSixFLFzcNolHJQ
         gXipAXi+6ak8Pk7X3ciQ82VDLFSwLlafAypgK1QxZL13c6CUeZb3tjh2f8jbEElPGRB4
         5J+/xsoDXgtmIiuGpHPmsRmIt2MtHK3pjLb5cdOhawfywZ5w5dzYbGLvDQ3XkxLgdfdk
         FERZGaUScLDwu0cwNKM13pcBKJjU63VbNzAhELWW/tVhroK8o9YIgGYmsoAivpicL/TV
         5pZdc9twfHpkdEQcruEvmDKBwe42qVxve3N71n3iiEnbj7WjpLNVHvJltVAJKx+H++k4
         TH1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781491518; x=1782096318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5vNyzKH84DR1hv4ulYF/RyW72TXwcFWsow16w4/msNI=;
        b=R8EU0iG5US6oQbXjOFgXl1kT4mU8pfyXQLR0NsIXx56/AOXcJ6Q+flxTfvEdwhznZy
         9r742Ws3zOXCBPUYFHNTp8bUGWh+XuOfD5aEPPx2FV0KKAwEZIjXXcKhX/y8+93Zp3JC
         KurWy8JoR4uQlnOMiPZEYTgc17MDZms/7owd15rdIemJ6xHT70b1X4yppI6uXBDWTOo3
         o7pzGnKSZhcQPJC69lDq/w0X5gwgFbhucp/PfgEiSWpxgdDX9paKbsN6XmmrOAYkNo2v
         MgnfnFExIOnmXwUnM6JteF2EDWOmUdoYoB3GHvZM5Z0weJhsMNB51wpcmHzQF/SaLskD
         S9Qg==
X-Gm-Message-State: AOJu0YwOgziiwJO1etgFWI6KhAi389jYhFwee0iDzAL/Vj+S+7l9BHjp
	PWYxUitWR5X1DHMnzaxO77be4KKFMci0RZTd/gwwVCRHXq82jYclXqOd
X-Gm-Gg: Acq92OEbwVPdXVwwCSLEjtnXMn3rIkQs6Hp6KMsAQZgvVeWtj974TxVG3+IWR5ArkXL
	vARbprlDVjh5F1Abg+bfVTJG4Ul9h7bGdQWcW8gA7UIvVCbM0Z1bI+KHtZPZ3d0mA21nwu3kqNn
	EFgOgVHbnBn5hHM9SDsFp1ZNoM5wQDbFZgYRB/adNge7Ct8xw/RIfqdeKjvMmEAYGgMvM8liKQH
	jajKeQTX0l5GsWHFTWEiCOr95OKMLNvJYF23ssa6DpyHJ4AcW818bKmw4GdLVeGkOxEvbqoUlTs
	cpoJMBuIXt5xTO6UISFFzMeWu5XEw6CPeL8BChmDxJVXYSoGZOkm9SCg3Cyqph+cIdgJUUCjfZH
	j2Hz9aQsHbcfop6u7gr41a1XE3eUWhUA4NbCaPW0h9/TRH/Xb3SZweZxq5ZTjCSkDoqZwZZMoB5
	PDuXHMiYF1DCWBfFJviSs2ckP2PqVW81IUI6xatIzV8XAtwQIuAmYspf8=
X-Received: by 2002:a17:902:ce8c:b0:2c0:db23:4c1 with SMTP id d9443c01a7336-2c66419882fmr104261815ad.5.1781491518518;
        Sun, 14 Jun 2026 19:45:18 -0700 (PDT)
Received: from localhost.localdomain ([157.15.11.68])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c4328a4c14sm79691065ad.43.2026.06.14.19.45.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 14 Jun 2026 19:45:18 -0700 (PDT)
From: Nithurshen <nithurshen.dev@gmail.com>
To: hsiangkao@linux.alibaba.com
Cc: linux-erofs@lists.ozlabs.org,
	nithurshen.dev@gmail.com,
	xiang@kernel.org
Subject: Re: [PATCH v1] fsck.erofs: implement thread-safe global LRU metadata cache
Date: Mon, 15 Jun 2026 08:15:12 +0530
Message-ID: <20260615024512.94930-1-nithurshen.dev@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <555d6eec-7ddf-451e-98a3-70f7612a98c6@linux.alibaba.com>
References: <555d6eec-7ddf-451e-98a3-70f7612a98c6@linux.alibaba.com>
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
Content-Transfer-Encoding: 8bit

Hi Xiang,

Understood. I will drop the userspace metadata caching patches for now, 
as it is not the current priority.

I will shift my focus entirely to the concurrent directory traversal 
patch (Phase 3) that I submitted recently. Please let me know your 
thoughts on this.

Thanks,
Nithurshen

