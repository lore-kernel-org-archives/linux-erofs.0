Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 545C6E6C612
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Dec 2024 07:54:28 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Y2Xwy3yxGz30B8
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Dec 2024 18:54:26 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1733212464;
	cv=none; b=nf5zGog9iFYgFTA7FPA/WlR8djMvar0EaedAEBu/Ofub9QrPThD2zoQTorlK5YOhSoSMtTbhKMNU51dq37bQJP+28ClFk3exxi/4if5/lrOrpzT0U1PqbIJrD+ycvVWLKNikjXsWMUP3Rf6xKCPU+ks7kmpqjvim0Nd5UaFcr+hKi43mxFPqyqXus1VewNeBn580SdbwCXgE4o1xeekoTBTAryT7UrmL4t0iw3Zn+W+rBs9WGvuDUGBN6I0n+6hEIpi+6MdnrpbWpAVHBTIL190ZU1cKC67gN3RBBBB+pT+Vb2SwQA26PvGGWtYk0DLtaDRZxgfhgS0c/bUaNCUSNA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1733212464; c=relaxed/relaxed;
	bh=5SgRX+7+NOmvdVrrojO2Q/2qIgy7ypImz7e1r3cIDOQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HlzTMxk1XitG0N8APzhnGC2aWeIQzGlhI60BRncgJgjru1ItzEgdcNfKZV0oCAb9fMuqsvxsapyV3G5+deQonW3n8tiZuMGDMGZ8AfZ8c4qEpBEshqKDNKXCJO8YptdPeniIUbL3IjrTcwrTuNiajAF9ktlDcgtOMCq8vvpemmSEuYMLZKzuDXSt9ixDlIgDl/X0u5KRLdfuzkdP4158KHvbEc7Li9n/OvHdLLMaAu/eh2W0VfnoAVg/TsQ/LwTWzkZXkQ3X2/2WFXDJTHpzjEo7xEK4TYNQDeYtLEM4KIlrPxpEIw5rMr6PkXwdaL571mZZmfoQkjRE0003xJYzqQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sLUOXh5n; dkim-atps=neutral; spf=pass (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sLUOXh5n;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Y2Xwr3DSfz2xJT
	for <linux-erofs@lists.ozlabs.org>; Tue,  3 Dec 2024 18:54:14 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1733212450; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=5SgRX+7+NOmvdVrrojO2Q/2qIgy7ypImz7e1r3cIDOQ=;
	b=sLUOXh5nDABv7oqhpSR+Qyol/s/fDKibzFtg6mQnLpP2xjCjzTFuNTiXiUht1hzjvcaZA2m68xJxciw9AEq6rsPf1kDZUUiZLOgTpGrI47Sy2RbPaHmP8SLMIsr0BRfcJUM0+7ULjob0oywUbu1fzJml9atBVJKIbA6Ohd3BUhg=
Received: from 30.221.129.129(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WKltEre_1733212448 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Dec 2024 15:54:09 +0800
Message-ID: <67cc7d14-33e5-4f0d-8fc0-86d4f94c9d46@linux.alibaba.com>
Date: Tue, 3 Dec 2024 15:54:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] erofs-utils: mkfs: make output stable
To: Jooyung Han <jooyung@google.com>, linux-erofs@lists.ozlabs.org
References: <20241203074531.3728133-1-jooyung@google.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20241203074531.3728133-1-jooyung@google.com>
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



On 2024/12/3 15:45, Jooyung Han wrote:
> The iteration order of opendir/readdir depends on filesystem
> implementation. Initializng inode->i_ino[0] in the loop causes the
> output unstable even though the entries are sorted in
> erofs_prepare_dir_file().
> 
> In this change,  inode->i_ino[0] is initialized in
> erofs_prepare_inode_buffer() instead to make the output stable. (not
> affected by readdir())
> 
> Test: mkfs.erofs ... inputdir(ext3)
> Test: mkfs.erofs ... inputdir(tmpfs)
>    # should generate the same output
> Change-Id: I41bb8d5487a77b83dfa69d3d085e38223ab17f87
> Signed-off-by: Jooyung Han <jooyung@google.com>

Thanks, applied without `Change-Id` tag.

Thanks,
Gao Xiang
