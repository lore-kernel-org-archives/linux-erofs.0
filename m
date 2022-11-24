Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13B83C433FE
	for <linux-erofs@archiver.kernel.org>; Thu, 24 Nov 2022 03:20:03 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4NHjss42z0z3cXX
	for <linux-erofs@archiver.kernel.org>; Thu, 24 Nov 2022 14:20:01 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.43; helo=out30-43.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4NHjsn6X5wz3bsK
	for <linux-erofs@lists.ozlabs.org>; Thu, 24 Nov 2022 14:19:56 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VVZ9.-D_1669259990;
Received: from 30.221.132.138(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0VVZ9.-D_1669259990)
          by smtp.aliyun-inc.com;
          Thu, 24 Nov 2022 11:19:51 +0800
Message-ID: <25cfb176-ff2d-36e5-d12e-a2413ad2d5c2@linux.alibaba.com>
Date: Thu, 24 Nov 2022 11:19:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.0
Subject: Re: [PATCH v4 1/2] fscache,cachefiles: add prepare_ondemand_read()
 callback
Content-Language: en-US
To: David Howells <dhowells@redhat.com>
References: <20221117053017.21074-2-jefflexu@linux.alibaba.com>
 <20221117053017.21074-1-jefflexu@linux.alibaba.com>
 <1609247.1669221883@warthog.procyon.org.uk>
From: Jingbo Xu <jefflexu@linux.alibaba.com>
In-Reply-To: <1609247.1669221883@warthog.procyon.org.uk>
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
Cc: jlayton@kernel.org, linux-kernel@vger.kernel.org, linux-cachefs@redhat.com, linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi David,

Really thanks for the comment.

On 11/24/22 12:44 AM, David Howells wrote:
> Jingbo Xu <jefflexu@linux.alibaba.com> wrote:
> 
>> -/*
>> - * Prepare a read operation, shortening it to a cached/uncached
>> - * boundary as appropriate.
>> - */
>> -static enum netfs_io_source cachefiles_prepare_read(struct netfs_io_subrequest *subreq,
>> -						      loff_t i_size)
>> +static inline enum netfs_io_source
>> +cachefiles_do_prepare_read(struct netfs_cache_resources *cres,
>> +			   loff_t start, size_t *_len, loff_t i_size,
>> +			   unsigned long *_flags)
> 
> That's not exactly what I meant, but I guess it would work as the compiler
> would probably inline it into both callers.

Yeah, I just have no better way if we don't want another function
calling introduced by this patch.  If we keep cachefiles_prepare_read()
untouched, the on-demand users need to construct a temporary subrequest
on the stack, and Jeff pointed out that this way is somewhat fragile and
not robust enough.

Anyway I would keep moving forward in the direction of current patch,
and add back the netfs_inode number to the tracepoint.  I would send v5
soon.

Thanks again for the reply :-)

> 
>> -		      __entry->netfs_inode, __entry->cache_inode)
>> +		      __entry->cache_inode)
> 
> Can you not lose the netfs_inode number from the tracepoint, please?  Feel
> free to display 0 there for your purposes.
> 

Sure.


-- 
Thanks,
Jingbo
