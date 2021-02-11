Return-Path: <SRS0=xD+V=HN=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EDECC433E0
	for <linux-erofs@archiver.kernel.org>; Thu, 11 Feb 2021 03:45:34 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B270164EB9
	for <linux-erofs@archiver.kernel.org>; Thu, 11 Feb 2021 03:45:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B270164EB9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4DbjFl6R2TzDwl7
	for <linux-erofs@archiver.kernel.org>; Thu, 11 Feb 2021 14:45:31 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=chao@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=pzvP5/Pf; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4DbjFc2JZFzDspp
 for <linux-erofs@lists.ozlabs.org>; Thu, 11 Feb 2021 14:45:24 +1100 (AEDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D934601FC;
 Thu, 11 Feb 2021 03:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1613015121;
 bh=iemugIdQeJU2GGS6+K1JMlL582bf/fRRHWUSkcs0xQE=;
 h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
 b=pzvP5/Pf2KZUwiesMWWK1VNT/7zGrBUXMeNentd8JwpdYQL2Bdr3IMN6cVBAz5Sm6
 dUC30JQAojoj57Jfxz0oorso/18dLWbVSIkVYMje0eM5gTjipLCVDbTV0AknH8W/xA
 pstGzFRpc94Ij5TLW6drIF0CEkcgy4Dyzg4lYCk0OpZP8Ej9nnMQMwIeAVC98xyakA
 uZMm9vYkNXsMu6Jgv+AyT9sj5j3IfTnzt+e9KAGLkGRhnBGUaQMyvj0+eLlBxPKIpm
 GntMSLfW8+oAVbZmorzS8uHVjCJoO3ftNJH5VxbcdS5tRCRJnRay4UGz+CmylcwOLl
 GB34gmgHudX2Q==
Subject: Re: [PATCH] erofs: initialized fields can only be observed after bit
 is set
To: Gao Xiang <hsiangkao@aol.com>, linux-erofs@lists.ozlabs.org
References: <20210209130618.15838-1-hsiangkao.ref@aol.com>
 <20210209130618.15838-1-hsiangkao@aol.com>
From: Chao Yu <chao@kernel.org>
Message-ID: <801d8f5d-9d5f-bc6a-1796-70d1038611da@kernel.org>
Date: Thu, 11 Feb 2021 11:45:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210209130618.15838-1-hsiangkao@aol.com>
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
Cc: LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On 2021/2/9 21:06, Gao Xiang via Linux-erofs wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> Currently, although set_bit() & test_bit() pairs are used as a fast-
> path for initialized configurations. However, these atomic ops are
> actually relaxed forms. Instead, load-acquire & store-release form is
> needed to make sure uninitialized fields won't be observed in advance
> here (yet no such corresponding bitops so use full barriers instead.)
> 
> Fixes: 62dc45979f3f ("staging: erofs: fix race of initializing xattrs of a inode at the same time")
> Fixes: 152a333a5895 ("staging: erofs: add compacted compression indexes support")
> Cc: <stable@vger.kernel.org> # 5.3+
> Reported-by: Huang Jianan <huangjianan@oppo.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Thanks for detailed explanation for barrier offline.

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
