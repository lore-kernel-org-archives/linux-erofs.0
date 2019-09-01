Return-Path: <SRS0=Lz2Y=W4=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8F9C41514
	for <linux-erofs@archiver.kernel.org>; Sun,  1 Sep 2019 05:52:18 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8FD102339D
	for <linux-erofs@archiver.kernel.org>; Sun,  1 Sep 2019 05:52:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="hrOi6JDB";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=aol.com header.i=@aol.com header.b="kdZcaoW1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8FD102339D
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46Lj674MVwzDqv4
	for <linux-erofs@archiver.kernel.org>; Sun,  1 Sep 2019 15:52:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1567317135;
	bh=8vePKitsOB++Y0/3LGAG5xEbexWfgNiuH7+xjhwQPOc=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=hrOi6JDBEdrwbJxdzWlUNfxh45t44m9TPJQKHm+yubUZySbgWZ2Sas1ANtK0IU6yT
	 +gcI6gBfLlIqXI1K7N6LW7BOx5dh8YrnEEq2gvtPh9xJpjcRu5EUdR0Wl30JxuoWqU
	 0zv7cnFnGaP74I+1DsM6jUAhVCcFoCYsuOzOkdSS9NTrKU4PHWCnHguhE4bT47OM0t
	 7+M6hF7ez5vd2kxZXdPm3p0ad7Vz1wXHRR4Uz41f2jysAv651baWEMvccG+nj0P5sc
	 Iw8hCJdtfOcOB5/cnjWsrONSf9qHfULNCg9NyfGyYLZhkvvxy1X7dBWph2tm5z6X+4
	 aJziFdpY5dmIA==
Authentication-Results: lists.ozlabs.org;
 spf=pass (mailfrom) smtp.mailfrom=aol.com
 (client-ip=98.137.64.204; helo=sonic303-23.consmr.mail.gq1.yahoo.com;
 envelope-from=hsiangkao@aol.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=aol.com header.i=@aol.com header.b="kdZcaoW1"; 
 dkim-atps=neutral
Received: from sonic303-23.consmr.mail.gq1.yahoo.com
 (sonic303-23.consmr.mail.gq1.yahoo.com [98.137.64.204])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46Lj5p6LfVzDqlr
 for <linux-erofs@lists.ozlabs.org>; Sun,  1 Sep 2019 15:51:52 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048;
 t=1567317108; bh=8vuTTgilnndAay+1QQhKe0yY1WR62jcI88iV2uYpBWI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject;
 b=kdZcaoW15p6mDZzbSEdi+fMRDYamfJ7wHFN2NMHnGVvOaCMsSu478b3Cs42vYZGNkk8uXIKoNqGU9LVvGVKIIrKGp9KwLiHA/Fzu9qUAIR97djtpO6u3uI9rr2NRzcG6bWz6XSrFsnVm7TLK0N/eK0CplNUnZ/JxKiWE6pM5UtiU2sKY9MwKTiNWVMd55gPixuE05cnnm1o0T1UY4Bf91c+kwCps5xZvPvpDubYjE+q1P0Imx1qV7PMGxwjKuQmwd73Hh74R9aX0YHITuxTN+YnbfW5/tZpCgZYFBbrS4tG7a12DpXGEpumGer/A5lCndt1VURj007XLdMJ/MmZbdA==
X-YMail-OSG: vcTN0YUVM1l1H75oH9NnT74c_r398x0WEkE3foLHiahdtX7wph9UuQPnnfJ123X
 1aOj20tzQ4E5076QEZZwrtfYtCwsTft.Qg80X2j9j2.DDTMs2JvLBghd9qNwzWHn_OHies2KhtwB
 EzbVLHqGRiSC8Bf5KFfe3cs3RKkbbtC8o8DHnFpwmylivsqo4muUOCqnj8kJppv3AgtXQSvt8SKq
 pluH0eKwZT5LS4sNeV85qU6ap.YTzCbl_fDMEPZf1PHazWepyNr7Nwmiou7CdE7Pxq.bL0DOM_FN
 ZrJAY8a822JP1zfsOH.k2oml6y5kVKMl.zdhx6obsojtnM4mthEetWrlbZz0qlx8dLpLfK0sZPC1
 Um1eModXM1XiXvaT2TCAyFoMSBLY0jbQclCiWy6CvXb_nH5TC_2QfvMzHhNZdCOiYKAA2UpwR11U
 0qR27uH9QT4rBbptEL_MCHxW5iQ1usL5qj87KP7bw6cNvB4aQljPf2I.WYYTVnGz.DfPsVkuBahQ
 yPCIhzrZvBR6X94NbLPBeTmIh2EIVK1nJVGaeFswrN0pZ8v5A3GcMz54rdVo1GUdJUGe1jfs.D.C
 6wys0b1fikCMq4h5POYomNIipRxyF5Arg0xMNBZ3ios7Z4qte4O55ek86WeMXfe8KZPMaF.fzgIQ
 UBvifBZLy5M.B_.jhRwaNwR0S6dFo09p2SToeWwCrAShHthW9CUhAbt5UwhsuZFqvz8ePqndXenC
 qQzaBsfVS7fhm4Ok2HZq50nhH5g54K0oYI_5AwrUnAg8Ag4kf2LpFdXE71ljwxcDNBAOi2BfP9mt
 k6B_XbOtVGhrCWUxPOtsE7cKFbEpfHCawcaVRoBCkdGaA.JW2szvHsxzKlg20Rq36ZtZRp6tTqtU
 ALBYj4ZJQdeymeVYc3kczLvwUrKxxhkICvv_Yi8z9IAXnZTTeWVCx_1UyMFnzxagf4pEKClchwEc
 mcUBISF2YbcMV6ViQQk5Dqk6uA9z7WA_oTBmOgMweGvUWCO9MCXyFIruVETxZr941lHBbwpOB0m9
 8zDNMMuvMcmM47WuO_nVgn2qj5ELVSPw5oZ.BsJTe59jFWK5qLf16fvyY4myz_Zq.zz7BC3pBZH5
 EwCpeQGiEU.Q9XfNiLMWscN.6qcIYrW5iri3RUAiTOi8VHkiCqp.uOPbDOYuyi83nf36wMzSwTDH
 iIiQQpaEq4TtLOsDoJ.DxSQBYocpBBXHTZKLEHw5z9fopkpKPqLVytJQl4KuKu5kKfotyUffESQA
 nvkk1zW_EoXVW4hNWfFcXcQRScSs-
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic303.consmr.mail.gq1.yahoo.com with HTTP; Sun, 1 Sep 2019 05:51:48 +0000
Received: by smtp406.mail.gq1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA
 ID 426e3b5ec1af9e36f409445c51071a70; 
 Sun, 01 Sep 2019 05:51:46 +0000 (UTC)
To: Christoph Hellwig <hch@infradead.org>, Chao Yu <yuchao0@huawei.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 00/21] erofs: patchset addressing Christoph's comments
Date: Sun,  1 Sep 2019 13:51:09 +0800
Message-Id: <20190901055130.30572-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190802125347.166018-1-gaoxiang25@huawei.com>
References: <20190802125347.166018-1-gaoxiang25@huawei.com>
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
Cc: linux-fsdevel@vger.kernel.org, devel@driverdev.osuosl.org,
 linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi,

This patchset is based on the following patch by Pratik Shinde,
https://lore.kernel.org/linux-erofs/20190830095615.10995-1-pratikshinde320@gmail.com/

All patches addressing Christoph's comments on v6, which are trivial,
most deleted code are from erofs specific fault injection, which was
followed f2fs and previously discussed in earlier topic [1], but
let's follow what Christoph's said now.

Comments and suggestions are welcome...

[1] https://lore.kernel.org/r/1eed1e6b-f95e-aa8e-c3e7-e9870401ee23@kernel.org/

Thanks,
Gao Xiang

Gao Xiang (21):
  erofs: remove all the byte offset comments
  erofs: on-disk format should have explicitly assigned numbers
  erofs: some macros are much more readable as a function
  erofs: kill __packed for on-disk structures
  erofs: update erofs_inode_is_data_compressed helper
  erofs: kill erofs_{init,exit}_inode_cache
  erofs: use erofs_inode naming
  erofs: update comments in inode.c
  erofs: update erofs symlink stuffs
  erofs: kill is_inode_layout_compression()
  erofs: use dsb instead of layout for ondisk super_block
  erofs: kill verbose debug info in erofs_fill_super
  erofs: simplify erofs_grab_bio() since bio_alloc() never fail
  erofs: kill prio and nofail of erofs_get_meta_page()
  erofs: kill __submit_bio()
  erofs: kill magic underscores
  erofs: use a switch statement when dealing with the file modes
  erofs: add "erofs_" prefix for common and short functions
  erofs: kill all erofs specific fault injection
  erofs: kill use_vmap module parameter
  erofs: save one level of indentation

 Documentation/filesystems/erofs.txt |   9 --
 fs/erofs/Kconfig                    |   7 --
 fs/erofs/data.c                     |  62 +++-------
 fs/erofs/decompressor.c             |  34 ++---
 fs/erofs/dir.c                      |   6 +-
 fs/erofs/erofs_fs.h                 | 162 ++++++++++++------------
 fs/erofs/inode.c                    | 176 +++++++++++++-------------
 fs/erofs/internal.h                 | 156 +++--------------------
 fs/erofs/namei.c                    |  12 +-
 fs/erofs/super.c                    | 185 ++++++++--------------------
 fs/erofs/xattr.c                    |  33 +++--
 fs/erofs/xattr.h                    |   4 +-
 fs/erofs/zdata.c                    |  44 +++----
 fs/erofs/zmap.c                     |  32 ++---
 include/trace/events/erofs.h        |  14 +--
 15 files changed, 338 insertions(+), 598 deletions(-)

-- 
2.17.1

