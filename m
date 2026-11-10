Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB88D606A32D
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 15:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L39VbUrA
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP94x5ycZz2yQJ;
	Wed, 11 Nov 2026 02:08:01 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::636"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794323281;
	cv=none; b=hPZuv/N84OqvHLcybXFc+l5hT6RhorwMtzY7iRS2T+Dxli8r5kcVkUfnZPHQCzq6Z0zYu1XDL93xT9oNUDfY3TNWKulIvB0FrEnhaajg+Kk5qQ6wZ1EX0fyXodYIPIuBYpbq3pQLIoVVvopf4kx9GH+T8LReVzpxo5kfa6SC6/etj93zCx6ZKYQwk6sMpzpLMS68e9Yaosn4thKFjtyjAzmfHwyhaH/o7PQPelxyTcCWsqMwyN1Dry5bD24cXWjMj0h2JUVNxNveS3fuLzPAqwmSwqYSsF8LVIfD8oozM9wsNbu4X3er4p8mvQ1p5i0vDhfWSpJdbo1wxaY1f3yavg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794323281; c=relaxed/relaxed;
	bh=JtM9UtzYhAWCxTCfoBKbcmHIR3U4Wq7tzdw7gboBY64=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YVOPBeZXY/DENV4eXdQaAbiLmS4AiS6YERrBJgliTx/hCQA4zUbJoNauJhcgCn6lZRDfwwNWTZslK3gh55hBxu7oMPwd5RS/5cTXYPT0QB7f1OSPMBfOJnwLZkedb+iXMv8LfHaNp4o5Ge2QZ6YytXOX0Q68HpFhRchvZ0iJrTZFI6W0J9scKu3qEeLHsfcecwHJD7PtE8VXUgfveQSQwKVUQtK4ueEOScUwjTxnZurbQkqSqTrpMH6cE9KrpBcL9FBbNxuE+x6meihlHc6qtK3Zvz6iRokn3XDHUgxP5bfM+kyF4/zx6xdPUC/FS+Bl905HKw06ds7KHhLHJsViLg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L39VbUrA; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::636; helo=mail-pl1-x636.google.com; envelope-from=kaylovefoss@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L39VbUrA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::636; helo=mail-pl1-x636.google.com; envelope-from=kaylovefoss@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP94x05r4z2yMK
	for <linux-erofs@lists.ozlabs.org>; Wed, 11 Nov 2026 02:08:00 +1100 (AEDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-2e977109392so12284675ad.0
        for <linux-erofs@lists.ozlabs.org>; Tue, 10 Nov 2026 07:08:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794323277; x=1794928077; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JtM9UtzYhAWCxTCfoBKbcmHIR3U4Wq7tzdw7gboBY64=;
        b=L39VbUrA9zqmT6T2zklJgi/i9F+Y/3ly5eRJ9lKEeiLaisxriqyLgYYWTG5/EEdR7h
         17gyYsbEt1q6vbbhmqG7tWeVGMehc7lwhEcRvEPpdgryeTgjeFO40jlnUSy6bl0gDz3m
         Tx6IR/1wUnwbKv9Ru+9MMerWh0s3eIjGa0qT+uXMxUOqxYTb9dRUIqYyZkCLM4NTKuph
         eepQWskjZnCpsL3UOBwPDjPYda+UPVD0diglSHUFPSkNhsfmKf1qB0i4ALGUAWMWbzp8
         fi8lA3pst9QaKpMhYT9rAU36N9rrAq3ygMxbxG3NYeAh911bDZAiNufrN995wCGYXcIE
         UHNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323277; x=1794928077;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JtM9UtzYhAWCxTCfoBKbcmHIR3U4Wq7tzdw7gboBY64=;
        b=yzaRqVKGzyfthVTq4MQnOzS/jws0wfKICN7TE1cB0mkddrH1MrNXBuNnZ2zq+/hU1F
         BfDw5HpeWToj/NFfWp77Dd95INy358aItDSMebt7bT2c3aK9a9C+8H7qgHAAtuvP3A6x
         uq9R34VcEWzRSDn18p4aGaaHvn0tzuy2E1wnySodJGzcYMf+sBt+zzRtAEfuuBIctaqR
         gzY2bjl16RhpVNIHKP0JNZ2g3/brxj1zw5u4pvRj2rojMv15nHymIeBuyxieSRp7Pwy9
         /vf6QN8MmHeTlDeP02wHwJKrasfqIygQaT/akELgADz2mRjbixvtt0xiYFOKOCtNkmB1
         h61Q==
X-Forwarded-Encrypted: i=1; AL+hErEAyuxCuXrZyavABxNj4xWiaUKHG0YwKoZZdiSDs8ivywOAWMdfeQRpAfj/h7Vizi7cK9iIVxZkzvPQ5g==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z+Vox0nIPUM0Y2eoT22IUT1+T/Y7Xf0Z9faP608o80oglfQ1smd
	in5YJnfvsVrs2w9ZdzQX/+J9EBujinu4v13V9uOknm848Y/Yijlncndr
X-Gm-Gg: AYBFou2dwuCST/pDTHNO1enKRXhWcm+QwrUUT3wRrI0zxEJQPtuKY96sPRYykKP2mZL
	IfDPHJzWDz9QbhdodyXtVZIZMOMPmJCZ0wRabfjsvVOdsxzYCAcVB14wfk1UXHT2w2Yxsh1XVY5
	VwrovwGGxsf+evt/zPvuk5iHPrCEHB4eHcyHbtOibI5fFM9YpFcRpTsUMN99PJEbHh0NVed3tUf
	/2EDbHZN7oWJ1UJhg4n+tpqZmecHSbhmHZ55wqh/fVX4Tv05tQQAjbf0lD8zAf3W1RAcmWEAxJJ
	TqzdzpxAcuSMbG/did7gprYlyYHp4OczxFGFLdAGyrq2FFdRtniLGJJLKNDxHJMZ6NjjI0uGnpe
	gAWy2bDnALOQkOkirUhk1TmSJ42ySW6TdxNIQ/QtkADHM73T9NywEgEssx6rG0MQOQk97Bgypvp
	RWGFUCs9JLTYETT2U+Qdthjx3P86SOPbVjFTlMly3TT9cKpnvMy89AbVDvObjRl/KNtk1ILP/To
	5qC8nBFIosMWWspJkUAbv2mBlUmzamzgPTNzOs/Yn+WxKCF5PG5PbIOHmmRkXFS7hwbEqD03cLW
	1RG5kvEAfNcF+0VySwjUrmOaPlfOICFRFSd6GXIE4VUxOpQtO7C+YcKwi0uGK1cH/i2zmLKMmam
	IRXTM58T/LuU=
X-Received: by 2002:a17:902:d481:b0:2ed:1ef3:9ec with SMTP id d9443c01a7336-2edb9172a2dmr26826345ad.14.1794323276968;
        Tue, 10 Nov 2026 07:07:56 -0800 (PST)
Received: from [192.168.2.6] ([27.75.101.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d78dbcsm10397575ad.27.2026.11.10.07.07.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 07:07:56 -0800 (PST)
Message-ID: <71f76e5e-ce24-4a71-863a-169ad262c510@gmail.com>
Date: Tue, 10 Nov 2026 22:07:46 +0700
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
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 36/41] nvmet: refuse files on pseudo filesystems as
 namespace backing files
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org,
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org,
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-36-4c998976c6c7@kernel.org>
Content-Language: en-US
From: Bui Nguyen Nhu Quynh <kaylovefoss@gmail.com>
In-Reply-To: <20261110-work-loop-pseudo-v1-36-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/2026 4:14 PM, Christian Brauner wrote:
> The file backend takes any path that isn't a block device. With
> buffered_io=1 that includes files on procfs or sysfs which then get read
> and written by a kernel worker on behalf of the host. Refuse files on
> pseudo filesystems just like loop does.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  drivers/nvme/target/io-cmd-file.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
> index dfa8aa46188c..71c69bac5394 100644
> --- a/drivers/nvme/target/io-cmd-file.c
> +++ b/drivers/nvme/target/io-cmd-file.c
> @@ -52,6 +52,11 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
>  		goto err;
>  	}
>  
> +	if (file_is_pseudo(ns->file)) {
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
>  	nvmet_file_ns_revalidate(ns);
>  
>  	/*
> 

I noticed patch 41/41 doesn't include a test for nvmet. Would it make
sense to add one with buffered_io=1? The test would need a pseudo file
that can be opened with O_RDWR and supports both read_iter and
write_iter. Otherwise, it could pass without ever reaching the new
file_is_pseudo() check.

Thanks.

