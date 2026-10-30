Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38472606A31C
	for <linux-erofs@archiver.kernel.org>; Fri, 30 Oct 2026 09:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=Bvl3dIDf
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jGGTQ5MLsz30Vn;
	Fri, 30 Oct 2026 20:46:50 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793353610;
	cv=none; b=AwODRO+suDlEQxN69MJh7S/sK/Pzi/6nPAmw5XyqrH/OO7GrM28SjKMdjK63stbpNwmvNoBayRSrK6cxR+sTlzIxy5zXqvS2bMoHILJ0BrPaTrQETIAh+vJNoD1pdRG+Ix88MLWPYHPeJCmxCEEptdcpQl+zxdOQU2bSeyvy3FlOsMRGmgSCa/yzUr4CEPzzRWIrvBAAag7SUTMabKnQ592p4hz/lStrwrpxA/1LhtLBYGBmpVU4tf+rx2P9Vy91bfHH9lqYjf+XGWDoGIA8mTdcVsxRCv+1M4h7dU5PzoLqOktNivs3MUyV6n7LUDranJBpxEVsH0N4idDzwtQarA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793353610; c=relaxed/relaxed;
	bh=ORyjSuKKSJN7+lfcko6IFZ37e1Surs9obtI/3rmqvUg=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=k9TIvhzt5l3KFsKaiLK0vtXHNWfsheCEddaUkb+sOlSbeDd/xQoes9hUasHvCYXLLmMXenIa/3WWem8REknP6+IYP13FIlUiaMXmTNHJLgAU78GCXJMYgODUmGbpWtm/GS80zyEaW+AYjhwbmP5+J//lEQd5XaiyVqbr/5a1KyykN8aJR2rJzS+3BtB6YyofvqNGomKrjfbyuguCIXi+PdtDbMRpWGCaPKHtEgblsjSFTbLaGY9SO4GQrqsocHheudw+n+UAUeTtVVlLrPzSdQIudA3fxQsfzVXPCJnpzgSwEiv56QWtYV0uhHDLuB2PveB24vHOuno3M4uMTVdgVA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com; dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=Bvl3dIDf; dkim-atps=neutral; spf=pass (client-ip=203.254.224.25; helo=mailout2.samsung.com; envelope-from=daejun7.park@samsung.com; receiver=lists.ozlabs.org) smtp.mailfrom=samsung.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=Bvl3dIDf;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=samsung.com (client-ip=203.254.224.25; helo=mailout2.samsung.com; envelope-from=daejun7.park@samsung.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 311 seconds by postgrey-1.37 at boromir; Fri, 30 Oct 2026 20:46:47 AEDT
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jGGTM6NlSz30C6
	for <linux-erofs@lists.ozlabs.org>; Fri, 30 Oct 2026 20:46:46 +1100 (AEDT)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261030094124epoutp02dca59138cd2f29e32b8ad8ceb435938f~jRU94cl9T3272732727epoutp02Q
	for <linux-erofs@lists.ozlabs.org>; Fri, 30 Oct 2026 09:41:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261030094124epoutp02dca59138cd2f29e32b8ad8ceb435938f~jRU94cl9T3272732727epoutp02Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793353284;
	bh=ORyjSuKKSJN7+lfcko6IFZ37e1Surs9obtI/3rmqvUg=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=Bvl3dIDfnyPIZZz7M7vgzqNTIK4clKgLyVXr+/9a1GXxdiS7wyTSUsOjOMt3NVkq1
	 rGZU2tQNgc57tgiDoaUUaw427u8MSdzdG3zHIM4AX11KtsQhUeSe8aEFf1mR5irl4q
	 kfIukRtrR8F26u6hCFXEnmt+f/F8cPCRPITWecNY=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20261030094123epcas2p27d9272f4be076ef15bb610136586a2be~jRU9avsQu0621406214epcas2p2y;
	Fri, 30 Oct 2026 09:41:23 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.205]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jGGM72wkMz6B9m5; Fri, 30 Oct
	2026 09:41:23 +0000 (GMT)
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
Mime-Version: 1.0
Subject: RE: [PATCH] erofs: allocate file-backed mount requests from a
 bio_set
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>
CC: Yue Hu <zbestahu@gmail.com>, Jingbo Xu <jefflexu@163.com>, Sandeep
	Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, Chunhai
	Guo <guochunhai@vivo.com>, "linux-erofs@lists.ozlabs.org"
	<linux-erofs@lists.ozlabs.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20261030-erofs-fileio-bioset-v1-1-caf47adbb3a3@samsung.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261030094122epcms2p6ed0246e9cb7e51134e4d89dae268c392@epcms2p6>
Date: Fri, 30 Oct 2026 18:41:22 +0900
X-CMS-MailID: 20261030094122epcms2p6ed0246e9cb7e51134e4d89dae268c392
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261030035441epcas2p11516a48f299f7e4c8ff69e07c29d8f17
References: <20261030-erofs-fileio-bioset-v1-1-caf47adbb3a3@samsung.com>
	<CGME20261030035441epcas2p11516a48f299f7e4c8ff69e07c29d8f17@epcms2p6>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> - Mount already rejects backing files on stacked fses and on
>   file-backed EROFS. A backing read cannot reach this pool again in
>   the same task.

This relies on the stacked fs check, and Sashiko pointed out that
inode_share gets around it.

A backing file on a block-backed EROFS passes the check, since that sb
has s_bdev. If that EROFS is mounted with inode_share, reads of the
file go through erofs_ishare_file_read_iter(), and erofs_real_inode()
may pick an inode of a file-backed EROFS in the same domain. So a
backing read can start another file-backed read in the same task,
while its own request is still held. I reproduced this in a QEMU guest
with the image on such an EROFS, and also with a device= blob there.
This is from the mount:

  vfs_iocb_iter_read
  erofs_fileio_rq_submit
  erofs_fileio_iomap_submit_read
  iomap_readahead
  erofs_readahead
  ...
  filemap_read
  erofs_ishare_file_read_iter
  vfs_iocb_iter_read
  erofs_fileio_rq_submit
  erofs_read_meta_folio
  ...
  erofs_fc_fill_super

With this patch both requests come from erofs_fileio_bioset, so under
memory pressure the inner allocation can wait on the pool while the
outer request still holds an element of it.

The nesting itself is older than this series. File-backed mounts can
stack this way since commit 34096ba919fd ("erofs: support unencoded
inodes for page cache share"). In v2 I will add a separate fix for
that, with a Fixes tag, which treats an EROFS mounted with inode_share
as a stacked fs, and update this paragraph.

Daejun

