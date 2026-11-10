Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A7B606A33E
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 12:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=esCQM7vh;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=oSEGdPnx;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=esCQM7vh;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=oSEGdPnx
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP66458l4z2yLY;
	Tue, 10 Nov 2026 23:53:48 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a07:de40:b251:101:10:150:64:2"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794315228;
	cv=none; b=DTdyP/T6nBrWjCQUdX3gq72r0HpKJ26DjHRtkN5x2cSL/IaQgvooXWrB4kEyhdftIRByij8QXCo8jp21v+X9XDOO9qj+ahP/ynJs6EejhJiL47+A/74n0NS/w92bE54m9X6DrA015/EktuEYsQu+8og4Q7tzWrL/oO6U3s6kxnU/60nwy/I5GX/1L68QVAQXY7n1zXAmQELx/Y5O3y23kZzDJRrVwKIaTcvsOkmQOc70zJgsFKIR/DX8oXtW/FPUbw1pJ6Q/wMbfV25UQROlj12aOln/qeifVlzbiec4qPtjwO48D0mS6daeoyDPV+iwtXNMnia6gyH9xoTm4ISFCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794315228; c=relaxed/relaxed;
	bh=bC8M9j5KysQj3/tBg6i5bs7GJQfbSn2RIhhiTaj/uW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sb6BSasBWvGss/G+0sR/7m5vFxVWQE6HAf/T99ptxH9+uN0/UjUsd/b/SEvrWAlY0PhSMeNYQiOQvBA2tfx7TJ7zx2jfOUm50d3dt8V2xSeKBG4KnD2tNkO4tOdm4W6dgoJO4B2LSLUeAWIY03NXHgNxRUPN1VZGNqEx9OpRlNLgj599xLz24SLuOBGjGsP8kDVQkyT71lMZn75t8E33L2k+TgmrlVs/jsZrsfKKfBFubs0I9NneDc8OysJlNT9oQ3djyFFJfh7biPE/KFf7c8uZoUk5eZcPKXjcev/ysC9zS6eGjYxLZ/QIXb6lPrJFf5MN0JMRUt85VT7q+erm5w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz; dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=esCQM7vh; dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=oSEGdPnx; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=esCQM7vh; dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=oSEGdPnx; dkim-atps=neutral; spf=pass (client-ip=2a07:de40:b251:101:10:150:64:2; helo=smtp-out2.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org) smtp.mailfrom=suse.cz
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=esCQM7vh;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=oSEGdPnx;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=esCQM7vh;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=oSEGdPnx;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=suse.cz (client-ip=2a07:de40:b251:101:10:150:64:2; helo=smtp-out2.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2a07:de40:b251:101:10:150:64:2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP6636rJdz2xjM;
	Tue, 10 Nov 2026 23:53:47 +1100 (AEDT)
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C21BF1F387;
	Tue, 10 Nov 2026 12:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315224; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bC8M9j5KysQj3/tBg6i5bs7GJQfbSn2RIhhiTaj/uW0=;
	b=esCQM7vhwtFDlR0XGu4BvbeJKkz5yWIkyBoCAFmsMjaesvd2xzTBQ75GstxjBGyvm+uTc3
	zbsPxyyuvivvpTctk9VGrw5XL7jzea4xXXiQ33KgF1MkCOuagUmIs2QoSpY/RNulRuLG5X
	2mokPeCKWxi/pNmsgHI/oRHbYwi1nhQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315224;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bC8M9j5KysQj3/tBg6i5bs7GJQfbSn2RIhhiTaj/uW0=;
	b=oSEGdPnxsbYWAcn6+XCX2+zc7aIbagOCqMu6PvH5TOZ7jB0Ipn+hjsjiYRXirvRo7if16R
	Tl3jPHzwufDb9cCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315224; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bC8M9j5KysQj3/tBg6i5bs7GJQfbSn2RIhhiTaj/uW0=;
	b=esCQM7vhwtFDlR0XGu4BvbeJKkz5yWIkyBoCAFmsMjaesvd2xzTBQ75GstxjBGyvm+uTc3
	zbsPxyyuvivvpTctk9VGrw5XL7jzea4xXXiQ33KgF1MkCOuagUmIs2QoSpY/RNulRuLG5X
	2mokPeCKWxi/pNmsgHI/oRHbYwi1nhQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315224;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bC8M9j5KysQj3/tBg6i5bs7GJQfbSn2RIhhiTaj/uW0=;
	b=oSEGdPnxsbYWAcn6+XCX2+zc7aIbagOCqMu6PvH5TOZ7jB0Ipn+hjsjiYRXirvRo7if16R
	Tl3jPHzwufDb9cCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 91DED1339F;
	Tue, 10 Nov 2026 12:53:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tmqdGtgT82pBQQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 12:53:44 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 32CA7224DA; Tue, 10 Nov 2026 13:53:40 +0100 (CET)
Date: Tue, 10 Nov 2026 13:53:40 +0100
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
Subject: Re: [PATCH RFC 02/41] nvmet: check that the file backend supports
 ->{read,write}_iter
Message-ID: <shrwrwia6jdxrryror4d2x3d52pwwtfve2pu5ql2af4oo6byxo@dkcq5tu4k4l5>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-2-4c998976c6c7@kernel.org>
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
In-Reply-To: <20261110-work-loop-pseudo-v1-2-4c998976c6c7@kernel.org>
X-Spam-Level: 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email]
X-Spam-Score: -12.80
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 10:14:18, Christian Brauner wrote:
> The file backend calls ->read_iter() and ->write_iter() of the backing
> file directly but never checks that they exist. Everything that isn't a
> block device ends up in the file backend. So a namespace pointing to a
> file without them calls a NULL pointer on its first I/O. Only
> buffered_io=1 gets that far as the O_DIRECT open fails for such files.
> 
> Refuse them when the namespace is enabled the same way zloop does since
> commit 0c10f8a1a7ae ("zloop: check that the zone backing file support
> ->{read,write}_iter").
> 
> Fixes: d5eff33ee6f8 ("nvmet: add simple file backed ns support")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  drivers/nvme/target/io-cmd-file.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
> index 695963dd932e..dfa8aa46188c 100644
> --- a/drivers/nvme/target/io-cmd-file.c
> +++ b/drivers/nvme/target/io-cmd-file.c
> @@ -47,6 +47,11 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
>  		return ret;
>  	}
>  
> +	if (!ns->file->f_op->read_iter || !ns->file->f_op->write_iter) {
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
>  	nvmet_file_ns_revalidate(ns);
>  
>  	/*
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

