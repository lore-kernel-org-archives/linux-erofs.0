Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCAD9C3DA5D
	for <linux-erofs@archiver.kernel.org>; Tue, 23 Jul 2024 02:08:48 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=inh7HEy4;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4WSgYV5QQCz3cWY
	for <linux-erofs@archiver.kernel.org>; Tue, 23 Jul 2024 12:08:46 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=inh7HEy4;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4WSgYM3ZkYz2ysd
	for <linux-erofs@lists.ozlabs.org>; Tue, 23 Jul 2024 12:08:37 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1721700512; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=1+xQllHGN2S5o1yzISAzY9G6oWxVPNfB20OtuGws4Pk=;
	b=inh7HEy4SmAPe7Wsy7DVGK+r/Jkd1hHAtay+mmHdtFvaFf9G1e7QzHMp3U00Kitz6febINgvGgnQKj4C07CQ2/MC8A5lb1Da7Z9ANO/UgjmyVRwfwRviv7eCtMyXp3Zoq6CmXRoM6EWWZx91MyNvlcmTMpX/p9exxtgIKNPAZL4=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032014031;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0WB7UUaR_1721700509;
Received: from 30.97.48.189(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WB7UUaR_1721700509)
          by smtp.aliyun-inc.com;
          Tue, 23 Jul 2024 10:08:31 +0800
Message-ID: <65bcdc34-c66b-4ccf-b04f-892c671d1e94@linux.alibaba.com>
Date: Tue, 23 Jul 2024 10:08:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v3] erofs: add support for FS_IOC_GETFSSYSFSPATH
To: Huang Xiaojia <huangxiaojia2@huawei.com>, xiang@kernel.org,
 chao@kernel.org, huyue2@coolpad.com, jefflexu@linux.alibaba.com,
 dhavale@google.com, yuehaibing@huawei.com
References: <20240720082335.441563-1-huangxiaojia2@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20240720082335.441563-1-huangxiaojia2@huawei.com>
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
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2024/7/20 16:23, Huang Xiaojia via Linux-erofs wrote:
> FS_IOC_GETFSSYSFSPATH ioctl exposes /sys/fs path of a given filesystem,
> potentially standarizing sysfs reporting. This patch add support for
> FS_IOC_GETFSSYSFSPATH for erofs, "erofs/<dev>" will be outputted for bdev
> cases, "erofs/[domain_id,]<fs_id>" will be outputted for fscache cases.
> 
> Signed-off-by: Huang Xiaojia <huangxiaojia2@huawei.com>

Thanks, applied.

Thanks,
Gao Xiang
