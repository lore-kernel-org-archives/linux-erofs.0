Return-Path: <linux-erofs+bounces-4218-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86F77C5CFDB
	for <linux-erofs@archiver.kernel.org>; Thu, 13 Aug 2026 11:51:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hLNxL1ys7z2ySS;
	Thu, 13 Aug 2026 21:51:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786621894;
	cv=none; b=h4HQAcSruK53mKgexn8IqQThjhplPsnqSiaRki+eS9zKLU4LSdi03hTnroQ6fjwBm9QxagVRII5PjWDsopx3DH7whBB70JVcHoqTGki5pSN1UxPzYs4AzoINhG6ENRlAbv2g6U7qqaOuXq5AY5ewzOWsQXx6Zw+xTnzx7xSYxAVgDPVcleKI3JC+BVnWI/0Sy88JTG6ZlU5V0ffWSvFUBrSNSSiq33KR9DHskzy7A2LzOcJyTP4NwmvJqiEnG9VST1twbuCb3ki0EIDWwj99MWPSCPcM7A/UKHBK0M4RpKP8As65aHhS2X2MAi5q4hyw2cJARIgZC5/ut0MuvxMHqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786621894; c=relaxed/relaxed;
	bh=JvESJkga9jdlK0rgNoYtj3HeOE+zzwc0hSXdxTbTp0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W7fvjgG7Id5UkZSDYB9rw23hmUUVRnoUHoEwMhQ6ca2jJe23s36rCMI1dFNf0Lz+KceHTcRH2MWYjCt7cGcHyyhxIi5f4ugD9ZeZds7FP5Xn613VPdPMK5SuOWYHn6MMqQuAJbqDAbT38mkBywHZaj958Rave5cwvqULR7fXXEBkrLkwJ4OIk0Kk7boHxQwQTbhBs/km7MCdju3MwdALHbWZkZ3XNjHJwF4c8BnHHsKDiNReqONyto+KU0fn09NgKN6E6+TZh7g2PYu2twl6UjAjeXm0mp19odYKbyxvaJPms+vz37qTIS72QqNeGMuSLM+tc7/OIc22iF9CErNYcg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AMVToVk4; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AMVToVk4;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hLNxJ1MsSz2y32
	for <linux-erofs@lists.ozlabs.org>; Thu, 13 Aug 2026 21:51:32 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B63940135;
	Thu, 13 Aug 2026 11:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DB81F000E9;
	Thu, 13 Aug 2026 11:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786621889;
	bh=JvESJkga9jdlK0rgNoYtj3HeOE+zzwc0hSXdxTbTp0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AMVToVk4MFkR7P4cmxVK1KGPrT2kUbr3NX9zQalw94nz2PqbcTBReXKNgk2gPLsls
	 yVRUWAgPSrtw9Ny4VIrXWNYwwikUi1PSeuxw6ClzbfPM9EjafJDrXsvyCuYz2kkjFI
	 fryOK4XINON/elk09G74hV1TT4vCHNJ0sQ7haD4fGAYOj/G1KvzNe+guhG1UdrZiNI
	 Pz5arx2wk6jwUCNynDjul98OPA3aUofKMzaTUHV0q8+YbZ25o9xQ/T6KEJbkFVRewz
	 lECyQv/dVyADzouIgs/HyQ1rceLrMkwvof/n4lksAEx4ceeaL3crbYfHN/xp/n2+XB
	 N0QtPpredee0Q==
Date: Thu, 13 Aug 2026 19:51:21 +0800
From: Gao Xiang <xiang@kernel.org>
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org,
	linux-fsdevel@vger.kernel.org, amir73il@gmail.com,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz
Subject: Re: [PATCH v6 2/2] erofs: reuse superblock for file-backed mounts
Message-ID: <an2vuT1Va8JjdLug@XiangdeMacBook-Pro.local>
Mail-Followup-To: Giuseppe Scrivano <gscrivan@redhat.com>,
	linux-erofs@lists.ozlabs.org, xiang@kernel.org,
	linux-fsdevel@vger.kernel.org, amir73il@gmail.com,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz
References: <20260812142907.1010046-1-gscrivan@redhat.com>
 <20260812142907.1010046-3-gscrivan@redhat.com>
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
In-Reply-To: <20260812142907.1010046-3-gscrivan@redhat.com>

On Wed, Aug 12, 2026 at 04:28:04PM +0200, Giuseppe Scrivano wrote:
> When the same file-backed image is mounted multiple times (via path or
> fd) with the superblock_share mount option, reuse the existing
> superblock instead of creating a new one.  This allows multiple mounts
> of the same image to share in-kernel data structures more efficiently.
> 
> The backing file is identified by its inode and fsoffset.  If mount
> options conflict or extra devices are used, a separate superblock
> is created transparently as a fallback.  Remount is not allowed on
> shared superblocks.
> 
> Tested by mounting a 177M Fedora EROFS image 20 times with full
> traversal:
> 
>   #!/bin/sh
>   IMG=${1:-/root/fedora.erofs}
>   OPTS=${2:+-o $2}
>   N=20
>   DIR=$(mktemp -d)
>   trap "umount $DIR/m* 2>/dev/null; rm -rf $DIR" EXIT
> 
>   sync; echo 3 > /proc/sys/vm/drop_caches
>   INODES_BEFORE=$(grep erofs_inode /proc/slabinfo | awk '{print $2}')
>   MEM_BEFORE=$(grep ^Slab: /proc/meminfo | awk '{print $2}')
> 
>   for i in $(seq 1 $N); do
>       mkdir $DIR/m$i
>       mount -t erofs $OPTS "$IMG" $DIR/m$i
>       find $DIR/m$i > /dev/null
>   done
> 
>   echo "Superblocks: $(grep $DIR /proc/self/mountinfo | \
>       awk '{print $3}' | sort -u | wc -l)"
>   echo "erofs_inode delta: +$(( $(grep erofs_inode /proc/slabinfo | \
>       awk '{print $2}') - INODES_BEFORE ))"
>   echo "Slab delta: +$(( $(grep ^Slab: /proc/meminfo | \
>       awk '{print $2}') - MEM_BEFORE )) kB"
> 
> without superblock_share:
> 
>   # time ./test.sh /root/fedora.erofs
>   Superblocks: 20
>   erofs_inode delta: +45864
>   Slab delta: +37448 kB
>   real	0m2.311s
>   user	0m0.222s
>   sys	0m1.998s
> 
> with superblock_share:
> 
>   # time ./test.sh /root/fedora.erofs superblock_share
>   Superblocks: 1
>   erofs_inode delta: +2044
>   Slab delta: +284 kB
>   real	0m0.679s
>   user	0m0.157s
>   sys	0m0.469s
> 
> The time difference shows that sharing the superblock also benefits
> the page cache and inode cache, as subsequent mounts of the same image
> avoid re-reading the backing file.  This is particularly useful for
> container hosts running multiple containers from the same base image.
> 
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

