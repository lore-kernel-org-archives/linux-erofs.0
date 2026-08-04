Return-Path: <linux-erofs+bounces-4137-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05842C55838
	for <linux-erofs@archiver.kernel.org>; Tue,  4 Aug 2026 17:04:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hF0JQ0cMjz2yH5;
	Wed, 05 Aug 2026 03:04:22 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785863062;
	cv=none; b=UazqpIVYPLe4y0suH//ij9x8ke7AMXXzfv6EO8LKhfa29vr5P+iCI5rJPrOKockGFfFpx7iGcE451VIgjJq33l7A512lfMRiuUAbqthCm+w/dq9tQSRQPCRER0U+kP4xS3X0mWbOvtDls3+EImZEhKjc/giBCb1XZ4Ph5HooNlDp1N6j3H8ptYD23CDls5dxGfbJ5rmutRrs65vvSbA4bDHUWVZQ27l8ZB13ca8LcOdevxcHpjgjEUloRy5RBo2jh8sdTuLCdSpC4aUoYHiMmKAa9EIx0JXScbYwbuy6P+g3csPBoBOpIGL/QKUHvwoWIKpKpN3rR2OfraXsOEdpLA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785863062; c=relaxed/relaxed;
	bh=+5v7MkDI4Dtpq/Qliw3bpPtxAQ4VzKqgcoQOQ2I8B4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q1boU7RdLavQ4IxNh4xSNDwPKHYiuNRt0FCW5szSJoVgfuUgqQzStka5hT/TC9dJAcP/dFet0UbqVWbxzwIKz0lGmtVxPLw1rK+yNml9kRLv7tQ0vZXuwL0lAXKMqdtxc50UpsbxrbITnIJznAVrBwFla12x9Wl4bSa9XsH531P0AYjyK6kSl0uSKQQEKE0lu5tEFFMqmLj6DcVplHBm06DHlQQyZd5D9r+ixAPjOsI4xCstQyUiHAs7SUQwRCG9A79RWbzQ2RfI5ZrxiBb2EFBpBqh/5TNKOZUgT+ugOHYEBA/uvQS/hGh3yRxt+l3mn13JkI9vIxJOgBCU84f6wA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz; dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=NzP7nDte; dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=0I8ng/Lb; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=JcfVmEHS; dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ACZaZmlW; dkim-atps=neutral; spf=pass (client-ip=195.135.223.130; helo=smtp-out1.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org) smtp.mailfrom=suse.cz
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=NzP7nDte;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=0I8ng/Lb;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=JcfVmEHS;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ACZaZmlW;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=suse.cz (client-ip=195.135.223.130; helo=smtp-out1.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hF0JP101gz2xqM
	for <linux-erofs@lists.ozlabs.org>; Wed, 05 Aug 2026 03:04:20 +1000 (AEST)
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 834C37F9C0;
	Tue,  4 Aug 2026 17:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785863052; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+5v7MkDI4Dtpq/Qliw3bpPtxAQ4VzKqgcoQOQ2I8B4A=;
	b=NzP7nDtelMe+b+taflIEH1Ih7EA+zpoaRjoHxBaRJg4zRkipq6bc5B+Qtlij/L0b5HdzX7
	dklukd4c/qkMwnBiQmBsZnhHpUk/Z+iDNomLyEShRjrHbMNfNW4mT4bcApJdri/KWsiswu
	mI4GxjZmNQyM/SRbX5Z0o8wqarNJ12Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785863052;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+5v7MkDI4Dtpq/Qliw3bpPtxAQ4VzKqgcoQOQ2I8B4A=;
	b=0I8ng/Lb6ZboK95ZUQpPJxJUIWJ1vDVgwjOkNHKh+nbd/uUPb9jQxNimxSvW8CEWTQDG+Y
	1OT2iULKP+GXDlBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785863048; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+5v7MkDI4Dtpq/Qliw3bpPtxAQ4VzKqgcoQOQ2I8B4A=;
	b=JcfVmEHSRj0suLTD08CtW028Ianxbe8YUbG6aqBAK7sSaVNnYXuJQ3MN4/fiOwiwMvJTr+
	fewzRc+rw7H3AQo2s57kMiRIFWNy0obiW3ukVmnHdUWmfVxTtX5qGw7E2RBn+sMQKvOi5e
	jesn+3ZJ7OOXQDG7Z5M2+VzlLnE9sHk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785863048;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+5v7MkDI4Dtpq/Qliw3bpPtxAQ4VzKqgcoQOQ2I8B4A=;
	b=ACZaZmlW7Js3yZLwzUjecV7cs2WuHQYbJZx/VOwQikbrXC2XRa+qQYJmWNzZ/f8xHiVtCM
	Y/+g0pEvgZY6MJBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 732CD779BB;
	Tue,  4 Aug 2026 17:04:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RbIYHIgbcmpQYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 04 Aug 2026 17:04:08 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 14D26A12F2; Tue, 04 Aug 2026 19:04:08 +0200 (CEST)
Date: Tue, 4 Aug 2026 19:04:08 +0200
From: Jan Kara <jack@suse.cz>
To: Zi Yan <ziy@nvidia.com>
Cc: Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC 07/14] fs/erofs: mm/pagemap: add
 readahead_folio_reverse() to avoid folio->private
Message-ID: <2evaxdu6cobpnzzer3y7fsrqvmtmhj7gm3e5buebdaw564igx6@7bs5enipxnpx>
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-7-142c97ba3562@nvidia.com>
 <332rknj4vo3cfhvfhhlf6pvg37s3lbrnzbbnv4swa6gctsiu6a@ndotgokvnglc>
 <DKFGTVA0XD01.OZYNYUOU9FTX@nvidia.com>
 <huzyeqj6a57nbcqc23v6f6rdhkob5552fcwy4mlrsagycqi4rz@ggsapkumc2gq>
 <DKGA508ERSYM.26RBD4HYM1SL8@nvidia.com>
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
In-Reply-To: <DKGA508ERSYM.26RBD4HYM1SL8@nvidia.com>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[37];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,infradead.org,linux-foundation.org,linux.dev,google.com,suse.com,linux.alibaba.com,arm.com,gourry.net,nvidia.com,cmpxchg.org,tencent.com,kvack.org,vger.kernel.org,gmail.com,vivo.com,lists.ozlabs.org];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLc5chj8mdhigtayhgqted7wkp)]

On Tue 04-08-26 11:54:41, Zi Yan wrote:
> On Tue Aug 4, 2026 at 5:32 AM EDT, Jan Kara wrote:
> > On Mon 03-08-26 12:56:36, Zi Yan wrote:
> >> On Mon Aug 3, 2026 at 5:54 AM EDT, Jan Kara wrote:
> >> > On Fri 31-07-26 22:13:30, Zi Yan wrote:
> >> >> erofs needs to traverse readahead folios in reverse order to achieve
> >> >> maximum performance by
> >> >> 1. reading all folios from readahead_folio();
> >> >> 2. storing the prior folio pointer in folio->private;
> >> >> 3. traverse from the last folio to the first one.
> >> >> 
> >> >> Add readahead_folio_reverse() to achieve the same function without using
> >> >> folio->private.
> >> >> 
> >> >> It prepares for a future commit that replaces PG_private checks with
> >> >> !folio->private checks. After switching the checks, erofs's use of
> >> >> folio->private without bumping folio refcount can cause unexpected
> >> >> outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() becomes
> >> >> reachable.
> 
> <snip>
> 
> >> 
> >> The below is what I come up with. I did not add a bool to
> >> readahead_control, since I think that is the decision of caller of
> >> __readahead_advance(). But let me know if you disagree.
> >
> > The reason why I wanted bool in readahead_control is that if some code
> > ends up mixing readahead_folio() with readahead_folio_last() things will
> > get confused (because __readahead_advance() really wants to skip the batch
> > returned from the *previous* call to readahead_folio[_last]()). With the
> > bool in rac, even mixed use will properly advance the state of the
> > readahead_control. I don't think mixed use is very realistic (at this
> > point at least) so I'm ok with leaving that for later if you don't like it.
> 
> Got it. I am trying to figure out your mental model of how the mix of
> readahead_folio() and readahead_folio_last() works with the bool inside
> ractl. By looking at readahead_folio_last() code, it is almost the same
> as readahead_folio() with __readahead_folio() inlined
> (__readahead_folio() is only used by readahead_folio(), so the inline
> can happen without any issue). As a result, we can get rid of
> readahead_folio_last(), add set_readahead_direction() to set the
> embedded bool read_from_head, and use readahead_folio() only. This
> removes redundant code in readahead_folio_last(). One thing I am not
> certain is whether we want to
> 
> 1. use set_readahead_direction() explicit and warn readahead_folio() if
> read_from_head is not initialized, or
> 
> 2. set read_from_head to true by default, so that only erofs needs to
> call set_readahead_direction() to change read_from_head.
> 
> The former is less confusing but changes how readahead_folio() works;
> the latter is simpler but implicit read_from_head state might confuse
> people at some point.

My idea was: readahead_folio() will call __readahead_advance() and then set
rac->forward = true. readahead_folio_last() will call __readahead_advance()
and set rac->forward = false. __readahead_advance() advances from beginning
/ end based on rac->_forward value.

								Honza


> > Also I have some minor comments below.
> >
> >> diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
> >> index b59f2745a8e72..23f423c22ac8c 100644
> >> --- a/fs/erofs/zdata.c
> >> +++ b/fs/erofs/zdata.c
> >> @@ -1908,8 +1908,8 @@ static void z_erofs_readahead(struct readahead_control *rac)
> >>  	trace_erofs_readahead(realinode, readahead_index(rac), nrpages, false);
> >>  	z_erofs_pcluster_readmore(&f, rac, true);
> >>  
> >> -	/* traverse in reverse order for best metadata I/O performance */
> >> -	while ((folio = readahead_folio_reverse(rac))) {
> >> +	/* traverse from last to first for best metadata I/O performance */
> >> +	while ((folio = readahead_folio_last(rac))) {
> >>  		err = z_erofs_scan_folio(&f, folio, true);
> >>  		if (err && err != -EINTR)
> >>  			erofs_err(realinode->i_sb, "readahead error at folio %lu @ nid %llu",
> >> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> >> index 5ca5aa365f319..2cc3de5594518 100644
> >> --- a/include/linux/pagemap.h
> >> +++ b/include/linux/pagemap.h
> >> @@ -1510,13 +1510,21 @@ void page_cache_async_readahead(struct address_space *mapping,
> >>  	page_cache_async_ra(&ractl, folio, req_count);
> >>  }
> >>  
> >> +static inline void __readahead_advance(struct readahead_control *rac,
> >> +		bool read_from_head)
> >> +{
> >> +	if (read_from_head)
> >> +		rac->_index += rac->_batch_count;
> >> +
> >> +	rac->_nr_pages -= rac->_batch_count;
> >> +}
> >
> > Maybe we can add:
> >
> > 	rac->_batch_count = 0;
> >
> > as well since after the advance the _batch_count isn't valid anymore? We
> > can then also remove it from the callers.
> 
> Yes, for __readahead_batch(), _batch_count is zeroed right after. For
> __readahead_folio() and readahead_folio_last(), _batch_count is either
> zeroed or overwritten by folio_nr_pages() before any use.
> 
> >
> >> +
> >>  static inline struct folio *__readahead_folio(struct readahead_control *ractl)
> >>  {
> >> -	struct folio *folio;
> >> +	struct folio *folio = NULL;
> >
> > Not sure why this initialization got here...
> 
> Will remove it. It is some leftover during my development. Thank you for
> pointing it out.
> 
> >
> >>  
> >>  	BUG_ON(ractl->_batch_count > ractl->_nr_pages);
> >> -	ractl->_nr_pages -= ractl->_batch_count;
> >> -	ractl->_index += ractl->_batch_count;
> >> +	__readahead_advance(ractl, /* read_from_head= */ true);
> > 				   ^^^^
> > This is not really a kernel style :), please delete this comment. I'm ok with
> > pure false/true here - it is an internal helper used in few places. If
> > things get wider use, we tend to switch to 'unsigned flags' with explicit
> > flag names to ease code reading. But that's not the case here.
> 
> We did this in some MM code. I will delete the comment like you
> suggested.
> 
> <snip>
> 
> >> @@ -1583,11 +1594,10 @@ static inline unsigned int __readahead_batch(struct readahead_control *rac,
> >>  {
> >>  	unsigned int i = 0;
> >>  	XA_STATE(xas, &rac->mapping->i_pages, 0);
> >> -	struct folio *folio;
> >> +	struct folio *folio = NULL;
> >
> > Again not sure why this initialization got here...
> 
> Will remove.
> 
> -- 
> Best Regards,
> Yan, Zi
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

