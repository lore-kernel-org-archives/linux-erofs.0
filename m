Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326DF606A338
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 17:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LWj9kUC8
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSwNR2zXXz2y8m;
	Tue, 17 Nov 2026 04:49:27 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794851367;
	cv=none; b=Mgu0nkj38jpDWSLmvkwu5tjd6H06GvJUs/GjK9snkWTr35pNAyUVV7FYrHf/mJ/rcnVt9YpQdxy71fwD4efLYda+aykKqEDQkG/44LtibOEc4pgzIFZiuQAHuvEESyJxbKs2qdJzoYl3bx+QGBElNRqa8umjKJa+E5JOydYWzCPy9ufbzwwkeVmu8y3vA60/g3MK3DvDwXxxQRLkPBU1NUNGWft2C6uekcVVpT1kU5pblsKnaFe+mmaKQKB35qOkQVkCzI3LFXiz6C9JQP778+NJk1lI0G/PSo+MtUA7xJNvOXap9u9isX7bUbyQrNEt4tYS25mVUknRpOXDggz/bw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794851367; c=relaxed/relaxed;
	bh=ED8m1EUNyZbVy60KlCH1nfmXFCVOvYy5WXRoQrkl9dY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DJ/dTgOTTwo+HN3WxhAvWUEkdOWmkDplo2capDx4sVhzww+UJdZwx26COg6eTGxoK9YAYjZbD8aKpbtjsME/BHeMGzYMg58yRw2d/HN2NGKjXRmj0CisOda0dKFJu8UboHT2vzdh68V38QCRatjSwQgw54qAUodug5TNIBxucp3KmYMeijfeAu0RDiL7ipDIrddgjK8j1bKsQPDD+G8x7ieUnuacRb0DjiTNhxlUfBwk9Qf4IRVHaBt1cxafAkwWmk2IbQJdQXB3qaX4ANQ40jnqtOzDAvA+aOZW9fsKTi8Qis60EKiYbgnJ6O6TtpB74isXoV8BEwCUwMWK+TYSzA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LWj9kUC8; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LWj9kUC8;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSwNQ4F1bz2y7p;
	Tue, 17 Nov 2026 04:49:26 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A06146147C;
	Mon, 16 Nov 2026 17:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A261F02813;
	Mon, 16 Nov 2026 17:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794851363;
	bh=ED8m1EUNyZbVy60KlCH1nfmXFCVOvYy5WXRoQrkl9dY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LWj9kUC8kQFC5SfD1vjbud2HBFDNnZqFBwsM7D7EkixcrkbHslvvXUPplnT67OEDa
	 Ojxvc/9bBfh+7M7IgMwLe0/MW3vEZ7MNK475jdjW9gzIKFiwKQYtp2o3epkEHr1OUY
	 ut8wZMtQ6WwDI4R/4NjZmngdKNKdP+t6PoX5HnYwVJTKEbOQrvDnGzw7NTHVCoa2iV
	 Az2pSjHFx32LhMnzCRrFLDjD1DXtR7qLBdQXkQEuVAl0z7iuGlB/eKvhfmNtzTqNut
	 eiuM63/QtPtS1+8sCvNSNotSJGDSOZKb/xcO1WCvyJtafHJlrptV+MYpMU1CW9c9N/
	 f6aB01Y3d7oMw==
Date: Mon, 16 Nov 2026 18:49:14 +0100
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
	linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC v3 33/44] ovl: refuse data-only layers on pseudo
 filesystems
Message-ID: <20261116-kriterien-getoppt-kauern-5a0c1fba70cf@brauner>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
 <20261116-work-loop-pseudo-v3-33-8cbbea1cf34f@kernel.org>
 <CAOQ4uxgPerkkG4ie0SyHVXaBD9VZN2wYfQpEAEi4hytn=ara3A@mail.gmail.com>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxgPerkkG4ie0SyHVXaBD9VZN2wYfQpEAEi4hytn=ara3A@mail.gmail.com>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 06:37:16PM +0100, Amir Goldstein wrote:
> On Mon, Nov 16, 2026 at 12:10 PM Christian Brauner <brauner@kernel.org> wrote:
> >
> > The data of a metacopy file can live in a data-only layer. overlayfs
> > doesn't look that data up when it looks up the file. It only remembers
> > the absolute redirect and looks up the data lazily the first time
> > someone needs it. So until then nothing can tell which filesystem holds
> > the data of such a file.
> >
> > But a data-only layer has no business being a pseudo filesystem in the
> > first place. All it does is hold the data of metacopy files and the
> > regular files of a pseudo filesystem are kernel interfaces, not storage.
> > So let's refuse data-only layers on superblocks with SB_I_PSEUDO at
> > mount time.
> >
> > Data-only layers can be added via the "::" separator in "lowerdir=" and
> > via "datadir+" by path or by file descriptor. All of them end up at the
> > end of ctx->lower. So a single check in ovl_get_lowerstack() covers all
> > of them.
> >
> > Note that regular lower layers on pseudo filesystems are left alone.
> > Stacking overlayfs on top of sysfs keeps working.
> >
> > Suggested-by: Amir Goldstein <amir73il@gmail.com>
> > Link: https://lore.kernel.org/all/CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo91QjJHH9T_Yw@mail.gmail.com
> > Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> > ---
> >  fs/overlayfs/super.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index 39d4d57dec230..719c2569dfeaf 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
> > @@ -1237,6 +1237,14 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
> >         for (i = 0; i < ctx->nr; i++) {
> >                 l = &ctx->lower[i];
> >
> > +               /* Pseudo filesystems don't hold data for metacopy files. */
> > +               if (i >= ctx->nr - ctx->nr_data &&
> > +                   (l->path.dentry->d_sb->s_iflags & SB_I_PSEUDO)) {
> > +                       pr_err("filesystem on %s not supported as data-only layer\n",
> > +                              l->name);
> > +                       return ERR_PTR(-EINVAL);
> > +               }
> > +
> 
> How about we make this just a tad more restrictive:
> 
>                 /* Pseudo filesystems don't belong in composefs setup */
>                 if (ctx->nr_data &&
>                     (l->path.dentry->d_sb->s_iflags & SB_I_PSEUDO)) {
>                         pr_err("filesystem on %s not supported along
> with data-only layers\n",
>                                l->name);
>                         return ERR_PTR(-EINVAL);
>                 }
> 
> I could send this as followup patch, but since this version is simpler
> there is no real reason to have the intermediate "only ban datadir" step.
> 
> Only the commit message needs a little more flexing to justify this.

Just sent me the diff on top of the series and I can fold it with the
commit message you want and slap your Co-developed-by and SoB on it,
please?

