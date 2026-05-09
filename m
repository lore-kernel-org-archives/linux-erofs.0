Return-Path: <linux-erofs+bounces-3389-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B9B7CD343F
	for <linux-erofs@archiver.kernel.org>; Sat,  9 May 2026 10:03:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gCM4r6lwRz2xqv;
	Sat, 09 May 2026 20:03:24 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1778321004;
	cv=none; b=j5m0bA8DBzoyrsW9oB4I98Z4/w5bKHEpM1PotzK/eB+RRQwTfkaDAfuM47htUN5FFslT8HcsDp/rS/FujZZiRM2KxkpX7Id7AQALcaevuGu1ert8ItdLBWkr/N5n87rwNRDNhcgIKwyMjPWmY7v/KPD+cXaT1wY61zVtnlB4muUkIrHaO7x6OYj7WtXUlZWiDqQJTkKh/tenMoqHZJjyyGTmh8FvDoSvFy+ufAZAiYWsXfcsASD4WipGxB6QY9R/l9GiLgsia8YEOyWrY/KpdTL0PHEkQ/P+L3N1KZopAod+65ze6CJ4QVDOGeLF+eDzzc3oTROVftzvdb7wNa9oBg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1778321004; c=relaxed/relaxed;
	bh=/i1oaAfXGx5tNgdr9HS6UH8t+Dlwxq2oAYBBfgl+nCI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YhdhZeVEhPejhm2bE+3zVwcl4mrqbuymsgsnNsooAz9rjen1pp8i3lAZuQnzSaSOE5/r7EIwoDUs5lShVv1C3gqXAQiMgeKr/fLFUpJ2Kiw1yGD1Md3S30SdJlKUWcuoE6Km8I0DEab/L+Z5GfH9GNlYgg/joTqAY92dueI9y+QKmouix03zJfSd+M5IhZttpM92AaQ96iJo+RaLZX80K1h41uh+IBLi8nZKEdmE1J7uqrwg8Djg61heU2Ysocgr4zYRmkpDVhFWS9Z+GLolOVhmnDnrz85R0BbSjJZhbb8PUrFellWHqIzSGhMR4wy5NTA4zBNL0DchxJcE9PNV6A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=JMvBmFFh; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=JMvBmFFh;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gCM4q6fX6z2xf8
	for <linux-erofs@lists.ozlabs.org>; Sat, 09 May 2026 20:03:23 +1000 (AEST)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E83BD6024D;
	Sat,  9 May 2026 10:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACB7C2BCB2;
	Sat,  9 May 2026 10:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778321000;
	bh=PcKIOonsa92S8kn3TnBvXbr3wHVIDuGBmZ8z3hwk/q0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JMvBmFFhr10XSWkIuoDUUJ0mj6xSgGWyWZwxm4de7qGE6YiGT7phR62nt1Z+brm+E
	 4i67EVt27s1bhB4lasg7Q/OvRlX2Rc3Hq4oORtn0YKmEcaZ2UrF0Sh6JIzhYUwSBfe
	 W7XwkAih242DYydOGr8s5QCxfaRHph+vR4pT5kI5L5i8Q0CXbyaZpf0ijyDVvmCoiF
	 dBEUFykrCBJ/v6Zi5lwLYtVdDzr6wSbwM+ihN2oR1BnK/wwnzifPWUYQ2CtYpclGVc
	 u4C7MUzeifFqYzJ25hmXi6zn0DTIAPoOn3YOzgq77aFuhYONW+0R3mGW9FFl2W68oU
	 nkfQDyqYySgRw==
Date: Sat, 9 May 2026 18:03:15 +0800
From: Gao Xiang <xiang@kernel.org>
To: Bingwu Zhang <xtex@envs.net>
Cc: linux-erofs@lists.ozlabs.org, Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: Re: Rebuild mode for tail-pack layouts
Message-ID: <af8GY7GTdIO4G829@debian>
Mail-Followup-To: Bingwu Zhang <xtex@envs.net>,
	linux-erofs@lists.ozlabs.org,
	Gao Xiang <hsiangkao@linux.alibaba.com>
References: <Jk-rGy7vS2y1kZoygWQp8w@envs.net>
 <38546371-df53-4fa2-adf1-26ab2dd71542@linux.alibaba.com>
 <CgjAP5WSSE2vLMZi0oabUw@envs.net>
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
Content-Transfer-Encoding: 8bit
In-Reply-To: <CgjAP5WSSE2vLMZi0oabUw@envs.net>

On Sat, May 09, 2026 at 04:37:43PM +0800, Bingwu Zhang wrote:
> Hi,
> 
> On Monday, May 4, 2026 11:13:23 PM China Standard Time Gao Xiang wrote:
> > Hi xtex,
> > 
> > On 2026/4/30 20:09, xtex wrote:
> > > Hi!
> > > 
> > > In erofs_rebuild_write_blob_index (rebuild.c), only
> > > EROFS_INODE_CHUNK_BASED
> > > and FLAT_PLAIN are implemented, so when generating a metadata index with
> > > rebuild mode, the sources cannot use tail-pack nor inline data layout.
> > > However, disabling tail-packing can lead to great disk-space waste in many
> > > cases, especially when the file-system consists of a lot of small files.
> > > 
> > > Thus I attempted to implement FLAT_INLINE for it, only to realize that the
> > > current chunk entry formats can only represent physical addresses that are
> > > block-aligned while tail-pack extent is not.
> > > 
> > > I wonder what do you think about adding a new chunk entry format? And how
> > > should it be named?
> > > 
> > > I would suggest the following structure:
> > > struct erofs_inode_chunk_index_tp {
> > > 
> > > 	__le16 startblk_hi;	/* starting block number MSB */
> > > 	__le16 device_id;	/* back-end storage id (with bits masked)
> > > 
> > > */
> > > 
> > > 	__le32 startblk_lo;	/* starting block number of this chunk */
> > > 	/* new fields below */
> > > 	__le16 startblk_off;	/* starting block offset */
> > > 	__le16 reserved;
> > > 
> > > } __packed;
> > > The 16b offset should be enough unless we are to support block size > 64K.
> > > The reserved field is added for alignment.
> > 
> > Sorry about the late response.
> > 
> > Thanks for the question.
> > 
> > FLAT_INLINE can be used for index rebuilding, which can work with
> > uniaddr (or mapped_blkaddr) since the blkaddr will be mapped
> > into the relative address based on the blob starting with
> > mapped_blkaddr:
> > 
> > https://erofs.docs.kernel.org/en/latest/ondisk/chunked_format.html#device-ta
> > ble
> > 
> > But I agree the expression in the page above is a bit
> > ambigious through.
> > 
> > Thanks,
> > Gao Xiang
> > 
> > > Best wishes.
> 
> Sorry for the late response and thanks for your answer.
> 
> I am sorry about that I didn't get it.
> In __erofs_map_blocks:
> > map->m_pa = erofs_pos(sbi, startblk);
> and
> > #define erofs_pos(sbi, nr)      ((erofs_off_t)(nr) << (sbi)->blkszbits)
> It seems like that the mapped PA is always block-aligned? However, the last 
> chunk of inline data is not?

Yes, sorry I didn't express explicitly.

I mean the main data except the trailing inline data part
can be remapped into another external blob.

But inline data should be kept with the metadata; otherwise it
won't be called _inline data_ anymore.

Or do you have a case we have to redirect the inline data?

Thanks,
Gao Xiang

> 
> Best wishes.
> 
> -- 
> xtex (a.k.a. Bingwu Zhang) @ Sat, 09 May 2026 08:24:53 +0000
> 
> 
> 
> 

