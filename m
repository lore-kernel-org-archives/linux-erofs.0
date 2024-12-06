Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AFF5E77173
	for <linux-erofs@archiver.kernel.org>; Fri,  6 Dec 2024 19:46:39 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Y4hbK1rCZz30h7
	for <linux-erofs@archiver.kernel.org>; Sat,  7 Dec 2024 06:46:37 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1733514395;
	cv=none; b=TZORp5bOAD/M+v1dWEsR9uTFVmqoiU9RYtTxoSBpLQYUIJdsu4m8227dapWS8HHdc8aJ76uBZAqVVdnEVj7pVsF69nvWuao88a2rkUxLHWVT0k6vEjpjnryeEVSk3XIAsQxTToK/LopFolub2xzG3/eqTww+EtSzKinbEw9Ho589ICOXQsd+hE7H8OVlxzIGWSq/+0E3CEquxlb9rWlO5XB5q8UjFq1rFzZRI0LamW7c/lx0Gi/A4LJi6BVgc4N1f7wpi1T/ElbgoJWPx6QsOLmi20TFujq+TLlypA+JBIrBKw6rr8getC2f7NfVy9L/EQq8xumgWMyUSqjUB1czWg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1733514395; c=relaxed/relaxed;
	bh=znDVf9UKy4sVxxwV3H0M/2TDDC96qLINJosGTeRPNbI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ggA3TgGv247sAoHV86QO9jGQdKxk7rh5QSBXZRFVGITFVMrO/cM8r2HvNQNk2TKIQZGbZrYveGyOwqLd86lZlk673jf7gn3AzIFSarCn/qy5Qxadv8yF34txC3WGMUavdf1DNiGxfMBzKp+23t5JXYMFFe1AlbdZlas0biMDkR7CQN8KTGDPbe2LGU7swqMRySG0fIQ06hLfmX8pjR06zcogorjEIOoJ7n04g2fvmSWSimRmZ6F0uqTYfBiXnqVPoWj7eH6iHG3wbuBhVvAH8WEviv4xDZ08uopPCe3KHeXXhZJdhVvz7nhGD2O+vSsuyN41WitvagRmuFFXy34P9Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=XiC5macx; dkim-atps=neutral; spf=pass (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=XiC5macx;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Y4hb945MHz2yMF
	for <linux-erofs@lists.ozlabs.org>; Sat,  7 Dec 2024 06:46:26 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1733514381; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=znDVf9UKy4sVxxwV3H0M/2TDDC96qLINJosGTeRPNbI=;
	b=XiC5macxpGiEiJsksKxrBLvAV6m39jBhQq9PdVVxIqVPxX+c3sKgOODnnUHhkBZNOOgVS0JtFoIa0dLRkZjq6NLkBz1juRu0ouiA7fcYBuDEauna6b14QTue5puha8V9uSI963umA0zrGlWZklhRyI+e9T9rx8+Jv+WNEum86IA=
Received: from 30.170.86.122(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WKxTiNf_1733514375 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 07 Dec 2024 03:46:19 +0800
Message-ID: <17b4f35e-a365-4460-b2a4-9da660ae3e95@linux.alibaba.com>
Date: Sat, 7 Dec 2024 03:46:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mounting 4k blocksize on e.g. 64k hosts
To: Colin Walters <walters@verbum.org>, linux-erofs@lists.ozlabs.org
References: <406ae215-0f60-4f19-9be9-122739682056@app.fastmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <406ae215-0f60-4f19-9be9-122739682056@app.fastmail.com>
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2024/12/7 00:36, Colin Walters wrote:
> Hi, today in the composefs[1] project we do checksumming of a "canonicalized" EROFS (i.e. not written by mkfs.erofs currently[2]), and we hardcode a 4k blocksize today.
> 
> It came up in https://issues.redhat.com/browse/RHEL-63985 that on ppc64le (at least Fedora derivatives?) use a 64k page size by default, and erofs refuses to mount:
> 
> `erofs: (device loop0): erofs_read_superblock: blkszbits 12 isn't supported on this platform `
> 
> How hard would that be to support? If we have to start dealing with different composefs digests per architecture, things would be really messy for us. Especially given even that's not sufficient because on e.g. aarch64 nowadays in RHEL we support both 4k and 64k page size kernels.
> 
> If it's not easy to support mounting 4k in erofs regardless of host page size, I think for our use case it's probably OK in this corner case to just read the entire EROFS into memory if that helps?

Did you try upstream kernels? It's already supported upstream
since Linux 6.4.

I think RHEL 9 is lacking of many features.

Thanks,
Gao Xiang

> 
> [1] https://github.com/containers/composefs/
> [2] https://github.com/containers/composefs/issues/335

