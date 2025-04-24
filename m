Return-Path: <linux-erofs+bounces-230-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD1B1C369AB
	for <linux-erofs@archiver.kernel.org>; Thu, 24 Apr 2025 12:02:30 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Zjvjd2Hwmz3bqQ;
	Thu, 24 Apr 2025 22:02:29 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.118
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1745496149;
	cv=none; b=cXjCCA8jA6CUAUBtiwP0Vm0yzwkifXkVhExVi0sRj//VuqQMXi2uDqSVtQwWk3LlTbWZAukVrpHWqSdNGw0KSSbR2XcO5RbtlDb2suQ+t+yo1Q26CJfhp3vxiMtQ2ToEwjY1zjBU7b0gDTwM6bDysPlRib2RVU5l1Ae0XsLAH31bbyZKKhEn+dZGoP/tXdmym4w7MpoznBrwZWOQag90PdHT28ILECrxurToA0IDUeke00yBhhQ5TlYyV2hWGug9Jjc55Cyr8zuqp46AuFLgZsxDdH+m/sWcpPcRChtGsrRdl7TxuxP9121SLoUshDRbVZtMyj1ZXEpcYpcPQE0Jnw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1745496149; c=relaxed/relaxed;
	bh=gkOUV6sGAuQr29EThkOThv0b6KbqR66Yzqjl3hHT0Ss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hg95/1Anqr1eyaVRiwA9qk+hf8YWcajmmyOrSB9i2jqMyS3MNaobshwbKMOOrcT8iPsEZdLxWIq1qsy0EMG9saoixGXrrCHqCJFbuer2FouSwkDZYuCMv3PcXMHdRdq2hWGsv9YrD7HKG3hD+TpmFK2Sl+ioQZ5F+aQevAIfTXfm+GssjUDh0y4g6zYipTYypVhr4XYUFeBj2AOIdLQRrkZqic0G0R1YrvIv7FTyyXwr1hjmvSTtn+2nwB4QgDAJ+LMA+Xu8D4IGfYqy4to/I4oRcnvsMROEfVtSHgmm5Hk3GyPnIunK/Ukm7tzPb+2bv6jRA4MWH6O9GoImLHPMPQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=KSu2zW6l; dkim-atps=neutral; spf=pass (client-ip=115.124.30.118; helo=out30-118.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=KSu2zW6l;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.118; helo=out30-118.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Zjvjc3S2Gz3bnL
	for <linux-erofs@lists.ozlabs.org>; Thu, 24 Apr 2025 22:02:28 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1745496143; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gkOUV6sGAuQr29EThkOThv0b6KbqR66Yzqjl3hHT0Ss=;
	b=KSu2zW6lhKEpgMFaKAFic1+cKnzfGp3GUlvegBX9WfXRuue/QlTqGL2NYVCkExpx+SZUhb4VyBW8P6CcRNSi2JNgBlLxwgae6mHcYtmZ76Mw7Bfvz3XnFvU+FUAVGZDL5GBtPHQ2nTfd9rap7uohn7g7qyo+4M3ISqmB6LVAVTQ=
Received: from 30.134.100.0(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WXzKPyD_1745496140 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 24 Apr 2025 20:02:20 +0800
Message-ID: <b286966f-abf3-47a8-85a7-6856784a4c43@linux.alibaba.com>
Date: Thu, 24 Apr 2025 20:02:20 +0800
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] erofs: lazily initialize per-CPU workers and CPU
 hotplug hooks
To: Sandeep Dhavale <dhavale@google.com>
Cc: linux-erofs@lists.ozlabs.org, Gao Xiang <xiang@kernel.org>,
 Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
 Jeffle Xu <jefflexu@linux.alibaba.com>, kernel-team@android.com,
 linux-kernel@vger.kernel.org
References: <20250423061023.131354-1-dhavale@google.com>
 <94c702b9-cad5-4727-a7f1-16de1827841e@linux.alibaba.com>
 <CAB=BE-SwcvC0sDXAVoK+C9V8Ags+1VanWY_n1hgg8k+UmKH+0A@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAB=BE-SwcvC0sDXAVoK+C9V8Ags+1VanWY_n1hgg8k+UmKH+0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2025/4/24 14:04, Sandeep Dhavale wrote:
>> I could fix up this part manually if you don't have strong
>> opinion on this.
>>
> 
> Hi Gao,
> I don't have any objection to styling as it is subjective. I am ok
> with the fixup.

Ok, thanks for the confirmation!

Thanks,
Gao Xiang

