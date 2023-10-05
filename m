Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B366E92727
	for <linux-erofs@archiver.kernel.org>; Thu,  5 Oct 2023 18:43:50 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=O4bE6FB4;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4S1gSP0vbCz2yVd
	for <linux-erofs@archiver.kernel.org>; Fri,  6 Oct 2023 05:43:49 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=O4bE6FB4;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=145.40.73.55; helo=sin.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4S1gSD5cNgz2yVL
	for <linux-erofs@lists.ozlabs.org>; Fri,  6 Oct 2023 05:43:40 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sin.source.kernel.org (Postfix) with ESMTP id 4C205CE23D0;
	Thu,  5 Oct 2023 18:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F83C433C7;
	Thu,  5 Oct 2023 18:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696531417;
	bh=lchUuJLrFsc8/TMgoB73Wh7n7W4z8E63wQO7H0+zvY4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O4bE6FB4vb+otwv+hpYSWK98SEiA225v6ahDboy2r4yamQzuJyCU8Y74sOB3N+agv
	 roVyN0mOQeK5s8Elz0YRH+lkn0YCUWjngBqp5QHHW8AA2EsW18buMnTWOzQtjNdyNV
	 uV+wVItqn0jkaYLjJsUM1oTx0NYBFgLu+NbK769hDtair+CblnZtZ4iDTe4wW+ERTo
	 396Ty3Fv7/EmLvXXvXom3GmKOeX45/Zg2qx8L0Tpjha9vEtPMKOqRwSbyLRxTZZLg4
	 FQCgZ+FNOqJsa6ct0ov7bFYG2xyDeOpX0JNZAzY5p8UVu6/lcVj4Vdnjynn+T+28wU
	 81uDQ9l/XWaDQ==
Date: Fri, 6 Oct 2023 02:43:29 +0800
From: Gao Xiang <xiang@kernel.org>
To: Erik =?utf-8?Q?Sj=C3=B6lund?= <erik.sjolund@gmail.com>
Subject: Re: errno is set to a negative value in lib/tar.c
Message-ID: <ZR8D0ara6HGoH1aB@debian>
Mail-Followup-To: Erik =?utf-8?Q?Sj=C3=B6lund?= <erik.sjolund@gmail.com>,
	linux-erofs@lists.ozlabs.org
References: <CAB+1q0Q3+7s1Lt8uW6DWZ7vfjhEKhG7O7MAQhCuH-C10cr9F4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB+1q0Q3+7s1Lt8uW6DWZ7vfjhEKhG7O7MAQhCuH-C10cr9F4g@mail.gmail.com>
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
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Erik,

On Mon, Oct 02, 2023 at 07:36:08PM +0200, Erik Sjölund wrote:
> Hi,
> Does this patch make sense?
> (I thought errno should be set to a non-negative value)
> Best regards,
> Erik Sjölund

Thanks for the patch.

I'm on vacation, sorry for late reply.  It looks good to me,
I will address it when I'm back.

Thanks,
Gao Xiang

> 
> diff --git a/lib/tar.c b/lib/tar.c
> index 0744972..8204939 100644
> --- a/lib/tar.c
> +++ b/lib/tar.c
> @@ -241,7 +241,7 @@ static long long tarerofs_otoi(const char *ptr, int len)
>         val = strtol(ptr, &endp, 8);
>         if ((!val && endp == inp) |
>              (*endp && *endp != ' '))
> -               errno = -EINVAL;
> +               errno = EINVAL;
>         return val;
>  }
