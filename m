Return-Path: <linux-erofs+bounces-222-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E570C369CB
	for <linux-erofs@archiver.kernel.org>; Thu, 24 Apr 2025 01:50:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Zjf7D4XVgz30Ss;
	Thu, 24 Apr 2025 11:50:16 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=45.249.212.188
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1745459416;
	cv=none; b=idFs3kbnFsoLUI20IrmYMRrARQGzsBM2XSUiUOskCwEeHBp4V+ueovph59BzPozTj2z4mWQCOyTbZp6CDE+8IsMBA1anWcE+ZhhKcBc1SK9F++QjLB+Wp7cbYpgRSkZaTwKCKtJkiX210dqTQZbmYr0Siufeh/hOhfY2HjZ/Z5UBggmOvxkMFXTUUB9PjaKH/zHyfSPd75KdaflyqDXdC5+4FrcHWBJsqGjVyb0UuojFBolVN3ctUSBPgYPEO9PaVcK4PjtZeNrGk3NPof6vvye1c7JAYOMGf23E0lCiXJazecbIJfCa3P+LCnFVhLtZFFBlyjRBAOO3WiGd4PjWaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1745459416; c=relaxed/relaxed;
	bh=4tN9PpTaqqlGObQC3+rkqPTDO0SClIczPQpAY7NDzhc=;
	h=Message-ID:Date:MIME-Version:To:CC:From:Subject:Content-Type; b=VIhZjDUdCbZkES0PIUXgaM7HCbg2/X+d7adWP4S0j6qTUAiTNcmQsyDX4jH6USgaOhccSeg+vW6vnkUDQhYTEsHsX1tsTJjlj8w3bWwRi4QiQUcpmHanQr6n47x4+ktY8loUIKbh+lAWVu9XaV3quqVpB9DOucvPTKgy9ZAwJbFHRzeQwIKTnVjtEx0yIN+ISl0pXj7mO3w8pSZgowput8WXMQAniYruGsFqdhDZhc99r7jq1SKp/F6DFHmfo+zQ07oa4UGCDPCG/Y4WCwcXOHayFYQS8hPT6FTjedd60PDViU/qVGA9arFaE1lebqJmz+GXJAw8nnj1/pdLSqtN3A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass (client-ip=45.249.212.188; helo=szxga02-in.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=45.249.212.188; helo=szxga02-in.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Zjf7B5nLMz2yZS
	for <linux-erofs@lists.ozlabs.org>; Thu, 24 Apr 2025 11:50:12 +1000 (AEST)
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Zjf5W14hSznfVp;
	Thu, 24 Apr 2025 09:48:47 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 0CF831402C3;
	Thu, 24 Apr 2025 09:50:08 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 kwepemo500009.china.huawei.com (7.202.194.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 24 Apr 2025 09:50:07 +0800
Message-ID: <50dc6bdc-ee62-41f1-b8e5-be64defb07c6@huawei.com>
Date: Thu, 24 Apr 2025 09:50:06 +0800
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Sandeep Dhavale <dhavale@google.com>
CC: Gao Xiang <hsiangkao@linux.alibaba.com>, LKML
	<linux-kernel@vger.kernel.org>, linux-erofs mailing list
	<linux-erofs@lists.ozlabs.org>
From: Hongbo Li <lihongbo22@huawei.com>
Subject: Re: Maybe update the minextblks in wrong way?
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.104]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemo500009.china.huawei.com (7.202.194.199)

Hi Sandeep,
   The consecutive chunks will be merged if possible, but after commit 
545988a65131 ("erofs-utils: lib: Fix calculation of minextblks when 
working with sparse files"), the @minextblks will be updated into a 
smaller value even the chunks are consecutive by blobchunks.c:379. I 
think maybe the last operation that updates @minextblks is unnecessary, 
since this value would have already been adjusted earlier when handling 
discontinuous chunks. Likes:

```
--- a/lib/blobchunk.c
+++ b/lib/blobchunk.c
@@ -376,7 +376,6 @@ int erofs_blob_write_chunked_file(struct erofs_inode 
*inode, int fd,
                 *(void **)idx++ = chunk;
                 lastch = chunk;
         }
-       erofs_update_minextblks(sbi, interval_start, pos, &minextblks);
         inode->datalayout = EROFS_INODE_CHUNK_BASED;
         free(chunkdata);
         return erofs_blob_mergechunks(inode, chunkbits,

```
This way can reduces the chunk index array's size. And what about your 
opinion?

Thanks,
Hongbo

