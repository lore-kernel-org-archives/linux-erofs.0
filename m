Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3DD606A337
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 10:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=b1+NJ9jl
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQtSg0rKTz3bbx;
	Fri, 13 Nov 2026 21:16:03 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::631"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794564963;
	cv=none; b=RQfS9C8Vga0XogT+mth9RDmCzYNxChNLTjiygdBvXnKhbgvZ+8ian7gguxTUt6ajR+PaYLAhwjniUCoK69xLSwnezs4eB6pY5QL+Nd0YR/Ce0xV/Vw5UARrl57ufJg/QvtEPdFBQmDC5Ee2QhC/TjZXeuHW5dkreSlcC7yilrCtvBePJjrGx0tJqOoV9YKzcOmTocftAM0f+E/5s9hV/UeXSGdMzssX4DLFgE1DpmPG6i+hzcUlrHeaspqmjHcU3zEnWqYmMjMoP4I23Oij5pJrf1xZpB1s/cVpkQPaHWOlBG0qdNbTZGSy3RPFLlFiatLLw7ZF4DUrinRnGxwb72A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794564963; c=relaxed/relaxed;
	bh=PfCz/38ILdxPmJBY1NDzDaIsiECcLTMyKpoKPJStEV0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oc9t8VIZFSdbqMmtZxYoMVer/AA/MrWTnlb8xriHrj4WtAuiabuMD2MbliBeV3zerUVYmtBRmk35JEsEvmZIhS3t/U8t3nedoNnXay+9E1ih+zf0WvVca/Zxe9MkOS10vF8M9h/RHIHUDeHDCG4Lc3arDA3tZphPPLaw3iWm2iaB9p4BBHPJjkFcoiO//Q27eg/rbjA+iJ93KOWdIJ7vnq5mixgjXpnx78cNzJkNgA9X/MvTkKcArGQ+FUtmyLqzZ6vww19KOjLdjJWddQOQzYJGHovixcj59JWDLy/KHrvfzO3K+1aS73ulFCEH5t6Tr1DaReblHSfjcKqgvPMt1w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=b1+NJ9jl; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::631; helo=mail-ej1-x631.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=b1+NJ9jl;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::631; helo=mail-ej1-x631.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQtSd6TMdz3bcP
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 21:16:01 +1100 (AEDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-c4cb6834eaaso156034266b.2
        for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 02:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564958; x=1795169758; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=PfCz/38ILdxPmJBY1NDzDaIsiECcLTMyKpoKPJStEV0=;
        b=b1+NJ9jlK9LpXcHE7bPhZJ1+TArHsVfU2ajFIan1yEmVePh3mRw3s35t9co0oc5LeI
         ZkEq6d+N+ovACa8azhbS7uInYpusPCL98XCgcVy5aI6Q61hmOf/A4VeJXxHmNd0xWq78
         2bZRtU/+x9rKdStm2bBtNRxawc+7xxr3jzoHh5Gy+b9ea5SSgifAKEyBTFO69ZwAwb1B
         sizb1xwy/qkF7+Ma0uQp9XXlrbvMO/mg6vp0JgWno0qXS6BzJJLUOix5dfyyTCWes0se
         Vfgxhg2rQnBLuzbHqe3kZU8RS/NdhQd8WSCxuECVOsoXV4kLJrSz6rjoPGVldWCoIDBL
         bF+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564958; x=1795169758;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PfCz/38ILdxPmJBY1NDzDaIsiECcLTMyKpoKPJStEV0=;
        b=Gf2Lsoohjh4AgU0z81UseoS/rslNZpC0OiosuFAuVHsFFc1BIccaS5MMtb+ZbffxtQ
         9FSSm2bNKLh6sNbSYXp8CtrLbBG1K53iHC4YlWEKjFm4OPdcAycHuksdmI1D4PMQbDTy
         tc9qbEiU6xBQtg9v6FCLYYCRrvdW7sSwYooOmTE1YoNfMlyY5TkqVMvtnOaIUO+/9OQX
         pYZeHleOs3oVhzIfzvk0d4BKb2Ld1VfLdwSM0YvElv0Yl1O8VKh+bTKbF+afGjQCvEme
         PbeaWZDQYyw2gV3XdYj6qEzDpUPl55yi/K6M6zqXjwZ1VUuiKKIdsJRGDCkCbWzaOvAN
         99Bw==
X-Forwarded-Encrypted: i=1; AL+hErGXBzuMvjB1Z6P9aOcdAXa4XJuywexxeEvFwIvf9hfsuPYoADWIJXAMUIBuM62q1EuXX+jSa3Qd8g00Fw==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z9iDAw2SDzrxh2qckiV84NNh1+/h7e9qu3f+O9F9KhWG0QedqiK
	OqxH9LeqPlA+OS6iOZygit9FKgIAjRxv3Foe7WTSqMT9pcUkO0SSEL6ptNxaZK77/xC+
X-Gm-Gg: AYBFou3yXUkeyabYFKu7vazWLty9C4PmvRu3kZCmzVZfa6VMy4WalUsXqJBNQho6nT3
	uxw0QFyJ87D9gEFIiqZYxwD1B8W+d2SlkYTTMeQK5U2QoO3fTzBzm9GAhZT/Qq2JIIPy+eIAztd
	ElNclHISdpmnUStus/oRItI6jSa2iViG5d6lbRMzrN2hLOFqaSpWRLKFKed2OkMSGZ2WcF6w9LD
	6XiWPjYfEjvfeyeSJ/YlrAa0goFuiMh+zCYiSrKXPb+/OFTzK49F1tsZjLOf8/kUrg9zVh4/VwQ
	LVhVL2yFdSDHwXj/uhMAp4pJMf7+PmcUrKxSGqzkvGAB/5YxJ0z8xwI/basbrHAgp6LKww00+KC
	zPiJ+3X13u3EjFuv435pBDi/A1mRIY+5Ksev/vMKib0GdvkKQGqlHf8FzTNt3iRHIUoDe3BNAqz
	l7h4ut9oPx4jNs4v3Nxl8sowqkE/1Aynaw2SURvDicQWrq9yOEw3t/mpqWE4GtP/v8qHrJhW0Q4
	7J0h28spBW8gD8HON+J5hrgMxwh+z/GxJWB8MCbC8PxXSa2H8cKySIbO+QIF+VyzQh+ubUmE43X
	nBT2Fv52aQCeX0q5FT++NV698EEWU9CQ2cQOn/o27T978M8ePyrpISZrpECgBBM=
X-Received: by 2002:a17:906:f59c:b0:c42:102f:15f0 with SMTP id a640c23a62f3a-c509614d4c1mr171873666b.3.1794564958075;
        Fri, 13 Nov 2026 02:15:58 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b7d1b7sm75606066b.74.2026.11.13.02.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:15:57 -0800 (PST)
Message-ID: <c5a694991af7e9182fd475a20bf4cfd73a13e395.camel@amutable.com>
Subject: Re: [PATCH RFC 34/41] loop: refuse files on pseudo filesystems as
 backing files
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
 linux-kselftest@vger.kernel.org
Date: Fri, 13 Nov 2026 11:15:56 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-34-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-34-4c998976c6c7@kernel.org>
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

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Currently loop accepts any regular file that implements ->read_iter()
> as
> a backing file and any that also implements ->write_iter() as a
> writable
> one. That includes files on procfs, sysfs and other pseudo
> filesystems.
> For example, /proc/kcore attaches read-only as a loop device the size
> of
> the kernel's virtual address space, 64 PiB with 5-level paging. sysfs
> attributes attach read-write as 4096 byte loop devices. Writing a
> block
> to the loop device of /sys/kernel/mm/transparent_hugepage/enabled
> changes the THP setting.
>=20
> That's not just nonsensical, it can be abused. Loop calls -
> >read_iter()
> and ->write_iter() of the backing file directly from its worker which
> runs with kernel credentials. But pseudo files enforce part of their
> access rules at read and write time against current. Dozens of sysfs
> ->show() and ->store() methods call capable(). Behind a loop device
> all
> of these checks are done against the loop worker instead of the task
> that opened the file. And setting up a loop device requires no
> capabilities, only access to the device nodes. So on v7.4-rc1:
>=20
> - uid 0 without any capabilities can't write to
> /sys/kernel/reboot/mode
> =C2=A0 as mode_store() requires CAP_SYS_BOOT. Writing "warm" through a
> loop
> =C2=A0 device works.
>=20
> - uid 0 without any capabilities can't read the files in
> =C2=A0 /sys/firmware/dmi/entries/*/ as dmi_sysfs_attr_show() requires
> =C2=A0 CAP_SYS_ADMIN. Reading them through a loop device works.
>=20
> - An unprivileged container that was handed a loop device can't
> change
> =C2=A0 gro_flush_timeout of its own network devices as
> =C2=A0 gro_flush_timeout_store() requires CAP_NET_ADMIN in the initial
> user
> =C2=A0 namespace. Writing it through a loop device works.
>=20
> The same goes for hard_offline_page, the md and sd attributes, rfkill
> and others.
>=20
> Refuse files on pseudo filesystems as loop backing files. Note that
> file_is_pseudo() looks through overlayfs so stacking overlayfs on top
> of
> sysfs doesn't get around this.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0drivers/block/loop.c | 3 +++
> =C2=A01 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index c96e35c3ef42..1482580a1979 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -537,6 +537,9 @@ static int loop_check_backing_file(struct file
> *file)
> =C2=A0	if ((file->f_mode & FMODE_WRITE) && !file->f_op->write_iter)
> =C2=A0		return -EINVAL;
> =C2=A0
> +	if (file_is_pseudo(file))
> +		return -EINVAL;
> +
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0

