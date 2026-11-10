Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D205660A2604
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 12:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Q2H6Mk4O;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=29N3zImF;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Q2H6Mk4O;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=29N3zImF
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP66y405pz2yQJ;
	Tue, 10 Nov 2026 23:54:34 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794315274;
	cv=none; b=B8Odtr2OsSwDpTDfGXPHGGPPYpJsEVEa0rshOb6jplgdzZe0qlbaUGWd4cP0Sv0zfKzIwJO5/QEbfx2ZkPUpPQ7Gf5XkrdWe31NXVrpghfmCyXn9Bs4R71J3cLaV6jnIqkJOn9Teun5vzN7s5hYfbnQUFg6b9OTeiATAaim7nNn/F7RsIAoIiIN0/tpqKihch4g/iGFAL9XIyiw31mvWlrw3bRv/rfVe8lCv2JmprCkWT+qkPPIiFVzElRhktR3Vp2kmlTwtG8Z49LPu+7KFQIBAPQFPAVsQxGuSmqvK0YFaEfhvANeunOcoJfUiTF5nyM9bJOd1F5UpwbGeXaT+dg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794315274; c=relaxed/relaxed;
	bh=OJ/prrn965jMvrgfLjF+vFRorAc5HNvJ6Vj8L/XmMbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FrdiW8A9ivWc87ImTMwqcpj0IX5pVlWXFVq9cnVHJXB3/zeOL0QO9xwE8R0Es/7obJYfQOKa33MUYIO5DtfOhi3IpfZPUOj6tgAW4xq0MjX/eTUzXCKMLSjRpqev5P8YkB/s4qVxn8vSIcXl1m/K5PsfM2PGaoyTn1uNcWsMVbjo+ipD/YQ2YzZIkzO0Ke/vCUsDFfUYqEBZMEC6wBj8aVNKkOz86fHbbpLk/yRDe0WTqDG8eVU4pxaSYMrkf0MRW7CdVxa6/W0GHGvJeCakawadGIz0joxlHePA0Pl4si0d5rcmIREpJdIAZuLkzLVpQeXZmNt7bJQIUyV709Xqsw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz; dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Q2H6Mk4O; dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=29N3zImF; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Q2H6Mk4O; dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=29N3zImF; dkim-atps=neutral; spf=pass (client-ip=195.135.223.130; helo=smtp-out1.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org) smtp.mailfrom=suse.cz
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Q2H6Mk4O;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=29N3zImF;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Q2H6Mk4O;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=29N3zImF;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=suse.cz (client-ip=195.135.223.130; helo=smtp-out1.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP66x3fZhz2xjM;
	Tue, 10 Nov 2026 23:54:33 +1100 (AEDT)
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5BBCB21EC3;
	Tue, 10 Nov 2026 12:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315270; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OJ/prrn965jMvrgfLjF+vFRorAc5HNvJ6Vj8L/XmMbo=;
	b=Q2H6Mk4O1KaxEREOj5DevP2kMmH/Jidslcr1s6/vZIMu9WIDtdkSn5EG2n6fd0LuRLcdyR
	OsFZv9uv7UMWguBVt0RqvpxAGlKN3MHZdrq5jMlTWssQy62BIT2qg2AoLOn1LWDhgCr5PN
	XMWF0Y0SpbRpnTpFBSi/pSKP5wkCCts=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315270;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OJ/prrn965jMvrgfLjF+vFRorAc5HNvJ6Vj8L/XmMbo=;
	b=29N3zImFuoXZ3FcTPq5PwxpXmvPvhMRlDBfBJL8lW84IsbdkpNdw1G7KrJbgDQqTwApVDr
	s36m1YzU5P2ufNAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315270; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OJ/prrn965jMvrgfLjF+vFRorAc5HNvJ6Vj8L/XmMbo=;
	b=Q2H6Mk4O1KaxEREOj5DevP2kMmH/Jidslcr1s6/vZIMu9WIDtdkSn5EG2n6fd0LuRLcdyR
	OsFZv9uv7UMWguBVt0RqvpxAGlKN3MHZdrq5jMlTWssQy62BIT2qg2AoLOn1LWDhgCr5PN
	XMWF0Y0SpbRpnTpFBSi/pSKP5wkCCts=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315270;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OJ/prrn965jMvrgfLjF+vFRorAc5HNvJ6Vj8L/XmMbo=;
	b=29N3zImFuoXZ3FcTPq5PwxpXmvPvhMRlDBfBJL8lW84IsbdkpNdw1G7KrJbgDQqTwApVDr
	s36m1YzU5P2ufNAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2EA8D1339F;
	Tue, 10 Nov 2026 12:54:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LWGGBQYU82p9QQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 12:54:30 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id D65A3224DC; Tue, 10 Nov 2026 13:54:25 +0100 (CET)
Date: Tue, 10 Nov 2026 13:54:25 +0100
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
Subject: Re: [PATCH RFC 03/41] target: fileio: check that the backing file
 supports ->{read,write}_iter
Message-ID: <7gknb2zk5u322p4hwxmbkwko4oqnmtroz6evgxcfgaqv43e2lf@4ys3f4ojdwvu>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-3-4c998976c6c7@kernel.org>
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
In-Reply-To: <20261110-work-loop-pseudo-v1-3-4c998976c6c7@kernel.org>
X-Spamd-Result: default: False [-16.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	REPLY(-4.00)[];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email]
X-Spam-Score: -16.80
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 10:14:19, Christian Brauner wrote:
> With fd_async_io=1 the fileio backend calls ->read_iter() and
> ->write_iter() of the backing file directly. The synchronous path goes
> through vfs_iter_read() and vfs_iter_write() which check for them but
> the aio path doesn't. So a backing file without them calls a NULL
> pointer on its first I/O.
> 
> Refuse such files when configuring the device. On the synchronous path
> every read or write that needed the missing method failed with EINVAL
> anyway.
> 
> Fixes: 769031c92c8b ("scsi: target: target/file: Add support of direct and async I/O")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  drivers/target/target_core_file.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
> index ab9824a4852f..a5391e57e9aa 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
> @@ -144,6 +144,14 @@ static int fd_configure_device(struct se_device *dev)
>  		goto fail;
>  	}
>  	fd_dev->fd_file = file;
> +
> +	if (!file->f_op->read_iter || !file->f_op->write_iter) {
> +		pr_err("FILEIO: %s lacks ->read_iter or ->write_iter\n",
> +		       fd_dev->fd_dev_name);
> +		ret = -EINVAL;
> +		goto fail;
> +	}
> +
>  	/*
>  	 * If using a block backend with this struct file, we extract
>  	 * fd_dev->fd_[block,dev]_size from struct block_device.
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

