Return-Path: <linux-erofs+bounces-4362-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4937EC61DB9
	for <linux-erofs@archiver.kernel.org>; Fri, 28 Aug 2026 13:29:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hWfPJ2dzXz2y8F;
	Fri, 28 Aug 2026 23:29:24 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787923764;
	cv=none; b=bFyiTCgfuFocBdhUaWUUWXUoX95K6W+Uq3DH0MnSWkj2NqOSMd6FMIKSiUY6ORuN5eKpCEsnsFur5ZfTeqxKSRbRY5DEfQeSC29LQsUnjzz66cv4OlJVWZd3NYbqqRUdnbUsmqIi9qoXfJSklxQuvq1EpTH21WOB0x88NFn2erA6thg+HyuKL7Eaous+/02yg4y5XfNlFnIW7np7tgb+N4s7+gUajJfiFC8rRcR/c07MFCyyYJIGMSA8Q3nsc2PmkO7rKIHldap7djS2aMzZj8A4SN5pGD1HWqpDyL8UMYs8Ra6bQ8sSZKTmUe5Gb38riQDHURaxQYZzdl3Qw71Qzw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787923764; c=relaxed/relaxed;
	bh=MJo92qxuTxW6xloiekXIgDf7/8rPYktAVkSmnZb23rU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FgLHUXfkQWkfoB6+mTcMOSTJcZ0LQm4ZNe0601QZ+Qf760OMOmq+z8D+GI6jDCX+5h3G34chhBEt+31aqD6X7PzNWFoH60v/vTp8CrTH1KOqBpdRiv9yCiqTQazaDAih0cvaKFON3IKmOg6j23uMhmQKkMczusClJ64ZDAXlWyABZqfBgaJb1biw2QXpvzR0x/MMCfnUV3+2rcBdLZOtEPHTUJHUNDydt48zoQjLot1IksjEi07352gQZLlBVQ63r2veUrxpYvflc+EGVfTNCyt0abY0z07Qvs7t1TET5JtFyAudDe57TW82yKplKlgNaUpSggXvJVtFXlGNh5aKGQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JVuDSrLF; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JVuDSrLF;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hWfPD6kW8z2y2T
	for <linux-erofs@lists.ozlabs.org>; Fri, 28 Aug 2026 23:29:20 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE196418A3;
	Fri, 28 Aug 2026 13:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BF71F000E9;
	Fri, 28 Aug 2026 13:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787923755;
	bh=MJo92qxuTxW6xloiekXIgDf7/8rPYktAVkSmnZb23rU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JVuDSrLFuj6k7RItIE+V2oDbDmVydF/LNgxkfY3mNs1nlUu1tKuAKHugZfZVktqsf
	 CcF0efwSFF3OpzEORaQb1Rj5ThIggKTO5s/BqM4uS+yVk51M6XzX6MgPTr5UrdsWhJ
	 P5f9dx4kb3qEalFAF+X/dCZ3AAiQqu1tlLDrIfD14Hg+ZsgJ6M9PUNEm1HvxicbmPm
	 T3AMJPkYoQQzV0oV7WJHZ9/XHQyMM/fXzADI3GO3AKtpKNWyDYxU16GLt2HfSXi98h
	 ZSpFyRYhZ/xm7Bx3g5346FxeJFQkq3bfcMgsUZ7wPOVo5OAiV6xdRuPCHXm7iy/g/d
	 TcXlZ5XHOAAnA==
Date: Fri, 28 Aug 2026 21:29:09 +0800
From: Gao Xiang <xiang@kernel.org>
To: "Walther, Jens-Uwe" <waltju@amazon.de>
Cc: "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>,
	"xiang@kernel.org" <xiang@kernel.org>,
	"chao@kernel.org" <chao@kernel.org>
Subject: Re: EROFS: decompressed page cache returns valid file content from
 the wrong offset under sustained reclaim
Message-ID: <apGNJSV_pSlZek1o@192.168.5.19>
Mail-Followup-To: "Walther, Jens-Uwe" <waltju@amazon.de>,
	"linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>,
	"xiang@kernel.org" <xiang@kernel.org>,
	"chao@kernel.org" <chao@kernel.org>
References: <BEZP281MB2102E57CD31862B8D958B33DD2AC2@BEZP281MB2102.DEUP281.PROD.OUTLOOK.COM>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BEZP281MB2102E57CD31862B8D958B33DD2AC2@BEZP281MB2102.DEUP281.PROD.OUTLOOK.COM>

Hi Walther,

On Fri, Aug 28, 2026 at 12:01:22PM +0000, Walther, Jens-Uwe wrote:
> Hey folks,
> 
> We have two independent occurrences of silent data corruption on EROFS roots, on
> two machines run by two different operators, and we cannot reproduce it locally.
> The corruption is not random: a contiguous region of a read-only file comes back
> containing that same file's own bytes taken from a different offset. Details in
> case the pattern is recognisable.

So, so far there is only two individual reports, and it is
unreproducible locally?

> 
> Environment
>   EROFS root image built with mkfs.erofs --all-root -z lz4hc,12 -C 262144
>   mounted ro, cache_strategy=readaround, dm-verity below with
>   restart_on_corruption
>   kernels 6.18.38 (case A) and 6.12.95 (case B), x86_64
>   8 GiB and 16 GiB machines; swap is zram only (1 GiB, lz4), no disk swap
>   failures appeared after 9d5h and 5d16h uptime
> 
> Symptom
>   A 3,627,816-byte shared library reads back with one contiguous region
>   replaced. It has a self-integrity check, which is how it was noticed.
>   Everything outside the region is byte-identical to a known-good copy, and the
>   region reconstructs 100% from that copy as exactly two contiguous runs taken
>   from elsewhere in the same file:
> 
>   case A   region 0x239000-0x23afff (8,192 B)
>            run 1  at 0x239000  3,694 B  from +16,786
>            run 2  at 0x239e6e  4,498 B  from +8,393
> 
>   case B   region 0x271d0c-0x273fff (8,948 B)
>            run 1  at 0x271d0c  7,436 B  from +17,896
>            run 2  at 0x273a18  1,512 B  from +8,948
> 
>   In both cases the first shift is exactly twice the second. Neither is a
>   multiple of PAGE_SIZE (8,393 = 2*4096 + 201), so this is not a page- or
>   folio-level mixup.

I'm not sure I could parse it correctly (for example, I don't quite get
the idea what shift means), but if the shared library can be shared with
me, could you just send the binary to me directly?

Or when the wrong data was read, did you find the same data in the
image?

> 
> Location
>   dump.erofs -e places both corrupted ranges and both of their source ranges
>   inside a single extent: logical 2,177,202..2,779,162 (601,960 B) decompressed
>   from one 262,144-byte pcluster. Nothing sits near an extent boundary. The
>   error is therefore produced within one decompression, not by selecting the
>   wrong pcluster.
> 
> Ruled out
>   on-disk corruption - dm-verity reported no error across 15.92 days spanning
>     the fault, with restart_on_corruption armed
>   a stale mapping - a read() of the file and the process mapping return the same
>     wrong bytes, so the page cache itself holds them
>   hardware - two operators, different CPU vendors, and the result is structured
>   folio migration as the copying agent - migration moves whole pages, the shifts
>     are not page-aligned
> 
> Conditions
>   Both machines were under sustained page-cache reclaim. Case A: 956M
>   pgsteal_kswapd and 559M workingset_refault_file over 17.7 days. Case B: 71M
>   and 16M over 7.74 days. A comparable machine on the same image with no reclaim
>   shows pgscan_kswapd and pgsteal_kswapd exactly 0. Since the only swap is zram,
>   clean page cache - i.e. the EROFS image - is the only memory the kernel can
>   genuinely free, so all pressure lands on evicting and re-reading these pages.
> 
> Geometry in this configuration
>   bpftrace on z_erofs_lz4_decompress, same image and mount options, while the
>   library was evicted and re-read about a million times:
>     rq->inplace_io was 0 for all 963,196 calls
>     74.7% had rq->partial_decoding = 1
>     inplace_io=1 occurs only when the compressed pages are absent from the
>       managed cache; with a warm managed cache we never observed it
>   So the failing path is very likely a managed-cache decode, mostly partial.
> 
> Not reproduced
>   ~33M real decompressions of the same file, same image and mount options, under
>   heavier reclaim than either failing machine (66x the pgsteal_kswapd rate, 1.4x
>   the pgmigrate_success rate), produced no mismatch. Also tried: 92M single-page
>   faults against a purpose-built image with an identical extent map, forced
>   compaction, and cache_strategy=disabled. No mismatch in any configuration.
> 
> Questions
>   1. Is a byte-granular displacement of this shape known in the partial decode
>      path with big pclusters - output written at rq->pageofs_out into a
>      partially populated rq->out[] set?
>   2. Does the first shift being exactly twice the second suggest particular
>      index or length arithmetic worth looking at?
>   3. Could z_erofs_lz4_prepare_dstpages() or the fillgaps handling place output
>      at the wrong offset when only a subset of out[] is requested?

I don't think answering the details of 1,2,3 helps since
 - it involves many erofs implementation details and hard to write here
   in simple words, for example fillgaps should have nothing with your
   set since it's only related to mkfs.erofs `-Ededupe` feature;

 - the decompression subsystem is basically unchanged from Linux 6.1
   to Linux 6.12, except that:
     - it adds subpage block support (I think it's unrelated to your
       case);
     - it adds large folio support (suspicious);
     - the lz4 doesn't rely on some page refcount anymore (see below).

 - If you didn't observe it on Linux 6.1/6.6, I guess it may due to the
   following changes:
     - (6.6~6.12) it implements large folios, so we could try to see if
       the fleets can still be reproduced with large folios disabled;

     - we could try to revert 1001042e54ef ("erofs: avoid refcounting
       short-lived pages") since I think it's a significant change from
       Linux 6.1/6.6.

But anyway, if it only reproduced twice so far and no reproducer, I think
first we need to find a better way to reproduce it in a short time; on
the other hand, I will review and reproduce myself too, but as I said,
the binary is helpful for me to get more clues.

Thanks,
Gao Xiang

>   4. If field data would help, what would you want captured? We have a detector
>      running that hashes the file periodically and, when it fires, preserves the
>      machine along with the corrupted copy, /proc/vmstat and PSI. We can also
>      run additional tracing or a debug patch on affected fleets.
> 
> 
> Thank you in advance.
> 
> Best regards
> Jens-Uwe Walther
> Senior Specialist TAM Containers
> AWS Enterprise Support
> [CKA badge]<https://www.credly.com/badges/b4f55949-4357-4062-93a9-6d0f0f5f3833/linked_in>[CKAD badge]<https://www.credly.com/badges/85b75f03-91d4-4887-8150-cfb9ea39d272> [CKS: Certified Kubernetes Security Specialist] <https://www.credly.com/badges/c26e3b3c-cfc7-46d7-8b7b-7a7a59045c60/>
> e: waltju@amazon.com<mailto:waltju@amazon.com> m: +49 152 38870547
> [cid:image004.png@01D9D4D4.4DF69060]<http://www.aws.amazon.com/>
> 
> 
> 
> Amazon Web Services EMEA SARL
> 38 avenue John F. Kennedy, L-1855 Luxembourg
> Sitz der Gesellschaft: L-1855 Luxemburg
> eingetragen im Luxemburgischen Handelsregister unter R.C.S. B186284
> 
> Amazon Web Services EMEA SARL, Niederlassung Deutschland
> Anni-Albers-Str. 21, D-80807 Muenchen
> Sitz der Zweigniederlassung: Muenchen
> eingetragen im Handelsregister des Amtsgerichts Muenchen unter HRB 242240
> USt-ID DE317013094






