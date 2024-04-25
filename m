Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F5D3C4345F
	for <linux-erofs@archiver.kernel.org>; Thu, 25 Apr 2024 05:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1714023698;
	bh=LiVVv+CXcN+CvM+zB+3igsIJaaE0zH8C5SDY181CcQk=;
	h=Date:Subject:To:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=YPzCR2krZ26sdv85UclW2SQ7IPcD/LJ2i4RIDB4PH+xctX8Cby6Q4eMY+vrfOo9fx
	 UK8R7Wu7Gy70a7H10E0YOPkB6XfkqAOl5GB4+ieHtFiKcGcZN7NIZE4B9tb4/StGZC
	 okToQ3s3mur/IPuykk6KOAjijiyMTtk2Cq0tchno2ghMjxA7ylDNd+/Mju7uUsXimp
	 n+yfO9XORHt/c2ATB0Zra5iDPAXYa/0JA3mKqL4XtM4WmTMrzv9IDtxhkyJbw9LWsB
	 2zaDy8RaLV6mv4s56KAPGQVn7OrFJSUbYEqqsx4jYA6xL/X0zL3C5Do3IiCKy9Cu21
	 R7KkmhGQAwPWQ==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4VQ4VB65LGz3dK9
	for <linux-erofs@archiver.kernel.org>; Thu, 25 Apr 2024 15:41:38 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Hvfj/iXq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=bytedance.com (client-ip=2607:f8b0:4864:20::429; helo=mail-pf1-x429.google.com; envelope-from=zhujia.zj@bytedance.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4VQ4V339cfz3cmg
	for <linux-erofs@lists.ozlabs.org>; Thu, 25 Apr 2024 15:41:29 +1000 (AEST)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-6ecf05fd12fso597182b3a.2
        for <linux-erofs@lists.ozlabs.org>; Wed, 24 Apr 2024 22:41:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714023687; x=1714628487;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LiVVv+CXcN+CvM+zB+3igsIJaaE0zH8C5SDY181CcQk=;
        b=gevDIlZ5P3ywHaqCfrngPIq23m+TVIiycNS+2yNI5kjAjqBXmQK8xV0nN2H14S163R
         sl5AF17Dc4wVpq74Il9P01/1AfaeIdOEMhTDiMaFOoXfc4it+BDRi0Q/EuadR/2NVNMP
         KBze3+hrYFHsAZZxpiUyheEGjhkk1AARVulvnFvzI4owNzYo+KRWSMyGB6F6VyLrxjN2
         tVfuzsb03ZJhBpU11C7zVRpvJJQZFuuXyliW23QWiZsuvq79ij6cn1ZbEiH9C0Nl/nSh
         F7isshrCdsqxvhm2VST518sNVmM24jCaBjly+t4plYCPfuZtcXZyPoy6Y7VIumjcq8i4
         XSQA==
X-Forwarded-Encrypted: i=1; AJvYcCXJPXFbwgLO1xiq1lsAWkMAwKbyZ9fDSBQO2lYZ3hIWBy1wGYKw91IxYaSyoYfWx/hlAQG6tLPvYXlj0b1RpN3RR6nGksiwP8vYpOIv
X-Gm-Message-State: AOJu0YwocLtF/zSbcOig4isR8NEPTTHSuTZq2IRsWQKXa1fmhkvgpem3
	1EoLapfMbAKfPV1xffUfjIkR24LD/ez6GSXBtVLQlyT2Bid0lo0ebERoE3hUjPg=
X-Google-Smtp-Source: AGHT+IHNJBsklbaNtuhephdNcHI3SdblGcDt0X5IXkyJ+9Sg3RqlYnd4/Js8ZPm7qlkq9lbveXh7Sg==
X-Received: by 2002:a05:6a00:1492:b0:6ed:1c7:8c5d with SMTP id v18-20020a056a00149200b006ed01c78c5dmr5655256pfu.12.1714023687307;
        Wed, 24 Apr 2024 22:41:27 -0700 (PDT)
Received: from [10.3.132.118] ([61.213.176.14])
        by smtp.gmail.com with ESMTPSA id a5-20020aa78e85000000b006e554afa254sm12333974pfr.38.2024.04.24.22.41.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Apr 2024 22:41:26 -0700 (PDT)
Message-ID: <8572a732-ca12-48d7-817c-d8218d536c0c@bytedance.com>
Date: Thu, 25 Apr 2024 13:41:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] cachefiles: flush ondemand_object_worker during clean
 object
To: libaokun@huaweicloud.com, netfs@lists.linux.dev
References: <20240424033409.2735257-1-libaokun@huaweicloud.com>
 <20240424033409.2735257-4-libaokun@huaweicloud.com>
In-Reply-To: <20240424033409.2735257-4-libaokun@huaweicloud.com>
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
Cc: jlayton@kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Thanks for catching this. How about adding a Fixes tag.

Reviewed-by: Jia Zhu <zhujia.zj@bytedance.com>


在 2024/4/24 11:34, libaokun@huaweicloud.com 写道:
> From: Hou Tao <houtao1@huawei.com>
> 
> When queuing ondemand_object_worker() to re-open the object,
> cachefiles_object is not pinned. The cachefiles_object may be freed when
> the pending read request is completed intentionally and the related
> erofs is umounted. If ondemand_object_worker() runs after the object is
> freed, it will incur use-after-free problem as shown below.
> 
> process A  processs B  process C  process D
> 
> cachefiles_ondemand_send_req()
> // send a read req X
> // wait for its completion
> 
>             // close ondemand fd
>             cachefiles_ondemand_fd_release()
>             // set object as CLOSE
> 
>                         cachefiles_ondemand_daemon_read()
>                         // set object as REOPENING
>                         queue_work(fscache_wq, &info->ondemand_work)
> 
>                                  // close /dev/cachefiles
>                                  cachefiles_daemon_release
>                                  cachefiles_flush_reqs
>                                  complete(&req->done)
> 
> // read req X is completed
> // umount the erofs fs
> cachefiles_put_object()
> // object will be freed
> cachefiles_ondemand_deinit_obj_info()
> kmem_cache_free(object)
>                         // both info and object are freed
>                         ondemand_object_worker()
> 
> When dropping an object, it is no longer necessary to reopen the object,
> so use cancel_work_sync() to cancel or wait for ondemand_object_worker()
> to complete.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> ---
>   fs/cachefiles/ondemand.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
> index d24bff43499b..f6440b3e7368 100644
> --- a/fs/cachefiles/ondemand.c
> +++ b/fs/cachefiles/ondemand.c
> @@ -589,6 +589,9 @@ void cachefiles_ondemand_clean_object(struct cachefiles_object *object)
>   		}
>   	}
>   	xa_unlock(&cache->reqs);
> +
> +	/* Wait for ondemand_object_worker() to finish to avoid UAF. */
> +	cancel_work_sync(&object->ondemand->ondemand_work);
>   }
>   
>   int cachefiles_ondemand_init_obj_info(struct cachefiles_object *object,
