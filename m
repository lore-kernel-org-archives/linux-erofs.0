Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A61E1C3DA61
	for <linux-erofs@archiver.kernel.org>; Fri, 19 Jul 2024 03:21:18 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=rFQgWJaE;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4WQFM102hXz3fFT
	for <linux-erofs@archiver.kernel.org>; Fri, 19 Jul 2024 13:21:17 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=rFQgWJaE;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4WQFLr0DbSz3cTL
	for <linux-erofs@lists.ozlabs.org>; Fri, 19 Jul 2024 13:21:06 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1721359260; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=MJ64cmXfjLqGZmyICyAEnvD6/hHTCeUjziMuAi77Bks=;
	b=rFQgWJaE9XX9KVewkErMRAJGPayyZQbyRnwt8mQGQx2DRB+PcVgqFiTF1XCUk4ogR6zzfu39lw4fcYXyXqnatuxsdUk/dKUaOtlgrNK4NXCXCz+sAmhJs0+vLwaIumWh4uwwOwFxeDBiYScEkocRgkm67tcmM04V/5kRb6DoMkY=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032019045;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0WAqDoer_1721359258;
Received: from 30.97.48.203(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WAqDoer_1721359258)
          by smtp.aliyun-inc.com;
          Fri, 19 Jul 2024 11:20:59 +0800
Message-ID: <9ad02965-11e6-4285-a915-ce6aa779861b@linux.alibaba.com>
Date: Fri, 19 Jul 2024 11:20:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] erofs-utils: misc: Fix potential memory leak in
 realloc failure path
To: Sandeep Dhavale <dhavale@google.com>, linux-erofs@lists.ozlabs.org
References: <20240718202204.1224620-1-dhavale@google.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20240718202204.1224620-1-dhavale@google.com>
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
Cc: kernel-team@android.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Sandeep,

On 2024/7/19 04:22, Sandeep Dhavale wrote:
> As realloc returns NULL on failure, the original value will be
> overwritten if it is used as lvalue. Fix this by using a temporary
> variable to hold the return value and exit with -ENOMEM in case of
> failure. This patch fixes 2 of the realloc blocks with similar fix.

Thanks for the patch!

Is it a lint issue?  Although I think currently userspace malloc
failures is rare, it'd be better to handle them.

> 
> Signed-off-by: Sandeep Dhavale <dhavale@google.com>
> ---
>   fsck/main.c | 9 +++++++--
>   lib/data.c  | 5 +++--
>   2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fsck/main.c b/fsck/main.c
> index 8ec9486..75950b6 100644
> --- a/fsck/main.c
> +++ b/fsck/main.c
> @@ -508,8 +508,13 @@ static int erofs_verify_inode_data(struct erofs_inode *inode, int outfd)
>   		if (compressed) {
>   			if (map.m_llen > buffer_size) {
>   				buffer_size = map.m_llen;
> -				buffer = realloc(buffer, buffer_size);
> -				BUG_ON(!buffer);
> +				char *newbuffer = realloc(buffer, buffer_size);
> +
> +				if (!newbuffer) {
> +					ret = -ENOMEM;
> +					goto out;
> +				}
> +				buffer = newbuffer;

I update this as since the variable definition would be better
at the beginning of a block...

diff --git a/fsck/main.c b/fsck/main.c
index 75950b6..fb66967 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -507,9 +507,10 @@ static int erofs_verify_inode_data(struct erofs_inode *inode, int outfd)

                 if (compressed) {
                         if (map.m_llen > buffer_size) {
-                               buffer_size = map.m_llen;
-                               char *newbuffer = realloc(buffer, buffer_size);
+                               char *newbuffer;

+                               buffer_size = map.m_llen;
+                               newbuffer = realloc(buffer, buffer_size);
                                 if (!newbuffer) {
                                         ret = -ENOMEM;
                                         goto out;

Thanks,
Gao Xiang
