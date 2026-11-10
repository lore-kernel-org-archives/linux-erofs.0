Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B4E606AA5B
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 10:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NzPKxJaX
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP2Zc5SDdz3bmc;
	Tue, 10 Nov 2026 21:14:48 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::52c"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794305688;
	cv=none; b=e2lJtmnlMPIJlkRWItXZWEJudi4ipFjA+MCNSehoNUC8oB9tGzuYYpiIVPpBWbQaAyknJ/9KT5/X36dUvKzlSNb5Fd9wRjS45l/EcbApFykLoK1YXMwPWDhBIfV4LE5ko1NVe3AkHxibfQGpVkKmv8JafCpqYGUCEsVSR1Us2apvxetOyfdeAyXpuo2OX6H8NsBIFJykIp4Zk3UZr5UyPq0+17h1bC15xsShFD3dbtjYDkubufbDf3jTfyFfTU4ILsWm/J2Jlw93AZ2y4YC58aUfNdsb+Z1h+cerey16EkYBWdbHCm/GKMubq/vo9DRN9sir/GaApWO7igdzM/IREg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794305688; c=relaxed/relaxed;
	bh=9WFltYRvNkpM0HMxRLJxGiCTEiP83WtKPHu+oXy3KTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SiUCTWkk2LwrS2xOYDSO9fKJMBOvROjcikJVifiT9KPNO7gEcnVvkA38/bCzS0QO5tA8RXtAjaOictFjMpLgHp6JUpzaQBz+sNUNYFXU+5ze3Me4EYXTe/rMgdBVXsfRe9LZ2rBX1K0XWxqfd/GX5CuGC3P2WcEt6KCaaMdBBjJ2eMwGc3cDJUJK8MvdaBhsKs8BXuRF+4WSvn/ypcDIIRC1r7hvh5UPs6eCTMUy/2d3B3CmXd/SSKFuXkQ/Wtskt+sNZt+cavleD1eYHOGdrL/p2goI38ZxqJc5wPsk1k+FYzoM1wY23lzQh3pC4Ct2LAAgj4rQALQeJiaXN3xXZQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NzPKxJaX; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::52c; helo=mail-ed1-x52c.google.com; envelope-from=amir73il@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NzPKxJaX;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::52c; helo=mail-ed1-x52c.google.com; envelope-from=amir73il@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP2ZZ5wpfz3bmM
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Nov 2026 21:14:46 +1100 (AEDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-6b56bbf8330so2383292a12.3
        for <linux-erofs@lists.ozlabs.org>; Tue, 10 Nov 2026 02:14:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794305678; x=1794910478; darn=lists.ozlabs.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9WFltYRvNkpM0HMxRLJxGiCTEiP83WtKPHu+oXy3KTg=;
        b=NzPKxJaXDeXxmGkTTFDG7CA7dgr22+WaifkWTnGFBOIHpQAdLSpDTaYt2u+sC/6Bn+
         BOdts0+eGaoakOHtVRaIOiqQLhwvSz6oaTnAn8Q8+gMD2Uh4XnTbsavlt7lmwyyvyyeN
         bX8tAIod0KqSbY5OtJKzy5wltGOI4F4VVMDMFC1JEnczWgBUlrGa8DO6jel1fZ8yNRmN
         B1A8dGElXmuzfw+tUbSZyzor56TYV0qHuppPnWr1kZUOZnBaaevtuu1hPzvCrPZ+8QmX
         O76gP/Ir/z15lHUfn5pEk7yiBdRaJnqcZi9ep/tqyknMgVuPFveEkBPuVEn6ATNo3iEF
         cPLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794305678; x=1794910478;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9WFltYRvNkpM0HMxRLJxGiCTEiP83WtKPHu+oXy3KTg=;
        b=IqpwsxWn45jxMUvIYCb87vDld2ZE2UZ+LeycoSCu4jPX/P1R+LDOd+G85ChjOPfJyv
         TVF5sq1Q4hk4yZkM1dqqvqWyl/mW2E+YPwX17gTXZ14cuGZYJthl/u3pA0cFcC6Wyj7D
         vhesWfd8+YxrlZEivZ82+ogAMMTOsxljxYdIZtVzTpvy8tvM6jybn1XGb5lgEU2xVnKf
         HQpFk2dZuSiNpUQsqLkwBFzTc+Dw8ouR9r9C3dbHG5CdqXgj/j0Rd2ww38NZk3N7nLro
         So2djFBtNY/KnNIWT0iYGXRIIObts8xG6shq8okpn/am4VqbaRlbsxpxHTbQH01EJXW6
         PJ6w==
X-Forwarded-Encrypted: i=1; AL+hErHmjhRGECRbyrW3GKnr/1ERMEMyalPle+8KmS5uTkLyDTVHsKwx2zvDq6aScg9i6vrc5kY6ygzdDnIGoQ==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z/Gx59h7yLE04/RWb6qG34oIYZrNdxJXON965F8pcV6hYR9j7Z+
	M+uMpjdHnoqpGZvw6X5cOoBXJNhvpvWTaGseo3idU7dmLuRmXp0ENcTx
X-Gm-Gg: AYBFou2+GV7WgfcyaM3HwZVRHflbkXrEz0H2vRHKxdIFu0VGnGjccFB0WPGkW5vq1J6
	hK6fmjGGw4ruvZ7ExMpfGb/XSQyxrdGHQCMQUgLgBTghxDetG1IfmMyByQthIapet1LOG0hC6/S
	q+5PsPvbZ5QriQX7ha+r6fc+I30CyI1q451Hs7dHVH8RkMORezO4oMU9n5iN/HC1q6/rYbKQerZ
	u99Ll68xPm8WpBW/7rQthNwt4GBLsbWY5Vvp6jZTSJDJIaQifGp6emrkEqnZX+2S+TH+qumYPti
	9ehj+upTdXrS/+6vqxQ07irk2UDQDFfj1Qcpoyh0TjhzWWAZRiftSjtdS6wkUt1IpacKkGdQHu0
	kXfI7dVJUqQC/qnlE+/+gsWJUbpgGQ0DLwYSnNKS319EFI3qw9YHVyy1ifESOxhMCpNERNJxvcW
	0ZHMQKl5CbVKsmDY3T1723IQtFxTLqdnEoi+gprQbUeFx5wx9BpnBl0XnV5Z0+okhm5xdsu4cyD
	XMzokx44NO9H02zkNVnqfzAlck9VIQiCY7iuUZXHObiSltHZJ9FDu+0h4iM64kfWvs3lXYNNr55
	YEbLbnz8CzCvsn5RzIfljftD00WECcZl4NnLUNWRlUFrnGJvoGq4FKydSpToh7CIoLlyfsqnf5S
	z9Ky8jJCSUOnV
X-Received: by 2002:a17:907:944d:b0:c41:4c20:5a80 with SMTP id a640c23a62f3a-c504963ce05mr189793966b.44.1794305677695;
        Tue, 10 Nov 2026 02:14:37 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c504a593eacsm90433466b.36.2026.11.10.02.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 02:14:36 -0800 (PST)
Date: Tue, 10 Nov 2026 11:14:35 +0100
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 38/41] fuse: refuse files on pseudo filesystems as
 passthrough backing files
Message-ID: <avLui6Mpf8GbKbtc@amir-ThinkPad-T480>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 10:14:54AM +0100, Christian Brauner wrote:
> The fuse server can register any regular file as a backing file. procfs
> and binfmt_misc files are already refused by the stacking depth check as
> both set s_stack_depth to FILESYSTEM_MAX_STACK_DEPTH. sysfs and the
> other pseudo filesystems aren't. Reads and writes of the fuse file would
> then be done on the pseudo file with the fuse server's credentials.
> Refuse files on pseudo filesystems just like loop does.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/fuse/backing.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
> index 8c21a8a74efb..4e4fb810ddaa 100644
> --- a/fs/fuse/backing.c
> +++ b/fs/fuse/backing.c
> @@ -147,6 +147,9 @@ static int fuse_backing_open_file(struct fuse_conn *fc, struct fuse_backing *fb,
>  		if (inode->i_sb->s_stack_depth >= fc->max_stack_depth)
>  			return -ELOOP;
>  
> +		if (file_is_pseudo(file))
> +			return -EINVAL;
> +
>  		fb->type = FUSE_BACKING_PATH;
>  		fb->path = file->f_path;
>  		path_get(&fb->path);
> 
> -- 
> 2.53.0
> 

Reviewed-by: Amir Goldstein <amir73il@gmail.com>


