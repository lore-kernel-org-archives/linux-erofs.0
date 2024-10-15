Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7340ECFC263
	for <linux-erofs@archiver.kernel.org>; Tue, 15 Oct 2024 03:48:30 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4XSKnn1DtSz3cGt
	for <linux-erofs@archiver.kernel.org>; Tue, 15 Oct 2024 14:48:29 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.118
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1728964106;
	cv=none; b=T54AMzMwgbc6yHO3M+xE/FqTpWW0femrKxgcX++cnrIiFpqR0iSkbJFgYuk8pBiMm2UrLiyGnkx3tX8q/lXrsv86teX6kVXj0vGIxmCA3md89vL41ZLzYB6by6M3873PJxAH5iutfOQPNT/UYm2sLbgkh+Gqy4Lpujpz+0ofYb8p7Qjfqx32e73GDhO/GZ1FX645lCLeR8GuXdXUU79XvssHbDrz9a3zaUmgMRWHvptv0t3Fehp/lsrj2bg76GivrzRvhq9NLaEJ9LOb2UYOyLnNk+WTY9N6wZRcQOb04KFsfOeUgKz070MJsohLl/2/rJjcb9w7YTJqQZpHMwR9Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1728964106; c=relaxed/relaxed;
	bh=0jJcnLLUB4sfrF659g9g3wDut6/5vw1xqDVGRBp97v0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BjnPFG5CjWnyhEYStHqq289/o0cI369AYnOMz0fR/eTfr9OFdKsEgDdy+nlRJUHshCqUUY2rBVn4cQJ2RzJX3kI3gLfUBCS7VOA2Zl6W0Bbr/Srj7DYP486Zt/mEXle6LqK1fNtU0c6YGCD/JU5KZvESjbW7j9W7C5r8VufkDXgU6vV7Xbg6T6Z4nmpAyQFGyEYwe2Uu4hoXN5a+5WfyTtlF48lrS4qquwCppBZd0jNboqDQ2cGnEp6DAgqMyy9xaDo15tFpUL6o5nag4Z8E4+A4hVGVQ5Oc0QAnPauU43wt3RvUvLDv66YUDXsI8Toyn9qVB0zWShQi7PJpmUiM6g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=mMDhKeky; dkim-atps=neutral; spf=pass (client-ip=115.124.30.118; helo=out30-118.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=mMDhKeky;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.118; helo=out30-118.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4XSKnj5PZHz2yNR
	for <linux-erofs@lists.ozlabs.org>; Tue, 15 Oct 2024 14:48:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1728964101; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=0jJcnLLUB4sfrF659g9g3wDut6/5vw1xqDVGRBp97v0=;
	b=mMDhKekyb3uBU9BcqcD8qey/xmGx9Xcljs8vOtLGokOfXo1P/CuhSCHiv4/hcRJXZEYi0kJNRlt8xt2lSItndvObs7SFqaSzFOyaecfVc4z2ELRDjJoOw2LWm6dMZgJOwu4dgn5NsI7iTyrN5Sx5x2B4Infb9mmiXP5Gt0DaqgI=
Received: from 30.221.130.176(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WHBmK37_1728964100 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 15 Oct 2024 11:48:21 +0800
Message-ID: <ca1304e4-10ae-4721-9e61-5e8274743234@linux.alibaba.com>
Date: Tue, 15 Oct 2024 11:48:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] erofs-utils: tests: add test for file-backed mount
To: Hongzhen Luo <hongzhen@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
References: <20241014150359.2185347-1-hongzhen@linux.alibaba.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20241014150359.2185347-1-hongzhen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2024/10/14 23:03, Hongzhen Luo wrote:
> Test for the file-backed mount feature.
> 
> Signed-off-by: Hongzhen Luo <hongzhen@linux.alibaba.com>

I think we need to run all previous tests for file-backed mounts,
and it's my previous mount helper for testing.

#include <sys/mount.h>

int main(int argc, char *argv[])
{
         return mount(argv[1], argv[2], "erofs", MS_RDONLY, argc >= 3 ? argv[3] : NULL);

}

Thanks,
Gao Xiang
