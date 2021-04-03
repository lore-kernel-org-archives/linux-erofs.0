Return-Path: <SRS0=1gyK=JA=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B955C433ED
	for <linux-erofs@archiver.kernel.org>; Sat,  3 Apr 2021 03:18:25 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A915F610CE
	for <linux-erofs@archiver.kernel.org>; Sat,  3 Apr 2021 03:18:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A915F610CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4FC2Dv277mz3bnH
	for <linux-erofs@archiver.kernel.org>; Sat,  3 Apr 2021 14:18:23 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=nXcYB4RX;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=xiang@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=nXcYB4RX; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4FC2Dr4gRpz2xg5
 for <linux-erofs@lists.ozlabs.org>; Sat,  3 Apr 2021 14:18:20 +1100 (AEDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE0CE61056;
 Sat,  3 Apr 2021 03:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1617419897;
 bh=SU/+5GRt1QvsCB8iKE15u0xmXZLEH/faeLHknrAWTPI=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=nXcYB4RXJWnp8ypJkqHVacJuMfuEvfb5Icg3yhDxsnWBBwgyN2x2bDCle5uDxvtVy
 6zv26MXVdOXYJpm7x8TER7f0/AAaZkWQb2rX3TcsBToM/j79u+wbQYfPDRFTmih3hK
 +Z7x5danC5B1HtoOEhpfjPGLbv9lb3p74tYPmAckBitkgTABbLWb9VidwsWNo3ADqb
 rmKVSj+ABQjpW3Hf3G3h++ItffWrWpvG9vXwQx5o1R08GfZAwSbAHWtKaQLc4b+SK0
 xgWEjL6A+ffpIegKeFCZYi5nj/0oon1LkcTkh/FwKZENQh0pX+nIch4MS1qg09eGrY
 WUogihs023JKQ==
Date: Sat, 3 Apr 2021 11:17:56 +0800
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org, Chao Yu <yuchao0@huawei.com>,
 Chao Yu <chao@kernel.org>
Subject: Re: [PATCH v2 00/10] erofs: add big pcluster compression support
Message-ID: <20210403031755.GA16255@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20210401032954.20555-1-xiang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210401032954.20555-1-xiang@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Thu, Apr 01, 2021 at 11:29:44AM +0800, Gao Xiang wrote:
> Hi folks,
> 
> This is the formal version of EROFS big pcluster support, which means
> EROFS can compress data into more than 1 fs block after this patchset.
> 
> {l,p}cluster are EROFS-specific concepts, standing for `logical cluster'
> and `physical cluster' correspondingly. Logical cluster is the basic unit
> of compress indexes in file logical mapping, e.g. it can build compress
> indexes in 2 blocks rather than 1 block (currently only 1 block lcluster
> is supported). Physical cluster is a container of physical compressed
> blocks which contains compressed data, the size of which is the multiple
> of lclustersize.
> 
> Different from previous thoughts, which had fixed-sized pclusterblks
> recorded in the on-disk compress index header, our on-disk design allows
> variable-sized pclusterblks now. The main reasons are
>  - user data varies in compression ratio locally, so fixed-sized
>    clustersize approach is space-wasting and causes extra read
>    amplificationfor high CR cases;
> 
>  - inplace decompression needs zero padding to guarantee its safe margin,
>    but we don't want to pad more than 1 fs block for big pcluster;
> 
>  - end users can now customize the pcluster size according to data type
>    since various pclustersize can exist in a file, for example, using
>    different pcluster size for executable code and one-shot data. such
>    design should be more flexible than many other public compression fses
>    (Btw, each file in EROFS can have maximum 2 algorithms at the same time
>    by using HEAD1/2, which will be formally added with LZMA support.)
> 
> In brief, EROFS can now compress from variable-sized input to
> variable-sized pcluster blocks, as illustrated below:
> 
>   |<-_lcluster_->|________________________|<-_lcluster_->|
>   |____._________|_________ .. ___________|_______.______|
>         .                                        .
>          .                                     .
>           .__________________________________.
>           |______________| .. |______________|
>           |<-          pcluster            ->|
> 
> The next step would be how to record the compressed block count in
> lclusters. In compress indexes, there are 2 concepts called HEAD and
> NONHEAD lclusters. The difference is that HEAD lcluster starts a new
> pcluster in the lcluster, but NONHEAD not. It's easy to understand
> that big pclusters at least have 2 pclusters, thus at least 2 lclusters
> as well.
> 
> Therefore, let the delta0 (distance to its HEAD lcluster) of first NONHEAD
> compress index store the compressed block count with a special flag as a
> new called CBLKCNT compress index. It's also easy to know its delta0 is
> constantly 1, as illustrated below:
>   ________________________________________________________
>  |_HEAD_|_CBLKCNT_|_NONHEAD_|_..._|_NONHEAD_|_HEAD | HEAD |
>     |<------ a pcluster with CBLKCNT --------->|<-- -->|
>                                                    ^ a pcluster with 1
> 
> If another HEAD follows a HEAD lcluster, there is no room to record
> CBLKCNT, but it's easy to know the size of pcluster will be 1.
> 
> More implementation details about this and compact indexes are in the
> commit message.
> 
> On the runtime performance side, the current EROFS test results are:
>  ________________________________________________________________
> |  file system  |   size    | seq read | rand read | rand9m read |
> |_______________|___________|_ MiB/s __|__ MiB/s __|___ MiB/s ___|
> |___erofs_4k____|_556879872_|_ 781.4 __|__ 55.3 ___|___ 25.3  ___|
> |___erofs_16k___|_452509696_|_ 864.8 __|_ 123.2 ___|___ 20.8  ___|
> |___erofs_32k___|_415223808_|_ 899.8 __|_ 105.8 _*_|___ 16.8 ____|
> |___erofs_64k___|_393814016_|_ 906.6 __|__ 66.6 _*_|___ 11.8 ____|
> |__squashfs_8k__|_556191744_|_  64.9 __|__ 19.3 ___|____ 9.1 ____|
> |__squashfs_16k_|_502661120_|_  98.9 __|__ 38.0 ___|____ 9.8 ____|
> |__squashfs_32k_|_458784768_|_ 115.4 __|__ 71.6 _*_|___ 10.0 ____|
> |_squashfs_128k_|_398204928_|_ 257.2 __|_ 253.8 _*_|___ 10.9 ____|
> |____ext4_4k____|____()_____|_ 786.6 __|__ 28.6 ___|___ 27.8 ____|
> 
> 
> * Squashfs grabs more page cache to keep all decompressed data with
>   grab_cache_page_nowait() than the normal requested readahead (see
>   squashfs_copy_cache and squashfs_readpage_block).
>   In principle, EROFS can also cache such all decompressed data
>   if necessary, yet it's low priority for now and has little use
>   (rand9m is actually a better rand read workload, since the amount
>    of I/O is 9m rather than full-sized 1000m).
> 
> More details are in
> https://lore.kernel.org/r/20210329053654.GA3281654@xiangao.remote.csb
> 
> Also it's easy to know EROFS is not a fixed pcluster design, so users
> can make several optimized strategy according to data type when mkfs.
> And there is still room to optimize runtime performance for big pcluster
> even further.
> 
> Finally, it passes ro_fsstress and can also successfully boot buildroot
> & Android system with android-mainline repo.
> 
> current mkfs repo for big pcluster:
> https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git -b experimental-bigpcluster-compact
> 
> Thanks for your time on reading this!
> 
> Thanks,
> Gao Xiang
> 
> changes since v1:
>  - add a missing vunmap in erofs_pcpubuf_exit();
>  - refine comments and commit messages.
> 
>  (btw, I'll apply this patchset for -next first for further integration
>   test, which will be aimed to 5.13-rc1.)
>

As a quick update, I've applied the following update to the next version
(some minor fix):

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index c7b1d3fe8184..fe46a9c34923 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -43,11 +43,15 @@ int z_erofs_load_lz4_config(struct super_block *sb,
 		distance = le16_to_cpu(lz4->max_distance);
 
 		sbi->lz4.max_pclusterblks = le16_to_cpu(lz4->max_pclusterblks);
-		if (sbi->lz4.max_pclusterblks >
-		    Z_EROFS_PCLUSTER_MAX_SIZE / EROFS_BLKSIZ) {
-			erofs_err(sb, "too large lz4 pcluster blocks %u",
+		if (!sbi->lz4.max_pclusterblks) {
+			sbi->lz4.max_pclusterblks = 1;	/* reserved case */
+		} else if (sbi->lz4.max_pclusterblks >
+			   Z_EROFS_PCLUSTER_MAX_SIZE / EROFS_BLKSIZ) {
+			erofs_err(sb, "too large lz4 pclusterblks %u",
 				  sbi->lz4.max_pclusterblks);
 			return -EINVAL;
+		} else if (sbi->lz4.max_pclusterblks >= 2) {
+			erofs_info(sb, "EXPERIMENTAL big pcluster feature in use. Use at your own risk!");
 		}
 	} else {
 		distance = le16_to_cpu(dsb->u1.lz4_max_distance);
diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 545cd5989e6a..6fc8e7fdaef8 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -77,12 +77,21 @@ static int z_erofs_fill_inode_lazy(struct inode *inode)
 	}
 
 	vi->z_logical_clusterbits = LOG_BLOCK_SIZE + (h->h_clusterbits & 7);
+	if (!erofs_sb_has_big_pcluster(EROFS_SB(sb)) &&
+	    vi->z_advise & (Z_EROFS_ADVISE_BIG_PCLUSTER_1 |
+			    Z_EROFS_ADVISE_BIG_PCLUSTER_2)) {
+		erofs_err(sb, "per-inode big pcluster without sb feature for nid %llu",
+			  vi->nid);
+		err = -EFSCORRUPTED;
+		goto unmap_done;
+	}
 	if (vi->datalayout == EROFS_INODE_FLAT_COMPRESSION &&
 	    !(vi->z_advise & Z_EROFS_ADVISE_BIG_PCLUSTER_1) ^
 	    !(vi->z_advise & Z_EROFS_ADVISE_BIG_PCLUSTER_2)) {
 		erofs_err(sb, "big pcluster head1/2 of compact indexes should be consistent for nid %llu",
 			  vi->nid);
-		return -EFSCORRUPTED;
+		err = -EFSCORRUPTED;
+		goto unmap_done;
 	}
 	/* paired with smp_mb() at the beginning of the function */
 	smp_mb();

