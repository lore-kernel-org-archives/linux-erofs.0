Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3F0FC74A5B
	for <linux-erofs@archiver.kernel.org>; Wed, 29 Mar 2023 05:06:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4PmZJx1Fwtz3cfd
	for <linux-erofs@archiver.kernel.org>; Wed, 29 Mar 2023 16:06:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1680066385;
	bh=GjcLq9TYMSCEM1QxXkGT3Sk7emAp6wIFay5f/IdlFCI=;
	h=Date:Subject:To:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=FONLXL3LFesSlrECRNksdDVRf+AsZlJ1Dqr9IZLthck4JdlpEaCG0lpUJRwNd7vbf
	 ChAusCYwSftYk8weTPbp6fX3GlCSS8F0MJhusJz3FjeSxgQPucCGiFi/2z2ToVAW2P
	 xGEWatLpMKYNrl/e6oU0VQmgZCwifizsiPxfReY/iGkYVHbcUMeu354bY5dScAlHql
	 9oKJ6+ZUcGNRr++O/KwB5/xtOep25KWHOiHTtcByXfgqYqzWHdpu/wbn9WEFJy87L6
	 vG3P3cOBbxTa2MhmGlhn/WBfjcKUVbN7WxOX+/FYngi9Kd571mOLLZM/CgcPcsQ+Tf
	 VQSUBNWbYsfiw==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=bytedance.com (client-ip=2607:f8b0:4864:20::1033; helo=mail-pj1-x1033.google.com; envelope-from=zhujia.zj@bytedance.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=K0sDjl31;
	dkim-atps=neutral
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4PmZJp6f1kz2xHH
	for <linux-erofs@lists.ozlabs.org>; Wed, 29 Mar 2023 16:06:17 +1100 (AEDT)
Received: by mail-pj1-x1033.google.com with SMTP id p13-20020a17090a284d00b0023d2e945aebso3246701pjf.0
        for <linux-erofs@lists.ozlabs.org>; Tue, 28 Mar 2023 22:06:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680066375;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GjcLq9TYMSCEM1QxXkGT3Sk7emAp6wIFay5f/IdlFCI=;
        b=DXRNEA6jeJq8aJkpR3Fndt7Fi1Qh1fH4MGsDN7EVGlmmDDRBLYc4lcNVsKQSIcTBc5
         n4p8QEmNobY8fK//F3e7Nfmu7PKVevW0/fOxR+pm1uxCkK4dzY/KPN3WkNSVftOeRLhb
         KL6n0LNMg5gog1VygaoL9dgt5OFD6vKx2aCKL+ashxfBLumP5joQn6yMPEv19Pj2d2S/
         Xdgh4RyBSz4cN+H0JV1+CmKPY+RwufQ6EKKZZdytYBDEXGgKALV8xBrJrZo1Lg9z5qeN
         LFaEggM7W1mfEPgvnUKRLddpQyhn+un00jeuuebViFj9vOBSKx+Rea8xbpPYh/HWBUGh
         OvEA==
X-Gm-Message-State: AAQBX9eBCivhUFqamVTkw6QM3LysHreG5jy2sxiiFWzgSXaHhpAbOa42
	T9ZSTQJVeGCfRPJ2/6EyH0aYsg==
X-Google-Smtp-Source: AKy350ZTGNkadk5EkErfDhJ6zlZsX/8WZzxktyRHEWZEs7dxg+S3jbdRlD777MfiA6AK1tAh84FLZg==
X-Received: by 2002:a17:90b:1a88:b0:23e:aba9:d51d with SMTP id ng8-20020a17090b1a8800b0023eaba9d51dmr19242110pjb.7.1680066374750;
        Tue, 28 Mar 2023 22:06:14 -0700 (PDT)
Received: from [10.3.144.50] ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id dw24-20020a17090b095800b0023cff7e39a6sm463394pjb.22.2023.03.28.22.06.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 22:06:14 -0700 (PDT)
Message-ID: <1b99542d-f21b-a27b-fc59-d4fe38e893de@bytedance.com>
Date: Wed, 29 Mar 2023 13:06:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: Re: [PATCH V4 2/5] cachefiles: extract ondemand info field from
 cachefiles_object
To: David Howells <dhowells@redhat.com>
References: <20230111052515.53941-3-zhujia.zj@bytedance.com>
 <20230111052515.53941-1-zhujia.zj@bytedance.com>
 <132137.1680011908@warthog.procyon.org.uk>
In-Reply-To: <132137.1680011908@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
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
From: Jia Zhu via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Jia Zhu <zhujia.zj@bytedance.com>
Cc: linux-kernel@vger.kernel.org, linux-cachefs@redhat.com, linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



在 2023/3/28 21:58, David Howells 写道:
> Jia Zhu <zhujia.zj@bytedance.com> wrote:
> 
>> @@ -65,10 +71,7 @@ struct cachefiles_object {
>>   	enum cachefiles_content		content_info:8;	/* Info about content presence */
>>   	unsigned long			flags;
>>   #define CACHEFILES_OBJECT_USING_TMPFILE	0		/* Have an unlinked tmpfile */
>> -#ifdef CONFIG_CACHEFILES_ONDEMAND
>> -	int				ondemand_id;
>> -	enum cachefiles_object_state	state;
>> -#endif
>> +	struct cachefiles_ondemand_info	*private;
> 
> Why is this no longer inside "#ifdef CONFIG_CACHEFILES_ONDEMAND"?
> 

I'll revise it in next version.

> Also, please don't call it "private", but rather something like "ondemand" or
> "ondemand_info".

I'll use @ondemand to replace it.
Thanks.
> 
> David
> 
