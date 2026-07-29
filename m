Return-Path: <linux-erofs+bounces-4031-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E13AAC53200
	for <linux-erofs@archiver.kernel.org>; Wed, 29 Jul 2026 09:57:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h97772h7nz2yjg;
	Wed, 29 Jul 2026 19:57:55 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785319075;
	cv=none; b=QHBb4zEO3FXxGsDYsmA/3s+QS7ympVq3NvV+lfIMzzF5wCFCrmkY8nox75jkIr4LAwaj8VsyN0tjF2zUWkDD/+617Stimp+7sVBq3LD5eJ77PJd/o1dV1lVv8Kublv4boqIaxv6+2304k4k6Ha86bYUfu45Gret/VPqo0Q0aoBvZrePHzX99bpYSoDmgzQasY4A1exUkEpldVajA0LT0nupoviVwJz8CAAnLqUL7vPSWbBKZvr1rnPBKhB2RF9AlGihUiAhydl/LCZdw4UPlp8bnhfuBASXwMJ2veg/GsmuAwk1lH+Uc6oYe/EfKkd80hCp3LdIZdyuAFRsTl3WStQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785319075; c=relaxed/relaxed;
	bh=Gpqm3qXNMEEYU33pegSYP4qns9JRmr0RwOBLDBlH9AE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nPLhkSbab1em/VvNbVIdJPH8wBiOAC/zDzZoHqvL/aMhodjLzfXYQQeTQCMnQqqmPsbCZMvCjJz6a+v0jDfBj1FtCB0dwvyRgtsKsjgroe7VowV4AyOiPIjl2D1K1t2leuBKjuRQLyrg/x6oSNJASgba4WS3Y7p4Sr0CCYCAGT/mpF2JgkKKTI0HL3vUk1TuPVp7VrO9uNY2bJ54fhmp19AtqcwHnVOrKRIV3K+vlWJb1Th4H2FTaAFKNsLMIccv7yMK8fo0q1vpqMK2P2UJYBNmaMLY5aHv7IFHll4W2UvQL10w3IChfU5Qs4Wy9RvHnTB6uas465gIo7fSDLnesg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz; dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=BMOYxe4Z; dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HyQJ9wf4; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=2f/SBpsE; dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=zkuqGP7d; dkim-atps=neutral; spf=pass (client-ip=195.135.223.131; helo=smtp-out2.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org) smtp.mailfrom=suse.cz
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=BMOYxe4Z;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HyQJ9wf4;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=2f/SBpsE;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=zkuqGP7d;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=suse.cz (client-ip=195.135.223.131; helo=smtp-out2.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h977455W6z2ygW
	for <linux-erofs@lists.ozlabs.org>; Wed, 29 Jul 2026 19:57:52 +1000 (AEST)
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B55053E16;
	Wed, 29 Jul 2026 09:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785319064; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gpqm3qXNMEEYU33pegSYP4qns9JRmr0RwOBLDBlH9AE=;
	b=BMOYxe4ZOMx7A9Umer1Jei/NJwRNmHtd4MJF3Ytytf5aC/45cBwSNCKSuXD3wZjUEYDZJB
	YRJ7Xrr5xn+pdvspEJFo9fo5XJuzyH2LrlowyB+45uITlH80o9XXxHP4YLD+ec1oI4YtK+
	7wsqHz/RoEt1sv4oQuNOI+nxwfrhxvA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785319064;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gpqm3qXNMEEYU33pegSYP4qns9JRmr0RwOBLDBlH9AE=;
	b=HyQJ9wf4f7xPE7SpMy7fcOowQN3nmEHUzvWe33NyWzO3lhEWCPQUz1WlmgHiaYbfPX0SPn
	kynuuziz+szwdSCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785319060; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gpqm3qXNMEEYU33pegSYP4qns9JRmr0RwOBLDBlH9AE=;
	b=2f/SBpsExr+x1qlk84aEp9G1GTtCEf4FsHH205mXjMsizcqaWCPwFW/+Vqxu2J7KPyQK8d
	iMWgBbb9uS3YRQVWqFstxMhSEquxGdMmU+T2cMks4IjGcyO7ZCwkMbsUX3D6vDeKUsnb7L
	MHuLadXNxwvtH2QKgE+Gu+LO7ou3ILY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785319060;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gpqm3qXNMEEYU33pegSYP4qns9JRmr0RwOBLDBlH9AE=;
	b=zkuqGP7dit6pemP7Udz0pDxCy2xwsP3bQhg7KdmlNJBMcQzI0SMp8kZSkuU+hPzh+P1Sqe
	X2CoVWJSJiTTWyBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AD6E5779A1;
	Wed, 29 Jul 2026 09:57:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gJtMKpTOaWo4JwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 29 Jul 2026 09:57:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5996BA131F; Wed, 29 Jul 2026 11:57:25 +0200 (CEST)
Date: Wed, 29 Jul 2026 11:57:25 +0200
From: Jan Kara <jack@suse.cz>
To: Gao Xiang <xiang@kernel.org>
Cc: Giuseppe Scrivano <gscrivan@redhat.com>, linux-erofs@lists.ozlabs.org, 
	cyphar@cyphar.com, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5] erofs: accept source file descriptor via fsconfig
Message-ID: <7kgp355d25csimg5txuxhp33zmc5onxpyxdtkarmun62rblp7j@etbql27573dl>
References: <20260728160619.853924-1-gscrivan@redhat.com>
 <amlaIt8jjy_mSK-j@XiangdeMacBook-Pro.local>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amlaIt8jjy_mSK-j@XiangdeMacBook-Pro.local>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]

On Wed 29-07-26 09:40:50, Gao Xiang wrote:
> On Tue, Jul 28, 2026 at 06:05:32PM +0200, Giuseppe Scrivano wrote:
> > Allow userspace to pass an already-opened file descriptor as the mount
> > source instead of a path string.  This is useful for tools that already
> > hold an fd to the image, such as composefs reusing an existing erofs
> > backing file.
> > 
> > Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
> > ---
> > v4: https://lore.kernel.org/linux-fsdevel/20260717134147.1602735-1-gscrivan@redhat.com/
> > v3: https://lore.kernel.org/linux-fsdevel/20260714154917.489993-1-gscrivan@redhat.com/
> > v2: https://lore.kernel.org/linux-fsdevel/20260711071137.4130824-1-gscrivan@redhat.com/
> > v1: https://lore.kernel.org/linux-fsdevel/ak5GfvVfWLJU1EwK@debian/
> > 
> >  Documentation/filesystems/erofs.rst | 15 ++++++
> >  fs/erofs/super.c                    | 73 ++++++++++++++++++++++++-----
> >  2 files changed, 77 insertions(+), 11 deletions(-)
> > 
> > diff --git a/Documentation/filesystems/erofs.rst b/Documentation/filesystems/erofs.rst
> > index 4230884fb359..774e8b236d09 100644
> > --- a/Documentation/filesystems/erofs.rst
> > +++ b/Documentation/filesystems/erofs.rst
> > @@ -139,6 +139,21 @@ inode_share            Enable inode page sharing for this filesystem.  Inodes wi
> >                         page cache.
> >  ===================    =========================================================
> >  
> > +File-backed mounts
> > +==================
> > +
> > +When CONFIG_EROFS_FS_BACKED_BY_FILE is enabled, EROFS file-backed images
> > +can be mounted directly without a loopback block device.  The backing file
> > +can be given either as a path, or as an already-opened file descriptor.
> > +
> > +When a file descriptor is used, the kernel resolves its path and records it
> > +so that /proc/mounts and similar interfaces can still report the mount
> > +source.
> > +
> > +Only regular files are accepted as backing files; to mount an image that
> > +resides on a block device, use the traditional block device mount path
> > +instead.
> 
> Reviewed-by: Gao Xiang <xiang@kernel.org>
> 
> Hi Christian, Jan, could you ack this (`fc->source` filling when
> `source_fd` is used) if possible?

Whenever I see a use of d_path() (or file_path() in this case) I'm a bit
watchful because its result is inherently racy and unsafe. But in this case
the result is only used for alloc_vfsmnt() which uses it for mnt_devname so
in the worst case we'll get an unreliable path in /proc/mounts or similar.
I guess that's acceptable. So feel free to add:

Acked-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

