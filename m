Return-Path: <linux-erofs+bounces-4357-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B42AC61DC4
	for <linux-erofs@archiver.kernel.org>; Thu, 27 Aug 2026 18:45:42 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hW9Sh2QJ6z2y8f;
	Fri, 28 Aug 2026 04:45:40 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=109.224.244.20
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787856340;
	cv=none; b=Hxj4GMKwkGliY6qyx1wj21tMHBbid7SL6Mpb85vh8gMnZerAEwTCjGoi+2ujlW1RwyJyRxqgtCgWA0KFdfROle+yG2ThXk4iyGinSUuFlGBZGggx+y3/MiX0VkpffviDWZ8i9BbOY1IOTBKnjoC9oHOlgMqWBgemk/Va9ZMWln2WVypMSXya9J7J4Xnro8+6AZb1nswDnIjYc1NBp5PkMo4A/Khrlk6qOZLBqemtXSm25NkvpXMQ2LpjIsvqbG7DCd3IAJU+9VtDhLpecmMaZFPgTZ7w/ZsJkTWGJ7YU3Zt8ezxwyZR4E5uMg6Abyny0cEHJVthBZMG3sqRqcopNpA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787856340; c=relaxed/relaxed;
	bh=wrwAXp7h2coI+Zsm1GtzWfjixIqm4Bde3+UXqffLn7k=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j5Cthw6xO8WUM58o/6YWZxd6SrvACNgO8DRk3it6Vd+5dXhNx/lWsNcUCe91BdWKUMJo+xUfWrAmkI6yr6bGzN9n7VnhmbBzxY7FWSn2NEBVVwVPITIgfKGk7CYrHRxghNQ3PG0FDD5visv6F+tf3pg2jYlftoiJ7lFesQzgnQqXmKb/WUmDoYtRMluurtH5rb7cM02m5NOxZVWKStohWC8ANtmQexJxsk6d7N86DqCVna+o9ZNJ+xDgo/p8w2K5hFWjzTGoYv4JgUpLfgyAcsnQMR/ImN/Ids0TmtEPmgBAAhBSM9JcoRlkHR83Q/Yx4c1RYMYzVimqPOHFqUOFwg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=namespace.ee; dkim=pass (2048-bit key; secure) header.d=namespace.ee header.i=@namespace.ee header.a=rsa-sha256 header.s=protonmail2 header.b=LBqjWH6L; dkim-atps=neutral; spf=pass (client-ip=109.224.244.20; helo=mail-24420.protonmail.ch; envelope-from=lenno@namespace.ee; receiver=lists.ozlabs.org) smtp.mailfrom=namespace.ee
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=namespace.ee
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=namespace.ee header.i=@namespace.ee header.a=rsa-sha256 header.s=protonmail2 header.b=LBqjWH6L;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=namespace.ee (client-ip=109.224.244.20; helo=mail-24420.protonmail.ch; envelope-from=lenno@namespace.ee; receiver=lists.ozlabs.org)
Received: from mail-24420.protonmail.ch (mail-24420.protonmail.ch [109.224.244.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hW9SX3hD0z2y2b
	for <linux-erofs@lists.ozlabs.org>; Fri, 28 Aug 2026 04:45:30 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=namespace.ee;
	s=protonmail2; t=1787856323; x=1788115523;
	bh=wrwAXp7h2coI+Zsm1GtzWfjixIqm4Bde3+UXqffLn7k=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=LBqjWH6L6mBF2Y/9wLFcrQqANHqrEAYMj3fpmwrkRPxnmHQfAdzBqKJUQ63fvQyAa
	 DW/JMJNDDdwOZWJ2Vp5v/T+f7OwEeaS5HvqZj0z6a2foUsPPwOLPFo3DoUgG2HCV3x
	 AZeNEtzO5vTwk+c1Cdy+buAgkE5CJp/JBIN96aOZsI3zSHFxy8jcp2UhPZZFL7PURc
	 McZcrERRq5vLMjlj6R7a3VHyIZNV9He7HkDeqQYaE8lCN48FkmprxUBES6R2M+Zfy+
	 7f5k6su+fjkq0qwf0RpDx0XtbZKjMOrnSJQd2LbfLkrWzevpQO0Ype/yE/Ncf43kWH
	 PDnJSHL7REL3A==
Date: Thu, 27 Aug 2026 18:45:19 +0000
To: Gao Xiang <xiang@kernel.org>
From: Lenno Nagel <lenno@namespace.ee>
Cc: "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>
Subject: Re: [PATCH] erofs-utils: lib: bound SEEK_DATA results by the inode size
Message-ID: <HTDxUtIgwmA_rCi5UiqhQp1hMA7LbWlkWyZ_mtQRKVGpFOjavEDm4nWk5X-L0sfxIla0EKa5x19x4UqhfrXNqwFW26wsoMukHvgwNSpX22o=@namespace.ee>
In-Reply-To: <ao7qJUU8YEq7ciiS@192.168.5.19>
References: <g6thRspQKWfiuTooyOe2QlTfKjPaELZs2Im4oTfBTwqb6w9NV1q4Rkc3O3bzQvbkn9lq94pAszmT2jHwKPPi0yWK3NoxpgWPefvUQSp2AOc=@namespace.ee> <ao7qJUU8YEq7ciiS@192.168.5.19>
Feedback-ID: 67709125:user:proton
X-Pm-Message-ID: 2e06100d6f8b96893fa65710f71fe7e503de620e
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
Content-Transfer-Encoding: quoted-printable

Hi,

I built your version with ASAN and ran both the minimal reproducer and the =
original 324 MB OCI layer through it. No overflow on the line where the unp=
atched build trapped at lib/blobchunk.c:398. Resulting images are byte-iden=
tical to the ones my version produced, fsck.erofs-clean, and extract back t=
o the original contents. Will send the formal patch based on your variant.

Regards,
Lenno

On Wednesday, August 26th, 2026 at 16:29, Gao Xiang <xiang@kernel.org> wrot=
e:

> Hi Lenno,
>=20
> On Fri, Aug 21, 2026 at 07:22:20AM +0000, Lenno Nagel wrote:
> > erofs_blob_write_chunked_file() allocates inode->chunkindexes for
> > DIV_ROUND_UP(inode->i_size, chunksize) entries, but the hole-skipping
> > loop advances `pos' in chunksize steps until it reaches the offset
> > reported by SEEK_DATA, without bounding that offset by the inode size.
> >
> > Since the diskbuf was introduced, `fd' is not necessarily the source
> > file any more: for tarballs it is a shared scratch region holding the
> > payload of every member, each reservation rounded up to
> > max(st_blksize, getpagesize()), so SEEK_DATA can legitimately report
> > the next member's data instead of failing with ENXIO.  If the
> > filesystem backing the diskbuf stores all-zero regions as holes (e.g.
> > ZFS with compression enabled, which also reports st_blksize as its
> > recordsize), an all-zero member is skipped in its entirety and the
> > loop keeps appending hole entries until it reaches the next member: a
> > 65535-byte all-zero member on a 1 MiB alignment writes 256 entries
> > into a 16-entry array.
> >
> > The heap corruption is silent where it happens and surfaces later as
> > an abort inside an unrelated malloc(), e.g. "malloc(): invalid size
> > (unsorted)" from erofs_balloc().
> >
> > Bound the offset with round_up(inode->i_size, chunksize) so that the
> > bytes past the inode become hole chunks, just as they do on the ENXIO
> > path above.
> >
> > Reproducer (out.erofs doubles as the diskbuf, so it must live on a
> > filesystem which stores all-zero regions as holes, e.g. a ZFS dataset
> > with compression=3Don):
> >
> >   head -c 65535 /dev/zero    > a-zeros.bin
> >   head -c 4096  /dev/urandom > b-data.bin
> >   tar -cf minimal.tar a-zeros.bin b-data.bin
> >   mkfs.erofs --tar=3Df -b4096 --chunksize=3D4096 out.erofs < minimal.ta=
r
> >
> > Found while converting an OCI layer to EROFS with containerd's erofs
> > snapshotter, which invokes mkfs.erofs with --tar=3Df --chunksize=3D4096=
.
> >
> > Fixes: 376fb2dbe66d ("erofs-utils: lib: introduce diskbuf")
> > Signed-off-by: Lenno Nagel <lenno@namespace.ee>
>=20
> Thanks for the patch and sorry for the delay!
>=20
> Could you confirm if the following diff works and if it works,
> could you send out a formal patch based on this?
>=20
> diff --git a/lib/blobchunk.c b/lib/blobchunk.c
> index 0523873..6cf021b 100644
> --- a/lib/blobchunk.c
> +++ b/lib/blobchunk.c
> @@ -369,12 +369,7 @@ int erofs_blob_write_chunked_file(struct erofs_inode=
 *inode, int fd,
>  =09for (pos =3D 0; pos < inode->i_size; pos +=3D len) {
>  =09=09off_t offset =3D lseek(fd, pos + startoff, SEEK_DATA);
>=20
> -=09=09if (offset < 0) {
> -=09=09=09if (errno !=3D ENXIO)
> -=09=09=09=09offset =3D pos;
> -=09=09=09else
> -=09=09=09=09offset =3D ((pos >> chunkbits) + 1) << chunkbits;
> -=09=09} else {
> +=09=09if (offset >=3D 0 && offset < startoff + inode->i_size) {
>  =09=09=09offset -=3D startoff;
>=20
>  =09=09=09if (offset !=3D (offset & ~(chunksize - 1))) {
> @@ -385,6 +380,12 @@ int erofs_blob_write_chunked_file(struct erofs_inode=
 *inode, int fd,
>  =09=09=09=09=09goto err;
>  =09=09=09=09}
>  =09=09=09}
> +=09=09} else if (offset < 0 && errno !=3D ENXIO) {
> +=09=09=09/* SEEK_DATA doesn't work as expected (unimplemented) */
> +=09=09=09offset =3D pos;
> +=09=09} else {
> +=09=09=09/* lseek returns ENXIO or OOB (considering diskbuf) */
> +=09=09=09offset =3D ((pos >> chunkbits) + 1) << chunkbits;
>  =09=09}
>=20
>  =09=09if (offset > pos) {
>=20
>=20
> Thanks,
> Gao Xiang
> 

