Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB0360A2606
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 12:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=u1B+HDke;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=s5Vry7Gw;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=u1B+HDke;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=s5Vry7Gw
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP6821Mnnz30hq;
	Tue, 10 Nov 2026 23:55:30 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a07:de40:b251:101:10:150:64:2"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794315330;
	cv=none; b=IZeOoyLg7wmp7htXncCLwqQg1XXn6I5Wu/SmDs+Azaj692S9gKkTa9NQxtjSYZoYTz1q/ZUNO5hvFpjud89P5L4mPb6JUtZmSAKZBaA/++PCl8YPp7EwzhxVwuxW+PwN1bLRxrEIU/TmxvC2clXwQAyqBNODJgT4uFUBjlVKiTludmddcli4MjBRNKtJ3Rw1rUmTLTZFJ7mej9yuDFJIaoHPmKF5A8xaC50DyCqaXfIgrEQgwBHqJVrK+6ZgJDpRLAtpnmfx8bpFsdnVp7Ptjs14J/Esa2ZENPlLIlzMWw/og2ewib99rAEqqlELHrJyUYV53kjjWzlzcyMxGecmVw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794315330; c=relaxed/relaxed;
	bh=tdoiUJdd+iiYf5DPNh/N+wqKlHvGCKXVkvS18tLeyxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z2Nns6FZispIv0jqYbPBMGn/SVWrJd07/cbmMtM/gJL8EL2avGAVEIbS5x9OdzraJZYt65ugJmUwuGouVRM4S/zg3VfZDihcY4Kn+M0DfSeig88Y+GaKeMTL8RZaeRydRJ+CEocniYYmWRkBK46yMV4lDi2tO/teuOJGjV+R4o7ON3b+TIeVN82Kfgp91+JxuUeLbrqY2Hxku48QjT4qeIirKCFJX6gUCECyNFeUXchlUu6ROZCVZVFJ4/fYZ9DHscwwQOIvMaoP1ueZDuG3Cl0eWZZMJ1qOASJjr+IPZMMi82OzBaEce/dIxLtY8S4wQLhnOK9rklVxiqct5yl4Uw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz; dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=u1B+HDke; dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=s5Vry7Gw; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=u1B+HDke; dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=s5Vry7Gw; dkim-atps=neutral; spf=pass (client-ip=2a07:de40:b251:101:10:150:64:2; helo=smtp-out2.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org) smtp.mailfrom=suse.cz
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=u1B+HDke;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=s5Vry7Gw;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=u1B+HDke;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=s5Vry7Gw;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=suse.cz (client-ip=2a07:de40:b251:101:10:150:64:2; helo=smtp-out2.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2a07:de40:b251:101:10:150:64:2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP6811XGRz2yYY;
	Tue, 10 Nov 2026 23:55:29 +1100 (AEDT)
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 433A51F7E1;
	Tue, 10 Nov 2026 12:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315326; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tdoiUJdd+iiYf5DPNh/N+wqKlHvGCKXVkvS18tLeyxA=;
	b=u1B+HDke0hpMTlvQS4vtx71OgG/jW66cq5t3mKyddBwSs3IYmIVxUedNECKYU2Wn3gjDNT
	XUqmAOVAzpAAoCLHSQwmjBDhumXbbOHNTsIcqDMxum8byZPrO4ABQMzvGZfY065Bc2x/zH
	mOiuGvCf5UFir5w37V75pl3/j+OZOdo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315326;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tdoiUJdd+iiYf5DPNh/N+wqKlHvGCKXVkvS18tLeyxA=;
	b=s5Vry7GwYW6iUbLBXO4qDI4lvuxved+sj/wAa+gp1aCB2Ie0NTZRQTOaGDvuboGj3hVbu8
	2o09Y6CHNOgJe5BQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315326; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tdoiUJdd+iiYf5DPNh/N+wqKlHvGCKXVkvS18tLeyxA=;
	b=u1B+HDke0hpMTlvQS4vtx71OgG/jW66cq5t3mKyddBwSs3IYmIVxUedNECKYU2Wn3gjDNT
	XUqmAOVAzpAAoCLHSQwmjBDhumXbbOHNTsIcqDMxum8byZPrO4ABQMzvGZfY065Bc2x/zH
	mOiuGvCf5UFir5w37V75pl3/j+OZOdo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315326;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tdoiUJdd+iiYf5DPNh/N+wqKlHvGCKXVkvS18tLeyxA=;
	b=s5Vry7GwYW6iUbLBXO4qDI4lvuxved+sj/wAa+gp1aCB2Ie0NTZRQTOaGDvuboGj3hVbu8
	2o09Y6CHNOgJe5BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 188A2134F4;
	Tue, 10 Nov 2026 12:55:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bVLYOj0U82rFQgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 12:55:26 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id B1F3D224DE; Tue, 10 Nov 2026 13:55:21 +0100 (CET)
Date: Tue, 10 Nov 2026 13:55:21 +0100
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
Subject: Re: [PATCH RFC 04/41] fs: add SB_I_PSEUDO
Message-ID: <mdy4v37mrp7rfwt3bwiiu63ztgdlcqtahyiqj6vw66zo2dl3cz@rd3m2b6sf77x>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-4-4c998976c6c7@kernel.org>
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
In-Reply-To: <20261110-work-loop-pseudo-v1-4-4c998976c6c7@kernel.org>
X-Spamd-Result: default: False [-12.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[31];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	R_RATELIMIT(0.00)[to_ip_from(RLdu9otajk16idfrkma9mbkf9b)];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,google.com,kernel.org,toxicpanda.com,lst.de,lists.infradead.org,zeniv.linux.org.uk,suse.cz,lists.linux.dev,kvack.org,lists.ubuntu.com,lists.xenproject.org,lists.ozlabs.org,gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -12.80
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 10:14:20, Christian Brauner wrote:
> Currently, there's no way to tell whether the files of a filesystem
> store data or whether they are kernel interfaces. Files on pseudo
> filesystems such as procfs or sysfs generate their contents when they're
> read and writes to them are commands to the kernel.
> 
> But a few places in the kernel take an arbitrary file and use it as
> storage: loop, zloop, the nvme target's file backend, the scsi target's
> fileio backend, fuse passthrough, the usb mass storage gadget and erofs
> file-backed mounts. At most they check the file type and whether the
> file implements ->read_iter() and ->write_iter(). That's not enough.
> kernfs provides both for every sysfs attribute for example.
> 
> Add SB_I_PSEUDO so a filesystem can state that its regular files are
> kernel interfaces and must not be used as storage.
> 
> Pseudo filesystems also never hold executables or device nodes. But
> currently each of them decides on its own whether to raise SB_I_NOEXEC
> and SB_I_NODEV. Some do, most don't. Add fc_init_pseudo() as the common
> initialization point for all pseudo filesystems that raises all three
> flags and switch init_pseudo() over to it. The following patches
> convert the mountable pseudo filesystems.
> 
> Nothing checks SB_I_PSEUDO yet so no functional changes.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/libfs.c                     |  2 +-
>  include/linux/fs/super_types.h |  1 +
>  include/linux/pseudo_fs.h      | 11 +++++++++++
>  3 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/libfs.c b/fs/libfs.c
> index 96a6e9b1535f..8c8789489fdf 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -735,7 +735,7 @@ struct pseudo_fs_context *init_pseudo(struct fs_context *fc,
>  		fc->fs_private = ctx;
>  		fc->ops = &pseudo_fs_context_ops;
>  		fc->sb_flags |= SB_NOUSER;
> -		fc->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
> +		fc_init_pseudo(fc);
>  		fc->global = true;
>  	}
>  	return ctx;
> diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
> index 72f4288e16c5..472200bdf081 100644
> --- a/include/linux/fs/super_types.h
> +++ b/include/linux/fs/super_types.h
> @@ -359,5 +359,6 @@ struct super_block {
>  #define SB_I_NOIDMAP	0x00002000	/* No idmapped mounts on this superblock */
>  #define SB_I_ALLOW_HSM	0x00004000	/* Allow HSM events on this superblock */
>  #define SB_I_NO_DATA_INTEGRITY	0x00008000 /* fs cannot guarantee data persistence on sync */
> +#define SB_I_PSEUDO	0x00010000	/* regular files are kernel interfaces, not storage */
>  
>  #endif /* _LINUX_FS_SUPER_TYPES_H */
> diff --git a/include/linux/pseudo_fs.h b/include/linux/pseudo_fs.h
> index a651e60d9410..0ca408aa60af 100644
> --- a/include/linux/pseudo_fs.h
> +++ b/include/linux/pseudo_fs.h
> @@ -2,6 +2,7 @@
>  #define __LINUX_PSEUDO_FS__
>  
>  #include <linux/fs_context.h>
> +#include <linux/fs/super_types.h>
>  
>  struct pseudo_fs_context {
>  	const struct super_operations *ops;
> @@ -15,4 +16,14 @@ struct pseudo_fs_context {
>  struct pseudo_fs_context *init_pseudo(struct fs_context *fc,
>  				      unsigned long magic);
>  
> +/*
> + * Common initialization for all pseudo filesystems, mountable or not. Their
> + * regular files are kernel interfaces. They don't store data and pseudo
> + * filesystems never hold executables or device nodes.
> + */
> +static inline void fc_init_pseudo(struct fs_context *fc)
> +{
> +	fc->s_iflags |= SB_I_PSEUDO | SB_I_NOEXEC | SB_I_NODEV;
> +}
> +
>  #endif
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

