Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51933606A31C
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 11:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=Iw9YPYIO
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQwhT4V5mz2xpt;
	Fri, 13 Nov 2026 22:56:25 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=43.154.197.177
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794570985;
	cv=none; b=gIiy2fl7Xt70RadQcd96p2ap63LnCj7Clmg93w8AwOH3Lt+AoCda0NY03evNBwM3IH9oWkl3AK/xacXSVypsm7CFpVbWm7R0FZGDNmPl960yKLVtY4AIOAAl2FgecGozgrkDK9Jtmm3B92iPXJbZvFZNfiM/NQhCZRE2z++tek8Lamu25TsLOc6baGCG61uTj+Os/OJ00EUYoQTfKmmlXrWBznDxmVLDyJ7RipBoefcUNds7atFg0/5k8gISqnu4TXk5pPLpaHkLSGPA7oqfgQjGGCDXG5De635TBUsP1h77h5q/aq0TCy7yxu509uTw0ToV2Jj6k3TrwToOhK3iVA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794570985; c=relaxed/relaxed;
	bh=VHd/V3qu0rqnu55hIwOwRRLtbhU8RA6QEV81DvAQRc8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CvbWybGOFCfxPNeN5jHkvhRysDYTtTuhdm1IBcdYdPlA8H5MYY4Z3dRJdUsCJK4QWs4h6kn0Qx/f/fkdi2wPKwfboIbuQgH/Z1sscap8jB5zJbCei+YZ1bkWgm4pDf+qCkGfAWcLEdhxeGcYDZ9iQJYA78GmuALvQxkCQXqPivKnLUTY/y/tMkTTSY65hQ1nYp1McoBpjMhSGK74x0evdbwpFTIVl1dDFU+KikjkJlXQDs28NYPiaIyTMBwmbOStNB+cOejkPlfr8CA3Lc3hBnJ3FcuLQzXAIyNW6nyFhK+Nz3+tKBtavinv0VREsymOSLwa2PKvAX06V37gLJRuWA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; dkim=pass (1024-bit key; unprotected) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=Iw9YPYIO; dkim-atps=neutral; spf=pass (client-ip=43.154.197.177; helo=bg5.exmail.qq.com; envelope-from=gouhao@uniontech.com; receiver=lists.ozlabs.org) smtp.mailfrom=uniontech.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=Iw9YPYIO;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=uniontech.com (client-ip=43.154.197.177; helo=bg5.exmail.qq.com; envelope-from=gouhao@uniontech.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 1349 seconds by postgrey-1.37 at boromir; Fri, 13 Nov 2026 22:56:22 AEDT
Received: from bg5.exmail.qq.com (bg5.exmail.qq.com [43.154.197.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQwhQ1l43z2xjP
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 22:56:21 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1794570954;
	bh=VHd/V3qu0rqnu55hIwOwRRLtbhU8RA6QEV81DvAQRc8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=Iw9YPYIOZuk/LWtAeYcyY/J7Pk05+lQLD0R+hSgZ6lMB4aMopwbTo0b8nSS/kcZYa
	 /tr8wnxnztajtNrS3TeE4JZ6AN+RCIYn17rjXCv+dXvM1Uzx7VWhwOEA271I6EWmBH
	 Riw09eT9vYxZCiDb9cyDmKKh1dJqSoP7eMQdqoKI=
X-QQ-mid: zesmtpip2t1794569526tac643835
X-QQ-Originating-IP: wHH/jMG8YP+G/YqKf5W0TrO5Gq0k1HQV2DBYaCoz/pg=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 13 Nov 2026 19:32:04 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9348496667323867854
EX-QQ-RecipientCnt: 14
From: Gou Hao <gouhao@uniontech.com>
To: xiang@kernel.org,
	chao@kernel.org,
	zbestahu@gmail.com,
	jefflexu@163.com,
	dhavale@google.com,
	hongbohbli@tencent.com,
	guochunhai@vivo.com,
	hongzhen@linux.alibaba.com
Cc: linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	guanwentao@uniontech.com,
	niecheng1@uniontech.com,
	gouhaojake@163.com,
	gouhao@uniontech.com
Subject: [PATCH] erofs: reject turning inode_share on during remount
Date: Fri, 13 Nov 2026 19:32:04 +0800
Message-Id: <20261113113204.560730-1-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
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
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: MdoRYM9mYrydrBuWXnhXu3TkQxtnXg+DjZYyQFNb8PbB4yytV2XVENb3
	ObodR9YAUbWN9X8R1GA828GH7CeXmumRuExIQWvLEEi8at1OPc1FgdfHrMikdq4C3F1K1oh
	2MgKjR33EOrz6OR0KZ3rE+uXf2N8Zvvr477/jfIirmufR1dgTyX4oK76PEtG5qO5Fit3O6p
	EbiHYELIUjFBxJw4/uZtYBS68h0sZTSWfQIwkRBB//GG4eLSnfhkRramkV2PIxzWfZbAvKQ
	I1NHOZwdZAuVIPcM+2zRh/V+yt0WzgHG2/7rGL39Y5cBz1BCBUstfFtv6JVxQmqQLMHTSGl
	EYCfzGNifplL2ucyROcQ32joF1LLjdLLbxvRxN+CZG9fRvSbQUO0ZaQ1GKmELd35NWxhvoY
	fAQaBd1a2rAe8QDt3U8mCmSNJeB8gLh6e7D9LusLlV7/y0hQitnwlsyDEkCEzq6wwPD7Cfk
	2UTRi5I54fShGK8zyVZaFyrFdKmyiFitngrLLyPmlvaB+tZfVfsfDPl8QIebQ1BJTEN8QZm
	gwSpPd510rpE/LHzG6GStXqJuhoFik50ZHy+XlNSujWCA8KJtrff+WX8Kudr+prkhb2AR8M
	NN7XExie0eqlzOLQv0g9zJUFqljZQxqFPSurpGMYYhGojUqpP1uLS3V/4utoxzczB7sFqaj
	UqWQVnM+TNwsA1VAMIRqkSMKs6kMNGAKj0Zo19kP3zY/YWv4dynL6qkvf3yYIbTsQcJTyCz
	pokAvO3oiMl9pGiAU1sEfFv+n8o/zGUoRE3RfozpzdLFmLytvxIOwbWAg6gggMG1PlNnApD
	JmhlUV1U4eyZn9jME4s6HV7MrpKcLIogocb+Bq8vMSIhxnj5uBJnyk6R8XQKCgGQke/xZgo
	O7etsEaZIvUYGb2GjIeV6Yt2TEPlP9q+w2k5OXx59scLHcE7jf1qwMWQzBbNh9jg2rVICxv
	iq6mc8ARMlYZnvyAVIvfywStiJeFPe5/QfDSN9TmOYYTmaSJjk7hO/+zpgH8xsh7X3nGLxP
	kkYluCxlKH3aYCgyQvFA3eb2WdRDmUKxmG7zlNqB1aDElchemLV3G6/rNoFlhb/dfyH9iSp
	D3u005uggfhn4NQnqz/JgYTgZaAAT6Upg==
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The inode_share and domain_id constraint is validated when a
superblock is initialized, but remount replaces the live mount options
with a newly parsed option set without rechecking it.

Therefore a filesystem mounted without domain_id can enable inode_share
by remount.  For an image with ishare xattrs, the next lookup of a
regular file then passes a NULL domain_id to
erofs_xattr_fill_inode_fingerprint() and crashes.

Since domain_id cannot be changed by remount, reject turning inode_share
on during remount.

Reproducer:

	mkfs.erofs --xattr-inode-digest=erofs.fingerprint.v1 img  man/
	mount img t
	mount -o remount,inode_share t
	ls t/

Full crash log:

[   50.416381] erofs (device loop0): mounted with root inode @ nid 37.
[   78.553276] BUG: kernel NULL pointer dereference, address: 0000000000000000
[   78.553882] #PF: supervisor read access in kernel mode
[   78.554326] #PF: error_code(0x0000) - not-present page
[   78.554762] PGD 0 P4D 0
[   78.555014] Oops: Oops: 0000 [#1] SMP NOPTI
[   78.555423] CPU: 4 UID: 0 PID: 4446 Comm: ls Kdump: loaded Not tainted 7.3.0-erofs #2 PREEMPTLAZY
[   78.556105] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[   78.556942] RIP: 0010:strlen+0x0/0x20
[   78.557284] Code: f7 75 ec 31 c0 e9 40 76 02 00 48 89 f8 c3 cc cc cc cc 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 <80> 3f 00 74 14 48 89 f8 48 83 c0 01 80 38 00 75 f7 48 29 f8 e9 07
[   78.558636] RSP: 0018:ffffd2bb444afab8 EFLAGS: 00010212
[   78.559092] RAX: 0000000000001000 RBX: 0000000000000027 RCX: 000000000000000c
[   78.559652] RDX: ffffffffffffffff RSI: ffff8f2bcdef0d71 RDI: 0000000000000000
[   78.560267] RBP: ffff8f2bc526b000 R08: 0000000000000610 R09: 00000000e096ebe3
[   78.560839] R10: 0000000074d3def0 R11: 0000000085971d85 R12: ffff8f2be536fae0
[   78.561443] R13: ffffd2bb444afb08 R14: 0000000000000000 R15: ffff8f2bcdef0d61
[   78.562019] FS:  00007fe2289c94c0(0000) GS:ffff8f2f478c2000(0000) knlGS:0000000000000000
[   78.562673] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   78.563133] CR2: 0000000000000000 CR3: 000000011e6ec001 CR4: 0000000000772ef0
[   78.563656] PKRU: 55555554
[   78.563892] Call Trace:
[   78.564111]  <TASK>
[   78.564315]  erofs_xattr_fill_inode_fingerprint+0x95/0x150 [erofs]
[   78.564785]  erofs_ishare_fill_inode+0x75/0x260 [erofs]
[   78.565193]  erofs_fill_inode+0x12e/0x190 [erofs]
[   78.565603]  erofs_iget+0x85/0xc0 [erofs]
[   78.565950]  erofs_lookup+0xe6/0xf0 [erofs]
[   78.566312]  __lookup_slow+0x5b/0x100
[   78.566631]  lookup_slow+0x39/0x60
[   78.566914]  path_lookupat+0x19b/0x2a0
[   78.567223]  filename_lookup+0xf0/0x200
[   78.567534]  ? filldir64+0x38/0x190
[   78.567822]  vfs_statx+0x7d/0x150
[   78.568096]  do_statx+0x66/0xb0
[   78.568367]  __x64_sys_statx+0x64/0xd0
[   78.568670]  do_syscall_64+0x8d/0x460
[   78.568974]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   78.569367] RIP: 0033:0x7fe228b5c0de
[   78.569665] Code: 2d 0d 00 ba ff ff ff ff 64 c7 00 16 00 00 00 e9 a5 fd ff ff e8 53 c0 01 00 0f 1f 00 f3 0f 1e fa 41 89 ca b8 4c 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 2a 89 c1 85 c0 74 0f 48 8b 05 05 2d 0d 00 64
[   78.570936] RSP: 002b:00007ffec5afe428 EFLAGS: 00000246 ORIG_RAX: 000000000000014c
[   78.571485] RAX: ffffffffffffffda RBX: 0000564bf6a2c498 RCX: 00007fe228b5c0de
[   78.572007] RDX: 0000000000000900 RSI: 00007ffec5afe560 RDI: 00000000ffffff9c
[   78.572532] RBP: 0000000000000002 R08: 00007ffec5afe430 R09: 00000000f6a31900
[   78.573061] R10: 0000000000000002 R11: 0000000000000246 R12: 0000000000000000
[   78.573595] R13: 0000564bf6a319f3 R14: 0000000000000000 R15: 0000564bf6a2c480
[   78.574130]  </TASK>
[   78.574334] Modules linked in: erofs loop nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfkill ip_set nf_tables intel_rapl_msr intel_rapl_common intel_uncore_frequency_common skx_edac_common nfit sunrpc libnvdimm snd_hda_codec_generic kvm_intel snd_hda_intel snd_hda_codec rapl snd_hda_core pcspkr snd_intel_dspcfg i2c_piix4 joydev virtio_balloon snd_hwdep i2c_smbus rtc_cmos eni_vdpa vdpa sg fuse fsdev_dax sr_mod bochs cdrom drm_shmem_helper drm_client_lib drm_kms_helper sd_mod ahci ata_generic libahci ata_piix drm libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_multipath dm_mod
[   78.578967] CR2: 0000000000000000

Fixes: 5ef3208e3be5 ("erofs: introduce the page cache share feature")

Signed-off-by: Gou Hao <gouhao@uniontech.com>
---
 fs/erofs/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index ce05557bd998..c641153c5d8f 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -889,6 +889,11 @@ static int erofs_fc_reconfigure(struct fs_context *fc)
 	if (test_opt(&sbi->opt, SUPERBLOCK_SHARE))
 		return -EBUSY;
 
+	/* Enabling inode sharing by remount is not supported.  */
+	if (test_opt(&new_sbi->opt, INODE_SHARE) &&
+	    !test_opt(&sbi->opt, INODE_SHARE))
+		return -EBUSY;
+
 	if (new_sbi->domain_id)
 		erofs_info(sb, "ignoring reconfiguration for domain_id.");
 
-- 
2.20.1


