Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5647CC54E5D
	for <linux-erofs@archiver.kernel.org>; Tue, 19 Mar 2024 10:34:41 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=w8fYUNQJ;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4TzSlM5lbDz3dVB
	for <linux-erofs@archiver.kernel.org>; Tue, 19 Mar 2024 21:34:39 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=w8fYUNQJ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.119; helo=out30-119.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4TzSlD5BtQz3cnt
	for <linux-erofs@lists.ozlabs.org>; Tue, 19 Mar 2024 21:34:30 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1710844466; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Bdadq9GunDiEhKHRiECvDiVFYuvED6FoFIbywdNUegA=;
	b=w8fYUNQJUVcgb2drn3aRxYL40Y12rPFM9shnwHtQnsZvxJbC3bosEKDkdtyiisuMUF4/Acpcv9kB0kO6wrVJmTHIaRvFHsKrkpAzay8E8HhCcsp2ui0e7/wdmzs/O6MCFvsXL2P0r4GuZACncPChVaNP4xO2FClBTtDVf7bagBs=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R561e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0W2svsTi_1710844463;
Received: from 30.97.48.212(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0W2svsTi_1710844463)
          by smtp.aliyun-inc.com;
          Tue, 19 Mar 2024 18:34:24 +0800
Message-ID: <fad8f767-7870-486c-b8af-1f260b6bdb65@linux.alibaba.com>
Date: Tue, 19 Mar 2024 18:34:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [erofs?] KMSAN: uninit-value in z_erofs_lz4_decompress
 (3)
To: syzbot <syzbot+88ad8b0517a9d3bb9dc8@syzkaller.appspotmail.com>,
 linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com, xiang@kernel.org
References: <0000000000007e031e061400c64d@google.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <0000000000007e031e061400c64d@google.com>
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

#syz dup KMSAN: uninit-value in z_erofs_lz4_decompress (2)

On 2024/3/19 18:17, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> 
> Reported-and-tested-by: syzbot+88ad8b0517a9d3bb9dc8@syzkaller.appspotmail.com
> 
> Tested on:
> 
> commit:         b3603fcb Merge tag 'dlm-6.9' of git://git.kernel.org/p..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14395479180000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c0f689e0798c5101
> dashboard link: https://syzkaller.appspot.com/bug?extid=88ad8b0517a9d3bb9dc8
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Note: no patches were applied.
> Note: testing is done by a robot and is best-effort only.
