Return-Path: <SRS0=IqKj=M4=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A9DAC4338F
	for <linux-erofs@archiver.kernel.org>; Thu,  5 Aug 2021 03:02:50 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9CF3B610A0
	for <linux-erofs@archiver.kernel.org>; Thu,  5 Aug 2021 03:02:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9CF3B610A0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GgD1h2PzWz3bjK
	for <linux-erofs@archiver.kernel.org>; Thu,  5 Aug 2021 13:02:48 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=ZBMzEmoz;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=chao@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=ZBMzEmoz; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GgD1f1h2fz30CJ
 for <linux-erofs@lists.ozlabs.org>; Thu,  5 Aug 2021 13:02:46 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82D3161050;
 Thu,  5 Aug 2021 03:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1628132563;
 bh=qDBlW4B4gSwZHvi0mYWCYW7Dr8lxWPIo4xN7SW8CISY=;
 h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
 b=ZBMzEmozzYs+RWrxoqVWVhZffhTByzYBLMyWGiZ9EJcz5E96mEGEoOSNYnit26oTX
 PHNybnEppQ1owSsgoMuJdzxadgi/MBSQjIE5qOtgaWJrb+WsdwezQvvnvgjFKKnqmV
 eamgeqa2E+ul+d7NskR4SrkgmqYqobpn8FoqLhkvQ07r19vqeCqY9NoJrOi8cJqnub
 Nr7xb2UW/LfBCNQ50mS+ubNjWcX/loraGSu0TDyHH5rlvAvLrLKhjFoRKW7crtZoZm
 dW+NTmO0OBF7o3bCKLf08svLWoUUdE+b7tJ0vsYzpUzQDBmwvB26KJ36c6B0xnqGu3
 T2/r0u7VJFTzg==
Subject: Re: [PATCH v3 3/3] erofs: convert all uncompressed cases to iomap
To: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
References: <20210805003601.183063-1-hsiangkao@linux.alibaba.com>
 <20210805003601.183063-4-hsiangkao@linux.alibaba.com>
From: Chao Yu <chao@kernel.org>
Message-ID: <225f3b6b-7a78-5ab8-a356-893caaeb5dcc@kernel.org>
Date: Thu, 5 Aug 2021 11:02:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210805003601.183063-4-hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
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
Cc: nvdimm@lists.linux.dev, "Darrick J. Wong" <djwong@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Liu Bo <bo.liu@linux.alibaba.com>, Tao Ma <boyu.mt@taobao.com>,
 linux-fsdevel@vger.kernel.org, Liu Jiang <gerry@linux.alibaba.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On 2021/8/5 8:36, Gao Xiang wrote:
> Since tail-packing inline has been supported by iomap now, let's
> convert all EROFS uncompressed data I/O to iomap, which is pretty
> straight-forward.
> 
> Cc: linux-fsdevel@vger.kernel.org
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
