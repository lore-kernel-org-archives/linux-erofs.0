Return-Path: <linux-erofs+bounces-1867-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB157D37E3D
	for <linux-erofs@archiver.kernel.org>; Wed, 14 Jan 2026 14:54:03 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4drpzG1Dzgz2xT4;
	Thu, 15 Jan 2026 01:54:02 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1768402442;
	cv=none; b=Hx1g8XdPyJylzh+/aOIivJDDrHZezmAWkKjZTrtfwp4YaEO+u6VJxLVji1mUAOH0aY8lZ3N7z3Cc4UZxMrItS889EFI5MmR3jT57fW4dD3BBd4dK8ZD/zpw50OgUi5gc10MT4paSKYt9AJDdkZnbOLvpqk/s7546qXFgXr1wlnIBPDXhOPoG/nsU27NC/1r0zX0UlGdvxKmfxz9dwv/46xWnFZirfyz0OBerwjRStquKvy2Hd4WQOdS0Aa/AcgdVhjZI3Yz+zC1KVC/GgEaplezHXLuR1oW5DN3LIBQthXP98Ok/SBhAf3x/Fw6shFqIadUvxxwNJ2i6rUbRdewhqw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1768402442; c=relaxed/relaxed;
	bh=NBHzWnw/Bz1netRes1MD8Dx3Xm+VZaSz/9OEB/xBLNA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YEROpWFIfZVRGuXc9NJYWiXeBzNJABKSkeXy2/YeRLpsPdgDeLHJVgtUZR9pOrO0lpi2UdC2FGPiTgXU24OIYjx2bvcSPXwa0rNLOrOnOtUG7lFBI2CAQBON1pZIGlnjZb2dil7buIsW6x5WurlcVivxByX2U2ARB8TeVrXt+UB4ZMVygTmv1+7HE8b7Z++6Qvmb0v/2V8X2da6qAQxXvBxB/viBstzmjup3T5HMDCUW3jFTgI2NfkwMcm8vaHi2vSDXrSe8gJXaXMSQjUxmEIH5geoWo+djgLHZ9TTNcFU5X2U0TD27/pViUDMZLw0sXrIcF+tDoB5JvZj+DNWKFg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=qWOSCumL; dkim-atps=neutral; spf=pass (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=qWOSCumL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4drpzF0bXrz2xNg
	for <linux-erofs@lists.ozlabs.org>; Thu, 15 Jan 2026 01:54:00 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768402434; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=NBHzWnw/Bz1netRes1MD8Dx3Xm+VZaSz/9OEB/xBLNA=;
	b=qWOSCumLa86qUI/jd8jcVLFMRe+ni0W9+klAbBAH0UMaglvT/Pke6zsGSi+d6HSZ72gfassk3HINXyzRTMniIXGLUcVq94aa9DvyvWF3Am1Ac3XBRs8+scgUEHok/+3pKJ14QjO539qWaU1PFox8WVe3sIoNSMUWPX8py2NipMk=
Received: from 30.180.182.138(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wx2jwhk_1768402432 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 14 Jan 2026 22:53:53 +0800
Message-ID: <615134f7-fcfd-44d0-b895-dd5a4901ea7b@linux.alibaba.com>
Date: Wed, 14 Jan 2026 22:53:52 +0800
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
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 09/10] erofs: support compressed inodes for page cache
 share
To: Hongbo Li <lihongbo22@huawei.com>
Cc: djwong@kernel.org, amir73il@gmail.com, hch@lst.de,
 linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
 Christian Brauner <brauner@kernel.org>
References: <20260109102856.598531-1-lihongbo22@huawei.com>
 <20260109102856.598531-10-lihongbo22@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260109102856.598531-10-lihongbo22@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/1/9 18:28, Hongbo Li wrote:
> From: Hongzhen Luo <hongzhen@linux.alibaba.com>
> 
> This patch adds page cache sharing functionality for compressed inodes.
> 
> Signed-off-by: Hongzhen Luo <hongzhen@linux.alibaba.com>
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

