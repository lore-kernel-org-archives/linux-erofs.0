Return-Path: <SRS0=x6ng=X2=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44BB6C388F3
	for <linux-erofs@archiver.kernel.org>; Tue,  1 Oct 2019 09:10:17 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E792B2190F
	for <linux-erofs@archiver.kernel.org>; Tue,  1 Oct 2019 09:10:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="EvyzAJ7h";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=aol.com header.i=@aol.com header.b="U61gxEK+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E792B2190F
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46jD4l07nfzDqRP
	for <linux-erofs@archiver.kernel.org>; Tue,  1 Oct 2019 19:10:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1569921015;
	bh=kn1FN48dWMtKd+RApOOahlyqJFzmSD4JxKWhCL3wSK4=;
	h=Date:To:Subject:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=EvyzAJ7hnpEBKbsWuj3XoU+t+OtdpPt0Ed8u/Sd+y0tet4VhP3REIkp46IhstbWuM
	 518FwVSlNIVJrJtr1dZuCBfZNOCWXh1viMbUuqNaNls3pS8n8+e8ed0NS8qz5ShNfe
	 82oy2zkX/ooGkXlIUngBVVHr172TB396nEu6EhSYHddOejmr1v1VIHDotpOZilqDAH
	 X+yj3EWWD6qy0AyRS08e+BgmwW8tlAdTxFdyhRCh2FVP+R7We7PgIGWQBUoMatLnir
	 qBbmvcJ79tt+O1IGLePtx0npjddPqcYFVWV3lJDn/9Cvcrib/exV+MVqW4IUycXCEo
	 9S8SZ2eQ7ywYg==
Authentication-Results: lists.ozlabs.org;
 spf=pass (mailfrom) smtp.mailfrom=aol.com
 (client-ip=77.238.176.205; helo=sonic306-19.consmr.mail.ir2.yahoo.com;
 envelope-from=hsiangkao@aol.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=aol.com header.i=@aol.com header.b="U61gxEK+"; 
 dkim-atps=neutral
Received: from sonic306-19.consmr.mail.ir2.yahoo.com
 (sonic306-19.consmr.mail.ir2.yahoo.com [77.238.176.205])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46jD4Y2LrRzDq6k
 for <linux-erofs@lists.ozlabs.org>; Tue,  1 Oct 2019 19:10:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048;
 t=1569920997; bh=/Hwz0MxqOic/tYrg0VLHTdYvhqlYjwGMfuUdJ4Fp1gw=;
 h=Date:From:To:Cc:Subject:From:Subject;
 b=U61gxEK+IDw4uA0RGTv14T/OvCrEnaFObS7Rk+qMd+ExdBGY4iLyWIlC9ZSN83BhK0QMpSTuMmI6/dEs6GsGKID32blYobZm1QfcsosYvlnXoqKzrOZZLr0DMZX+FZMU+Mj5AJvKPvxj6yVHjUNvxawJy5w39kF8Z0X+kG1s4GBstkyPsLq14SVJsStFw5T8fG1T2IjaH4GzM1nGQYcBntqDYlm2m9URDwKk3oBaO+dFyNvC3fpXHdOPgLsXrBoIQsVInYKwDVvddI3ZZYdQuhgEFaKgdyy0cAZRHf/ag2Gwa8105xX6EkMJh4DABGfpm4Um7CaJIADF4cpcAMHAwQ==
X-YMail-OSG: 5mUTXrMVM1k6R82NABifyxjoDszBtHVPR2e.tbio8GPgSirabd608Yq.SXoqhNt
 yNMRlGhgfg4LzQcXcl8W7ViIGWt0b4zzFl1I0e5sSciWQ0q3s5hid81LFyWRU0sSfirwtDUxovFC
 9eeOJ3ca5VS3CumyG6deR0Nzgf1qI.b8ga_1A9zymtOByx4DVjenHexP26aF26rAs7ye6FYFHAJS
 BVAVCeI63RZIE7Pl_Mk7_9iy55J0zfVZ1WD6GPzaT43cM3gg66VFJWXOG8afjFz9iV53pQ7vZTnW
 c5IxHP9xyU23x8Y4JV99QvpR1mzXv9mmM7Cj7OEKmImSDNUkH8YGI0cpCHVefT4MfjPWrPB1LVXe
 sMyRED5yXJGtLdeUCx9P.tSeddXvoNihEhWj20JDaeA0g79Hg2MpxJDH4lM4TyAz.6KCpEm_.4nN
 rvnhnC36KUorRfKGAtqOhnjx6Rq.I48tzo2UPOZkeiWcPq77EGIn_aQz3tRgt5QeDXqfGIiCi9HJ
 vaz22IZIZNCafrJEUkwgUsApkIZtzuuXARWrGfX587vNste_cfLhRuCjuGffvyuvjchDHiskDxhY
 14GTRaB1aht5citBSO9fpOSHndeB2SHGJYiJBpi47mGO._8cxiliKH9K73MIdgC0CqKPhNDjHOJd
 mtXgkXqJoM5lUMtXri1P7SXwTACgYvroesASs4TYcXJWYsLXJpeYvpaPgGPkDCUiZIa6sUwYopQr
 t2gXMc.EReqivzkzQPzuDgqT1YzmjR9ThIlaQoCmz.mMd_36G.uoKanct7Qnp_Ckgoxg9bCTasxO
 3_TmeDGFqmlvqeU8.0bAAvU5_9dYjt.d_BKX4zKS4Ezc9NqkIP_Xgj4UVpHaernyxqu5Nh2Hwkk_
 oCih6J_ocH_coPSAx23.1kFLaCILEJMZnwfB0qKUxnfv4aNK4DI4ZFIhMs.zZTQSazFuKGYBRtUO
 o0y0SLk7U652r8jGnpPtkwhXd1YO84Z3cxuPjq93_Gbs_XP04.jaad2dTPxPqoSshu3ZpMBN1RIm
 VKk0iBTH_kE9nwG6gJKJ66JwCYbwe1Z8m0oqfnxEIoQd1shsdE0dUO3ppFdTg8vNfrZch0eSQxLF
 Hy2fYdGwMSP9eyoTNWFrfK_yNrJXFVaNxBdgHraOd17yma8CHAX8ck7bO9IjPhFQG34DNnKzyQ0z
 o63v6mYlXQ1gGaeBL3Cs.BlNK98PcolUiyP1raRxfAi4C1NKV7qvqhk8PlJyUnvh0rA5A58s8Tky
 RTPnbrfgdISglKo89GLbP3Pvz_puVB64q8IKOS_DKavZ4NRz1J2Ac6NOoJXoiC1WFltjz70KJcGP
 K
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic306.consmr.mail.ir2.yahoo.com with HTTP; Tue, 1 Oct 2019 09:09:57 +0000
Received: by smtp405.mail.ir2.yahoo.com (Oath Hermes SMTP Server) with ESMTPA
 ID c999365307370019789162bfab3ecb7c; 
 Tue, 01 Oct 2019 09:09:53 +0000 (UTC)
Date: Tue, 1 Oct 2019 17:09:43 +0800
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] erofs fixes for 5.4-rc2
Message-ID: <20191001090938.GA30542@hsiangkao-HP-ZHAN-66-Pro-G1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
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
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Miao Xie <miaoxie@huawei.com>,
 LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Linus,

Could you consider this pull request for 5.4-rc2?

3 patches of those address regressions due to recent cleanups, mainly
founded by stress test on latest mainline kernel (no more regression
out compared with older kernels for more than a week). The other patch
updates sub-entries in MAINTAINERS.

All commits have been in -next for a week (since 20190924). In order to
avoiding using a random base of a random day, I just rebased those fixes
on -rc1 stable point without any change, which are now in next-20191001
as well. This merges cleanly with master.

This is my first pull request, due to National Day holiday I'd use my
personal email. I refered many other past pull requests these days,
kindly let me know if something wrong...

Thanks,
Gao Xiang

The following changes since commit 54ecb8f7028c5eb3d740bb82b0f1d90f2df63c5c:

  Linux 5.4-rc1 (2019-09-30 10:35:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-5.4-rc2-fixes

for you to fetch changes up to dc76ea8c1087b5c44235566ed4be2202d21a8504:

  erofs: fix mis-inplace determination related with noio chain (2019-10-01 04:54:45 +0800)

----------------------------------------------------------------
Changes since last update:
- Resolve 3 regressions due to recent cleanups:
  Fix error handling due to avoiding sb_bread in erofs_read_superblock;
  Fix locking in erofs_get_meta_page;
  Fix mis-inplace behavior due to decompression frontend cleanup.
- Update sub-entries in MAINTAINERS in order to better blame.

----------------------------------------------------------------
Gao Xiang (3):
      MAINTAINERS: erofs: complete sub-entries for erofs
      erofs: fix erofs_get_meta_page locking due to a cleanup
      erofs: fix mis-inplace determination related with noio chain

Wei Yongjun (1):
      erofs: fix return value check in erofs_read_superblock()

 MAINTAINERS      |  3 +++
 fs/erofs/data.c  | 10 +++++++---
 fs/erofs/super.c |  4 ++--
 fs/erofs/zdata.c | 12 ++++++++++--
 4 files changed, 22 insertions(+), 7 deletions(-)

