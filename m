Return-Path: <linux-erofs+bounces-3813-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82A9CC43458
	for <linux-erofs@archiver.kernel.org>; Fri,  3 Jul 2026 01:48:04 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4grxTt4FSCz2yMm;
	Fri, 03 Jul 2026 11:48:02 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::430" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1783043282;
	cv=pass; b=NFBPoRSiyXWPEFXWv30lLuApHGXysSXIg0C8t9EOvPtDJ9jBQO5xbyKjDcdDWn7HDln4BV7kkNn3Jybv7yfqH+phK5tbr/6sA8dLaI+8VgrwHOcsLqo+tfcmwYIiyy2VU/NYmth3wvRnWMXU4uVlf157DjY57S2kEueKuuoebt3h2O10/lh1zWAGkGOGO1G0vXTGiQ+kzkflJ7551fjjCcf+QLvVjrqHqG29ok2aMCC37BNakF97PAp+pT56kHqOxKES5fNFixjztOAeGFkvbkj6dyWPJMAyEP9jl0UQ7VvDTmisdEbbh4y8XJ88jKt36L1M/GFEpKuTRneMusdpZA==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1783043282; c=relaxed/relaxed;
	bh=DOn6vRfEsVTpudhzzAfawUs56a4yn/B/CVb7CXUItZw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zv88SBEVeLcJtUwafKyvkzEkY5E9Wrz43ngi6BEnXsZp3ekLzd77YWn7qj2UmpN6kxD5ClpayAEn3QBXK/p0UV/bJGBJxVI9NVGyhGKwgN56XRfAwFKZ8Hzjd5JwYG+1P+hqptIB3juEZ6E4gkH42pnK63EHtgIheMpEI0KS7DlNmexr8szaCtky6tC0EZTqVWTDVqBvkESzMRL23q+D3vrEXdqApgnS10NY36QyxyNWT7/FPrk9CL/7MVA1GdbrhaqFOxTvzggq2sSgTigj1vfZQF6K2eRgxGpQNW8GmKzI556HzqoRTW5nNnbZrNDHpf3xouVS9tpkHzNG3Sy2pg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ghL7VK0W; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::430; helo=mail-wr1-x430.google.com; envelope-from=joannelkoong@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ghL7VK0W;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::430; helo=mail-wr1-x430.google.com; envelope-from=joannelkoong@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4grxTs3zpDz2yDs
	for <linux-erofs@lists.ozlabs.org>; Fri, 03 Jul 2026 11:48:00 +1000 (AEST)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-4629051c946so28069f8f.1
        for <linux-erofs@lists.ozlabs.org>; Thu, 02 Jul 2026 18:48:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783043277; cv=none;
        d=google.com; s=arc-20260327;
        b=hA6k7iKTPH+lv1iRxmGwe3S1Z9WU3Zx02V3KAHc2lQ4zk2ha91PiIZRWWG7RZZo6k1
         Q6LoTJsQk1AbcEI4Oufv2lZW498thOTk4CdBESYYVANAbiCiEXtdhHMfEVGPrE1WLXas
         PJP5hliRqCVrVEO45zAUKDCJ/bC+ZpOlqYGEPT/RP3VKdtJ3qhgIs8W1Cs92TWhK4ShT
         hHWeL2gq+zW50eX/pyblNU/GkaP1B74uf2uCR0ODSEhepmkuYflkAzk7ZFLOIywNZyMb
         g4fr6rWbNC2nygsCi3qV+t9XUkWtYMMDNcXYduM0Q4S4AxX2xp0sVpcHhae4oASWaVDm
         Mg5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DOn6vRfEsVTpudhzzAfawUs56a4yn/B/CVb7CXUItZw=;
        fh=b86rrpwAiriXyRz/jmHQv3kgKIFbJBumChEhumh/NaI=;
        b=cnCiA2g91YHFFEsJPnsMGYxoDScpuYp9aKBtEi2C7pJ1YnskECI35bTyhUJVuQRrWC
         9R1Bfg8qWtB3ygMJE5kPiym1u2N69WnkOIEztukCcASU9Q+ix/rq6iXJeLcr90GuBbDR
         dlk4mTtmCk1T0Q5SWRKHKkkp1YZTGF6rCTMBsw6G4GuTgTNBy6WWLazGavSWaRKZNSO6
         1NxEOHYjyZZLwTQZMN4L9y+GCfNB2OLjdcxirRB5NdcJmkUDcL06L3a40c9koPa6j/He
         Pal7Jsf/6ofTLsCeViHdM8A5vcgNoz1AIUdq0niyJknMcEleGHburcq5p1hgctqWZx6V
         qH4Q==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783043277; x=1783648077; darn=lists.ozlabs.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DOn6vRfEsVTpudhzzAfawUs56a4yn/B/CVb7CXUItZw=;
        b=ghL7VK0WXn7IUZSsASykUarRTNbJqQirzCiEstESmRYWfgQYgdhbBsKLTy4Ll9SoPi
         2mSQSj1pCXKu0KlsBGnSWvrG9Wsh0h0vFLmDAL9dkwxGW1OtKB6ncrWIhoviW9ezobZ1
         YVG24CN8/jrgQy2IIKnfaO8qAvoUt+PlzERRYFN01/nvHaIkNmVuQyAt7czHJbUhxQRn
         ilwhgUDVgladToP28MOqwPyJZ63dEW9SKa1XEp86PYv8Em5VGaysNwP6hMlbEHO91nZG
         XSkc/3+0vr9o/6YUx9yIacb6WfTaAyhnQ0enPgDD+vM5ZoYCkHsQwKBJLUMBCNgS8yF6
         5Bnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783043277; x=1783648077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DOn6vRfEsVTpudhzzAfawUs56a4yn/B/CVb7CXUItZw=;
        b=loO017SbbY3IeS6By5aebDs0cRk4+VXqSWYVTGMPwXQGgS9BN52CcwKqhsnDSOGst5
         dLn1Esn+61gDjEMpXBX1nOLspL8+bq2LmYZFqCLulKel0SThPXTKpgyVIX7TBfJyn1XZ
         rH3s6RdSBx+0NKmcC9l08dvRUuXZRC81SF6Iu89i1XS4n3VOos4oTuSgBuWFL2GCBrXB
         iVH8kQa/R6QVIR5eL6b8rbZXqHSXmlu+Dni80Pr/gKXu3gs0p1LdSaxemjYrBN6zXPLD
         8XfeIcyYu/gXR12R+Y1ufG44C09PehhVh73isolIUq0BdW/xY43nVhFQQfyytS35Kv4l
         vEHA==
X-Forwarded-Encrypted: i=1; AHgh+RqoG9+VZO6wcstKavfaB6gn5WrWCvy9p+4/5hDVjy/x4x/Q7fBTNVE2+UQCt6+1GgkfElUE6QbOuIF6lw==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Yx2iDPYNyXJFPq/63RN0l6oGE3HxGrE1SbasYRP+fbW+61/7RHp
	GZEVBVDJ3GqDdDE9Ym2po9WOmJUulknU4ql54WsPksocqaaHLzGIDq8/bHFRj46HdM2TMkQ3yH/
	25Ce3HQRqmDqrTQUOcZX/NA3TNntjvvg=
X-Gm-Gg: AfdE7ckAXBYLgu8huofmy9QmAUUYwuwgeDtHQ8THiHL1FqvFU1MiaSWYCAOXlHYdJu3
	L1CEsGoCZplqfXpulI5QMwDqU1uRqLB+WgaOyjg0Yohs3xl+5Qmn6ISSa3DE84grouqi4dcKtwm
	tSbDbd362TLveLYfxVdIWzonbm9IFGYEl2PB85IBBGvuj7gTltx7NnQWy9L6HYqj5kFYAmzhbC9
	EjrvThWzILa4Xx3wpBYOqsnf5NOEXocqFjsosZ7glxDpMoEYcODlU/kN7rsrjRYbyrgQceT8CB1
	VdBxg5jEi9/l/WzE2Xb0V3iHuA+veBfLmOPngk5F0K7JCjdeEb4D
X-Received: by 2002:a05:6000:188a:b0:474:88ef:cdec with SMTP id
 ffacd0b85a97d-479347abc89mr3414307f8f.6.1783043276701; Thu, 02 Jul 2026
 18:47:56 -0700 (PDT)
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
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-18-joannelkoong@gmail.com> <20260702140705.GE21339@lst.de>
 <20260702165117.GK9392@frogsfrogsfrogs>
In-Reply-To: <20260702165117.GK9392@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 2 Jul 2026 18:47:43 -0700
X-Gm-Features: AVVi8CdwjVgCnc8OibEiAJiLFqrCHykAhTtcw0AOMmm18cQj3dSCo5Q-SEBvMhY
Message-ID: <CAJnrk1b8j5WHtbHOWNXc4=QBFOxde1f2QxTOeui7Ta8O-xWcTA@mail.gmail.com>
Subject: Re: [PATCH v2 17/18] iomap: pass iomap_next_fn directly instead of
 struct iomap_ops
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, brauner@kernel.org, willy@infradead.org, 
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Dan Williams <djbw@kernel.org>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
	Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>, 
	"open list:FILESYSTEM DIRECT ACCESS (DAX)" <nvdimm@lists.linux.dev>, 
	"open list:EROFS FILE SYSTEM" <linux-erofs@lists.ozlabs.org>, 
	"open list:EXT2 FILE SYSTEM" <linux-ext4@vger.kernel.org>, 
	"open list:F2FS FILE SYSTEM" <linux-f2fs-devel@lists.sourceforge.net>, 
	"open list:FUSE FILESYSTEM [CORE]" <fuse-devel@lists.linux.dev>, 
	"open list:GFS2 FILE SYSTEM" <gfs2@lists.linux.dev>, "open list:NTFS3 FILESYSTEM" <ntfs3@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 2, 2026 at 9:51=E2=80=AFAM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> On Thu, Jul 02, 2026 at 04:07:05PM +0200, Christoph Hellwig wrote:
> > Looks good:
> >
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> >
> > In terms of merge logistics, I wonder if we should delay this and
> > the previous patch to the next merge window so that we can minimize the
> > cross-subsystem merge pain with more file system iomap conversion.
> > If none of them actually happen until rc6 or so, orif  the merges aren'=
t
> > painful we could still pick them up late in the merge window.
>
> I'd say everything but this patch should go in during the merge window
> for 7.3, along with clear instructions to brauner/torvalds to expect
> this patch to appear right before 7.3-rc1 gets tagged, to clean up all
> the other changes that come in.

Just to clarify, did you mean this patch and the previous one? If i'm
interpreting Christoph's concern correctly, I think he's worried about
other filesystems converting to iomap using the ->iomap_begin() /
->iomap_end() functions still? That sounds like a good plan to me, for
v3 I'll submit everything but this patch and the last one and then
submit these patches (and any cleanup ones that become necessary) to
Christian right before 7.3-rc1 gets tagged (which as I understand it,
is when the merge window is about to close).

Thanks,
Joanne

