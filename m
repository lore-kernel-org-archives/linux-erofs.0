Return-Path: <SRS0=1sIR=K2=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C37EC47082
	for <linux-erofs@archiver.kernel.org>; Mon, 31 May 2021 16:21:14 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1DDE461396
	for <linux-erofs@archiver.kernel.org>; Mon, 31 May 2021 16:21:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DDE461396
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Fv0sM6vh4z2ymS
	for <linux-erofs@archiver.kernel.org>; Tue,  1 Jun 2021 02:21:11 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=vAjF7s/q;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=xiang@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=vAjF7s/q; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Fv0sG4khJz2xtk
 for <linux-erofs@lists.ozlabs.org>; Tue,  1 Jun 2021 02:21:06 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99A6160232;
 Mon, 31 May 2021 16:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1622478063;
 bh=dxosx0uiZE6vTh8Ya6hRhelnWIICwcihOzUewBbWULA=;
 h=Date:From:To:Cc:Subject:From;
 b=vAjF7s/qxzQs1X4a56XkumN/elIMkS1TeigSa6Ud0WctaFk7VEVDhdqbspEYVP5Dp
 akuO1r1bXcTdGO8Ued/Czb1gYkcIK8DkpbEAmLGPV9hgw+MIIwNpPDDgnXdYz+tRNE
 f0uMOWsCWQmG+ziORxqls/ekrEJSuDRJxp6EZa4ifJxxKfgbTLkKvo2Qa67m8EQCKI
 3AJ5emzlSZFYnvLkx9PBP8PXh8TIwXNMBOXxdcgT+KV2JxfrJ3azU91xvpu5XTPFsW
 BBq6dkjI+jJ2gY8Ipwn6Jjp/zgmWOydW9e2APGQxv9Go5mLad8He8thVYQdQQZEBZc
 cEDtHxoxO+Zag==
Date: Tue, 1 Jun 2021 00:20:56 +0800
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Subject: [ANNOUNCE] erofs-utils: release 1.3
Message-ID: <20210531162055.GA18956@hsiangkao-HP-ZHAN-66-Pro-G1>
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
Cc: kernel-team@android.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
 Miao Xie <miaoxie@huawei.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi folks,

A new version erofs-utils 1.3 is available at:
git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git tags/v1.3

It mainly includes the following changes:
   - support new big pcluster feature together with Linux 5.13+;
   - optimize buffer allocation logic (Hu Weiwen);
   - optimize build performance for large directories (Hu Weiwen);
   - add support to override uid / gid (Hu Weiwen);
   - add support to adjust lz4 history window size (Huang Jianan);
   - add a manual for erofsfuse;
   - add support to limit max decompressed extent size;
   - various bugfixes and cleanups;

One notable update is that it now supports EROFS big pcluster [1][2],
which allows compressing variable-sized data into more than 1 fs block
by using fixed-sized output compression [3]. It can be used for some
(sub)-files with specific data access patterns (such as oneshot data
segments which need better compression ratio and thus better sequential
performance.)

Note that users can write their own per-(sub)files big pcluster
strategies to adjust pclustersize in time according to file type static
analysis or historical tracing data in z_erofs_get_max_pclusterblks().
And default strategies will be developed and built-in laterly in the
future.

btw, I've heard more in-market products shipped with EROFS, for example
OPPO [4] and Coolpad [5] with some public news plus more in-person
contacts from time to time. It's always worth trying and feedback or
contribution is welcomed.

[1] https://www.kernel.org/doc/html/latest/filesystems/erofs.html
[2] https://lore.kernel.org/r/20210407043927.10623-1-xiang@kernel.org 
[3] https://www.usenix.org/system/files/atc19-gao.pdf
[4] https://new.qq.com/omn/20210312/20210312A0D9HT00.html
[5] https://hunchmag.com/helio-g80-erofs-48-mp-arcsoft-and-cool-os-coolpad-cool-2-smartphone-announced/

Thanks,
Gao Xiang
