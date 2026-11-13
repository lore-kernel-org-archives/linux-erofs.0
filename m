Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D7F606A8A0
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 16:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T41V0Bu2
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jR2ps1G98z2xLr;
	Sat, 14 Nov 2026 03:32:21 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794587541;
	cv=none; b=VI9slizrogPz1d9UC9ylsbrFz4PrK4nd2oFPMai+NjwC0sfE39qUwpJxUtNWM5AoUhWAAapViYmewKGA7v5CYwSWykd7saZTb6OUaxkF/2k6IEYXhF04kt8oEwrQulXzLTEBnC45PVaBT6HlwKW6IGufHdFWROWq090aL0EH/2eKloHE1ePyCl70BQeMFKmOcFB9tebdiywJbm878Q44a+OVmRoSXlr7qhPkKdqB/iVEs97PwmVGN5JHfkjh24kfXM8hHx+QXBx4iIUY/Q49ZU99kJT4uhZROiVt6gS7eQH4l/ymIib4xYU25e1cP+5nb7qlnXSKsCofFiohNAA7AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794587541; c=relaxed/relaxed;
	bh=hbYuJXsU/Y/fx8jdL3h62cRD0Al1NC/ykCIIJh5wMVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TIlwvPVXoJTjr/QvNfJYhMe/hQ1ONR574B+73pBqlgq6nB3OfNopmjC3FK0eO1QXCd+mC+swcrdnfxru8ataF6DJjPgvAqeolIYm77RM5X80kizjODKDjT5yEFMa1XJLsOTAQhDzeEaJxZkISWq09H54s1nik54GcDVKiNb2q2jgtjFAvSJrjFuEnaCUrf9k3PPDkQyv8DMRejlWmU4x24AsJHcFSIGo1oK1InNFkOn9Cm+ovFBnoLE+x0gdlZ0AIbK4J5AG27NL6uMvk4AsVY+zmmG20iFoSxYxGBbTAclox85ZDz/oTO3YnlE/QxW+PUgIcQWNkWmabC3TH33dKw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T41V0Bu2; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T41V0Bu2;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jR2pq6KFDz2xLg
	for <linux-erofs@lists.ozlabs.org>; Sat, 14 Nov 2026 03:32:19 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C92062930;
	Fri, 13 Nov 2026 16:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48B71F000C4;
	Fri, 13 Nov 2026 16:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794587537;
	bh=hbYuJXsU/Y/fx8jdL3h62cRD0Al1NC/ykCIIJh5wMVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T41V0Bu2rECZifE6tzxy5moCxah3+ZtB1epMqBSiZHDzn6/sMeRTSNHiPMesT8hbF
	 7gOFXEcQt6ncbLan1WVi01I2Oq+ggxDyMDg2waTaaOc25DpRRiXXwAsbghDG0r5U7/
	 AdmAFmI6sRabBntJVXsSZ6sGRkhNrncvqplQEzX9M5SzwxvGXFerFeCdEeHQCfnXN3
	 emTnT7cJj4yqhUI/qamjQFDNrPZ9DT0To6nA/rVox036FPyUvzpvaI9dzqB0wzQe89
	 gGt5SFO8iwq2cSTQqiyKtJQR8lo4KlPx/LruX5x+UXFtpNq7bSgpUFGtTpnO5IgSlF
	 w9Q3puAdqK3Bw==
Date: Fri, 13 Nov 2026 17:32:08 +0100
From: Gao Xiang <xiang@kernel.org>
To: Gou Hao <gouhao@uniontech.com>
Cc: xiang@kernel.org, chao@kernel.org, zbestahu@gmail.com, jefflexu@163.com,
	dhavale@google.com, hongbohbli@tencent.com, guochunhai@vivo.com,
	hongzhen@linux.alibaba.com, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, guanwentao@uniontech.com,
	niecheng1@uniontech.com, gouhaojake@163.com
Subject: Re: [PATCH] erofs: reject turning inode_share on during remount
Message-ID: <avc7iAy-qfS3g0PA@MacBookPro.fritz.box>
Mail-Followup-To: Gou Hao <gouhao@uniontech.com>, xiang@kernel.org,
	chao@kernel.org, zbestahu@gmail.com, jefflexu@163.com,
	dhavale@google.com, hongbohbli@tencent.com, guochunhai@vivo.com,
	hongzhen@linux.alibaba.com, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, guanwentao@uniontech.com,
	niecheng1@uniontech.com, gouhaojake@163.com
References: <20261113113204.560730-1-gouhao@uniontech.com>
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
In-Reply-To: <20261113113204.560730-1-gouhao@uniontech.com>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Hao,

On Fri, Nov 13, 2026 at 07:32:04PM +0800, Gou Hao wrote:
> The inode_share and domain_id constraint is validated when a
> superblock is initialized, but remount replaces the live mount options
> with a newly parsed option set without rechecking it.
> 
> Therefore a filesystem mounted without domain_id can enable inode_share
> by remount.  For an image with ishare xattrs, the next lookup of a
> regular file then passes a NULL domain_id to
> erofs_xattr_fill_inode_fingerprint() and crashes.
> 
> Since domain_id cannot be changed by remount, reject turning inode_share
> on during remount.
> 
> Reproducer:
> 
> 	mkfs.erofs --xattr-inode-digest=erofs.fingerprint.v1 img  man/
> 	mount img t
> 	mount -o remount,inode_share t
> 	ls t/
> 
> Full crash log:
> 
> [   50.416381] erofs (device loop0): mounted with root inode @ nid 37.
> [   78.553276] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [   78.553882] #PF: supervisor read access in kernel mode
> [   78.554326] #PF: error_code(0x0000) - not-present page

The full stack can be simplified a bit, there are two many overly
long lines.

I can simplify it later manually.

> [   78.554762] PGD 0 P4D 0
> [   78.555014] Oops: Oops: 0000 [#1] SMP NOPTI
> [   78.555423] CPU: 4 UID: 0 PID: 4446 Comm: ls Kdump: loaded Not tainted 7.3.0-erofs #2 PREEMPTLAZY
> [   78.556105] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> [   78.556942] RIP: 0010:strlen+0x0/0x20
> [   78.557284] Code: f7 75 ec 31 c0 e9 40 76 02 00 48 89 f8 c3 cc cc cc cc 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 <80> 3f 00 74 14 48 89 f8 48 83 c0 01 80 38 00 75 f7 48 29 f8 e9 07
> [   78.558636] RSP: 0018:ffffd2bb444afab8 EFLAGS: 00010212
> [   78.559092] RAX: 0000000000001000 RBX: 0000000000000027 RCX: 000000000000000c
> [   78.559652] RDX: ffffffffffffffff RSI: ffff8f2bcdef0d71 RDI: 0000000000000000
> [   78.560267] RBP: ffff8f2bc526b000 R08: 0000000000000610 R09: 00000000e096ebe3
> [   78.560839] R10: 0000000074d3def0 R11: 0000000085971d85 R12: ffff8f2be536fae0
> [   78.561443] R13: ffffd2bb444afb08 R14: 0000000000000000 R15: ffff8f2bcdef0d61
> [   78.562019] FS:  00007fe2289c94c0(0000) GS:ffff8f2f478c2000(0000) knlGS:0000000000000000
> [   78.562673] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   78.563133] CR2: 0000000000000000 CR3: 000000011e6ec001 CR4: 0000000000772ef0
> [   78.563656] PKRU: 55555554
> [   78.563892] Call Trace:
> [   78.564111]  <TASK>
> [   78.564315]  erofs_xattr_fill_inode_fingerprint+0x95/0x150 [erofs]
> [   78.564785]  erofs_ishare_fill_inode+0x75/0x260 [erofs]
> [   78.565193]  erofs_fill_inode+0x12e/0x190 [erofs]
> [   78.565603]  erofs_iget+0x85/0xc0 [erofs]
> [   78.565950]  erofs_lookup+0xe6/0xf0 [erofs]
> [   78.566312]  __lookup_slow+0x5b/0x100
> [   78.566631]  lookup_slow+0x39/0x60
> [   78.566914]  path_lookupat+0x19b/0x2a0
> [   78.567223]  filename_lookup+0xf0/0x200
> [   78.567534]  ? filldir64+0x38/0x190
> [   78.567822]  vfs_statx+0x7d/0x150
> [   78.568096]  do_statx+0x66/0xb0
> [   78.568367]  __x64_sys_statx+0x64/0xd0
> [   78.568670]  do_syscall_64+0x8d/0x460
> [   78.568974]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [   78.569367] RIP: 0033:0x7fe228b5c0de
> [   78.569665] Code: 2d 0d 00 ba ff ff ff ff 64 c7 00 16 00 00 00 e9 a5 fd ff ff e8 53 c0 01 00 0f 1f 00 f3 0f 1e fa 41 89 ca b8 4c 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 2a 89 c1 85 c0 74 0f 48 8b 05 05 2d 0d 00 64
> [   78.570936] RSP: 002b:00007ffec5afe428 EFLAGS: 00000246 ORIG_RAX: 000000000000014c
> [   78.571485] RAX: ffffffffffffffda RBX: 0000564bf6a2c498 RCX: 00007fe228b5c0de
> [   78.572007] RDX: 0000000000000900 RSI: 00007ffec5afe560 RDI: 00000000ffffff9c
> [   78.572532] RBP: 0000000000000002 R08: 00007ffec5afe430 R09: 00000000f6a31900
> [   78.573061] R10: 0000000000000002 R11: 0000000000000246 R12: 0000000000000000
> [   78.573595] R13: 0000564bf6a319f3 R14: 0000000000000000 R15: 0000564bf6a2c480
> [   78.574130]  </TASK>
> [   78.574334] Modules linked in: erofs loop nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfkill ip_set nf_tables intel_rapl_msr intel_rapl_common intel_uncore_frequency_common skx_edac_common nfit sunrpc libnvdimm snd_hda_codec_generic kvm_intel snd_hda_intel snd_hda_codec rapl snd_hda_core pcspkr snd_intel_dspcfg i2c_piix4 joydev virtio_balloon snd_hwdep i2c_smbus rtc_cmos eni_vdpa vdpa sg fuse fsdev_dax sr_mod bochs cdrom drm_shmem_helper drm_client_lib drm_kms_helper sd_mod ahci ata_generic libahci ata_piix drm libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_multipath dm_mod
> [   78.578967] CR2: 0000000000000000
> 
> Fixes: 5ef3208e3be5 ("erofs: introduce the page cache share feature")
> 
> Signed-off-by: Gou Hao <gouhao@uniontech.com>

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

