Return-Path: <SRS0=VaLi=FJ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FBF5C4361A
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Dec 2020 08:33:11 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 23E5222D2A
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Dec 2020 08:33:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23E5222D2A
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Cp2s030WtzDqjg
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Dec 2020 19:33:08 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1607157188;
	bh=/YgwaXQgR+vm6kRKe7FdBaTI0jzwwRyPaZA5DMAdkuA=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:
	 From;
	b=FBI6dFDPkzYU9sCr8Bdjs8qevFulUfqAU6I1B13DjunWLDqlW6Ov67Jk2FlEujRYo
	 WFcCcZl2LX0OcXlB1FK8WfLubN98k3F1q6eYYlzRHrjFdWlQ3UN5YT0DZn2Z17Sd/k
	 q7bJgN9CfQMMZcIndAubmcs72pr5MacXdZtQcwANmB84uiAqgsttowAOPYe+h56sWq
	 GmQxc+EvaBP4BpBMFP36zPyEBYaoBvwn4FNOs0x37g3QBaPadibGRZ64uzx6hpx1A/
	 9Wdd2bnzcZje4TrFfGwL8HVyFRFX7lFeNBNy+j8JfEbP+4hv2kTFxymg9OwgqW4IIR
	 YkYoSHjM9KrbA==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.50;
 helo=out30-50.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none)
 header.from=aliyun.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=KCEll14v; dkim-atps=neutral
Received: from out30-50.freemail.mail.aliyun.com
 (out30-50.freemail.mail.aliyun.com [115.124.30.50])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Cp2rn5hBkzDqNC
 for <linux-erofs@lists.ozlabs.org>; Sat,  5 Dec 2020 19:32:56 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1607157165; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
 bh=4zK0a5kPGh9k7RWvK62rtbqMWrDEZ8JJPmIjrLJIw9c=;
 b=KCEll14vgBtN0cF+VEd3hRP9QA6NzdVnYUcr5QXR67hXJtK17Mtjho5UV+Ufvpsp5uoGQeGOgwf9xIbc0BpPgjXRHrgniuduOq96pdgOwrTiTJ9Iz8eLecNq3GPS2dI9qXwjfMISkSn4sa3iX6l96fQ61d3leNoBzjXhfUErAjw=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.0737483|-1; CH=green; DM=|CONTINUE|false|;
 DS=CONTINUE|ham_alarm|0.010099-0.00137825-0.988523; FP=0|0|0|0|0|-1|-1|-1;
 HT=e01e04395; MF=bluce.lee@aliyun.com; NM=1; PH=DS; RN=2; RT=2; SR=0;
 TI=SMTPD_---0UHZmRem_1607157164; 
Received: from 172.168.2.18(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0UHZmRem_1607157164) by smtp.aliyun-inc.com(127.0.0.1);
 Sat, 05 Dec 2020 16:32:44 +0800
Subject: Re: [PATCH] erofs-utils: update i_nlink stat for directories
To: Gao Xiang <hsiangkao@aol.com>, linux-erofs@lists.ozlabs.org
References: <20201205055732.14276-1-hsiangkao.ref@aol.com>
 <20201205055732.14276-1-hsiangkao@aol.com>
Message-ID: <ed88d60a-77a9-f189-3586-a6d6aef510d9@aliyun.com>
Date: Sat, 5 Dec 2020 16:32:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201205055732.14276-1-hsiangkao@aol.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
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
From: Li GuiFu via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Li GuiFu <bluce.lee@aliyun.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2020/12/5 13:57, Gao Xiang via Linux-erofs wrote:
> From: Gao Xiang <hsiangkao@aol.com>
> 
> Previously, nlink of directories is treated as 1 for simplicity.
> 
> Since st_nlink for dirs is actualy not well defined, nlink=1 seems
> to pacify `find' (even without -noleaf option) and other utilities.
> AFAICT, isofs, romfs and cramfs always set it to 1, Overlayfs sets
> it to 1 conditionally, btrfs[1], ceph[2] and FUSE client historically
> set it to 1.
> 
> The convention under unix is that it's # of subdirs including "."
> and "..". This patch tries to follow such convention if possible to
> optimize `find' performance since it's not quite hard for local fs.
> 
> [1] https://lore.kernel.org/r/20100124003336.GP23006@think
> [2] https://lore.kernel.org/r/20180521092729.17470-1-lhenriques@suse.com
> Signed-off-by: Gao Xiang <hsiangkao@aol.com>
> ---
>  lib/inode.c | 33 +++++++++++++++++++++++++++++----
>  1 file changed, 29 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/inode.c b/lib/inode.c
> index 618eb284550f..357ac480154a 100644
> --- a/lib/inode.c
> +++ b/lib/inode.c
> @@ -25,7 +25,7 @@
>  struct erofs_sb_info sbi;
>  

> @@ -957,6 +974,10 @@ struct erofs_inode *erofs_mkfs_build_tree(struct erofs_inode *dir)
>  			ret = PTR_ERR(d);
>  			goto err_closedir;
>  		}
> +
> +		/* to count i_nlink for directories */
> +		d->type = (dp->d_type == DT_DIR ?
> +			EROFS_FT_DIR : EROFS_FT_UNKNOWN);
>  	}
>  
It's confused that d->type was set to EROFS_FT_UNKNOWN when not a dir
It's not clearness whether the program goes wrong or get the wrong data
Actually it's a correct procedure


>  	if (errno) {
> @@ -978,6 +999,7 @@ struct erofs_inode *erofs_mkfs_build_tree(struct erofs_inode *dir)
>  
>  	list_for_each_entry(d, &dir->i_subdirs, d_child) {
>  		char buf[PATH_MAX];
> +		unsigned char ftype;
>  
>  		if (is_dot_dotdot(d->name)) {
>  			erofs_d_invalidate(d);
> @@ -1000,7 +1022,10 @@ fail:
>  			goto err;
>  		}
>  
> -		d->type = erofs_type_by_mode[d->inode->i_mode >> S_SHIFT];
> +		ftype = erofs_mode_to_ftype(d->inode->i_mode);
> +		DBG_BUGON(d->type != EROFS_FT_UNKNOWN && d->type != ftype);
> +		d->type = ftype;
> +
>  		erofs_d_invalidate(d);
>  		erofs_info("add file %s/%s (nid %llu, type %d)",
>  			   dir->i_srcpath, d->name, (unsigned long long)d->nid,
> 
