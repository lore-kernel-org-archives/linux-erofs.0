Return-Path: <linux-erofs+bounces-2365-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55D1BEA4FBA
	for <linux-erofs@archiver.kernel.org>; Mon, 23 Feb 2026 14:03:48 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fKMyp6l6Rz2yFc;
	Tue, 24 Feb 2026 01:03:46 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1771855426;
	cv=none; b=HUKD0r4NBeCZ1vI5yUF8pFOK/dFL5DLB0Ne1vxc6Vnh0L0pkvsCHBpvRZWZOJdLEkEklzBbtoN89MQbk0bvdCfdyV4CoEmc9b21eeCZeCxxVP8o60t73IMVBQBuLT1AP2hf55TMrrJX9KFwOUAaI0G1r6CWXClNfqIxK+4Gih1IFGcsH69YZCj6Hk+L02e9W6NofkYKougXqVsArsN+IhrssY14XIGhRnihICGk63VUdUCaL9zTCoBzEwAOPhRlei0R7xZNhMQShhw0waMhO5vWxf0KobVnoHTaBleUR3gjmiV2EXPexOlPNBfayvi28mh4bPJuVJ9+4p1mtqkOjRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1771855426; c=relaxed/relaxed;
	bh=x0bCF0gSNivwN6OED4BvckqGL7j34q4jTf0yj2ndCis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f8cFmSmykZOCjduBNq6/8pG8GIKumFm/54FWsPjnNRdNYsAZXPUHoWnvTmuXLdqqAgcF0RlJNfXbPTs/FjjhZEJJNs8xJVYfPcHShpqB6Cjbf/LUjPtTNMRN+rxeAS7OPlz5woPfELrOWGzJL0UE0uOn2f9QotL+IHdPfKfMXbL8hKBB1ybbuyrPEQkIzszkPbHT6MUqvVOCzBHYX5QghOuN47HiHUHC+J1C/vTb+7eo3TntGS1zlKmheAHOd1WZfXEj+g5unB2B3Y0qEEx9P/SOfjuipNuXf4FNZSIpGVj69tYprdrPqJ8IK8iGXMIhB7ed8vCtZfDkbuKUK12yBQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=UamWqCMb; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+48176073e30864d8fa6b+8219+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=UamWqCMb;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+48176073e30864d8fa6b+8219+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fKMyp1CX9z2xN8
	for <linux-erofs@lists.ozlabs.org>; Tue, 24 Feb 2026 01:03:46 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=x0bCF0gSNivwN6OED4BvckqGL7j34q4jTf0yj2ndCis=; b=UamWqCMbl6P3nbszGSl40uzFdI
	l6ZjTjAvQZpcrAqLBgvEpn1PTBhaHyLcLM8nELM9k9jjB6cjpWItZhBWSB5yo2Ld35EG+LfWoKPTg
	wVZxxM82kFhZnjlwTKTAN6hU7JgDj5V5zS6fWPIUujS71WuSauUKRLhQZ3h884V5YXbE5yeA/3o1z
	g40QtAPXSLaE45U3JPId+LK77m7RrY4TycmWevnGT6EuY2nKm5Xn0QxVi5dZXjgXlrt2BhEC48Zyw
	uGKob5+htZDIPIv7s4zX/dbitIPZd//Uy8Ip1NfgtuTMWU87fVwdAZnqjL6MVezLjACgLXbPrh2rA
	Z8z5r+DA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuWX0-00000000RIL-2hdP;
	Mon, 23 Feb 2026 14:03:26 +0000
Date: Mon, 23 Feb 2026 06:03:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, linux-block@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jason Xing <kernelxing@tencent.com>,
	Yushan Zhou <katrinzhou@tencent.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Eric Sandeen <sandeen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>, Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Gao Xiang <xiang@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>
Subject: Re: [PATCH v1 00/11] Zero page->private when freeing pages
Message-ID: <aZxeLmNyKKTrkSzn@infradead.org>
References: <20260223032641.1859381-1-ziy@nvidia.com>
 <aZxaIEFZr2NvO2eQ@infradead.org>
 <F1307EF8-7054-4135-B61A-62141A113394@nvidia.com>
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
In-Reply-To: <F1307EF8-7054-4135-B61A-62141A113394@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Feb 23, 2026 at 09:00:57AM -0500, Zi Yan wrote:
> > awkward interface.  Don't do that.
> 
> Page allocator hands the user a zero ->private. I think it is reasonable
> to require the user to return a zero ->private. Restoring things back
> to their original states is a common standard, isn't it? And most of
> users do that.

No other relevant interface requires private data pointers, as that would
be silly and cause tons of bugs.


