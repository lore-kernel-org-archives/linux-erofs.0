Return-Path: <linux-erofs+bounces-1835-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7C1AD29DD4
	for <linux-erofs@archiver.kernel.org>; Tue, 13 Jan 2026 06:20:24 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dqzd32TFxz2xKx;
	Tue, 13 Jan 2026 17:20:23 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1768285223;
	cv=none; b=LJmPQTAuPLUnbfRYZ519xUfNMsRyJeR31KLH026G5naOFGndvZ6L4Bqh+fcO364TpLUXUWEnk1ZqDkJlzypDjdbhK8m/LMnt3ClnxJctw3DJLD4IW3fPSN17deKZSZj8CgqVA7Qw25WdbhAfxcYFvHv6jIY5WpNxqxbJGLLQhTYfkn0Z8+9I3bDtCmWsvrZFkZP13TCYtP2bFeD1ywnCnTRAQvgHxrBXMb3TWbXJ0kfrf94yLz82PXyNh2r5ydTgNA6sjDT2JxSlFvbayEcX8ladvktXLVbu4kCV04BXBx2gcXNLD0y6Y5Mhi++VHK2zRs5iGuZVMMZWcWtMqJrogg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1768285223; c=relaxed/relaxed;
	bh=0O37pSHOy+tXh10IcozLgEe0rmmZ7QuymxdRlspAtCc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U2G043F84MtGesMD9IPHI/BFBfj+2PgESGTkoBG5Ys4VxQv1tGvmf4D9eRke1fC6tkE1vbNo4ouDX12p6V47bxjmTf1AivRZadMPAmvxtpdPEtifcaAR4AStXLROz/1HzYi64NTH0oNFmrojG7l4G7n2MvaCCsyTNjiF9XvVwuugC2IEF0npKU+GGj5jLoBN+k3/rnbrkYU7R+SyXgjMxWDsAumL2n0hYFi3ehPa6m1Z7X+G7EJiHe4E/xFGjhLLk+PDA18pBXI+9N0OkwOptbDocp48tcqtEUIDuKSPVorv5XRJd2miQLGO8lyh0hNi9RrjI2fh5gxGDpfuHflpbA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=vOsdMcbq; dkim-atps=neutral; spf=pass (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=vOsdMcbq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dqzd12dksz2xHP
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Jan 2026 17:20:19 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768285214; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=0O37pSHOy+tXh10IcozLgEe0rmmZ7QuymxdRlspAtCc=;
	b=vOsdMcbq1T9gTOXvaWVWrf71PL6JM5jARPuJQNo6mloMz3UzRjiQ0zz/SmX7ApZ1oiWYQ/tevtekajOEV/cz38XyN4oISd0Hu8hzZt1WQdy+/6oOLaslgbLqkXC/qQJJov8QNiMETKFJqxKsurYj9Nj6jq1kschQEk4ffSyhhOw=
Received: from 30.221.131.147(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WwznAqC_1768285212 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 13 Jan 2026 14:20:12 +0800
Message-ID: <7db44e77-9256-469d-9845-d40079ab2a5a@linux.alibaba.com>
Date: Tue, 13 Jan 2026 14:20:12 +0800
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
Subject: Re: [PATCH 2/3] erofs-utils: lib: s3: set UID & GID correctly
To: Yifan Zhao <zhaoyifan28@huawei.com>, linux-erofs@lists.ozlabs.org
Cc: jingrui@huawei.com, wayne.ma@huawei.com
References: <20260113061149.3630464-1-zhaoyifan28@huawei.com>
 <20260113061149.3630464-2-zhaoyifan28@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260113061149.3630464-2-zhaoyifan28@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Yifan,

On 2026/1/13 14:11, Yifan Zhao wrote:
> In the current remote/s3 implementation, the default {u,g}id for files
> and directories is 0. Additionally, the --force-{u,g}id flag only
> affects file ownership, leaving directories unchanged.
> 
> This patch fixes the behavior by explicitly setting permissions for the
> root inode:
> 
> - If --force-{u,g}id is not specified, it now defaults to the current
>    user's {u,g}id.
> - If --force-{u,g}id is specified, it correctly updates the ownership
>    for all files and directories.
> 
> Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
> ---
>   lib/remotes/s3.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/remotes/s3.c b/lib/remotes/s3.c
> index 3426585..8351674 100644
> --- a/lib/remotes/s3.c
> +++ b/lib/remotes/s3.c
> @@ -1050,8 +1050,8 @@ int s3erofs_build_trees(struct erofs_importer *im, struct erofs_s3 *s3,
>   	bool dumb;
>   	int ret;
>   
> -	st.st_uid = root->i_uid;
> -	st.st_gid = root->i_gid;
> +	root->i_uid = st.st_uid = im->params->fixed_uid == -1 ? getuid() : im->params->fixed_uid;
> +	root->i_gid = st.st_gid = im->params->fixed_gid == -1 ? getgid() : im->params->fixed_gid;

I guess for the root inode, we should update
erofs_rebuild_make_root() instead?

Also it's too long, just break the assignment
into multiple lines.

Thanks,
Gao Xiang

>   
>   	ret = s3erofs_curl_easy_init(s3);
>   	if (ret) {


