Return-Path: <SRS0=iJNB=W2=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C213C3A59B
	for <linux-erofs@archiver.kernel.org>; Fri, 30 Aug 2019 15:26:40 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 152BD21726
	for <linux-erofs@archiver.kernel.org>; Fri, 30 Aug 2019 15:26:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 152BD21726
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46Kjxn4TzbzDqx9
	for <linux-erofs@archiver.kernel.org>; Sat, 31 Aug 2019 01:26:37 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
 spf=pass (mailfrom) smtp.mailfrom=huawei.com
 (client-ip=45.249.212.187; helo=huawei.com;
 envelope-from=gaoxiang25@huawei.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=huawei.com
Received: from huawei.com (szxga01-in.huawei.com [45.249.212.187])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46KjxD0Dg5zDqwr
 for <linux-erofs@lists.ozlabs.org>; Sat, 31 Aug 2019 01:26:06 +1000 (AEST)
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.54])
 by Forcepoint Email with ESMTP id DFDBD2D2AD8F25ECC514;
 Fri, 30 Aug 2019 23:26:00 +0800 (CST)
Received: from dggeme762-chm.china.huawei.com (10.3.19.108) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 30 Aug 2019 23:26:00 +0800
Received: from architecture4 (10.140.130.215) by
 dggeme762-chm.china.huawei.com (10.3.19.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Fri, 30 Aug 2019 23:25:59 +0800
Date: Fri, 30 Aug 2019 23:25:11 +0800
From: Gao Xiang <gaoxiang25@huawei.com>
To: Chao Yu <yuchao0@huawei.com>, Dan Carpenter <dan.carpenter@oracle.com>,
 Christoph Hellwig <hch@infradead.org>, Joe Perches <joe@perches.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>
Subject: Re: [PATCH v3 1/7] erofs: on-disk format should have explicitly
 assigned numbers
Message-ID: <20190830152511.GA39008@architecture4>
References: <20190830032006.GA20217@architecture4>
 <20190830033643.51019-1-gaoxiang25@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190830033643.51019-1-gaoxiang25@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.140.130.215]
X-ClientProxiedBy: dggeme719-chm.china.huawei.com (10.1.199.115) To
 dggeme762-chm.china.huawei.com (10.3.19.108)
X-CFilter-Loop: Reflected
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
Cc: weidu.du@huawei.com, Miao Xie <miaoxie@huawei.com>,
 linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Fri, Aug 30, 2019 at 11:36:37AM +0800, Gao Xiang wrote:
> As Christoph claimed [1], on-disk format should have
> explicitly assigned numbers. I have to change it.
> 
> [1] https://lore.kernel.org/r/20190829095954.GB20598@infradead.org/
> Reported-by: Christoph Hellwig <hch@infradead.org>
> Reviewed-by: Chao Yu <yuchao0@huawei.com>
> Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>

...ignore this patchset. I will resend another incremental
patchset to address what Christoph suggested yesterday...

Thanks,
Gao Xiang

> ---
> no change
> 
>  fs/erofs/erofs_fs.h | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/erofs/erofs_fs.h b/fs/erofs/erofs_fs.h
> index afa7d45ca958..2447ad4d0920 100644
> --- a/fs/erofs/erofs_fs.h
> +++ b/fs/erofs/erofs_fs.h
> @@ -52,10 +52,10 @@ struct erofs_super_block {
>   * 4~7 - reserved
>   */
>  enum {
> -	EROFS_INODE_FLAT_PLAIN,
> -	EROFS_INODE_FLAT_COMPRESSION_LEGACY,
> -	EROFS_INODE_FLAT_INLINE,
> -	EROFS_INODE_FLAT_COMPRESSION,
> +	EROFS_INODE_FLAT_PLAIN			= 0,
> +	EROFS_INODE_FLAT_COMPRESSION_LEGACY	= 1,
> +	EROFS_INODE_FLAT_INLINE			= 2,
> +	EROFS_INODE_FLAT_COMPRESSION		= 3,
>  	EROFS_INODE_LAYOUT_MAX
>  };
>  
> @@ -181,7 +181,7 @@ struct erofs_xattr_entry {
>  
>  /* available compression algorithm types */
>  enum {
> -	Z_EROFS_COMPRESSION_LZ4,
> +	Z_EROFS_COMPRESSION_LZ4	= 0,
>  	Z_EROFS_COMPRESSION_MAX
>  };
>  
> @@ -239,10 +239,10 @@ struct z_erofs_map_header {
>   *                (di_advise could be 0, 1 or 2)
>   */
>  enum {
> -	Z_EROFS_VLE_CLUSTER_TYPE_PLAIN,
> -	Z_EROFS_VLE_CLUSTER_TYPE_HEAD,
> -	Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD,
> -	Z_EROFS_VLE_CLUSTER_TYPE_RESERVED,
> +	Z_EROFS_VLE_CLUSTER_TYPE_PLAIN		= 0,
> +	Z_EROFS_VLE_CLUSTER_TYPE_HEAD		= 1,
> +	Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD	= 2,
> +	Z_EROFS_VLE_CLUSTER_TYPE_RESERVED	= 3,
>  	Z_EROFS_VLE_CLUSTER_TYPE_MAX
>  };
>  
> -- 
> 2.17.1
> 
