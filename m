Return-Path: <linux-erofs+bounces-4219-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73A75C5CFCF
	for <linux-erofs@archiver.kernel.org>; Thu, 13 Aug 2026 12:08:54 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hLPKJ3pfwz2y32;
	Thu, 13 Aug 2026 22:08:52 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786622932;
	cv=none; b=L55YWET6HBkzEDmDNMqLDZP4D4WIwNYFGzta6CTFU/atOH95uOHIrNAYzFgtW9nnLZzQDb8yN5yH8/7421KaViu/qH90W/hI51Pz4t5Ac+9Y+NUrH9hxfooW6ih+658KlVuEiBJWDU2Huwbn2g6rZ4QJmCpMWDwq8pqZhxgnh/pKAk73ekr/wYd4UxURhRl6ma3X7GjYg8r5PtyTqcYtkYkYHSbAbgCb6v3l7Br7gF5crQ5wB83JNfdCDL8Iifi2jVTUUuTFtTvhupW+8P6CaBVYkFZHMMyY2GTZZfQg5tbDw/UBS6MIRm4Y8MTUv4N0OYZ0HqfqzFtve2OQlRh3SA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786622932; c=relaxed/relaxed;
	bh=+kVXEwQS1lEs5zqzijQqGBYvRfh8PASUlFrUm0/ypgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e4lgEYErMmVUY3YVyGtvFkTBEYQL2wBIpo6VFJd0/1GwZfHfDtegppxiyfIsjS4ziGXb3CSiZzM6VmCq+4isOQUtiGLD0+VVBrtb96utqz+bdnAzJpFsZwVepvPqGPgAEvlE7f8R2YBYNZCA+tu+TZrBIZUM6M9uRpLYGTMxaaE2mHjU70k8+Y+2ac7tSrVwVSDwgayR1YC9cYa1/yzzFLo9T+XsH/pF3r7m2p0rh+nNOGIakuiDyPhziBP3bkpo/etLh8rIXBjWsbq+urFrrZpu8pjGUMGm8Yzn4pSW3+p4L8cdTa+vqrjuoP58TZJBd/Y2U1v0RSm45YE+R/BOJA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jW44CAN6; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jW44CAN6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hLPKH1mfLz2xWV
	for <linux-erofs@lists.ozlabs.org>; Thu, 13 Aug 2026 22:08:51 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E586600AD;
	Thu, 13 Aug 2026 12:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEE91F00A3A;
	Thu, 13 Aug 2026 12:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786622928;
	bh=+kVXEwQS1lEs5zqzijQqGBYvRfh8PASUlFrUm0/ypgM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jW44CAN6zq6mcWAYApOBQmr5cslq4HV/JbQo7JrcStfdpVds3ah++A7lJWeH3RxM6
	 QHfG2k852DsyYLj8XgvgKTbF+/uuIMbY+LmZqTQ9j50Q8qfIr6mtUIIZycyjAw2oKL
	 1aWNSpuOxsHFcNdZ2WccZjWq4ZpZNFYWGYkX9+SxR3cBfsgZa4+6WdSr6jVjZ6puy8
	 IadxciEnOoomh8V1WyJm3+ojRBuMQ7rZMUbrNM3AHMOLniER85t3rm5BguA/OFe+UF
	 kfCAgXoQgpvm5MIPLKBhg20dMsOk3T2v5pROyUvKxS0ZePUXwRyq0+WiiB5TutJXpV
	 2vbJKLD17mcfA==
Date: Thu, 13 Aug 2026 20:08:43 +0800
From: Gao Xiang <xiang@kernel.org>
To: seula2.lee@lge.com
Cc: linux-erofs@lists.ozlabs.org, Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: Re: [PATCH] erofs-utils: lib: fix erofs_is_packed_inode() on the
 read path
Message-ID: <an2zy_VyU3rP47vx@XiangdeMacBook-Pro.local>
Mail-Followup-To: seula2.lee@lge.com, linux-erofs@lists.ozlabs.org,
	Gao Xiang <hsiangkao@linux.alibaba.com>
References: <20260813093849.3607625-1-seula2.lee@lge.com>
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
In-Reply-To: <20260813093849.3607625-1-seula2.lee@lge.com>

Hi Seula,

On Thu, Aug 13, 2026 at 06:38:49PM +0900, seula2.lee@lge.com wrote:
> From: Seula Lee <seula2.lee@lge.com>
> 
> erofs_is_packed_inode() compares i_srcpath against the global
> EROFS_PACKED_INODE identifier.  i_srcpath is only assigned by
> mkfs.erofs and has no on-disk counterpart, so it is never set for
> inodes filled in by erofs_read_inode_from_disk(), and the helper always
> returns false on the read path.
> 
> fsck.erofs therefore treats the packed inode as an ordinary regular
> file at all four of its call sites, for any image with fragments and a
> non-zero packed_nid:
> 
> - erofsfsck_extract_inode(): the guard never fires, so
> erofs_extract_file() writes the packed data to fsckcfg.extract_path
> itself, which is still the top-level directory because main()
> checks the packed inode before the root inode. Extracting the root
> then fails in erofs_extract_dir():
> 
> $ mkfs.erofs -zlz4hc -Efragments img.erofs dir
> $ fsck.erofs --extract=out img.erofs
> <E> erofs: erofs_extract_dir() Line[697] path is not a directory: out
> <E> erofs: main() Line[1256] Failed to extract filesystem
> $ file out
> out: ASCII text # 603720 bytes, the packed inode itself
> 
> - erofsfsck_set_attributes(): the packed inode's mode, timestamps and
> xattrs are applied to the extraction root directory.
> 
> - erofs_verify_inode_data(): the packed inode's own compressed data is
> decoded and hashed as if it were file data.
> 
> - the -p accounting: fragment bytes are counted both as file data and
> as packed inode data, so the reported ratio is too low.
> 
> Restore the nid-based test, which is how the packed inode is already
> identified elsewhere on the read path: z_erofs_read_one_data() compares
> inode->nid against sbi->packed_nid directly, and the
> erofs_sb_has_fragments(sbi) && sbi->packed_nid > 0 idiom used here is
> the same one in fuse/main.c, dump/main.c and fsck.erofs' own
> erofs_packedfile_init() call.
> 
> The i_srcpath comparison has to stay first rather than be replaced:
> while mkfs.erofs builds the packed inode its nid is still
> EROFS_NID_UNALLOCATED and sbi->packed_nid is 0, so a nid-only test
> would return false there and break fragment dedupe and
> pclusterblks_packed handling in lib/compress.c.
> 
> This restores the v1.8.x behaviour at every call site, where the helper
> was nid-based; in particular the packed inode is again excluded from the
> decompression check that --extract performs, as it was before v1.9.
> 
> dump.erofs is affected the same way and prints "Path : (packed file)"
> again as intended.
> 
> erofs_is_metabox_inode() shares the same idiom, but it has no read-path
> caller (all callers are in lib/compress.c and lib/inode.c), so it is
> left alone.
> 
> Fixes: 7928074b7643 ("erofs-utils: introduce metadata compression [metabox]")
> Signed-off-by: Seula Lee <seula2.lee@lge.com>

Thanks for the patch, that is indeed a bug and the fix looks fine,
but the commit message is too long to understand the impacts (it seems
in a LLM-generated-style.)

I will rephrase a short commit message instead.

Thanks,
Gao Xiang

