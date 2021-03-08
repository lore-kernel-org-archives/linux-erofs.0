Return-Path: <SRS0=quJP=IG=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.8 required=3.0 tests=BAYES_50,DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_REPLYTO_END_DIGIT,
	HEADER_FROM_DIFFERENT_DOMAINS,LOTS_OF_MONEY,MAILING_LIST_MULTI,
	MONEY_FREEMAIL_REPTO,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DAF1C433E0
	for <linux-erofs@archiver.kernel.org>; Mon,  8 Mar 2021 09:52:40 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7441F651B9
	for <linux-erofs@archiver.kernel.org>; Mon,  8 Mar 2021 09:52:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7441F651B9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=5fafa.xyz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4DvDCp0wmNz3cM4
	for <linux-erofs@archiver.kernel.org>; Mon,  8 Mar 2021 20:52:38 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=5fafa.xyz header.i=nami@5fafa.xyz header.a=rsa-sha1 header.s=default header.b=FJ506TQi;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=5fafa.xyz (client-ip=106.75.237.29; helo=5fafa.xyz;
 envelope-from=nami@5fafa.xyz; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=5fafa.xyz header.i=nami@5fafa.xyz header.a=rsa-sha1
 header.s=default header.b=FJ506TQi; dkim-atps=neutral
X-Greylist: delayed 16453 seconds by postgrey-1.36 at boromir;
 Mon, 08 Mar 2021 20:52:35 AEDT
Received: from 5fafa.xyz (5fafa.xyz [106.75.237.29])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4DvDCl1LC0z3cJ2
 for <linux-erofs@lists.ozlabs.org>; Mon,  8 Mar 2021 20:52:34 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; s=default; d=5fafa.xyz;
 h=From:Subject:To:MIME-Version:Reply-To:Date:Content-Type:Content-Transfer-Encoding;
 i=nami@5fafa.xyz; bh=NxP5VtJjwHufso4gXAJ75krU5YQ=;
 b=FJ506TQisTnh3kg7x3H66aOcrJcKRo/Lj6BWS+in68PBXm39cog58j6oTFTWlzGaR6l78OrM4i9U
 HhZAi+kGA+LL43DGBHaK8m2Aj27LokZyjd9Gx99g537UTBC0/Ru1BxFwRjYXf1hx2sQkJkik1AAL
 MPr/k88YXszdziL3Vm8=
From: "Ms. Melvida Bullock" <nami@5fafa.xyz>
Subject: Greetings Dear Beloved:
To: linux-erofs@lists.ozlabs.org
MIME-Version: 1.0
Date: Mon, 8 Mar 2021 13:01:16 +0800
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
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
Reply-To: melvbullockzone123@gmail.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
Message-Id: <4DvDCp0wmNz3cM4@lists.ozlabs.org>

Dear Beloved,

Life is gradually passing away from me as a result of my present medic=
al condition and my personal doctor confided in me yesterday that I ha=
ve only a few more weeks to live. In view of this setback, I want to d=
onate my estate for humanitarian assistance, since this has always bee=
n the plan of my late husband and besides I have no child. In an effor=
t to compliment the good work of our creator for humanity and the wish=
 of my late Husband I donate the sum of 10,000,000.00 Euro (Ten Millio=
n EUR) to you. Upon your acknowledgement of this mail and informing me=
 of your nationality and current place of resident, my Bank will facil=
itate due processes for transfer of this legacy to you. May God bless =
you as you use this money judiciously for the work of charity to help =
the less privileged.

Sincere regards,

Ms. Melvida Bullock
Email: melvbullockzone123@gmail.com

