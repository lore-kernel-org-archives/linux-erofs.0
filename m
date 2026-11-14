Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98CE606A323
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 21:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FIy92zB+
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRnwY6XPfz3cQP;
	Sun, 15 Nov 2026 08:54:53 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794693293;
	cv=none; b=U4uqdkR3soT2NPpAGj6g9b8IL7WXphrfVJb5FBVK+THwit9Nq9zCG9XXd4TkZe5srnNAt+pwJXx8LFA/4gJf2GK6MMD/0ETQPauEuedK4jehkf0fpvVrRalpoLQuQFXCXED0h4BiQn9+WDIrO6hqpZYbiJ5FM5gORKiwYELpV5ISGBaFwGgbUtWCatGyF2oX8grk91KMZOqBJvR+TOdX+A7+wTjMjv9F52twc0sIZOp57HQF4txfxDEQwSL66UzH0quPH8q4Ily04zJYsYRLyf0jZulvdaiGvYXDjilODvD5C/HKzR0wsRlW6XO53tPIQKbW/dGl2Lnd3RUO43ehjw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794693293; c=relaxed/relaxed;
	bh=MU5XNgGhJm4qGtdrFglh8iv5ciWWvcUh9TpKkyBJYjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WDXNB+DptQtLYmh2yzS8CS9yEnpiizE1aYhdRD4Xpi+XPBWkqD2KXBHxzkQEIZ1VuZXn3+yMV+APKK3zZoPw/psSb4jEL9Y0NUZKG8s79SWf5wYYBxCBqn9V5ZKloBVJtIlQkuvB/t7FXbcbs7qF7bggp1wKRi0WbSdq3HXYVJRLulTbtENGTwtE+INWAMQuta5ePvNGOx4hZ8lkHjzNy9DLEMKI4uSFjajmCatPiP1AW6iNndyJgOUblOAHGlblGuHX5rYqfN1Mew2eB+pj4PAgr8exdUa9YoRa3PcRcctsdilHjtMFc2GT8aUsyvTPsfWi0+Tbpax9vx0sPkfV3g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FIy92zB+; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FIy92zB+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRnwY0zvCz3c58;
	Sun, 15 Nov 2026 08:54:52 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E15E0447B9;
	Sat, 14 Nov 2026 21:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCA71F000C4;
	Sat, 14 Nov 2026 21:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794693290;
	bh=MU5XNgGhJm4qGtdrFglh8iv5ciWWvcUh9TpKkyBJYjo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FIy92zB+Q6XXV11Bx9r1d6hblgiehsd1O2WYa4ANqHuoaMNzzpTo/kyfrrl5vWJqU
	 ntQlUQLehZaQBgb5PHB5XgsgvcpzvDKacjzaPI1D0mhsgTUlE44bsX7wUuFZlbKEVy
	 2bf9iGRkxrODGLkzXesChHlOpfKM10Ar21sYj0wFzavx9W02CRh/nVciBf1lbn33of
	 RFNAI7U3T2zGoe8QK8NctZ4IPimWP2/h2Wjo3dajkFGo7hKnMdTyDdQrkd/NIOxJeq
	 4KueXIk2XzkN6Oe+3U49dByhB2/gIMk6xuZPod2J7aymfou+3hjeBLx6QqpqyydE14
	 fsnMkL8jCu8lw==
Date: Sat, 14 Nov 2026 22:54:42 +0100
From: Christian Brauner <brauner@kernel.org>
To: Chris Down <chris@chrisdown.name>
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
	Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org, 
	Alexander Mikhalitsyn <alex@amutable.com>
Subject: Re: [PATCH RFC v2 17/42] securityfs: use fc_init_pseudo()
Message-ID: <20261114-wohnprojekt-rational-ersetzbar-b338c88cba70@brauner>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
 <20261114-work-loop-pseudo-v2-17-98639a2286fb@kernel.org>
 <20261114120555.cbfaf8ab8a92fb25@chrisdown.name>
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
In-Reply-To: <20261114120555.cbfaf8ab8a92fb25@chrisdown.name>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 12:05:55PM -0800, Chris Down wrote:
> Not a big deal, but userspace can see that node too, as
> /sys/kernel/security/apparmor/.null. Opening it by path works in current
> kernels and fails with EACCES after this patch. Now, I don't know of
> anything that does that, but selinuxfs gets SB_I_NODEV cleared again in
> the next patch for the same kind of node, so I think we should do the
> same thing here. If not, it would be good to have a line in the
> changelog saying that opening it by path is meant to stop working.

Yeah, seems fine. Though, afaict aa refuses every read and write on
.null in aa_file_perm(). So this change only moves the EACCES from
read()/write() to open(). But I guess open() failing might be an issue,
idk.

I really really dislike this device node abuse on for both lsms. It's
sketchy as hell.

