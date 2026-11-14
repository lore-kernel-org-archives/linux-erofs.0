Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3C2606A327
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 20:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=BkZ2Jf/N
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRlVz56gLz3bkb;
	Sun, 15 Nov 2026 07:06:03 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::52c"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794686763;
	cv=none; b=LzEROKhBqwgI33rRmsvZZHvNYyrd0X2jBAMX7ZdWpKL6HMkvV8DCymyF5d9M+yArML2NiB8rNUV64hZ9yezrlbvBbk9C+T+t3H9B7zDaS+gNOtZ0vlm0VSaYEYmlzO+qIsuVD4Poqxeuag+SlpH0p/t7IdHdUEfGt2EFHnEPjejvOwKsVok9Arh6/cEPrTUWZtg7Dgqbf6LMcL+kp5Hd0bhAYOtjuJFwhkBkFDUKr9HkHyEVzroGKauxxgpvY0WGRsobJfo17WJCzs16Ecx31M4MeKTk7sCtYDSu4j5pREjzMUaW8h+4igX58uYNNdY1jKE69CTYkJqiY88bEREVrA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794686763; c=relaxed/relaxed;
	bh=cEK0v6G1yB2cz/8630PKsjvi8Z78P9QyctaIU0ylRW4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID; b=f+TwCJZnJcYVgtACdpJHKwWxiLZVXlAMSx79XOgFDoJf/liJ6FOYU3D/5cxDj0a6p+0LlacB6g0d05XEt/DkaItgYE871RYrlfIVoUx2xm9nts3tctdwUrsr7YN3pZZ0EY9XnCK6xp5vnmxnE08HMDhiR7TaMxtx+7LS7E2WTWKokIjbiqHJnV2Xlbq5/dKfaXchdO3a8JLey0E2M3IcrT34/98rDds16d0A82OQI+dAlVgaAmJ1MS/ZsFHlNyC/w8R66HA+n2GKjhgkHIjp8THFQqOLDkac0PXIvxo0RhCGiM8igExIY4J3TYec+HQ+x9H5EnY4zVMM74U3yzXL0Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name; dkim=pass (1024-bit key; unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=BkZ2Jf/N; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::52c; helo=mail-pg1-x52c.google.com; envelope-from=chris@chrisdown.name; receiver=lists.ozlabs.org) smtp.mailfrom=chrisdown.name
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=BkZ2Jf/N;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chrisdown.name (client-ip=2607:f8b0:4864:20::52c; helo=mail-pg1-x52c.google.com; envelope-from=chris@chrisdown.name; receiver=lists.ozlabs.org)
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRlVx01sYz3c9y
	for <linux-erofs@lists.ozlabs.org>; Sun, 15 Nov 2026 07:06:00 +1100 (AEDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-cdb75699c7cso835204a12.2
        for <linux-erofs@lists.ozlabs.org>; Sat, 14 Nov 2026 12:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686758; x=1795291558; darn=lists.ozlabs.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cEK0v6G1yB2cz/8630PKsjvi8Z78P9QyctaIU0ylRW4=;
        b=BkZ2Jf/NMkDzH1CG1X7qkyq139ChwlaYOxKhDNtZtaEQk907mg7f09+Q3h8FfWZvJk
         cflfdNeCRZBP7CVNpZ4lll9TPz9x4jC+p+oD3cEIS7264GucTUGymAuysJkHS0IBm9rN
         F5js5PbQ5VPP0oYDd85+YRrsKW7LJwxvx9wkE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686758; x=1795291558;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cEK0v6G1yB2cz/8630PKsjvi8Z78P9QyctaIU0ylRW4=;
        b=M85M6LCLJhfME4OF/MdQPV0EQ80qmj7JllCYo/HxXKihLmJc6WQi1zoYxxRJ2fUGrI
         851VNRfhiItHBksXf+G05OD9RSclyVTrxLzm6Qzup3MQryGWqvzHEgi6oSuDZnpnT891
         sJV6nZPF1f3R9beV0V1cdCjOnqpiEdtMTirx4VuNa1IvNw7Qf0I4bSVXVNwS1tjyy5lv
         PDj8/4ZNhhGzA1C62Vt3zb0lkHo6AXwmcm/CPvxDhpM20tdUNB72F6OJMd/xWG0nqtvY
         QdxxAIdl7NMY2XgM7+KkFXZlH+bbP7kjEvN966/BLpeM1/Ge9nqLRwPc4MnBk6e6LOgM
         vjRA==
X-Forwarded-Encrypted: i=1; AL+hErGteCpnjz0l8d/oSI7xD+zmTx6y3bUa/efIOAB+2reVzWMhf53U/QbrSEXdtDGhE9gP5fEx2pppfdMQGQ==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z9c5nzjiSNkimIk8clJjbZL+YGBLxwOdOOhRIhFFsF2+QhDJXnp
	TjbpAMY+vh3Z7EYDLSDKTwI9azgt8POUK9acRu3lFwEfXIhT6g9f80xnFi1zxA9la1k=
X-Gm-Gg: AYBFou1B5Fb7kIG+PAsXDBGMlxICMSuoI+nJd33AgRZNcMx2zHpI8vVSDY+DnQ2aJOc
	VEqAj4fjQoHdNza1v1JzMwYSPi773sUec/1gV6CbUCH9DEXD3sNK6UJNjVW4lzgvSPIpLw9Qi/l
	rWA+MnxuT7/eJn7rwel3rwpvrreeTYQ/5tFebpx/MsaG+EMCoSpCeLL82qhDDidBv6HSbgCT7L9
	nP6kdAYUDRNYtptUimi1ZcrLZ9+OdEpgSI9VVAtIWnrp2LSSFalnunVdBdsk1HcDxl4AWCwsA6c
	EVixw7sFHZdwPP4rWy6+1jZlWLtvWk0Z6qPv/1iF5NpX0o8mxBJtB8MUFm8ixSpyRAKQ3MkRPNM
	IUIAzoDV2eklvNZ3Hmn4UmNh2dXLJ5++oyExsct90NWcZvh40e6l7m+2MPKD463DzBLWDY4d9qx
	U4Mo+f0zjdGh/QqYwXPTJHSbsrL1tS+Q3dXUdhOdScjCQNB4a51WHyVT61fZhuPEAhOoq/ej+9+
	vUqNGVfNUkVjw37ilgcOKwbW3p0AA/LR2QfP2q0nEvOU7tLYmfm0RJAD+5e2AxPBy/4TiAyG6mf
	v2pY8dyYmU7cM/pJaDg497BdnAkpB2HGqpucSSxgRuL+PSe16/bDL3u4F8qrLfozwQXBM58oBTi
	YNLH6IKWk+wI0I3cM8cONByzow2terNQWyVr99TImYBhOb6dHpCh+fHar2Khen2vQ+cw5T0tOd7
	4rr/f4qqFrFuLbAwdD/clHjqsVF2isUIrz4oRR8oatIhXnyJRN6+MpydVj
X-Received: by 2002:a17:90b:3b8a:b0:3b0:9f53:e8a8 with SMTP id 98e67ed59e1d1-3b1b0b5f2c1mr6192503a91.52.1794686758572;
        Sat, 14 Nov 2026 12:05:58 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b266d873sm4654869a91.1.2026.11.14.12.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 12:05:57 -0800 (PST)
Date: Sat, 14 Nov 2026 12:05:55 -0800
From: Chris Down <chris@chrisdown.name>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>
Subject: Re: [PATCH RFC v2 17/42] securityfs: use fc_init_pseudo()
In-Reply-To: <20261114-work-loop-pseudo-v2-17-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
	<20261114-work-loop-pseudo-v2-17-98639a2286fb@kernel.org>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114120555.cbfaf8ab8a92fb25@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Christian,

Christian Brauner writes:
>AppArmor puts a .null device node into securityfs but only ever opens
>it via dentry_open() which doesn't care about SB_I_NODEV.

Not a big deal, but userspace can see that node too, as
/sys/kernel/security/apparmor/.null. Opening it by path works in current
kernels and fails with EACCES after this patch. Now, I don't know of
anything that does that, but selinuxfs gets SB_I_NODEV cleared again in
the next patch for the same kind of node, so I think we should do the
same thing here. If not, it would be good to have a line in the
changelog saying that opening it by path is meant to stop working.

Once that's fixed, please feel free to add:

Reviewed-by: Chris Down <chris@chrisdown.name>

