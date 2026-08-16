Return-Path: <linux-erofs+bounces-4233-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60D64C5B572
	for <linux-erofs@archiver.kernel.org>; Sun, 16 Aug 2026 04:12:01 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hN2bf6Bkgz2xlv;
	Sun, 16 Aug 2026 14:11:58 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786853518;
	cv=none; b=C7aY11IbenBH6X6AKAHRn8CUN2qqRcysj4zPGXNjUXGa7xLKP0EGC2akIw8/xONWPYOFB9iQo8okwRf2up5o473FywQVZgJV+0htFoyQ0C7y/S3hVUDcAhO5pG7DtZSz/CciNIaG13FqijhWUeGB3qqs34gvhitxRMcqL6JjswxZkZF/GbwkiZ1ePebCW8kemtjjN9K1UJ8Coz/svc+zUwREc1eN1OaVCz2CrEfs2U7/OrVtaWDRDIK8ZRg9DBpUCmRG4FQz0yXuH6NdVn5UMPvjf1VeQC0VU75jnn1A+UOfyWdoWryDEjvaBPXZ8YDfR2A4nDiXCSoJmhIzl6jYGw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786853518; c=relaxed/relaxed;
	bh=cFHs8gvxJX+p37ht/u6mq8BW9d9iCfeT6c4xmXd4hIo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b0QqqmKJU2KLkyfQY+RFptoQ/3x4uG2vzMa9H17Ax2U//Ghxr2f3/b01iFtO0/qFq/sbTx6OPVi3y/A+IED/0YUwM5R0txOMgjud2DP9P4W8Y1sbxDeY9ebSsASFm8GaO/lVQw8fk9qkP6rz7J7kUYzBqUFGcaVqTqKAKO6bu6zhvWYzO0IdLWzFaO7/E+smddlGbxXdOSHBwISAl6g7318pOMR+pZbRzkNNShFC4Aq/zQSt8LBjpA+tXkdW3fgj8NwrPst2S7W/tMrHQ3qV0mtAm4yUVS2LxJvsn7ih6rUvuJy7ic1cG6Sh05SnhQ9r6eGT6Rxky48GbQtosn8sfg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y626Wpze; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=baohua@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y626Wpze;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=baohua@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hN2bd4ThYz2xjN
	for <linux-erofs@lists.ozlabs.org>; Sun, 16 Aug 2026 14:11:57 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E8EBA4400F
	for <linux-erofs@lists.ozlabs.org>; Sun, 16 Aug 2026 04:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5661F0155B
	for <linux-erofs@lists.ozlabs.org>; Sun, 16 Aug 2026 04:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786853513;
	bh=cFHs8gvxJX+p37ht/u6mq8BW9d9iCfeT6c4xmXd4hIo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Y626Wpze5eush5ifesQlMpXEC+DZ+SYMxPDh1c/gdX6JMAVrOzh84A0RPXO84FrIc
	 +QUNB0m88JUb5shuHgka5W9YxR1k1riSwdzWNNMs3CbQCe+ircgB2uEvvu+QPFpu+X
	 aLsU6FzFU4sygvmMnAFLzvLVHGEdOqVpnnfV6lmvaE/UGmevtAvoedMtZxTHYal1k1
	 /ERR09Lp+Af06TDPHCogWWCbaj0GztIfngM2ONMOIVX6FGqnwPjrIRqOpjDJCuKOyi
	 YtJQrt07/fE+F+3nn3GvSiK+Eoi6ZGtFAwxHv09mFwL5m1JZLIeQO0uY23SOk+1lHw
	 eo9bZQWlY2HBQ==
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8fcc43c48f7so23776856d6.2
        for <linux-erofs@lists.ozlabs.org>; Sat, 15 Aug 2026 21:11:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoJziYRxDUX/+mOC3cKLdOE4wCAFyc6F0RXfcnITOa6rJhnY5Kz9k+61yN8eG3LUaHwOuVSYhQ88TXZpA==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Yz7H9soDhvXBCmjpdoSpjhyoS/ORIS+q7Fy3rdGEVS8GOIk/6X5
	zJM7fpAR7601LYCgQcD77vvdqcna9Wuv2PViddXifehoiP+zYJqNJqZ4b3eacCuCs3LY89NJN8r
	8I8pWZG8GG52+RZwdOQEPpUpVAGuqHfc=
X-Received: by 2002:a05:6214:459b:b0:8ee:fbc5:8110 with SMTP id
 6a1803df08f44-90a91e850e0mr202646836d6.32.1786853512973; Sat, 15 Aug 2026
 21:11:52 -0700 (PDT)
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
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu> <20260730-blk-dontcache-v7-2-3e8e6850068d@columbia.edu>
In-Reply-To: <20260730-blk-dontcache-v7-2-3e8e6850068d@columbia.edu>
From: Barry Song <baohua@kernel.org>
Date: Sun, 16 Aug 2026 12:11:42 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wUvLoKGafR3U-ji1kUUaz6K_QdN6QxMT-apSaO5tXp0A@mail.gmail.com>
X-Gm-Features: AcwNN1WZkB-TbbPYLGbQZDybzjU1BQWX9MmsjrOiq9haH_bC38JheVA30gQpXP8
Message-ID: <CAGsJ_4wUvLoKGafR3U-ji1kUUaz6K_QdN6QxMT-apSaO5tXp0A@mail.gmail.com>
Subject: Re: [PATCH v7 2/5] block: add task-context bio completion infrastructure
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Dave Chinner <dgc@kernel.org>, 
	Bart Van Assche <bvanassche@acm.org>, Hillf Danton <hdanton@sina.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-erofs@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 3:37=E2=80=AFPM Tal Zussman <tz2294@columbia.edu> w=
rote:
>
> Some bio completion handlers need to run from preemptible task context,
> but bio_endio() may be called from IRQ context (e.g., buffer_head
> writeback). Callers need a way to ensure their callback eventually runs
> from a sleepable context. Add infrastructure for that, in two forms:
>
>   1. BIO_COMPLETE_IN_TASK, a bio flag the submitter sets when it knows
>      in advance that its callback needs task context (e.g., dropbehind
>      writeback). bio_endio() sees the flag and offloads completion to a
>      worker automatically.
>
>   2. bio_complete_in_task(), a helper that completion callbacks can
>      invoke from within bi_end_io() when the deferral decision is
>      dynamic (e.g., fserror reporting).
>
> Both share a per-CPU list drained by a work item on a WQ_PERCPU
> workqueue. Producers push the bio onto the local CPU's list and schedule
> the work item, which then dispatches each bio's bi_end_io() from task
> context.
>
> Both methods are gated on bio_in_atomic(), which returns true in any
> context where a sleeping bi_end_io() is unsafe, including
> non-preemptible task context.
>
> Two CPU hotplug callbacks are used to drain remaining bios from the
> departing CPU's batch, while maintaining the per-CPU behavior. The
> CPUHP_AP_ONLINE_DYN callback disables the per-CPU work item while the
> CPU is still online, preventing it from running on an unbound worker
> later. CPUHP_BP_PREPARE_DYN then drains any bios added between disabling
> the work item and CPU offline.


Hi Tal,

Thanks very much for the patch. I=E2=80=99m just a bit confused that
folio_end_dropbehind() only requires in_task(), and nothing more.

void folio_end_dropbehind(struct folio *folio)
{
        if (!folio_test_dropbehind(folio))
                return;

        /*
         * Hitting !in_task() should not happen off RWF_DONTCACHE writeback=
,
         * but can happen if normal writeback just happens to find dirty fo=
lios
         * that were created as part of uncached writeback, and that writeb=
ack
         * would otherwise not need non-IRQ handling. Just skip the
         * invalidation in that case.
         */
        if (in_task() && folio_trylock(folio)) {
                filemap_end_dropbehind(folio);
                folio_unlock(folio);
        }
}

But we=E2=80=99re applying a much stricter check with bio_in_atomic():

+static inline bool bio_in_atomic(void)
+{
+     if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
+           return true;
+     if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
+           return true;
+      return !preemptible();
+}

I feel like something may be missing either in
folio_end_dropbehind() itself or somewhere in the
filesystem/block-device path.

Do you know why they don=E2=80=99t match each other?

Best Regards
Barry

