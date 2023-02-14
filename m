Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8019BC05027
	for <linux-erofs@archiver.kernel.org>; Tue, 14 Feb 2023 14:45:06 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4PGPBT17g8z2yJQ
	for <linux-erofs@archiver.kernel.org>; Wed, 15 Feb 2023 01:45:05 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=khTJrD+x;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=139.178.84.217; helo=dfw.source.kernel.org; envelope-from=chao@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=khTJrD+x;
	dkim-atps=neutral
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4PGPBN1CNvz3c7s
	for <linux-erofs@lists.ozlabs.org>; Wed, 15 Feb 2023 01:45:00 +1100 (AEDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 43232615A6;
	Tue, 14 Feb 2023 14:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A7FC433D2;
	Tue, 14 Feb 2023 14:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1676385897;
	bh=BpCjJ2aKu9c/zWe3SDTTfkT/dSP657acF+jv5YfyDb8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=khTJrD+xCTtVz3/EnUkDamqOcuiGNQofEc6tYSp5mPOnhndJWqbatR40ium3fyYjK
	 thfyMM55rRY9oYrliJAnRaiiXGtvJIuNhbWo8/qNj3y8vOG6Xmjb4fjC0mwwxIuhAc
	 DVctweJscFZHSnEOzS+kN461c7MkwEocxBHUNhh7QQyQjBh1I/Kc8JsJpx6x/i7Ch1
	 hiPmQDePUKACpHGu7lGjW0pgOF9jqDmDXSIMGRNv6WUhozk9tyaTNTmY/CjKW4Sc+z
	 tTMBOen5Nodg3IVshjV2g3DLU4mRsBsMR7v6YNJecMoyrGbOWhSUoTm02cVBC/ONU5
	 4FFG5pdG4jAbg==
Message-ID: <7af50b7c-cf39-8da0-e73e-2f044a0b1fc7@kernel.org>
Date: Tue, 14 Feb 2023 22:44:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 4/6] erofs: move zdata.h into zdata.c
Content-Language: en-US
To: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org,
 Yue Hu <huyue2@coolpad.com>, Jeffle Xu <jefflexu@linux.alibaba.com>
References: <20230204093040.97967-1-hsiangkao@linux.alibaba.com>
 <20230204093040.97967-4-hsiangkao@linux.alibaba.com>
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20230204093040.97967-4-hsiangkao@linux.alibaba.com>
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
Cc: LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On 2023/2/4 17:30, Gao Xiang wrote:
> Definitions in zdata.h are only used in zdata.c and for internal
> use only.  No logic changes.
> 
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

