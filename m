Return-Path: <SRS0=VaLi=FJ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E8EC433FE
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Dec 2020 21:31:30 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 709FC20825
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Dec 2020 21:31:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 709FC20825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4CpN734mB8zDqkm
	for <linux-erofs@archiver.kernel.org>; Sun,  6 Dec 2020 08:31:27 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=xiang@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=fJFYR/fK; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4CpN464tkrzDqTZ
 for <linux-erofs@lists.ozlabs.org>; Sun,  6 Dec 2020 08:28:54 +1100 (AEDT)
Date: Sun, 6 Dec 2020 05:28:38 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1607203731;
 bh=4z48dUqSouK4GSOzBXOaPmeem+ji2gnvk6THESip6uY=;
 h=From:To:Cc:Subject:From;
 b=fJFYR/fKFfy0YWlb2GqgxhVtW+m8tzWcp6Odaewz4daoSs2eKcKQ0rBz1RFj4DClq
 ucVLXGfam/imDDRLmj7KcqGD25dwJr52bOe6wlUAitnc4/qUo0u7yBvVy916APDU2L
 0n5JLSBR7XQej2VdzJsaG+es6B8tcFCB08DLAZnugNvQfvnemrJJ2K5YM/6ENqYlIJ
 rtvB+qcQ/6sRCiXaGtwyG9dD2bKbsUtpL3FO0uwSiwNdxWBdIVeKYJ8KhCralMmVvb
 LbQGss2e+tt1ieU3AoBB85F+jFaupknPZP8iKIlOBqxcUb7VyppyKRDGN34b8TF+PV
 mUBGTdyzZYqQg==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Subject: [ANNOUNCE] erofs-utils: release 1.2
Message-ID: <20201205212511.GA15184@hsiangkao-HP-ZHAN-66-Pro-G1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
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
Cc: linux-fsdevel@vger.kernel.org, Miao Xie <miaoxie@huawei.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi folks,

A new version erofs-utils 1.2 is available at:
git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git tags/v1.2

It mainly includes the following changes:
    - (mkfs.erofs) support selinux file contexts;
    - (mkfs.erofs) support $SOURCE_DATE_EPOCH;
    - (mkfs.erofs) support a pre-defined UUID;
    - (mkfs.erofs) fix random padding for reproducable builds;
    - (mkfs.erofs) several fixes around hard links;
    - (mkfs.erofs) minor code cleanups;
    - (mkfs.erofs, AOSP) support Android fs_config;
    - (experimental, disabled by default) add erofsfuse approach;

The big part is erofsfuse, which is intended to support erofs for
various platforms (mainly older linux kernels for building servers
to patch images) and for new on-disk features iteration. It focus
on simplicity and portability thus no optimal optimization such as
in-place I/O or in-place decompression (Therefore, NEVER use it if
performance is the top concern.) It can also be used as an unpacking
tool for unprivileged users. Thanks Jianan for originally picking
it up, erofsfuse finally got in shape. However mainly due to some
lz4 1.9.2 issue, it has to be disabled by default until the recent
lz4 1.9.3 is widely distributed. Please kindly carefully read README
before trying it out.

erofs-utils has been included into many distributions, buildroot,
and Android AOSP for a while, therefore it's quite easy to have a
try and here is the latest benchmark on my PC for reference:
https://github.com/erofs/erofs-openbenchmark/wiki/linux_5.10_rc4-compression-FSes-benchmark

Plus, it's known that EROFS is commercially using by several Android
vendors for their system partitions as an acceptable compression
solution with good performance.

EROFS fixed-sized output LZMA support is still slowly ongoing since
I need to seek some full time to fully calm down and focus on the
algorithm details itself, I will update on the mailing list when
I get a significant progress.

Thanks,
Gao Xiang

