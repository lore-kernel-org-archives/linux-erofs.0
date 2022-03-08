Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC7A3C433F5
	for <linux-erofs@archiver.kernel.org>; Tue,  8 Mar 2022 05:59:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4KCPmV0MLrz3bT0
	for <linux-erofs@archiver.kernel.org>; Tue,  8 Mar 2022 16:59:38 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.43;
 helo=out30-43.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-43.freemail.mail.aliyun.com
 (out30-43.freemail.mail.aliyun.com [115.124.30.43])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4KCPmM4tH8z2yLX
 for <linux-erofs@lists.ozlabs.org>; Tue,  8 Mar 2022 16:59:28 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R271e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04394; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=7; SR=0; TI=SMTPD_---0V6cqYPl_1646719159; 
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0V6cqYPl_1646719159) by smtp.aliyun-inc.com(127.0.0.1);
 Tue, 08 Mar 2022 13:59:21 +0800
Date: Tue, 8 Mar 2022 13:59:19 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Hongnan Li <hongnan.li@linux.alibaba.com>
Subject: Re: [PATCH] Documentation/filesystem/dax: update DAX description on
 erofs
Message-ID: <Yibwt1yDO+oXF7Pu@B-P7TQMD6M-0146.local>
References: <20220308034139.93748-1-hongnan.li@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220308034139.93748-1-hongnan.li@linux.alibaba.com>
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
Cc: corbet@lwn.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Tue, Mar 08, 2022 at 11:41:39AM +0800, Hongnan Li wrote:
> From: lihongnan <hongnan.lhn@alibaba-inc.com>
> 
> Add missing erofs fsdax description since fsdax has been supported
> on erofs from Linux 5.15.
> 
> Signed-off-by: lihongnan <hongnan.lhn@alibaba-inc.com>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

(If no other concern, I will apply it for -5.18 cycle...)

Thanks,
Gao Xiang

> ---
>  Documentation/filesystems/dax.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/filesystems/dax.rst b/Documentation/filesystems/dax.rst
> index e3b30429d703..c04609d8ee24 100644
> --- a/Documentation/filesystems/dax.rst
> +++ b/Documentation/filesystems/dax.rst
> @@ -23,11 +23,11 @@ on it as usual.  The `DAX` code currently only supports files with a block
>  size equal to your kernel's `PAGE_SIZE`, so you may need to specify a block
>  size when creating the filesystem.
>  
> -Currently 4 filesystems support `DAX`: ext2, ext4, xfs and virtiofs.
> +Currently 5 filesystems support `DAX`: ext2, ext4, xfs, virtiofs and erofs.
>  Enabling `DAX` on them is different.
>  
> -Enabling DAX on ext2
> ---------------------
> +Enabling DAX on ext2 and erofs
> +------------------------------
>  
>  When mounting the filesystem, use the ``-o dax`` option on the command line or
>  add 'dax' to the options in ``/etc/fstab``.  This works to enable `DAX` on all files
> -- 
> 2.32.0 (Apple Git-132)
