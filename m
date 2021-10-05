Return-Path: <SRS0=qz5t=OZ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E618C433EF
	for <linux-erofs@archiver.kernel.org>; Tue,  5 Oct 2021 18:50:39 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8277F611C3
	for <linux-erofs@archiver.kernel.org>; Tue,  5 Oct 2021 18:50:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8277F611C3
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4HP6991D2yz2ymc
	for <linux-erofs@archiver.kernel.org>; Wed,  6 Oct 2021 05:50:37 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1633459837;
	bh=NhJmJ2GhjrChFePNVIANkzFcmmBCmTxHwcluBZ+z/ho=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=E4fametxCo8UE9ZK6UYBc9VXJ53ktCo1l87KFbxmmTTpN898EZjvp+YEKxAMwmHyt
	 wSRgdsgpPwA8tYENvCEoWPDp6QQ/2Cmyaj6oBvzP2Ja7I/6L5+evM8qNN1ZW72FHoo
	 G/xwF9QA+8y2Sk7whK0VszDai04eDeTPbK96DpAy02IORtuxi9wpnIiTbWgop/ZyMp
	 cs/0a3H0I5e8yppHguZkhoSG7ECYkA3FvNWT7cXddUsQY8jjfSoXE6I0ODaz0R20oK
	 LC5IZSekUXzq3Ipnq9DDkZiDa4rvjDLOzW6Xw/eV7R2cnNfhEmGjutVHOIKSIshL8X
	 BF650B1sw4/Pg==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=ieee.org (client-ip=2607:f8b0:4864:20::f31;
 helo=mail-qv1-xf31.google.com; envelope-from=pebenito@ieee.org;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=ieee.org header.i=@ieee.org header.a=rsa-sha256
 header.s=google header.b=FUPHd3CI; dkim-atps=neutral
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com
 [IPv6:2607:f8b0:4864:20::f31])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4HP6936rvgz2xX2
 for <linux-erofs@lists.ozlabs.org>; Wed,  6 Oct 2021 05:50:28 +1100 (AEDT)
Received: by mail-qv1-xf31.google.com with SMTP id k3so280127qve.10
 for <linux-erofs@lists.ozlabs.org>; Tue, 05 Oct 2021 11:50:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=NhJmJ2GhjrChFePNVIANkzFcmmBCmTxHwcluBZ+z/ho=;
 b=OWCUa8oAm4up8CZD/ApDAT4u2dGzpay/2IYdxjyvJtD6mo37DIAGHh12M4xUj62vCO
 JiA8IVDAr5XRAYwv2+auaT8L75WejYpy65vXijmudwmRP9kCctbEXg6KsCssheDjmPpN
 f1ynTkA0c+AQ3U1/31ng3SYq0ld4jIoXKKFgN9XvkpmhZvsZxUtehnl3lZr3XcMs8V77
 Si9pLBAF7Vi4OwdMI/0M6qQ5Zite8kACpNjhcnhkY3xleULL0Z47Zl+0EynTcDMI33pw
 AhDZCaKKfB8D7ajFAGWYMAY4DGB4kYZwKWw6XmZRz6XPdBe7dvqlFT+86MMu1O54kVTT
 97yQ==
X-Gm-Message-State: AOAM532mvS8tVGL98QQ0hSMQOrLJljrHqz2xQ2AMaZexXet3AEW9/pYd
 dqytD3DEWhTrtREnRlTTWwyRSQ==
X-Google-Smtp-Source: ABdhPJz9XsbM/eFmhmk/HhTpvR76lP+XhL5Q1S5TwTiO6p9IsZTXkHnedRB95ZkK2iRH0pAgTCnwgg==
X-Received: by 2002:a0c:f450:: with SMTP id h16mr29454818qvm.28.1633459824167; 
 Tue, 05 Oct 2021 11:50:24 -0700 (PDT)
Received: from fedora.pebenito.net ([72.85.44.115])
 by smtp.gmail.com with ESMTPSA id p19sm9711660qkk.83.2021.10.05.11.50.23
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 05 Oct 2021 11:50:23 -0700 (PDT)
Subject: Re: [PATCH] Add erofs as a SELinux capable file system
To: Gao Xiang <xiang@kernel.org>, selinux-refpolicy@vger.kernel.org
References: <8735pjoxbk.fsf@gmail.com> <20211004035901.5428-1-xiang@kernel.org>
Message-ID: <26267281-d183-6d5c-6490-57c7376625ab@ieee.org>
Date: Tue, 5 Oct 2021 14:50:22 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211004035901.5428-1-xiang@kernel.org>
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
From: Chris PeBenito via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Chris PeBenito <pebenito@ieee.org>
Cc: linux-erofs@lists.ozlabs.org, David Michael <fedora.dm0@gmail.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On 10/3/21 11:59 PM, Gao Xiang wrote:
> EROFS supported the security xattr handler from Linux v4.19.
> Add erofs to the filesystem policy now.
> 
> Reported-by: David Michael <fedora.dm0@gmail.com>
> Signed-off-by: Gao Xiang <xiang@kernel.org>
> ---
>   policy/modules/kernel/filesystem.te | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/policy/modules/kernel/filesystem.te b/policy/modules/kernel/filesystem.te
> index 7282acba8537..8109348f70de 100644
> --- a/policy/modules/kernel/filesystem.te
> +++ b/policy/modules/kernel/filesystem.te
> @@ -24,6 +24,7 @@ sid fs gen_context(system_u:object_r:fs_t,s0)
>   # Requires that a security xattr handler exist for the filesystem.
>   fs_use_xattr btrfs gen_context(system_u:object_r:fs_t,s0);
>   fs_use_xattr encfs gen_context(system_u:object_r:fs_t,s0);
> +fs_use_xattr erofs gen_context(system_u:object_r:fs_t,s0);
>   fs_use_xattr ext2 gen_context(system_u:object_r:fs_t,s0);
>   fs_use_xattr ext3 gen_context(system_u:object_r:fs_t,s0);
>   fs_use_xattr ext4 gen_context(system_u:object_r:fs_t,s0);


Merged. Thanks!

-- 
Chris PeBenito
