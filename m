Return-Path: <linux-erofs+bounces-3995-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1710C531F7
	for <linux-erofs@archiver.kernel.org>; Thu, 23 Jul 2026 15:11:57 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h5ZND17cBz2yhD;
	Fri, 24 Jul 2026 01:11:56 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::636"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784819516;
	cv=none; b=GoRGItUU0oi54p0lwf4HyzfLc+AX0L9yircBstyJ/D1rOG25QK2eYXqd1GDoMMpg/HT6VjB7ue8VkDvEavYMPQ1aU7KVf/Eid9KZekAghNAqUN9vGZ9muSYsxN243Hwq+WTJG/RhxSVjn4DTBt1F9sqE5jLvxgRjq9USgDTa5R+rK0bChZGQSxBpjhjmPK9y58QpJw25X44jZqbOjm6KUaJdQesArMQTcmmuE/BK0Uva91XeIfxOxA6lXM+LhiffJhv7ZTR8gfkpOiYaU+bGWVQPUs9unV2jEgK28ER2XXV5Tcc2jwy1lSLfPuE/bXb7aAq54x2+x8d4Y/v+Yanqjg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784819516; c=relaxed/relaxed;
	bh=zDE3Y2Bzew64lctNZMYs5GdvBzJQ9z2sKXS6xw4+mlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:Message-ID; b=Zi0tpU7wm5h5Pl/zgbDjFu51QL6/FAaP1FO/LwB3cGv7kF50QrbL3e5b7D5B6MyFvXbVG4pHVpear9yiQbcfXdc5OqZPXeRrQ68jIopHolK8PXN1KdTKSvoAZLa5WUAPJH+ODCR7dr1D+B7TtSBe2pb5knj3atg5MxXUrTawe6nRQZvpwjcjtLqYf2EC9QIi1HneWUXJ59E6wdF/FNvmQMfwyCSOayxLqCzyvNA9GBGc/5Qtf+uC0jGIx4brh0Lw0BuFhTtIbaPEyfOwXWx372yeMz7ZZkGJM7KkOgRhZS+irJG9YHrVLXca61bBPEuevUQAScZtVaJHMfYI/n7iig==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=daJ+2o5K; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::636; helo=mail-pl1-x636.google.com; envelope-from=lihb2113@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=daJ+2o5K;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::636; helo=mail-pl1-x636.google.com; envelope-from=lihb2113@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h5ZNB57n4z2ygt
	for <linux-erofs@lists.ozlabs.org>; Fri, 24 Jul 2026 01:11:54 +1000 (AEST)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-2cacf197759so11679665ad.2
        for <linux-erofs@lists.ozlabs.org>; Thu, 23 Jul 2026 08:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784819511; x=1785424311; darn=lists.ozlabs.org;
        h=message-id:references:in-reply-to:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zDE3Y2Bzew64lctNZMYs5GdvBzJQ9z2sKXS6xw4+mlo=;
        b=daJ+2o5KnaFWnakyNA9Jkq5oK52hnjBdW6YX3TuS2zMliRiJgsN2GGMuRkdQ7cpJZA
         9z+mcZRBfpWE4AgW//2+c0Sw6P1N5ybodJkSklGVT4sExPcc5bX89RPdD8JH/sO923uP
         T/jIit8sgkROgVuCbAGII+EPZJs4dPR+TjOLNz3cdwdPMG9s7UtxsQSr4x1alXun4Gsk
         8SBhTrx1y7tpNZpzypZ2wULNh2Xznj91FrB2rriga+F4HMKQq6tjCPNn5Q++j9IgFrbe
         FMrr5ImdEQby0rtBrYGnN1PxpgRuRIeK9z068Dk8q5Wnz8sKZ7iPb0sFY4in/+8FhUOS
         1Qxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784819511; x=1785424311;
        h=message-id:references:in-reply-to:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zDE3Y2Bzew64lctNZMYs5GdvBzJQ9z2sKXS6xw4+mlo=;
        b=m7mU3gOmePL6dQL3OEUa/Ka5H8gjg1scr9jmOHY60WUSDBlaEq6PDnwPJifAGA7AhL
         5n0UTJiO2c8mBALsFzAc3TWsjOKdntxKULeVrflTX4b/WoHoBVcefA0O3NqKCk7hzJiB
         MUrafF6YHCPHffO3/wOLg8FVup2WJKBNyhJHy6+2iJi44THhAhiPk9iRMmTJKUSCswvr
         Vm6tmQEfiIaUyYSNnJdaoP//msWCm5neFaX1OYPchbHppYlz2NTkNGKuwma6PEfDNnPC
         YS1teNzKAZ+tGhT1Ueq5hw/ENfCtILVJKupY2DRvi/bXrsNqh23tLYhpxbFcgb+OSQ7i
         oi5w==
X-Gm-Message-State: AOJu0YwTNdLbUu6EDXSGS15Ws+OlZcH6kpxXJnS/ufCHEbQa+Kerm22o
	BiFebgsZq2KmBPj1PYmMFcVionF+ARwkTVvc3Lk5nAFYkA1tD22DzTNyZH2D39OQcSM=
X-Gm-Gg: AR+sD11uR6oz9As4q+ERywX+lKdLdnEMVST5vBHp95x3bcQYDJDxBOIohEaFpxO9DDu
	kuqZMIQsWx0+EWqoAb76oXsVltJTUWglrsVs3krQd3BEsglYT/vuNgkvzAtZ6CHBIbEHIQGvzYE
	OHpjzoLXtWoc88PpdDOnuk8d4tITo2Br9zHkr1ia0Hi0zMurqGBG0JhXgs6rG2MygsSAZvyP9FI
	G5xdxsdsIRh/tCpKGhjPbWroxw731L6EpEiC6miy3e8BFYx2DKcYXpgPlPlddYn6MOpMRuZEfI4
	44+bKXUINt5mzx+8znoPF/9U03ve4i8Vbf5HBstwCQdLcjFAlR7H3Ggdaz1wG0Qldl3idn4/a5N
	E9+8/KIBmPjry/SRdop5NKl9SGGrOxE0NK0HPH0LltlKkkBKm2NG7t0oPZYVYYaN7lQy2GJRlv/
	lX6TxsmjGtYa3wsRs=
X-Received: by 2002:a17:903:37c5:b0:2ca:5d9a:ecc6 with SMTP id d9443c01a7336-2cfa7488a25mr42375255ad.28.1784819511164;
        Thu, 23 Jul 2026 08:11:51 -0700 (PDT)
Received: from localhost ([14.22.11.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfa57542e0sm17303385ad.67.2026.07.23.08.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 08:11:50 -0700 (PDT)
From: Hongbo Li <lihb2113@gmail.com>
To: Gao Xiang <xiang@kernel.org>
Cc: linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] erofs: ensure valid f_path for page cache sharing
Date: Thu, 23 Jul 2026 23:07:51 +0800
In-Reply-To: <20260723050313.2273-1-xiang@kernel.org>
References: <20260723050313.2273-1-xiang@kernel.org>
Message-ID: <ack-real-5ce6a38b7e5c-lihb2113@gmail.com>
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

Acked-by: Hongbo Li <hongbohbli@tencent.com>

Thanks,
Hongbo

