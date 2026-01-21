Return-Path: <linux-erofs+bounces-2126-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B2CCC44508
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Jan 2026 19:00:21 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dxD6C3HSBz2xqD;
	Thu, 22 Jan 2026 06:00:19 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::636" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769022019;
	cv=pass; b=onq59Ck1ElXYoBZFyDQFGE0aeL8DqhIUcZ0+IBaXnEPd8bSz6551F9giFIUzh9Cfb251EC2EsudJen/ovv4v3KWqvNJT4kIZ6UxKjONm7bs3M83NJo0jpf+pTtnoY+qdJrd2/U2pxPBA8rz+8B+Us7xq69AyiOq+cOWrUFEr328drnSlV6oLXk5z7es6Y5ijkCzFu4iLSM+wsr5tJrerC3nEbhhPTFnzOhV+nF8gY/CXJFmnJWWDxXgR52cCIUKc2QO1ZkwLUwrei96ugvKobF3QgQDHzMbVAxfxGwdGQBgsjOOi8Q0hVvxNUT5vzYAKOXk+K5oASIcUZILRqsUFew==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769022019; c=relaxed/relaxed;
	bh=P50vKKEGRcti/ilk0zXXEyTeAkMnj2pLP0nOzx4jcho=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h1SkbwFCRX3XgDA/dtey6J+CdyWxMqJSDuxVj7iBF8gwbJQZOKMLxvIxQTHIlej9qOeSJwsI9eUqogCKAB0Bbu0hPwqZKqqvV3iCMIVTegW6ERav34wlhE/3yctMUukBsV6YwPatLYZc4Ho/iwXyYbkpMyrNlRhdSxNXwq8nNOgKNx0R5Zqw+zXCcgGZ/XZ0zmI3Iro672Wk0574Bzm0y/z1RcbawzXmIaiTLoMNLFxWbGNDaxdpYmKbyz/mBPsCzp19TTkEcynzMFgv17fOPrOOzvMJvkywIrRNUQkkgkBFqfVRLsmkbZDxguBoJ38GLSqd5GmlN8TTs7XOPgkSTg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=IOuyrR08; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::636; helo=mail-ej1-x636.google.com; envelope-from=amir73il@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=IOuyrR08;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::636; helo=mail-ej1-x636.google.com; envelope-from=amir73il@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dxD692SXLz2xpk
	for <linux-erofs@lists.ozlabs.org>; Thu, 22 Jan 2026 06:00:16 +1100 (AEDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-b87693c981fso20614366b.1
        for <linux-erofs@lists.ozlabs.org>; Wed, 21 Jan 2026 11:00:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769022008; cv=none;
        d=google.com; s=arc-20240605;
        b=FrdM+EY8SnluYsUjHHvRqMhVG71QufAJVCQEvUcRbP+z02K+L7TS2rdHBeP4rIXw+C
         oPLHEdhZ0ymmdQcOAjF1h9cKgAXRIcvcZM9be1lkBRqfGMKfo3VSJiE94ETPKbFPrVro
         SfAK+Iq/tx9W99bqbUhPZ00WvOZIzi8amcNWbqQprxraLnaQs1dRFAAw3ygx8vT2pml9
         5MdgQwgTvedLULjvfH9m5kjb0FyPpcLZpZ+Uh/B6xoooj3JxD7y5l40bZTDrM/H0IJDO
         oPD1pHHoLeGWeBV7FPO7xXSy+KQB69OX6Fbj1FGyufHV/JE10p8kVMqpnJCFseXe1cFm
         hONQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P50vKKEGRcti/ilk0zXXEyTeAkMnj2pLP0nOzx4jcho=;
        fh=TEfH7YbsoU56iLBUzE1f+U+89Rs/YDWRHf6xtq7W4g8=;
        b=YsG+WwLU6cG9WK9AsApKDgdxeKolNAOv3xd9TeNxxd4QOYHkhFTCM1oBqXwSxn0LNz
         jyJ0hZKwKPPdZLwb9XLQ/UYiyuA3xvSvnfY1cAM6hNz+dicjy3Q3pt61i6vRwvVxtFWN
         3v8feHrtDWA937KGHxkhWEZkdGNOtDvz3EgYiyl0pBm+QhIZx/jobE4GxFLFM9vBZ+Ez
         YPNKEypp6rchqM9s8/opB3bZ9A0qHnNdcgi7mW89/xpilVhO2zR6vIjBgO1Ray+n/kvn
         Zg1mnOK3QFyXorj+bdW3VGaDk7FbfloR5p6oX6Q/7HiS2M1DZULdMpwKvAiOaYmRnaNc
         QZaw==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769022008; x=1769626808; darn=lists.ozlabs.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P50vKKEGRcti/ilk0zXXEyTeAkMnj2pLP0nOzx4jcho=;
        b=IOuyrR080iOA899ACpctaBeHDLS7EsB/hJyInoiYfiyKXSn416jBNgi6K6S5uK72N+
         8zJ6R0BPIrd5rPFYzqNNQU9dd62cBH3+92N59wx46cBOXpeIpqaOuPv2C0L42cMMIzqW
         Y1/1p3YEgzadTavkjufjh22U1SF1yseYDwMPCHf5Wspx+RG0jvXjxAsAWc5ga7f71svB
         Y48dP4espKN2pbRvOM8jQ7eys1lfSEr3EAOcE0tF+bg1/6mspCIPhAYWTGgAj7FX+5J7
         Ddmmcu6/+Gr38zJyKaDg9Pdc9uDu1D0L8qxSXgQRT8jd3lN0xRT+DCAe46ECNOaWF8kN
         V68A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769022008; x=1769626808;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P50vKKEGRcti/ilk0zXXEyTeAkMnj2pLP0nOzx4jcho=;
        b=Pu2i/RSq9fQ6pom46SuxT/BJYaIeStxiNEHd4rGPJCCpThUnoBzl7bxtazUAHChekI
         tkhPuhN+Q9Rwjm0p7AD9uc5JQP/VCbOjhPX9ys91BI5DaDeAHM1f8vuZodmTGXAB/NQq
         nqiy19qt0G+5kCCdBMAP+L+47EtIcEk9MSZfIEQ3tgI+1xXFUp9oQk/mhugGTGKTQWXG
         ovbUai8EjSOR8qPjHrfaXFxz8DVAeZ5yiRcVe425rPHb5sXiOAbcTE6p37LmPf8N+zR0
         VtuVV0FbBMAbi7CA2DsjptRveyK/43Kg6iA7mLaVl62FATFy0uXRzlcTKjmIhC4YDLhp
         NmLA==
X-Forwarded-Encrypted: i=1; AJvYcCXImfl15GwhDGFaCcR1wXye/IDgipzax5VoiRu7wFSJvBEfSnObd0siBGa57gRDw8/WjC6oyVHGXoGlGQ==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YzPIYRYoe4BIdi06FZ9lEz12DWOvFc2sV7Mfqmfkq0nwPuxQWPS
	3UWwcZCkUO4Wb/KlAKdKXK41e69cl4i1d5niZPXqZBJyj9Pyx7Wq21yPpYe5gLUmH6Aee4H5QBJ
	X4xLX0OcDEK9KO98cvPkiv3IFj3kUF90=
X-Gm-Gg: AZuq6aK/3RFostwLtd4TsNvMmt0U0FQEKU3DxqZGTQ1W9MYzcTddd1dpVwZTdz+ATIG
	Di9UQFMW1syWCBxW1ipHWG99svaxoNdetP6Wl22FMGCtZ36jrGhT97a9C/a4Ky+QOWYX2yjtQqi
	NSGAIb0+G2TItv6D7JOS9sx0pT2IcDMJBzbhkHIrXuQKnyXZJ/hBRQb+n0y903qKbm1bE+QM/yo
	vvNJ6b53j4KIRCp+ioMroxVzwUL+KuZXq7GQdgsSCIxkKTA+hdxgHJK6a0S4z3p8GvpiM4wkbR7
	2wlzFSIHqVr+JM9S+xwN890Z5Pk=
X-Received: by 2002:a17:906:6a13:b0:b87:206a:a23b with SMTP id
 a640c23a62f3a-b8792f79852mr1477117366b.34.1769022007470; Wed, 21 Jan 2026
 11:00:07 -0800 (PST)
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
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
 <9c99197dde2eafa55a1b55dce2f0d4d02c77340a.camel@kernel.org>
 <176877859306.16766.15009835437490907207@noble.neil.brown.name>
 <aW3SAKIr_QsnEE5Q@infradead.org> <176880736225.16766.4203157325432990313@noble.neil.brown.name>
 <20260119-kanufahren-meerjungfrau-775048806544@brauner> <176885553525.16766.291581709413217562@noble.neil.brown.name>
 <20260120-entmilitarisieren-wanken-afd04b910897@brauner> <176890211061.16766.16354247063052030403@noble.neil.brown.name>
 <20260120-hacken-revision-88209121ac2c@brauner> <a35ac736d9ebc6c92a6e7d61aeb5198234102442.camel@kernel.org>
 <176896790525.16766.11792073987699294594@noble.neil.brown.name> <ccb32c576cc4ebf943d5ec35e3d7ba4ae8892acd.camel@kernel.org>
In-Reply-To: <ccb32c576cc4ebf943d5ec35e3d7ba4ae8892acd.camel@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 21 Jan 2026 19:59:56 +0100
X-Gm-Features: AZwV_Qh050IhjThhArfxNo-53HjJR0uLCcITEQOtntS-75Lw875opD6ONQssxps
Message-ID: <CAOQ4uxg+dC1o+6V7Nvxf8UW3H=0OvsGjEe76LNY6q8ZcpGDDJw@mail.gmail.com>
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
To: Jeff Layton <jlayton@kernel.org>
Cc: NeilBrown <neil@brown.name>, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Chuck Lever <chuck.lever@oracle.com>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-nfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, devel@lists.orangefs.org, 
	ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 21, 2026 at 12:56=E2=80=AFPM Jeff Layton <jlayton@kernel.org> w=
rote:
>
...
> > But if you really really want to set this new flag on almost every
> > export_operations, can I ask that you please set it on EVERY export
> > operations, then allow maintainers to remove it as they see fit.
> > I think that approach would be much easier to review.
> >
>
> We could probably do that, but I think the main ones that excludes it
> are kernfs, pidfs and nsfs. ovl and fuse also have export ops in
> certain modes that exclude NFS access, so the flag was left off of
> those as well.
>

For the record, my comments regarding fuse_export_fid_operations
and ovl_export_fid_operations variants were purely semantic -
it did not make sense to mark them as _STABLE_HANDLE, but
it does not matter if you set a flag on those ops, because they do
not implement ->fh_to_dentry(), on purpose, they are not
exportfs_can_decode_fh() by design.

Thanks,
Amir.

