Return-Path: <SRS0=iiW+=DS=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B278CC433DF
	for <linux-erofs@archiver.kernel.org>; Sun, 11 Oct 2020 23:49:08 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A8242207FB
	for <linux-erofs@archiver.kernel.org>; Sun, 11 Oct 2020 23:49:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="oGh4Mf2I";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=aol.com header.i=@aol.com header.b="Pw4E0z4V"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8242207FB
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4C8dnG0ZDzzDqsC
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2020 10:49:06 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1602460146;
	bh=cZ+5bLqyAO43Nz9zRHG8dK9YFtjc1vDgZkv758TEpS0=;
	h=Date:To:Subject:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=oGh4Mf2I/yFoEqSXYkmy1vlgstxHow3RM4pcfvjxDppO3XJZYzxXvA4/N2g1+dU3M
	 USjH6KFGK/rZl3JKqjmLM9tOowv5D5L8g+wSIQW5OKZI+3X3ilmZT0Begir+NcsaR1
	 wHYHPQ6SfcYxXHB+HqBtmp5zEm2RvH8YK0M0DSVXt/C8Auf499xxJ6sGoIo81LSJ2s
	 HyoBcMBj6T75xyISnRXLrNH2uf8J4bTnzIdxIGuAXdi9qAEUNCZoSCTtD9QBRBrqe2
	 55VS84yoYYfd6OgON+UYANVDCYA82uAPOQDZXhR2XEO3NG5BX8w5RWTyPFWuRuBQq5
	 WJ/qLLkkJOEdA==
Authentication-Results: lists.ozlabs.org;
 spf=pass (sender SPF authorized) smtp.mailfrom=aol.com
 (client-ip=98.137.65.83; helo=sonic313-20.consmr.mail.gq1.yahoo.com;
 envelope-from=hsiangkao@aol.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=aol.com header.i=@aol.com header.a=rsa-sha256
 header.s=a2048 header.b=Pw4E0z4V; dkim-atps=neutral
Received: from sonic313-20.consmr.mail.gq1.yahoo.com
 (sonic313-20.consmr.mail.gq1.yahoo.com [98.137.65.83])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4C8dn23JB2zDqqD
 for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2020 10:48:50 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048;
 t=1602460126; bh=tuos+LOxwqu9pbYehTZRSd3JkdEr+dAj5yJ1Dyed1C0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From:Subject;
 b=Pw4E0z4VIacqIsOlIX7s0/FQlXx9nbaAkdu/oKjSn3T6wyPMyTwL7K8KZcbP3gD8CTGO9BalU/wMekbphYtdXMJRg+2PpzBwk4NSlfbqYaffB46uXfogaE+ngg5YEGI0EJkxofFYLtKUXcNlrWDIGZLunKnrOhXy32Ov7Rxaf38oasLvOsaQNNR19F1qPkCErw2h8dmhxSSs3OEzNsm5GTk15iISMkjEGmg2+cE3HYlp76on0fnIBrIuMyuFNV8941tgVeZS2i62OOSmW4otyL37CHDvMNkDG+rYYnfltNHu9YZdicQZhsBVrUTPTwXtELQEAt9CCLD6u2ZT55hHdQ==
X-YMail-OSG: US4YbiYVM1l496yUxf7x6HIdp2FsMa1MGPmly.ltiELmkbqgw1WherTtuUa7Iq9
 sWX6T_Nkmpl4mbdeyVNpq.9nFvSNv.._5T9_uAwji4.XbJWIendEh22XDyRg_FkY9f.k3VRdyVmS
 FkRvD5TxZYqZx_50XjviowPCRW1R2p8zdt12kAHB2PLHp4CEAw8E377t28L9p0QX_48lsKcFVEY9
 qe9HywiLV7iZ2lA2dkpHKgC1YETcDnAxxPnABITHANGXI0kIlEkDx3sS9srJk4eRFjuRarhV5rvL
 m4plPEnMo1pzO7_LCAIqzXH3FPxBkhpqKKMYYDt7BbQWFa76vE6YPfN6YtbVQFIpVSV8xy3fNLCG
 MhxvErEbvywatEOyyAIhukhwRYyWcekCR3Mror8G.CHgOzyXbXTBqQ3oVYD9lsvHLUHNg0LFabkM
 tQzsLX5KYYRAA.Sug8yuMlyXatL5voJ_QgNpwsO_zGRjuQLHavS7bxxOjFOTBKprgtu5PhH5SW.r
 dhRzW2wcagWRVeDOKZkVBfBOxlbKG3Iy6gK_OqpSosRHaKUa9Z7vSTDT6XAzvDY6rNdFcisrevp1
 003Ai9BeOOCnWmMnSc_f92RW2G76R78iZvD75OneW4gn3JxxHRY4LF6Rx07Tn2RtlEraUYjY0m2O
 5RNKQ1WpNUeNA8jVAvKP.y2JijR9Vw_J2h9mBjfrHlvUALbMxOsCC_zZW2d_EXi320Ha2E_UAkOX
 15BHeDAVjYm5heCTeiUirKKu.vf60xX_XUu57k_N7vUWcGbftU1GcXha23V0TW7S7N6iU3Jy087p
 1OVoRACctp.c1ApkQPGnZgHM32Xq581OUKa.t4CZQxeIZoWMiBkuKao65rhJhwW6ULVy_F4C2SS8
 S.b5N.oPfmWvd74pn7uKvmhfMa4937Zh4MOL2W8z.y_451Re6nzzcf7HiH8gIcl7NaAj.TyRxaK.
 3K4kbeybfRHZMMrBUJv3gtT1QUOCQrwSeXagCfeh.3qaXOesnXDEG8n4wp9OwtgHjKiFP2ajICge
 sOgo6oz67eRGCeiFEvTU3c0A7VVTQLzHBnE32LHKtqUOfvYidYhxDnwmwo5mZ8UiHfOjHGWPlxde
 Ur5BL6GQkKxgKBumsAmcekqVA7wFPLF34lChWl5E_ZXgM2Guh1HdepeNv9eoPe3mnZYOhf2zNr23
 BxsLCvuQSHrMfW0vRSa4nHA4dJg.YFGO2SvZx4i7lU3bchzq3pes4LOVcjSA3rmoikZw7iFhAliA
 qFKvBKceVq.5cdUvtuAYPvvFrFqYwBxe7RSelK4eJPqQTN9LCQK2ulNiy3d9skXLg4kgtC3gMGnS
 cLHVEZmxTRSjSMC0XOfbZFrILgLIkIXOU8rVNP.ncFZxbuDU3l_WUtRZCE9XrlvsMKo_KQ11g_9o
 UaMZuFe11qbtBc9UZlgBdRNmax8.TunujXeDxKwhh5KtDHiBP0SUXkNPa8dbRXVqDXibLGEveum_
 vXZvkJBdzX9AQ835IVbHY4LFtb.F1TT8EFB.Gysd5BaIqaoGRogl0
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic313.consmr.mail.gq1.yahoo.com with HTTP; Sun, 11 Oct 2020 23:48:46 +0000
Received: by smtp408.mail.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA
 ID ae9f6a7169eccc205df40197c5759b99; 
 Sun, 11 Oct 2020 23:48:43 +0000 (UTC)
Date: Mon, 12 Oct 2020 07:48:36 +0800
To: Li GuiFu <bluce.lee@aliyun.com>
Subject: Re: [PATCH v2] AOSP: erofs-utils: add fs_config support
Message-ID: <20201011234221.GA26867@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20200928213549.17580-1-hsiangkao@aol.com>
 <20200929051302.3324-1-hsiangkao@aol.com>
 <7e4490c0-0a3d-0ceb-98ca-73d5eb69932d@aliyun.com>
 <a4b4d4a8-46bc-87d2-eb8a-d1d010f9d76d@aliyun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4b4d4a8-46bc-87d2-eb8a-d1d010f9d76d@aliyun.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mailer: WebService/1.1.16795
 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol
 Apache-HttpAsyncClient/4.1.4 (Java/11.0.7)
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
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Sun, Oct 11, 2020 at 04:53:24PM +0800, Li GuiFu wrote:
> 
> 
> �� 2020/10/10 0:33, Li GuiFu д��:
> > 
> > 
> > �� 2020/9/29 13:13, Gao Xiang д��:
> >> So that mkfs can directly generate images with fs_config.
> >> All code for AOSP is wraped up with WITH_ANDROID macro.
> >>
> >> Signed-off-by: Gao Xiang <hsiangkao@aol.com>
> >> ---
> >> changes since v1:
> >>  - fix compile issues on Android / Linux build;
> >>  - tested with Android system booting;
> >>
> >>  include/erofs/config.h   | 12 ++++++++++
> >>  include/erofs/internal.h |  3 +++
> >>  lib/inode.c              | 49 +++++++++++++++++++++++++++++++++++++
> >>  lib/xattr.c              | 52 ++++++++++++++++++++++++++++++++++++++++
> >>  mkfs/main.c              | 29 +++++++++++++++++++++-
> >>  5 files changed, 144 insertions(+), 1 deletion(-)
> >>
> Please update the usage about mount-point

Ok, make sense. since it has been merged, will add another
patch to handle that.

Thanks,
Gao Xiang

> 
