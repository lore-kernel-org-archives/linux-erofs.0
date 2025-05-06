Return-Path: <linux-erofs+bounces-277-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16377C3ABBC
	for <linux-erofs@archiver.kernel.org>; Tue,  6 May 2025 03:30:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Zs3nD4l4mz2yrf;
	Tue,  6 May 2025 13:30:24 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1746502224;
	cv=none; b=elRi2zSZxDvCUfSC4PkPfzGd3JXVDw3AcQmsL/+PvFR4PMeEz61mJVtgXZXotyx/l6GqJK2dbfw6fiDxmKeyyrLWWM1txyNGvalz1mxtzD40ZGu4IUVLtIRfho4+39lb09cUFQM5CmkzR+nb05GPyZ6SZnzPte0RT+pQv4Xn0QYDdUWJbAT4Lx1gQYAiN6o1bru2UAJRE6rFt8t6JFzbP+3EQ2L6PRZM85Xb4z29/okmyNIjs7e8foDi/jIWjTKdXY/G5MtqM8IEDWJVci7xMB0bquEWllSuqlox939yNZFOGHP68QPlUZmqLzvz0xZxHYDZipSuuRLRYYpHersWeg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1746502224; c=relaxed/relaxed;
	bh=qVR8T8FmyXrwS8bihvMwLtX38nPsMBJYh/Ep2JgBEjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mjcJfHQ8ARtoPVr+UgM/y+qVMzzhglBblilbnj1QrY1y2HMMkYQpUVvOrN8RCqZrz1cDKtKcCKV6ssEbYQrGWFr19s6nCUV1vnXntHtit2TXlOrsbzaqBk53BhfGjDYqVY/RTl3hYjPsW6y/3N+11Ng42Cxlyb0c6xx7Jg+nb4wu4nhY6sWxoDlFfMXtUbp9vyvd/Gb1KVzatfzaGHmEIoXszC2gDbwLfZBaK4d/m1WCnV5IsrI5UXoT3/ESfMFsuQV5EAzur/E6FVDUDQuh1RumBOK7+Ct8pL4S6rFooXuXN1mkn6pjbm6AGzMeKCI8aJzqA3yQfDqCqcLmOaoQCA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=M2w1I2eS; dkim-atps=neutral; spf=pass (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=M2w1I2eS;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Zs3nB32pnz2ygK
	for <linux-erofs@lists.ozlabs.org>; Tue,  6 May 2025 13:30:21 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1746502216; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=qVR8T8FmyXrwS8bihvMwLtX38nPsMBJYh/Ep2JgBEjU=;
	b=M2w1I2eS7tRvU+jskqnjexWkAuchwm2yX/vel9ESWk26ZNxZthyH5WxGwhZhO512TF7RTj8oy6Kdws+aMcZV4qmAx1R9L80IiR3gsZuZntpFad+1Ffc/cKHlDmYe3zWC2feeWOjgLUEYKch/PKC3dYm+jOE/k/FdbPYgsz8T4tI=
Received: from 30.221.130.226(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WZJNpx4_1746502214 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 06 May 2025 11:30:15 +0800
Message-ID: <8de6a220-45a3-4885-890f-0538522e620c@linux.alibaba.com>
Date: Tue, 6 May 2025 11:30:14 +0800
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] erofs: lazily initialize per-CPU workers and CPU
 hotplug hooks
To: Sandeep Dhavale <dhavale@google.com>, linux-erofs@lists.ozlabs.org,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: kernel-team@android.com, linux-kernel@vger.kernel.org
References: <20250501183003.1125531-1-dhavale@google.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20250501183003.1125531-1-dhavale@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Sandeep,

On 2025/5/2 02:30, Sandeep Dhavale wrote:
> Currently, when EROFS is built with per-CPU workers, the workers are
> started and CPU hotplug hooks are registered during module initialization.
> This leads to unnecessary worker start/stop cycles during CPU hotplug
> events, particularly on Android devices that frequently suspend and resume.
> 
> This change defers the initialization of per-CPU workers and the
> registration of CPU hotplug hooks until the first EROFS mount. This
> ensures that these resources are only allocated and managed when EROFS is
> actually in use.
> 
> The tear down of per-CPU workers and unregistration of CPU hotplug hooks
> still occurs during z_erofs_exit_subsystem(), but only if they were
> initialized.
> 
> Signed-off-by: Sandeep Dhavale <dhavale@google.com>
> ---
> v4: https://lore.kernel.org/linux-erofs/20250423061023.131354-1-dhavale@google.com/
> Changes since v4:
> - remove redundant blank line as suggested by Gao
> - add a log for failure path as suggested by Chao
> - also add success log which will help in case there was a failure
>    before, else stale failure log could cause unnecessary concern
> 
>   fs/erofs/zdata.c | 65 ++++++++++++++++++++++++++++++++++++------------
>   1 file changed, 49 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
> index 0671184d9cf1..a5d3aef319b2 100644
> --- a/fs/erofs/zdata.c
> +++ b/fs/erofs/zdata.c
> @@ -291,6 +291,9 @@ static struct workqueue_struct *z_erofs_workqueue __read_mostly;
>   
>   #ifdef CONFIG_EROFS_FS_PCPU_KTHREAD
>   static struct kthread_worker __rcu **z_erofs_pcpu_workers;
> +static atomic_t erofs_percpu_workers_initialized = ATOMIC_INIT(0);
> +static int erofs_cpu_hotplug_init(void);
> +static void erofs_cpu_hotplug_destroy(void);

We could move downwards to avoid those forward declarations;

>   
>   static void erofs_destroy_percpu_workers(void)
>   {
> @@ -336,9 +339,45 @@ static int erofs_init_percpu_workers(void)
>   	}
>   	return 0;
>   }
> +
> +static int z_erofs_init_pcpu_workers(void)

How about passing in `struct super_block *` here?
Since print messages are introduced, it's much better to
know which instance caused the error/info.

> +{
> +	int err;
> +
> +	if (atomic_xchg(&erofs_percpu_workers_initialized, 1))
> +		return 0;
> +
> +	err = erofs_init_percpu_workers();
> +	if (err) {
> +		erofs_err(NULL, "per-cpu workers: failed to allocate.");
> +		goto err_init_percpu_workers;
> +	}
> +
> +	err = erofs_cpu_hotplug_init();
> +	if (err < 0) {
> +		erofs_err(NULL, "per-cpu workers: failed CPU hotplug init.");
> +		goto err_cpuhp_init;
> +	}
> +	erofs_info(NULL, "initialized per-cpu workers successfully.");


Otherwise it looks good to me know.

Thanks,
Gao Xiang

