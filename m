Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACB60C6FA82
	for <linux-erofs@archiver.kernel.org>; Tue, 13 Sep 2022 06:34:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4MRYbz0kvvz3bYk
	for <linux-erofs@archiver.kernel.org>; Tue, 13 Sep 2022 16:34:55 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4MRYbv4V41z2xGH
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Sep 2022 16:34:50 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VPeAMF._1663050886;
Received: from 30.221.130.76(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0VPeAMF._1663050886)
          by smtp.aliyun-inc.com;
          Tue, 13 Sep 2022 14:34:47 +0800
Message-ID: <b9794188-f1e1-20ab-6aec-04312cbb02bf@linux.alibaba.com>
Date: Tue, 13 Sep 2022 14:34:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [External] Re: [PATCH V2 2/5] erofs: introduce fscache-based
 domain
Content-Language: en-US
To: Jia Zhu <zhujia.zj@bytedance.com>, linux-erofs@lists.ozlabs.org,
 xiang@kernel.org, chao@kernel.org
References: <20220902105305.79687-1-zhujia.zj@bytedance.com>
 <20220902105305.79687-3-zhujia.zj@bytedance.com>
 <ac567b29-dd30-7b65-aefb-3f23e59781cb@linux.alibaba.com>
 <fe9199a2-a8d5-98c9-461b-e7a2cbf87516@bytedance.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
In-Reply-To: <fe9199a2-a8d5-98c9-461b-e7a2cbf87516@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Cc: linux-fsdevel@vger.kernel.org, huyue2@coolpad.com, linux-kernel@vger.kernel.org, yinxin.x@bytedance.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 9/13/22 12:31 PM, Jia Zhu wrote:
> 
> 
> 在 2022/9/9 16:42, JeffleXu 写道:
>>>   int erofs_fscache_register_cookie(struct super_block *sb,
>>>                     struct erofs_fscache **fscache,
>>>                     char *name, bool need_inode)
>>> @@ -495,7 +581,8 @@ int erofs_fscache_register_fs(struct super_block
>>> *sb)
>>>       char *name;
>>>       int ret = 0;
>>>   -    name = kasprintf(GFP_KERNEL, "erofs,%s", sbi->opt.fsid);
>>> +    name = kasprintf(GFP_KERNEL, "erofs,%s",
>>> +            sbi->domain ? sbi->domain->domain_id : sbi->opt.fsid);
>>
>> Do we also need to encode the cookie name in the "<domain_id>,<fsid>"
>> format? This will affect the path of the cache files.
>>
> I think even though the cookies have the same name, they belong to
> different volumes(path). Cookies do not affect each other.
> Are there other benefits to doing so?

Okay. The current implementation is correct. Please ignore the noise.


-- 
Thanks,
Jingbo
