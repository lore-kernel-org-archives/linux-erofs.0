Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEB11C6FD18
	for <linux-erofs@archiver.kernel.org>; Wed, 29 Mar 2023 03:33:52 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4PmXG70QNWz3cgq
	for <linux-erofs@archiver.kernel.org>; Wed, 29 Mar 2023 14:33:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1680060831;
	bh=4+TATKpiI/m1aX5zcJcBfi55zhCtiMGHrjCscJ6PomI=;
	h=Date:Subject:To:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=awd+tzsKkl8irG0HfceiF97wraY6AoX3FzHuRMaM7MJZrs8nGfqY+J0hxaB31/mb3
	 rm0azLru0PLZTphfhF+eXuKwgqaHtLM55yHgzDyfSwGmJ12YXQfwHlbi2vcv/AU/F3
	 RiS8Y1ml+lp7Vgv0y+tYD1AqzK3wx/p6zAg44KZtxSdOzj7KB1hfPpjnywHiGjrtvd
	 Zx8Le+tP2WueV/xajiXmex3ejRt5/eCwE1/AIufRa9VV3cIwqBd5vsDHCCfY64rLjY
	 WL2sqeu+/P24b2vnhtX5rDx5TlNwNvtUxOinBoKSrPYUa+qaIQ2MCFcB+//DFjYWTh
	 XLofdgD5D5gAA==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=bytedance.com (client-ip=2607:f8b0:4864:20::1029; helo=mail-pj1-x1029.google.com; envelope-from=zhujia.zj@bytedance.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=FPQnW38S;
	dkim-atps=neutral
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4PmXFz5B8bz3bbZ
	for <linux-erofs@lists.ozlabs.org>; Wed, 29 Mar 2023 14:33:41 +1100 (AEDT)
Received: by mail-pj1-x1029.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so14788986pjt.5
        for <linux-erofs@lists.ozlabs.org>; Tue, 28 Mar 2023 20:33:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680060817;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4+TATKpiI/m1aX5zcJcBfi55zhCtiMGHrjCscJ6PomI=;
        b=xRnfIWxZPC4dZK/+q5PI658+H/BT12zCu0PhgRnk9bsTYg8W1bMXrLI8SstJAGwdvj
         aYfmrxbhhv8p3oJdmxmGXUujFQQT0RmGI+R+aVee1NIyGFr0UzsuFTQpr/c4+qPqbIkz
         NZz4HFOtUoHy5Rx85YQAJ+HXvTcf+jmmbOImpqHcBhgUBSerlc3bV2LnyBilV67CuS/w
         DMMLmY4q6wg6/L2CsUINFW4GhlH85+YMfg3e5Y5u3iMVaxgU88523YbkhD0UZ3l78r4j
         KLAitCwUa+Q8QkwAJSraI7o6HOhXjzq3uBS7E/P7KxQGex0DGlgz6SNp+Ki5sjnfCqDX
         Rq7w==
X-Gm-Message-State: AAQBX9fDKlVL4+/lYZ19vnHDkkqrwv9x1yN+6VKyRQHe7tJ160Rjbomh
	Hec+b8qeb2XAbrgJIsOrjap8QA==
X-Google-Smtp-Source: AKy350avfa0gKz4Zd6gsYPNpRBHU5Bq4LY4VQkUnGwedVUVb52Mza3ZZUfXF1Abdzp/MXze4iNGrjw==
X-Received: by 2002:a17:903:743:b0:1a1:cd69:d301 with SMTP id kl3-20020a170903074300b001a1cd69d301mr15834742plb.68.1680060817286;
        Tue, 28 Mar 2023 20:33:37 -0700 (PDT)
Received: from [10.3.144.50] ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id k16-20020a63f010000000b004fbd021bad6sm20505062pgh.38.2023.03.28.20.33.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 20:33:36 -0700 (PDT)
Message-ID: <a9952336-4648-16be-532a-37fd52d67b27@bytedance.com>
Date: Wed, 29 Mar 2023 11:33:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: Re: [PATCH V4 1/5] cachefiles: introduce object ondemand state
To: David Howells <dhowells@redhat.com>
References: <20230111052515.53941-2-zhujia.zj@bytedance.com>
 <20230111052515.53941-1-zhujia.zj@bytedance.com>
 <131869.1680011531@warthog.procyon.org.uk>
In-Reply-To: <131869.1680011531@warthog.procyon.org.uk>
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

Hi David,
Thanks for reviewing.

在 2023/3/28 21:52, David Howells 写道:
> Jia Zhu <zhujia.zj@bytedance.com> wrote:
> 
>> +enum cachefiles_object_state {
>> +	CACHEFILES_ONDEMAND_OBJSTATE_close, /* Anonymous fd closed by daemon or initial state */
>> +	CACHEFILES_ONDEMAND_OBJSTATE_open, /* Anonymous fd associated with object is available */
> 
> That looks weird.  Maybe make them all-lowercase?

I'll revise it in next version.
> 
>> @@ -296,6 +302,21 @@ extern void cachefiles_ondemand_clean_object(struct cachefiles_object *object);
>>   extern int cachefiles_ondemand_read(struct cachefiles_object *object,
>>   				    loff_t pos, size_t len);
>>   
>> +#define CACHEFILES_OBJECT_STATE_FUNCS(_state)	\
>> +static inline bool								\
>> +cachefiles_ondemand_object_is_##_state(const struct cachefiles_object *object) \
>> +{												\
>> +	return object->state == CACHEFILES_ONDEMAND_OBJSTATE_##_state; \
>> +}												\
>> +												\
>> +static inline void								\
>> +cachefiles_ondemand_set_object_##_state(struct cachefiles_object *object) \
>> +{												\
>> +	object->state = CACHEFILES_ONDEMAND_OBJSTATE_##_state; \
>> +}
>> +
>> +CACHEFILES_OBJECT_STATE_FUNCS(open);
>> +CACHEFILES_OBJECT_STATE_FUNCS(close);
> 
> Or just get rid of the macroisation?  If there are only two states, it doesn't
> save you that much and it means that "make TAGS" won't generate refs for those
> functions and grep won't find them.

Actually there is one more state <reopening> will be introduced in
patch3 and 30+ loc for repeated functions will be added if we drop the 
macro.
Shall I keep using the macro or replace it?
> David
