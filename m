Return-Path: <SRS0=VVqX=2B=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3037C43603
	for <linux-erofs@archiver.kernel.org>; Wed, 11 Dec 2019 18:42:17 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A6A47206A5
	for <linux-erofs@archiver.kernel.org>; Wed, 11 Dec 2019 18:42:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="fmlgzFot";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=aol.com header.i=@aol.com header.b="Z+uVRsdH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A6A47206A5
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from lists.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 47Y5Pz5qlDzDqvW
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Dec 2019 05:42:15 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1576089735;
	bh=rnxN1J+JX8WwI4LNIxl3JWfBz07+8/5ORh3/tGFMxpg=;
	h=Date:To:Subject:References:List-Id:List-Unsubscribe:List-Archive:
	 List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=fmlgzFot0qBztzIE7P4vTa1Xjea0IRbnsNuLigRIPHxrw2PYRnykxGVSzEXVLn0s1
	 iihxsWY0ucJbsPUy+zyhOnoQIxFOaVaEGNaXxcaJXBnmFXG4AK4v2EmWGKNz0nmciT
	 uZdng67nHH/kdjPLoMUUw5+1VTtd5Ck/Qk0OKR4S6QjixLXYdxVz7xs6+19+3ueFdd
	 WwUx8n26z4liNWMoMSUSfFIV0L27s2ddPAYQKDtG3FAAdVxTlx0jiqSY+JPHnW1uuc
	 EOqCEdQlFtwapNelKleWYiL2RDggi09bbrEI211qPLKw7a6AoaBZd63i4yDpB4Hn+v
	 ldJGsMUyFrVxg==
Authentication-Results: lists.ozlabs.org;
 spf=pass (sender SPF authorized) smtp.mailfrom=aol.com
 (client-ip=98.137.64.148; helo=sonic301-22.consmr.mail.gq1.yahoo.com;
 envelope-from=hsiangkao@aol.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=reject dis=none) header.from=aol.com
Received: from sonic301-22.consmr.mail.gq1.yahoo.com
 (sonic301-22.consmr.mail.gq1.yahoo.com [98.137.64.148])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 47Y3N10JNBzDqDN
 for <linux-erofs@lists.ozlabs.org>; Thu, 12 Dec 2019 04:10:22 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048;
 t=1576084215; bh=zh+Qq4KKIZBWaPq05JcdqJTq0ZIdb2xT9gPdRoh6Iu4=;
 h=Date:From:To:Cc:Subject:References:From:Subject;
 b=Z+uVRsdHOXjOjjD9kXgyXgiLKGsj3ENObF3fxk7XwSy5K80VnFlmWQ4RYKetMSFs0vYkLW+LzHhOghKRoY2OoA6sa5kwxCrJwy7dCBCSBr8zyBNP+T4C22OTdEnxxICWIRkkHw9/kSByzfdu62QDKpe3pQFPmGV6QO/zh/Pt7l0mtjbAh2nki4PCXinp574TEXo0dHWm/NqyAYpL7qg+/fkQIK90+Ou7AAQ6/kTxpppRi14EScK12dij6bajPtWdkhIYrBHIA54URZ0k9YSN6arXRJg1dlfTCVxfW6Lh/zc4GDdWfv+qcDJFhx+F3V0V/8CG1YMlVusWrWoogYtQQg==
X-YMail-OSG: WG8ijLUVM1kklRgyAHjAJW0GX8ixNnkB.BQrGKakTRErvtKWMMgVhn1zd2ZVceK
 NdtyTOS.pE0VJ3X0j0YcdgenF4f3E_Yz8F7H4SiHQlMn5m46Lj8i.j3Q4_g9ONYm4OauQq9L0m_K
 ERLQxrsbAqEL.T1z9NKHmvAjaVpHVbZZ2rPNOzPMzunok6QfhV7miYZhGWkUgf3Gx2az1pYr_8Bz
 w_7K8OLUTex5GtLM38kK9sHSgvU8Gf_CGNX94RcTscCpUhhrCPqdjovKewaDtTojK17UE20OKDL8
 ygnY5ed_cA6oT27gzyKcf55Lwr4_551HdcvJc16AW9.yf3p60aboUwMZNGKDkgxG5RFw5CFlouXo
 3ya7tVxa3LaxAEgZiWb0Lb9MAXPNqpC0DB53NMyfW9Os70jG9ibKkMz_DYvxyKmph1GynRg5KLqE
 ovsNgOiXXYKkoplpnKDnzOuAP9t9DQXggapzFvR2rSuSZdXTYlv3t00Ob_rvk6KNkAVY1W0rBJb7
 Dc9encw4cYxTopFCQ5j_aAnv4kBE4bXtI6PQhptegeACwIbLRAqv9CuPlrhEwWbNYXIB8g4zp6I_
 jYKBNbK4oBUjUk7YcHi2gPqUd.U2uFmhBNM8sbzlGPrkeFKy6fFEJt41Mkfi_6lGbn_aofA8xIJZ
 ceY9hSCoUtBN_4EWIeT75aHow2.J4N98eW2NgkW_4.k2fdgDVMWcseihOeyxCx2RFkbxsd9KdLsg
 j_glcQtModUuCYoNeNR6JvZkLpvyLURWiL050PEwLk.vRMBr0_l_AGCz0OmYpPbR9jCNAyfdEhhl
 KtPQ0J98Q2PqhDx1.a1U5tY_aSnis19.hlcB9oV1Kkq_yHaVbnERSdp3dFVlISxTo_Ki6bzDNdTm
 9SbyWYt3quGH6JFZaYcV4dmqOHH_uvEjJqcQL2gPmpsDBeXfEVkUlswcR4LVD9Zt19LSJK5wTsO6
 PBjIXfgDnE4HETtrwZijzELnoRTbj6hl18XmBEmV7wHbe4i4WUYyKZ3MFfRia6CX96e.uCYd3gEu
 8IQcrQeSNQvsrFvwdrsgDdBOEd4LDndHg5JmRwFncasxCmzt_m.4ETAJYcjFPQMrOntdflK5lIFb
 AzKm.lz.TSGFbxX9io7cq_.IpF7aEZ.JOxffZdntPQ3O.QIUfzDMkzzudZuvJLgrBCodCEVSzOIX
 ffrXtZ5wkcWoANy8mBzvR1VQ91jSswxIPPTvH671QZrrpaC8ei5arEUFB3LMXSw68UPLwE4_zUSE
 hnHs6gNXvtyynnkdkTyWZ2BFitDQUBhyYbuM4A81pAGH80hI_NIRfbtR7tq8aH4iP6MmsBRncc3m
 _33mUcV_GPkTNmc_Xme5PPcskO6boB2jFJmNE1AQrqWIT6ZsO1FgPHA6oJzzeZNxFgYx83jARxwL
 loPCHanaSMSkb
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic301.consmr.mail.gq1.yahoo.com with HTTP; Wed, 11 Dec 2019 17:10:15 +0000
Received: by smtp413.mail.ir2.yahoo.com (Oath Hermes SMTP Server) with ESMTPA
 ID 78b50f606b195eafc3a6178574d6a883; 
 Wed, 11 Dec 2019 17:10:09 +0000 (UTC)
Date: Thu, 12 Dec 2019 01:09:58 +0800
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] erofs fixes for 5.5-rc2
Message-ID: <20191211170950.GA16027@hsiangkao-HP-ZHAN-66-Pro-G1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
References: <20191211170950.GA16027.ref@hsiangkao-HP-ZHAN-66-Pro-G1>
X-Mailer: WebService/1.1.14728 hermes Apache-HttpAsyncClient/4.1.4
 (Java/1.8.0_181)
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
 David Michael <fedora.dm0@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Miao Xie <miaoxie@huawei.com>,
 LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 linux-erofs@lists.ozlabs.org, Wang Li <wangli74@huawei.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Linus,

Could you consider these fixes for this 5.5 round?

Mainly address a regression reported by David recently observed
together with overlayfs due to the improper return value of listxattr()
without xattr. Update outdated expressions in document as well.

Thanks,
Gao Xiang

The following changes since commit 219d54332a09e8d8741c1e1982f5eae56099de85:

  Linux 5.4 (2019-11-24 16:32:01 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-5.5-rc2-fixes

for you to fetch changes up to ffafde478309af01b2a495ecaf203125abfb35bd:

  erofs: update documentation (2019-12-08 21:37:01 +0800)

----------------------------------------------------------------
Changes since last update:

- Fix improper return value of listxattr() with no xattr;

- Keep up documentation with latest code.

----------------------------------------------------------------
Gao Xiang (2):
      erofs: zero out when listxattr is called with no xattr
      erofs: update documentation

 Documentation/filesystems/erofs.txt | 27 ++++++++++++++-------------
 fs/erofs/xattr.c                    |  2 ++
 2 files changed, 16 insertions(+), 13 deletions(-)
