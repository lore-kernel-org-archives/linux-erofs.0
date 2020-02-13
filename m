Return-Path: <SRS0=9oqF=4B=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18AC1C2BA83
	for <linux-erofs@archiver.kernel.org>; Thu, 13 Feb 2020 16:19:34 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C641F206ED
	for <linux-erofs@archiver.kernel.org>; Thu, 13 Feb 2020 16:19:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C641F206ED
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=os.inf.tu-dresden.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from lists.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 48JMCl0L3GzDqRc
	for <linux-erofs@archiver.kernel.org>; Fri, 14 Feb 2020 03:19:31 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record)
 smtp.mailfrom=os.inf.tu-dresden.de (client-ip=141.76.48.99;
 helo=os.inf.tu-dresden.de; envelope-from=mplaneta@os.inf.tu-dresden.de;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none)
 header.from=os.inf.tu-dresden.de
Received: from os.inf.tu-dresden.de (os.inf.tu-dresden.de [141.76.48.99])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 48JMCZ5VgXzDqRZ
 for <linux-erofs@lists.ozlabs.org>; Fri, 14 Feb 2020 03:19:21 +1100 (AEDT)
Received: from [2002:8d4c:3001:48::120:84]
 by os.inf.tu-dresden.de with esmtpsa (TLS1.3:TLS_AES_128_GCM_SHA256:128) (Exim
 4.93.0.3) id 1j2HCw-0004Br-Lm; Thu, 13 Feb 2020 17:19:18 +0100
Subject: Re: Remove WQ_CPU_INTENSIVE flag from unbound wq's
To: Mike Snitzer <snitzer@redhat.com>
References: <20200213141823.2174236-1-mplaneta@os.inf.tu-dresden.de>
 <20200213153645.GA11313@redhat.com>
From: Maksym Planeta <mplaneta@os.inf.tu-dresden.de>
Message-ID: <82715589-8b59-5cfd-a32f-1e57871327fe@os.inf.tu-dresden.de>
Date: Thu, 13 Feb 2020 17:19:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200213153645.GA11313@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
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
Cc: Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, Zhou Wang <wangzhou1@hisilicon.com>,
 linux-crypto@vger.kernel.org, Gao Xiang <xiang@kernel.org>,
 linux-erofs@lists.ozlabs.org, "David S. Miller" <davem@davemloft.net>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 13/02/2020 16:36, Mike Snitzer wrote:
> On Thu, Feb 13 2020 at  9:18am -0500,
> Maksym Planeta <mplaneta@os.inf.tu-dresden.de> wrote:
> 
>> The documentation [1] says that WQ_CPU_INTENSIVE is "meaningless" for
>> unbound wq. I remove this flag from places where unbound queue is
>> allocated. This is supposed to improve code readability.
>>
>> 1. https://www.kernel.org/doc/html/latest/core-api/workqueue.html#flags
>>
>> Signed-off-by: Maksym Planeta <mplaneta@os.inf.tu-dresden.de>
> 
> What the Documentation says aside, have you cross referenced with the
> code?  And/or have you done benchmarks to verify no changes?
> 

It seems so from the code. Although, I'm not 100% confident. I did not 
run benchmarks, instead I relied that on the assumption that 
documentation is correct.

> Thanks,
> Mike
> 

-- 
Regards,
Maksym Planeta
