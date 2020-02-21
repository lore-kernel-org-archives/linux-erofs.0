Return-Path: <SRS0=b6sO=4J=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 093DCC3565B
	for <linux-erofs@archiver.kernel.org>; Fri, 21 Feb 2020 19:44:50 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AE52924653
	for <linux-erofs@archiver.kernel.org>; Fri, 21 Feb 2020 19:44:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="lYdo4NH8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE52924653
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from lists.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 48PMNv5XpzzDqgj
	for <linux-erofs@archiver.kernel.org>; Sat, 22 Feb 2020 06:44:47 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=nvidia.com (client-ip=216.228.121.65;
 helo=hqnvemgate26.nvidia.com; envelope-from=jhubbard@nvidia.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=nvidia.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=nvidia.com header.i=@nvidia.com header.a=rsa-sha256
 header.s=n1 header.b=lYdo4NH8; dkim-atps=neutral
Received: from hqnvemgate26.nvidia.com (hqnvemgate26.nvidia.com
 [216.228.121.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 48PMNk1k3HzDqdj
 for <linux-erofs@lists.ozlabs.org>; Sat, 22 Feb 2020 06:44:37 +1100 (AEDT)
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by
 hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
 id <B5e5033120000>; Fri, 21 Feb 2020 11:44:18 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
 by hqpgpgate101.nvidia.com (PGP Universal service);
 Fri, 21 Feb 2020 11:44:32 -0800
X-PGP-Universal: processed;
 by hqpgpgate101.nvidia.com on Fri, 21 Feb 2020 11:44:32 -0800
Received: from [10.2.166.200] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 21 Feb
 2020 19:44:32 +0000
Subject: Re: [PATCH v7 11/24] mm: Move end_index check out of readahead loop
To: Matthew Wilcox <willy@infradead.org>
References: <20200219210103.32400-1-willy@infradead.org>
 <20200219210103.32400-12-willy@infradead.org>
 <e6ef2075-b849-299e-0f11-c6ee82b0a3c7@nvidia.com>
 <20200221153537.GE24185@bombadil.infradead.org>
From: John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <1fd052ce-cd5e-60ce-e494-cbf6427d3ed3@nvidia.com>
Date: Fri, 21 Feb 2020 11:41:28 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200221153537.GE24185@bombadil.infradead.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
 t=1582314258; bh=pQKOwwEmNmp5lZ+eX1Ols5QNnW+OORTLQJDMCsPxtEc=;
 h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
 Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
 X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
 Content-Transfer-Encoding;
 b=lYdo4NH8M7SXphPat6doJg0oOA1V6kLXukQ7JIEh5FVkfFb0/CxKOhHQdMiRNYy87
 Q6EhPR2Fph1xqpiZaGm+fIV8Ra4pJE8E5H2Ofj6LlTy0+Qb+/+y64EhZcbjIYXrOqI
 IXR7s2kX4Yi3hnWXNuj2sU2+Joh83jXJxvw8pHXSeKQS/7ccswnLmpLkros2lxWTg/
 2U8B/Ar6NYNMOQFqfCj3j5XpjUwSHVdi0BMHCh2YVMnazsUm42RddLEt+ZRAKHCaXa
 IlYO+1WyQ2QxlFvwnZy2R5xtgMwusy7sT9ZlwHQi2bqndUATGT9KLiH14aMZETjP0i
 ow4Jt857PEIiA==
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

On 2/21/20 7:35 AM, Matthew Wilcox wrote:
> On Thu, Feb 20, 2020 at 07:50:39PM -0800, John Hubbard wrote:
>> This tiny patch made me pause, because I wasn't sure at first of the exact
>> intent of the lines above. Once I worked it out, it seemed like it might
>> be helpful (or overkill??) to add a few hints for the reader, especially since
>> there are no hints in the function's (minimal) documentation header. What
>> do you think of this?
>>
>> 	/*
>> 	 * If we can't read *any* pages without going past the inodes's isize
>> 	 * limit, give up entirely:
>> 	 */
>> 	if (index > end_index)
>> 		return;
>>
>> 	/* Cap nr_to_read, in order to avoid overflowing the ULONG type: */
>> 	if (index + nr_to_read < index)
>> 		nr_to_read = ULONG_MAX - index + 1;
>>
>> 	/* Cap nr_to_read, to avoid reading past the inode's isize limit: */
>> 	if (index + nr_to_read >= end_index)
>> 		nr_to_read = end_index - index + 1;
> 
> A little verbose for my taste ... How about this?


Mine too, actually. :)  I think your version below looks good.


thanks,
-- 
John Hubbard
NVIDIA

> 
>          end_index = (isize - 1) >> PAGE_SHIFT;
>          if (index > end_index)
>                  return;
>          /* Avoid wrapping to the beginning of the file */
>          if (index + nr_to_read < index)
>                  nr_to_read = ULONG_MAX - index + 1;
>          /* Don't read past the page containing the last byte of the file */
>          if (index + nr_to_read >= end_index)
>                  nr_to_read = end_index - index + 1;
> 

