Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 616B4C64EC4
	for <linux-erofs@archiver.kernel.org>; Fri, 10 Mar 2023 06:01:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4PXwR85yfmz3cf6
	for <linux-erofs@archiver.kernel.org>; Fri, 10 Mar 2023 17:01:24 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4PXwR20pFyz3bm6
	for <linux-erofs@lists.ozlabs.org>; Fri, 10 Mar 2023 17:01:17 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0VdW7I1M_1678428069;
Received: from 30.97.48.46(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VdW7I1M_1678428069)
          by smtp.aliyun-inc.com;
          Fri, 10 Mar 2023 14:01:10 +0800
Message-ID: <e8054874-88d8-e539-8fd4-6123821aa3a8@linux.alibaba.com>
Date: Fri, 10 Mar 2023 14:01:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v4 2/5] erofs: convert to use i_blockmask()
To: Yangtao Li <frank.li@vivo.com>, xiang@kernel.org, chao@kernel.org,
 huyue2@coolpad.com, jefflexu@linux.alibaba.com, tytso@mit.edu,
 adilger.kernel@dilger.ca, rpeterso@redhat.com, agruenba@redhat.com,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org
References: <20230310054829.4241-1-frank.li@vivo.com>
 <20230310054829.4241-2-frank.li@vivo.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20230310054829.4241-2-frank.li@vivo.com>
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
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Yangtao,

On 2023/3/10 13:48, Yangtao Li wrote:
> Use i_blockmask() to simplify code.
> 
> Signed-off-by: Yangtao Li <frank.li@vivo.com>

Please help drop this one since we'd like to use it until i_blockmask()
lands to upstream.

Thanks,
Gao Xiang

> ---
>   fs/erofs/data.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
> index e16545849ea7..d394102ef9de 100644
> --- a/fs/erofs/data.c
> +++ b/fs/erofs/data.c
> @@ -376,7 +376,7 @@ static ssize_t erofs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>   		if (bdev)
>   			blksize_mask = bdev_logical_block_size(bdev) - 1;
>   		else
> -			blksize_mask = (1 << inode->i_blkbits) - 1;
> +			blksize_mask = i_blockmask(inode);
>   
>   		if ((iocb->ki_pos | iov_iter_count(to) |
>   		     iov_iter_alignment(to)) & blksize_mask)
