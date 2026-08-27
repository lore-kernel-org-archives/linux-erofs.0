Return-Path: <linux-erofs+bounces-4358-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81965C61DB9
	for <linux-erofs@archiver.kernel.org>; Thu, 27 Aug 2026 18:45:53 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hW9Sv6NQ6z2yfH;
	Fri, 28 Aug 2026 04:45:51 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=109.224.244.117
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787856351;
	cv=none; b=oTmmvY0Zq2amMqlLbkv8iJXseeD10chgYVnCc1iO5sdOrlbC3GQxbgQocyl7mDMhM5WB5tWFCh8azml3WAxgBOlP5qbaKINokoWL7lM/csv/KtaCar3oz4wHerUMhc1eqOom6fLTRFQyQ9EqWLmL/hCBUYJ2jEKMqHo8THncltGLh4c8M1xt3tJu9i8PhzGameJPtZyWK16ukqlnxG3to0PfFeNpbs7vIBmsYIwTXmIJDWzLAIEEBCd4KmpKTXpKjyfx1qWhWP108pcwljWZ51vnIIkFNaKoNPk1yFraI2l12jM/2c0pgtMbwf/Dh6M49TGxDMOzYGoNQRzh0BKaOg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787856351; c=relaxed/relaxed;
	bh=xqm/taN/9THyjEH1pnINltXdCRTdloD99mca9CMn2cE=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=UKF9CASestQo0RXVkyjajmd0yBA3+FzxhQ5UYidy3f8fKgewEOTIQnJii/CPcuvYUIBOwL82gEe7zAIvtwKkPiUYaV70GSl0eeiN5fSKfGusNhW4j5uoQ2uL46a/nnJpBSksIyp4eDjlYp37Y5Iy+kqaTY7DF2KfyX/o9ma3iKMvAfQR2yhX9huYIDhWdf5ef4qKxLbs8NtP8NRodMUGqKBpRMk6Q07WijTBQMmUfnqTr5EUS4/zB8CGKaaGLD2oNPpNz4W1BU+o/fVC+cTpH5AXoR6odkIqyw+CuKZmGNSGMtetmlNoZ8TCwsMR8owOxl+ACWDWXGMWYOOel62xng==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=namespace.ee; dkim=pass (2048-bit key; secure) header.d=namespace.ee header.i=@namespace.ee header.a=rsa-sha256 header.s=protonmail2 header.b=F2HEBENi; dkim-atps=neutral; spf=pass (client-ip=109.224.244.117; helo=mail-244117.protonmail.ch; envelope-from=lenno@namespace.ee; receiver=lists.ozlabs.org) smtp.mailfrom=namespace.ee
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=namespace.ee
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=namespace.ee header.i=@namespace.ee header.a=rsa-sha256 header.s=protonmail2 header.b=F2HEBENi;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=namespace.ee (client-ip=109.224.244.117; helo=mail-244117.protonmail.ch; envelope-from=lenno@namespace.ee; receiver=lists.ozlabs.org)
Received: from mail-244117.protonmail.ch (mail-244117.protonmail.ch [109.224.244.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hW9Sv0dNXz2yYY
	for <linux-erofs@lists.ozlabs.org>; Fri, 28 Aug 2026 04:45:51 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=namespace.ee;
	s=protonmail2; t=1787856347; x=1788115547;
	bh=xqm/taN/9THyjEH1pnINltXdCRTdloD99mca9CMn2cE=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=F2HEBENiTf5rt1xelf74OiYK6s4f6chgxpx1E8kLb6IqpSq3s8/7+ITiTwbocO7PN
	 raPoufrKY5/ZHkOBMqBtbe4utNg5FbAT9d3KZpH/hD3uxADh8t517QI4FrBwhWCvnm
	 G17qfBUU8klzaETHzn2EJVUiaxIYGItMjifuSfdltxeT3QU4fKC6fthPSK+VNICoFo
	 BuVIgvt3RRVyfxV/2melUfVBpSG1gTIhQlRkCzEpwuTZg8FTWbHwT+U8Y3QXpa4FDb
	 37ng+tICmTOqM8tIIk6aPHUenldOaytkpdVWeVNZMMu7LsR6TaDGJ3pNJmXCXmiwe3
	 lujcxM6NmOpzA==
Date: Thu, 27 Aug 2026 18:45:43 +0000
To: "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>
From: Lenno Nagel <lenno@namespace.ee>
Cc: Gao Xiang <xiang@kernel.org>
Subject: [PATCH v2] erofs-utils: lib: bound SEEK_DATA results by the inode size
Message-ID: <wUs-xy1vc_z3L8fhjhyQ6Z9SCzHeNABi21rBf7z09irX-sRZq41jJMNjXQG28kw9HykVd3BC3pGyAZRQZdKlaBBPS6M5bjpPg6zSQymKOAk=@namespace.ee>
Feedback-ID: 67709125:user:proton
X-Pm-Message-ID: d987b45a03cfe8bebfe9186ad515684591cd849d
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

Treat an out-of-bounds offset the same way as ENXIO, so that the bytes
past the inode become hole chunks.

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
Suggested-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Lenno Nagel <lenno@namespace.ee>
---
Changes since v1:
 - Rework as suggested by Gao Xiang: instead of clamping the offset to
   round_up(i_size, chunksize) inside the in-bounds arm, narrow the
   in-bounds condition itself so an out-of-bounds SEEK_DATA result
   falls through to the existing ENXIO arm.  No third code path, and
   the tail chunk now becomes a hole when SEEK_DATA lands exactly on
   the inode end, where v1 still wrote it as a zero-filled chunk.

Verified with an ASAN build on the reproducer above and on the original
324 MB OCI layer, where the unpatched build traps at blobchunk.c:398.
The resulting images are byte-identical to the ones v1 produced,
fsck.erofs-clean, and extract back to the original contents.

v1:
https://lore.kernel.org/linux-erofs/g6thRspQKWfiuTooyOe2QlTfKjPaELZs2Im4oTf=
BTwqb6w9NV1q4Rkc3O3bzQvbkn9lq94pAszmT2jHwKPPi0yWK3NoxpgWPefvUQSp2AOc=3D@nam=
espace.ee/

 lib/blobchunk.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/lib/blobchunk.c b/lib/blobchunk.c
index 0523873..6cf021b 100644
--- a/lib/blobchunk.c
+++ b/lib/blobchunk.c
@@ -369,12 +369,7 @@ int erofs_blob_write_chunked_file(struct erofs_inode *=
inode, int fd,
 =09for (pos =3D 0; pos < inode->i_size; pos +=3D len) {
 =09=09off_t offset =3D lseek(fd, pos + startoff, SEEK_DATA);
=20
-=09=09if (offset < 0) {
-=09=09=09if (errno !=3D ENXIO)
-=09=09=09=09offset =3D pos;
-=09=09=09else
-=09=09=09=09offset =3D ((pos >> chunkbits) + 1) << chunkbits;
-=09=09} else {
+=09=09if (offset >=3D 0 && offset < startoff + inode->i_size) {
 =09=09=09offset -=3D startoff;
=20
 =09=09=09if (offset !=3D (offset & ~(chunksize - 1))) {
@@ -385,6 +380,12 @@ int erofs_blob_write_chunked_file(struct erofs_inode *=
inode, int fd,
 =09=09=09=09=09goto err;
 =09=09=09=09}
 =09=09=09}
+=09=09} else if (offset < 0 && errno !=3D ENXIO) {
+=09=09=09/* SEEK_DATA doesn't work as expected (unimplemented) */
+=09=09=09offset =3D pos;
+=09=09} else {
+=09=09=09/* lseek returns ENXIO or OOB (considering diskbuf) */
+=09=09=09offset =3D ((pos >> chunkbits) + 1) << chunkbits;
 =09=09}
=20
 =09=09if (offset > pos) {

base-commit: f36cadb5c563995ab3aa8572a60ed6b721b9557d
--=20
2.53.0

