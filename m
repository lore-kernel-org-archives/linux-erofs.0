Return-Path: <SRS0=L+av=DY=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30047C433E7
	for <linux-erofs@archiver.kernel.org>; Sat, 17 Oct 2020 05:17:15 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F1B5E207EA
	for <linux-erofs@archiver.kernel.org>; Sat, 17 Oct 2020 05:17:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="EN+zMUb4";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=aol.com header.i=@aol.com header.b="rj4w+H9r"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F1B5E207EA
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4CCrqX0vNczDr0T
	for <linux-erofs@archiver.kernel.org>; Sat, 17 Oct 2020 16:17:12 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1602911832;
	bh=ehCuL2EUWQCKKOh72zusvPVuLFV97B5/TFdz+7sYWtI=;
	h=To:Subject:Date:References:List-Id:List-Unsubscribe:List-Archive:
	 List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=EN+zMUb41A0y4HM/flvRXR0MEzk4cNWl3LyEpIHMPo8603i+AbhQpUVw7LD0l937b
	 2BaBZrEaizSyit/PZwlZv0UVqOgOx8Ey8aFAEdVFFHUjAcA8E7Sct7N+nLCVWB/td/
	 s7JRfVRbwb8HApLQUf+aKnLmG9mbTu27MjcaYQWTZE1zrkvTnR/7gksi2ZSNNgIH+7
	 MNQ6ZUQbUxO/7tpkneCVvn1AQn2Q5tt125Zq9XWyZ9kZWUAX12BtKPcOS4q+S+WKSY
	 OmUBRA/OsCuGcj52UmCv6VNNNRyS+7weRkD2cnMnx9kB1Mv5F+2BmMj2dOAHfLJFwV
	 mg2YGBwoqRROg==
Authentication-Results: lists.ozlabs.org;
 spf=pass (sender SPF authorized) smtp.mailfrom=aol.com
 (client-ip=98.137.69.84; helo=sonic314-21.consmr.mail.gq1.yahoo.com;
 envelope-from=hsiangkao@aol.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=aol.com header.i=@aol.com header.a=rsa-sha256
 header.s=a2048 header.b=rj4w+H9r; dkim-atps=neutral
Received: from sonic314-21.consmr.mail.gq1.yahoo.com
 (sonic314-21.consmr.mail.gq1.yahoo.com [98.137.69.84])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4CCrq9309MzDqyd
 for <linux-erofs@lists.ozlabs.org>; Sat, 17 Oct 2020 16:16:50 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048;
 t=1602911805; bh=qmF16PGV1mWhrQpw16okjRv0X1z6+n0Cxzh8CbPoc0Y=;
 h=From:To:Cc:Subject:Date:References:From:Subject;
 b=rj4w+H9rH8ekxymNukCbXS6CNcfjKXacs6+Imt6eh4MDWovef3kIKm+qRquCuU9hMMv+s/Va+eLpaeRsa1rL0meuXWcYkGnEwuMOnSiWX8xefzaNlYpqmT3KFbfs84W1XDulvr5Wtgjw+2u930rz5Hl186gj3HAwmHOkyRRgThv5Pt7rlS6Ifs9X6GOZBo3uVydqY32esYrttUJHoyLro1J26FDrWh+pdqM0FFRxTqwkmiOXkg0oEvQXXRz5z3GVrxVXSguOvTsiradVIzObIjyYrl/fxBpCUcXd6l1A1ZYEcoxdgUQq9qpuHv7/wZ5xWqgEDL+2+2Hn60QSEPM+DA==
X-YMail-OSG: 2Mb6PyMVM1kWUpFdnhGrIT3eIk8MOera6XgSC02Qvg2d9UoHzyt1SG70tOZaQJ_
 ZyRy.52BzG8CmeYTuHJtX9hZtiyvsp3sOpYYbI4gLN8bt.tvylWBheOCXC7ThglxeorQ6Lnox479
 kHV6TVX28ubmm7iILhDwt0vFaKu34OUuc.O9GBXM8TnCYT95cz9KNH.RgfoKAq6faCKLl5XAyH4j
 5RF_dZC7kO93bHaKIw1fE_k5iIMPKvuRBpFy6hzPbVoYfKVHNaaP.GI6zWnw0ZME_FUSaa5U0aCp
 ObCTeNUy5CFWwbAW9.R9oIhubI.u2qfVECjd616E0JKnnuUTnTYTRZh4_rBuXjII.B..ElZWt95f
 qcdXHtGHn53gsOlALSilW_yw0vBBhYbCQrGKuXXcWT9pcgQ2b8ZFR3rIjuCu.xXN6yUAPaajeJOX
 W2BHiYIFMbB6ixtcWJPxCTsF.56Xs7l03ixQsulj7Qsm2B3nG_9C4bt_073Vel3cbhKH0rkys12u
 _snDugR.tI1wTT2KOeokFgfeaQTMUDbwYCkcRyGLBHxa8y_FQcUXlRRQ2cmRAi0YtlNgpSNOBL2P
 CbK9uM2wf74ZHnr0lbOzbIgRlB6cJcENd.g39NaoqSERFLbHY8SB1TpOHXlBinP8pWp9XKip3GOv
 rgjFF3TfzuspDu3tgFAPPZoDApkT10aSzlE7L_F6KFqGdr9fgaiALjLWLBfd_VOI.lCYuoz.DFIo
 mfsP7avlj347QyeMd244bsZFXWjCArvEMRk18ygwzpiJHfE94URxVzLDnPFAhGQ.wEd6MiRNF3fS
 rS7BzPuyMnFd0dXZvts4my1.ICphAsNne6rSoVBbSFv56.L0.PQZaaB8GLjJJjcCG93DBZ7LQ6WB
 r1t8IEBgVk5jq5MWe6hjVqrQ_PonVPzr8qohjVoaFaBAfF86acXsZdemy2UZH_tng5VM3PpyUBC5
 VwuEtgxdMXDlQS0OyQyHE5KxfBBQhsy5DM1oR_GF8RRvu7HdpVAB7xGHa.rR.ajPcFb_SiBPC1hg
 _A8Z53zw_XkdhBuEVqQ1bn3WWO34X8JFgCvfT3HU5RceYTm9MgfpIxzgqASlrHKdW9iHbBuHdJao
 jFO0tU9kNFQ1GrarZp1gZqONIzeAjioWRE9UvW9fRSzaYEJgHVoQb62vbRD8QoOk7jLFomIxngIS
 SGxzcAzkgG.CVpigSXXBesfE4AYBgRkTJM8i9CuuMGkTYYtJL0.RXvJY6rRdb1NXb16nF93n1ZVY
 egkStlt9DuRQXWEj21Zu8MJtULloQ358Tm3NVmhSEqG6kmp37K016ZMZ2I.azFbCtqTxoixKcUZE
 sn7omvaq.q2os8FQIY6OIdiPI2yUm4BmosuRAiiRYVRbEF7UfikEbhITEzWjRT8FJ7C9NLewHvBJ
 5HJPPs7bjPfnqS6K6Yu6U98xX7EqlqgL3vo6_m.4y.5AOJl4xthBHxkZ.yUZqP8_n7gc65sXY4Sh
 OdQO.e6xN7oOwp70FkyY6gLjWpgWAhvCIQe82b_Wm1FVcPA3wQGdAAVuF.jnJ9cQPEwk7XfCHv4N
 9_S7I8W2VWSRE
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic314.consmr.mail.gq1.yahoo.com with HTTP; Sat, 17 Oct 2020 05:16:45 +0000
Received: by smtp424.mail.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA
 ID 9d3dc137a63e5241cc606f3cba181f35; 
 Sat, 17 Oct 2020 05:16:40 +0000 (UTC)
To: linux-erofs@lists.ozlabs.org
Subject: [WIP] [PATCH 00/12] erofs-utils: introduce fuse implementation
Date: Sat, 17 Oct 2020 13:16:09 +0800
Message-Id: <20201017051621.7810-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20201017051621.7810-1-hsiangkao.ref@aol.com>
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
From: Gao Xiang via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Gao Xiang <hsiangkao@aol.com>
Cc: Zhang Shiming <zhangshiming@oppo.com>, Guo Weichao <guoweichao@oppo.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi all,

This patchset is based on the original patch
https://lore.kernel.org/r/20190818135923.27444-1-blucerlee@gmail.com
and several fixes / compression support by Huang Jianan
https://lore.kernel.org/r/20201015133959.61007-1-huangjianan@oppo.com

with my additional 9 incremental patches to refactor my current
development status, which will be folded into original patches
in the next WIP version since the fuse approach hasn't been
merged into dev branch yet.

To summarize the benefits of erofsfuse, I think it would be:

 - erofs images can be supported on various platforms;
 - an independent unpack tool can be developed based on this;
 - new on-disk feature can be iterated, verified effectively.

Any feedback or/and follow-on development/cleanup is welcomed.
(we still have a lot to do for the entire erofsfuse codebase...)

Thanks,
Gao Xiang

Gao Xiang (9):
  erofs-utils: fuse: adjust larger extent handling
  erofs-utils: fuse: use proper expression about inode size
  erofs-utils: fuse: drop ofs_out
  erofs-utils: fuse: refuse a undefined shifted cluster behavior
  erofs-utils: fuse: drop z_erofs_shifted_transform()
  erofs-utils: fuse: rename ofs_head and outputsize
  erofs-utils: fuse: cleanup erofs_read_data_compression()
  erofs-utils: fuse: move up mpage in struct erofs_map_blocks
  erofs-utils: fuse: fix up source headers

Huang Jianan (2):
  erofs-utils: fuse: support read special file
  erofs-utils: fuse: support read compressed file

Li Guifu (1):
  erofs-utils: introduce fuse implementation

 Makefile.am              |   2 +-
 README                   |  28 ++-
 configure.ac             |   3 +-
 fuse/Makefile.am         |  18 ++
 fuse/decompress.c        |  84 ++++++++
 fuse/decompress.h        |  42 ++++
 fuse/dentry.c            | 129 ++++++++++++
 fuse/dentry.h            |  43 ++++
 fuse/disk_io.c           |  72 +++++++
 fuse/disk_io.h           |  21 ++
 fuse/getattr.c           |  65 ++++++
 fuse/getattr.h           |  15 ++
 fuse/init.c              | 118 +++++++++++
 fuse/init.h              |  24 +++
 fuse/logging.c           |  81 ++++++++
 fuse/logging.h           |  55 ++++++
 fuse/main.c              | 171 ++++++++++++++++
 fuse/namei.c             | 242 +++++++++++++++++++++++
 fuse/namei.h             |  22 +++
 fuse/open.c              |  22 +++
 fuse/open.h              |  15 ++
 fuse/read.c              | 214 ++++++++++++++++++++
 fuse/read.h              |  17 ++
 fuse/readir.c            | 123 ++++++++++++
 fuse/readir.h            |  17 ++
 fuse/zmap.c              | 417 +++++++++++++++++++++++++++++++++++++++
 include/erofs/defs.h     |  16 ++
 include/erofs/internal.h |  79 ++++++++
 include/erofs_fs.h       |   4 +
 29 files changed, 2156 insertions(+), 3 deletions(-)
 create mode 100644 fuse/Makefile.am
 create mode 100644 fuse/decompress.c
 create mode 100644 fuse/decompress.h
 create mode 100644 fuse/dentry.c
 create mode 100644 fuse/dentry.h
 create mode 100644 fuse/disk_io.c
 create mode 100644 fuse/disk_io.h
 create mode 100644 fuse/getattr.c
 create mode 100644 fuse/getattr.h
 create mode 100644 fuse/init.c
 create mode 100644 fuse/init.h
 create mode 100644 fuse/logging.c
 create mode 100644 fuse/logging.h
 create mode 100644 fuse/main.c
 create mode 100644 fuse/namei.c
 create mode 100644 fuse/namei.h
 create mode 100644 fuse/open.c
 create mode 100644 fuse/open.h
 create mode 100644 fuse/read.c
 create mode 100644 fuse/read.h
 create mode 100644 fuse/readir.c
 create mode 100644 fuse/readir.h
 create mode 100644 fuse/zmap.c

-- 
2.24.0

