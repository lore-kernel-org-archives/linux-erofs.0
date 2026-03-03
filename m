Return-Path: <linux-erofs+bounces-2479-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD3F9EB365B
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Mar 2026 02:57:41 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fQ0pX2rN5z2xpk;
	Tue, 03 Mar 2026 13:57:40 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772506660;
	cv=none; b=CiHPOL2w/hRuQQp2mBaQO2NLZrvNBs7QhdZhJGWUyTYMhJ2BBYREZRZWVpanIJyZ/5gm5iWVZEWhSvpHP/MtcEBWm1K3vj3PFdKfapSaAvRzELibFjqTYM6uc+K6ZnlklJ181gG13OW+hPs275Ep71Iwta8dmnCZqM7GZ3lPvkCNedHl2l4lIuuTa1GuRUoLQeV+7b/YpMPok+WpIVa1g7UfBxftfBznqXAzwEDXfqKLJXZyfD2Menw7t6qiYoxMdB4aXGOTYvJE8J0mTZOsTWns5xl4XuFrBm9QXfYbSZm1NlpeBoqgqhZnZKf6rgZfLRalJi8zLLSDo5Wkf+LlCg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772506660; c=relaxed/relaxed;
	bh=S1PDgh+qFZflNmwDFC11wz3E/TrH7h1wooXtaJyVI48=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=buIgFUnn0agKMcG41SPXEJh0dV/HOkHx6VEFxxGLOuMKlzmFHOhO6LeRdPP31ea+ZV0DG9ReRv/wLXyYsz0tVi53Bcpl1XSkzP89Z1NlXJOmE034H+dYkhvV/WAVeTYmTpXBhupJV2wTk++FJFaOPdfVm0kyKiUxXB8wuj++BD5QcvNieMWDoHyStG0ax2XMAakQv/HXuvdOqbNejstYmcOZ38a8JGQRLTUrbcb2Yui4RbWEutGNtzCOo53t5SXXJWejycTMEJTmvnysuv/yJGdlvPZvrC8DkzuF+Yp80Ycw9BLMw6K4+lVCb1ne4+4Pca0WTkQpJJ8CwrKb3Ioh3g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=P/vq7aQ6; dkim-atps=neutral; spf=pass (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=P/vq7aQ6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fQ0pV41FPz2xRq
	for <linux-erofs@lists.ozlabs.org>; Tue, 03 Mar 2026 13:57:36 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772506651; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=S1PDgh+qFZflNmwDFC11wz3E/TrH7h1wooXtaJyVI48=;
	b=P/vq7aQ6tjwtv+yckQkJmGxAFj4g8dMhW6mOL269NRqmJyHRQGHetvy0x0oNKMvWShZojts+5Z90kfTCAMzhQ1wN63w/R6V+osOOkDt7lz2NC8MWzlvrXDss1/hOi94d/q8qc12qCrBDAuvN/l4ndqGabLsV6om7uI/RKUCo9xc=
Received: from 30.221.132.55(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X-8JWaG_1772506649 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Mar 2026 10:57:30 +0800
Message-ID: <9fb745b7-6944-4773-843e-099ee598557d@linux.alibaba.com>
Date: Tue, 3 Mar 2026 10:57:29 +0800
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
Subject: Re: [PATCH v2] erofs-utils: lib: fix xattr crash in rebuild path when
 source has xattr
To: linux-erofs@lists.ozlabs.org, Lucas Karpinski <lkarpinski@nvidia.com>
Cc: jingrui@huawei.com, zhaoyifan28@huawei.com,
 lishixian <lishixian8@huawei.com>
References: <20260302130356.769479-1-lishixian8@huawei.com>
 <20260303023911.792454-1-lishixian8@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260303023911.792454-1-lishixian8@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Lucus,

On 2026/3/3 10:39, lishixian wrote:
> When rebuilding from source EROFS images, erofs_read_xattrs_from_disk()
> is called for inodes that have xattr. At that point inode->sbi points to
> the source image's sbi, which is opened read-only and never gets
> erofs_xattr_init(), so sbi->xamgr is NULL. get_xattritem(sbi) then
> dereferences xamgr and crashes with SIGSEGV.
> 
> Fix by using the build target's xamgr when initializing src's sbi.
> 
> Reported-by: Yixiao Chen <489679970@qq.com>
> Fixes: https://github.com/erofs/erofs-utils/issues/42
> Signed-off-by: lishixian <lishixian8@huawei.com>
> Reviewed-by: Yifan Zhao <zhaoyifan28@huawei.com>

Can you confirm it that fixes your issue too?
I will merge this for the bandaid solution, but after erofs-utils 1.9.1
is released, rebuild and xattr codebase need to be fixed instead.

Thanks,
Gao Xiang

> ---
>   mkfs/main.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/mkfs/main.c b/mkfs/main.c
> index b84d1b4..58c18f9 100644
> --- a/mkfs/main.c
> +++ b/mkfs/main.c
> @@ -1735,7 +1735,9 @@ static int erofs_mkfs_rebuild_load_trees(struct erofs_inode *root)
>   	}
>   
>   	list_for_each_entry(src, &rebuild_src_list, list) {
> +		src->xamgr = g_sbi.xamgr;
>   		ret = erofs_rebuild_load_tree(root, src, datamode);
> +		src->xamgr = NULL;
>   		if (ret) {
>   			erofs_err("failed to load %s", src->devname);
>   			return ret;


