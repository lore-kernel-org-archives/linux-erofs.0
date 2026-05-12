Return-Path: <linux-erofs+bounces-3403-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 813FCCD4F26
	for <linux-erofs@archiver.kernel.org>; Tue, 12 May 2026 07:33:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gF7cK5hKQz2ygG;
	Tue, 12 May 2026 17:33:21 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1778571201;
	cv=none; b=egzvvXvAiBCqwcjApmqpHAOFueoCjS5BK5WTduXuYvdoUQARWBuZP6AnItqrcIsxK4D4m1PNGj3SNC/3kNpvKF9hFL91Q0jv5Axs1QNfla5kYCvs0xlECfX5+OvxeXhZh2Rh5f+HJgt5QCspaOAcq1TmDEpJBaqW/1Ql1g+ecbWzTxK42eBSnzefZTt2uOf1u5zvrTybGceRtOnvFD9sgNc4uwoxSldHDTCYH8rkWhuImmruqqGT504Dbfd9z6kNBkDBki8x3vIu5kyc3ZfQQ/19+v7JzgS9JMY9U/IkQ9LbUYa7+/6xD/Zw3sGJ64Bbym9h+m8GrinOP4LppFdy0w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1778571201; c=relaxed/relaxed;
	bh=KilzlgYdXvQP1EF5iW6ehOR1n8vPeCFyMZcdoC2ZPQ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gbdvHNzrIJnAMlgHcX3tVoYoW7IzA840MgJwYXDqNI2Rtt1T4YHqe0SQM6JuQ16xPVlNIVbexRhrZV3NV6zmZvwRlKnRaSDlunf+b4rQxpHsg7Y6mzJFnVRiU+lZihEXMNsXOaNJZ2itJxmP/godDia8jP2vc4s0cVQ6fJLUgl6UZ1AjC/VGU56l86wOuo0XDnABxDXLu1sNtuwGFrWilDFT3ujqe+pyzMWG7jTpMMor9E1fmrYRRg0zYhPE/FW1C+9Sxdmuw3a4xylJl09JJzUedRVSyfYIDwyn4SUqQgyIApbIUTaRO469DbHLFCJsQzpdXS6h8kq6GWyrG4fGSA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=kTlZKDMM; dkim-atps=neutral; spf=pass (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=kTlZKDMM;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gF7cH1t40z2yb9
	for <linux-erofs@lists.ozlabs.org>; Tue, 12 May 2026 17:33:17 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778571193; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=KilzlgYdXvQP1EF5iW6ehOR1n8vPeCFyMZcdoC2ZPQ8=;
	b=kTlZKDMMKYSQIkfG8ZvCrdTGiKww4una3Wm9OOeDpJCbyv2yP9OK4/sU65PgkuA59aAZ5fLVMgffqY0iCU5hDvV3Ubbeah0JkPdu359LYzBIAOi8njtXTCwvxCJ5xHKCrBB0OGAomjwBYdRrtcwPJp1gobGHpvibXoH3Ua3gHnc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X2pmzEB_1778571189;
Received: from 30.221.130.241(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X2pmzEB_1778571189 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 12 May 2026 15:33:11 +0800
Message-ID: <d759a7f6-b273-4a3b-b686-3ff48ccd7150@linux.alibaba.com>
Date: Tue, 12 May 2026 15:33:11 +0800
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
Subject: Re: [PATCH 2/3] erofs-utils: lib: reject packed inodes in metabox
To: Yifan Zhao <zhaoyifan28@huawei.com>
Cc: jingrui@huawei.com, zhukeqian1@huawei.com,
 linux-erofs mailing list <linux-erofs@lists.ozlabs.org>
References: <20260512071631.969752-1-zhaoyifan28@huawei.com>
 <20260512071631.969752-2-zhaoyifan28@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260512071631.969752-2-zhaoyifan28@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/5/12 15:16, Yifan Zhao wrote:
> If packed_nid carries the metabox NID bit, loading the packed
> inode first redirects its inode metadata lookup through the
> metabox inode.  Initializing that metabox inode can then read
> metadata that refers back through the packed inode, forming a
> recursive packed inode -> metabox inode -> packed inode path.
> 
> Reject such images while parsing the superblock, matching the
> format rule that the special packed inode itself is not stored
> inside the metabox.
> 
> Reproducible image (base64-encoded gzipped blob):
> H4sIAAAAAAAAA2NgGAWjYBSMVPDo4dcHrY0KwsxANg8jAwMLFjVMSGzPx/7Lzj3zXb3jSFTh
> 5iN7v6CrbQSa8f8/gq8GoRpARHErYxYDEh8EVAm4jw2Il4AMFYDoB7IYmDGVNRhAzf8PBMh+
> yEjNyclXKM8vyklRIILNRcA5o2AUjIJRMApGwSgYBaNgFAxpAGorv3VkYtBgQLSfQW3sF8wv
> kJvZDSqIXkCDKpANlWxQZ2Bk0NPTS8RlPkgXqP0Oa5/DxNDNB7XvR8EoGAWjYBSMglEwCkbB
> KBgFo2AUjIJRQBsAAEZO6n4AIAAA
> 
> Assisted-by: Codex:GPT-5.5
> Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>

Can you fix the kernel instead first and backport to
erofs-utils? like below,

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 802add6652fd..d1829262c06e 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -337,11 +337,12 @@ static int erofs_read_superblock(struct super_block *sb)
                                              metabox_nid))
                         goto out;
                 sbi->metabox_nid = le64_to_cpu(dsb->metabox_nid);
-               if (sbi->metabox_nid & BIT_ULL(EROFS_DIRENT_NID_METABOX_BIT))
-                       goto out;               /* self-loop detection */
         }
-       sbi->inos = le64_to_cpu(dsb->inos);
+       if ((sbi->metabox_nid | sbi->packed_nid) &
+           BIT_ULL(EROFS_DIRENT_NID_METABOX_BIT))
+               goto out;

+       sbi->inos = le64_to_cpu(dsb->inos);
         sbi->epoch = (s64)le64_to_cpu(dsb->epoch);
         sbi->fixed_nsec = le32_to_cpu(dsb->fixed_nsec);
         super_set_uuid(sb, (void *)dsb->uuid, sizeof(dsb->uuid));

Thanks,
Gao Xiang

