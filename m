Return-Path: <linux-erofs+bounces-2325-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E55FAE9A03E
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Feb 2026 21:14:43 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fFspp0c8nz2xGF;
	Wed, 18 Feb 2026 08:14:42 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1771362882;
	cv=none; b=g21dLySQxFdJxS8avy7V+NKxyQrFMQSjgz24WQPM+Voy0d2zFjbLMoKGUchRP8ozcnGCB4pzegxB5UuoMZl8leCQ2t2rP8m1EvJm6zbaprleekNSU/IAliQcrkocsR4MDekBLNjZ0edHIKFMvDVgfJMskRtnMnWYfrpbQQmmCipSrEdKDv3lSDgw+ivUKnh5Pa98xWgSvmwrEgS7f54JOqB9hbAxM7IYEXCpfH9MrisHvsNxgzrg7oB2tiKsvR1noL5upl+pj9LuUZBMeQnoC1Ju8GCO+495zkdQ1CsDpBmVoJf8FxDwnGxo2iXSiSRM8bZhcnhn+YEFspH2xp61DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1771362882; c=relaxed/relaxed;
	bh=/QAFZrzsR3b01tUvyixH463bVn8gaQeXSmMleluN4G8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=UzKlAn8TEeCx5QMOaBxtzB9DRoEq415CKU4XSij3MTyMpBDnPB+qRRJ1fgvJnKSvSxL0QPA4A1KfYSfIF9QKGh+9V/2HOWGnV5jBWSkrC4l0dFPqJaSoYPG0xs3KlMHrLdb1BhJ+MT7HyVI2m4KMadunc8i7HFMH4OCqR5RFhL+fCcsv4z4hdbglhYHzhfdUQmSLEkb6hmDuR0ArWAZwaF+xaPSly0X8sA7u7pZZnxwmxCiKFC4eiovVuDUhfQ8Y4zHyxCJx8K9baiBZh1RPMTEzkDS0QMGFDqhc9wtaLO2+P3vEaBGJOmkkemSXMUxLGgekM5WQomKqoEeG6bAAqg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=qME5lVPC; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=patchwork-bot+f2fs@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=qME5lVPC;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=patchwork-bot+f2fs@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fFspn0kmZz2x99
	for <linux-erofs@lists.ozlabs.org>; Wed, 18 Feb 2026 08:14:40 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5CA3D60128;
	Tue, 17 Feb 2026 21:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05413C19421;
	Tue, 17 Feb 2026 21:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771362878;
	bh=SWr3Pg6zIeu2S3Z6UDsk8BzZU6tf527GPJ41POMlghM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=qME5lVPCgbs75GtVkYDVSedStUuy5Pu7iKCY4IKu3xqN3EcQE+Oh5yA77hoZy7VyU
	 +0wZZYMpZQVXM9oVuFBmRCNz9ULENuT2B5em0ouDg88Yb0OXaPujVB/GBPkgNNMpHr
	 EhgPO+uLpu1WI515RTCnoSYcSuoUoWHPdRcl280BUTS4HjHiimnSyoFiD+9+NmEu7s
	 4m0WVXB/a1C6i48qotqtPrvf49sFdMixg5MNCldkNycO7JhTW+IJtnP0WEfZw+8dYi
	 1uYBY6iDz7huxRyc2w6LATusfRgMkVW0RAKYcp9Uufer3E7jADONKO2Apo8cM0wFiU
	 pB1OIFY+N5Jzg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 0B1123806667;
	Tue, 17 Feb 2026 21:14:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
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
Subject: Re: [f2fs-dev] [PATCH 00/24] vfs: require filesystems to explicitly
 opt-in to lease support
From: patchwork-bot+f2fs@kernel.org
Message-Id: 
 <177136286957.643511.1991968143318289235.git-patchwork-notify@kernel.org>
Date: Tue, 17 Feb 2026 21:14:29 +0000
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
In-Reply-To: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: luisbg@kernel.org, salah.triki@gmail.com, nico@fluxnic.net,
 hch@infradead.org, jack@suse.cz, al@alarsen.net, viro@zeniv.linux.org.uk,
 brauner@kernel.org, dsterba@suse.com, clm@fb.com, xiang@kernel.org,
 chao@kernel.org, zbestahu@gmail.com, jefflexu@linux.alibaba.com,
 dhavale@google.com, lihongbo22@huawei.com, guochunhai@vivo.com,
 jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca, jaegeuk@kernel.org,
 hirofumi@mail.parknet.co.jp, dwmw2@infradead.org, richard@nod.at,
 shaggy@kernel.org, konishi.ryusuke@gmail.com, slava@dubeyko.com,
 almaz.alexandrovich@paragon-software.com, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, hubcap@omnibond.com,
 martin@omnibond.com, miklos@szeredi.hu, amir73il@gmail.com,
 phillip@squashfs.org.uk, cem@kernel.org, hughd@google.com,
 baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
 linkinjeon@kernel.org, sj1557.seo@samsung.com, yuezhang.mo@sony.com,
 chuck.lever@oracle.com, alex.aring@gmail.com, agruenba@redhat.com,
 corbet@lwn.net, willy@infradead.org, ericvh@kernel.org, lucho@ionkov.net,
 asmadeus@codewreck.org, linux_oss@crudebyte.com, xiubli@redhat.com,
 idryomov@gmail.com, trondmy@kernel.org, anna@kernel.org, sfrench@samba.org,
 pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, hansg@kernel.org,
 jfs-discussion@lists.sourceforge.net, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, gfs2@lists.linux.dev, linux-mm@kvack.org,
 linux-mtd@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-nilfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev,
 ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, v9fs@lists.linux.dev,
 samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org

Hello:

This series was applied to jaegeuk/f2fs.git (dev)
by Christian Brauner <brauner@kernel.org>:

On Thu, 08 Jan 2026 12:12:55 -0500 you wrote:
> Yesterday, I sent patches to fix how directory delegation support is
> handled on filesystems where the should be disabled [1]. That set is
> appropriate for v6.19. For v7.0, I want to make lease support be more
> opt-in, rather than opt-out:
> 
> For historical reasons, when ->setlease() file_operation is set to NULL,
> the default is to use the kernel-internal lease implementation. This
> means that if you want to disable them, you need to explicitly set the
> ->setlease() file_operation to simple_nosetlease() or the equivalent.
> 
> [...]

Here is the summary with links:
  - [f2fs-dev,01/24] fs: add setlease to generic_ro_fops and read-only filesystem directory operations
    https://git.kernel.org/jaegeuk/f2fs/c/ca4388bf1d9e
  - [f2fs-dev,02/24] affs: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/663cdef61a27
  - [f2fs-dev,03/24] btrfs: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/f9688474e413
  - [f2fs-dev,04/24] erofs: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/f8902d3df893
  - [f2fs-dev,05/24] ext2: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/ccdc2e0569f5
  - [f2fs-dev,06/24] ext4: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/20747a2a29c6
  - [f2fs-dev,07/24] exfat: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/b8ca02667552
  - [f2fs-dev,08/24] f2fs: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/9e2ac6ddb397
  - [f2fs-dev,09/24] fat: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/a9acc8422ffb
  - [f2fs-dev,10/24] gfs2: add a setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/3b514c333390
  - [f2fs-dev,11/24] jffs2: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/c275e6e7c085
  - [f2fs-dev,12/24] jfs: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/7dd596bb35e5
  - [f2fs-dev,13/24] nilfs2: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/f46bb13dc5d9
  - [f2fs-dev,14/24] ntfs3: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/6aaa1d6337b5
  - [f2fs-dev,15/24] ocfs2: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/f15d3150279d
  - [f2fs-dev,16/24] orangefs: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/136b43aa4b16
  - [f2fs-dev,17/24] overlayfs: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/94a3f60af5dc
  - [f2fs-dev,18/24] squashfs: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/dfd8676efe43
  - [f2fs-dev,19/24] tmpfs: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/f5a3446be277
  - [f2fs-dev,20/24] udf: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/dbe8d57d1483
  - [f2fs-dev,21/24] ufs: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/545b4144d804
  - [f2fs-dev,22/24] xfs: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/6163b5da2f5e
  - [f2fs-dev,23/24] filelock: default to returning -EINVAL when ->setlease operation is NULL
    https://git.kernel.org/jaegeuk/f2fs/c/2b10994be716
  - [f2fs-dev,24/24] fs: remove simple_nosetlease()
    https://git.kernel.org/jaegeuk/f2fs/c/51e49111c00b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



