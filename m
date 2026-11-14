Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FD0606A32E
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 23:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rT4coWWq
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRqq43Fy3z3cJW;
	Sun, 15 Nov 2026 10:20:16 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::52f" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794698416;
	cv=pass; b=TllxYiCeJZAd+O1IRWzHrrMENQYWEucLAX+aYTQZT5+4Jdu4nx+8jTB5l/2hZT8s1lwRVDW0ZIU/Irn3erqPa7w5/5ibpA4xIElb5fw6WJm6IL0JTC0YDxPRPF06L1hNMKNk+gG61hj7LVsUXiDu3IthTFbafYgx4YjHsAp6KczaBLW6IZLK7sAZLps/c9AnmNveJQZXS7wGm3qy+uvwTvisRbp3bS2UYwiQhOVniV0sjB6UsqUPNkOgwwzGrc0s9MXid22uuiKY3/JUfjfuPUS728ujB2Y7nYMg7XKE+McWBFZuBy6LToFpyS1Mk7UAxR5nML1giRwFDTFp3KDzsQ==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794698416; c=relaxed/relaxed;
	bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZaNt45ZhtrV/hx2gUDHqPHfxG5FZ3KENxXtuP3rOnYaj0ExAZzsdqS4unZwcPTcyE9+sgRZlH+A7hutvqpHwd2Mxlw6wcXLsy6/9Ce7XmN3YAdvS+yb7UpwlOsp3JNQriU1u1mU5mizVqiFjed5b+S/BtPXPrQYlxVHtkwnDESaYpWjgmJX7Qhl/z1FN6X+gao+iHmsjz2uoU2Gkau+d4KkxLEUY30/8Khr/mpIzGtxw2f6rRpBWuqeAAEja1F/nTUROW6X7wcpl/gdd4BseBx0F1zm5+m2ElyUugkS6GoLcAeRAnJ1QDkP5V0g/jfgiYMU0AyBK5Q0gKpC80WUfSA==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rT4coWWq; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::52f; helo=mail-ed1-x52f.google.com; envelope-from=amir73il@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rT4coWWq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::52f; helo=mail-ed1-x52f.google.com; envelope-from=amir73il@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRqq24BGrz3cGY
	for <linux-erofs@lists.ozlabs.org>; Sun, 15 Nov 2026 10:20:13 +1100 (AEDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-6b70192ebceso4502090a12.0
        for <linux-erofs@lists.ozlabs.org>; Sat, 14 Nov 2026 15:20:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794698409; cv=none;
        d=google.com; s=arc-20260327;
        b=cT4FiF1gZpgIVzVISLPNTdK1ab1D8auNa4OnIxZbGTLkqKVxGXP/tUff7hRyNABQ/8
         /OA4YpdrDoiGVifINkEQarQafQEjlB/7KHwIehybs74PaldpT2s/S5JtiZkGF57OBJZf
         WKKuU1Zv9pTSISv0/nnP1yL9DyBYS/MGcZcwDfWf7zD6+2VshO47BrXCMO34rnb2TjZH
         bPXw1Ieidb0BAARhk6eIiaTEPLN4T+1soSLfAzCl0KFxzs/VM1/nmwffOWNDhqxCzj+p
         xiSj+cgyH6kL/k3R/nO9tlOoM5btsr3fMeVvHsoPQ7r4lWDJsaVK2roJ8Kakg4TyLIbn
         xDsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
        fh=3nlVvAlaNMIcJk9iBsthcjc+BFgP26+gobu7iWHeCwY=;
        b=rAONiKmhnX26pjaFaul5ZLR5SnuPh/Z5KoX3pw3p4EmAOt5ikjZkPa4LyMqerS7M5X
         7cdcqHMgp5qRzwjb3oZo+qd3ddqHCxa3RxG7k1JYIxb77uPprcfCDUpvo03tzaHXJEm9
         syVNjozIbiuro1FTVy0VOTFAZU3ZsQt+UdRz3qU0q8V94dZjFvsINVpp0TJVYFPwqqcD
         DhD7YWDLSEZ02hoLqran4/B6gVdpATglX1/O5XLtqeQLHQoDI/fL+420DaoGjDtoSwa+
         MlKKx1JQ6vbriOBrIu3Ae3KNGXBtGFb60keI4Ln0Tw0zmtXuNwypD8GPBauoQPbno6uG
         Jpcw==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794698409; x=1795303209; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
        b=rT4coWWq34O3z+FRdCatQtGsOhe0d02arptSLGaaPmXJC9uQ+mg6AKFMSzG+u/XUCt
         cGxumwzGx5LwnFTkD2kemPmr82dqQrZvKC0ynNgt0x87PTzRW6D4YzY7tF517mL/WybW
         hzXJl7QiEqjSSJwMLhtqpRF1gbjGzMdgVJ8Ay8gxjVlx2Qn5+CZadMgZTkhH38s/SLnf
         QwZBFLnR18n6XZJ+1sJsD0VETHhfvS74xdSGrZhliHAGWGCCVPSYEtgHVrU0LBs/u8Ya
         XPQZxgKVHoJSpn+KVUEj2YRj8QYuRheF0OusgSAYYi6ZRYc/r7wCuGCKcc3vBvreMqPt
         qN4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794698409; x=1795303209;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
        b=I+cv5nB6b8LKA0z+xgVWnydI9jEmQr7EydhhktrKF4pGdBRR5ikeuGAYcOFs/zxmkT
         9/dw+GdD8SqD2bEiRp3LKkvDvoYb0qVMijhGdZDe26LYXDLq9h/4n/ssWMZ5h4W5xnyt
         s9QHR8DC1jaJUxAV7cF8PKyrfOrmYdb2ITWzOvaH2+IytOiBmOce3Tm78iqgY7YTY3pS
         jxkBD8QUdRh7aI9j/EnOaGS/KD/SRN9VV09aXs2qlQl9//IU34xiPeLZkCTIgFTUufM0
         PK5cfAYcZBLc7oKvaYgJAe1KcuGE3R2yiRw6Dc7CxgJK4je/ulShXXRzlGtVL8cjxIs0
         PpFw==
X-Forwarded-Encrypted: i=1; AL+hErE3VKMpbjEdQr37uv1RgGD3uGhLS4KPBPgMe7dYc1gZus5tg6Th2rCw8X1dByK6K963CM7DClFXeadOpg==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z/Y8mCa6T7C0OiO15L/KuOIVyrc3OXz9BPobvywK/1AhhvwfEU9
	hHTWbSBHiG6he86LwpAtVQ/zGKzJpXUa0MiGXkexmuae86F8orQszsorZMtaJ4jgI4pLOkLqvoF
	qOciB/3Q4SmZ3CifyLt399FbbYHYdOpg=
X-Gm-Gg: AYBFou2ulNinPsfpPevLyVfC1rXNlzMI4purTfiRkdaC5X7bJdZqNABAXY+L96MtNIR
	ymWg9nF6aKpxtPo7grZRqWcDfTyMATJiYQ+8XFHxfq0MVCK8C4/WWaRRYmr6SoLwVGTDogTTngW
	UtZ6UOxoVCqtzF+5Q2yiwo7m+6MfUNsZiymM+Ga6KfMJzBI/Qq/jxUM/u7DGdUVLCmY71wm3S1o
	VSsXF/cFRNIhfEq2BHXCphLDfWYw9hLSBtRiplgFpIP3dHX9UKiCQRyUsQqBHSZ02hj9NvvLsb+
	enSDX5jQQJma1ISSM/J1FDChtyCXF7i8PA9ToH4natxTkjddAusk0Q9Hik3ZRVtI9FNuwN4+5WD
	q17kYDWqzi8P9JyDMcI1UvjqTMx9JJgd8lVTg+sld65mxC7gzxanl+SSCB3tWX73R+QcCzw==
X-Received: by 2002:a05:6402:e10:b0:6b7:f00e:5e56 with SMTP id
 4fb4d7f45d1cf-6b7f00e5f37mr1542816a12.1.1794698409123; Sat, 14 Nov 2026
 15:20:09 -0800 (PST)
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
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
 <20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org> <20261114120557.4bc1eb6e57218cdc@chrisdown.name>
In-Reply-To: <20261114120557.4bc1eb6e57218cdc@chrisdown.name>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 15 Nov 2026 00:19:57 +0100
X-Gm-Features: AclHuK_YVxhIpv6JLzeNAX5mX5IHGfu05WS6uQ-TCKewxE3JKeci2PyA-UDMCbo
Message-ID: <CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo91QjJHH9T_Yw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 33/42] fs: add file_check_backing()
To: Chris Down <chris@chrisdown.name>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, 
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 9:06=E2=80=AFPM Chris Down <chris@chrisdown.name> w=
rote:
>
> Hi Christian,
>
> Christian Brauner writes:
> >+      /* Look through stacking filesystems at the inode with the data. =
*/
> >+      if (d_real_inode(file->f_path.dentry)->i_sb->s_iflags & SB_I_PSEU=
DO)
> >+              return -EINVAL;
>
> This looks good in general, but what the bots said about O_PATH files
> here is real. With FMODE_PATH this is reached for a file that was never
> opened, so on overlayfs nothing has been through ovl_open() to look up
> the lowerdata of a metacopy file yet. ovl_d_real() then does the lookup
> itself, and when that fails it hits the WARN(1) at its end and returns
> the overlayfs dentry, so the check passes as well.
>
> Only fuse passes FMODE_PATH, so it takes CAP_SYS_ADMIN to get there, but
> it's easy to trigger with that. From a quick test with a metacopy file
> whose redirect into a data-only layer points at nothing, registering an
> O_PATH fd of it with FUSE_DEV_IOC_BACKING_OPEN gives
>
>      ovl_d_real(/f, 0): real dentry not found
>      WARNING: fs/overlayfs/super.c:79 at ovl_d_real+0xc9/0x210
>      [...]
>       file_check_backing+0x308/0x5e0
>       fuse_backing_new+0x219/0x4a0
>       fuse_backing_open+0xe8/0x390
>       fuse_dev_ioctl+0x53a/0x7d0
>
> and the ioctl still succeeds. A normal open of that file fails with
> ENOENT, so nothing could have used it as a backing file anyway, but with
> panic_on_warn this is now a panic.
>
> Maybe ovl_d_real() should just stop warning when the lookup fails, now
> that it has a caller that isn't trace_uprobe?

Yeh I guess that this needs to be a Fixes for lazy data lookup.

The correct fix would be to teach all the callers to deal with an error.

> The check would still pass
> for an O_PATH file whose lowerdata couldn't be looked up at that point,
> though.

One observation relevant to this patch set is that a datadir layer has no
business being a pseudo fs and that can and should be blocked explicitly
at overlayfs mount time.

The other observation is that fuse_passthrough_open() should probably
check the backing_file that was opened for io in addition to checking
in fuse_backing_open(), which could have different FMODE and specifically
could be FMODE_PATH.

Thanks,
Amir.

