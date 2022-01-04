Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4264C433FE
	for <linux-erofs@archiver.kernel.org>; Tue,  4 Jan 2022 07:57:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4JSlMH1BlDz2ywZ
	for <linux-erofs@archiver.kernel.org>; Tue,  4 Jan 2022 18:57:15 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=Kr2pK+rx;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=2604:1380:4641:c500::1;
 helo=dfw.source.kernel.org; envelope-from=chao@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=Kr2pK+rx; 
 dkim-atps=neutral
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [IPv6:2604:1380:4641:c500::1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4JSlM965N9z2xsW
 for <linux-erofs@lists.ozlabs.org>; Tue,  4 Jan 2022 18:57:09 +1100 (AEDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 2CC41612DA;
 Tue,  4 Jan 2022 07:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315B2C36AEF;
 Tue,  4 Jan 2022 07:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1641283025;
 bh=NSJ0zTdBXcJWuUZOOPmyxo1EAOMSjDyoFTgmv/YJlAo=;
 h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
 b=Kr2pK+rxZApN2H/ze4xyyXHbls1BroLStG49SrYoE2MLJxfZdI5yatFwTPW/PSVeS
 p2BhdOY1UoEu3MaXUSzhmYi+Wn6RMpxQeq3vMLe7jOBhNNyWbOsPAJgE7PUUgKs9nz
 iBAml9PJxzEAfAU+GvGNE4Z/RpwNWiYkMpkh2WrpaXynIk+WiTQbQLyG7fuwZL8y81
 /KBfb+9FFpOhT0+nav/HjW2gxcLopGurGp5SU0sLZBDGxC55iGCqtqO77SaKMjIFEf
 oHcdNCNfpsv77BrygfxHsbyT0VPhOLcaChIJEOfuEcq91xCHMslDCHQMDyII//GgDx
 2xfInguavBzog==
Message-ID: <2d841b67-27d0-df57-fff0-fa8fb2c4175c@kernel.org>
Date: Tue, 4 Jan 2022 15:57:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 2/5] erofs: use meta buffers for inode operations
Content-Language: en-US
To: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org,
 Liu Bo <bo.liu@linux.alibaba.com>
References: <20220102040017.51352-1-hsiangkao@linux.alibaba.com>
 <20220102040017.51352-3-hsiangkao@linux.alibaba.com>
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20220102040017.51352-3-hsiangkao@linux.alibaba.com>
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
Cc: Yue Hu <huyue2@yulong.com>, LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On 2022/1/2 12:00, Gao Xiang wrote:
> Get rid of old erofs_get_meta_page() within inode operations by
> using on-stack meta buffers in order to prepare subpage and folio
> features.
> 
> Reviewed-by: Yue Hu <huyue2@yulong.com>
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
