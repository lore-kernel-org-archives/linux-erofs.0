Return-Path: <linux-erofs+bounces-2099-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2B14CA5FA2
	for <linux-erofs@archiver.kernel.org>; Tue, 20 Jan 2026 16:07:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dwXKl1FyVz2x9M;
	Wed, 21 Jan 2026 03:07:55 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=202.12.124.143
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1768925275;
	cv=none; b=Q85hSiEy02ZqI3+Si9y/irVdwUR/ey53Phgg1JnryiVqPu2vZnaphuX1Bu1wBmjZHOWVtOaLgr4XbWmpKWLkbmU14+ikPo0cDRJeMAOWklxvl+INqDIFIRPCE5jHI8xODgL6OYfeIPVbQENWEWe/ls5WW8wgSnOmdeapCwHbUpsidPbSA7DthfjJGtmnDbvDaBAbZCQJ/HXhiHh5UB3wRTJpNLReepG2yseBMUgLWcxOjJFzAtIXVLmXLsis0XoDyuTrnrYNyaOTqVVAMc4qJqZmnDNCuq0SpZDif21J6RXuwoCGLEWsU/3uS+omR3snvGLBPv7b4Z3fR8QBS0VGHg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1768925275; c=relaxed/relaxed;
	bh=KfkVnVcFie+8lJSMwr+BM1cQg1+WZ1F7itYYKxiYDxA=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=hR+44W098cDdI+qyNU8dqu2sPr0JkuWYsC0j/9I0pLZNly7eltVWaYjaQqNyRwj/px4X9UTzNH8A4Plg+BVRy+w/SG1Dbc5+Xl9A0GR+X6PJc1vrFjzrL0bTSqNaSwjxTnAfwt0QKi+EMFvTAHQjF2blylEonFU1jHUTyWVd10qxyq+r7x3qowlj/sMfv4QS9GfFyu5aedEwYssS+apmXpye6EeAemcEebQcvN3D1BthTy7ruS8K1oeD+JhRw1XGpO68kFVBhYYRhQrM3qkZADWPWfJ0HcHwor8aDSJOobqmqkKiy8Ap33E2whKmeeGPTrB9UqOSLrPXhsTMo+EwaQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=arndb.de; dkim=pass (2048-bit key; unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=kR9gOAj5; dkim=pass (2048-bit key; unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=hcwcLU9t; dkim-atps=neutral; spf=pass (client-ip=202.12.124.143; helo=flow-b8-smtp.messagingengine.com; envelope-from=arnd@arndb.de; receiver=lists.ozlabs.org) smtp.mailfrom=arndb.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=kR9gOAj5;
	dkim=pass (2048-bit key; unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=hcwcLU9t;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=arndb.de (client-ip=202.12.124.143; helo=flow-b8-smtp.messagingengine.com; envelope-from=arnd@arndb.de; receiver=lists.ozlabs.org)
X-Greylist: delayed 406 seconds by postgrey-1.37 at boromir; Wed, 21 Jan 2026 03:07:50 AEDT
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dwXKf5Br2z2x99
	for <linux-erofs@lists.ozlabs.org>; Wed, 21 Jan 2026 03:07:50 +1100 (AEDT)
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id A7CFA13012B5;
	Tue, 20 Jan 2026 11:00:57 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Tue, 20 Jan 2026 11:00:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1768924857;
	 x=1768932057; bh=KfkVnVcFie+8lJSMwr+BM1cQg1+WZ1F7itYYKxiYDxA=; b=
	kR9gOAj5pXn1HlvyIPf1Dn2UnaJAS+jRzIAsaR2XzWmwVU3duRgbE0mh5JHntjXj
	cuWYepTHKUWzhsOhC73++QR5yvZK4X1S2AwaIcjIrwElOhOnB7qBma9Rt3sk4wEp
	WApUxciyhayGX/RZcK8fKFz6xIdI+xP0DrR1lTAATkjc8XoS7YDkMHYuYZCNVtBX
	4oGFoRnhTrXR+Av/H+nXr31W99ztPY8wV3R2x29p9i/J68icSSg69RfuDb4y8YAC
	s4LhKb2VHYYXAgITpUrU4ktCyPGwkOI9lIgNBoXcky3A3mVVfmLH/JHxew6hI9Hi
	veL08yMhuZP0sXK/DL5Ezw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768924857; x=
	1768932057; bh=KfkVnVcFie+8lJSMwr+BM1cQg1+WZ1F7itYYKxiYDxA=; b=h
	cwcLU9t2Na5NvYNY+HqrNgOlIOAEx2zdTmluSgjajfn4eJ5F+JIB4BRW8ErmbMJb
	5ljggxqqdQPdg2SZtb56c1NTdnpBu5weRDSXaiQR+Mg0Ub9iThiAQ79EUDX9yysa
	If4/Knasx1iPLLZBRyvYpz8FhOYnlESn3fgeQPRrN8KMwKv6jSRpu0DLxO2sSNsb
	R4TQnDC+MhnR+ow7ZS/sYxRoTgI4V6asIPb1zuVNFs2Fc8BB9RtG2146jooAzX5l
	vcbjXpebeDkjFdxXkF3/V9TJ8Omw44E5cSge6Qts1idwHBYUlshPhSE1PbPF8M3M
	EM/yfREYAwG76Llyugm5Q==
X-ME-Sender: <xms:tqZvabeGsRgVUmYbJYubbEJsMblBOKkMPVUcZJSAcArtFN7R0_JmeQ>
    <xme:tqZvacCZ4cB2mdxuaWLwjQTUSZDxD3Bf1wqfkWuap9G_bNa-8cI9R9Kjk_UIAoevp
    8e2nWPX3vkW-eL_zNn3-aozty1UyyBCIwgt3SJui6DtRU08gGv2zDs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugedtkeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepgeefpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopehjrghnihdrnhhikhhulhgrsehlihhnuhigrdhinhhtvghlrdgtoh
    hmpdhrtghpthhtohepjhhoohhnrghsrdhlrghhthhinhgvnheslhhinhhugidrihhnthgv
    lhdrtghomhdprhgtphhtthhopehmrggrrhhtvghnrdhlrghnkhhhohhrshhtsehlihhnuh
    igrdhinhhtvghlrdgtohhmpdhrtghpthhtohepghhrvghgkhhhsehlihhnuhigfhhouhhn
    uggrthhiohhnrdhorhhgpdhrtghpthhtohepughrihdquggvvhgvlheslhhishhtshdrfh
    hrvggvuggvshhkthhophdrohhrghdprhgtphhtthhopehinhhtvghlqdhgfhigsehlihhs
    thhsrdhfrhgvvgguvghskhhtohhprdhorhhgpdhrtghpthhtohepnhhtfhhsfeeslhhish
    htshdrlhhinhhugidruggvvhdprhgtphhtthhopehnvhguihhmmheslhhishhtshdrlhhi
    nhhugidruggvvhdprhgtphhtthhopeguvghvvghlsehlihhsthhsrdhorhgrnhhgvghfsh
    drohhrgh
X-ME-Proxy: <xmx:tqZvaWR4-8YE2KZu1y5jvyNQljKoCBlYcV9QkUPtn5Ni7W-NSZMsUw>
    <xmx:tqZvaRktxaBWwwSZcFROAg2TG6_nap3Qro5Wk-tlRgwqau7F5lM2lA>
    <xmx:tqZvaZLjBCOSgCLQJimLJKR8KCf21qGLd9xPnpeFgrHRnOQFa7r4YA>
    <xmx:tqZvacVW_XYjP20S7nkpndFaafpNrDdhIyeeUuIH4hGwRfJO4DQR5A>
    <xmx:uaZvadqcdmsUnvEM9LNX4jzRraMdQCDjpzpx0jFAVDSf99K8t-JGJM_0>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id A67DD70006A; Tue, 20 Jan 2026 11:00:54 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
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
X-ThreadId: AWSx1lsrOtaB
Date: Tue, 20 Jan 2026 17:00:28 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Jason Gunthorpe" <jgg@nvidia.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
 "Jarkko Sakkinen" <jarkko@kernel.org>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Dan Williams" <dan.j.williams@intel.com>,
 "Vishal Verma" <vishal.l.verma@intel.com>,
 "Dave Jiang" <dave.jiang@intel.com>,
 "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>,
 "Maxime Ripard" <mripard@kernel.org>,
 "Thomas Zimmermann" <tzimmermann@suse.de>,
 "Dave Airlie" <airlied@gmail.com>, "Simona Vetter" <simona@ffwll.ch>,
 "Jani Nikula" <jani.nikula@linux.intel.com>,
 "Joonas Lahtinen" <joonas.lahtinen@linux.intel.com>,
 "Rodrigo Vivi" <rodrigo.vivi@intel.com>,
 "Tvrtko Ursulin" <tursulin@ursulin.net>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 "Huang Rui" <ray.huang@amd.com>, "Matthew Auld" <matthew.auld@intel.com>,
 "Matthew Brost" <matthew.brost@intel.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>,
 "Benjamin LaHaise" <bcrl@kvack.org>, "Gao Xiang" <xiang@kernel.org>,
 "Chao Yu" <chao@kernel.org>, "Yue Hu" <zbestahu@gmail.com>,
 "Jeffle Xu" <jefflexu@linux.alibaba.com>,
 "Sandeep Dhavale" <dhavale@google.com>,
 "Hongbo Li" <lihongbo22@huawei.com>, "Chunhai Guo" <guochunhai@vivo.com>,
 "Theodore Ts'o" <tytso@mit.edu>,
 "Andreas Dilger" <adilger.kernel@dilger.ca>,
 "Muchun Song" <muchun.song@linux.dev>,
 "Oscar Salvador" <osalvador@suse.de>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Konstantin Komarov" <almaz.alexandrovich@paragon-software.com>,
 "Mike Marshall" <hubcap@omnibond.com>,
 "Martin Brandenburg" <martin@omnibond.com>,
 "Tony Luck" <tony.luck@intel.com>,
 "Reinette Chatre" <reinette.chatre@intel.com>,
 "Dave Martin" <Dave.Martin@arm.com>, "James Morse" <james.morse@arm.com>,
 "Babu Moger" <babu.moger@amd.com>, "Carlos Maiolino" <cem@kernel.org>,
 "Damien Le Moal" <dlemoal@kernel.org>,
 "Naohiro Aota" <naohiro.aota@wdc.com>,
 "Johannes Thumshirn" <jth@kernel.org>,
 "Matthew Wilcox" <willy@infradead.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Vlastimil Babka" <vbabka@suse.cz>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Hugh Dickins" <hughd@google.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Zi Yan" <ziy@nvidia.com>,
 "Nico Pache" <npache@redhat.com>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>,
 "Lance Yang" <lance.yang@linux.dev>, "Jann Horn" <jannh@google.com>,
 "Pedro Falcato" <pfalcato@suse.de>,
 "David Howells" <dhowells@redhat.com>,
 "Paul Moore" <paul@paul-moore.com>, "James Morris" <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>,
 "Yury Norov" <yury.norov@gmail.com>,
 "Rasmus Villemoes" <linux@rasmusvillemoes.dk>, linux-sgx@vger.kernel.org,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-aio@kvack.org, linux-erofs@lists.ozlabs.org,
 linux-ext4@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev,
 devel@lists.orangefs.org, linux-xfs@vger.kernel.org,
 keyrings@vger.kernel.org, linux-security-module@vger.kernel.org
Message-Id: <1617ac60-6261-483d-aeb5-13aba5f477af@app.fastmail.com>
In-Reply-To: <488a0fd8-5d64-4907-873b-60cefee96979@lucifer.local>
References: <cover.1768857200.git.lorenzo.stoakes@oracle.com>
 <baac396f309264c6b3ff30465dba0fbd63f8479c.1768857200.git.lorenzo.stoakes@oracle.com>
 <20260119231403.GS1134360@nvidia.com>
 <36abc616-471b-4c7b-82f5-db87f324d708@lucifer.local>
 <20260120133619.GZ1134360@nvidia.com>
 <488a0fd8-5d64-4907-873b-60cefee96979@lucifer.local>
Subject: Re: [PATCH RESEND 09/12] mm: make vm_area_desc utilise vma_flags_t only
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, Jan 20, 2026, at 16:10, Lorenzo Stoakes wrote:
> On Tue, Jan 20, 2026 at 09:36:19AM -0400, Jason Gunthorpe wrote:
>
> I am not sure about this 'idiomatic kernel style' thing either, it feels rather
> conjured. Yes you wouldn't ordinarily pass something larger than a register size
> by-value, but here the intent is for it to be inlined anyway right?
>
> It strikes me that the key optimisation here is the inlining, now if the issue
> is that ye olde compiler might choose not to inline very small functions (seems
> unlikely) we could always throw in an __always_inline?

I can think of three specific things going wrong with structures passed
by value:

- functions that cannot be inlined are bound by the ELF ABI, and
  several of them require structs to be passed on the stack regardless
  of the size. Most of the popular architectures seem fine here, but
  mips and powerpc look like they are affected.

- The larger the struct is, the more architectures are affected.
  Parts of the amdgpu driver and the bcachefs file system ran into this
  with 64-bit structures passed by value on 32-bit architectures
  causing horrible codegen even with inlining. I think it's
  usually fine up to a single register size.

- clang's inlining algorithm works the other way round from gcc's:
  inlining into the root caller first and sometimes leaving tiny
  leaf function out of line unless you add __always_inline.

      Arnd

