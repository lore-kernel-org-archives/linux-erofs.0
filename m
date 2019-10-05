Return-Path: <SRS0=H4Ti=X6=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FD45C47404
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Oct 2019 16:44:59 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D23DD22475
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Oct 2019 16:44:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ukMYt/GR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D23DD22475
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46lszX6dpVzDqZk
	for <linux-erofs@archiver.kernel.org>; Sun,  6 Oct 2019 03:44:56 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
 spf=pass (mailfrom) smtp.mailfrom=gmail.com
 (client-ip=2607:f8b0:4864:20::543; helo=mail-pg1-x543.google.com;
 envelope-from=blucerlee@gmail.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=gmail.com header.i=@gmail.com header.b="ukMYt/GR"; 
 dkim-atps=neutral
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com
 [IPv6:2607:f8b0:4864:20::543])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46lszP5qXfzDqLJ
 for <linux-erofs@lists.ozlabs.org>; Sun,  6 Oct 2019 03:44:49 +1100 (AEDT)
Received: by mail-pg1-x543.google.com with SMTP id q1so5569253pgb.0
 for <linux-erofs@lists.ozlabs.org>; Sat, 05 Oct 2019 09:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-transfer-encoding;
 bh=YlGsw/b6ARxs4oMJpLn4hSeNoyDZyLPumE/A6lzxtqw=;
 b=ukMYt/GRAAdQca6rJ+nGYunxNDe4si83UysK3LjOpwZ+EUnm/CnTsE2WBNX0yr8GCc
 c0UNJbXJEe1EM7RSSgQfKC5+4+4o0tgnjNfH0Hc7ZbpL4r41j6t8YWLgOIB2E9fVIT2v
 fVAh1arkzrlF8KN5yRsEzALtDRnlKrFxONqLbwaDJP/v3xD1URDCjjFYo16bKPbg9rNp
 FD29U/UyWcg1EUdCPjaUQmTw6gAj+M2ymtaf2urLp/aptj9290cuZxre3Iw4VEdvN/mt
 pf0iW1YScEk0igQRdadnlBw2YqLtB9VwQv71dHBRFuw+whuC9EpB510zid5ZPf4Oc2BO
 dMig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-transfer-encoding;
 bh=YlGsw/b6ARxs4oMJpLn4hSeNoyDZyLPumE/A6lzxtqw=;
 b=SzMgdxHK+bNHa3FYc17sIHC6e/Foo4IxX/87h+xTEMfwbCTXz9HCUbpvSM8gYiInzl
 j0Kr+lY02NyRu7RBrfMACDo6k5+YHQ2MN+0QKpBno8zkUdes5bN8NP0PJZ08nUE9wRUd
 eTaooZczLDVDdhoY8w88PMC5PYbrP1CuQ96NMmY9bkME76nfeWlj8iK0wWYzqvuzHCEb
 OE+AFEX+Tj8i50bWdMDuxD4rZQDB+ALMi+DvabUK/uKFHteg28Lwbe7CVnxGSCqDYj+H
 Dk9bFqv5uImKagNdzFuQ1HfaWRo4IF7LpM+SWPqXTryChiiDE5FxI2WwjGjxuDnW72uo
 CFbQ==
X-Gm-Message-State: APjAAAXp6ErAwQlzenG4F7jwNhDYRuuuujjdik0h80qkzAp/v/JzT7e8
 K9KYee1cPYhaKLL2kzFH2kk=
X-Google-Smtp-Source: APXvYqwpsPCcbwh+ItXMpxYqE206EpcWu7gxAnSdOLET3omP756HDxOyhhTGGB/ZC2Pl90zVxi1VZg==
X-Received: by 2002:a17:90b:d97:: with SMTP id
 bg23mr23918720pjb.86.1570293886215; 
 Sat, 05 Oct 2019 09:44:46 -0700 (PDT)
Received: from [0.0.0.0] (li2012-80.members.linode.com. [172.105.119.80])
 by smtp.gmail.com with ESMTPSA id x18sm9864298pge.76.2019.10.05.09.44.41
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Sat, 05 Oct 2019 09:44:45 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] erofs-utils: introduce inline xattr support
To: Gao Xiang <hsiangkao@aol.com>, Li Guifu <bluce.liguifu@huawei.com>,
 Chao Yu <yuchao0@huawei.com>, linux-erofs@lists.ozlabs.org
References: <20190811171049.26111-1-hsiangkao@aol.com>
 <20191005142050.8827-1-hsiangkao@aol.com>
From: Li Guifu <blucerlee@gmail.com>
Message-ID: <7120d450-af94-a165-b612-13788d05d222@gmail.com>
Date: Sun, 6 Oct 2019 00:44:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191005142050.8827-1-hsiangkao@aol.com>
Content-Type: text/plain; charset=utf-8; format=flowed
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
Cc: "htyuxe+dhbrei4sq0df8@grr.la" <htyuxe+dhbrei4sq0df8@grr.la>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

> From: "htyuxe+dhbrei4sq0df8@grr.la" <htyuxe+dhbrei4sq0df8@grr.la>
> 
> Load xattrs from source files and pack them into target image.
> 
> Signed-off-by: htyuxe+dhbrei4sq0df8@grr.la <htyuxe+dhbrei4sq0df8@grr.la>
> Signed-off-by: Li Guifu <blucerlee@gmail.com>
> Signed-off-by: Gao Xiang <hsiangkao@aol.com>
> ---
It looks good
Tested-by: Li Guifu <blucerlee@gmail.com>

Thanks,
