Return-Path: <linux-erofs+bounces-4146-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FAD5C55174
	for <linux-erofs@archiver.kernel.org>; Wed,  5 Aug 2026 16:10:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hFb3c63qXz2yYf;
	Thu, 06 Aug 2026 02:10:20 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785946220;
	cv=none; b=GMTRMx7uolAyE3DliyyyLgVXpMELBDRrLC99mK4y6A0+FEPyNrt1XpmUe2y8eBMkykW7OLzNDsjSzZRhQGLVAUFjcf2Zvrl59OzTETE86N6/m/3sW9fwyWYLmbb5JDqjNaBa6QUklxdRHjLicJgsAx5PNFLyVGgi6o1UVG0D3eR4Hioewk/FGzJ6Tg6zM0NK0PvN4UXYb19/7E+RjjwSnnSFvQmyfi3TW5d1Bk0jpnA+IRyYuvmZOi6eQodbLHEdgBwBQ1HXye4W326J9yl+O9+Y04dYLz7TFGaToJ+cOlK/PpzQ+AKVMAgMP8Od7WPlMnojFTTWXisZzDzCmWr5cA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785946220; c=relaxed/relaxed;
	bh=HskJbUE1aNqCuNXRMEy5hyx9jsFoyh9wIHexTfa7E5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cN54J48lKZWai/DsjB7XY3zSQrjFdXgK4RKlAfnKqA3AllbWNcr4oFhQz9pQTpZADZzB7Aw74SNDvbo7b/zeBUW1lWp4K+A4pnTfxzZSgLRLn9H6WwemntT+mqvSXYR4SZ643DLO6d5T2ZQ0JOE5u1xWepoDHSBP+lvFJcgZrNREmmsJ7eCgSXb5YoT1Qa95ZCH3cFovvChblyKOllNj/Qadm9JizDEhLz+s3XNuPi3XNbesAbnZ/FqVqEbcYf+zc5yeuq5XeeNXf1/OaqtzaYxEjLTOjlmD1fNnfYCQjK/Paa9M5RKdZUqV6I2x4XKAL/2n0v82uBSRSrJcXTaI0A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz; dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=h5XQ1L1X; dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=EWe59/xI; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Xli57Era; dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5tcAQy0S; dkim-atps=neutral; spf=pass (client-ip=195.135.223.130; helo=smtp-out1.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org) smtp.mailfrom=suse.cz
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=h5XQ1L1X;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=EWe59/xI;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Xli57Era;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5tcAQy0S;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=suse.cz (client-ip=195.135.223.130; helo=smtp-out1.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hFb3b12lHz2ySW
	for <linux-erofs@lists.ozlabs.org>; Thu, 06 Aug 2026 02:10:18 +1000 (AEST)
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AC89B7EFC3;
	Wed,  5 Aug 2026 16:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785946209; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HskJbUE1aNqCuNXRMEy5hyx9jsFoyh9wIHexTfa7E5w=;
	b=h5XQ1L1XESwBu4lX1BLS0KL8+Qjut/rS9S5KsnvS0BH/pXQUfsfurL8d0Qss8ajH+XLU1P
	3vYz46qTE2pBShledGfdEuNK/ec4MRZJR7Rfa6xD8OayfWt3I28RL/mpk7hnNcD3hBmj/C
	rW+kd2jjx46LtCYmqR8l+cMAX9ZwyvM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785946209;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HskJbUE1aNqCuNXRMEy5hyx9jsFoyh9wIHexTfa7E5w=;
	b=EWe59/xIDiP5vTKrNSNXwLfnMgku2cQdCaXx4qm5Nik5EYSY4GCdLqiTDtBX+4+8ddrWOm
	Agh+0USaxFyE3nAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785946205; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HskJbUE1aNqCuNXRMEy5hyx9jsFoyh9wIHexTfa7E5w=;
	b=Xli57Erab/Nk3CLdJjFnHdG6ttlcEODmtSCxIx/RTtO2VnPgP4fDCbbUdQom+mgzPtmYwm
	VT5eZGsdFQG7Ak4wKU5OceaAW3HgN+ScTaksqBILvtaab8GtVHGeYxjE8MN19dXw0Kuxbx
	3GKIitNOX7OOBuYbwc1F8JRCmUoRRYA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785946205;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HskJbUE1aNqCuNXRMEy5hyx9jsFoyh9wIHexTfa7E5w=;
	b=5tcAQy0S/zzzaTqeZqq3rXnGjW2LHS4wwXQqWwHF6UQE5kfSV+RNg3zOCC2O6Ov0qvLYc9
	lfuT2s/I/hb2bYBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9C44B779C2;
	Wed,  5 Aug 2026 16:10:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ag0eJl1gc2pxUQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 05 Aug 2026 16:10:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4534BA13B1; Wed, 05 Aug 2026 18:10:05 +0200 (CEST)
Date: Wed, 5 Aug 2026 18:10:05 +0200
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
Message-ID: <44w5y7ehefqmo4jkvxjm7abfm7bmqh2p2uucfu2cqnizmgzvmx@lk3xamijvglg>
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-7-142c97ba3562@nvidia.com>
 <332rknj4vo3cfhvfhhlf6pvg37s3lbrnzbbnv4swa6gctsiu6a@ndotgokvnglc>
 <DKFGTVA0XD01.OZYNYUOU9FTX@nvidia.com>
 <huzyeqj6a57nbcqc23v6f6rdhkob5552fcwy4mlrsagycqi4rz@ggsapkumc2gq>
 <DKGA508ERSYM.26RBD4HYM1SL8@nvidia.com>
 <2evaxdu6cobpnzzer3y7fsrqvmtmhj7gm3e5buebdaw564igx6@7bs5enipxnpx>
 <DKGBQHP25RE0.3NKUQSDULAQSX@nvidia.com>
 <ivg5x7hjo4tmpd34i6wrd5cp2v56c3vorwru7h6kqxnqlcpte7@lvd7xa4ncwxu>
 <DKGZEK0AQP6R.1RTQEY44OQD65@nvidia.com>
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
In-Reply-To: <DKGZEK0AQP6R.1RTQEY44OQD65@nvidia.com>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[37];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,infradead.org,linux-foundation.org,linux.dev,google.com,suse.com,linux.alibaba.com,arm.com,gourry.net,nvidia.com,cmpxchg.org,tencent.com,kvack.org,vger.kernel.org,gmail.com,vivo.com,lists.ozlabs.org];
	R_RATELIMIT(0.00)[to_ip_from(RLc5chj8mdhigtayhgqted7wkp)];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]

On Wed 05-08-26 07:42:37, Zi Yan wrote:
> On Wed Aug 5, 2026 at 5:25 AM EDT, Jan Kara wrote:
> > On Tue 04-08-26 13:09:46, Zi Yan wrote:
> >> On Tue Aug 4, 2026 at 1:04 PM EDT, Jan Kara wrote:
> >> > On Tue 04-08-26 11:54:41, Zi Yan wrote:
> >> >> On Tue Aug 4, 2026 at 5:32 AM EDT, Jan Kara wrote:
> >> >> > On Mon 03-08-26 12:56:36, Zi Yan wrote:
> >> >> >> On Mon Aug 3, 2026 at 5:54 AM EDT, Jan Kara wrote:
> >> >> >> > On Fri 31-07-26 22:13:30, Zi Yan wrote:
> >> >> >> >> erofs needs to traverse readahead folios in reverse order to achieve
> >> >> >> >> maximum performance by
> >> >> >> >> 1. reading all folios from readahead_folio();
> >> >> >> >> 2. storing the prior folio pointer in folio->private;
> >> >> >> >> 3. traverse from the last folio to the first one.
> >> >> >> >> 
> >> >> >> >> Add readahead_folio_reverse() to achieve the same function without using
> >> >> >> >> folio->private.
> >> >> >> >> 
> >> >> >> >> It prepares for a future commit that replaces PG_private checks with
> >> >> >> >> !folio->private checks. After switching the checks, erofs's use of
> >> >> >> >> folio->private without bumping folio refcount can cause unexpected
> >> >> >> >> outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() becomes
> >> >> >> >> reachable.
> >> >> 
> >> >> <snip>
> >> >> 
> >> >> >> 
> >> >> >> The below is what I come up with. I did not add a bool to
> >> >> >> readahead_control, since I think that is the decision of caller of
> >> >> >> __readahead_advance(). But let me know if you disagree.
> >> >> >
> >> >> > The reason why I wanted bool in readahead_control is that if some code
> >> >> > ends up mixing readahead_folio() with readahead_folio_last() things will
> >> >> > get confused (because __readahead_advance() really wants to skip the batch
> >> >> > returned from the *previous* call to readahead_folio[_last]()). With the
> >> >> > bool in rac, even mixed use will properly advance the state of the
> >> >> > readahead_control. I don't think mixed use is very realistic (at this
> >> >> > point at least) so I'm ok with leaving that for later if you don't like it.
> >> >> 
> >> >> Got it. I am trying to figure out your mental model of how the mix of
> >> >> readahead_folio() and readahead_folio_last() works with the bool inside
> >> >> ractl. By looking at readahead_folio_last() code, it is almost the same
> >> >> as readahead_folio() with __readahead_folio() inlined
> >> >> (__readahead_folio() is only used by readahead_folio(), so the inline
> >> >> can happen without any issue). As a result, we can get rid of
> >> >> readahead_folio_last(), add set_readahead_direction() to set the
> >> >> embedded bool read_from_head, and use readahead_folio() only. This
> >> >> removes redundant code in readahead_folio_last(). One thing I am not
> >> >> certain is whether we want to
> >> >> 
> >> >> 1. use set_readahead_direction() explicit and warn readahead_folio() if
> >> >> read_from_head is not initialized, or
> >> >> 
> >> >> 2. set read_from_head to true by default, so that only erofs needs to
> >> >> call set_readahead_direction() to change read_from_head.
> >> >> 
> >> >> The former is less confusing but changes how readahead_folio() works;
> >> >> the latter is simpler but implicit read_from_head state might confuse
> >> >> people at some point.
> >> >
> >> > My idea was: readahead_folio() will call __readahead_advance() and then set
> >> > rac->forward = true. readahead_folio_last() will call __readahead_advance()
> >> > and set rac->forward = false. __readahead_advance() advances from beginning
> >> > / end based on rac->_forward value.
> >> 
> >> Got it. I can do that. Just to be clear, it should be that
> >> readahead_folio() first sets rac->forward = true, then calls
> >> __readahead_advance(), since __readahead_advance() advances based on
> >> rac->forward, right? readahead_folio_last() as well.
> >
> > No. I wrote "and then set" which means after and that is what I really
> > wanted to say. You still don't seem to be understanding the logic of handling
> > the _batch_count. _batch_count is the length of the returned batch.
> > __readahead_advance() updates _index and _nr_pages to remove the folios
> > returned in the last batch from the range. So _forward needs to contain
> > whether the last returned batch was taken from the beginning or the end of
> > the range and __readahead_advance() uses it to update current range
> > accordingly (before we go and return the next batch). We cannot clobber
> > _forward before calling __readahead_advance(). I hope things are clearer
> > now.
> 
> Got it. Sorry I made some assumption instead of asking my question, so I
> misinterpret your words. My question is who sets the initial value of
> _forward? So that __readahead_advance() can update _index and _nr_pages
> correctly at the first time __readahead_folio() is called?

This first time __readahead_folio() is called _batch_count is 0 so the
value of _forward doesn't really matter... But DEFINE_READAHEAD() will
implicitly initialize it to 'false' which is fine.

> __readahead_folio() does:
> 
> 1. update _nr_pages and _index,
> 2. return NULL if _nr_pages is 0 and set _batch_count to 0,
> 3. return folio using xa_load and set _batch_count to folio_nr_pages().
> 
> after the change:
> 
> 1. call __readahead_advance() to update _index, _nr_pages, and
> _batch_count based on _forward,
> 2. update _forward to true, since it is __readahead_folio()
> 3. return NULL or folio based on _nr_pages.
> 
> Then the first time __readahead_folio() is called, who sets _forward to
> make 1 work correctly?

See above...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

