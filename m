Return-Path: <linux-erofs+bounces-710-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87F0FC87FCE
	for <linux-erofs@archiver.kernel.org>; Mon, 28 Jul 2025 05:34:10 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4br6bj0j3sz307K;
	Mon, 28 Jul 2025 15:34:09 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1753680849;
	cv=none; b=SRrWXLVtW3SkqAMFgLBkvqjTm9JyMNY9MvVmXsDK8cKMEePnpGkP8rqTVMdoVhjqm0F9Pw5uXWxjVKMEcJR85WSwtSVmBsDI1MiCatwaMlEddYNBxAcEIPY41kWclX6bPEKYLv5g0chmuo2vGBBIHQ+Py7rNTdNhZnJLQ5/Ea71e/Y2u9I8Av6TgkqAPS2Kem610C/I34Do28l/5MEEVvGTPfHEkuSo2fCYmIIW0kyJToyo6KiosK+M53UZAtRUZw7UT/V8xSbISF0x4VVM1J7dfdOiWZ/8IgpF3w/hH5GrJ641WAoQco1HGOWC02buVXwEFCVc+XbTkOsqQCmozvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1753680849; c=relaxed/relaxed;
	bh=anVUP8qLaAisZL4VT8e0DR55l+wtSiKxSnPQcHIUmxg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EvEV0Ol+g5ISwZ+d+bzfgsqIO9wAtgLUiWin2Iyx+0SfUuwf1vz0n89wSfL9JBI7q+WPgLcJHOJU6a9KGEc2AcXSjZgFcdTbpIxJvxre3jWlDWg83UZXm/b2Mseiy1l4iTZ3AWgxyoUs7CK55KaMdyaZxQ1FqV81gj8HXFQBSBlP5cGdXydDScy89TKA/K4nj42GGLQUUUzNGfOriGTTk6BX4jGrpptZKGS4PWaN6eYM+EABxQhxgmyE9ZvZIRaR6ocCZp7jwTBPYFGQychoH7G2JZYJzUd36CvCJtZ82usUqVLnF0I7QVmZbSmycpXqA+916OimQ7pFYOfCaC732w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Mz8qB9Kz; dkim-atps=neutral; spf=pass (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Mz8qB9Kz;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4br6bg2Bfhz2xRq
	for <linux-erofs@lists.ozlabs.org>; Mon, 28 Jul 2025 15:34:05 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753680841; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=anVUP8qLaAisZL4VT8e0DR55l+wtSiKxSnPQcHIUmxg=;
	b=Mz8qB9KzRhkrEdRQeHosSEEQZuipaKwhAlgeMelsqmKQqHWKVhjSz1Klpd0o3WMF1cBJug3cqBIfOxobdimd7oma/x4q4UFrUfr8T/XlxxjaGojadaU+gIpKN7GXPkpORbs3oz1kFNcQ3aq3LYr94eEExhAbxHb5wyHdFcvk0/M=
Received: from 30.221.131.28(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WkD.KPR_1753680838 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 28 Jul 2025 13:33:59 +0800
Message-ID: <bf8d975a-606d-4bed-ad96-a848611d7caa@linux.alibaba.com>
Date: Mon, 28 Jul 2025 13:33:58 +0800
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
Subject: Re: [PATCH v2] erofs: Fallback to normal access if DAX is not
 supported on extra device
To: Yuezhang Mo <Yuezhang.Mo@sony.com>, xiang@kernel.org, chao@kernel.org,
 huyue2@coolpad.com, jefflexu@linux.alibaba.com, dhavale@google.com
Cc: linux-erofs@lists.ozlabs.org, Friendy Su <friendy.su@sony.com>,
 Jacky Cao <jacky.cao@sony.com>, Daniel Palmer <daniel.palmer@sony.com>
References: <20250728045409.1678099-2-Yuezhang.Mo@sony.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20250728045409.1678099-2-Yuezhang.Mo@sony.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2025/7/28 12:54, Yuezhang Mo wrote:
> If using multiple devices, we should check if the extra device support
> DAX instead of checking the primary device when deciding if to use DAX
> to access a file.
> 
> If an extra device does not support DAX we should fallback to normal
> access otherwise the data on that device will be inaccessible.
> 
> Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
> Reviewed-by: Friendy Su <friendy.su@sony.com>
> Reviewed-by: Jacky Cao <jacky.cao@sony.com>
> Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

