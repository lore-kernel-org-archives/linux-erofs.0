Return-Path: <SRS0=k0ix=ON=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 804C3C433F5
	for <linux-erofs@archiver.kernel.org>; Thu, 23 Sep 2021 15:09:38 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1AA496124B
	for <linux-erofs@archiver.kernel.org>; Thu, 23 Sep 2021 15:09:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1AA496124B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4HFdqh3LbJz2ywc
	for <linux-erofs@archiver.kernel.org>; Fri, 24 Sep 2021 01:09:36 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=OpjLqQ3w;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=chao@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=OpjLqQ3w; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4HFdqb5CLNz2yS9
 for <linux-erofs@lists.ozlabs.org>; Fri, 24 Sep 2021 01:09:31 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34A0561211;
 Thu, 23 Sep 2021 15:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1632409769;
 bh=oA+WWs5P3iaZypn5jU4SpKYZzff2WutgvUss6C8I1ls=;
 h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
 b=OpjLqQ3wJS0mnuI98GptpCEetjJ7ryrKPRZawRxcJyOjz39Wm0twQ88tzZObVtMa9
 QirClY/g+GQBLZejLEdyBfzOjNXKsC8u85V5dflPNMap/uUNEpb4PbYBWqazCivDFw
 H1CeAhEm7ctFniGz5gqTchtFCM7PmG7d14tcezwZGUo7yhVbFREvm4RmiW4Vx6F0wc
 4WM7ylAKNg00kdQNmWhhvx9MxVp5DT7oMWgkYHMm2QA9FOmnbvua9/xgug/pzRWpYI
 mEno+UW5OxERAGrRNu1ijGqrngs6+dF99CMPNCbq3VGnxP2JfOZVFXYMhHrksK8y0S
 S0mBdZrDOo02w==
Subject: Re: [PATCH] erofs: fix misbehavior of unsupported chunk format check
To: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org,
 Liu Bo <bo.liu@linux.alibaba.com>
References: <20210922095141.233938-1-hsiangkao@linux.alibaba.com>
From: Chao Yu <chao@kernel.org>
Message-ID: <926fb1a9-174e-26de-c9ed-70aa0a01d394@kernel.org>
Date: Thu, 23 Sep 2021 23:09:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210922095141.233938-1-hsiangkao@linux.alibaba.com>
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
Cc: LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On 2021/9/22 17:51, Gao Xiang wrote:
> Unsupported chunk format should be checked with
> "if (vi->chunkformat & ~EROFS_CHUNK_FORMAT_ALL)"
> 
> Found when checking with 4k-byte blockmap (although currently mkfs

That means for 4k-byte blockmap, chunkformat should be zero, right?

> uses inode chunk indexes format by default.)
> 
> Fixes: c5aa903a59db ("erofs: support reading chunk-based uncompressed files")
> Cc: Liu Bo <bo.liu@linux.alibaba.com>
> Cc: Chao Yu <chao@kernel.org>
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
