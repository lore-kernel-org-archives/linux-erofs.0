Return-Path: <linux-erofs+bounces-1937-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB731D4A5FC
	for <linux-erofs@archiver.kernel.org>; Fri, 16 Jan 2026 04:22:58 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dsmt91Wrsz2xPL;
	Fri, 16 Jan 2026 15:22:57 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1768537377;
	cv=none; b=nmLlJDrqKD3ACUijF0UgezoJnJoERgZrgE47ShZ4UtzV/C+OhU2d+qFXhCsY2jbxoKFW2AEchDrk0wvN9ys1nT5wUTF6J3cFGpYmuR1vavx4esHDPcbVx6z4fKNSOmo65UGyw/dCLiZkpw0yYUFUFq99VdSABdxsLoyppS3Jp6ohYubQiqjWDanSUQbm48WmPKUzAORjgHCR1ursFwuevuq9Id1kL8NaOdEMdz8R+aAmykntSpJu1hR4u9kQz5TPvB4ce2IB7tbcreJmvcuvrJToOzxqOwlGrNh/eRV8RROlwGYIgrm4OA67qMejzmcOtc3eq1kAOFGolIbAT6FBlw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1768537377; c=relaxed/relaxed;
	bh=qWm4mmiwab6RrWO4LC8ozqoCf1EHNfHlRe3JhfrTiW0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MWaJkeo2hlVQzGvpDmFb/v8Q0otDqCqSYx8LKMy2ZO+RIJFUoToISYTbg42Nk+hHRz4Y+ixejO2gj3rOZmzFPfFll8eMXAOLysX0McXxD7KP7uCw+cwmbyGnJVhl57LUGO6LeRoGuor/iJk+MKJt2cUak73hlFb1Dnaa1UYlgWE6QFciLq3qqY+BuaEO94cfEf35msy4fcrVTfldXWUxljbUZXV/MfTWAuhlop/pq+A+YGgOuCAoPBzW5bSioVIPdeeD5xGhtWgiwWRKxlJ1i2+f7QQcV1mCuOUM+hSfCbralBdeXYQDx+WhUehbOVrynCxou2TWQKrox231hZcQIA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Ih7lC0Uu; dkim-atps=neutral; spf=pass (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Ih7lC0Uu;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dsmt56T6Zz2xP9
	for <linux-erofs@lists.ozlabs.org>; Fri, 16 Jan 2026 15:22:51 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768537365; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=qWm4mmiwab6RrWO4LC8ozqoCf1EHNfHlRe3JhfrTiW0=;
	b=Ih7lC0Uu7IkcEIenAj3x912zA2g6HyyZM2ioVbhPW86wC0XZ+LdZINLU9dWLowQspumYGEKD60OWlt+LNxapxVJbLT3U6YfesVjlHkqcT07AYvEKWfJSQb97GE/KCSM07bomjW93mk30lPA/C+Jej4fDNUEyFEV6reHtIZKpgps=
Received: from 30.221.132.12(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wx8o1TC_1768537363 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 16 Jan 2026 12:22:43 +0800
Message-ID: <b8540497-50c2-4d4f-8025-060ae6352229@linux.alibaba.com>
Date: Fri, 16 Jan 2026 12:22:43 +0800
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
Subject: Re: [PATCH v2] erofs-utils: lib: fix incorrect mtime under
 -Edot-omitted
To: Yifan Zhao <zhaoyifan28@huawei.com>,
 linux-erofs mailing list <linux-erofs@lists.ozlabs.org>
Cc: jingrui@huawei.com, wayne.ma@huawei.com
References: <20260116040509.3674821-1-zhaoyifan28@huawei.com>
 <20260116040729.3675421-1-zhaoyifan28@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260116040729.3675421-1-zhaoyifan28@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/1/16 12:07, Yifan Zhao wrote:
> `-Edot-omitted` enables `-E48bits`, which requires specific
> configurations for g_sbi.{epoch, build_time}. Currently, the call to
> `erofs_sb_set_48bit()` occurs too late in the execution flow, causing
> the aforementioned logic to be bypassed and resulting in incorrect
> mtimes for all inodes.
> 
> This patch moves `erofs_sb_set_48bit()` forward to the options parsing
> stage to resolve this issue.
> 
> Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>

I think instead we should move this part into lib/importer.c?

         g_sbi.fixed_nsec = 0;
         if (cfg.c_unix_timestamp != -1) {
                 mkfs_time = cfg.c_unix_timestamp;
         } else if (!gettimeofday(&t, NULL)) {
                 mkfs_time = t.tv_sec;
         }
         if (erofs_sb_has_48bit(&g_sbi)) {
                 g_sbi.epoch = max_t(s64, 0, mkfs_time - UINT32_MAX);
                 g_sbi.build_time = mkfs_time - g_sbi.epoch;
         } else {
                 g_sbi.epoch = mkfs_time;
         }

I mean adding `mkfs_time` in `erofs_importer_params`.

Thanks,
Gao Xiang

