Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E61606A76D
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 13:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=nU4XxgAL;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Mnc4QrSZ;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=nU4XxgAL;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Mnc4QrSZ
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP6K66vHKz3brm;
	Wed, 11 Nov 2026 00:03:22 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794315802;
	cv=none; b=cQWXRVrS7s4mVpQu//tUkJjC6SsGqDaZWwLsQwD0aQpKL786EpV9LMlDN5DyBB25Wb3UmTTamqUIgxfM2Mjf5Bku/xM1haAs5jUqtkDx9zxjy6/G197hokrCuIUP5CvXqXoblwDjRvTXHzDdiAUInQ83Ejzkz25+OVEm7Z+XmoyeS93L9eenBvNnAaOUR4oxBwj8bZM02JHJM82bkVRxKLm9j4adbSx0SKzEw2hEOm0UAy3XhhKMA/t8Pdr4viMIhDU3//YdANjdG66SMwgykQphXehLNtakkbClnFbMnl/8HhtA6DnfELkV+K/IkI2mZpmNu1IJ2KIVwGiprT2g6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794315802; c=relaxed/relaxed;
	bh=l0P34w8QQvLO5YW5vCLMJ84QpfDMX9/Bu1FrRmyy2v8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NaflmvrBBXVeS2dZE3Q/hafIxMnxMASalM5mquKn9TRK1vMa72rSA90Fda88u48p4mqU6fxuzyPS++ARJEmODbMXXWH/Oz4kH+BOeGqHlM9dkAkwnukiCQwK9yiqKREzKtvvgmHy5BtrqnzAlJQGb3l7WVC+/nTAah/jfbYUEOelwp665mHgSKR0Jy3Dn5t3dWv2mfXbYrfXwhRIKEe+CJr5dipk3zWDJR/6pij15KB+Dm9vUmQYWehDPkdRYzy9zsmJ+Ig02LAKKM/25jdB1Vb0itNps8kmf8CA5nXjS7tpvBm9hv/tGpb1sXjs2yQzB7+B75k1sA9za9o/7mDegw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz; dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=nU4XxgAL; dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Mnc4QrSZ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=nU4XxgAL; dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Mnc4QrSZ; dkim-atps=neutral; spf=pass (client-ip=195.135.223.130; helo=smtp-out1.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org) smtp.mailfrom=suse.cz
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=nU4XxgAL;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Mnc4QrSZ;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=nU4XxgAL;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Mnc4QrSZ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=suse.cz (client-ip=195.135.223.130; helo=smtp-out1.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP6K62GNRz3bpd;
	Wed, 11 Nov 2026 00:03:22 +1100 (AEDT)
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C0D9421F77;
	Tue, 10 Nov 2026 13:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315799; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l0P34w8QQvLO5YW5vCLMJ84QpfDMX9/Bu1FrRmyy2v8=;
	b=nU4XxgALhU6j4K3Mxr5ngQH1kaedGJkQyEqwlGUplEx9hMxQ3fo4McMmOwr1ERv3Mkpxw3
	gLCfI+EWYKzq/l9mRzhXb6GJ0h3nlI+5tsg9MpjQ2PJDBC1XC/U5s6EqGl5dlEXIEKPAnz
	BBcKQlac9Q1+gcOvfNs3dKHhhfnARxs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315799;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l0P34w8QQvLO5YW5vCLMJ84QpfDMX9/Bu1FrRmyy2v8=;
	b=Mnc4QrSZrRmpafaJe4iOnLi1RuOTcqJe/GGSNdftVub9UNeD+cHjavH2Su/fUJ6PuunSLs
	aVyAWefkY3MWbuCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315799; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l0P34w8QQvLO5YW5vCLMJ84QpfDMX9/Bu1FrRmyy2v8=;
	b=nU4XxgALhU6j4K3Mxr5ngQH1kaedGJkQyEqwlGUplEx9hMxQ3fo4McMmOwr1ERv3Mkpxw3
	gLCfI+EWYKzq/l9mRzhXb6GJ0h3nlI+5tsg9MpjQ2PJDBC1XC/U5s6EqGl5dlEXIEKPAnz
	BBcKQlac9Q1+gcOvfNs3dKHhhfnARxs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315799;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l0P34w8QQvLO5YW5vCLMJ84QpfDMX9/Bu1FrRmyy2v8=;
	b=Mnc4QrSZrRmpafaJe4iOnLi1RuOTcqJe/GGSNdftVub9UNeD+cHjavH2Su/fUJ6PuunSLs
	aVyAWefkY3MWbuCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 960C61339F;
	Tue, 10 Nov 2026 13:03:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id e3rfGxcW82q6SgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 13:03:19 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 35CB1224F7; Tue, 10 Nov 2026 14:03:15 +0100 (CET)
Date: Tue, 10 Nov 2026 14:03:15 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
	linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 34/41] loop: refuse files on pseudo filesystems as
 backing files
Message-ID: <xlql7gc5uyvehjvin4ls3okfnv32xxdj45bjvamf2vdkrakvjx@u4iwy4ydmphs>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-34-4c998976c6c7@kernel.org>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-34-4c998976c6c7@kernel.org>
X-Spam-Level: 
X-Spamd-Result: default: False [-12.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[31];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,google.com,kernel.org,toxicpanda.com,lst.de,lists.infradead.org,zeniv.linux.org.uk,suse.cz,lists.linux.dev,kvack.org,lists.ubuntu.com,lists.xenproject.org,lists.ozlabs.org,gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -12.80
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 10:14:50, Christian Brauner wrote:
> Currently loop accepts any regular file that implements ->read_iter() as
> a backing file and any that also implements ->write_iter() as a writable
> one. That includes files on procfs, sysfs and other pseudo filesystems.
> For example, /proc/kcore attaches read-only as a loop device the size of
> the kernel's virtual address space, 64 PiB with 5-level paging. sysfs
> attributes attach read-write as 4096 byte loop devices. Writing a block
> to the loop device of /sys/kernel/mm/transparent_hugepage/enabled
> changes the THP setting.
> 
> That's not just nonsensical, it can be abused. Loop calls ->read_iter()
> and ->write_iter() of the backing file directly from its worker which
> runs with kernel credentials. But pseudo files enforce part of their
> access rules at read and write time against current. Dozens of sysfs
> ->show() and ->store() methods call capable(). Behind a loop device all
> of these checks are done against the loop worker instead of the task
> that opened the file. And setting up a loop device requires no
> capabilities, only access to the device nodes. So on v7.4-rc1:
> 
> - uid 0 without any capabilities can't write to /sys/kernel/reboot/mode
>   as mode_store() requires CAP_SYS_BOOT. Writing "warm" through a loop
>   device works.
> 
> - uid 0 without any capabilities can't read the files in
>   /sys/firmware/dmi/entries/*/ as dmi_sysfs_attr_show() requires
>   CAP_SYS_ADMIN. Reading them through a loop device works.
> 
> - An unprivileged container that was handed a loop device can't change
>   gro_flush_timeout of its own network devices as
>   gro_flush_timeout_store() requires CAP_NET_ADMIN in the initial user
>   namespace. Writing it through a loop device works.
> 
> The same goes for hard_offline_page, the md and sd attributes, rfkill
> and others.
> 
> Refuse files on pseudo filesystems as loop backing files. Note that
> file_is_pseudo() looks through overlayfs so stacking overlayfs on top of
> sysfs doesn't get around this.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  drivers/block/loop.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index c96e35c3ef42..1482580a1979 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -537,6 +537,9 @@ static int loop_check_backing_file(struct file *file)
>  	if ((file->f_mode & FMODE_WRITE) && !file->f_op->write_iter)
>  		return -EINVAL;
>  
> +	if (file_is_pseudo(file))
> +		return -EINVAL;
> +
>  	return 0;
>  }
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

