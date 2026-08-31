Return-Path: <linux-erofs+bounces-4386-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1AD1C61DE2
	for <linux-erofs@archiver.kernel.org>; Mon, 31 Aug 2026 10:08:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hYPnf24Wlz2yCv;
	Mon, 31 Aug 2026 20:08:06 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788170886;
	cv=none; b=ftMghDtViQogeqt6F1S70BWvBPzvdGaD2E2iHQdECwe+nkhXgXZFn03XraXtLWZiKHDVltQrKbzCZOZCWYKvhFQkXsU7qT+oOcOE6AMZcslu3oUZX3QdUlZQZ08vftw24UGxGdi1oFkbxjHju83MxlyZ5Q/7KwYCj/WlFDko4//UBT4kvyKCqP9bowHa8IZ7vg2kIpz3tw5XkIsocB9ymhs1tyZROJ3gPv981ypIhhyZzHnf5f7DNv+r3MDEe9Hi7TBw716DF9LXqfcKCHfzNDbHuDqOgSWkwTdnGrd0AGYB2BtvxLSPymMgX1yOWn7hoHbYeBR6RYOhn3ps2LobcA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788170886; c=relaxed/relaxed;
	bh=kgcS0o3Xgc0q06A194A0nwAi34yqPqnCWzQ7aKp6YgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E8WuMgKSfCjvU4OJO8Ar/uxPXOoDPQBVrqTtywt3AWv3ScJ+ZPyRHKHW0jqNY1JoGV2hr+/9lCrB9p5wCebUTJ2qV1cm5TmARKS0lK3Q5G0H1LDloZEXq8aFuvMEkj8hZ7qbTJrlDuFTBk7nQnUaL0NlqtM2iAI1pIvUmzWqvK5LfbYMjp6e+8HxHNqIbn1HmDF6+iyTiAfgf5E0Ws7QooygqQwJ3lCy44W+FXwgWU7+cC37nv/VF6Jymjegw0EssRMNQbGx1wtXL8l7nggbi0j9CoBWploSAj55rKhSTsBcw6OjBoHoDd/uLnHA9LU1hZ4VW3QXsj/PuRBhJlQ6Hg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz; dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=aNRfX8vx; dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=C2FBLfRx; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=bYP23/Jw; dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HJyZzCAq; dkim-atps=neutral; spf=pass (client-ip=195.135.223.131; helo=smtp-out2.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org) smtp.mailfrom=suse.cz
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=aNRfX8vx;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=C2FBLfRx;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=bYP23/Jw;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HJyZzCAq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=suse.cz (client-ip=195.135.223.131; helo=smtp-out2.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hYPnd3t7Dz2xLf
	for <linux-erofs@lists.ozlabs.org>; Mon, 31 Aug 2026 20:08:05 +1000 (AEST)
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D72481FB3C;
	Mon, 31 Aug 2026 10:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788170878; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kgcS0o3Xgc0q06A194A0nwAi34yqPqnCWzQ7aKp6YgU=;
	b=aNRfX8vxxjM3odxsdfJV6wO0jG1NqkuTD9HoFNIODpmSWjCxeNfMdMYvhmzKQjujswSnS/
	rsw2myUH73slSIpAbHyQIpFfxod/SQ2iQvVYWJoq5Caq6Mw/C9sC61t5fOi17IYtnepOde
	7PSGZ/7EJG/gjRtw+IKV6ViVMkT9ZzI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788170878;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kgcS0o3Xgc0q06A194A0nwAi34yqPqnCWzQ7aKp6YgU=;
	b=C2FBLfRx5w0FhBlYmUEqJBJeiO+tYeVwOm3uAqGwG+EH4A/5oSH+COi7OpJf0RrTmcyy3Y
	+8lyiHRF5PTrfjCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="bYP23/Jw";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HJyZzCAq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788170873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kgcS0o3Xgc0q06A194A0nwAi34yqPqnCWzQ7aKp6YgU=;
	b=bYP23/JwEC8Iz5BXzI8ktYpWIGLxXVJ+2iWwruUdHZ9/LPZaqgfV59aDVFEPG5i3JOTaks
	2uIp7s/5M7c+SLxJsp+nlM5EyOiFQZtnegZ12+DPLgrtIOdAQeUPZb/CMSXHltIUiRLDts
	FI0VoUMNgmd+3o2uc4+mgVVrJDfjYtY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788170873;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kgcS0o3Xgc0q06A194A0nwAi34yqPqnCWzQ7aKp6YgU=;
	b=HJyZzCAqmkoMNCvobtYJW6f9ASXIDXGTYKAyP3rU5YD/8sFndO8X/CKnGEI4bW/Uok/xuJ
	kiVj+Hpb5awsiaBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A253D13682;
	Mon, 31 Aug 2026 10:07:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vNCfJ3lSlWobeQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 31 Aug 2026 10:07:53 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 39461A13B5; Mon, 31 Aug 2026 12:07:45 +0200 (CEST)
Date: Mon, 31 Aug 2026 12:07:45 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <christian@brauner.io>, Jan Kara <jack@suse.cz>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Theodore Tso <tytso@mit.edu>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, ntfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/9] nfs: Remove redundant FGP_NOFS
Message-ID: <qabnsbfd2jknm6g6h2jqlavbpxiem3f2rfu6lwozmlt264aknw@6vxajyigvkaz>
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-5-willy@infradead.org>
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
In-Reply-To: <20260830041901.2668-5-willy@infradead.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: D72481FB3C
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[18];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[brauner.io,suse.cz,kernel.org,mit.edu,gmail.com,squashfs.org.uk,lists.ozlabs.org,vger.kernel.org,lists.linux.dev,kvack.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,infradead.org:email,suse.com:email,suse.cz:dkim,suse.cz:email]

On Sun 30-08-26 05:18:51, Matthew Wilcox (Oracle) wrote:
> The flags already include FGP_NOWAIT which prohibits all reclaim, not
> just reclaiming from the filesystem.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Obvious enough :) feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/nfs/dir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
> index 49394123bd09..e34125a8a2e2 100644
> --- a/fs/nfs/dir.c
> +++ b/fs/nfs/dir.c
> @@ -447,7 +447,7 @@ static struct folio *nfs_readdir_folio_get_next(struct address_space *mapping,
>  	struct folio *folio;
>  
>  	folio = __filemap_get_folio(mapping, index,
> -			FGP_LOCK|FGP_CREAT|FGP_NOFS|FGP_NOWAIT,
> +			FGP_LOCK | FGP_CREAT | FGP_NOWAIT,
>  			mapping_gfp_mask(mapping));
>  	if (IS_ERR(folio))
>  		return NULL;
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

