Return-Path: <SRS0=ChUK=4H=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41AACC35254
	for <linux-erofs@archiver.kernel.org>; Wed, 19 Feb 2020 20:24:44 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E5B0624654
	for <linux-erofs@archiver.kernel.org>; Wed, 19 Feb 2020 20:24:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="PoUTRdSy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5B0624654
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from lists.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 48N8Ms6BpkzDqS8
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Feb 2020 07:24:41 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=nvidia.com (client-ip=216.228.121.143;
 helo=hqnvemgate24.nvidia.com; envelope-from=jhubbard@nvidia.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=nvidia.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=nvidia.com header.i=@nvidia.com header.a=rsa-sha256
 header.s=n1 header.b=PoUTRdSy; dkim-atps=neutral
Received: from hqnvemgate24.nvidia.com (hqnvemgate24.nvidia.com
 [216.228.121.143])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 48N8Mj6HcWzDqJM
 for <linux-erofs@lists.ozlabs.org>; Thu, 20 Feb 2020 07:24:32 +1100 (AEDT)
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by
 hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
 id <B5e4d99340000>; Wed, 19 Feb 2020 12:23:16 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
 by hqpgpgate101.nvidia.com (PGP Universal service);
 Wed, 19 Feb 2020 12:24:27 -0800
X-PGP-Universal: processed;
 by hqpgpgate101.nvidia.com on Wed, 19 Feb 2020 12:24:27 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 19 Feb
 2020 20:24:27 +0000
Subject: Re: [PATCH v6 07/19] mm: Put readahead pages in cache earlier
To: Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
 <20200217184613.19668-12-willy@infradead.org>
 <e3671faa-dfb3-ceba-3120-a445b2982a95@nvidia.com>
 <20200219144117.GP24185@bombadil.infradead.org>
 <20200219145246.GA29869@infradead.org>
 <20200219150103.GQ24185@bombadil.infradead.org>
From: John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <a5f8ba4c-8413-2633-9523-5b5941c0762b@nvidia.com>
Date: Wed, 19 Feb 2020 12:24:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200219150103.GQ24185@bombadil.infradead.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
 t=1582143796; bh=Stnn+zSSGNCFbZ988J4GuiCkm17Qbq44jVcYhuJTWJc=;
 h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
 Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
 X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
 Content-Transfer-Encoding;
 b=PoUTRdSyZJ3hX2dxzQISosJ/wVYoveMKl+7atg1sDrOWdAAaYMtdVxq7QyYHhh7xe
 EvTmBI7/rq4HLGscXS8LPXNBnQ1Jix4flhNHGsxk201kSI8sMpgUmQGRpk7I9BpUhS
 +KjQiwXIyu9koQoSyGAly8ElawI2qpwAoJWQDFM4pVRo/Z9yKmG/dGB+jg0mlia4Y2
 aAY4dZzfwP+DRcHOuBWJl3IdIgHWxdpwgzTmZEfGVW+WOZbqKq5bU129bePvvI5bU1
 dYKswZNLebiNLPAg01grHG4u36LomMBF2QsjP/hPLPNASaXyUhQMXbUJhq2V3Ktwp6
 cwNUY5UNidflg==
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
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
 linux-mm@kvack.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-btrfs@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On 2/19/20 7:01 AM, Matthew Wilcox wrote:
> On Wed, Feb 19, 2020 at 06:52:46AM -0800, Christoph Hellwig wrote:
>> On Wed, Feb 19, 2020 at 06:41:17AM -0800, Matthew Wilcox wrote:
>>> #define readahead_for_each(rac, page)                                   \
>>>         while ((page = readahead_page(rac)))
>>>
>>> No more readahead_next() to forget to add to filesystems which don't use
>>> the readahead_for_each() iterator.  Ahem.


Yes, this looks very clean. And less error-prone, which I definitely
appreciate too. :)


>>
>> And then kill readahead_for_each and open code the above to make it
>> even more obvious?
> 
> Makes sense.
> 

Great!


thanks,
-- 
John Hubbard
NVIDIA
