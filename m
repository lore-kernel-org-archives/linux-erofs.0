Return-Path: <linux-erofs+bounces-4045-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5B16C54FDF
	for <linux-erofs@archiver.kernel.org>; Thu, 30 Jul 2026 09:03:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h9jsZ262Wz2yYd;
	Thu, 30 Jul 2026 19:03:14 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a07:de40:b251:101:10:150:64:1"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785402194;
	cv=none; b=ec5LJgfZxYdnxweMuZy9PDf/vJ645vF3raY3m11Zw0+vTOY7QOcOE9t9fdTKImUqkyeehLCcW6WdqybsVrT9bu3nu+wr3VOjAJE+MTL46+FeLV6cvs5oL4DfMWOZKP9vRM7tOtRG12T8c4S+U/++oTgLgVTaL45anVAE+3td7efyCsy95zYEUdQIhY9a393vRv0TXzGxLUCBkaBzEjNCKkWT7eywnUrNcTkMlHdGy8l+OPJloDw1wZ10j0xVv7YxiB4taCJT4QDiA/9RXti1kR7vcP/DL7jG5vp+LYaU78YWwTtuAG5GcuF9ci0yCF0aaLai9Dm2LY1ZzthK8Oe1Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785402194; c=relaxed/relaxed;
	bh=2lcyjIV1UgNCG8dyBWciVmy0meoQnVsrSi06pjEH+so=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mxHvUlNZtQ4tbF8KExJb5M7js5GHspfdorvfMLOPF0SU7r+vHfaAC4lAdA+Ur7qjF9gfFouvakCrziPC/SmyRrNbg+R3LP9XG26ghhLQJbTEGBM+6vzcRcfwVWXo0xwbi+rTJwBgh5Za7y2Z6+VyEdz68UlhGooAqjQZnsYfxXW/vG0+8Cq1M27yPFbXzUjEN/Nf1PYidon7nLZVBEpNnnsi35TSXzB2kYi4K2E9OAvwfQstz7rwgFAkGfLagyKJ2/heCPfZS94C/nZPgznmwAtr9cQjkD/vwCxEKzgwEh/DLYstcTH++zqgiWSuCKgHUb6+RWeG3Jfv8/TJw3Xfyw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz; dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=0cUIwe9Y; dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=mWva2A6K; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=maifyACd; dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=gDc1BEZz; dkim-atps=neutral; spf=pass (client-ip=2a07:de40:b251:101:10:150:64:1; helo=smtp-out1.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org) smtp.mailfrom=suse.cz
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=0cUIwe9Y;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=mWva2A6K;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=maifyACd;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=gDc1BEZz;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=suse.cz (client-ip=2a07:de40:b251:101:10:150:64:1; helo=smtp-out1.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2a07:de40:b251:101:10:150:64:1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h9jsX1pNNz2yDs
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 19:03:11 +1000 (AEST)
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AF3897D4B7;
	Thu, 30 Jul 2026 09:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785402181; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2lcyjIV1UgNCG8dyBWciVmy0meoQnVsrSi06pjEH+so=;
	b=0cUIwe9Ywz6ANAz5DcQmwuwm3N/lnDg11kIQFZTq9WiaBTTkmIGW7MIv9ohor8Jw3CXiDj
	chQOCdHSNUaNW8YdZSIWGUrdxsZWocDtRQA1UQ9/vfd4uFMRdtiGqpKMHYSFUcWWYQxBnE
	zgg0tbWDfuD6T5NsrNo2ZfUqR7idszY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785402181;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2lcyjIV1UgNCG8dyBWciVmy0meoQnVsrSi06pjEH+so=;
	b=mWva2A6K46mRjcGrjCcIU6z6ngn0i47JX2KuHiRKNdPYG1qdewJRuOHNuTUILQPDUZhHiN
	CXtzCanVf+tlmaBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785402177; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2lcyjIV1UgNCG8dyBWciVmy0meoQnVsrSi06pjEH+so=;
	b=maifyACdq8mMa8+y4Wq5AXK7l4BKn2Sg1/SGME6NZ+ohi26yk6cGO58fiDoFPsu6OYlg12
	btSuM7+HRyYchkuY85FJ4KQw2s/tO+5Lf6RX7n1/qDF7lp5zctTlsb+y2IRokjiRuEXGL/
	t0h7rCE3VJeRmr2F20ECKslkkBcOr+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785402177;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2lcyjIV1UgNCG8dyBWciVmy0meoQnVsrSi06pjEH+so=;
	b=gDc1BEZzFv6Juckc+df3mLmF5Bi0EdNnCFS10baD/7YUIXPo3aeDT1oqiebPSv1TZQDEnH
	v3kAHSzxRmA8xIBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A3B18779CC;
	Thu, 30 Jul 2026 09:02:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +CDyJ0ETa2obWwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 30 Jul 2026 09:02:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 42EE7A0AAA; Thu, 30 Jul 2026 11:02:57 +0200 (CEST)
Date: Thu, 30 Jul 2026 11:02:57 +0200
From: Jan Kara <jack@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Dave Chinner <dgc@kernel.org>, 
	Bart Van Assche <bvanassche@acm.org>, Hillf Danton <hdanton@sina.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH v7 1/5] block: introduce bio_in_atomic()
Message-ID: <memvwweih7kaket63x6tee7a4z6nefgkelv4xznpxrqysjob2c@t5rfbf53s2og>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-1-3e8e6850068d@columbia.edu>
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
In-Reply-To: <20260730-blk-dontcache-v7-1-3e8e6850068d@columbia.edu>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,sina.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,infradead.org,kernel.org,zeniv.linux.org.uk,suse.cz,gmail.com,linux.alibaba.com,google.com,huawei.com,vivo.com,acm.org,sina.com,linutronix.de,vger.kernel.org,kvack.org,lists.ozlabs.org];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email,infradead.org:email]

On Thu 30-07-26 02:57:51, Tal Zussman wrote:
> Move the atomic context detection logic from erofs's z_erofs_in_atomic()
> into the block layer as bio_in_atomic(). This helper returns true when
> the current context is unsafe for sleeping bio completion handlers (e.g.,
> hard/soft IRQ, preempt-disabled).
> 
> The logic was originally added to erofs in commit c99fab6e80b7 ("erofs:
> fix atomic context detection when !CONFIG_DEBUG_LOCK_ALLOC"). A
> subsequent patch will use it in the block layer's bio completion
> infrastructure, so move it to include/linux/bio.h where both subsystems
> can share it.
> 
> Convert erofs to call the new bio_in_atomic() directly.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  fs/erofs/zdata.c    | 11 +----------
>  include/linux/bio.h | 15 +++++++++++++++
>  2 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
> index 74520e910259..f796bb3ef53b 100644
> --- a/fs/erofs/zdata.c
> +++ b/fs/erofs/zdata.c
> @@ -1427,15 +1427,6 @@ static void z_erofs_decompressqueue_kthread_work(struct kthread_work *work)
>  }
>  #endif
>  
> -/* Use (kthread_)work in atomic contexts to minimize scheduling overhead */
> -static inline bool z_erofs_in_atomic(void)
> -{
> -	if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
> -		return true;
> -	if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
> -		return true;
> -	return !preemptible();
> -}
>  
>  static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
>  				       int bios)
> @@ -1452,7 +1443,7 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
>  
>  	if (atomic_add_return(bios, &io->pending_bios))
>  		return;
> -	if (z_erofs_in_atomic()) {
> +	if (bio_in_atomic()) {
>  		/* See `sync_decompress` in sysfs-fs-erofs for more details */
>  		if (sbi->sync_decompress == EROFS_SYNC_DECOMPRESS_AUTO)
>  			sbi->sync_decompress = EROFS_SYNC_DECOMPRESS_FORCE_ON;
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 8f33f717b14f..62a983758e09 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -368,6 +368,21 @@ static inline struct bio *bio_alloc(struct block_device *bdev,
>  
>  void submit_bio(struct bio *bio);
>  
> +/**
> + * bio_in_atomic - check if the current context is unsafe for bio completion
> + *
> + * Return: %true in atomic contexts (e.g. hard/soft IRQ, preempt-disabled);
> + * %false when a bio can be safely completed in the current context.
> + */
> +static inline bool bio_in_atomic(void)
> +{
> +	if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
> +		return true;
> +	if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
> +		return true;
> +	return !preemptible();
> +}
> +
>  extern void bio_endio(struct bio *);
>  
>  /**
> 
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

