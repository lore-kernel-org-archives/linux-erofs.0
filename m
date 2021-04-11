Return-Path: <SRS0=U8k6=JI=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E0FC433ED
	for <linux-erofs@archiver.kernel.org>; Sun, 11 Apr 2021 14:41:26 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 93E4261025
	for <linux-erofs@archiver.kernel.org>; Sun, 11 Apr 2021 14:41:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93E4261025
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4FJF1J1hnRz30KH
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Apr 2021 00:41:24 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=XW8JvLhy;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=xiang@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=XW8JvLhy; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4FJF1G0blLz3046
 for <linux-erofs@lists.ozlabs.org>; Mon, 12 Apr 2021 00:41:21 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53C8D610CA;
 Sun, 11 Apr 2021 14:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1618152078;
 bh=v9npEMhtYeaR5hhTXxr5o8/abATSfD69bb48zHsRoMA=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=XW8JvLhygrVI1KFxl/X8JFXdHWmIkZlh2mA3/hEe69BevwkgfveSkmJffx5ENYZpw
 Yfx0AW8eC481pTHrdMuXfPCidMiLh+PFvJsQsyG7z3q8IoxLwJJf8nn3jIbGk4u6cK
 2QavG+HgoXzLGpHwqxYYvb7TZE9gtAHUvvPGqYqmwvLLne7b527a/tpbICToU0GAz+
 ULyLyyJpXZX6t8jn7sOXsd8SIrf4V+YH3g327lCC7V2Yt55n7pyc6wgvNVK9LTQbDK
 uNfe4uhrKXgSvB3GCGlAM+52EZ36mtVuAEtsLXNN+qZMJy5PZPwZhFC3wt7obrk76Q
 dwY3vbB17CaBw==
Date: Sun, 11 Apr 2021 22:41:03 +0800
From: Gao Xiang <xiang@kernel.org>
To: Li GuiFu <bluce.lee@aliyun.com>
Subject: Re: [PATCH v2] erofs-utils: use qsort() to sort dir->i_subdirs
Message-ID: <20210411144047.GA15096@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20210402021741.GB4011659@xiangao.remote.csb>
 <20210405093816.149621-1-sehuww@mail.scut.edu.cn>
 <8f0140a5-c738-7890-eff7-eb877a40035d@aliyun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8f0140a5-c738-7890-eff7-eb877a40035d@aliyun.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Guifu,

On Sun, Apr 11, 2021 at 10:10:09PM +0800, Li GuiFu via Linux-erofs wrote:
> Hu Weiwen
>   It really do a high sort performance increase,
>   I have a idea that keeping the erofs_prepare_dir_file() function
> paramter stable, Using a independent function to do dirs sort.
> 

I think Weiwen's implementation looks fine to me, if you tend to
not passing nr_subdirs as a cleaner solution, my suggestion would
be:
1) introduce a somewhat erofs_subdirs, which includes
   - a list_head for all subdir dentries generated from d_alloc;
   - a nr_subdirs count;
2) update erofs_d_alloc to
   erofs_d_alloc(struct erofs_subdirs *, const char *);
3) update erofs_prepare_dir_file to
   erofs_prepare_dir_file(struct erofs_inode *, struct erofs_subdir *).

Yet I'd like to apply the current solution first since it helps the
dir creation performance. If someone has interest to the solution
above, new cleanup is always welcomed.

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang
