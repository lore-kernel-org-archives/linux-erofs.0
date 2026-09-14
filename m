Return-Path: <linux-erofs+bounces-4554-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAEF9C88E64
	for <linux-erofs@archiver.kernel.org>; Mon, 14 Sep 2026 03:40:09 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hjrWW5xllz2yQJ;
	Mon, 14 Sep 2026 13:40:07 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789357207;
	cv=none; b=LlS3BrA/0NullGORvY8cwErwEU2IjSmQwygNsWFivhlF9Xy8gwHJ9HTVMDUIn5DwwinHH9MAqYFdoijyZFYwTyBUfNlqhaHuoukW8VOFRIBdDYlWU/25ig4rWe13S/rDsti3eJ4G4iuADNjOqZMbOHJ2M5BOAwG9xAxUCjUflE+eHF5rbvHidSwOqZCviPgE9+uQANZFivSB94JxXVBNV5/tcpLiVmbyWP6m6SeXiCqe40uxg3DttFCuJLLFI2t4IEthzSE3c9FNsQMPseFU56j6vfG4MeHv8A+bIXwmmtWlUMFum+OLJqkdywOGjOBWH3YndJQn+8+eOBxS2K5NEw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789357207; c=relaxed/relaxed;
	bh=x5zisV7HoQ8XMweM1XOT4E07P1NlnKsteMfQzVmO4Js=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=mYXtBbw3AAFLviM1i/ROSEMZmHQQX6ca5RjBkgHTEr9IsWxWbKoY1WgbscfBOjapxfVnoQwQdM4jyDfmaxz5YdJ0QNAesbkKp8FDoqmMIATRD1ktGXTHiFVTOAyRbSrFGPpskbCvSEUStBxql/BaOPK5jR4e/7cMycXWfk+D1RUoGAgmEfXOpu44MCkPisrBGX0NJ2Z7hI7THFQ7FK/Zp1a8o7Ui9urm42Ndl2dzn0zdIkInD4n2npMLWA00frEML1kZVfOzdP5xveHtZ6xRgqPTNvbTFYvlundqyR/wxdeWgOzGkE2iVuf6pJfXB9UxBJdbBPQFYy5VBak4j0guoQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; dkim=pass (1024-bit key; unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pHy6fbef; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=akpm@linux-foundation.org; receiver=lists.ozlabs.org) smtp.mailfrom=linux-foundation.org
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pHy6fbef;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux-foundation.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=akpm@linux-foundation.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hjrWV551cz2yLg
	for <linux-erofs@lists.ozlabs.org>; Mon, 14 Sep 2026 13:40:05 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8DFC540A5C;
	Mon, 14 Sep 2026 03:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FF91F000FF;
	Mon, 14 Sep 2026 03:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789357202;
	bh=x5zisV7HoQ8XMweM1XOT4E07P1NlnKsteMfQzVmO4Js=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=pHy6fbeflVTU8QtsqFS5eh8OvOR3ntwRr+lHZYMkoAT3ltm91/zKHpwN5XKZntEOS
	 ILIVvwKavB+/VLgc77oFP5R90/PbqE2ALcouMF/TdFK9XZ9ovr5QioyLZB1yLh6r2e
	 gdt1bOJXa+0zPlb1i7I7WNxSlmbqXRfHn0UsNCp4=
Date: Sun, 13 Sep 2026 20:39:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Minchan Kim
 <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Peter
 Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo
 Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, Dave
 Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Mark Rutland
 <mark.rutland@arm.com>, Alexander Shishkin
 <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Ian
 Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, James
 Clark <james.clark@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-perf-users@vger.kernel.org, Juergen Gross <jgross@suse.com>, Stefano
 Stabellini <sstabellini@kernel.org>, Oleksandr Tyshchenko
 <oleksandr_tyshchenko@epam.com>, xen-devel@lists.xenproject.org, Eric
 Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk
 Kim <jaegeuk@kernel.org>, linux-fscrypt@vger.kernel.org, Oscar Salvador
 <osalvador@suse.de>, Chao Yu <chao@kernel.org>,
 linux-f2fs-devel@lists.sourceforge.net, Tal Zussman <tz2294@columbia.edu>,
 Gao Xiang <xiang@kernel.org>, Jan Kara <jack@suse.cz>, Yue Hu
 <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep
 Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, Chunhai
 Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
 linux-fsdevel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, linux-trace-kernel@vger.kernel.org, Trond Myklebust
 <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 linux-nfs@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>, Alex Markuze
 <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>,
 ceph-devel@vger.kernel.org, Song Liu <song@kernel.org>, Yu Kuai
 <yukuai@fygo.io>, Li Nan <magiclinan@didiglobal.com>, Xiao Ni
 <xiao@kernel.org>, linux-raid@vger.kernel.org, Richard Weinberger
 <richard@nod.at>, Zhihao Cheng <chengzhihao1@huawei.com>,
 linux-mtd@lists.infradead.org, Baoquan He <baoquan.he@linux.dev>, Pasha
 Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Dave Young <ruirui.yang@linux.dev>, Shuah
 Khan <skhan@linuxfoundation.org>, kexec@lists.infradead.org,
 linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 00/16] Remove PG_private by using page/folio->private
 checks instead
Message-Id: <20260913203959.6b46b0b5a052aec818a7f267@linux-foundation.org>
In-Reply-To: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
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

On Sun, 13 Sep 2026 22:23:58 -0400 Zi Yan <ziy@nvidia.com> wrote:

> This patchset removes PG_private to make space for upcoming PG_folio for
> identifying pages from a folio (more details in Note below). Instead of
> checking PG_private, all code is changed to check page/folio->private !=
> NULL instead.
> 
> MM people are cc'd on all patches and subsystem people are cc'd on the
> cover letter and corresponding patches.
> 
> Patch 6 is picked up separately in f2fs tree, but since mm-new does not
> have it yet, it is sent for MM testing.

AI review claims to have found a pre-existing critical level deadlock
in f2fs:

	https://sashiko.dev/#/patchset/20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com

it also had a few things to say about this patchset and, as always,
hugetlb.c.


Thanks, The MM bits appear adequately reviewed and review of the non-MM
bits are, as usual:

  Great to have but I won't permit lack of other-than-MM review to
  block MM improvements.

So I'll queue it all up and shall push it into -next after a few days.

Acks from non-MM maintainers are appreciated.

If a non-MM patch appears in linux-next I'll autodrop the mm.git copy
of that patch.


