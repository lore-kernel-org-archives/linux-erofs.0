Return-Path: <linux-erofs+bounces-4097-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46FA4C55184
	for <linux-erofs@archiver.kernel.org>; Mon,  3 Aug 2026 23:43:24 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDYCG4sQ9z306N;
	Tue, 04 Aug 2026 09:43:22 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=212.227.17.20
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785800602;
	cv=none; b=UgCrJLilVLP5qefppZbZwBJQal6jBFxoTsb1wYs1TLaq/hNGEgs/sdPXgZpsxWUCZeArHgwvYQrCHGvTSr2iQjGXHfYWEtCxhnfFcGxWUMRASkjlcP101X3M7phDrTA8rK4aIdrJKdK0EOks0bMkJzVyO1pI9LlQPZvxa7dfnyr7vQxJKNyFzuPyAF22pnJ7rr/pZjLaFECqs4Bxzp66FMC5hplQntSHmTqlNeD/7B9YJcFnQzjb/Lx7lTAqRSW9OF+iBAqUT/uCS0TbNw0bQrj7mwmtMhe9kpjR/NxnDsFmR6eyvSGrRp0XriyXHMxnJbBQQSumm2UHThuM7dFc4w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785800602; c=relaxed/relaxed;
	bh=zDXi7OWTbpdPYjqvXuHmBoIm4oP9FwJhQNX1ofpFS64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dj7GnwpTU946zCvNqeqZSkz757vLqp+O/kZO38mZksDdWYjj2ShPskD9fuxIZO+VckP6rdMoKiMvdq8/8e+gtAg9z/ZwvMPx8vCTCEZBqVSycrUhWcNFsOH+/unh+oTnPFf/ojxxfHaX1ATA5NKwtKc/iZL9speyBqdcVrGZzhZE28rpCxEr2l30zqaNsNVADBuczwcBCLKVZ8aV5TI8Qeexy9wMmUvR+3TuT9Id4Zi1uYguQAwltvbjcafqLgin8p8iJUNOK0EP+68bqHnKPzr7/tjtwTkkd9ZtRwmOSwkiM2e9wC6/hRSN/BCobSMvqE6qanPNnKsNkySN/nRLJw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; dkim=pass (2048-bit key; secure) header.d=gmx.com header.i=hsiangkao@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=ClUe8BQ/; dkim-atps=neutral; spf=pass (client-ip=212.227.17.20; helo=mout.gmx.net; envelope-from=hsiangkao@gmx.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmx.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=gmx.com header.i=hsiangkao@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=ClUe8BQ/;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmx.com (client-ip=212.227.17.20; helo=mout.gmx.net; envelope-from=hsiangkao@gmx.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 340 seconds by postgrey-1.37 at boromir; Tue, 04 Aug 2026 09:43:19 AEST
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hDYCC2pP2z2yWK
	for <linux-erofs@lists.ozlabs.org>; Tue, 04 Aug 2026 09:43:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1785800594; x=1786405394; i=hsiangkao@gmx.com;
	bh=zDXi7OWTbpdPYjqvXuHmBoIm4oP9FwJhQNX1ofpFS64=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=ClUe8BQ/pp2GMUNKkVE16vgnkpgqhmoEhyBxahUo+r4DNycJdB+UOIvKJ0xuZ9s+
	 qmFnidlfijPz0IHavImQWk6jsy6Q896/I3ixU4jd4qd9xS3TgDQDR/fH1v6Did2fF
	 InFJjMMvuOERmIkCasJRqoa0R6H8eViWe0FZ43s1BxEpzqZ9NmpMG5Amo3fWpHNFZ
	 AsncY7xqa7EzUTa1ugFiuUj4zP6j7oPiJpoMTKLp69ZbPef4qMIyGLt94e9sSvCdr
	 fZk75/A++5AqzX1OS7RtY9ROhZ9ddry2OgLORFQNQ7Puq8ThSTW3U4MbBFJhNDGAU
	 sDQdIy9F/SVO+6Ydcw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mj8mb-1xMoGd2EMP-00hthI; Tue, 04
 Aug 2026 01:37:31 +0200
Date: Tue, 4 Aug 2026 07:37:25 +0800
From: Gao Xiang <hsiangkao@gmx.com>
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: Chao Yu <chao@kernel.org>, linux-erofs@lists.ozlabs.org,
	cyphar@cyphar.com, hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5] erofs: accept source file descriptor via fsconfig
Message-ID: <anEmNQWJzo-osec6@XiangdeMacBook-Pro.local>
Mail-Followup-To: Giuseppe Scrivano <gscrivan@redhat.com>,
	Chao Yu <chao@kernel.org>, linux-erofs@lists.ozlabs.org,
	cyphar@cyphar.com, hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org
References: <20260728160619.853924-1-gscrivan@redhat.com>
 <366a9c6b-ec56-4cdf-b373-22a3cd8c9beb@kernel.org>
 <874ihbxviy.fsf@redhat.com>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <874ihbxviy.fsf@redhat.com>
X-Provags-ID: V03:K1:MStWG9YfY+66xmSnK9qGZw9XYfyXfUlNxn/fbdKt5HaqrFJJmB+
 +G4V604W3dUPMCKkpky3H+aK4qlmvU3XqpbuvDmVb/XEhjDfeWn8cjlxNO82DV9AX+uh/jz
 7iUeIgEZ1W8bdenB9Q3ZYDDGZl3Jtbx4LuHVhzZgctEEji+arQ1gv1F0fu/qWXWUQItTmv0
 mZixgxAsrDjLhHo2ZwVhA==
UI-OutboundReport: notjunk:1;M01:P0:GeSdPTl3P4g=;uZMUv6BFEa3KC8cePuyFLSxTHfp
 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
 nXhKOmotG/KEgqxBiKCdNEILA==
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 03, 2026 at 02:01:41PM +0200, Giuseppe Scrivano wrote:
> Chao Yu <chao@kernel.org> writes:
>=20
> > On 7/29/26 00:05, Giuseppe Scrivano wrote:
> >> Allow userspace to pass an already-opened file descriptor as the moun=
t
> >> source instead of a path string.  This is useful for tools that alrea=
dy
> >> hold an fd to the image, such as composefs reusing an existing erofs
> >> backing file.
> >> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
> >> ---
> >> v4: https://lore.kernel.org/linux-fsdevel/20260717134147.1602735-1-gs=
crivan@redhat.com/
> >> v3: https://lore.kernel.org/linux-fsdevel/20260714154917.489993-1-gsc=
rivan@redhat.com/
> >> v2: https://lore.kernel.org/linux-fsdevel/20260711071137.4130824-1-gs=
crivan@redhat.com/
> >> v1: https://lore.kernel.org/linux-fsdevel/ak5GfvVfWLJU1EwK@debian/
> >>   Documentation/filesystems/erofs.rst | 15 ++++++
> >>   fs/erofs/super.c                    | 73 ++++++++++++++++++++++++--=
=2D--
> >>   2 files changed, 77 insertions(+), 11 deletions(-)
> >> diff --git a/Documentation/filesystems/erofs.rst
> >> b/Documentation/filesystems/erofs.rst
> >> index 4230884fb359..774e8b236d09 100644
> >> --- a/Documentation/filesystems/erofs.rst
> >> +++ b/Documentation/filesystems/erofs.rst
> >> @@ -139,6 +139,21 @@ inode_share            Enable inode page sharing=
 for this filesystem.  Inodes wi
> >>                          page cache.
> >>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D    =3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> >>   +File-backed mounts
> >> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> +
> >> +When CONFIG_EROFS_FS_BACKED_BY_FILE is enabled, EROFS file-backed im=
ages
> >> +can be mounted directly without a loopback block device.  The backin=
g file
> >> +can be given either as a path, or as an already-opened file descript=
or.
> >> +
> >> +When a file descriptor is used, the kernel resolves its path and rec=
ords it
> >> +so that /proc/mounts and similar interfaces can still report the mou=
nt
> >> +source.
> >> +
> >> +Only regular files are accepted as backing files; to mount an image =
that
> >> +resides on a block device, use the traditional block device mount pa=
th
> >> +instead.
> >
> > Do we need to add an entry to describe the new mount option source=3D =
in
> > "Mount options" section in erofs.rst?
> >
> > Thanks,
>=20
> I've another patch "erofs: reuse superblock for file-backed mounts" that
> also touches erofs.rst and it is currently based on top of this version.
> I wonder what is your preferred way to handle them.

EROFS dev branch usually has a small number of patches. Since Chao gave
a new suggestion, I think a v6 is needed (but you could add all
previous reviewed-by:).

And "erofs: reuse superblock for file-backed mounts" needs to be rebased
too, I will find time to play with it this week (or you could add a
testcase in erofs-utils experimental-tests if you have time.)

>=20
> Will maintainers deal with conflicts or do I need to submit them as a
> single series?
>=20
> Do you prefer a new submission v6 with the following fixup?
>=20
> diff --git a/Documentation/filesystems/erofs.rst b/Documentation/filesys=
tems/erofs.rst
> index c972a869f3e9..49c4e7dbc5d6 100644
> --- a/Documentation/filesystems/erofs.rst
> +++ b/Documentation/filesystems/erofs.rst
> @@ -137,6 +137,8 @@ fsoffset=3D%llu          Specify block-aligned files=
ystem offset for the primary d
>  inode_share            Enable inode page sharing for this filesystem.  =
Inodes with
>                         identical content within the same domain ID can =
share the
>                         page cache.
> +source=3D%s              (For file-backed mounts) Specify the backing i=
mage as a path
> +                       or as an already-opened file descriptor.

Not quite sure "an already-opened file descriptor" is "%s", but I'm fine
since it's quite a minor one (it's unneeded to nitpick the
documentation).

Thanks,
Gao Xiang


>=20
> Thanks,
> Giuseppe
>=20
>=20

