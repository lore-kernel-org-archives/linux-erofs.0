Return-Path: <linux-erofs+bounces-4283-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1B8DC5DF87
	for <linux-erofs@archiver.kernel.org>; Fri, 21 Aug 2026 07:22:37 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hRBbJ0NMnz2xnW;
	Fri, 21 Aug 2026 17:22:36 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=185.70.43.97
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787296955;
	cv=none; b=H8xnRT1m1uJPzpJM0pCs5zMqKcN3awXtP77s2tqBWDPOjYOIGiXghNHFKbMYkFMELQfGti9GGyVqSZAlluP/vVvAv/ya8Q/0iYuq5gfOT2DvSG5v+3yfXeS2eNLtlnjkGTPmiRDaWeyBE7kxB/G5mLP4LPFhhhAF79mjn+yCgf81qZ0druAd3GVqICbSD8oXYXY4uu8ItMl3Yi4imm/JImNkg1/C+94xOo4aweq4BBrhDIpFzUv2R2Wo/0Wyc5pBHgiiuFEIDEvYHHgHdtNM4DbuKANUCqcohSehFCRhYHHql/JLnuQbe79SA/CbTW/1TA9w7eqLM7BMxz/5VQ+X7A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787296955; c=relaxed/relaxed;
	bh=ieOkK0TC+fhf4BHI2Fd+yujhOfBZNTYNVDpyaUHjCmU=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=an117way8uM0mid6wbSJis17nUxFTSOK/PsPZUVPDVSy/Q6Rr1Y8DwlGf0tLum3VQlWOUTPkkpnK4uXf4wpemZtMVENPQyDnXXYQkYlRY6KRLf2E16eiLSjD2F2R140RiO6v55YIY/XrqUK9bNkgNWfbduDqET+SjuexRhpWcmtern7YO8iJt7mIzGCJKqeUO9Bi2j32zavNzThEMTuxSGpWRbZQ4rIKZ7swB42A9uVZRfO8aL16HMJH03EujrLo//JDYCCnMEHpZn3e5gjxYnhxDkxOyOkhVOifnyx9b2Dfgr2ug1eQhyyP9jnMLuIrL+jR6OwqEbNmIrHWuDeFqQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=namespace.ee; dkim=pass (2048-bit key; secure) header.d=namespace.ee header.i=@namespace.ee header.a=rsa-sha256 header.s=protonmail header.b=TEsLnbpg; dkim-atps=neutral; spf=pass (client-ip=185.70.43.97; helo=mail-4397.protonmail.ch; envelope-from=lenno@namespace.ee; receiver=lists.ozlabs.org) smtp.mailfrom=namespace.ee
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=namespace.ee
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=namespace.ee header.i=@namespace.ee header.a=rsa-sha256 header.s=protonmail header.b=TEsLnbpg;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=namespace.ee (client-ip=185.70.43.97; helo=mail-4397.protonmail.ch; envelope-from=lenno@namespace.ee; receiver=lists.ozlabs.org)
Received: from mail-4397.protonmail.ch (mail-4397.protonmail.ch [185.70.43.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hRBbB4LM5z2xRq
	for <linux-erofs@lists.ozlabs.org>; Fri, 21 Aug 2026 17:22:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=namespace.ee;
	s=protonmail; t=1787296945; x=1787556145;
	bh=ieOkK0TC+fhf4BHI2Fd+yujhOfBZNTYNVDpyaUHjCmU=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=TEsLnbpg3zahfZI8Wn3MrZTIWksEoQFImRhtig3rl8xxy55oj+S6MIRbNvqQETCao
	 /wrh2Kren3UjzA+9l6n86G2UXN+JeUvv8xhCrw9Bs+ih0MTXdz9pfCG617m7mHczZL
	 lRoUGQ+zY6NOtFNmqX+sVW91QS4xhgzT2Nr2Z32+jAymiL+M0kygNyYbXFIco3BLGz
	 ppuVaS6YRTPds78Fxg0ZCOrlISP3Spox/L83zj5JeIc9bOXjWCxfYFjJMDdgcZhTxl
	 f+C3VJ5yKqUhyGbbRqtsLA9LgGHsl1q6fedSEbhy3Y6KuRliu4JnlmtKzLcBDU4jnd
	 eblcZVYnQ/wXQ==
Date: Fri, 21 Aug 2026 07:22:20 +0000
To: "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>
From: Lenno Nagel <lenno@namespace.ee>
Cc: Gao Xiang <xiang@kernel.org>
Subject: [PATCH] erofs-utils: lib: bound SEEK_DATA results by the inode size
Message-ID: <g6thRspQKWfiuTooyOe2QlTfKjPaELZs2Im4oTfBTwqb6w9NV1q4Rkc3O3bzQvbkn9lq94pAszmT2jHwKPPi0yWK3NoxpgWPefvUQSp2AOc=@namespace.ee>
Feedback-ID: 67709125:user:proton
X-Pm-Message-ID: d5db72cdbf5086548559bea927b3d6a5ad09efd1
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

erofs_blob_write_chunked_file() allocates inode->chunkindexes for
DIV_ROUND_UP(inode->i_size, chunksize) entries, but the hole-skipping
loop advances `pos' in chunksize steps until it reaches the offset
reported by SEEK_DATA, without bounding that offset by the inode size.

Since the diskbuf was introduced, `fd' is not necessarily the source
file any more: for tarballs it is a shared scratch region holding the
payload of every member, each reservation rounded up to
max(st_blksize, getpagesize()), so SEEK_DATA can legitimately report
the next member's data instead of failing with ENXIO.  If the
filesystem backing the diskbuf stores all-zero regions as holes (e.g.
ZFS with compression enabled, which also reports st_blksize as its
recordsize), an all-zero member is skipped in its entirety and the
loop keeps appending hole entries until it reaches the next member: a
65535-byte all-zero member on a 1 MiB alignment writes 256 entries
into a 16-entry array.

The heap corruption is silent where it happens and surfaces later as
an abort inside an unrelated malloc(), e.g. "malloc(): invalid size
(unsorted)" from erofs_balloc().

Bound the offset with round_up(inode->i_size, chunksize) so that the
bytes past the inode become hole chunks, just as they do on the ENXIO
path above.

Reproducer (out.erofs doubles as the diskbuf, so it must live on a
filesystem which stores all-zero regions as holes, e.g. a ZFS dataset
with compression=3Don):

  head -c 65535 /dev/zero    > a-zeros.bin
  head -c 4096  /dev/urandom > b-data.bin
  tar -cf minimal.tar a-zeros.bin b-data.bin
  mkfs.erofs --tar=3Df -b4096 --chunksize=3D4096 out.erofs < minimal.tar

Found while converting an OCI layer to EROFS with containerd's erofs
snapshotter, which invokes mkfs.erofs with --tar=3Df --chunksize=3D4096.

Fixes: 376fb2dbe66d ("erofs-utils: lib: introduce diskbuf")
Signed-off-by: Lenno Nagel <lenno@namespace.ee>
---
 lib/blobchunk.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/lib/blobchunk.c b/lib/blobchunk.c
index 0523873..a066052 100644
--- a/lib/blobchunk.c
+++ b/lib/blobchunk.c
@@ -377,6 +377,15 @@ int erofs_blob_write_chunked_file(struct erofs_inode *=
inode, int fd,
 =09=09} else {
 =09=09=09offset -=3D startoff;
=20
+=09=09=09/*
+=09=09=09 * `fd' can be a shared diskbuf holding the data of
+=09=09=09 * other inodes as well, thus SEEK_DATA may report the
+=09=09=09 * next data region beyond this inode.  The remaining
+=09=09=09 * bytes are then a hole, just like the ENXIO case.
+=09=09=09 */
+=09=09=09if ((u64)offset > inode->i_size)
+=09=09=09=09offset =3D round_up(inode->i_size, chunksize);
+
 =09=09=09if (offset !=3D (offset & ~(chunksize - 1))) {
 =09=09=09=09offset &=3D ~(chunksize - 1);
 =09=09=09=09if (lseek(fd, offset + startoff, SEEK_SET) !=3D

base-commit: f36cadb5c563995ab3aa8572a60ed6b721b9557d
--=20
2.53.0

