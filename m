Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0872EE644D
	for <linux-erofs@archiver.kernel.org>; Fri, 15 Sep 2023 08:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1694768135;
	bh=C3A2Q+7uqNfRFwjiJsn4cXX6VIZZN+ey242i/wnxUIM=;
	h=Date:Subject:To:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=FILhFkz85KnLOOd66t+ZJeP/5UxJwGm+paR9HDgOB0PEkXjqUiJ9zU0nO9WFGZtaf
	 wTRK70nnh1Yl6NjP4sYSfmqssbzxmiiDGvWEItHml9QiGM8vZHUNgx9KJ0Spn1OaGp
	 IQ0VjGsxJN18tmmog1y6qJAh1pkp+dW5MDeiqDEH1m1aQeCD9XmWpt2CnFwJXg6k3o
	 RI4l5XjfaH1mjuDLOmqAa4NxwFz8FQ5H6R9n9FXGxau5GQ1GDhuIZlv5YvBZoJzHV5
	 44S7gQw3eLXaf+1Bghug8v/VAtLQL7PF61IjQqrjg/8TkXWfJuqYnEphmQQmlv0OK/
	 BUTFG0V1rQH/A==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Rn7Lv3Z98z3cNY
	for <linux-erofs@archiver.kernel.org>; Fri, 15 Sep 2023 18:55:35 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=RnvITPy9;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=bytedance.com (client-ip=2607:f8b0:4864:20::42e; helo=mail-pf1-x42e.google.com; envelope-from=zhujia.zj@bytedance.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Rn7Lm3Xrfz3c27
	for <linux-erofs@lists.ozlabs.org>; Fri, 15 Sep 2023 18:55:26 +1000 (AEST)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-68fb46f38f9so1811168b3a.1
        for <linux-erofs@lists.ozlabs.org>; Fri, 15 Sep 2023 01:55:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694768122; x=1695372922;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=C3A2Q+7uqNfRFwjiJsn4cXX6VIZZN+ey242i/wnxUIM=;
        b=R/86O4TwfCcBbyo93KcAv/FMuL9mxyBDVAKHcWozjnicsRQeBICN4VKM5sri9ziTB3
         tJjoJ1wDrYsGvDGAZpAhPRslHlUIR2pXkc4OOh+p//XLl0lwvE6x4tWAhd4MMAdDiFaI
         h53LrkXzu+GOw353lKxX+Fchn9X34L51mzJgKyvedxQJPwVqE+jq9zDuXIloM2Jo4n8s
         3Us9OxVZ438lzbSMssBujWkEcqaKRCROUY3xqTMu+Ez4d+h3En2ZTV1O2BlfX0gFv33S
         DsTGvzKKr6mtogrbx8qbR7HxA+r7abqMLfCBEcU/fEgx6c3odSowPXNuPNXEpjOO4joe
         aicg==
X-Gm-Message-State: AOJu0YzWYjwNfWT/Rsl9ccxOAoXeQg6AZy9z5/kvzfB6cWU0XGbBV8cq
	n75XaeXoDwPq8XIc0Q8pbag1GH45z2k/l1DgZfA=
X-Google-Smtp-Source: AGHT+IHdwJDgJaHBC4fHlkgBshKlaeCkGnD9A9DZKRM7u6gFBjp7btOxwhf66+WH+Vqyn6cfDILPEg==
X-Received: by 2002:a05:6a21:3e0b:b0:156:e1ce:d4a1 with SMTP id bk11-20020a056a213e0b00b00156e1ced4a1mr1137534pzc.9.1694768122609;
        Fri, 15 Sep 2023 01:55:22 -0700 (PDT)
Received: from [10.3.153.195] ([61.213.176.12])
        by smtp.gmail.com with ESMTPSA id jj5-20020a170903048500b001bc6e6069a6sm2958485plb.122.2023.09.15.01.55.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Sep 2023 01:55:22 -0700 (PDT)
Message-ID: <79a570f9-b556-8083-c247-e543732316d1@bytedance.com>
Date: Fri, 15 Sep 2023 16:55:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [External] [RESEND PATCH] erofs: relax the constraint of
 non-empty device tag in flatdev mode
To: Jingbo Xu <jefflexu@linux.alibaba.com>, xiang@kernel.org,
 chao@kernel.org, linux-erofs@lists.ozlabs.org
References: <20230915082728.56588-1-jefflexu@linux.alibaba.com>
In-Reply-To: <20230915082728.56588-1-jefflexu@linux.alibaba.com>
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
Cc: huyue2@coolpad.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



在 2023/9/15 16:27, Jingbo Xu 写道:
> The device tag is not required in flatdev mode, and thus relax this
> constraint in flatdev mode.
> 
> Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>

LGTM
Reviewed-by: Jia Zhu <zhujia.zj@bytedance.com>

> ---
> Sorry I forget to cc linux-erofs@lists.ozlabs.org in the former patch.
> ---
>   fs/erofs/super.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index 44a24d573f1f..3700af9ee173 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -235,7 +235,7 @@ static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
>   		return PTR_ERR(ptr);
>   	dis = ptr + erofs_blkoff(sb, *pos);
>   
> -	if (!dif->path) {
> +	if (!sbi->devs->flatdev && !dif->path) {
>   		if (!dis->tag[0]) {
>   			erofs_err(sb, "empty device tag @ pos %llu", *pos);
>   			return -EINVAL;
