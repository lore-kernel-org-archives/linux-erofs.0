Return-Path: <linux-erofs+bounces-4593-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D88AEC98304
	for <linux-erofs@archiver.kernel.org>; Tue, 22 Sep 2026 04:16:30 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hpmxn1K9xz2xnQ;
	Tue, 22 Sep 2026 14:16:29 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:39::"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790050589;
	cv=none; b=dDFYlVixupJV/td18vYvcydp+r2BMJiRjrJUpEg1dH3MPXAswxdNr3yMZwZUz5qhWPZzzh6Kz7Qt80EoRNHnQ4SHsbTc0gggXwlPfbB+0CtFC2n7T1zCJqUOiZuDr46bKeroIQvNTB1goNG2XvzArfnBH4iRYfixTGla27DwcCXVL1FS1gWcu0x+1u5mPdGytAiN+RwTjjby4d7eRZDXqwDFOnwwr/VZP1MEkyhr6iOUMp14+w2E8sam87IIDG35Y/SSItVlmCWHXZXF7ed8jyhAh11Q2P2B8kRho0Zi/NtxXWB3OqyZfZwb5KY05oiuNZYr9zIO1Ar7brQPgp1vbA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790050589; c=relaxed/relaxed;
	bh=JDLbvCKUB+a+IDR0laoJE09QGbcCCmet6VJT4AONztI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fk85Sxw2uEPt4Teremb/3PrPQv6+NzEjD05GpZY4Ig1fuz05VtUOBGVPEGef5IW9tPcYr2iff1fz2vNKXiMsqoHZXiWe91iuPzoN9M/Bf/ju2RT+NMBOIiBCGYz13dAIFH9tXz+9e3qMZOA1w6Lf3DzPwkbTWlvCrL10sjVwFhC7o/kIYG8VRy8m0yzJGKHzbJiFsyoTlTKUsSSFvcd9ZcbyzpgZglqrnhf4LwWNKOO4jivYaVVua73eFglkVr9JZjJ7bhj9dmDTqD3p4L28g6XOMxvamxhN6Ois+IFuRF1JL34i/wvaQ5IIcn6VoyvrhckebQcQpmsWa+8b1viLAg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OdPhxGiH; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:39::; helo=mail-pj2-x00.google.com; envelope-from=nzzhao.sigma@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OdPhxGiH;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:39::; helo=mail-pj2-x00.google.com; envelope-from=nzzhao.sigma@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj2-x00.google.com (mail-pj2-x00.google.com [IPv6:2607:f8b0:4864:39::])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hpmxm0X8vz2xSg
	for <linux-erofs@lists.ozlabs.org>; Tue, 22 Sep 2026 14:16:26 +1000 (AEST)
Received: by mail-pj2-x00.google.com with SMTP id 98e67ed59e1d1-39e59dca659so2252848a91.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 21 Sep 2026 21:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790050583; x=1790655383; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JDLbvCKUB+a+IDR0laoJE09QGbcCCmet6VJT4AONztI=;
        b=OdPhxGiHhjrlBfqSCaB9sxrUGMFSDHnl8RICwU6h/HnBFKiObwSkKW9j7xFLwTpwHw
         7kbIHqN3+VCmYGZ436aoawLm57QZ2unKFme1MX+jKGZy9CQ1SiYjSV5IcDcHIOw7A5Ir
         6A/OIaMdKvRb3t4UsLOe05z/WTWQ+NqpUdo0qZN/VbE54r1OvrjFe+oBU2v1LEq0FuEK
         tRhs67EjsoxqFTAx5gTvHeCXUTsvEAL5AAtANyPPhDwnsKZifboWr3R4len7TTxUWN03
         qeuAVGiwio4GyOGc9McJmGwuvFZeETExHfTilbzWCo5esGnyimrnfItPuiSdzFcRYCpY
         DJqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790050583; x=1790655383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JDLbvCKUB+a+IDR0laoJE09QGbcCCmet6VJT4AONztI=;
        b=o/BxxCIqiTa24kpf8SPvGEEyUPpnjO7+Hf4c3BBsoo98vRveSUqr/giN5Whvqnz5qi
         DDXjNU3xWF+S3GbmHT1BOWEAI/UblunV1wsE3sIX+GIUxWUX1PPdzTfio+W3XVArGP6c
         z9yCIGMeWuiFceYbMEz97B8l4ewCRgEnS0hJ1yAj5m77c8xADh+zgAYzE37ncOADc2WI
         ORyw6LJQXDeITbSJ6Bi5Jr0EPZLDY6bIXfdJQRnrhfSerYHTq2JKW2LLPK2ZpxRF8/X+
         +6FzNNqbtVU5474fhUFZ1QnRb01QoM7cQoeFB6668w/iV3K67+aqixq4JtyT2wXlnSmf
         F6Wg==
X-Forwarded-Encrypted: i=1; AKwUvBzo8Y9VeVVIErmuNoFkFS5HZ3lDWtWZbbYrMH6h/Ccem6/x6oaASNUG6YruUHJ7Ig4aOHY1YgkC661XLQ==@lists.ozlabs.org
X-Gm-Message-State: AFuF++kTmpPIWehNiqeR68fO8oNJaZcmzja6rs6S8zNm30+D+Ja4ngun
	u60KHHBpyYZwNk52pWoCQb5/X9DP64DT278sX4fq5w9UWnsxzfPNKI9e
X-Gm-Gg: AYBFou0NiSCf4e+q5fdaet4NAepx3+K1wzofKtc5ppOz680pHjK1YLrEvM3gM0bllfE
	553kGL9dQIy6AbJ3ndXej7sCLKo/zaAq2n+t+8ZLgdciwum3pNhisezPtqE1a7zkTxkA/WthqOH
	f/HiJGa4TL4jBiepB3p/gemHs/qobUjC2urDGkbBHRYcrbZ6xXFx/x91CQ6TEz/ZviYOt36/F4o
	sXNvbqUlFzEEnczmbWL9bxvPRdZJlY3yS1hp9DMrkyftCbY4dZSVpx/zyOkk9ODmpk0EVf2NkQ0
	6EJjj0bM7mq9aItSB9Ma+GOjYG4OjfZbz0D3o27pouBzb1Pa3JhZuqFGSPdBMAy17MENB3ZI3u1
	x0RvJdrhe8Dy8sucArMGVGXJCHkL+VT7t8Rs5isve1oVzRFsn4TXKkYmM3IgdWvbXzgpykd2p6g
	HuoC7U32N6yr+oqVvdJLseTSmKVRdXl/PvGbhfY9sDC2Qdfjs5eDz0vG41P+gyGC90Ccz+8140Q
	j9ldudYtLTBdCphF6koSTCQANKHEkDPde5z
X-Received: by 2002:a17:90b:56c5:b0:39d:f95d:bd08 with SMTP id 98e67ed59e1d1-39e55008a3amr25857593a91.14.1790050583196;
        Mon, 21 Sep 2026 21:16:23 -0700 (PDT)
Received: from nzzhao-ThinkCentre-M760t.mioffice.cn ([43.224.245.179])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0674d65d4sm2204031a91.15.2026.09.21.21.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 21:16:22 -0700 (PDT)
From: Nanzhe Zhao <nzzhao.sigma@gmail.com>
X-Google-Original-From: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Rogers <irogers@google.com>,
	Jan Kara <jack@suse.cz>,
	linux-doc@vger.kernel.org,
	Alex Markuze <amarkuze@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	kexec@lists.infradead.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dave Young <ruirui.yang@linux.dev>,
	Adrian Hunter <adrian.hunter@intel.com>,
	linux-mm@kvack.org,
	Hongbo Li <hongbohbli@tencent.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Tal Zussman <tz2294@columbia.edu>,
	Baoquan He <baoquan.he@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Anna Schumaker <anna@kernel.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Yue Hu <zbestahu@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	x86@kernel.org,
	ceph-devel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Wei Xu <weixugc@google.com>,
	xen-devel@lists.xenproject.org,
	Gao Xiang <xiang@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	James Clark <james.clark@linaro.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	linux-fscrypt@vger.kernel.org,
	Borislav Petkov <bp@alien8.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-mtd@lists.infradead.org,
	Axel Rasmussen <axelrasmussen@google.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Juergen Gross <jgross@suse.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	linux-nfs@vger.kernel.org,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-perf-users@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-trace-kernel@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	Trond Myklebust <trondmy@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Daeho Jeong <daeho43@gmail.com>
Subject: Re: [PATCH v5 00/17] Remove PG_private by using page/folio->private checks instead
Date: Tue, 22 Sep 2026 12:16:00 +0800
Message-ID: <20260922041600.1240429-1-zhaonanzhe@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
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
Content-Transfer-Encoding: 8bit

Hi Zi Yan,

Thanks for the series. The cleanup is a nice help for the f2fs
large-folio work -- it removes the page-based private-flag plumbing that
my series would otherwise have to carry itself.

My large-folio series v2 [1] can be rebased on top of this series. The
only overlap is the PAGE_PRIVATE_* flag helpers, which I can re-express
on top of the F2FS_FOLIO_PRIVATE_* names while keeping the
f2fs_folio_state indirection.

Jaegeuk, do you have a preference on the ordering here? My personal
suggestion would be to review and merge this series first, and I'll
rebase on top of it.

[1] https://lore.kernel.org/linux-f2fs-devel/20260915041909.2903887-1-zhaonanzhe@xiaomi.com/

Thanks,
Nanzhe

