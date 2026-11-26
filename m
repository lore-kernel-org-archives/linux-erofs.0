Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34F2606A323
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Nov 2026 06:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eWf9B3YD
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jZnHY6z0jz2yDc;
	Thu, 26 Nov 2026 17:50:33 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795675833;
	cv=none; b=HF2RWaZNKbkjbVVaIGMFd5jOjWfk9oOM/uOxlnPZbF+itoyb53CKsee4bcoVCYzBRnmYBGCrQqGXOrLqqefTHqZCj+F00Y5folOJZapsnUeuFmBvBh6+R9oetXBXwHmPqnPmfYJVTj58KuJpS1wUy8blIjl2U69/4VbvCTZ6XyVXEfN5voJaqieOJDBOlZcRbjC+JUIdBscNsM+8jPKAo/an7Y9N9C8wCnFflZL3YB+g+Od7Ic/h/43ybpGb/5MIx1V0uwBltl9ekc5Cc2RZv7zHM+70+3+hY2petoiR36w9vhynzb+JVwnJrW7hwhXyVrrJQxbcovxRd+GNsI+uyw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795675833; c=relaxed/relaxed;
	bh=ZoiJbuRMqJkbZCgyJM9gElB2PWpxJgreaUQZdBrK56Q=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CckOL7oz6dkOed/yjdWJY7lPd7nl7wv3cTW68r3GA7doptwOJ6s5/aF2X8vncBYKGzWVq1vuvN+DmfB5Lpi1wNSxy4jNLIPn3Js7pYJZcJXCjefETgubmxymD2+gX6GF/eRYl1y+YNs9d5gitBa9/b7Nf62vQiDdMv/G3GR+fIaTmQpd0fZQwkEaSbZe4cN33BgObJOmo0EQ+qbzdBtohdWkwhet4OY7zg8LlAJ1YqFQ4RbtoYAOhfunDrkms+6egyXAXXwZMcLkkI4ZqrYZTNhCBIKbLLa3n0/iGocvyVKOseAEattJs2u57nmQPIa33pX7y7qziOHyYWTRTeeFNg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eWf9B3YD; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eWf9B3YD;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jZnHX60s6z2xjP
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 17:50:32 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 005CA44379;
	Thu, 26 Nov 2026 06:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D711F000CA;
	Thu, 26 Nov 2026 06:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795675829;
	bh=ZoiJbuRMqJkbZCgyJM9gElB2PWpxJgreaUQZdBrK56Q=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=eWf9B3YDEwGcmRFj0Lt9FXm0+gG/uhrPtL2WQ7Yma/3o9ZVdis9nqhwEGQGTz6yvF
	 +7SdO5QOMxHGlLH/WDSG53ZT2mno39Kr28KB3/iJmwx/nhmFleKM9/HoFy5ZMDT2YF
	 be2GZh5/g8zGdK+v1+aLxaY4LuD5e1ufc9uYSDwuFGa2TInuz7DVvlMfdQjWWaBv+m
	 g0XzXceuizNUtU4p2Z1MTw2Se2ZAap+kb6nEuJoFPfs/fdn5HDEM+VBDkkqsFjWcxl
	 gLZunLqrWkO3mCvXi244BtImayYM7GprQ2lDh9v03FDAigFqHU58CK1TIQkJVbWaYs
	 w6B5H+DFGgprg==
Message-ID: <bc771151-b017-44fc-9643-6ab3da24c531@kernel.org>
Date: Thu, 26 Nov 2026 14:50:25 +0800
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
User-Agent: Mozilla Thunderbird
Cc: chao@kernel.org, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, guanwentao@uniontech.com,
 niecheng1@uniontech.com, gouhaojake@163.com
Subject: Re: [PATCH] erofs: reject turning inode_share on during remount
To: Gou Hao <gouhao@uniontech.com>, xiang@kernel.org, zbestahu@gmail.com,
 jefflexu@163.com, dhavale@google.com, hongbohbli@tencent.com,
 guochunhai@vivo.com, hongzhen@linux.alibaba.com
References: <20261113113204.560730-1-gouhao@uniontech.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20261113113204.560730-1-gouhao@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 19:32, Gou Hao wrote:
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
Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

