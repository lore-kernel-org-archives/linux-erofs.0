Return-Path: <linux-erofs+bounces-3948-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28E82C44529
	for <linux-erofs@archiver.kernel.org>; Tue, 21 Jul 2026 13:28:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h4J9X3h5vz2xqJ;
	Tue, 21 Jul 2026 23:28:16 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784640496;
	cv=none; b=QFLjIRKySo9AfO8NqavV3QxTwsJgOc5FGxX/Z6j791YLEdj4rn2+Zg2Q9aGbMZyK5ZTQNoHO3g78cg49TGlbvEiC6YUVv6YJ6nbQ5hv5sMy8yhOqyXhLjy6yzhkCye+asNRqhzs8fQIXD+J88oKoBMuYxmgoUhxCjzqAvEYS7t7vaSl83naygsJht5DTLn6vYOyCYY2Wkjy9hPkwMid05XbjMdbF0JrZMb7ide5bpJausXsVk/FxqbUC1z5+sY8KSlr6cXS0Z+DcRN5+JyxPG6J+XtThn9nAh07yiqeSnQtVKjVZjdyYcOyZHY+62i3JesGqIzg6yDZByJOsHaH2SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784640496; c=relaxed/relaxed;
	bh=OwvNN2QciO5oZt+L5VytYOSJfzRjvp+jR57EzAwBL18=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nglxNUSGt6UyDTisj3MeTFngMkwTcKPNE7tjnNeR2HGFuKt1rFbVvMKQDS0bTEXK6QMOMPA19rqKFhqTVBVzWdEwYZNgVXF7G+dve2mvvTm6pwuQNIHWXPllnZfY7LVnF/SXHJt9pthcTBYPRsRhG+qGwRuf9MBfS6WHnORFKKuWD+dDlBz8+PchtJfjDziwwsRQ+G/qA+2RGqI20isptKS4WhzCrZuUq710PwsXi7cqiVMwl2nz6S5TPjP6Rlk6sWWj1N4l2vBZUmo/2DzO4H8vB8jy0usxspcbLegF+RG5Yhk2WxJg7cLNCIz+7Zwn3aSUE44C4S/28tzhfb44kg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NX5fogeq; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NX5fogeq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h4J9W2TCMz2xm3
	for <linux-erofs@lists.ozlabs.org>; Tue, 21 Jul 2026 23:28:15 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 052EF405AC;
	Tue, 21 Jul 2026 13:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911141F000E9;
	Tue, 21 Jul 2026 13:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784640491;
	bh=OwvNN2QciO5oZt+L5VytYOSJfzRjvp+jR57EzAwBL18=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=NX5fogeq+nNZSiTvj6kmfuc2VIMIegmF5qOQkYqMIYWWrRIJx8gj+rBZbLDkJJ0Po
	 Ej5zKoBA7bX7bs1PUYO8+UaJSDckydh/S1gMfSJq20ki5OFlYpdFoTYFWDekl8EQtS
	 Jd0dNZuTYMSGCfls8o+FqGXhKXFrZ1qEJXC+a6Vn1q+hJna1nw0JmJWDiN8H2lzYRP
	 fO+nxAPdDhhs/DIy9DFIR/auHZVDvpeFIrPppUv4L6PwcVoW0CxRRnsa84eL3slGLw
	 D7PkrC6Agz6KpwVfhg5UjhL6O6Ng0p/kPuwjKl9vyLUJVVL4AeMo1bz155YEfu8c5N
	 Q5+w4ze6oJ6sA==
Message-ID: <87f7f2cf-b482-44eb-9cd3-94f809319e42@kernel.org>
Date: Tue, 21 Jul 2026 21:28:08 +0800
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
Cc: chao@kernel.org, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, hongbohbli@tencent.com
Subject: Re: [PATCH] MAINTAINERS: update Hongbo Li's email address
To: Hongbo Li <lihb2113@gmail.com>, hsiangkao@linux.alibaba.com
References: <20260721070518.2016441-1-lihb2113@gmail.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260721070518.2016441-1-lihb2113@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/26 15:05, Hongbo Li wrote:
> From: Hongbo Li <hongbohbli@tencent.com>
> 
> Since the original email account is no longer in
> use, I have updated it to my current email address.
> 
> Signed-off-by: Hongbo Li <hongbohbli@tencent.com>

Acked-by: Chao Yu <chao@kernel.org>

Thanks,

