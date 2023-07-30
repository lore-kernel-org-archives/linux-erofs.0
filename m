Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EFA6C001DC
	for <linux-erofs@archiver.kernel.org>; Sun, 30 Jul 2023 14:28:32 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (1024-bit key; unprotected) header.d=t-8ch.de header.i=@t-8ch.de header.a=rsa-sha256 header.s=mail header.b=KmRvWkSA;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4RDNyk64Z0z2yG9
	for <linux-erofs@archiver.kernel.org>; Mon, 31 Jul 2023 00:28:30 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=t-8ch.de header.i=@t-8ch.de header.a=rsa-sha256 header.s=mail header.b=KmRvWkSA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=t-8ch.de (client-ip=159.69.126.157; helo=todd.t-8ch.de; envelope-from=thomas@t-8ch.de; receiver=lists.ozlabs.org)
X-Greylist: delayed 3405 seconds by postgrey-1.37 at boromir; Mon, 31 Jul 2023 00:28:25 AEST
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4RDNyd2Gv4z2xpd
	for <linux-erofs@lists.ozlabs.org>; Mon, 31 Jul 2023 00:28:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=t-8ch.de; s=mail;
	t=1690727302; bh=Q02GOFmqhBP5l5HrvhTUt4jqdKin17tPNOiFpSZNQOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KmRvWkSANTrCjEGvR7AR4mGzUOpDjzJr/DheRiUIJKWPVQ2Ok1FtGUDaHcKIquHJB
	 8clxGMmz2WsneMe67FRuwyMhS/j+ccN4hWSbje1WPi9B3XdF5y9BlX3kCTIjTQ2n6c
	 IUlxocxakPSKGDPisNo/azQexoK22OgNeVYbY034=
Date: Sun, 30 Jul 2023 16:28:21 +0200
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas@t-8ch.de>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: Re: [PATCH v2] erofs: deprecate superblock checksum feature
Message-ID: <9299dd4c-c2da-4ed1-8979-87fa44c68f77@t-8ch.de>
References: <20230717112703.60130-1-jefflexu@linux.alibaba.com>
 <f796b2ed-8564-45c3-bb04-44dfabb575c7@t-8ch.de>
 <bdd94a7c-7364-c262-ed01-d7e6fcb26007@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bdd94a7c-7364-c262-ed01-d7e6fcb26007@linux.alibaba.com>
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
Cc: huyue2@coolpad.com, linux-kernel@vger.kernel.org, Karel Zak <kzak@redhat.com>, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Gao!

On 2023-07-30 22:01:11+0800, Gao Xiang wrote:
> On 2023/7/30 21:31, Thomas Weißschuh wrote:
> > On 2023-07-17 19:27:03+0800, Jingbo Xu wrote:
> > > Later we're going to try the self-contained image verification.
> > > The current superblock checksum feature has quite limited
> > > functionality, instead, merkle trees can provide better protection
> > > for image integrity.
> > 
> > The crc32c checksum is also used by libblkid to gain more confidence
> > in its filesystem detection.
> > I guess a merkle tree would be much harder to implement.
> > 
> > This is for example used by the mount(8) cli program to allow mounting
> > of devices without explicitly needing to specify a filesystem.
> > 
> > Note: libblkid tests for EROFS_FEATURE_SB_CSUM so at least it won't
> > break when the checksum is removed.

> I'm not sure if we could switch EROFS_FEATURE_SB_CSUM to a simpler
> checksum instead (e.g. just sum each byte up if both
> EROFS_FEATURE_SB_CSUM and COMPAT_XATTR_FILTER bits are set, or
> ignore checksums completely at least in the kernel) if the better
> filesystem detection by using sb chksum is needed (not sure if other
> filesystems have sb chksum or just do magic comparsion)?

Overloading EROFS_FEATURE_SB_CSUM in combination with
COMPAT_XATTR_FILTER would break all existing deployments of libblkid, so
it's not an option.

All other serious and halfway modern filesystems do have superblock
checksums which are also checked by libblkid.

> The main problem here is after xattr name filter feature is added
> (xxhash is generally faster than crc32c), there could be two
> hard-depended hashing algorithms, this increases more dependency
> especially for embededed devices.

From libblkid side nothing really speaks against a simpler checksum.
XOR is easy to implement and xxhash is already part of libblkid for
other filesystems.

The drawbacks are:
* It would need a completely new feature bit in erofs.
* Old versions of libblkid could not validate checksums on newer
  filesystems.
