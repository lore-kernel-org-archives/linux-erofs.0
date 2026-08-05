Return-Path: <linux-erofs+bounces-4142-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB162C55ABA
	for <linux-erofs@archiver.kernel.org>; Wed,  5 Aug 2026 09:26:00 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hFQ526TkHz2y8c;
	Wed, 05 Aug 2026 19:25:58 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785921958;
	cv=none; b=RtuilQzDgfj5PWBJJJXyxm0CLEU/35kJSVSYAFdSqlCgtY8UmEqV4+UOG5mk3tFxR3AzrHxmKKiy/ICb5PfK4K/ZJHtWz5Z1uM/9QLu/P3ilJCD8EnxTQIIR1RQNG4t1pRzx8cMQv++HknRRPnWTrnu2MC2GGKG3OQuM66ZZwlLH8J95VLSCGLHuq6zMTFuVTpisDTdCP+kOceyljSKDsKPfRFGls7rCuPrjyv5D9W7X7UNqbBqZPpjU+HxvLxY9lICRjQZrsXt3HxyH2TWKZX+NUVufUOzzchTCb6CK7SRlgYTPurOfAe5XqMLVvBtLvIzp2ZgCKzv/bPbq+ji7Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785921958; c=relaxed/relaxed;
	bh=Unq3L3W/LMOsRcSXFhJi3b4iG89arfC8wlxjitqO8bM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NOL7m45xHvNqSjI+4EVroGkA4q64FjGk06LVZXww3IfSUzZwF+p8xHa1liFSzvFxcv2NpjRkHbsZMuc+6Oga0xoGnTmPMFxMHTmkHW1+V1+yv+uE3mJde1eEfeZSmRyAhpkQLF18j3mspL54ngSWqJksozHNKijTmtTdiOTFg0tJwIrufBVWBsthAU/5bxo2WTEXikW0NbP9gPfbu6bJvencOpJIJrHmCaPS7C0tBN/ONjbYC//0RbYsJudIy2glb8Vt5u4+NQNB4oEXB1KOPpRzCTdjSlGeA4b8XOcpgyWuZpgqPjuTfbL/y2X1b6whH4F5qiZESDt0KlcYD3PZ+A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz; dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=BeLeBx+R; dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+b/K4Sqr; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=dE7KOysv; dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=4GdgJQCy; dkim-atps=neutral; spf=pass (client-ip=195.135.223.130; helo=smtp-out1.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org) smtp.mailfrom=suse.cz
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=BeLeBx+R;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+b/K4Sqr;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=dE7KOysv;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=4GdgJQCy;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=suse.cz (client-ip=195.135.223.130; helo=smtp-out1.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hFQ5156pfz2xqM
	for <linux-erofs@lists.ozlabs.org>; Wed, 05 Aug 2026 19:25:57 +1000 (AEST)
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 294947FC27;
	Wed,  5 Aug 2026 09:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785921950; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Unq3L3W/LMOsRcSXFhJi3b4iG89arfC8wlxjitqO8bM=;
	b=BeLeBx+RbR7lIXCZOhMwI7UuGd9+/JKpVR3qQU+wSjCQ/3kDvtgTVqP+FYu7l5oPoKc+IJ
	05bf6y7mbobzoujJwJ++BNE5FWF5+ZzbwSKnLfNWcuV0R3NXT2YrwYwwS/Dar13yO+CV/z
	vUgeIoq9zT7HSDUixmRFbELP2ELZZ1w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785921950;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Unq3L3W/LMOsRcSXFhJi3b4iG89arfC8wlxjitqO8bM=;
	b=+b/K4SqrGg5pjq2JjXGlzgM4Gl5Bnu0gGtSAKIU/D8U2QuSRLoATAoSf8PZava2ksrsV33
	SGsov77Dzp9AStBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dE7KOysv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4GdgJQCy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785921946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Unq3L3W/LMOsRcSXFhJi3b4iG89arfC8wlxjitqO8bM=;
	b=dE7KOysv06PWLA2nYIGNx9NLCv/3Sp7N/KXMQlGQjRN+8TiOj2KrsJCUlHSE3eStEpgVe7
	PLZKBi4ZJhD3lpf3PfSNqV9vn1xjZe07BtpEvfL0RsJgU9kNLvf6d1nJFXV0RU6flCxsXX
	ZuY5lHfzmqJvq9zmKgmEIyDbBNtAVAA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785921946;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Unq3L3W/LMOsRcSXFhJi3b4iG89arfC8wlxjitqO8bM=;
	b=4GdgJQCyh1+GIPV9s9EVlMFMBEn4BAEEp6LYnz7ZsFI7wGwDEUDivwefCweLJPjNSvDGQm
	0rhpnVdK2JTGO0Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 11B80779B6;
	Wed,  5 Aug 2026 09:25:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IhhUBJoBc2oBMgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 05 Aug 2026 09:25:46 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id AC37FA13A7; Wed, 05 Aug 2026 11:25:41 +0200 (CEST)
Date: Wed, 5 Aug 2026 11:25:41 +0200
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
Message-ID: <ivg5x7hjo4tmpd34i6wrd5cp2v56c3vorwru7h6kqxnqlcpte7@lvd7xa4ncwxu>
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-7-142c97ba3562@nvidia.com>
 <332rknj4vo3cfhvfhhlf6pvg37s3lbrnzbbnv4swa6gctsiu6a@ndotgokvnglc>
 <DKFGTVA0XD01.OZYNYUOU9FTX@nvidia.com>
 <huzyeqj6a57nbcqc23v6f6rdhkob5552fcwy4mlrsagycqi4rz@ggsapkumc2gq>
 <DKGA508ERSYM.26RBD4HYM1SL8@nvidia.com>
 <2evaxdu6cobpnzzer3y7fsrqvmtmhj7gm3e5buebdaw564igx6@7bs5enipxnpx>
 <DKGBQHP25RE0.3NKUQSDULAQSX@nvidia.com>
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
In-Reply-To: <DKGBQHP25RE0.3NKUQSDULAQSX@nvidia.com>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[37];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLkwzcrc11j1xpcoc77u1czc8w)];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,infradead.org,linux-foundation.org,linux.dev,google.com,suse.com,linux.alibaba.com,arm.com,gourry.net,nvidia.com,cmpxchg.org,tencent.com,kvack.org,vger.kernel.org,gmail.com,vivo.com,lists.ozlabs.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Rspamd-Queue-Id: 294947FC27
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On Tue 04-08-26 13:09:46, Zi Yan wrote:
> On Tue Aug 4, 2026 at 1:04 PM EDT, Jan Kara wrote:
> > On Tue 04-08-26 11:54:41, Zi Yan wrote:
> >> On Tue Aug 4, 2026 at 5:32 AM EDT, Jan Kara wrote:
> >> > On Mon 03-08-26 12:56:36, Zi Yan wrote:
> >> >> On Mon Aug 3, 2026 at 5:54 AM EDT, Jan Kara wrote:
> >> >> > On Fri 31-07-26 22:13:30, Zi Yan wrote:
> >> >> >> erofs needs to traverse readahead folios in reverse order to achieve
> >> >> >> maximum performance by
> >> >> >> 1. reading all folios from readahead_folio();
> >> >> >> 2. storing the prior folio pointer in folio->private;
> >> >> >> 3. traverse from the last folio to the first one.
> >> >> >> 
> >> >> >> Add readahead_folio_reverse() to achieve the same function without using
> >> >> >> folio->private.
> >> >> >> 
> >> >> >> It prepares for a future commit that replaces PG_private checks with
> >> >> >> !folio->private checks. After switching the checks, erofs's use of
> >> >> >> folio->private without bumping folio refcount can cause unexpected
> >> >> >> outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() becomes
> >> >> >> reachable.
> >> 
> >> <snip>
> >> 
> >> >> 
> >> >> The below is what I come up with. I did not add a bool to
> >> >> readahead_control, since I think that is the decision of caller of
> >> >> __readahead_advance(). But let me know if you disagree.
> >> >
> >> > The reason why I wanted bool in readahead_control is that if some code
> >> > ends up mixing readahead_folio() with readahead_folio_last() things will
> >> > get confused (because __readahead_advance() really wants to skip the batch
> >> > returned from the *previous* call to readahead_folio[_last]()). With the
> >> > bool in rac, even mixed use will properly advance the state of the
> >> > readahead_control. I don't think mixed use is very realistic (at this
> >> > point at least) so I'm ok with leaving that for later if you don't like it.
> >> 
> >> Got it. I am trying to figure out your mental model of how the mix of
> >> readahead_folio() and readahead_folio_last() works with the bool inside
> >> ractl. By looking at readahead_folio_last() code, it is almost the same
> >> as readahead_folio() with __readahead_folio() inlined
> >> (__readahead_folio() is only used by readahead_folio(), so the inline
> >> can happen without any issue). As a result, we can get rid of
> >> readahead_folio_last(), add set_readahead_direction() to set the
> >> embedded bool read_from_head, and use readahead_folio() only. This
> >> removes redundant code in readahead_folio_last(). One thing I am not
> >> certain is whether we want to
> >> 
> >> 1. use set_readahead_direction() explicit and warn readahead_folio() if
> >> read_from_head is not initialized, or
> >> 
> >> 2. set read_from_head to true by default, so that only erofs needs to
> >> call set_readahead_direction() to change read_from_head.
> >> 
> >> The former is less confusing but changes how readahead_folio() works;
> >> the latter is simpler but implicit read_from_head state might confuse
> >> people at some point.
> >
> > My idea was: readahead_folio() will call __readahead_advance() and then set
> > rac->forward = true. readahead_folio_last() will call __readahead_advance()
> > and set rac->forward = false. __readahead_advance() advances from beginning
> > / end based on rac->_forward value.
> 
> Got it. I can do that. Just to be clear, it should be that
> readahead_folio() first sets rac->forward = true, then calls
> __readahead_advance(), since __readahead_advance() advances based on
> rac->forward, right? readahead_folio_last() as well.

No. I wrote "and then set" which means after and that is what I really
wanted to say. You still don't seem to be understanding the logic of handling
the _batch_count. _batch_count is the length of the returned batch.
__readahead_advance() updates _index and _nr_pages to remove the folios
returned in the last batch from the range. So _forward needs to contain
whether the last returned batch was taken from the beginning or the end of
the range and __readahead_advance() uses it to update current range
accordingly (before we go and return the next batch). We cannot clobber
_forward before calling __readahead_advance(). I hope things are clearer
now.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

