Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E18CFC19F2A
	for <linux-erofs@archiver.kernel.org>; Sun,  7 Aug 2022 10:26:31 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4M0wVG1Vfwz2yxF
	for <linux-erofs@archiver.kernel.org>; Sun,  7 Aug 2022 20:26:30 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=k+cqsk/1;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2604:1380:4601:e00::1; helo=ams.source.kernel.org; envelope-from=chao@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=k+cqsk/1;
	dkim-atps=neutral
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4M0wV93W2hz2xHl
	for <linux-erofs@lists.ozlabs.org>; Sun,  7 Aug 2022 20:26:25 +1000 (AEST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id 4D671B80B7C;
	Sun,  7 Aug 2022 10:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67B1C433C1;
	Sun,  7 Aug 2022 10:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1659867978;
	bh=oHXNM9e+KqqIQkTJ0AAqOGGMwpn/QeJx1gR3yyGL/rI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=k+cqsk/1PI/tJ4SfRdvrfC29T/svkNTeTGny26DSGd1pwai2HqxlM/oyvjWZDuHJA
	 8aXeoYuLHVWDgucmp7zX53NkbpmotZiGSmve9pW/4kJAtM70S6f19RzIT2Vhzq0oNG
	 I/EnmJraf7uzSHEKhdssdXvO8SCej4//6MrBolhXH787RYx8z4SRhlfXgglDM0J3wl
	 ubMUI4SDnx2aobi0U+YRktPkImeDX3ed3jfpeZuZ1FuvT1eSSkTEBjnPz2Er4NTdws
	 MwgKvjFoPBJlEHqfnSZDicbfxgUFaU/BdX8pCeTarke+wq9aXdP+W4SqAwMLeUZmLG
	 5W+v0wiVOaMdQ==
Message-ID: <6104f247-fe16-7ee2-99f4-06772ebf2e1c@kernel.org>
Date: Sun, 7 Aug 2022 18:26:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2] erofs-utils: fuse: set d_type for readdir
Content-Language: en-US
To: Sheng Yong <shengyong2021@gmail.com>, xiang@kernel.org,
 bluce.lee@aliyun.com, linux-erofs@lists.ozlabs.org
References: <d783aec4-4d1c-46d8-202e-27ae5fe3cc72@oppo.com>
 <20220807080835.4160209-1-shengyong@oppo.com>
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20220807080835.4160209-1-shengyong@oppo.com>
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
Cc: shengyong@oppo.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On 2022/8/7 16:08, Sheng Yong wrote:
> From: Sheng Yong <shengyong@oppo.com>
> 
> Set inode mode for libfuse readdir filler so that readdir count get
> correct d_type.
> 
> Signed-off-by: Sheng Yong <shengyong@oppo.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
