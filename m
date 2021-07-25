Return-Path: <SRS0=rb4k=MR=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_REPLYTO_END_DIGIT,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D30C4338F
	for <linux-erofs@archiver.kernel.org>; Sun, 25 Jul 2021 06:43:23 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 08ADE60F36
	for <linux-erofs@archiver.kernel.org>; Sun, 25 Jul 2021 06:43:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 08ADE60F36
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GXYRD40Mzz30CW
	for <linux-erofs@archiver.kernel.org>; Sun, 25 Jul 2021 16:43:20 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1627195400;
	bh=JgA2DdC18ssah1Z00lD2mxeo2wHaBQkHZMExYmN2qWs=;
	h=Date:Subject:To:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=WDrB5ZFiGcWMxshhNGrJc+kTM99ZBAaDTjvX3f+ossuo9FzuO4mlddep+biRMXgco
	 PkWLBoa4+2z9gthD6wfMJSGKoSxOf7ydfys1UhY0G7BXJ6NBwGCd/t7w635dUzKlUC
	 Pb3bM8MxqzLXil0+1f72lSGP/HaAV943z3Swv8qcARBME8o74k2Gnt+GAcsRIWG/EC
	 g8X/r/H+QrNxjQHVJ86Zmu2hecLXqP8AghqCqnLQjck4sn1egqDquAs8nN8t+MvBi4
	 r7pp8tuEfibmjsDsFFP+USopsoIOiD8Q7YjRJj6AJeLipbLmRieIMu4V0iwEv2afyk
	 4zZPg7XMUzf1g==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=icloud.com (client-ip=17.58.63.183;
 helo=st43p00im-ztbu10073701.me.com; envelope-from=hess.c58@icloud.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=icloud.com header.i=@icloud.com header.a=rsa-sha256
 header.s=1a1hai header.b=xkrY7Chw; dkim-atps=neutral
X-Greylist: delayed 394 seconds by postgrey-1.36 at boromir;
 Sun, 25 Jul 2021 16:43:15 AEST
Received: from st43p00im-ztbu10073701.me.com (st43p00im-ztbu10073701.me.com
 [17.58.63.183])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GXYR708mfz2yPB
 for <linux-erofs@lists.ozlabs.org>; Sun, 25 Jul 2021 16:43:14 +1000 (AEST)
Received: from smtpclient.apple (179.sub-174-251-135.myvzw.com
 [174.251.135.179])
 by st43p00im-ztbu10073701.me.com (Postfix) with ESMTPSA id DD9514C035A;
 Sun, 25 Jul 2021 06:36:38 +0000 (UTC)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (1.0)
Date: Sun, 25 Jul 2021 02:36:37 -0400
Subject: Re: [PATCH v2 3/3] erofs-utils: support randomizing pclusterblks in
 debugging mode
Message-Id: <30A594F3-3E8A-4E23-BAE5-78681F1BB7AC@icloud.com>
To: xiang@kernel.org
X-Mailer: iPhone Mail (18G69)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391, 18.0.790
 definitions=2021-07-25_01:2021-07-23,
 2021-07-25 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=830 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2107250045
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
From: Christopher Hess via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Christopher Hess <hess.c58@icloud.com>
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Fix code source 

Sent from my iPhone
