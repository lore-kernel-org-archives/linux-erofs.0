Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9076DCD80D3
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Oct 2023 13:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1696945204;
	bh=HAdo80OiOQp/aaIgDYByIwUiOb4hTmJC0/eMYaZpsCY=;
	h=Date:Subject:To:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=V7Zpy6Rgn6dmnJ/i8Iou/ufKFLpYDYMivVbsg6nEqNJkXCoRyJb73ovZ4fOL3j99u
	 PqF9Gk8a6VYQA/G537JII6Rsof95JUHq8kJvaUj+JnTjjdssHxtv0OrdDz5rMtRDMA
	 GLqbMl467Bba1u+JRW9bHqn+UbeTaGvz8I74FAonnycUL0UTa6M9ZgFLZMH235QVoP
	 IGtJqBkGp01CLySj1C03d2uBuZebbt+HUhSQ0wn3uPDN8zIgNvychcPKTC5Z84kKuj
	 lLRczpSHdCOLc8E6ucQE90fJiPZIarHwGZMpk+AGxZCUS7AkJQ1tCf/7Iw5Cba2oTc
	 syPQuRcCWzaJw==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4S4cTc5Gcdz2yTx
	for <linux-erofs@archiver.kernel.org>; Wed, 11 Oct 2023 00:40:04 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=antgroup.com (client-ip=140.205.0.207; helo=out0-207.mail.aliyun.com; envelope-from=tiwei.btw@antgroup.com; receiver=lists.ozlabs.org)
Received: from out0-207.mail.aliyun.com (out0-207.mail.aliyun.com [140.205.0.207])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4S4cTT1LdCz2yTx
	for <linux-erofs@lists.ozlabs.org>; Wed, 11 Oct 2023 00:39:54 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047199;MF=tiwei.btw@antgroup.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---.Uxbr70Y_1696945180;
Received: from 30.239.222.1(mailfrom:tiwei.btw@antgroup.com fp:SMTPD_---.Uxbr70Y_1696945180)
          by smtp.aliyun-inc.com;
          Tue, 10 Oct 2023 21:39:49 +0800
Message-ID: <78478a20-e617-468c-85e6-105b16e6723b@antgroup.com>
Date: Tue, 10 Oct 2023 21:39:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] erofs: fix inode metadata space layout description in
 documentation
To: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org,
 xiang@kernel.org
References: <20231010113915.436591-1-tiwei.btw@antgroup.com>
 <9a6ccef5-3a35-ae0d-2a9c-1703c5038c81@linux.alibaba.com>
Content-Language: en-US
In-Reply-To: <9a6ccef5-3a35-ae0d-2a9c-1703c5038c81@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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
From: Tiwei Bie via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Tiwei Bie <tiwei.btw@antgroup.com>
Cc: linux-doc@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, ayushranjan@google.com, Yue Hu <huyue2@coolpad.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On 10/10/23 9:06 PM, Gao Xiang wrote:
>> Fixes: fdb0536469cb ("staging: erofs: add document")
> 
> I'm not sure if it's necessary to tag document fixes anyway
> since docs.kernel.org already uses the latest version and
> `.rst` format is adapted much later..
> 
> I will drop this tag for the next merge window if not urgent.

Thanks! This patch is not urgent. :)

Regards,
Tiwei
