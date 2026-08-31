Return-Path: <linux-erofs+bounces-4382-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75EDEC61DFD
	for <linux-erofs@archiver.kernel.org>; Mon, 31 Aug 2026 09:59:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hYPcC0YpNz2y2f;
	Mon, 31 Aug 2026 19:59:55 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a07:de40:b251:101:10:150:64:2"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788170395;
	cv=none; b=ltbVBM1NuBb5briKxA1w0S8iRcMQIbNV0vEcwvmGOPlX89HpnAUVlKnCuhB9JOsAjbKguwLeEJH8nDymRbESYHwaoAjhFRy+GIQgNXXpdTWW7wUJIvOH8nQK77q8dL+VMUujL+MekJ+JXfNi6bQ4KVwFTzjxIPa9ub/MBP0KumL+gXHae9q0OAzZ0k0GnHsZWxJYY+WbTnxaNcrbgS2AmyijLFo0PHUvCJX7NGjCSN/JT6rPjbW55C1kgEBFeo3NSne9U8JBF2DIqjlONijogUskcK8WpMUD1Px6mb+n3Ki6LgYOFrCTggK9p7p7Fenc+v5Wc2XyFptcHJYAOyg36g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788170395; c=relaxed/relaxed;
	bh=9NwnR8kMEaTJTYkoxBQW5G3izVgqGS7StBEwaJ2omhE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q/dvuSo3iJJo2bljt6y6E8VGMg5WdkLkRux729QMJCdmWCDt17mUuzPnJsqZ1HONpywiFkf7TDi2q726JHyjlUQKGVmtt9c5csuvcWn/D312iRCy46I4u8YxIC24PyH/U6eBpLdvrEAgr4dob4lr4zLZXwE+FppwwJfVIBnIUiR91fpwtcz4ZprpDps7v5td05Rb5xBxAD57BYaxvM9EPulhR+Dy1skwghn60G662/CrZNtibFuxTJ6iUeYA6Ec/9S8TfhP4m867JrvooLohiWCqondRGd0hI7Dh56layXdKbUCStpc3F1Kt/NexLfKpNb6bShf46FyaKwIFwEi7QA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz; dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=dW2nKgD/; dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=KmcOhO0z; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=r9+5dkfj; dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vayhPUMM; dkim-atps=neutral; spf=pass (client-ip=2a07:de40:b251:101:10:150:64:2; helo=smtp-out2.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org) smtp.mailfrom=suse.cz
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=dW2nKgD/;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=KmcOhO0z;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=r9+5dkfj;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vayhPUMM;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=suse.cz (client-ip=2a07:de40:b251:101:10:150:64:2; helo=smtp-out2.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2a07:de40:b251:101:10:150:64:2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hYPc940n6z2xLf
	for <linux-erofs@lists.ozlabs.org>; Mon, 31 Aug 2026 19:59:53 +1000 (AEST)
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BCE4E1FAAB;
	Mon, 31 Aug 2026 09:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788170383; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9NwnR8kMEaTJTYkoxBQW5G3izVgqGS7StBEwaJ2omhE=;
	b=dW2nKgD/72GHfPDPSkIXHWa4TQlW9zo4m5ZJZt18et8r8SpFKwl3fSOhDCUde4WrGHhX1k
	HthafQUnqSZwcZK8Hdcs9U36lkHKEFP7wcuFYQxjwio2w5aV+Vt72W3ZXcuri1mhWwTdMf
	dP+uDJvuZa7oiZHnAx8jWbEbvlydq4E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788170383;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9NwnR8kMEaTJTYkoxBQW5G3izVgqGS7StBEwaJ2omhE=;
	b=KmcOhO0zo72Y4OHAa8RvceB+zt8rPD1OtYKdTL75AERgXOIdssNGME6lJ09SSLwG+HwP6H
	WPniXvtYYYJ7buDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788170379; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9NwnR8kMEaTJTYkoxBQW5G3izVgqGS7StBEwaJ2omhE=;
	b=r9+5dkfj5zv2zJtacQf2HZljTAw/25dZVX8yvLicsAhmPie/8z4lpxN7aqnWa4UN22X30z
	VqtIUOoyqHhMMot3U+vyaxuyjejWrLJMumjOQ8E3Br8VcDxJXDazwa4lekbK2hbqemViUC
	LVdcCgmonttzkdd8su0ehz6W1kl120w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788170379;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9NwnR8kMEaTJTYkoxBQW5G3izVgqGS7StBEwaJ2omhE=;
	b=vayhPUMMZNg3rW2xgsNzuc/IUtzfsyNI4zFxAL3JrlK7XeBEytvIqcNyZdaxkU8YXY20/9
	vR13eZLPIsgFyYDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 98AE413694;
	Mon, 31 Aug 2026 09:59:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2pBAJYtQlWp8cAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 31 Aug 2026 09:59:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 29D40A13B5; Mon, 31 Aug 2026 11:59:35 +0200 (CEST)
Date: Mon, 31 Aug 2026 11:59:35 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <christian@brauner.io>, Jan Kara <jack@suse.cz>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Theodore Tso <tytso@mit.edu>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, ntfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/9] mm: Improve memalloc_nofs_save() documentation
Message-ID: <wriwrbwg3sx5kpl6s7yggam5x7ljml2sul5rz4dm7ftbyyoqyu@yqjepgxxtd3g>
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-2-willy@infradead.org>
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
In-Reply-To: <20260830041901.2668-2-willy@infradead.org>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	TAGGED_RCPT(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[brauner.io,suse.cz,kernel.org,mit.edu,gmail.com,squashfs.org.uk,lists.ozlabs.org,vger.kernel.org,lists.linux.dev,kvack.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]

On Sun 30-08-26 05:18:48, Matthew Wilcox (Oracle) wrote:
> Talk about why someone should call this function instead of
> what this function does.  This makes the long comment in mm/readahead.c
> obsolete; replace it with a comment about which case we're protecting
> against.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Yeah, I think the documentation is better. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/sched/mm.h | 31 +++++++++++++++++++++++--------
>  mm/readahead.c           | 14 ++------------
>  2 files changed, 25 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> index d7c6a942aa7e..f76be1141b06 100644
> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -372,13 +372,26 @@ static inline void memalloc_noio_restore(unsigned int flags)
>  }
>  
>  /**
> - * memalloc_nofs_save - Marks implicit GFP_NOFS allocation scope.
> + * memalloc_nofs_save - Prevent recursion into the filesystem.
>   *
> - * This functions marks the beginning of the GFP_NOFS allocation scope.
> - * All further allocations will implicitly drop __GFP_FS flag and so
> - * they are safe for the FS critical section from the allocation recursion
> - * point of view. Use memalloc_nofs_restore to end the scope with flags
> - * returned by this function.
> + * All memory allocations between calling this function and calling
> + * memalloc_nofs_restore() will be prevented from calling into filesystems
> + * to reclaim memory.  Clean page cache memory can still be reclaimed,
> + * but (for example) inodes will not be.
> + *
> + * The primary reason to do this is that the caller has taken a lock
> + * which would be needed by FS reclaim.  While we could theoretically
> + * call into a different filesystem in this case, it can be a deep call
> + * stack so it is better to avoid all filesystems.
> + *
> + * Filesystems often choose to incorporate a call to this function as part
> + * of starting a journal transaction.  While not a lock in the normal
> + * sense, it has much the same effect as nested journal transactions
> + * are either prohibited or expensive.
> + *
> + * Also call this function if you need to allocate memory while holding
> + * a file folio locked.  High order allocations (such as those requested
> + * by slab) can trigger compaction which will attempt to lock the folio.
>   *
>   * Context: This function is safe to be used from any context.
>   * Return: The saved flags to be passed to memalloc_nofs_restore.
> @@ -389,10 +402,12 @@ static inline unsigned int memalloc_nofs_save(void)
>  }
>  
>  /**
> - * memalloc_nofs_restore - Ends the implicit GFP_NOFS scope.
> + * memalloc_nofs_restore - End filesystem reclaim scope.
>   * @flags: Flags to restore.
>   *
> - * Ends the implicit GFP_NOFS scope started by memalloc_nofs_save function.
> + * Ends the implicit memory allocation scope started by
> + * memalloc_nofs_save().  This may not enable access to filesystem reclaim
> + * if it was already disabled at the time memalloc_nofs_save() was called.
>   * Always make sure that the given flags is the return value from the
>   * pairing memalloc_nofs_save call.
>   */
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 6e5563290287..9c116d4ba963 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -227,17 +227,7 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
>  	gfp_t gfp_mask = readahead_gfp_mask(mapping);
>  	unsigned long mark = ULONG_MAX, i = 0;
>  	unsigned int min_nrpages = mapping_min_folio_nrpages(mapping);
> -
> -	/*
> -	 * Partway through the readahead operation, we will have added
> -	 * locked pages to the page cache, but will not yet have submitted
> -	 * them for I/O.  Adding another page may need to allocate memory,
> -	 * which can trigger memory reclaim.  Telling the VM we're in
> -	 * the middle of a filesystem operation will cause it to not
> -	 * touch file-backed pages, preventing a deadlock.  Most (all?)
> -	 * filesystems already specify __GFP_NOFS in their mapping's
> -	 * gfp_mask, but let's be explicit here.
> -	 */
> +	/* Allocating with locked folios */
>  	unsigned int nofs = memalloc_nofs_save();
>  
>  	lockdep_assert_held(&mapping->invalidate_lock);
> @@ -512,7 +502,7 @@ void page_cache_ra_order(struct readahead_control *ractl,
>  
>  	ra->order = new_order;
>  
> -	/* See comment in page_cache_ra_unbounded() */
> +	/* Allocating with locked folios */
>  	nofs = memalloc_nofs_save();
>  	filemap_invalidate_lock_shared(mapping);
>  	/*
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

