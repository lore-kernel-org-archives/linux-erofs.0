Return-Path: <linux-erofs+bounces-4380-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 745A1C61DE1
	for <linux-erofs@archiver.kernel.org>; Sun, 30 Aug 2026 08:57:37 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hXmGl1Qjyz2xbQ;
	Sun, 30 Aug 2026 18:57:35 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788080255;
	cv=none; b=Nufm1dissP6FiLEi2Wstm5WfDHXheqhzZ1RwkwAnABgjUyqaJxt4hba0D89OrUUq5gHyaChA5u0t43TpTGvhpZBnLVXzRl1WLlDlwxBwKqetCSPgZMYn20DJfU6VqsAhNDSABQsEHWy4pCeCeqK2N4zFllaG6bdu9Ax4xZxkclevTlN/h6Dk/1CwQ57zshvOraUBxSXn0WUhhC9zdbVMOOBHzk+39KtZH9fiToLw23622I7IZmwOnPAuCD2QzvDEAphS5YIekcn+5lo/D5MBk4ZWQb5L9afs6fFyU8aJFht8vt8UBUFrxgRo0nLSLaB/IqEVtmPv/1qxahKShLoiXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788080255; c=relaxed/relaxed;
	bh=029+faS5ZzWsov4hpcUm5x/4rseKLpq/BvplkVhE40Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IeBEFfYdtTZmd/05cRgPpLAfPBv2aZYmzSRFjcNimdya9Yjry6y/HJQJQi46QCCmDKTZetf7sAK8mjAmMJ9D3mi0H21lG7u3bFg7rsjeuRFSFxxqXjNlJshXI3axqmorAUXgVFOtBtmrQFBDH9u14kIDO3GPEUlxtIHu1a4rUaE1KZJ6ooRThLti7Wb6z/abMjnFp72nkjUouV2hKUZEX5M2tD6xBrn88OQXXyVtVXk66PCWLGxkoM3r77Mx6nHRxE6e/gsN3WOLPouD3UwdkV7B3I7FtOyp3o+N6Yhjk2qSKF5lc3V+4v0r6YVzRJwS7uIG4Oo65fHlSjfPHvOYKA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oqxJpBEt; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=baohua@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oqxJpBEt;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=baohua@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hXmGj6nstz2xT6
	for <linux-erofs@lists.ozlabs.org>; Sun, 30 Aug 2026 18:57:33 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 308FF43ECC
	for <linux-erofs@lists.ozlabs.org>; Sun, 30 Aug 2026 08:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062D31F00ADE
	for <linux-erofs@lists.ozlabs.org>; Sun, 30 Aug 2026 08:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788080251;
	bh=029+faS5ZzWsov4hpcUm5x/4rseKLpq/BvplkVhE40Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=oqxJpBEt3n/PrGLolRfZZ7q7RTLGVwOKqEZrxdigyJmNaxBaixGYhIkZxi2c5aHwD
	 zunXvrJiXLvdfJs1+0b3rPl0Y12AJ6soo/nCjQKUUc1BAfJfxfp9TUJdt6hnaVQ5Xv
	 EOylIyrS38eh5Fzk+dcH48n0ojGUMd2gnf020FT3U/1Gcnp3OqcRsb6YSMxUiPJQDF
	 8CefjlqcToWNeNbAvueJxf/Hsb0MyCeMlYp437F6XPwy4Crs8HHWbPfdJdUMQclMCk
	 CPhTPBIGDk+KRETf7XulrJk+h2d4YVk2vmGBwsCXP8eRAnUKt7aRL6YxuvwEqPA/JQ
	 9/X7BSHxiyo4g==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92ed3993c1eso121461485a.1
        for <linux-erofs@lists.ozlabs.org>; Sun, 30 Aug 2026 01:57:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqcJqb+gC2HTL1BJgHLS1ACDJ9FOsQzLyoSjFmBQc+nG4gbHcT1mlFrDRb8om+QS3jqIgGP4zM46G0BBA==@lists.ozlabs.org
X-Gm-Message-State: AFuF++n0kRPn4hISSGqxYoZysPorN/NOsds9XBy4ZHm4aN7D8VMoRnLR
	OSH2i1gVPz41LvOQkpcu483c+4sYKggcRVNR2wQrpP4RR8e/z9fwgfND4DYGuT1NPIbe3bAqDhy
	ZSDYeS6HGf/e8ZNjPU4dCjWTVuR9IKug=
X-Received: by 2002:a05:620a:5d83:b0:92f:279:5953 with SMTP id
 af79cd13be357-939138ae01emr1707149385a.27.1788080250323; Sun, 30 Aug 2026
 01:57:30 -0700 (PDT)
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
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-2-3e8e6850068d@columbia.edu> <CAGsJ_4wUvLoKGafR3U-ji1kUUaz6K_QdN6QxMT-apSaO5tXp0A@mail.gmail.com>
 <6672b30b-427f-45ed-a172-4c47a63d2c7c@columbia.edu>
In-Reply-To: <6672b30b-427f-45ed-a172-4c47a63d2c7c@columbia.edu>
From: Barry Song <baohua@kernel.org>
Date: Sun, 30 Aug 2026 16:57:18 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y8tAh8A8pfi5TJEtPq-JMPjrLX4gCLvesmPNYuZdWCCA@mail.gmail.com>
X-Gm-Features: AcwNN1UV9cGDBED4rxscU4sOzbiEGy-p9iJ4uD11AMCMxh60PQMZXIFRTunlV-4
Message-ID: <CAGsJ_4y8tAh8A8pfi5TJEtPq-JMPjrLX4gCLvesmPNYuZdWCCA@mail.gmail.com>
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

On Sat, Aug 29, 2026 at 11:26=E2=80=AFPM Tal Zussman <tz2294@columbia.edu> =
wrote:
>
> On 8/16/26 7:11 AM, Barry Song wrote:
> > Hi Tal,
> >
> > Thanks very much for the patch. I=E2=80=99m just a bit confused that
> > folio_end_dropbehind() only requires in_task(), and nothing more.
> >
> > void folio_end_dropbehind(struct folio *folio)
> > {
> >          if (!folio_test_dropbehind(folio))
> >                  return;
> >
> >          /*
> >           * Hitting !in_task() should not happen off RWF_DONTCACHE writ=
eback,
> >           * but can happen if normal writeback just happens to find dir=
ty folios
> >           * that were created as part of uncached writeback, and that w=
riteback
> >           * would otherwise not need non-IRQ handling. Just skip the
> >           * invalidation in that case.
> >           */
> >          if (in_task() && folio_trylock(folio)) {
> >                  filemap_end_dropbehind(folio);
> >                  folio_unlock(folio);
> >          }
> > }
> >
> > But we=E2=80=99re applying a much stricter check with bio_in_atomic():
> >
> > +static inline bool bio_in_atomic(void)
> > +{
> > +     if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
> > +           return true;
> > +     if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
> > +           return true;
> > +      return !preemptible();
> > +}
> >
> > I feel like something may be missing either in
> > folio_end_dropbehind() itself or somewhere in the
> > filesystem/block-device path.
> >
> > Do you know why they don=E2=80=99t match each other?
> >
> > Best Regards
> > Barry
> >
>
> Hi Barry,
>
> Apologies for the delay.
>
> As far as I can tell, the in_task() in folio_end_dropbehind() wasn't mean=
t
> to be a generic test for if it's safe to sleep, but rather filtered out t=
he
> known unsafe case of buffer_head writeback completing from IRQ context.
> In contrast, the bio_in_atomic() check needs to be stricter since the bi_=
end_io()
> callbacks could sleep or the callers could be holding locks, RCU, etc.
>
> I see there's some more discussion about this at [1], but I suspect there=
 are
> other instances that are (incorrectly) using in_task() as a proxy for bei=
ng able
> to sleep (like f2fs_read_end_io(), but I haven't looked too closely at it=
).
>
> Additionally, it probably only makes sense to use bio_in_atomic() when th=
ere's
> some deferral path, since with CONFIG_PREEMPT_COUNT=3Dn, it'll always ret=
urn true.

Tal, thanks very much for your reply and the kind clarification. It
seems you're right, and I think we should also use `bio_in_atomic()` in
`folio_end_dropbehind()`.

On the other hand, as I mentioned in another thread[1], I really feel that
`bio_in_atomic()` has nothing to do with `bio` at all; it's really a
scheduler thing. We may want to move it to the scheduler layer and
discuss it there.

[1] https://lore.kernel.org/linux-mm/CAGsJ_4xxDpeaPv9Uh_1qsuXsMLkx+J0X=3D2V=
6342idLFO5jkTBw@mail.gmail.com/

Best Regards
Barry

