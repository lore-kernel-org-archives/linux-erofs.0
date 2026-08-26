Return-Path: <linux-erofs+bounces-4346-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E154BC61DBD
	for <linux-erofs@archiver.kernel.org>; Wed, 26 Aug 2026 13:29:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hVQVF0WgNz2y32;
	Wed, 26 Aug 2026 23:29:25 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787750964;
	cv=none; b=WLKZkbICkkaNX8iJqKuRGgODcnG47We+LZD2e6BVMvmnM/nvhOytG9CdB7JaWgLsT/xykLB+0AJ++y3pCh/RjuJaFLRCJ49X9tmV3caVo4jmwOv73Tv1nxCuAyv6ZsQQXYGiuRI1FdiQkptWCVDmBu2LuocmDy8Jk4/YWgeCAOeuw84pYbnSiuUuvaC6UFFPTA0m6hUYLzwu6OjKXK7e2J40czHLL7E9x83MzQCg9twuPjTq8TKiuwFnTi+99fOMKd5kufyHGeh0Z3EItT7izCqhJG4DhQNpNq61p2fML+FH4fQXfFMFpMpZWJso6M0YZcyIbzK7OZlo5aRmai3kTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787750964; c=relaxed/relaxed;
	bh=VngXe8Cgl3MdYMfNfW/E8xAJGyJMTjfct8pCzycnI4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oPgewxoSnNFlVVh6uBSbQZCrNmYlKtJEqpGhMwfKCaLz6yuKGi/ebUX8AKy/ET3jmr4qZMiLTJYS5RjN2csNfArG8NrVglB3DNriu5ddtcVUgLLtPvAAN3BwZaF+gwwB1EctiycNHQyaa/7nZ9PyDihDJ96g/HML1z0aEtlqBz0xxwHoDJi9JELLTfIfW3REMIx7yqrfxbGoiHrY8xx4mbE6024dpabJl/0JCpvhL3sx5LlK/S+NBddN1HS2lwrbUpWi2pp1GTyrzH1Cr5L2GwYhakaZeuaFMDxi6fj4/6ju4/B2CUKsSYdGNsEoqT6/8HmYDLzmWGTWLGQVGFT1ig==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KfPE0xXd; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KfPE0xXd;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hVQVB67Sdz2xLG
	for <linux-erofs@lists.ozlabs.org>; Wed, 26 Aug 2026 23:29:22 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BB6843A53;
	Wed, 26 Aug 2026 13:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D500E1F000E9;
	Wed, 26 Aug 2026 13:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787750954;
	bh=VngXe8Cgl3MdYMfNfW/E8xAJGyJMTjfct8pCzycnI4k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KfPE0xXd63KmmfsFjQIFGmChb9PA1rWRdnJDrjL8gfAZbsFs11Y31aIaQIyCFDjq3
	 p7IdfdNw93F5MZL+KwJE+PJ1vi34uDmh20+APaHSuHsgAbT+8GvXncdAY0jG+BH1Nl
	 YWZh7YCghKH7ViijXBMbIwiuAzmjD7ohv5lDRg6dA1SRpqABfaoR4O6k+8FFO/mImi
	 eWAxohYuqt3a98r9h4xVwwbDUatNbGoMsJftPktOAbdxYku/3CDLoRCg7FcxMixcrB
	 UqEa2EXs8O3Ztss6q/6+y1WFujBwmdBqHIIv50KC+EL0ZELi4ZNqbOEE1IL1CYn6cB
	 Ven/tdy569prQ==
Date: Wed, 26 Aug 2026 21:29:09 +0800
From: Gao Xiang <xiang@kernel.org>
To: Lenno Nagel <lenno@namespace.ee>
Cc: "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>,
	Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH] erofs-utils: lib: bound SEEK_DATA results by the inode
 size
Message-ID: <ao7qJUU8YEq7ciiS@192.168.5.19>
Mail-Followup-To: Lenno Nagel <lenno@namespace.ee>,
	"linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>,
	Gao Xiang <xiang@kernel.org>
References: <g6thRspQKWfiuTooyOe2QlTfKjPaELZs2Im4oTfBTwqb6w9NV1q4Rkc3O3bzQvbkn9lq94pAszmT2jHwKPPi0yWK3NoxpgWPefvUQSp2AOc=@namespace.ee>
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
In-Reply-To: <g6thRspQKWfiuTooyOe2QlTfKjPaELZs2Im4oTfBTwqb6w9NV1q4Rkc3O3bzQvbkn9lq94pAszmT2jHwKPPi0yWK3NoxpgWPefvUQSp2AOc=@namespace.ee>

Hi Lenno,

On Fri, Aug 21, 2026 at 07:22:20AM +0000, Lenno Nagel wrote:
> erofs_blob_write_chunked_file() allocates inode->chunkindexes for
> DIV_ROUND_UP(inode->i_size, chunksize) entries, but the hole-skipping
> loop advances `pos' in chunksize steps until it reaches the offset
> reported by SEEK_DATA, without bounding that offset by the inode size.
> 
> Since the diskbuf was introduced, `fd' is not necessarily the source
> file any more: for tarballs it is a shared scratch region holding the
> payload of every member, each reservation rounded up to
> max(st_blksize, getpagesize()), so SEEK_DATA can legitimately report
> the next member's data instead of failing with ENXIO.  If the
> filesystem backing the diskbuf stores all-zero regions as holes (e.g.
> ZFS with compression enabled, which also reports st_blksize as its
> recordsize), an all-zero member is skipped in its entirety and the
> loop keeps appending hole entries until it reaches the next member: a
> 65535-byte all-zero member on a 1 MiB alignment writes 256 entries
> into a 16-entry array.
> 
> The heap corruption is silent where it happens and surfaces later as
> an abort inside an unrelated malloc(), e.g. "malloc(): invalid size
> (unsorted)" from erofs_balloc().
> 
> Bound the offset with round_up(inode->i_size, chunksize) so that the
> bytes past the inode become hole chunks, just as they do on the ENXIO
> path above.
> 
> Reproducer (out.erofs doubles as the diskbuf, so it must live on a
> filesystem which stores all-zero regions as holes, e.g. a ZFS dataset
> with compression=on):
> 
>   head -c 65535 /dev/zero    > a-zeros.bin
>   head -c 4096  /dev/urandom > b-data.bin
>   tar -cf minimal.tar a-zeros.bin b-data.bin
>   mkfs.erofs --tar=f -b4096 --chunksize=4096 out.erofs < minimal.tar
> 
> Found while converting an OCI layer to EROFS with containerd's erofs
> snapshotter, which invokes mkfs.erofs with --tar=f --chunksize=4096.
> 
> Fixes: 376fb2dbe66d ("erofs-utils: lib: introduce diskbuf")
> Signed-off-by: Lenno Nagel <lenno@namespace.ee>

Thanks for the patch and sorry for the delay!

Could you confirm if the following diff works and if it works,
could you send out a formal patch based on this?

diff --git a/lib/blobchunk.c b/lib/blobchunk.c
index 0523873..6cf021b 100644
--- a/lib/blobchunk.c
+++ b/lib/blobchunk.c
@@ -369,12 +369,7 @@ int erofs_blob_write_chunked_file(struct erofs_inode *inode, int fd,
 	for (pos = 0; pos < inode->i_size; pos += len) {
 		off_t offset = lseek(fd, pos + startoff, SEEK_DATA);
 
-		if (offset < 0) {
-			if (errno != ENXIO)
-				offset = pos;
-			else
-				offset = ((pos >> chunkbits) + 1) << chunkbits;
-		} else {
+		if (offset >= 0 && offset < startoff + inode->i_size) {
 			offset -= startoff;
 
 			if (offset != (offset & ~(chunksize - 1))) {
@@ -385,6 +380,12 @@ int erofs_blob_write_chunked_file(struct erofs_inode *inode, int fd,
 					goto err;
 				}
 			}
+		} else if (offset < 0 && errno != ENXIO) {
+			/* SEEK_DATA doesn't work as expected (unimplemented) */
+			offset = pos;
+		} else {
+			/* lseek returns ENXIO or OOB (considering diskbuf) */
+			offset = ((pos >> chunkbits) + 1) << chunkbits;
 		}
 
 		if (offset > pos) {


Thanks,
Gao Xiang

