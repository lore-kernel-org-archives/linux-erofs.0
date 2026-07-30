Return-Path: <linux-erofs+bounces-4050-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30DCEC54FD2
	for <linux-erofs@archiver.kernel.org>; Thu, 30 Jul 2026 09:54:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h9l0S3d0gz2yYd;
	Thu, 30 Jul 2026 19:54:16 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=157.180.15.194
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785405256;
	cv=none; b=KV1Nc+NDgA8y5gRXLKeU41NWhVcjea/nOif4chElrzyp3K835RIeyD3nxIYpiRublXk7IXcS+FsEO45i6WOb6hPx5kR9TzpLbxo9EqkWRrN+pklXDwVD78s3LswNRSCqZDgQ/htqdWKicsMkKcEYFRAZXkzyxE59Im+67yjKB/mhrH1Zy+n3PS1j+KbT0PyGnpvcp/ZfnixS6mZdoxE4TmMdofPaVqzMtiyFJe0KMCmmxdrVMSPW0JinZCwnhbJPB/CRQmYv9F1qHZ8hNLT8WeRELx4xrLystQ7wE0lSCSlujK8OTo0y05TZBUCMifWEl0xv9js45MYJ/7oF78EzVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785405256; c=relaxed/relaxed;
	bh=D2XT2vl8tmZLBaZaZnBrkexFC40KAsQp94vktTr7CsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d5Vii3rGPKbj3a5ePOegQsltwsj6zmMGAYunQPnLHE4lMD3HjGbCd9RCGNiuH4/8rDxBDhrMPo17R6aZbZF1k69K2CoNkmTtRfC9uM9s7wK/VkqYS0vbGlSioLFzBnhekyWQV42WjuuXHz8Fgi4SFeyrJ095+ESjTCa79s4bppDRlJ7QKaNxOdGMyIOVbKd/ApNW7ZNamYw2R/dkecnL4kaAYeU3k18vRiPEj/vUpFsiXx6JDx5/ZZc3NcaxBWZHk8CIfR+vqneFDEoL3Dmvo5TwkArz9cD4TzAW4zVGLeL3I0TfLp5jmC3F4PXoVJxkXqOKczMlifKcN9pICOBdYA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=envs.net; dkim=pass (4096-bit key; secure) header.d=envs.net header.i=@envs.net header.a=rsa-sha256 header.s=modoboa header.b=hIyh0rFN; dkim-atps=neutral; spf=pass (client-ip=157.180.15.194; helo=mail.envs.net; envelope-from=xtex@envs.net; receiver=lists.ozlabs.org) smtp.mailfrom=envs.net
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=envs.net
Authentication-Results: lists.ozlabs.org;
	dkim=pass (4096-bit key; secure) header.d=envs.net header.i=@envs.net header.a=rsa-sha256 header.s=modoboa header.b=hIyh0rFN;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=envs.net (client-ip=157.180.15.194; helo=mail.envs.net; envelope-from=xtex@envs.net; receiver=lists.ozlabs.org)
Received: from mail.envs.net (mail.envs.net [157.180.15.194])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h9l0R19z0z2xRs
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 19:54:15 +1000 (AEST)
Received: from localhost (mail.envs.net [127.0.0.1])
	by mail.envs.net (Postfix) with ESMTP id EB9291C0094;
	Thu, 30 Jul 2026 09:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=envs.net; s=modoboa;
	t=1785405252; bh=D2XT2vl8tmZLBaZaZnBrkexFC40KAsQp94vktTr7CsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hIyh0rFNdEZdirHQZtxiXQvkLWF6wpQuZDVO05cunFxLZGtVPn6N2KJb8NNi7ojeo
	 bSjaoELJDD00Qqsy9n7+rg5y3yRwYqc4urm0fzGVlfzlliP2EpvkwLY03ZauIKUHA/
	 EmBYHBO2QhJxsLgdmUUSkhZ7HtSJcxa/T5u3C/EqCcrsb/kyuXlpo7MxfvZTwAVvUx
	 aTwqm1G4Kwl8n7Z1BN8ja43wRYPPNTyPng7K2Xh+cxg64iH5eF9xBMCl4kyHKvzBA/
	 m1nWv4weCbWorkmnaxr1z/xEG+AIoPvOcEYmTUrtnmZNC4ou/DLQhQmurIb0s5ZTZr
	 0BGvExqNXadLQc5FMR334p4F23BRoWtA79mmJq0vUrHrYpVLN8mz5h6alMBMEXlEHd
	 NFSjzvKQoumxaripoy3yyPZy8oyHKl96HYV4iSqtevjFN8u/RV8qLgt2VEUmzDbe1t
	 WwL4Mv3kATB6BtD4vxIKFomjZCw0n635KV4DE1f46bEc4/fQhoi7IXrbYesu3NchYc
	 S/Zitta2+k7VMvRe5nX4uvmA/gzcK1jY3kscGgfbt0puTLxYaEYiPSos7yhAvoh8Ov
	 mNUh6ID7KiyC5H03k/1b/NzbLYgGragdeMJe69s2K7wEcrTSD2axqpI86W2++jiNq0
	 TOmlLczNrLE08jxxc479lxxs=
X-Virus-Scanned: Debian amavisd-new at mail.envs.net
Received: from mail.envs.net ([127.0.0.1])
	by localhost (mail.envs.net [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id GSJZgeQBnqze; Thu, 30 Jul 2026 09:54:06 +0000 (UTC)
Received: from xtex-l16.localnet (unknown [123.88.3.171])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.envs.net (Postfix) with ESMTPSA;
	Thu, 30 Jul 2026 09:54:06 +0000 (UTC)
From: Bingwu Zhang <xtex@envs.net>
To: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>,
 Chunhai Guo <guochunhai@vivo.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject:
 Re: [PATCH] erofs: weaken full memory barriers to r/w barriers (update to
 test data)
Date: Thu, 30 Jul 2026 17:54:26 +0800
Message-ID: <Gc1x6FgaQ_qcO5n7YjvGXQ@envs.net>
Organization: AstraFall
In-Reply-To: <20260730-erofs-weaken-dbar-v1-1-dc2d9eacc07e@astrafall.org>
References: <20260730-erofs-weaken-dbar-v1-1-dc2d9eacc07e@astrafall.org>
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
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Thursday, July 30, 2026 12:01:20=E2=80=AFPM China Standard Time Bingwu Z=
hang wrote:
> From: Bingwu Zhang <xtex@astrafall.org>
>=20
> fs/erofs/{xattr.c,zmap.c} both implemented one-time initialization locks
> with general memory barriers.
>=20
> Weaken these unnecessarily-strong general memory barriers to SMP
> (ordering) read/write barriers for better performance on weakly-ordered
> architectures.
>=20
> Signed-off-by: Bingwu Zhang <xtex@astrafall.org>
> ---
> (All test results below are done using QEMU with KVM; guest VM root FS
> are mounted with v9fs; test target is an EROFS mounted on a loop device
> backed by a file in tmpfs, in attempt to reduce error caused by physical
> disks; mkfs flags: --zD=3D1 --all-root -zzstd -E48bit)
>=20
> On x86-64, with x86-TSO, a full barrier lowers to a fence instruction and
> read/write barriers are just compiler barriers. This patch removes
> several fence instructions although they don't affect performance much.
>=20
> On weakly-ordered architectures, a full memory barrier could be very
> expensive. Thus, on these platforms, this patch saves more performance
> than x86-64.
>=20
> Test result on x86-64:
> (host: AMD Ryzen 7 255 (@ 3.3GHz))
> (guest VM: ArchLinux, test data: linux.git/drivers @ commit fc02acf6ac0c)
>   Original:
>     read: IOPS=3D1684, BW=3D6737KiB/s (6899kB/s)(1006MiB/152838msec)
>     clat (usec): min=3D25, max=3D26293, avg=3D578.58, stdev=3D426.55
>      lat (usec): min=3D25, max=3D26293, avg=3D578.70, stdev=3D426.56
>    bw (  KiB/s): min=3D 1976, max=3D10904, per=3D100.00%, avg=3D6749.91,
>       stdev=3D1883.80, samples=3D305
>    iops        : min=3D  494, max=3D 2726, avg=3D1687.48, stdev=3D470.95,
> samples=3D305
>=20
>   New:
>    read: IOPS=3D1687, BW=3D6751KiB/s (6913kB/s)(1006MiB/152513msec)
>     clat (usec): min=3D25, max=3D19136, avg=3D577.00, stdev=3D425.66
>      lat (usec): min=3D25, max=3D19136, avg=3D577.09, stdev=3D425.67
>    bw (  KiB/s): min=3D 2192, max=3D11088, per=3D100.00%, avg=3D6770.26
>       stdev=3D1870.55, samples=3D304
>    iops        : min=3D  548, max=3D 2772, avg=3D1692.44, stdev=3D467.65,
> samples=3D304
>=20
> IOPS +0.17%, bandwidth +0.20%, max completion latency -27.22%
note: this line might be inaccurate, too
>=20

To clarify, the test result in the last email may be inaccurate.

I repeated tests and got some updated data.
This time I remembered to drop page caches between tests.

On AArch64,
for 4K randread, IOPS and bandwidth +1.5%, time -1.4%
for 16K randread, IOPS and bandwidth +1.6%, time -1.5%

Sorry for the misleading data in my last email. The data on ARM64 fluctuate=
=20
greatly between tests and I was trying to get an average value.

On x86-64,
for 4K randread, IOPS, bandwidth and time are basically unchanged,
while the max clat still -10.5% for unknown reasons (I don't think this pat=
ch=20
could change so much on x86)

I am not familiar with benchmarking and please let me know if I did anythin=
g=20
wrong.

Thanks!

Best regards,
Bingwu Zhang

> Test result on ARM64:
> (host: HUAWEI Kunpeng 920 @ 2.6GHz, both host & VM are AOSC OS)
> (test data:
> 1. AOSC OS: aosc-os_base_20260621_arm64.squashfs, /usr/bin directory is
>    repacked as EROFS.
> 2. linux.git at commit fc02acf6ac0c, drivers/ subdirectory
> )
>   Original:
>    read: IOPS=3D12.3k, BW=3D47.9MiB/s (50.2MB/s)(1291MiB/26950msec)
>     clat (nsec): min=3D910, max=3D37500k, avg=3D56026.68, stdev=3D198628.=
59
>      lat (nsec): min=3D960, max=3D37500k, avg=3D56167.70, stdev=3D198639.=
09
>    bw (  KiB/s): min=3D 3888, max=3D94328, per=3D100.00%, avg=3D49790.64,
>       stdev=3D31594.09, samples=3D53
>    iops        : min=3D  972, max=3D23582, avg=3D12447.57, stdev=3D7898.5=
1,
> samples=3D53
>=20
>   New:
>    read: IOPS=3D13.8k, BW=3D54.0MiB/s (56.6MB/s)(1315MiB/24375msec)
>     clat (nsec): min=3D930, max=3D34271k, avg=3D53069.97, stdev=3D145651.=
76
>      lat (nsec): min=3D980, max=3D34271k, avg=3D53221.68, stdev=3D145661.=
24
>    bw (  KiB/s): min=3D 5843, max=3D95054, per=3D100.00%, avg=3D55988.58,
>       stdev=3D30477.44, samples=3D48
>    iops        : min=3D 1460, max=3D23763, avg=3D13997.00, stdev=3D7619.3=
7,
> samples=3D48
>=20
> IOPS min +50.20%, avg +12.44%
> bandwidth min +50.28%, max +0.76%, avg +12.44%
> completion latency max -8.61%, avg -5.27%
>=20
> I am not pretty sure why the minimum completion latencies vary so much on
> AArch64. Even when I repeat the test with the same kernel without
> rebooting/re-mounting, clat min fluctuates randomly, sometimes spiking to
> over 1000 and sometimes dropping to as low as 2, but I think this patch
> still improves the overall throughput performance.
> ---
>  fs/erofs/xattr.c | 8 ++++----
>  fs/erofs/zmap.c  | 8 ++++----
>  2 files changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
> index df7ea019526d..0b252cfe616a 100644
> --- a/fs/erofs/xattr.c
> +++ b/fs/erofs/xattr.c
> @@ -44,10 +44,10 @@ static int erofs_init_inode_xattrs(struct inode *inod=
e)
>  	/* the most case is that xattrs of this inode are initialized. */
>  	if (test_bit(EROFS_I_EA_INITED_BIT, &vi->flags)) {
>  		/*
> -		 * paired with smp_mb() at the end of the function to=20
ensure
> +		 * paired with smp_wmb() at the end of the function to=20
ensure
>  		 * fields will only be observed after the bit is set.
>  		 */
> -		smp_mb();
> +		smp_rmb();
>  		return 0;
>  	}
>  	if (wait_on_bit_lock(&vi->flags, EROFS_I_BL_XATTR_BIT,=20
TASK_KILLABLE))
> @@ -111,8 +111,8 @@ static int erofs_init_inode_xattrs(struct inode *inod=
e)
>  		vi->xattr_shared_xattrs[i] =3D le32_to_cpu(*xattr_id);
>  	}
>=20
> -	/* paired with smp_mb() at the beginning of the function. */
> -	smp_mb();
> +	/* paired with smp_rmb() at the beginning of the function. */
> +	smp_wmb();
>  	set_bit(EROFS_I_EA_INITED_BIT, &vi->flags);
>  out_unlock:
>  	erofs_put_metabuf(&buf);
> diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
> index 5811556a7b71..d5b001a537f4 100644
> --- a/fs/erofs/zmap.c
> +++ b/fs/erofs/zmap.c
> @@ -628,10 +628,10 @@ static int z_erofs_fill_inode(struct inode *inode,
> struct erofs_map_blocks *map)
>=20
>  	if (test_bit(EROFS_I_Z_INITED_BIT, &vi->flags)) {
>  		/*
> -		 * paired with smp_mb() at the end of the function to=20
ensure
> +		 * paired with smp_wmb() at the end of the function to=20
ensure
>  		 * fields will only be observed after the bit is set.
>  		 */
> -		smp_mb();
> +		smp_rmb();
>  		return 0;
>  	}
>=20
> @@ -704,8 +704,8 @@ static int z_erofs_fill_inode(struct inode *inode,
> struct erofs_map_blocks *map) goto out_unlock;
>  	}
>  done:
> -	/* paired with smp_mb() at the beginning of the function */
> -	smp_mb();
> +	/* paired with smp_rmb() at the beginning of the function */
> +	smp_wmb();
>  	set_bit(EROFS_I_Z_INITED_BIT, &vi->flags);
>  out_unlock:
>  	clear_and_wake_up_bit(EROFS_I_BL_Z_BIT, &vi->flags);
>=20
> ---
> base-commit: 11028ab62899e4191e074ee364c712b77823a9c4
> change-id: 20260729-erofs-weaken-dbar-9fd2edff90e5
>=20
> Best regards,
> --
> Bingwu Zhang <xtex@astrafall.org>





