Return-Path: <SRS0=S08A=NJ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34857C4338F
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Aug 2021 16:49:35 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7FFBA610CB
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Aug 2021 16:49:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7FFBA610CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GqYld08Ysz3cGc
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Aug 2021 02:49:33 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=XD1aW5YU;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=xiang@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=XD1aW5YU; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GqYlY0qHfz3bXj
 for <linux-erofs@lists.ozlabs.org>; Thu, 19 Aug 2021 02:49:29 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 257DD610CB;
 Wed, 18 Aug 2021 16:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1629305366;
 bh=1NesV0brpkZ534wUSWFYWP/tKPwYqxvUzjbHxDqOHZs=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=XD1aW5YUUbUMgfIZvb903CH4/695mofrtNeVkbLlgBGIHJfkYJWhKfD7sHTwHSEKA
 NmymoBFSNtmJ35D22hMeCueUA46D1edkEda5pmUo/zL5aTIQxBRsVsQoYVWcYLsNJu
 3pRPsZQwtkJ08BFzfKvCOBzhYLHSXaUdBz2L9MRKkXOW5MiVImGXQrpKQMRTTYsy6n
 +asokcu7q21/iyG206XyTk/xJ2/hfx8peSrwitnN7UDYMxVNrIaOTG4cnwo++IMMmH
 TQXPqGm33U9Ack+7eplNDbeg0UNPd/PXpDNp5vymAmJZKzUZwBQZ9hXjLtOgn9mgW6
 ei0bGpvcIZiuQ==
Date: Thu, 19 Aug 2021 00:49:01 +0800
From: Gao Xiang <xiang@kernel.org>
To: Huang Jianan <huangjianan@oppo.com>
Subject: Re: [PATCH] erofs-utils: add mkfs.erofs and erofsfuse to .gitignore
Message-ID: <20210818164855.GA4664@hsiangkao-HP-ZHAN-66-Pro-G1>
Mail-Followup-To: Huang Jianan <huangjianan@oppo.com>,
 linux-erofs@lists.ozlabs.org, yh@oppo.com, kevin.liw@oppo.com,
 guoweichao@oppo.com, guanyuewei@oppo.com
References: <20210818043539.25417-1-huangjianan@oppo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210818043539.25417-1-huangjianan@oppo.com>
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
Cc: yh@oppo.com, kevin.liw@oppo.com, guoweichao@oppo.com,
 linux-erofs@lists.ozlabs.org, guanyuewei@oppo.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Wed, Aug 18, 2021 at 12:35:39PM +0800, Huang Jianan via Linux-erofs wrote:
> ---
>  .gitignore | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/.gitignore b/.gitignore
> index 8bdd505..0e54836 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -27,4 +27,5 @@ configure.scan
>  libtool
>  stamp-h
>  stamp-h1
> -
> +mkfs.erofs
> +erofsfuse

Should it be written as
/mkfs/mkfs.erofs
/fuse/erofsfuse

?

Thanks,
Gao Xiang

> -- 
> 2.25.1
> 
