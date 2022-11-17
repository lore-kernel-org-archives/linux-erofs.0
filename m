Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 666A0C433FE
	for <linux-erofs@archiver.kernel.org>; Thu, 17 Nov 2022 04:24:58 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4NCRf01ksWz3cRW
	for <linux-erofs@archiver.kernel.org>; Thu, 17 Nov 2022 15:24:56 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4NCRds2kmqz3bjf
	for <linux-erofs@lists.ozlabs.org>; Thu, 17 Nov 2022 15:24:47 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VV-VtWS_1668659080;
Received: from 30.221.128.178(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0VV-VtWS_1668659080)
          by smtp.aliyun-inc.com;
          Thu, 17 Nov 2022 12:24:42 +0800
Message-ID: <c529ee21-699d-dfc8-5f7d-2597fa00796d@linux.alibaba.com>
Date: Thu, 17 Nov 2022 12:24:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.0
Subject: Re: [PATCH v3 1/2] fscache,cachefiles: add prepare_ondemand_read()
 callback
Content-Language: en-US
To: David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@kernel.org>
References: <2b595b62f6ecd28298a860fcdc5b4941dcafd9eb.camel@kernel.org>
 <20221116104502.107431-1-jefflexu@linux.alibaba.com>
 <20221116104502.107431-2-jefflexu@linux.alibaba.com>
 <2968419.1668606101@warthog.procyon.org.uk>
From: Jingbo Xu <jefflexu@linux.alibaba.com>
In-Reply-To: <2968419.1668606101@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8
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
Cc: linux-kernel@vger.kernel.org, linux-cachefs@redhat.com, linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 11/16/22 9:41 PM, David Howells wrote:
> Jeff Layton <jlayton@kernel.org> wrote:
> 
>>> +static enum netfs_io_source cachefiles_do_prepare_read(struct netfs_cache_resources *cres,
>>> +					loff_t *_start, size_t *_len,
>>> +					unsigned long *_flags, loff_t i_size)
>>
>> _start is never changed, so it should be passed by value instead of by
>> pointer.
> 
> Hmmm.  The intention was that the start pointer should be able to be moved
> backwards by the cache - but that's not necessary in ->prepare_read() and
> ->expand_readahead() is provided for that now.  So yes, the start pointer
> shouldn't get changed at this point.

Okay.


> 
>> I'd also reverse the position of the arguments for _flags and i_size.
>> Otherwise, the CPU/compiler have to shuffle things around more in
>> cachefiles_prepare_ondemand_read before they call this.
> 
> Better to pass the flags in and then ignore them.  That way it can tail call,
> or just call cachefiles_do_prepare_read() directly from erofs.  If you're
> going to have a wrapper, then you might be just as well create a
> netfs_io_subrequest struct on the stack.

I would prefer letting cachefiles_prepare_ondemand_read() pass flags in
and then tail call cachefiles_do_prepare_read() directly.

Many thanks for the suggestion.


-- 
Thanks,
Jingbo
