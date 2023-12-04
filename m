Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82D87C10F04
	for <linux-erofs@archiver.kernel.org>; Mon,  4 Dec 2023 03:28:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Sk8JS1LvJz3cRp
	for <linux-erofs@archiver.kernel.org>; Mon,  4 Dec 2023 14:28:24 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.97; helo=out30-97.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Sk8JG6hs2z30gH
	for <linux-erofs@lists.ozlabs.org>; Mon,  4 Dec 2023 14:28:11 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Vxhh90d_1701660484;
Received: from 30.97.49.36(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Vxhh90d_1701660484)
          by smtp.aliyun-inc.com;
          Mon, 04 Dec 2023 11:28:05 +0800
Message-ID: <275f025d-e2f1-eaff-6af1-e909d370cee0@linux.alibaba.com>
Date: Mon, 4 Dec 2023 11:28:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: Weird EROFS data corruption
To: Juhyung Park <qkrwngud825@gmail.com>
References: <CAD14+f2AVKf8Fa2OO1aAUdDNTDsVzzR6ctU_oJSmTyd6zSYR2Q@mail.gmail.com>
 <5a0e8b44-6feb-b489-cdea-e3be3811804a@linux.alibaba.com>
 <CAD14+f2G-buxTaWgb23DYW-HSd1sch6tJNKV2strt=toASZXQQ@mail.gmail.com>
 <649a3bc4-58bb-1dc8-85fb-a56e47b3d5c9@linux.alibaba.com>
 <CAD14+f1u6gnHLhGSoQxL9wLq9vDYse+Ac8zxep-O2E8hHreT2w@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAD14+f1u6gnHLhGSoQxL9wLq9vDYse+Ac8zxep-O2E8hHreT2w@mail.gmail.com>
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
Cc: Yann Collet <yann.collet.73@gmail.com>, linux-erofs@lists.ozlabs.org, linux-crypto@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2023/12/4 01:32, Juhyung Park wrote:
> Hi Gao,

...

>>>
>>>>
>>>> What is the difference between these two machines? just different CPU or
>>>> they have some other difference like different compliers?
>>>
>>> I fully and exclusively control both devices, and the setup is almost the same.
>>> Same Ubuntu version, kernel/compiler version.
>>>
>>> But as I said, on my laptop, the issue happens on kernels that someone
>>> else (Canonical) built, so I don't think it matters.
>>
>> The only thing I could say is that the kernel side has optimized
>> inplace decompression compared to fuse so that it will reuse the
>> same buffer for decompression but with a safe margin (according to
>> the current lz4 decompression implementation).  It shouldn't behave
>> different just due to different CPUs.  Let me find more clues
>> later, also maybe we should introduce a way for users to turn off
>> this if needed.
> 
> Cool :)
> 
> I'm comfortable changing and building my own custom kernel for this
> specific laptop. Feel free to ask me to try out some patches.

Thanks, I need to narrow down this issue:

-  First, could you apply the following diff to test if it's still
    reproducable?

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index 021be5feb1bc..40a306628e1a 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -131,7 +131,7 @@ static void *z_erofs_lz4_handle_overlap(struct z_erofs_lz4_decompress_ctx *ctx,

  	if (rq->inplace_io) {
  		omargin = PAGE_ALIGN(ctx->oend) - ctx->oend;
-		if (rq->partial_decoding || !may_inplace ||
+		if (1 || rq->partial_decoding || !may_inplace ||
  		    omargin < LZ4_DECOMPRESS_INPLACE_MARGIN(rq->inputsize))
  			goto docopy;

- Could you share the full message about the output of `lscpu`?

Thanks,
Gao Xiang
