Return-Path: <linux-erofs+bounces-1142-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E98CCAC5B9
	for <linux-erofs@archiver.kernel.org>; Tue, 30 Sep 2025 08:02:09 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4cbVrw3nGvz3cZM;
	Tue, 30 Sep 2025 18:02:08 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1759219328;
	cv=none; b=gdF4Goc4j5l8+/Axa533CLqJ+L+UrwYHEZDs1rI8JV6xCaTh2hq3iD0jvh4CpaX95xr1SQvGj6IRaTxW0vHb37/8z/wB3+iHZPhiupkE0LFQWNQEI2gCFBINyCE9cM+62wtHcGoy3gcLaeo3ke163Xx1mXBjhSMwlMnjmA/WFisJxz8tjK+alPz5B2Zhuzz/jreu5TI8uE1lxSLzlM1pn4i8klD44y+nqgkg/+S2qk9FP6QXrsPf2CcXCb/TEetjtPZst1wu9qbdzh2VYX2nkqeYTTB5jPDXmb99PbgOER7SMP9AuK8kiMh8kRcwnvzucLEVvnksEABN7yNpIkXTMw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1759219328; c=relaxed/relaxed;
	bh=UZSxF/hmzD7xNIhJ4PBBJgYQsgeH8Rvo5JBlqF0JaHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=IWsLN4C8Z9St1/MYExdSZWWexcqMORn9gOj++Kdzv40D4ljeQjX8vqofqaPL9TKWRZdJ6lhI38XEciJnwFV+qoQ+PEU5SC+SK/RjvVcuYgI4VHYUHQx+7gwF9GljOViSu6n4e1fMIZ45eBpnfFOAxh11BveBsVDycOwG7UV6+3YGk2/8/o8ozPcW7Ffgmdc0IrPDfwMwpMMT6t4pw/UM33HiPDsG9WLXKoWpc74ugiZoOtIUkacN+ZLyjaaPFwTVVoSVP7w58v4G7P1xxDE7Kc8wcNxTI0EZ9vAikFJ1wzGYXLdq6R8IRKFLUEgShluYUsZYy3NmXMAenqH9XZO8nw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=t3eanrj5; dkim-atps=neutral; spf=pass (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=t3eanrj5;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4cbVrt2w59z3cZH
	for <linux-erofs@lists.ozlabs.org>; Tue, 30 Sep 2025 18:02:05 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1759219320; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=UZSxF/hmzD7xNIhJ4PBBJgYQsgeH8Rvo5JBlqF0JaHM=;
	b=t3eanrj5YmQoUJEYL1j2XeXUk6W6YYf15v2hvVlMEhgj3eOYl3I57DUY67wa6wOnS10KU93Le02mI0smIzMKwfiTl7XmsLTShJdCx5xdbhhHJJr6fyH5CFoW3ALcWh8ztASwlrVNP6nNychk+rP82orxY0UNf5cGbY7pEDabGOA=
Received: from 30.221.129.112(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WpAl.SM_1759219318 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 30 Sep 2025 16:01:59 +0800
Message-ID: <00f93f33-b42e-48e0-9e22-81e50faca479@linux.alibaba.com>
Date: Tue, 30 Sep 2025 16:01:58 +0800
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
Subject: Re: [PATCH] erofs-utils: tar: support archives without end-of-archive
 entry
To: Ivan Mikheykin <ivan.mikheykin@flant.com>, linux-erofs@lists.ozlabs.org
References: <20250929133222.38815-1-ivan.mikheykin@flant.com>
 <aNqcvDiftM3ST7Mn@debian> <c5318494-be05-452e-8f1c-626de696c0ec@flant.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <c5318494-be05-452e-8f1c-626de696c0ec@flant.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2025/9/30 15:42, Ivan Mikheykin wrote:
> Hello!
> 
> On 9/29/25 5:50 PM, Gao Xiang wrote:
> 
>> Could you confirm how docker/containerd or podman parses such image?
> 
> I confirm that images with such layers work well at least in containerd with overlayfs. We encounter problems during experiments with containerd and erofs. Also, GNU tar and BSD tar are good without end-of-archive zeros.
> 
>>
>> Because the POSIX standard says:
>> https://pubs.opengroup.org/onlinepubs/9699919799/utilities/pax.html
>> "At the end of the archive file there shall be two 512-byte blocks filled
>> with binary zeros, interpreted as an end-of-archive indicator."
>>
>> So such tar layers will be non-standard, I wonder we need at least
>> a erofs_warn() message for such tars at least.
>>
> 
> Good point. I think I can add erofs_warn() message to the patch.

Yes, please.

> 
> 
> P.S. I've noticed an interesting detail after submitting the patch. Produced erofs image reports an enormous file size after conversion error:
> 
> $ mkfs.erofs --tar=f --aufs --quiet -Enoinline_data test.erofs test-no-end.tar
> -rw-r--r--    1 user  admin  2199023255552 Sep 29 13:43 test.erofs

Yes, that is expected according to the current codebase
since it uses a sparse file to keep temproary data and
truncate when successful.

I guess we should remove the image entirely if mkfs
fails instead.

Thanks,
Gao Xiang

> $ du -sh test.erofs
> 4,0K    test.erofs
> 


