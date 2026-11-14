Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DE9606A88F
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 20:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=kkQ5o71K
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRlVy02D2z3cHP;
	Sun, 15 Nov 2026 07:06:02 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::42f"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794686761;
	cv=none; b=GBJT3o3aEqrfmrOBAWmm9oCxyJ0xhjagqSSQDfNUt0BgfFZ8G9h5OfhT4YuQqD6yC7MPpixn3T2Xhi60GsG8FiGoEoyHVGbzfLFpNaHHmfJDsapYZetKiPAEPth9DB+9vkCpI/Ap/zj7T4aqg/uCWUEqW7uAAp7KVVJWDZeCkglVpJ0L3k5viWPTeGRoonkeZf6JbDqFF+pVVaxnzfOewyPoGxMG4LwpXtaV25u/kNG2TPd/wRKtUuYlpLX/9bvNKkTQA0BzqqQXDoTlKzs50S4x+/+xDWjCKp1BdLNZRKJl+IU0/I8lzES9SuAZoUsZ/fNyB4PaXiZ1oB59ud8RXw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794686761; c=relaxed/relaxed;
	bh=SncZUWGrBOxT9WurRufkDIe8hGFcWm37DANGybHY+fQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID; b=XHNXRHgwBRAf7yBfm0+n6nSks2uCV0UV6qCIdOxeNzDBPid78M/c3uwolQmfg/b/MBY4CmPJDNHwLY8v8SNM5+6uidDyE3y05itI+5hE0D3Aa7sD3VtAmb/tmRrGLPC7AGx8rOTBRuCCEk8dPfUyO5B6KvXZxAtviOfT6DZWj8AtRYEZiiSzt/ZtNRSxAzo4SImKG07FoYYo2OAT6EYL5WAXL4QP2m6nYn5YwEANDjXjOjCVBkPcg14IDi+MDMDUj/TXzk/Em4swN9diNnCPDc1qec1mEL5y4bboyYMmL6v9X3eY+mduhp/ZQAKTmVlKtNGMSIVX3Q9R7XNZMIJaig==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name; dkim=pass (1024-bit key; unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=kkQ5o71K; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::42f; helo=mail-pf1-x42f.google.com; envelope-from=chris@chrisdown.name; receiver=lists.ozlabs.org) smtp.mailfrom=chrisdown.name
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=kkQ5o71K;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chrisdown.name (client-ip=2607:f8b0:4864:20::42f; helo=mail-pf1-x42f.google.com; envelope-from=chris@chrisdown.name; receiver=lists.ozlabs.org)
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRlVw1Hlqz3c7K
	for <linux-erofs@lists.ozlabs.org>; Sun, 15 Nov 2026 07:05:59 +1100 (AEDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-8b5e5e64494so1463742b3a.1
        for <linux-erofs@lists.ozlabs.org>; Sat, 14 Nov 2026 12:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686756; x=1795291556; darn=lists.ozlabs.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SncZUWGrBOxT9WurRufkDIe8hGFcWm37DANGybHY+fQ=;
        b=kkQ5o71KsU48A+mqRI2s6G3Sv5o7MyNPr7JXdRcjVo5o4n5B1cv1zaCVvW0n4h04P5
         MyA5LUVIMjkyx+LB2S5f1k6WkASNaoJoiT4sPXUqAM0f/HZCjHbduKzzh3JDAxiif1wB
         zjbWZFpaoF51yCe4XZa3sl32BejD/hOHJMhg8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686756; x=1795291556;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SncZUWGrBOxT9WurRufkDIe8hGFcWm37DANGybHY+fQ=;
        b=Jh7wjxg61J8wC/m0LAQrMa9BSqHqjlrkbhMdQA8np5nOH7X6l0OQXOkseLc7rwR0MN
         hkHi+SIXjVZIWaGsTdlUK4ePdlla1PmjPKoND1gKrVRwo7WuPnG48fuMwiwcZOE5N9/+
         4OCUjOiTaSMz6kRPvoEKFZvvxAC8ngW5/Uce4+Ea2v3QNQqBcRpzhkxPZZoshM3H6xhu
         UDGaLIVFuCnHsEUhVZRh59jFjD6rXDf1AwIfgihw3V64Vm2qgiVp/uHwHn7E9mF6jy6l
         qKJlG2qIF9Kk9YghaQpL9lD10TGA+y80Z66gfpMCgYZYkx3+Qi4PXBIjzBh5BoasRnGd
         bjNw==
X-Forwarded-Encrypted: i=1; AL+hErHcRLcr3Qk0LVLHrTHrixBXUaHJXjr4Fke24StP6X0YzWshXo+hC89AMwFdR1/bCK0ScJV1YA/wP05M7Q==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z+Y1e+SSk04BC5wqrut/WEv1um1QhQapWJqPWvha60WTo8C8Vsl
	jE6MxTMa/V94piVEOEMgFwCrbF49g4DfXdJ2j8wkTL4lHDtnlbvzNH02DITTPjsLHG4=
X-Gm-Gg: AYBFou1c7INIXCbqN1v7KOU82Pf5bNcx8M7ksoDdDLscWNxczWED5etasiZLnIvCAMq
	KoVleUM6iJ1yka+3YpUgedB3nlin6FmY4Emcv8XWpBbFzK5GIuBPlqsAGeKjGuSvxn7luBK9DPy
	b0r/kKpCNp6xy8Ecurh6TA5RQavgzby5jWRGMyW3rlglCAWCcNhxOqKzO+vaFCoOuhcMe3UwwsD
	KJV0OuZlnQKn50ACjKxeeISZxEFOj7vrCVakl4t8TnU06el0w7IAgm+GcOqT8wKE3OcTQS8zgRq
	zDss4Y9ee9LYX8HmHSy+pGyKsBbXFi7BjFiMsnzLH9Qwkfe80+KZq+aEYMpRvF/kxzWIynC4IIZ
	M5k13YqsEKUCzQhcPKD1XUwxyoWt9yWSEp6iq9+B1M2GVNCFtWXYXuL0vxtAT5ntMm3KvdxILhi
	lf/EA5g7uBc812o0XuRQzUWfcurjS+jYunugPQoCTut7eLXJjRKnnidg8nQj1z4ZC29AaEHqU5k
	e05Sajv/QZok/OWKSplnwtUCqKF4I93KYRu0/jG3JVMxDa3FAqFdFtjRtNTH8bkQl6DD1zvwRau
	pOgwj8Uc6BbbjmPQsYSrQEs8erw+2lBrRRGdYvtSfnW27fCFdlsFSBP24JKGHoYEttMMl8BXC+f
	bhMCzBp5n5/g2Bfyesg3bsVXv/cTP0/cLyHi4s5Dkod5LzDhkQYqiIWK+hRkUoI6HzoSY+2p3Mi
	C0kmKW02/FDs6M9Tc4m/lQ9mjE6OD6gH8RT3TBjGhsMVJh7Ark03YoM+gz
X-Received: by 2002:a05:6a21:748b:b0:3e3:37ff:3795 with SMTP id adf61e73a8af0-3f7a4dbfbbfmr5517650637.7.1794686756009;
        Sat, 14 Nov 2026 12:05:56 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed12a8172sm2271197b3a.13.2026.11.14.12.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 12:05:54 -0800 (PST)
Date: Sat, 14 Nov 2026 12:05:50 -0800
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
	stable@vger.kernel.org, Alexander Mikhalitsyn <alex@amutable.com>,
	Breno Leitao <leitao@debian.org>, Casey Schaufler <casey@schaufler-ca.com>,
	Chuck Lever <cel@kernel.org>, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH RFC v2 00/42] fs: don't use pseudo filesystem files as
	storage
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
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
Message-ID: <20261114120550.0c9e73aa12a3072c@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Christian,

Patches 1-11, 13-16, 18-26, 28, 31, 32, 34-37 and 39-42 look good to me,
so for those please feel free to add:

Reviewed-by: Chris Down <chris@chrisdown.name>

I've also tested 5, 6, 34-37, 41 and 42. The selftests all pass with the
series applied, and a uid 0 without capabilities can no longer change
/sys/kernel/reboot/mode through a loop device. So for those, please also
feel free to add:

Tested-by: Chris Down <chris@chrisdown.name>

I've replied separately to 17 and 33.

Thanks!

Chris

