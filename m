Return-Path: <linux-erofs+bounces-4396-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46AC8C61DFD
	for <linux-erofs@archiver.kernel.org>; Tue,  1 Sep 2026 02:36:50 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hYqkS2rdhz2yCv;
	Tue, 01 Sep 2026 12:36:48 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=45.249.212.51
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788230208;
	cv=none; b=mFSpqRZZnB5ZAe5mlArH7uUqnPYC6IfyyrOz1NWjeRzx1HNLmGkRkc53tc2xhxb3wNkoDhM/1Bodlc2GAeBGGmhibuCWyEBxIJyx0VDhlRN3XZV6T8AbVtx5Nz2RjoebzrISO9p5pSq4lTLXnrsmHOZ7AwD2XVtD52T1lG0e0dG2yHg3RmR4nFnQQAiwowHLlLWzgkKpdhBhD3sylTRRO9rsySyL4rX77MQ1wDn38MlRiEDuTAzk5ynxVCIAp/cqHquKXBu22LGiO4WmPJR728S6K8WjKt1dHLEH01VF/x9zJPNW0bxU4ZDWUUZ539odkUuvDH61HqPPGb2Qq8U5Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788230208; c=relaxed/relaxed;
	bh=jbfAJUaQ5g2QociN/kQcU2RWxpr2ei6+3CfE6ZVXnIw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YPRYqKVXuThfIrIGSQnX+cy70pwXwRIPEvTUD/pnS/e4CBNcrW4x547eeI0cDlcGqI0sXKWhwqSuvDvivLI3/CrjTYRutE0n7tOY5VXOMUIf2GkXcpvqAmuQXt+YstDOd3GHnsk4i+/XdsFQXu9pfFgfzRTc8/Z8eO+xrf6ZDjB41591H3YJvxo2/cfzBcfebkUW4/H4YMbhD8DX0IwqhgU7ZWu7zMd99gGK7ZjafV6OxI6rw3U96EkeiINox2YnXQUiTgzEq9nymPe1t/96uRDCbe0buASKnua0R6INpjh5fEzZQveQNeFiDEloVBkpf1si491Cv0JMyLnP65lLzw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass (client-ip=45.249.212.51; helo=dggsgout11.his.huawei.com; envelope-from=yi.zhang@huaweicloud.com; receiver=lists.ozlabs.org) smtp.mailfrom=huaweicloud.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huaweicloud.com (client-ip=45.249.212.51; helo=dggsgout11.his.huawei.com; envelope-from=yi.zhang@huaweicloud.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 1114 seconds by postgrey-1.37 at boromir; Tue, 01 Sep 2026 12:36:46 AEST
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hYqkQ5ygNz2yCs
	for <linux-erofs@lists.ozlabs.org>; Tue, 01 Sep 2026 12:36:44 +1000 (AEST)
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hYqHz0jRnzYQtpy
	for <linux-erofs@lists.ozlabs.org>; Tue,  1 Sep 2026 10:17:19 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id ACE3840776
	for <linux-erofs@lists.ozlabs.org>; Tue,  1 Sep 2026 10:17:57 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgAnDgnTNZZqkvQ9AQ--.49297S3;
	Tue, 01 Sep 2026 10:17:57 +0800 (CST)
Message-ID: <70d1f9a7-362a-4152-b323-58ae010ebbf6@huaweicloud.com>
Date: Tue, 1 Sep 2026 10:17:55 +0800
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
Subject: Re: [PATCH 2/9] ext4: Remove uses of FGP_NOFS
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <christian@brauner.io>, Jan Kara <jack@suse.cz>,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Theodore Tso <tytso@mit.edu>, Trond Myklebust <trondmy@kernel.org>,
 Anna Schumaker <anna@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Hyunchul Lee <hyc.lee@gmail.com>, Phillip Lougher <phillip@squashfs.org.uk>,
 linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, ntfs@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-3-willy@infradead.org>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260830041901.2668-3-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgAnDgnTNZZqkvQ9AQ--.49297S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tFyDXFy5WFy3AryrCFy7trb_yoW8Gw4Upw
	s5C3WUGrW8Za40kFW7uw17t345Wa48GayUCF1xKwnxCF90g3ZrKr4Yk3W2qryUtrW8Z3yx
	XF4jkrW8W3W3trDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVWxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kK
	e7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
	02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_
	WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	jIksgUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 8/30/2026 12:18 PM, Matthew Wilcox (Oracle) wrote:
> Both of these locations are called while a transaction is in progress.
> Starting a transaction uses memalloc_nofs_save(), so we are already
> prevented from recursing into the filesystem and using GFP_NOFS was
> unnecessary.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/ext4/inline.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index ceee69a66482..1884abb09614 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -601,9 +601,7 @@ static int ext4_convert_inline_data_to_extent(struct address_space *mapping,
>  		goto out;
>  	}
>  
> -	/* We cannot recurse into the filesystem as the transaction is already
> -	 * started */
> -	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN | FGP_NOFS,
> +	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN,
>  			mapping_gfp_mask(mapping));
>  	if (IS_ERR(folio)) {
>  		ret = PTR_ERR(folio);
> @@ -734,7 +732,7 @@ int ext4_generic_write_inline_data(struct address_space *mapping,
>  		goto out_release_bh;
>  	}
>  
> -	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN | FGP_NOFS,
> +	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN,
>  					mapping_gfp_mask(mapping));
>  	if (IS_ERR(folio)) {
>  		ret = PTR_ERR(folio);


