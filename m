Return-Path: <SRS0=U8k6=JI=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96FDAC433ED
	for <linux-erofs@archiver.kernel.org>; Sun, 11 Apr 2021 14:56:43 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CC13B610C7
	for <linux-erofs@archiver.kernel.org>; Sun, 11 Apr 2021 14:56:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC13B610C7
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4FJFLx3fgPz30L2
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Apr 2021 00:56:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1618153001;
	bh=Jv0R+kqOtFbJjkpF86I0HX3cwr9T9sDVzP7P8hGpCxE=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=inKR0Q3kcYf78xMMdtC7+e3f4Iiba3d6ZRo4P5xEmf3V+0/9e2amqwzMJOEitfFwo
	 0iyr8egPz9weN58trAEo7v9wGLWT0Vns5yxTN87L61/gpMyDqCygilPOwY1W6A+WA7
	 6U7wpKOrfFKwJ7iYLiRK1mV/g6j+5HDU+47eNRtehkPaw+NDhsGNnpV8LeBVeDke4d
	 EyBXOgcdEA6j2yBdC6cDYsCIhp3XCbNotaMF/hunF1zgIktzvTJzCSLQTk2CGizO6G
	 uPo2Gq9GhI+m+DC9RO1efiaE2Kp0WXWdz4bBz5wy+OyPt5YDwj2TUBtPSoHeaJV0PO
	 7q//jWmPICAkw==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.28;
 helo=out30-28.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=HHLuebPx; dkim-atps=neutral
Received: from out30-28.freemail.mail.aliyun.com
 (out30-28.freemail.mail.aliyun.com [115.124.30.28])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4FJFLs5DpKz304C
 for <linux-erofs@lists.ozlabs.org>; Mon, 12 Apr 2021 00:56:36 +1000 (AEST)
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.08190086|-1; CH=green;
 DM=|CONTINUE|false|;
 DS=CONTINUE|ham_regular_dialog|0.113356-0.00592422-0.88072;
 FP=0|0|0|0|0|-1|-1|-1; HT=e01e04426; MF=bluce.lee@aliyun.com; NM=1; PH=DS;
 RN=4; RT=4; SR=0; TI=SMTPD_---0UV9r04X_1618152987; 
Received: from 192.168.3.32(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0UV9r04X_1618152987) by smtp.aliyun-inc.com(127.0.0.1);
 Sun, 11 Apr 2021 22:56:28 +0800
Subject: Re: [PATCH v2] erofs-utils: use qsort() to sort dir->i_subdirs
To: Gao Xiang <xiang@kernel.org>
References: <20210402021741.GB4011659@xiangao.remote.csb>
 <20210405093816.149621-1-sehuww@mail.scut.edu.cn>
 <8f0140a5-c738-7890-eff7-eb877a40035d@aliyun.com>
 <20210411144047.GA15096@hsiangkao-HP-ZHAN-66-Pro-G1>
Message-ID: <eca4aafb-af6b-f31f-67f0-ad59777cb80f@aliyun.com>
Date: Sun, 11 Apr 2021 22:56:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210411144047.GA15096@hsiangkao-HP-ZHAN-66-Pro-G1>
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



On 2021/4/11 22:41, Gao Xiang wrote:
> Guifu,
> 
> On Sun, Apr 11, 2021 at 10:10:09PM +0800, Li GuiFu via Linux-erofs wrote:
>> Hu Weiwen
>>   It really do a high sort performance increase,
>>   I have a idea that keeping the erofs_prepare_dir_file() function
>> paramter stable, Using a independent function to do dirs sort.
>>
> 
> I think Weiwen's implementation looks fine to me, if you tend to
> not passing nr_subdirs as a cleaner solution, my suggestion would
> be:
> 1) introduce a somewhat erofs_subdirs, which includes
>    - a list_head for all subdir dentries generated from d_alloc;
>    - a nr_subdirs count;
> 2) update erofs_d_alloc to
>    erofs_d_alloc(struct erofs_subdirs *, const char *);
> 3) update erofs_prepare_dir_file to
>    erofs_prepare_dir_file(struct erofs_inode *, struct erofs_subdir *).
> 
> Yet I'd like to apply the current solution first since it helps the
> dir creation performance. If someone has interest to the solution
> above, new cleanup is always welcomed.
> 
> Reviewed-by: Gao Xiang <xiang@kernel.org>
> 

ok, It is also good
Reviewed-by: Li Guifu <bluce.lee@aliyun.com>

Thanks,
