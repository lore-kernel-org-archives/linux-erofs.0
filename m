Return-Path: <SRS0=Ce2X=ZG=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2086C432C3
	for <linux-erofs@archiver.kernel.org>; Thu, 14 Nov 2019 15:28:13 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 72502206F0
	for <linux-erofs@archiver.kernel.org>; Thu, 14 Nov 2019 15:28:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d0KBTDZC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 72502206F0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from lists.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 47DQNV6WlSzF6fm
	for <linux-erofs@archiver.kernel.org>; Fri, 15 Nov 2019 02:28:10 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::441;
 helo=mail-pf1-x441.google.com; envelope-from=blucerlee@gmail.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=gmail.com header.i=@gmail.com header.b="d0KBTDZC"; 
 dkim-atps=neutral
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com
 [IPv6:2607:f8b0:4864:20::441])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 47DQNJ4MTbzF63x
 for <linux-erofs@lists.ozlabs.org>; Fri, 15 Nov 2019 02:28:00 +1100 (AEDT)
Received: by mail-pf1-x441.google.com with SMTP id c184so4484161pfb.0
 for <linux-erofs@lists.ozlabs.org>; Thu, 14 Nov 2019 07:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=eQ5NlmZc0+4Ql6LI7faoT8RFjtRl5wqRZSwjNxpaK4g=;
 b=d0KBTDZC5wjjuubtxia4VLq/MhsHR09UPi7ywHpCSpiJtRiZ6CB0ZLCVIHvSrSoh7K
 lhIdwJqao67BpM1TzelQTNFwt/tPL8iwCeno2tjtEJMiO3fYDhB88YKvvUO9ImnKBy7F
 T08JE2+dcnKzjuSXsCgfZ53lL8U0uOjhKk+Vxr6ZqlbgyGUvkjecCxDKmhNW6g2osYWj
 Akd3UWnBHHB2wCNfyvNkGFj13qjj1+rmxkveoAWHe36X2MszRtpnuPjvnJwawpyWrpCd
 N9fj7B0Ktag7ZKR8spt/6AAPMarvx3HOiQkmdVIZi4qzjNNDIDAmTpKMB+2xaQRydaBW
 qHOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=eQ5NlmZc0+4Ql6LI7faoT8RFjtRl5wqRZSwjNxpaK4g=;
 b=BL4iktm/Tgr0fdMTawEEwwgmeP0cq90H+g7V3HwUFQ8WaGcP04R2NQuOlTO5JJQeQR
 3cLph7k8gc9VRDpqHNAlMaXSXYUU6uLPZv8Grk+xIaHTADZZVROX4tAzFcgDX0DJHfgM
 0huFlu/eNhi3wbzS4VK2uO+LcupOjjmffsT6A6aTSWMl8oIWSlJ472opmzQxjpPljEZe
 ICLQF5oy8OBE6/mNFt4u7qPNDHByUGZ/wTKBJSfn/06g750sXosjAFktkNmmORnKeAlY
 EJPH4iJLpLsC16ggVyIEJgsiRY14ZZErTIUFOlKIUXi3d3VXerBZRPOIt1zHifGHcLjh
 HBhA==
X-Gm-Message-State: APjAAAXi2eLfWTAHNtnzXZjDWIRQb/6yPwSu3KGDm9d/gM/5Wr8hjOyW
 kqjruWTOfrkl4X9t5tGsZCk=
X-Google-Smtp-Source: APXvYqxa4cg/LIg0AWPaj/a+2Qtb74sZmIdB/OPDPxfuGeQNCGswRn78IVHrrtAJuULFz3j193u09g==
X-Received: by 2002:a17:90a:4d8f:: with SMTP id
 m15mr3079742pjh.71.1573745276842; 
 Thu, 14 Nov 2019 07:27:56 -0800 (PST)
Received: from [0.0.0.0] ([167.172.195.219])
 by smtp.gmail.com with ESMTPSA id s24sm7057976pfh.108.2019.11.14.07.27.52
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 14 Nov 2019 07:27:55 -0800 (PST)
Subject: Re: [PATCH v2] erofs-utils: set up all compiler/linker variables
 independently
To: Gao Xiang <hsiangkao@aol.com>, Li Guifu <bluce.liguifu@huawei.com>,
 Chao Yu <yuchao0@huawei.com>, linux-erofs@lists.ozlabs.org
References: <20191114002651.GB2809@hsiangkao-HP-ZHAN-66-Pro-G1>
 <20191114134521.12416-1-hsiangkao@aol.com>
From: Li Guifu <blucerlee@gmail.com>
Message-ID: <87df58bc-29c4-59cd-dc31-f445fd07bba1@gmail.com>
Date: Thu, 14 Nov 2019 23:27:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191114134521.12416-1-hsiangkao@aol.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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
Cc: Miao Xie <miaoxie@huawei.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2019/11/14 21:45, Gao Xiang wrote:
> Otherwise, the following checking will be effected
> and it can cause unexpected behavior on configuring.
> 
> Founded by the upcoming XZ algorithm patches.
> 
> Signed-off-by: Gao Xiang <hsiangkao@aol.com>
> ---

It looks good
Reviewed-by: Li Guifu <blucerlee@gmail.com>
Tested-by: Li Guifu <blucerlee@gmail.com>

Thanks,
