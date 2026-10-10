Return-Path: <linux-erofs+bounces-4689-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02D72CA6017
	for <linux-erofs@archiver.kernel.org>; Sat, 10 Oct 2026 21:21:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j2Gqh10FLz2yDD;
	Sun, 11 Oct 2026 08:21:04 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791667264;
	cv=none; b=ffWHQb1N74DkVSsQOmYSNN47E+Dz/ur0qOmGCNQvZw0tdB+MlLMQEL6YZiLB/U+Z9Z95Z2GOTZu4o4jffeYQPDvWl1ufhpLkBV/UxZFrv/peqy+n/QCD29rRNuBGSyBGNhHRrfZ8ZwelLoyTGL/RoOZ8dXy6Eji5eYAhbSIayI0CIYYOBIulWsQ8W6udHTPLNoMdGULkmFBch0VyMVhD7mMYA0RQeTYD3NGgEx7zPZVAikdLsXfIq+Tng0vLdAcRcfIFjNydHXq+7sFgatB/i47zRIGwUwN7fbzV62x8bMrdMs8gb7dWabdvy3PzghbiT9haxD1CYtkOi7EDAh9eXg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791667264; c=relaxed/relaxed;
	bh=48MHaP83/iJcJ8Y4ljdBdoxiH7Nc6HID1h+cGnYzIuI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S23MW7sK0dBkDpIzuGR0I3bkzyYn97oSszDUuMuc+dhVot64wD3iKvPsIwAmtakTS1ZEUjt4VMlsJpw+Ubq8aHKf/x8AqY/6FC5HLhKOGQPy60ZGF6mQ94DSHnOlZGz14A0crv4k2oZltB9vCHDA/CRB08bEGPSeKCApkUW6bjt7Mf/wGtjooCwmEMLjtU2m1IMFU93OmQplqANaklQV9HXNvS7qtFuu9NPccqAT4IQtWHAWwj+01W7lbrWnFlj34C3giH2R7KewHW3R8vumgAO0pTnOH1RXmiQipKFnE+DX5bTavu09nUmgpZ942IX4xuZ6B0eUNgVDwVkk+/YJrQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AkXg3K3f; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AkXg3K3f;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j2Gqg18vMz2y8f
	for <linux-erofs@lists.ozlabs.org>; Sun, 11 Oct 2026 08:21:03 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A7D5602CC;
	Sat, 10 Oct 2026 21:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A751F000FF;
	Sat, 10 Oct 2026 21:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791667260;
	bh=48MHaP83/iJcJ8Y4ljdBdoxiH7Nc6HID1h+cGnYzIuI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AkXg3K3fDmlJCdNOvp/Ztt+uqOFjYq22CcP6fn3kjoXL4re292J9r4Ff2NSStopuJ
	 thBwC+Y1fXxnNwyS7oA94N5i65cs4xLsRAnQTHx6EWuq5zU69QsS88KL575hHQei0z
	 nZ8SKu06RoZoZe5Z3igYzsC79ELfGwx7oAagpC+1kdVop1qUOJRMixL8QB2ulZO1iv
	 Pr2jEzWMavZzmfCiMH6ZXv1+JPCi4j/TkVYbnfOCoby+fioeaMKgEsUGGBap5+BOiT
	 kLFqj+5USzDI08pQUkCV8YdAssNGNek69ONBv3z8pCfokL5/PyeYF8BT5s8UebHOfD
	 ojhI79uE5nX3g==
Date: Sat, 10 Oct 2026 23:20:54 +0200
From: Gao Xiang <xiang@kernel.org>
To: Friendy Su <friendy.su@sony.com>
Cc: xiang@kernel.org, chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>
Subject: Re: [PATCH v1] erofs: enable SB_I_ALLOW_HSM to support fanotify pre
 access event
Message-ID: <asqsNhtlXaEOrEky@XiangdeMacBook-Pro.local>
Mail-Followup-To: Friendy Su <friendy.su@sony.com>, xiang@kernel.org,
	chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>
References: <20261010094000.2036805-1-friendy.su@sony.com>
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
In-Reply-To: <20261010094000.2036805-1-friendy.su@sony.com>

Hi Friendy,

On Sat, Oct 10, 2026 at 05:40:00PM +0800, Friendy Su wrote:
> This patch makes erofs support a use case below:
> 
> erofs file data are not available at local, but need be
> filled at fanotify pre access event handler.
> 
> E.g. when format erofs to blob mode, meta data image
> is store locally, blob image size is big so it is stored remotely.
> At erofs mount, a loop device based on a sparse image file is
> used as blob device. The sparse image file size is equal to blob
> image size. Like:
> 
> $ sudo mount -o device=/dev/loop1 /dev/sdb1 /mnt/erofs/
> 
> Then at file access, need retrieve data from remote, then fill
> into sparse image at FAN_PRE_ACCESS event handler.
> 
> Signed-off-by: Friendy Su <friendy.su@sony.com>
> Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
> Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
> ---
>  fs/erofs/super.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index 0967aace9f7f..b92d3353319d 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -659,6 +659,10 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
>  	sb->s_maxbytes = MAX_LFS_FILESIZE;
>  	sb->s_op = &erofs_sops;
>  
> +	/*
> +	 * Allow HSM to support fanotify pre access event
> +	 */
> +	sb->s_iflags |= SB_I_ALLOW_HSM;

Did you notice
https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/tree/lib/backends/fanotify.c
?

I am not sure why EROFS itself needs to set SB_I_ALLOW_HSM because EROFS
is an immutable filesystem, its data should be considered as a golden
one and it shouldn't be partially filled.

Instead, SB_I_ALLOW_HSM should be set on the backing filesystems (ext4,
xfs, ...), and if I understand correctly, combining EROFS file-backed
mounts (pls don't use loop for this) already implements what you said
above.

And this functionality is already released in the latest erofs-utils
and Nydus v3:
https://github.com/dragonflyoss/nydus/blob/v3/docs/fanotify.md

Thanks,
Gao Xiang

