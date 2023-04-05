Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00320C7619A
	for <linux-erofs@archiver.kernel.org>; Wed,  5 Apr 2023 22:27:04 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4PsK4R3XGcz3f9s
	for <linux-erofs@archiver.kernel.org>; Thu,  6 Apr 2023 08:27:03 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1680733623;
	bh=XK91TzLV+BuNFfVuafZ92bpnVCXIC7GzKLzoDgloMhQ=;
	h=Date:To:Subject:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=e+nBRnMWgiejgy/SHz1tpPRZ2qlYbLc92pRbtXcfkKD28kjLW4SL0JBkK/tam5LE7
	 KlblwCm1BYv8nogit6ymB7yhNVYQd4UM0VBj3IAVWH2/bvEKQFZQ/dJtinVQM/lkWT
	 EwtWVeX3jM1xYqhSf0ECwlo9vzLSqeT9jjXGhvYJHW4GwO2E+olBkYHnnvN7DO0Cil
	 3WourahBx9id/zaGAckJcBHzHZbzAbaBjbe77jk8iir8pZGyZ+F/EVp5ofiK6PRvEl
	 /tO2zx7AS4mRZf7+t5fLJYND98ppuDsnlRN3jQyHlH3fakwmXh9J06muzOd35YajIf
	 0g0JaTDsfOJeg==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=fromorbit.com (client-ip=2607:f8b0:4864:20::436; helo=mail-pf1-x436.google.com; envelope-from=david@fromorbit.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=fromorbit-com.20210112.gappssmtp.com header.i=@fromorbit-com.20210112.gappssmtp.com header.a=rsa-sha256 header.s=20210112 header.b=phPcb/SN;
	dkim-atps=neutral
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4PsK4H0nDHz3c41
	for <linux-erofs@lists.ozlabs.org>; Thu,  6 Apr 2023 08:26:53 +1000 (AEST)
Received: by mail-pf1-x436.google.com with SMTP id y2so24658415pfw.9
        for <linux-erofs@lists.ozlabs.org>; Wed, 05 Apr 2023 15:26:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680733610;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XK91TzLV+BuNFfVuafZ92bpnVCXIC7GzKLzoDgloMhQ=;
        b=yVaHIj6RU6gwCN9G3ezhQEHfW/mkXyIuEIo93NIm8GNPfx5fozhczPumjMKMk/Qt5j
         mUNkkDrjrOZE2xTvIKEB47Ij/SmRTrAmxmhfiJZhyC6RTjFD2bGUo0qUe2R+Xb0hnnbl
         y+oyd01WxUSDinW/mAoUOJoDAoSNGOuJ4AWNGd/QWfnAQndBjd8ZiuNhEST5Zw35GNBi
         oZkcl5H95Or4u2g4T62UPNJ0NnPPOOet/loEwbANEcKAYswS4ug8PsMgi6KqC8KNOqki
         csnI4tHy9HtviwpvZjkR2xvTdJdJr9uD1b6tWSSXefzZZMPTzjXAsKdPbTn44CgBI3kt
         C0Cg==
X-Gm-Message-State: AAQBX9eitJZobuR7WYxIfkaPan9szmD2aHNTGDlnMPjxnMUSjN5tVEkP
	0rxbV9uyYsVUlw9eMxLtQMlafg==
X-Google-Smtp-Source: AKy350ZizTU3q/Uc2TiZy7crqeJ4jvK0CtSZoX/AzNtdP+Y2QHldAbm030UMhCShfo2v0Sb07Y+LGg==
X-Received: by 2002:a62:1d8f:0:b0:627:e577:4326 with SMTP id d137-20020a621d8f000000b00627e5774326mr6595721pfd.17.1680733610237;
        Wed, 05 Apr 2023 15:26:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-91-157.pa.nsw.optusnet.com.au. [49.181.91.157])
        by smtp.gmail.com with ESMTPSA id 2-20020aa79142000000b0062c0cfbb264sm11493110pfi.93.2023.04.05.15.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 15:26:49 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1pkBaY-00HUjN-NL; Thu, 06 Apr 2023 08:26:46 +1000
Date: Thu, 6 Apr 2023 08:26:46 +1000
To: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2 21/23] xfs: handle merkle tree block size != fs
 blocksize != PAGE_SIZE
Message-ID: <20230405222646.GR3223426@dread.disaster.area>
References: <20230404145319.2057051-1-aalbersh@redhat.com>
 <20230404145319.2057051-22-aalbersh@redhat.com>
 <20230404163602.GC109974@frogsfrogsfrogs>
 <20230405160221.he76fb5b45dud6du@aalbersh.remote.csb>
 <20230405163847.GG303486@frogsfrogsfrogs>
 <ZC264FSkDQidOQ4N@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZC264FSkDQidOQ4N@gmail.com>
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
From: Dave Chinner via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Dave Chinner <david@fromorbit.com>
Cc: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, agruenba@redhat.com, "Darrick J. Wong" <djwong@kernel.org>, Andrey Albershteyn <aalbersh@redhat.com>, linux-f2fs-devel@lists.sourceforge.net, hch@infradead.org, cluster-devel@redhat.com, dchinner@redhat.com, rpeterso@redhat.com, jth@kernel.org, linux-erofs@lists.ozlabs.org, damien.lemoal@opensource.wdc.com, linux-btrfs@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Wed, Apr 05, 2023 at 06:16:00PM +0000, Eric Biggers wrote:
> On Wed, Apr 05, 2023 at 09:38:47AM -0700, Darrick J. Wong wrote:
> > > The merkle tree pages are dropped after verification. When page is
> > > dropped xfs_buf is marked as verified. If fs-verity wants to
> > > verify again it will get the same verified buffer. If buffer is
> > > evicted it won't have verified state.
> > > 
> > > So, with enough memory pressure buffers will be dropped and need to
> > > be reverified.
> > 
> > Please excuse me if this was discussed and rejected long ago, but
> > perhaps fsverity should try to hang on to the merkle tree pages that
> > this function returns for as long as possible until reclaim comes for
> > them?
> > 
> > With the merkle tree page lifetimes extended, you then don't need to
> > attach the xfs_buf to page->private, nor does xfs have to extend the
> > buffer cache to stash XBF_VERITY_CHECKED.
> 
> Well, all the other filesystems that support fsverity (ext4, f2fs, and btrfs)
> just cache the Merkle tree pages in the inode's page cache.  It's an approach
> that I know some people aren't a fan of, but it's efficient and it works.

Which puts pages beyond EOF in the page cache. Given that XFS also
allows persistent block allocation beyond EOF, having both data in the page
cache and blocks beyond EOF that contain unrelated information is a
Real Bad Idea.

Just because putting metadata in the file data address space works
for one filesystem, it doesn't me it's a good idea or that it works
for every filesystem.

> We could certainly think about moving to a design where fs/verity/ asks the
> filesystem to just *read* a Merkle tree block, without adding it to a cache, and
> then fs/verity/ implements the caching itself.  That would require some large
> changes to each filesystem, though, unless we were to double-cache the Merkle
> tree blocks which would be inefficient.

No, that's unnecessary.

All we need if for fsverity to require filesystems to pass it byte
addressable data buffers that are externally reference counted. The
filesystem can take a page reference before mapping the page and
passing the kaddr to fsverity, then unmap and drop the reference
when the merkle tree walk is done as per Andrey's new drop callout.

fsverity doesn't need to care what the buffer is made from, how it
is cached, what it's life cycle is, etc. The caching mechanism and
reference counting is entirely controlled by the filesystem callout
implementations, and fsverity only needs to deal with memory buffers
that are guaranteed to live for the entire walk of the merkle
tree....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
