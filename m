Return-Path: <linux-erofs+bounces-3007-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE52D109C057
	for <linux-erofs@archiver.kernel.org>; Wed, 25 Mar 2026 18:28:04 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fgwPv1H1Yz2yVB;
	Thu, 26 Mar 2026 05:28:03 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774463283;
	cv=none; b=izVYXQnh+VMI2Ze/bmMKMtziFUgCJhxkIRx23IoLB1N0ZWjtzae0kCX66+oCNSgITB6UdzkpFcxKG0wlPpsXLPJeKjbx6uEH9oS9HxC+tIS8cbReH/7lhnTJsvgb7rE5Va72G9vnlSvNR6TEvsRS8hf/7UYud5yHekoHxxp3aTJVA5qZ5FytQHWb3zrcK5RE2MXYYYaUog6F4zEOjBoK/VZHkywPte2zUTwWlGkjbFzxkyL1C2A6VagqisF+QGxKI/VnwNAK7T+hDWlV6KLrKt8kX1kZIcZE6jLfujj2CKxVPUeiDrRy1JCWbUISAZu3eSLuSal47FyZZHnfFexwUg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774463283; c=relaxed/relaxed;
	bh=hpBw4RUY8JjxM8HYPYakB9zRBXoDbpL5Vame81dIANQ=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ii+htZMpMNYYxiN4gr78HaCe1Gm923PkJy2P+QxQ+T/4142f0hGDzT1rTDudKy4c/OHhk+K86QCmdtnike7mDcd668lalsrAhDmqT8KNC8bckT2Z/ikaODYPzUlSxUW7wINI6yWQ/XnP49xyLTNuiuzYB9hMqoqJuz4viM2gGfSr8B8jMWgNT8pNvxm0xoW8ocylSvPnkcuvXY3c3uKPpI+DS50QrSny2x/zn3tdyZWqLl7j4+TTmVJs9yPZt+paksLIjfhGhdjLew2PbfEIdj30vxqwanNEFsUlI3jWfnFRh4LUUcFs5klAxJCa1tOLJ6Dl0gmfEUXKgD5BJ9F9MQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; dkim=pass (1024-bit key; unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ahl4PxDM; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=akpm@linux-foundation.org; receiver=lists.ozlabs.org) smtp.mailfrom=linux-foundation.org
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ahl4PxDM;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux-foundation.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=akpm@linux-foundation.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fgwPs4zXdz2ySc
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Mar 2026 05:28:00 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0850D60053;
	Wed, 25 Mar 2026 18:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DC5C4CEF7;
	Wed, 25 Mar 2026 18:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774463277;
	bh=hpBw4RUY8JjxM8HYPYakB9zRBXoDbpL5Vame81dIANQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ahl4PxDMAZ4buO2ISagSICzQMCXJfWkl7I97eQ6yR1mOWfRwIu5UCh/gTbztrdxGC
	 fyA4HaqEAQXvNkPRoB9oqv1WPgBs8xAqNMYN0V08jI/FvWZ2bJt3m2qa09whBmgni2
	 JtFJg0xwVqAE8hSGnxFjcSYieb7qyA4v+ZsDWGt0=
Date: Wed, 25 Mar 2026 11:27:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Arnd Bergmann <arnd@arndb.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams
 <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave
 Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, Chao Yu
 <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, Jeffle Xu
 <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, Hongbo
 Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@kernel.org>, Konstantin Komarov
 <almaz.alexandrovich@paragon-software.com>, Tony Luck
 <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, Dave
 Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, Babu Moger
 <babu.moger@amd.com>, Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota
 <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev,
 linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm: always inline __mk_vma_flags() and invoked
 functions
Message-Id: <20260325112755.e62cd89508224f703239f03a@linux-foundation.org>
In-Reply-To: <959b34ea-69a7-4fda-a494-0b9a1773ec1d@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
	<241f49c52074d436edbb9c6a6662a8dc142a8f43.1772704455.git.ljs@kernel.org>
	<ndtnvnobevdymu5a5tdxdbi4tcsqshs3d6x2vnfgnuclxvgwok@bhbqkzilsets>
	<d352055d-06fe-43b2-8ad3-b73ab99683d0@lucifer.local>
	<20260325090949.795e06f48ec455053db9ae89@linux-foundation.org>
	<959b34ea-69a7-4fda-a494-0b9a1773ec1d@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 25 Mar 2026 16:23:53 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> Maybe 'into an inline constant value' is better?

<bikeshedbikeshed>

How about

: Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
: macro) always being inline, as we rely on the compiler turning all
: constants into compile-time ones.


