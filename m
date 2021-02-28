Return-Path: <SRS0=BvRt=H6=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEAA0C433E0
	for <linux-erofs@archiver.kernel.org>; Sun, 28 Feb 2021 13:30:42 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2532864E59
	for <linux-erofs@archiver.kernel.org>; Sun, 28 Feb 2021 13:30:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2532864E59
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4DpPR45xyXz3cQP
	for <linux-erofs@archiver.kernel.org>; Mon,  1 Mar 2021 00:30:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1614519040;
	bh=QY1nGiHIf044F96DYvNtnhpkRDBazW3kTU1Pg33t72k=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=QRKJ8MW2s9+XyKmIn9iPhXL1TJ8gxZ0AwTNxBMHF0iCpLZlSDDL4RPUybag/57n5w
	 oAXhaipsRdtT90s/jMzwhVKlYpIvIMxS6hLwqE2sFIY98Kg0gaWL15jdnlweIKUPoS
	 TN7fIy4fOgzge4IRAwMrtnN3Vl5YdT8/JsB+JiYfuyrgzpeUCsfdQvh7lTzJNxcjqX
	 vsA//TTnILVHp+yx2MGKExZGH7e86Sn/iD+SHq/Ye16zL7Xf+HQGqT4rgbJ89RTRUC
	 ti8V6znFFth5gzggBmtArfVpOKegNDO8zlAJow7HBVKegWHQDAj1VGjLqoedC8ELQp
	 cfnNusEmUs2SA==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.38;
 helo=out30-38.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=DFBTMDGH; dkim-atps=neutral
Received: from out30-38.freemail.mail.aliyun.com
 (out30-38.freemail.mail.aliyun.com [115.124.30.38])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4DpPR16DDsz30Jv
 for <linux-erofs@lists.ozlabs.org>; Mon,  1 Mar 2021 00:30:37 +1100 (AEDT)
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.07376582|-1; CH=green;
 DM=|CONTINUE|false|;
 DS=CONTINUE|ham_regular_dialog|0.00412887-0.000680782-0.99519;
 FP=0|0|0|0|0|-1|-1|-1; HT=e01e04400; MF=bluce.lee@aliyun.com; NM=1; PH=DS;
 RN=3; RT=3; SR=0; TI=SMTPD_---0UPoNN01_1614519019; 
Received: from 192.168.3.32(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0UPoNN01_1614519019) by smtp.aliyun-inc.com(127.0.0.1);
 Sun, 28 Feb 2021 21:30:19 +0800
Subject: Re: [PATCH v2] erofs-utils: fuse: fix random readlink error
To: Gao Xiang <hsiangkao@aol.com>, Hu Weiwen <sehuww@mail.scut.edu.cn>
References: <20210123152213.GB3167351@xiangao.remote.csb>
 <20210129180747.67731-1-sehuww@mail.scut.edu.cn>
 <20210209193845.GA13059@hsiangkao-HP-ZHAN-66-Pro-G1>
Message-ID: <f7066cea-b2e2-c4fe-3f46-aec347f20846@aliyun.com>
Date: Sun, 28 Feb 2021 21:30:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210209193845.GA13059@hsiangkao-HP-ZHAN-66-Pro-G1>
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
From: Li GuiFu via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Li GuiFu <bluce.lee@aliyun.com>
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2021/2/10 3:38, Gao Xiang via Linux-erofs wrote:
> Hi Weiwen,
> 
> On Sat, Jan 30, 2021 at 02:07:47AM +0800, Hu Weiwen wrote:
>> readlink should fill a **null-terminated** string in the buffer.
>>
>> To achieve this:
>> 1) memset(0) for unmapped extents;
>> 2) make erofsfuse_read() properly returning the actual bytes read;
>> 3) insert a null character if the path is truncated.
>>
>> Link: https://lore.kernel.org/r/20210121101233.GC6680@DESKTOP-N4CECTO.huww98.cn
> 
> Looked into this patch just now...
> 
> The Link tag is only used for refering to the patch itself.
> 
>> Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
>> ---
> 
> ...
> 
>>  
>> @@ -91,9 +92,13 @@ static int erofs_read_raw_data(struct erofs_inode *inode, char *buffer,
>>  
>>  		if (!(map.m_flags & EROFS_MAP_MAPPED)) {
>>  			if (!map.m_llen) {
>> +				/* reached EOF */
>> +				memset(buffer + ptr - offset, 0,
>> +				       offset + size - ptr);
>>  				ptr = offset + size;
>>  				continue;
>>  			}
>> +			memset(buffer + map.m_la - offset, 0, map.m_llen);
> 
> There might be some minor issue --- `offset' could be larger than
> `map.m_la' if sparse file is supported then.
> 
> I made an update version of this to fix these (some cleanup is
> included as well), it would be nice of you to take another look at
> this as well...
> 
> Thanks,
> Gao Xiang
> 
> From bfbd8ee056aca57a77034b8723f3f828f806747b Mon Sep 17 00:00:00 2001
> From: Hu Weiwen <sehuww@mail.scut.edu.cn>
> Date: Sat, 30 Jan 2021 02:07:47 +0800
> Subject: [PATCH v3] erofs-utils: fuse: fix random readlink error
> 
> readlink should fill a **null-terminated** string in the buffer [1].
> 
> To achieve this:
> 1) memset(0) for unmapped extents;
> 2) make erofsfuse_read() properly returning the actual bytes read;
> 3) insert a null character if the path is truncated.
> 
> [1] https://lore.kernel.org/r/20210121101233.GC6680@DESKTOP-N4CECTO.huww98.cn
> Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> Signed-off-by: Gao Xiang <hsiangkao@aol.com>
> ---
>  fuse/main.c |  8 ++++++++
>  lib/data.c  | 20 ++++++++++++--------
>  2 files changed, 20 insertions(+), 8 deletions(-)
> 
It looks good
Reviewed-by: Li Guifu <bluce.lee@aliyun.com>

Thanks,
