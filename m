Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67127606A329
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Nov 2026 08:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=P8XScuwK
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jTHr20jHxz2y2B;
	Tue, 17 Nov 2026 19:26:10 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::334"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794903970;
	cv=none; b=lKOPhJI/FCRBQs9vblObMvGKYn2rIOpGzzvYfwbjGMMiAM5ifDTy/oENouIJFUG9dVJqX6CaUl0lowWHAld4LrR4KhVq+W+IemrNvbVvnEw4m3MeQBSaTP94DiAaqVTqRtFGl2sKHSoanKjMJus0We/d/SJxGKyKJdZcMb4OBJkFMVdsrF1iVA1PCQZ4Sh2/E1YhR4opOCnwATkfMUpzOxd/J4g2C4aadsFHjBFSznbRKk9ENiCO/cyK0ftoC+0+fabf8D5AvZIJHNkMXGwmwgevNdpwg+dauMmAL28qTcBPZE/pCMNVGqrDubyyq6vgC2Zr/+CoJO83T2IbESWvzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794903970; c=relaxed/relaxed;
	bh=z/NZRmC5bENRF/WsK1hUt6gARTy1xozW3x04wBCWbAk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PNwelItQ6iFdLD1curlObwNSvR/mkK+XgOmIHCPAwmFuDhIxcW4cTVbCspAEp4mEhzOh4nwp3wITE8yzKnBNkpRspKHsmp+qrevc9uac+dE/dan5JOAdpkKg3sdMZOTLFti1yH83MOU+yoqXVOM/cfXceX131mucMMeCByP0gEDopXi5HNXStRvlIU7dP1cuWVEkps0TqMvXRAXLdfjUyZihKT/siUrCV3vU5urla0uaXW0XY3wpATlk28AkaCwmH1iurKB1tiqiewVM0vZ4JOiHtaHdHLVeDODZXBQAU3lpBVNDv2lgPpLlFSFEF496fYau6uJOYnisiDLtXFV1Mg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=P8XScuwK; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::334; helo=mail-wm1-x334.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=P8XScuwK;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::334; helo=mail-wm1-x334.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jTHr11BGjz2xly
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 19:26:09 +1100 (AEDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so7875565e9.1
        for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 00:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794903965; x=1795508765; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=z/NZRmC5bENRF/WsK1hUt6gARTy1xozW3x04wBCWbAk=;
        b=P8XScuwKG6VaDoH5Y7ZwaRRnqAcn7mG0iF2/0tQR8nVtBv3qlt+7Jrms3GCyLYetxb
         DnmvUbOqrkk1U6TxYnaO9UOib21ASaGFUbpW29p0VvRYKtdcaPAo2e3yfyuu58NQdwWE
         tc+zOsCwAzD572cjgxmVvqyQp1gETV4sBJU6xUBNKwdqkccNWftRPFYFDOk7oF93j9Rr
         C29QxASSpVpOCI3CRmyOcOeG1BOQPeFgiB4p67YxGsgZYAm8asVy0mLoTfFBt+AC5ty/
         oODgNdbub7KZPfmTVdvm71/QBwLlquKeURpNxW883pJSzJ0sIunZdRk50afblWA5ZCQL
         oOag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794903965; x=1795508765;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z/NZRmC5bENRF/WsK1hUt6gARTy1xozW3x04wBCWbAk=;
        b=Qiq5HKVDi9K+OHEh10R0sbybsWG7QCgLMWtMjpYeuh0gLAimEOrg0ePArLPTP5k0D4
         6a/uZKtY4TJzJYYK5X9AUBXwBhoxRBcwXrnhouJLJJMuGViITXGDgXc1o8KX4MF3d0vC
         n/iBJVdccj0EpYzNoxsMbTG3mdIgi+Ak+EaxP5czVB5jiSwprjmyT8/thWQ8HfbkQoYy
         m3pDCQEi8GKF/4gUuLHUkJ1JWSR4M2XqzIiF8K1zST0JYkVq05MZ8Bt37TlR6RR2JATi
         lBPb2EW6XHc7P31X4PYB2RHxOBY7rpHAsqxfdR7JIM5WsxE/kMRcJN/huMAU7LpE5JRx
         lmWA==
X-Forwarded-Encrypted: i=1; AL+hErGPkvwVKxwrHfNE0o1NKzmffVoWg/rGXVyzrQb2WWbKtAdnulRvoh586uTfXldE4hbE0wNls8on7vFh3Q==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z+lNSMFpCxSZppmfJMgCVc26JrNBpsNyvAGpfTGivhNbbRXlGNx
	ZqpQmrJ7O9bhNJq+d0cUGk/jBRWlaDRVidqE1BaDzlYmwmtIjp2m90O8+zhVm619ZUaL
X-Gm-Gg: AYBFou0YAmZDxkmcZKtER/um77Q0EJ6S8PicEhbYp6ZWigYFwKtT9IlPtoBsT0GEPHP
	W57Iq9b5raE9M4Kz2f1SSpUmaPKmlpTV0VQiP02cnPku5kvt1S9rxKeE8h/5n8vklA7MPcEfcV5
	/jC6Lisx5+nCKD5PFNVDrGqpeXxDUSlNJb+oY3HWn92kpPR/GcRQaXcjK944/SdTSeB/bP4+DgW
	+2jq5v7X3t+WOvIGDn0pSr4Cu9nnPKxDHAXs9JlvhMTc3FGXkNLz6pDHqNTsT+7OZsSKhOvI5l0
	ErG89xhUlpHt4FVJQo00MZ5F5O5yDdEsndodQ7UVGYxbydCh+5BBniA/Kq27DhsFRgCIcYhzm/4
	PLGyumlQulRqEIoqId2dk+AM4px2dZydMmRmCB2bE+XY8F+u1H6/16iYK14wx8AB8V5nmlFJgnd
	shhAJ2yswvn/bvHc6WNbNgc/IGhhBAeOsu9dtUeTH8aSlvOusvm+u4Hb+ktyaWkzgIE2flBRiU+
	iAinMLUPcnYPw/8b9Q1IZOkV/ejIXjUUBFtp0/stxgM7nunC4uaixYMUP3Baw6+rOX+3f2qeSJ8
	2G0FngyopRaUTIwYmpvItSKb9IX8qbs7T/BGKTki7ZtwJETbISXbk5dohTHW+BzwNf8vCaL77yj
	WCrVbJWYbeNpLl2OT93gtDUyvnGc039fGK7UjMtJ1Z6k5ueSxcs54sgkl
X-Received: by 2002:a05:600c:5493:b0:4a1:c27d:e1a8 with SMTP id 5b1f17b1804b1-4bb783813a7mr42606245e9.10.1794903965400;
        Tue, 17 Nov 2026 00:26:05 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7ad9430asm12629125e9.15.2026.11.17.00.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:26:05 -0800 (PST)
Message-ID: <88041240268f70b218de7dfd58c41977d03a60d3.camel@amutable.com>
Subject: Re: [PATCH RFC v3 03/44] target: fileio: check that the backing
 file supports ->{read,write}_iter
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef
 Bacik	 <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, 	driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, 	fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, 	xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, 	linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, 	linux-usb@vger.kernel.org, Amir Goldstein
 <amir73il@gmail.com>, 	linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org, Chris Down	 <chris@chrisdown.name>
Date: Tue, 17 Nov 2026 09:26:03 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-3-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-3-8cbbea1cf34f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
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
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-16 at 12:04 +0100, Christian Brauner wrote:
> With fd_async_io=3D1 the fileio backend calls ->read_iter() and
> ->write_iter() of the backing file directly. The synchronous path
> goes
> through vfs_iter_read() and vfs_iter_write() which check for them but
> the aio path doesn't. So a backing file without them calls a NULL
> pointer on its first I/O.
>=20
> Refuse such files when configuring the device. On the synchronous
> path
> every read or write that needed the missing method failed with EINVAL
> anyway.
>=20
> Fixes: 769031c92c8b ("scsi: target: target/file: Add support of
> direct and async I/O")
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0drivers/target/target_core_file.c | 8 ++++++++
> =C2=A01 file changed, 8 insertions(+)
>=20
> diff --git a/drivers/target/target_core_file.c
> b/drivers/target/target_core_file.c
> index ab9824a4852f1..a5391e57e9aa5 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
> @@ -144,6 +144,14 @@ static int fd_configure_device(struct se_device
> *dev)
> =C2=A0		goto fail;
> =C2=A0	}
> =C2=A0	fd_dev->fd_file =3D file;
> +
> +	if (!file->f_op->read_iter || !file->f_op->write_iter) {
> +		pr_err("FILEIO: %s lacks ->read_iter or -
> >write_iter\n",
> +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fd_dev->fd_dev_name);
> +		ret =3D -EINVAL;
> +		goto fail;
> +	}
> +
> =C2=A0	/*
> =C2=A0	 * If using a block backend with this struct file, we
> extract
> =C2=A0	 * fd_dev->fd_[block,dev]_size from struct block_device.

