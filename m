Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46F1AD41D41
	for <linux-erofs@archiver.kernel.org>; Tue, 12 Nov 2024 01:06:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4XnSsb5XzFz2yhg
	for <linux-erofs@archiver.kernel.org>; Tue, 12 Nov 2024 12:06:11 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1731373570;
	cv=none; b=O9228jF33iLjWH8l3FBvfW0/QQdtM6uGlF991TgRlQP33tVMX0CNN03akF/vo+HhI8Pr1ZIvWFndl+oBgOmqEF1imp+cHKhd6Y4OFJbMjsLQsvKleM5zGCuoNKK0NwkUbOGxkIvuDUCJsryV/6/ttVR1VmfngrSxWy/J903C3aChxeXpq3jT2I1e/Fnle/tIYKxO4SwlQVMhwkEhFzxasnHTxnMxywv164m27/5Gi6WvD0WgGLjIr6Am5oTQvpYLHiC/+bqGHll9HhO1g/fJ4kzLa/iDRkVzbrottKmAHeFdveV7/q4kcJYAg9iHrL+EVoMZV0CHxWECXRHNuExThw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1731373570; c=relaxed/relaxed;
	bh=rrc1oKb01rK1vEbuHPVJOa+h96ngQQ/gq2O/ooStszo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VMMrVSzUXfLjgBRcgv+scLWpEP2puPPIsAMNRNdvgkz8Cu3ZHcE2X8WxlaYuNJBxOkisHmHHXaVvCGGe7avZJwVN/7cyAC5DnwWYJdqSBDEPZgD7rDnwEE3sHi3QoITSBcYza4ZPpQ2XNOl4lXNXG5dnKSn8fDfjbG277UB8APDSc/T1pksjgkAk28YatifxcgUUmTm74AilykhU7fnM/BXYvF8jpOwH3nBWPu6zH30LNM2IhVl8hn6Gt1uy+ama1YiStfSP3xdf2QycCJO7oqgEW+YuAzhQbSLF5tZBofqE8v8Ep+wtYWeqKJyWnPMjWzpvrTO7c0jURMjCunYD8Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=d/hxC6Rp; dkim-atps=neutral; spf=pass (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=d/hxC6Rp;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4XnSsY3QSvz2xfR
	for <linux-erofs@lists.ozlabs.org>; Tue, 12 Nov 2024 12:06:08 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1731373565; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=rrc1oKb01rK1vEbuHPVJOa+h96ngQQ/gq2O/ooStszo=;
	b=d/hxC6RpKaHy4hrf+hWSJ6zaYB5QJ8O+fKj+v055drPPUZamJ6T+e5OD71n5V7M6faeAC/P2YYCG10rRGJwZtlC264jjVCg03Ge7DJ6TXMKxXkpHAHZ0XxWMrPRSBAaQzqhHRb7m6pj5fC9+gP9P1xJsLW/x1VV7pySoDn0OkB0=
Received: from 30.221.128.202(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WJExm9j_1731373563 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 12 Nov 2024 09:06:04 +0800
Message-ID: <9cdf389d-75a0-4529-a96f-23a4f2bcd4ee@linux.alibaba.com>
Date: Tue, 12 Nov 2024 09:06:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] erofs: add sysfs node to control cached decompression
 strategy
To: Chunhai Guo <guochunhai@vivo.com>, "xiang@kernel.org" <xiang@kernel.org>
References: <20241101124241.3090642-1-guochunhai@vivo.com>
 <0fa61236-e84b-4a3d-9804-612b33d166da@linux.alibaba.com>
 <e1b73e98-496c-4d39-b8b0-232cffa266ec@vivo.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <e1b73e98-496c-4d39-b8b0-232cffa266ec@vivo.com>
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
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "huyue2@coolpad.com" <huyue2@coolpad.com>, "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2024/11/11 19:10, Chunhai Guo wrote:
> 在 2024/11/11 10:28, Gao Xiang 写道:
>> Hi Chunhai,
>>
>> On 2024/11/1 20:42, Chunhai Guo wrote:
>>> Add sysfs node to control cached decompression strategy, and all the
>>> cache will be cleaned up when the strategy is set to
>>> EROFS_ZIP_CACHE_DISABLED.
>>>
>>> Signed-off-by: Chunhai Guo <guochunhai@vivo.com>
>> I guess remount could also change the decompression strategy?
>> Or there are some other concern that remount is not usable
>> for your use cases?
> Yes, remount can change the strategy. However, the cache will not be
> cleaned when the strategy is changed to EROFS_ZIP_CACHE_DISABLED. I will
> make another patch to address this during remount. Thank you for your
> suggestion.

Sounds good to me.

Thanks,
Gao Xiang
