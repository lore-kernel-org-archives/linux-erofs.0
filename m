Return-Path: <linux-erofs+bounces-2808-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8517BFED9EA
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Mar 2026 16:10:54 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZxlK0GZlz2yhV;
	Wed, 18 Mar 2026 03:10:53 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773763852;
	cv=none; b=E81x9HqTebrzEnwIRtjnzo6xha3a5lgDDxmM6Z1ei9ThCYm5BbCVrW7w5X7NVDygLLCiSeNFIuKfLg3kFE5j6eLPZkG2USNw+snrcKqUAwpXMMHZn8mFLTa3m5JgRWvWJ69C679jyhHHyonEP2Ar5MTu4W0U0opvagSDqK/aJzJzvtjhJa+6erZf4GG6Bndg9gi27OZ2YXj7u5OY7TAPyPmElRSiU7sxC3ne48oojrxQHDuLLY7XmPN8ZloFZjUI057z/hWci0fL4sIs49/sM2SS14vkFoK25honZNa6/pta1nnHhs7ef0IqmnZeqM1zRD0QAyaDCoBlfjkJDxgAmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773763852; c=relaxed/relaxed;
	bh=yT9B7syCuF6JdXe7xjWZQufmR34xFJzO4znY8Ol0NDI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qq7SDq1vEKxC2LeiuwuLeifjcXnQXumBD66SaGDOnE5NuylCC4BNPOp+N7Ze9aMekxRXzyEAT2zIJpp/XiQ8yAo032lJ+obk1+UGMoudfFQ16S/oCeB6KttqiX3Vfm7nx7GJDNPUL5NpYCnLPugnY4G8p3AxCKPaBL+bTF4cGF6j5L4rzsldJkTiNFAExPBxmssj0jpxTEfAvpong/ClWdO/CymTvefapMzA3ttJC4VeUjNxF2tIa7E5CVf2j4FlKy+MAw3LqSn+QcTyGHzHyE4U/69AtJx4vX5jAxSIrGQftMpAt7hI/tKuizpgLYDP/peoIIDLUhSIfNoQ2vDAOw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=AaJAAW3N; dkim-atps=neutral; spf=pass (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=AaJAAW3N;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZxlH0H8dz2yFd
	for <linux-erofs@lists.ozlabs.org>; Wed, 18 Mar 2026 03:10:48 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773763844; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=yT9B7syCuF6JdXe7xjWZQufmR34xFJzO4znY8Ol0NDI=;
	b=AaJAAW3NH4+AXZhaLhZjvPz88V35MgdRqnoIV38+fijRGpk9BMeeQiqHJ5pM7Xr0FMDjW2FgqRiQ/SuImhuyDa3xFt0x9dk/7mECiCckzjD1hDFEN50gl9LOYrNA5reKs2TCw/kcDxMsnmN8P9tzcXzozt0WUBrky9Q3qfPK2Qw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X.BVdQe_1773763843;
Received: from 30.170.14.2(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.BVdQe_1773763843 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Mar 2026 00:10:43 +0800
Message-ID: <635b6c28-36d6-4301-9cb0-7f81745aebdf@linux.alibaba.com>
Date: Wed, 18 Mar 2026 00:10:42 +0800
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
Subject: Re: [PATCH v2] erofs: harden h_shared_count in
 erofs_init_inode_xattrs()
To: Utkal Singh <singhutkal015@gmail.com>, linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org, yifan.yfzhao@linux.dev, linux-kernel@vger.kernel.org
References: <20260317152439.5738-1-singhutkal015@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260317152439.5738-1-singhutkal015@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/17 23:24, Utkal Singh wrote:
> `u8 h_shared_count` indicates the shared xattr count of an inode. It is
> read from the on-disk xattr ibody header, which should be corrupted if
> the size of the shared xattr array exceeds the space available in
> `xattr_isize`.
> 
> It does not cause harmful consequence (e.g. crashes), since the image is
> already considered corrupted, it indeed results in the silent processing
> of garbage metadata.
> 
> Let's harden it to report -EFSCORRUPTED earlier.
> 
> Signed-off-by: Utkal Singh <singhutkal015@gmail.com>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

