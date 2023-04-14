Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2E71C77B6E
	for <linux-erofs@archiver.kernel.org>; Fri, 14 Apr 2023 15:13:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Pyg1k669Cz3fW3
	for <linux-erofs@archiver.kernel.org>; Sat, 15 Apr 2023 01:13:14 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1681485194;
	bh=7E15TZKBUj7LhKJ72c7EvYGt3lCtMNYU30GwoWvGVWc=;
	h=Date:Subject:To:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=GpPgCww18LmehGaqAanav5XNj1s3SdJbAKyO3zQVLKTyThE+nnpe94gp9Esm/NKP7
	 29wj8+Si/KnLoS+I/N9J6u2oL+Kipt+903xg/jEtQRdh5Qwm49qdkiCPrBzp01QuuA
	 Lw4uPgklYPloAjSnvGSIvUK0jmP9UBcn0vXuOj4z5A3hTKt4mdE8EtkHoVZKgGvMrf
	 ouah6pHHOC91kZQIuDG/A6allNR/lU8caPclIaZJKPdRQOzB7HqyNCiEeLLhmM6d58
	 L6tWwUmGw+LJ6UQSDhALBO8sryT+K2/kRaHDL8wq/O4THQ0h8xKJ/dOLZCjxgjwBAQ
	 k7Y6nZ8igNvkw==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=bytedance.com (client-ip=2607:f8b0:4864:20::632; helo=mail-pl1-x632.google.com; envelope-from=zhujia.zj@bytedance.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=SwfEYPmd;
	dkim-atps=neutral
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Pyg1Z047Hz30Qg
	for <linux-erofs@lists.ozlabs.org>; Sat, 15 Apr 2023 01:13:04 +1000 (AEST)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1a66888cb89so6090355ad.3
        for <linux-erofs@lists.ozlabs.org>; Fri, 14 Apr 2023 08:13:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681485181; x=1684077181;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7E15TZKBUj7LhKJ72c7EvYGt3lCtMNYU30GwoWvGVWc=;
        b=i6OUxSLrOaNLWY7ZgyNCI8qnGEL44qvV/rPZRELOQmdLn4HybEHyrj5nhIVHDeJL11
         UrvH3wPYQlQIjlEtFvn7GBazacX/Ml5pXLgS4Oci/J3g11PZOfhY2uvEOHB1rj3mP+fq
         uS+9l5ZJo6/T5UCd9fR2gJ+7vpGMJeE6bOGCa/wlhnvaOPuDSvaQiuWcKZ1S2lHUBA+O
         VD+YObCrL7Qshr8bhj2aW0NXLuGzc9Set8dpPa2p0U+yKqNab3Taaf3hpV0xeC6cQwac
         5wjk+B9uuXAuhnhO1/ZHbVr9nUZxvVv+IOLZCqWd7Axlzxd1vvwfdj25RBpITK6/9ltK
         qw+g==
X-Gm-Message-State: AAQBX9d+qtEpB6pcon947cyc0eZTE3xzIsW9mwMF1JCKV10QVQ34alzh
	oO7hGpxEsNlv4um/mVmYmla6UQ==
X-Google-Smtp-Source: AKy350a/j8gjvHx5XSjNdD1sExInjJAJ7u6ERNSyq4ejXK3n0tHMQ777nwe9LmVp5aHRdXJu3Y85pw==
X-Received: by 2002:a05:6a00:2e1d:b0:636:ea6c:68d8 with SMTP id fc29-20020a056a002e1d00b00636ea6c68d8mr8600263pfb.27.1681485181079;
        Fri, 14 Apr 2023 08:13:01 -0700 (PDT)
Received: from [10.255.185.5] ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id 5-20020aa79105000000b0063b1bb2e0a7sm3129352pfh.203.2023.04.14.08.12.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 08:13:00 -0700 (PDT)
Message-ID: <65f424ca-d7cd-f53b-cefc-684ec0393bce@bytedance.com>
Date: Fri, 14 Apr 2023 23:12:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: Re: [PATCH V5 5/5] cachefiles: add restore command to recover
 inflight ondemand read requests
To: David Howells <dhowells@redhat.com>
References: <20230329140155.53272-6-zhujia.zj@bytedance.com>
 <20230329140155.53272-1-zhujia.zj@bytedance.com>
 <1250439.1681480404@warthog.procyon.org.uk>
In-Reply-To: <1250439.1681480404@warthog.procyon.org.uk>
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
Cc: linux-kernel@vger.kernel.org, linux-cachefs@redhat.com, hsiangkao@linux.alibaba.com, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



在 2023/4/14 21:53, David Howells 写道:
> Jia Zhu <zhujia.zj@bytedance.com> wrote:
> 
>> +int cachefiles_ondemand_restore(struct cachefiles_cache *cache, char *args)
>> +{
>> +	struct cachefiles_req *req;
>> +
>> +	XA_STATE(xas, &cache->reqs, 0);
>> +
>> +	if (!test_bit(CACHEFILES_ONDEMAND_MODE, &cache->flags))
>> +		return -EOPNOTSUPP;
>> +
>> +	/*
>> +	 * Reset the requests to CACHEFILES_REQ_NEW state, so that the
>> +	 * requests have been processed halfway before the crash of the
>> +	 * user daemon could be reprocessed after the recovery.
>> +	 */
>> +	xas_lock(&xas);
>> +	xas_for_each(&xas, req, ULONG_MAX)
>> +		xas_set_mark(&xas, CACHEFILES_REQ_NEW);
>> +	xas_unlock(&xas);
>> +
>> +	wake_up_all(&cache->daemon_pollwq);
>> +	return 0;
>> +}
> 
> Should there be a check to see if this is needed?
> 
> David

I've considered whether to add a check here, since the user could invoke
'restore' through ioctl at any time.

If 'restore' is called without user daemon crashing. Then the req being
processed by the user daemon will be reset to CACHEFILES_REQ_NEW and
could be re-read and processed by the user daemon.

For OPEN req:  The user daemon will ignore this repeated req since the
related anonymous fd is the same.

For READ req: The user daemon will read the same part of the data again
and write it to fscache (this will not cause any error)

For CLOSE req: Actually the user daemon will close this anonymous fd,
but fortunately [PATCH 3/5] could handle this case by reopening it
automatically.

Thus "restore" could be called at any time without error, checks
might introduce extra race conditions.

Jia
> 
