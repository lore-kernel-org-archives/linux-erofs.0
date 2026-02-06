Return-Path: <linux-erofs+bounces-2272-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6535FEE6B43
	for <linux-erofs@archiver.kernel.org>; Fri,  6 Feb 2026 17:36:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4f71TZ366pz2xqk;
	Sat, 07 Feb 2026 04:36:02 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1770399362;
	cv=none; b=Th/yVxzVMM2NIX3UOFsxiN0oSnurqMOBhotm/1Px5WVcEVIoFv4SVxzl0DlLt3zit/Vb9mVum6B98o0Tb6mCEvQ249/dN/uAJEKz7Sb+UKnF5Abro/yyG76mshOcerDi20C5Sx5gsQU064ywzuDcCWA6NcbmCDuQXAt41LCGY7G0QE+anNe+ch0PP1+sD3yXM8JC9TPkAokyKxKVYrLIuUUNCepAS6rIlAPj++bcIuZv7j2TYgZt1d7wiz7ZaUTdr17ltSVL0z8BTrwmCTtFKLZDXDrBmqy7UZCoWipvinkniqER01G/5ZPK1zfoVHmiqt29o32qj/TG9zRymH5CbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1770399362; c=relaxed/relaxed;
	bh=VJUA43BGvzwxesp6EkqhFxBoO3OZeDjhsPe0maEveNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AwFDdzcjfz8nA45n35eEYBXBZhXbr2oLrQAJDgu+mvEL8ur+77pDJmvJFQKftsXvTkJFBBTAWG5shVLRuxDRBtwEWV7SFaZu44P9jQ+ooX+szmHf3nYgvRwdHtfMcIB4IfOYkphX4qjf6Dt9GHT5b3PbB+y6f0Por9V61uc4qz06wt9S6xsQS2rcFd00q3P4VCrqSUKdGfyhCt96PYmcbpBvLn/ChWYUxgMOky1RE0eJ4+LLlPsDBMmRuvA0Ogp37PqsjjxoxP/9AzFY1rhIemGDlS2xijf8pwkblK4Z4ucW9P3cvEvp0fDytkSUewkajTioT++seHw36zb/J4RPOA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=suse.de; dkim=pass (1024-bit key; unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=1shQewP2; dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=JHUa9amE; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=U5YPWMVu; dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9GrzkJr3; dkim-atps=neutral; spf=pass (client-ip=195.135.223.130; helo=smtp-out1.suse.de; envelope-from=pfalcato@suse.de; receiver=lists.ozlabs.org) smtp.mailfrom=suse.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=1shQewP2;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=JHUa9amE;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=U5YPWMVu;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9GrzkJr3;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=suse.de (client-ip=195.135.223.130; helo=smtp-out1.suse.de; envelope-from=pfalcato@suse.de; receiver=lists.ozlabs.org)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4f71TY1GKpz2xpg
	for <linux-erofs@lists.ozlabs.org>; Sat, 07 Feb 2026 04:36:00 +1100 (AEDT)
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5F7903E6DD;
	Fri,  6 Feb 2026 17:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770399357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VJUA43BGvzwxesp6EkqhFxBoO3OZeDjhsPe0maEveNQ=;
	b=1shQewP2LmWP3MFSMYtX8w+6zZn7aKBAlTFRTxiOvTX7R2E4CohJmoLwXsU1vTDbMz0iaS
	R2jXA7lFXktcPsgpxf12asWwe05gSqhUXi2iIsQ4/rI0b42DF2zGDL5ZS3bP0iKXY3o8fL
	Y0jvZhjo5dSUxzqwtgF16yf6fyBAmG8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770399357;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VJUA43BGvzwxesp6EkqhFxBoO3OZeDjhsPe0maEveNQ=;
	b=JHUa9amEudPDM/4AySdJYeBKvZjF3HgEUfc5fY+W7hCNTZniiVkpoa0tvklosfEcBmNFGg
	KejMN7mwEDAwKlAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770399356; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VJUA43BGvzwxesp6EkqhFxBoO3OZeDjhsPe0maEveNQ=;
	b=U5YPWMVuexsLJCN9qapqSzJxhLnp84h/q7W92XbfAQUBhKRC87Wf1KYyxW+DhTX1iRGVH0
	GHDnk8h5kAzOs/VSDW/GoZZCY7O++wzHGjG4gE148WnPmHOtLHOjuxzJQXQk+HoAKrhM4I
	0pr/H/TJ/u6VuF6wpAnJn14EI8JyEUM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770399356;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VJUA43BGvzwxesp6EkqhFxBoO3OZeDjhsPe0maEveNQ=;
	b=9GrzkJr3/8NpPU6pAbKRUHmvzT482Kxxzhuv98BaxytL/Sy/DuDnzluD397tP3YK7WyJ5w
	cQBGHJgBEnX0wYAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F2D5E3EA63;
	Fri,  6 Feb 2026 17:35:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HOILOHYmhmm0CAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 06 Feb 2026 17:35:50 +0000
Date: Fri, 6 Feb 2026 17:35:49 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, Christian Koenig <christian.koenig@amd.com>, 
	Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
	Matthew Brost <matthew.brost@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Benjamin LaHaise <bcrl@kvack.org>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, 
	Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Jann Horn <jannh@google.com>, 
	David Howells <dhowells@redhat.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>, 
	Yury Norov <yury.norov@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-erofs@lists.ozlabs.org, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	devel@lists.orangefs.org, linux-xfs@vger.kernel.org, keyrings@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v2 05/13] mm: add basic VMA flag operation helper
 functions
Message-ID: <vrbggto75ugvpa5wtugmayr7yops6cnvygit42f2md646y6qnx@3vzc7taleijw>
References: <cover.1769097829.git.lorenzo.stoakes@oracle.com>
 <885d4897d67a6a57c0b07fa182a7055ad752df11.1769097829.git.lorenzo.stoakes@oracle.com>
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
In-Reply-To: <885d4897d67a6a57c0b07fa182a7055ad752df11.1769097829.git.lorenzo.stoakes@oracle.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,kernel.org,linux.intel.com,redhat.com,alien8.de,zytor.com,arndb.de,linuxfoundation.org,intel.com,suse.de,gmail.com,ffwll.ch,ursulin.net,amd.com,zeniv.linux.org.uk,suse.cz,kvack.org,linux.alibaba.com,google.com,huawei.com,vivo.com,mit.edu,dilger.ca,linux.dev,paragon-software.com,omnibond.com,arm.com,wdc.com,infradead.org,oracle.com,suse.com,nvidia.com,paul-moore.com,namei.org,hallyn.com,rasmusvillemoes.dk,vger.kernel.org,lists.linux.dev,lists.freedesktop.org,lists.ozlabs.org,lists.orangefs.org];
	R_RATELIMIT(0.00)[to_ip_from(RLkbg1q7eokc4zfw9e5dipwr46)];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCPT_COUNT_GT_50(0.00)[93];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oracle.com:email,imap1.dmz-prg2.suse.org:helo,suse.de:email]

On Thu, Jan 22, 2026 at 04:06:14PM +0000, Lorenzo Stoakes wrote:
> Now we have the mk_vma_flags() macro helper which permits easy
> specification of any number of VMA flags, add helper functions which
> operate with vma_flags_t parameters.
> 
> This patch provides vma_flags_test[_mask](), vma_flags_set[_mask]() and
> vma_flags_clear[_mask]() respectively testing, setting and clearing flags
> with the _mask variants accepting vma_flag_t parameters, and the non-mask
> variants implemented as macros which accept a list of flags.
> 
> This allows us to trivially test/set/clear aggregate VMA flag values as
> necessary, for instance:
> 
> 	if (vma_flags_test(&flags, VMA_READ_BIT, VMA_WRITE_BIT))
> 		goto readwrite;

I'm not a huge fan of the _test ambiguity here, but more words makes it uglier :/
I think I can live with it though.

> 
> 	vma_flags_set(&flags, VMA_READ_BIT, VMA_WRITE_BIT);
> 
> 	vma_flags_clear(&flags, VMA_READ_BIT, VMA_WRITE_BIT);
> 

The variadic-ness here is very nice though.

> We also add a function for testing that ALL flags are set for convenience,
> e.g.:
> 
> 	if (vma_flags_test_all(&flags, VMA_READ_BIT, VMA_MAYREAD_BIT)) {
> 		/* Both READ and MAYREAD flags set */
> 		...
> 	}
> 
> The compiler generates optimal assembly for each such that they behave as
> if the caller were setting the bitmap flags manually.
> 
> This is important for e.g. drivers which manipulate flag values rather than
> a VMA's specific flag values.
> 
> We also add helpers for testing, setting and clearing flags for VMA's and
> VMA descriptors to reduce boilerplate.
> 
> Also add the EMPTY_VMA_FLAGS define to aid initialisation of empty flags.
> 
> Finally, update the userland VMA tests to add the helpers there so they can
> be utilised as part of userland testing.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

