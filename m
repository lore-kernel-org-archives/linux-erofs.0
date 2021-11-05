Return-Path: <SRS0=PZRY=PY=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E7DC433EF
	for <linux-erofs@archiver.kernel.org>; Fri,  5 Nov 2021 03:13:09 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 248DF61246
	for <linux-erofs@archiver.kernel.org>; Fri,  5 Nov 2021 03:13:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 248DF61246
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Hllv73ZxTz2yS3
	for <linux-erofs@archiver.kernel.org>; Fri,  5 Nov 2021 14:13:07 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
 spf=pass (sender SPF authorized) smtp.mailfrom=mit.edu
 (client-ip=18.9.28.11; helo=outgoing.mit.edu; envelope-from=tytso@mit.edu;
 receiver=<UNKNOWN>)
X-Greylist: delayed 198 seconds by postgrey-1.36 at boromir;
 Fri, 05 Nov 2021 14:13:00 AEDT
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Hllv06SfNz2x9H
 for <linux-erofs@lists.ozlabs.org>; Fri,  5 Nov 2021 14:12:59 +1100 (AEDT)
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net
 [72.74.133.215]) (authenticated bits=0)
 (User authenticated as tytso@ATHENA.MIT.EDU)
 by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 1A539JCp001043
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Thu, 4 Nov 2021 23:09:19 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
 id 215AA15C00B9; Thu,  4 Nov 2021 23:09:19 -0400 (EDT)
Date: Thu, 4 Nov 2021 23:09:19 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: futher decouple DAX from block devices
Message-ID: <YYSgX9FI0kaGLeR0@mit.edu>
References: <20211018044054.1779424-1-hch@lst.de>
 <21ff4333-e567-2819-3ae0-6a2e83ec7ce6@sandeen.net>
 <20211104081740.GA23111@lst.de> <20211104173417.GJ2237511@magnolia>
 <20211104173559.GB31740@lst.de>
 <CAPcyv4jbjc+XtX5RX5OL3vPadsYZwoK1NG1qC5AcpySBu5tL4g@mail.gmail.com>
 <20211104190443.GK24333@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104190443.GK24333@magnolia>
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
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
 linux-s390 <linux-s390@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
 Eric Sandeen <sandeen@sandeen.net>, virtualization@lists.linux-foundation.org,
 linux-xfs <linux-xfs@vger.kernel.org>,
 device-mapper development <dm-devel@redhat.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 Dan Williams <dan.j.williams@intel.com>,
 linux-ext4 <linux-ext4@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>,
 Christoph Hellwig <hch@lst.de>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Thu, Nov 04, 2021 at 12:04:43PM -0700, Darrick J. Wong wrote:
> > Note that I've avoided implementing read/write fops for dax devices
> > partly out of concern for not wanting to figure out shared-mmap vs
> > write coherence issues, but also because of a bet with Dave Hansen
> > that device-dax not grow features like what happened to hugetlbfs. So
> > it would seem mkfs would need to switch to mmap I/O, or bite the
> > bullet and implement read/write fops in the driver.
> 
> That ... would require a fair amount of userspace changes, though at
> least e2fsprogs has pluggable io drivers, which would make mmapping a
> character device not too awful.
> 
> xfsprogs would be another story -- porting the buffer cache mignt not be
> too bad, but mkfs and repair seem to issue pread/pwrite calls directly.
> Note that xfsprogs explicitly screens out chardevs.

It's not just e2fsprogs and xfsprogs.  There's also udev, blkid,
potententially systemd unit generators to kick off fsck runs, etc.
There are probably any number of user scripts which assume that file
systems are mounted on block devices --- for example, by looking at
the output of lsblk, etc.

Also note that block devices have O_EXCL support to provide locking
against attempts to run mkfs on a mounted file system.  If you move
dax file systems to be mounted on a character mode device, that would
have to be replicated as well, etc.  So I suspect that a large number
of subtle things would break, and I'd strongly recommend against going
down that path.

						- Ted
