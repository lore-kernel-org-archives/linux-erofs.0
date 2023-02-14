Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07539C61DA4
	for <linux-erofs@archiver.kernel.org>; Tue, 14 Feb 2023 14:52:01 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4PGPLR3mLnz3cMT
	for <linux-erofs@archiver.kernel.org>; Wed, 15 Feb 2023 01:51:59 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=WpYy9LVI;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=145.40.68.75; helo=ams.source.kernel.org; envelope-from=chao@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=WpYy9LVI;
	dkim-atps=neutral
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4PGPLL5frDz3c6m
	for <linux-erofs@lists.ozlabs.org>; Wed, 15 Feb 2023 01:51:54 +1100 (AEDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id 61CF1B81DEA;
	Tue, 14 Feb 2023 14:51:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7ACC4339B;
	Tue, 14 Feb 2023 14:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1676386311;
	bh=pd/T1je5R3F3V13CYoaSCUsHQT+gasg5eBG4RSQYtHk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WpYy9LVIe0k2Tw+QYbhwnKWTRGG5w2ph080OvbaFX5l7gR5sl7RHUWWtbtWEHbapR
	 UPL90R+BSpfsGKokeVP6Fnzn5y5wLxhRwRu2bRZgZxDlMhClBeDdrhEOv6evMdFbd9
	 jQ/O1GQtJH4doPgk2LiAUCtWpEq/ID8UAXbT5Z5PHAoE7uEJ3vK0rt5cvBwI7xF3nr
	 8hMX4NgP6vM6IurLcuoJNHmXq0DsvcjlwwiB7OF3FGSDxPzSZaSKcxFQ7HPLzKOB1w
	 KYx5QcaAASN3S3sxj+j7YZLkGbVzWFCgNpEWZlbSZgvgrLNiF+KRqGYADbBUOig3vg
	 7AD1UdwRXpJDQ==
Message-ID: <9557c372-6d49-f39e-3ea4-fdf2f33b1bf5@kernel.org>
Date: Tue, 14 Feb 2023 22:51:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] Documentation/ABI: sysfs-fs-erofs: update supported
 features
Content-Language: en-US
To: Yue Hu <zbestahu@gmail.com>, xiang@kernel.org,
 linux-erofs@lists.ozlabs.org
References: <20230209051128.10571-1-zbestahu@gmail.com>
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20230209051128.10571-1-zbestahu@gmail.com>
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
Cc: huyue2@coolpad.com, linux-kernel@vger.kernel.org, zhangwen@coolpad.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On 2023/2/9 13:11, Yue Hu wrote:
> From: Yue Hu <huyue2@coolpad.com>
> 
> Add missing feaures for sysfs-fs-erofs feature doc.
> 
> Signed-off-by: Yue Hu <huyue2@coolpad.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

