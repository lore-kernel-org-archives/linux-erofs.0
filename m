Return-Path: <SRS0=r8Mz=W5=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D9EEC3A59B
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Sep 2019 08:40:44 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 823C121881
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Sep 2019 08:40:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 823C121881
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=denx.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46MNp02rMKzDqdL
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Sep 2019 18:40:40 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
 spf=none (mailfrom) smtp.mailfrom=ucw.cz
 (client-ip=195.113.26.193; helo=atrey.karlin.mff.cuni.cz;
 envelope-from=pavel@ucw.cz; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=denx.de
Received: from atrey.karlin.mff.cuni.cz (atrey.karlin.mff.cuni.cz
 [195.113.26.193])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46MNnr0pmSzDqcN
 for <linux-erofs@lists.ozlabs.org>; Mon,  2 Sep 2019 18:40:26 +1000 (AEST)
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
 id 28B04813BA; Mon,  2 Sep 2019 10:40:07 +0200 (CEST)
Date: Mon, 2 Sep 2019 10:40:20 +0200
From: Pavel Machek <pavel@denx.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 01/24] erofs: add on-disk layout
Message-ID: <20190902084020.GB19557@amd>
References: <20190802125347.166018-1-gaoxiang25@huawei.com>
 <20190802125347.166018-2-gaoxiang25@huawei.com>
 <20190829095954.GB20598@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="NMuMz9nt05w80d4+"
Content-Disposition: inline
In-Reply-To: <20190829095954.GB20598@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
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
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
 LKML <linux-kernel@vger.kernel.org>, Miao Xie <miaoxie@huawei.com>,
 devel@driverdev.osuosl.org, Stephen Rothwell <sfr@canb.auug.org.au>,
 "Darrick J . Wong" <darrick.wong@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Amir Goldstein <amir73il@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 David Sterba <dsterba@suse.cz>, Pavel Machek <pavel@denx.de>,
 linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>


--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > +struct erofs_super_block {
> > +/*  0 */__le32 magic;           /* in the little endian */
> > +/*  4 */__le32 checksum;        /* crc32c(super_block) */
> > +/*  8 */__le32 features;        /* (aka. feature_compat) */
> > +/* 12 */__u8 blkszbits;         /* support block_size =3D=3D PAGE_SIZE=
 only */
>=20
> Please remove all the byte offset comments.  That is something that can
> easily be checked with gdb or pahole.

I don't think I agree. gdb will tell you byte offsets _on one
architecture_. But filesystem is supposed to be portable between them.=20

> > +/* 64 */__u8 volume_name[16];   /* volume name */
> > +/* 80 */__le32 requirements;    /* (aka. feature_incompat) */
> > +
> > +/* 84 */__u8 reserved2[44];
> > +} __packed;                     /* 128 bytes */
>=20
> Please don't add __packed.  In this case I think you don't need it
> (but double check with pahole), but even if you would need it using
> proper padding fields and making sure all fields are naturally aligned
> will give you much better code generation on architectures that don't
> support native unaligned access.

This is on-disk structure, right?

drivers/staging/erofs/super.c:	struct erofs_super_block *layout;
drivers/staging/erofs/super.c:	layout =3D (struct erofs_super_block
*)((u8 *)bh->b_data

So __packed is right thing to do. If architecture accesses that
slowly, that's ungood, but different structures between architectures
would be really bad.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--NMuMz9nt05w80d4+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl1s1XQACgkQMOfwapXb+vK1qgCeMhRodxdCMHktGBYzM6YZ0upo
P8IAnRXsAoM5UyuAx4MPbJJVq8NtKIG8
=L04e
-----END PGP SIGNATURE-----

--NMuMz9nt05w80d4+--
