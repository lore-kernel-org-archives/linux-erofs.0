Return-Path: <linux-erofs+bounces-4035-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 539D7C531D0
	for <linux-erofs@archiver.kernel.org>; Thu, 30 Jul 2026 04:02:09 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h9bB72CdBz2xwH;
	Thu, 30 Jul 2026 14:02:07 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=157.180.15.194
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785384127;
	cv=none; b=cZOhSMKN6Xp2Bf8CkPuY9bnT4JFZnFgdYKpqB8HiADUPX6E5IiH+3hx1E11TprVcdD659HjZbj5Yamk63pkUTTdl6vpGYll78IrO5I7/di+ranMC3iktp9J1z7HybcJVH9Lw0r8Aeb5i2VlFj4dR1Ym0aAdfVzV4P8clabiq92JHUiIgaxbwWarIeeH438r3Hugy93odLJU/f4eimaXp5k2JaWKnq4swGADs6XMDJfwyTQ7Gwsn1SzN+00cMWlrG4BjL1dWh341zWgG/LRQMfLR9J1MLeDYyDhVTHHYcIgaJxtKgwkQjGQ4PZsL/S83qEgKglokYWbWWX72CrU0fOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785384127; c=relaxed/relaxed;
	bh=laJjoQFY1+saKwac32EvHbOrpLNgF4De3LkuMOa5KGU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=RQU2HYCmpxoVa+wFEZQSV5imqZaCV3T5id6a0a8Nm69JnL3ilMWcUp/buEvzBl6SuNmG54o/JTAdAwqqtmG31h+vZceUURWoSubyzdBm6q42RKnHdDtrrUwHa/0N+s6Q0ySB2Jz1md933MKJ4d88Q08fBpFym23dewA0Ro/MMio04IwyTu5Guy3+GEjDd0QhmSvES3kF4nCBOAiOSEfce1RE7xy4xi9Y5ZT7nMAscBL5qOdu5K0KON6BXLV0DxGi9AFIOXlEdE8XrEVf5tddZV0ndnRbgN9fBywfPKqWc0GqBMzLvCXgq4fZYhU2eh410h6OL0kQv8Gq0Q8IUAHp9g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=envs.net; dkim=pass (4096-bit key; secure) header.d=envs.net header.i=@envs.net header.a=rsa-sha256 header.s=modoboa header.b=HQZneBJ3; dkim-atps=neutral; spf=pass (client-ip=157.180.15.194; helo=mail.envs.net; envelope-from=xtex@envs.net; receiver=lists.ozlabs.org) smtp.mailfrom=envs.net
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=envs.net
Authentication-Results: lists.ozlabs.org;
	dkim=pass (4096-bit key; secure) header.d=envs.net header.i=@envs.net header.a=rsa-sha256 header.s=modoboa header.b=HQZneBJ3;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=envs.net (client-ip=157.180.15.194; helo=mail.envs.net; envelope-from=xtex@envs.net; receiver=lists.ozlabs.org)
Received: from mail.envs.net (mail.envs.net [157.180.15.194])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h9bB36bJ0z2xF8
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 14:02:02 +1000 (AEST)
Received: from localhost (mail.envs.net [127.0.0.1])
	by mail.envs.net (Postfix) with ESMTP id C97E41C0095;
	Thu, 30 Jul 2026 04:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=envs.net; s=modoboa;
	t=1785384116; bh=laJjoQFY1+saKwac32EvHbOrpLNgF4De3LkuMOa5KGU=;
	h=From:Date:Subject:To:Cc:From;
	b=HQZneBJ3i+mGwNIDRVcCAVHWjCC6ke16akiBILr7QjbJucUGaoETmaaBzr5tsGbhy
	 v1ExtDhpuVUa33dWEV4gLn6ANwPcVAw5blM9S4FdEmZr2B69jgQlpTYmwhaimKp2WA
	 jPVdryOTAwLDozxEfbqtTNtCAVpjKc6EzLmL0YCih0QY1VSPNFXsf/AI0EEDKuwyeP
	 swK7K9B7d73VeZJVuK5/ox0BC6j4G6ANsBepA6/bz4Y21mzYyAtac5N6es25KnbyrU
	 sF9bzneehKf0pkucjEVuEg0SS5Ofw+p5tlelwnxM7hddSjdIVI1NANhA1yLjdHHJqd
	 ZvuGxHbUhPHUwsvCcWOeFBgc9iqwYuAHVtz6itrLC3iZedjH+9x/R5w/xtZSSsMNtl
	 4k1aeJ/VAOftEk6OLoWg98xT2B2fbL/H4G5BNSorXP1jzeYgpdFRA10ULHFM0v+avg
	 bYZQfA+3dsts6KygUu6ml9QZF20hjFHMTTTrJEHCF2JIDn5quN3jKAyalwVyNrhorJ
	 IBTDxBwHyC/DcLskhguLHZmCuL/rMf8dYc8ZaXMWwqR3lWZ6g8+O0whOnBeXAtkxI7
	 BO2Qj7Wppv85e8qm+mTHMuVrddZxmsXMQgFBn1rJgjn6QcCo+5nGwwhZ34gvNglNGG
	 RaGYq0hNIzKNUuwd8nz0kzjI=
X-Virus-Scanned: Debian amavisd-new at mail.envs.net
Received: from mail.envs.net ([127.0.0.1])
	by localhost (mail.envs.net [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Fz7N3zBZ__4Q; Thu, 30 Jul 2026 04:01:39 +0000 (UTC)
Received: from [192.168.20.41] (unknown [211.136.168.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.envs.net (Postfix) with ESMTPSA;
	Thu, 30 Jul 2026 04:01:39 +0000 (UTC)
From: Bingwu Zhang <xtex@envs.net>
Date: Thu, 30 Jul 2026 12:01:20 +0800
Subject: [PATCH] erofs: weaken full memory barriers to r/w barriers
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-erofs-weaken-dbar-v1-1-dc2d9eacc07e@astrafall.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMywrCMBBG4Vcps3YgBqrEVxEXafOPjkIqM96g9
 N0bdfktzpnJYQqnQzeT4aWuU23YbjoaL7mewVqaKYa4C/uYGDaJ8xv5hsplyMZJSkQRSQE9te5
 uEP38nsfT3/4crhgf3xEtywr5XOuPdQAAAA==
X-Change-ID: 20260729-erofs-weaken-dbar-9fd2edff90e5
To: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
 Chunhai Guo <guochunhai@vivo.com>, Nick Terrell <terrelln@fb.com>, 
 David Sterba <dsterba@suse.com>
Cc: linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
 Bingwu Zhang <xtex@astrafall.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1785384124; l=5753;
 i=xtex@astrafall.org; h=from:subject:message-id;
 bh=2odAyWrV/pcFHfic8/cQgMPB6sTfN3aPBUY7LKKEvjk=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgL1erbbl1jNM9AtzeLFJ5FKVqr/ylJ
 MBUj5+W9IwwCl4AAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QG9K247TfeIR03rMkrwiPtYMIfwS1UU2tE0iJcspMC39ve8vq0OHaey4eOqVzAgPpBI9iWCEAdT
 ecx2okcGpEg0=
X-Developer-Key: i=xtex@astrafall.org; a=openssh;
 fpr=SHA256:IEYEjkZlkUTr5U9GiDAmZU/4eZus2t2RsxusyhQqwao

From: Bingwu Zhang <xtex@astrafall.org>

fs/erofs/{xattr.c,zmap.c} both implemented one-time initialization locks
with general memory barriers.

Weaken these unnecessarily-strong general memory barriers to SMP
(ordering) read/write barriers for better performance on weakly-ordered
architectures.

Signed-off-by: Bingwu Zhang <xtex@astrafall.org>
---
(All test results below are done using QEMU with KVM; guest VM root FS
are mounted with v9fs; test target is an EROFS mounted on a loop device
backed by a file in tmpfs, in attempt to reduce error caused by physical
disks; mkfs flags: --zD=1 --all-root -zzstd -E48bit)

On x86-64, with x86-TSO, a full barrier lowers to a fence instruction and
read/write barriers are just compiler barriers. This patch removes
several fence instructions although they don't affect performance much.

On weakly-ordered architectures, a full memory barrier could be very
expensive. Thus, on these platforms, this patch saves more performance
than x86-64.

Test result on x86-64:
(host: AMD Ryzen 7 255 (@ 3.3GHz))
(guest VM: ArchLinux, test data: linux.git/drivers @ commit fc02acf6ac0c)
  Original:
    read: IOPS=1684, BW=6737KiB/s (6899kB/s)(1006MiB/152838msec)
    clat (usec): min=25, max=26293, avg=578.58, stdev=426.55
     lat (usec): min=25, max=26293, avg=578.70, stdev=426.56
   bw (  KiB/s): min= 1976, max=10904, per=100.00%, avg=6749.91,
      stdev=1883.80, samples=305
   iops        : min=  494, max= 2726, avg=1687.48, stdev=470.95, samples=305

  New:
   read: IOPS=1687, BW=6751KiB/s (6913kB/s)(1006MiB/152513msec)
    clat (usec): min=25, max=19136, avg=577.00, stdev=425.66
     lat (usec): min=25, max=19136, avg=577.09, stdev=425.67
   bw (  KiB/s): min= 2192, max=11088, per=100.00%, avg=6770.26
      stdev=1870.55, samples=304
   iops        : min=  548, max= 2772, avg=1692.44, stdev=467.65, samples=304

IOPS +0.17%, bandwidth +0.20%, max completion latency -27.22%

Test result on ARM64:
(host: HUAWEI Kunpeng 920 @ 2.6GHz, both host & VM are AOSC OS)
(test data:
1. AOSC OS: aosc-os_base_20260621_arm64.squashfs, /usr/bin directory is
   repacked as EROFS.
2. linux.git at commit fc02acf6ac0c, drivers/ subdirectory
)
  Original:
   read: IOPS=12.3k, BW=47.9MiB/s (50.2MB/s)(1291MiB/26950msec)
    clat (nsec): min=910, max=37500k, avg=56026.68, stdev=198628.59
     lat (nsec): min=960, max=37500k, avg=56167.70, stdev=198639.09
   bw (  KiB/s): min= 3888, max=94328, per=100.00%, avg=49790.64,
      stdev=31594.09, samples=53
   iops        : min=  972, max=23582, avg=12447.57, stdev=7898.51, samples=53

  New:
   read: IOPS=13.8k, BW=54.0MiB/s (56.6MB/s)(1315MiB/24375msec)
    clat (nsec): min=930, max=34271k, avg=53069.97, stdev=145651.76
     lat (nsec): min=980, max=34271k, avg=53221.68, stdev=145661.24
   bw (  KiB/s): min= 5843, max=95054, per=100.00%, avg=55988.58,
      stdev=30477.44, samples=48
   iops        : min= 1460, max=23763, avg=13997.00, stdev=7619.37, samples=48

IOPS min +50.20%, avg +12.44%
bandwidth min +50.28%, max +0.76%, avg +12.44%
completion latency max -8.61%, avg -5.27%

I am not pretty sure why the minimum completion latencies vary so much on
AArch64. Even when I repeat the test with the same kernel without
rebooting/re-mounting, clat min fluctuates randomly, sometimes spiking to
over 1000 and sometimes dropping to as low as 2, but I think this patch
still improves the overall throughput performance.
---
 fs/erofs/xattr.c | 8 ++++----
 fs/erofs/zmap.c  | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
index df7ea019526d..0b252cfe616a 100644
--- a/fs/erofs/xattr.c
+++ b/fs/erofs/xattr.c
@@ -44,10 +44,10 @@ static int erofs_init_inode_xattrs(struct inode *inode)
 	/* the most case is that xattrs of this inode are initialized. */
 	if (test_bit(EROFS_I_EA_INITED_BIT, &vi->flags)) {
 		/*
-		 * paired with smp_mb() at the end of the function to ensure
+		 * paired with smp_wmb() at the end of the function to ensure
 		 * fields will only be observed after the bit is set.
 		 */
-		smp_mb();
+		smp_rmb();
 		return 0;
 	}
 	if (wait_on_bit_lock(&vi->flags, EROFS_I_BL_XATTR_BIT, TASK_KILLABLE))
@@ -111,8 +111,8 @@ static int erofs_init_inode_xattrs(struct inode *inode)
 		vi->xattr_shared_xattrs[i] = le32_to_cpu(*xattr_id);
 	}
 
-	/* paired with smp_mb() at the beginning of the function. */
-	smp_mb();
+	/* paired with smp_rmb() at the beginning of the function. */
+	smp_wmb();
 	set_bit(EROFS_I_EA_INITED_BIT, &vi->flags);
 out_unlock:
 	erofs_put_metabuf(&buf);
diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 5811556a7b71..d5b001a537f4 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -628,10 +628,10 @@ static int z_erofs_fill_inode(struct inode *inode, struct erofs_map_blocks *map)
 
 	if (test_bit(EROFS_I_Z_INITED_BIT, &vi->flags)) {
 		/*
-		 * paired with smp_mb() at the end of the function to ensure
+		 * paired with smp_wmb() at the end of the function to ensure
 		 * fields will only be observed after the bit is set.
 		 */
-		smp_mb();
+		smp_rmb();
 		return 0;
 	}
 
@@ -704,8 +704,8 @@ static int z_erofs_fill_inode(struct inode *inode, struct erofs_map_blocks *map)
 			goto out_unlock;
 	}
 done:
-	/* paired with smp_mb() at the beginning of the function */
-	smp_mb();
+	/* paired with smp_rmb() at the beginning of the function */
+	smp_wmb();
 	set_bit(EROFS_I_Z_INITED_BIT, &vi->flags);
 out_unlock:
 	clear_and_wake_up_bit(EROFS_I_BL_Z_BIT, &vi->flags);

---
base-commit: 11028ab62899e4191e074ee364c712b77823a9c4
change-id: 20260729-erofs-weaken-dbar-9fd2edff90e5

Best regards,
--  
Bingwu Zhang <xtex@astrafall.org>


