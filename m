Return-Path: <SRS0=gwdc=HY=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.6 required=3.0 tests=BAYES_50,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_WIN,LOTS_OF_MONEY,
	MAILING_LIST_MULTI,MONEY_FREEMAIL_REPTO,MONEY_NOHTML,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 648C2C433DB
	for <linux-erofs@archiver.kernel.org>; Mon, 22 Feb 2021 14:14:53 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 900B864E20
	for <linux-erofs@archiver.kernel.org>; Mon, 22 Feb 2021 14:14:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 900B864E20
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Dkkhq1D71z3cGj
	for <linux-erofs@archiver.kernel.org>; Tue, 23 Feb 2021 01:14:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1614003291;
	bh=29phq03JbaTXf6u8ApipDfHL2BWZMZe3Qh4TVsbTFNA=;
	h=Subject:To:Date:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=ctSZSLoqtw0v42rLie2vk5dr4wanfTD2KIJmgDO+Q1Rcx+aVaYgveL3k7wzBkO2+R
	 U0ClhjwYs9e7yE4B8s8KmH0fRa4LgGuHE87GZdqTLsLPpnVqCdPvI7ebC3bbjiya0c
	 J/h4m/BGbXn2EGkUDA30MYzPp19EW/lQrpxHJMaY+PJHBU3tDXwbngIBVGI8unAvft
	 8QlXcggiZfa63dILN7wAiLh6KFTvVrOHY3QoXSk965bJgg3w/fApKZfDvyIx73f4+L
	 X7pERBnClvrVjhYnm/7tgDdRFHAC++RljBeCD6hZx3vwJjt0GR4qv5ImIgE8lh5Fp6
	 SyrUuxD+PizPA==
Authentication-Results: lists.ozlabs.org;
 spf=neutral (access neither permitted nor denied)
 smtp.mailfrom=namakaran-alu.com (client-ip=139.59.75.255;
 helo=mail.shezartech.in; envelope-from=acc@namakaran-alu.com;
 receiver=<UNKNOWN>)
Received: from mail.shezartech.in (mail.shezartech.in [139.59.75.255])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Dkkhm1rgqz30MB
 for <linux-erofs@lists.ozlabs.org>; Tue, 23 Feb 2021 01:14:46 +1100 (AEDT)
Received: from [103.99.1.174] (unknown [103.99.1.174])
 (Authenticated sender: bitdefender@shezartech.in)
 by mail.shezartech.in (Postfix) with ESMTPA id C5C4D3FEAB6
 for <linux-erofs@lists.ozlabs.org>; Wed, 17 Feb 2021 21:56:51 +0530 (IST)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Congratulation: You're a winner!
To: linux-erofs@lists.ozlabs.org
Date: Wed, 17 Feb 2021 08:26:49 -0800
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
From: Euro Millions via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: ste68ven@gmail.com
Cc: Euro Millions <acc@namakaran-alu.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
Message-Id: <4Dkkhq1D71z3cGj@lists.ozlabs.org>

CONGRATULATION!!!
 =

With reference to the 1,377th EuroMillions draw which took place on Tuesday=
 1st December 2020 at 21:00 CEST (20:00 BST) and the winning numbers drawn =
were:
 =

Lucky numbers 14-20-29-47-49 Star Number 4-12 Millionaire Maker: MNHF52876 =
serial number ZWWD49193 Prize credited to file EURO/86169/2021
 =

An official letter was sent to your address. Your email address has been aw=
arded the sum of 2,713,908.40 GB pounds. Kindly, confirm receipt of this no=
tification by contacting your claims officer Mr. Kennith William for more d=
etails.
 =

visit the link https://www.euro-millions.com/results/01-12-2020 to view you=
r winning details as published on the Euro-Millions site.
 =

Euro-Millions prizes must be claimed within 180 days of the draw date. This=
 is a confidential mail sent to ONLY winners of this draws.
 =

If you have any questions, please contact our customer support.
 =

 =

Kind regards,
Peter Jones
Customer Support
EURO-MILLIONS
Customer Service
UK Regional Office
Acorns Oakwood Park Business Center
Fountains Road Bishop Thornton, Harrogate
HG3 3BF, UK.
