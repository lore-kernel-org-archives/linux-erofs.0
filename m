Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946E4606A329
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 20:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=nV5RXcAG
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRlW10bC4z3cP8;
	Sun, 15 Nov 2026 07:06:05 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::532"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794686765;
	cv=none; b=CvIMZgahh8TSdxp/wXGkjmB0eH2dcX+oAMatU5nbXUkcW9eFsxrEBe5KO2vNLqOxQ8KorfS7yPXcJYxGqnAA/tqvbvQVdA7EHHUt5rw/aKFEFMaRus5mehfMNisg4zWvjgO1nD7WRfAA+zMjKpvpvZVKnCOOoILVMbCTo++GxpD59yA90xKpXD32Oo0g9R5vmT99h3pmRANlfY5TZv217ku8lzXouo/gMrEkfFqlemLsI0uIrT9zPoN5bwji4SFdoRqz7dAiC++89FbfoDVPSO5JiTXphxlT+wuY6H2EapvUZjogxwpAJFmAxklC7+KjFQ6L8i/3MmSeivEbpK8TWA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794686765; c=relaxed/relaxed;
	bh=L9fh6nGpkdQ3PKE1Pv6VuACg3WWhS00/MicQv00SggM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID; b=oKbPC/lqH5PeHCutzesYmbzLF5Szqgxe3dDoL1Q/jXXTdV5vsruUGGtTZFaLLlzikZtValhjOukn7VZsyGZcBScIctyhFLUNgeRjl5iYLvsmQK5uIl2m490VDUS5WjOZRX9xs+BvHzUYViDt0ptDoOhpb/v3eBmH81WHWs/Ehm+l49rQVpHAXWTzPqw4/RjhEGxjs6BEDapjzCIHCeR6cUldmuSw6ry3ddEkSpSKsSzGbPXFAcAfvQ34Dr6q5y4jDSj1AFFeRYQetakpbhkbyNkqP6++DVv8JWS04d9dPCFNYfZ/pNeruXdFuISvvRLKfftVTV5k840WY9lZuusiEQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name; dkim=pass (1024-bit key; unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=nV5RXcAG; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::532; helo=mail-pg1-x532.google.com; envelope-from=chris@chrisdown.name; receiver=lists.ozlabs.org) smtp.mailfrom=chrisdown.name
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=nV5RXcAG;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chrisdown.name (client-ip=2607:f8b0:4864:20::532; helo=mail-pg1-x532.google.com; envelope-from=chris@chrisdown.name; receiver=lists.ozlabs.org)
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRlVz5vnnz3byF
	for <linux-erofs@lists.ozlabs.org>; Sun, 15 Nov 2026 07:06:03 +1100 (AEDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-cc758830601so2488360a12.2
        for <linux-erofs@lists.ozlabs.org>; Sat, 14 Nov 2026 12:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686761; x=1795291561; darn=lists.ozlabs.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L9fh6nGpkdQ3PKE1Pv6VuACg3WWhS00/MicQv00SggM=;
        b=nV5RXcAGUsYxIwGwFCOeZgIpoXWzEtmPBtlSIdHencdTQQs4b38rK24JrkX7xbB1m1
         ozUK/KqRhCmQNwdP9xgsqzDitR15XCvqwPmDurmJ05f/W6mKTCjSxE1aFbhWO5nd3/7H
         Npovnc+gVGzgpen3Yz8ugKhNX51m/s6T4Mwpk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686761; x=1795291561;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L9fh6nGpkdQ3PKE1Pv6VuACg3WWhS00/MicQv00SggM=;
        b=GhNkw7jmA8WFyqWxi+7cB5LwXecyi//W6/lrVVWEpug89ouLqW5rX2xP1U1jFBP37G
         g1qYqCE/cR1F8eKFeXw+DiLD8ZXSFO9WiEOSBg8UTwPwfdfkhqNGX42jY4iI9SZhmDtE
         BJYquPmzaclSchYT5QqCMrJiJrS0JyoU1twKa3HOVBNUhJ/yS6IjpsNjj0rUBNE/oFTo
         lbCcML89MGv8BFu1xl+E9hBkD9iOV9nrKV8blcLh8wJ1PftKiUaXBDTeGJZmWU+6TWaN
         yN7FA3Rir0GWGerBeBwRcKpGMI5f0J6z9WxCYE4zWWJAP60Ur8ZQ5ISpail4KoDObcmw
         CNSQ==
X-Forwarded-Encrypted: i=1; AL+hErEhPj2s0SQl6KiNeqf6OC2YYerV9V6W1XQC0DLyvpZv+bR6BFuVdA2OQWbN9VicNsI1H/CBMKdF0fQ4Qg==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z+Va/Bhu1Kdz5wcyFcUCKFmbAa2GRG54mcqzURd0lZjc+AADIp/
	jecp7zbPnbx65SaUV4dHaLuqWMm8glrNagHtzJgAMi9ZvJ6D0JiD23Aslw/yAJsYKDM=
X-Gm-Gg: AYBFou0PCuMvXp0Hih0i4fglAfoLx/NC8i7ZA3hw7vs8s5M048vG3ktbME0K0c08hhE
	nQwptExPUPteDgyTMg/A/DdiqDx1kKOS+VYHEdWF91OQRmSfhVg66abEWTBXFQtKx9aiPkkAVbT
	RgCzAaCyF+Jw9CPKt2GZMvCmsXSPIhRZ+v6osmj9KDV6uVjUvT6q1GHK+XjkI+z1tXi66uNtN+c
	cRtoUgei7bnxSzmnZ9Uppx9/DR1gtFz+Bsg+9CWgEffrLsVwt98b2slFiNBZg3yzfVfQpfb+tQB
	vllz/EkhWty8KlzMwosOVcNuEA5r3HASVeooeLO8WmFXFpDf6DdjKifxa3o/KTIBS2b0+I8tjn9
	QOodYtmz61qdZQShUBGpTioZxVyjwFrnE7oLB4CULwOhCbUvRJL7L+SKHPhDj2XpiYLxbG+QLNa
	OzO4qJ/R2LWY+rTE2359Qf/qnis4QbTRa+hrxw/3oH4y1ECKErwoz8gY3LtslPnDlOZmHpDvWin
	2pXod/ynYUs10e29ovklR1fZr6g5xJSixs1Mcbx9MzBiVVryGp0+OeXT+dUZwFNkeg2PGPyGi6q
	XuCQsZfOkg9OqX0m21GZhgwtIg8qwrIorEUtKmzOQkf/Yvg7JdNpdOdZHHEx73Mr0t3kiP7kJWc
	ihD/cA8J8QiJlIdlizU/QYkptQm3QsdO6jAs+kKYjrvV3tJYSX4NyKQNLe4izaNqe/Jw+WFsKP5
	T0IX7CwuWOLHVh/9J+UOW6NNOWQGdI/KG8PU+bi9ZTQbnRxsYr4rreqscz
X-Received: by 2002:a17:90b:2584:b0:3ac:9f00:3bc7 with SMTP id 98e67ed59e1d1-3b1b0ba61famr5629200a91.33.1794686761104;
        Sat, 14 Nov 2026 12:06:01 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b1e9ef15sm5258887a91.0.2026.11.14.12.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 12:06:00 -0800 (PST)
Date: Sat, 14 Nov 2026 12:05:57 -0800
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
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC v2 33/42] fs: add file_check_backing()
In-Reply-To: <20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
	<20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org>
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
Message-ID: <20261114120557.4bc1eb6e57218cdc@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Christian,

Christian Brauner writes:
>+	/* Look through stacking filesystems at the inode with the data. */
>+	if (d_real_inode(file->f_path.dentry)->i_sb->s_iflags & SB_I_PSEUDO)
>+		return -EINVAL;

This looks good in general, but what the bots said about O_PATH files
here is real. With FMODE_PATH this is reached for a file that was never
opened, so on overlayfs nothing has been through ovl_open() to look up
the lowerdata of a metacopy file yet. ovl_d_real() then does the lookup
itself, and when that fails it hits the WARN(1) at its end and returns
the overlayfs dentry, so the check passes as well.

Only fuse passes FMODE_PATH, so it takes CAP_SYS_ADMIN to get there, but
it's easy to trigger with that. From a quick test with a metacopy file
whose redirect into a data-only layer points at nothing, registering an
O_PATH fd of it with FUSE_DEV_IOC_BACKING_OPEN gives

     ovl_d_real(/f, 0): real dentry not found
     WARNING: fs/overlayfs/super.c:79 at ovl_d_real+0xc9/0x210
     [...]
      file_check_backing+0x308/0x5e0
      fuse_backing_new+0x219/0x4a0
      fuse_backing_open+0xe8/0x390
      fuse_dev_ioctl+0x53a/0x7d0

and the ioctl still succeeds. A normal open of that file fails with
ENOENT, so nothing could have used it as a backing file anyway, but with
panic_on_warn this is now a panic.

Maybe ovl_d_real() should just stop warning when the lookup fails, now
that it has a caller that isn't trace_uprobe? The check would still pass
for an O_PATH file whose lowerdata couldn't be looked up at that point,
though.

Thanks!

Chris

