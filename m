Return-Path: <SRS0=7dAB=6Q=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	FREEMAIL_REPLYTO_END_DIGIT,FROM_EXCESS_BASE64,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9832C3A5A9
	for <linux-erofs@archiver.kernel.org>; Sat,  2 May 2020 15:36:24 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6312821835
	for <linux-erofs@archiver.kernel.org>; Sat,  2 May 2020 15:36:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=k008.k008jp7657.info header.i=@k008.k008jp7657.info header.b="ugU28Xte"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6312821835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=k008.k008jp7657.info
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 49DtWT6SmBzDrPq
	for <linux-erofs@archiver.kernel.org>; Sun,  3 May 2020 01:36:21 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=k008.k008jp7657.info (client-ip=133.167.78.227;
 helo=k008.k008jp7657.info; envelope-from=m020b309@k008.k008jp7657.info;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none)
 header.from=k008.k008jp7657.info
Authentication-Results: lists.ozlabs.org;
 dkim=fail reason="signature verification failed" (1024-bit key;
 unprotected) header.d=k008.k008jp7657.info header.i=@k008.k008jp7657.info
 header.a=rsa-sha256 header.s=default header.b=ugU28Xte; 
 dkim-atps=neutral
X-Greylist: delayed 4540 seconds by postgrey-1.36 at bilbo;
 Sun, 03 May 2020 01:36:14 AEST
Received: from k008.k008jp7657.info (os3-369-17723.vs.sakura.ne.jp
 [133.167.78.227])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 49DtWL1FTKzDqVx
 for <linux-erofs@lists.ozlabs.org>; Sun,  3 May 2020 01:36:13 +1000 (AEST)
Received: by k008.k008jp7657.info (Postfix, from userid 1029)
 id C932B158B78; Sat,  2 May 2020 23:20:32 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=k008.k008jp7657.info;
 s=default; t=1588429232;
 bh=qrIXAAPu1T5dZPxqScLUB3bS73LGnyGrCe5lniwtpCg=;
 h=To:Subject:From:Reply-To:Date;
 b=ugU28Xte+PQyuAG9YAVrq5TW/o2B79z2EaCx6PWi4VUQqRpS90RDzddUhujVjmLK3
 liDvKQhwl1voG1GYxcJ6nCiNvnK1qQgRtFvGVo/G/ZYiQALpgQcF1+LzMT7qweM5iT
 89Sje2LTDFqAM1nhmSgLo3e2hFKgDme1GIm3Mtlg=
To: linux-erofs@lists.ozlabs.org
Subject: =?UTF-8?B?UGFydG5lcnNoaXA=?=
From: =?UTF-8?B?QWxpc3RhaXIgQ3Vycmll?= <no-reply@k008.k008jp7657.info>
MIME-Version: 1.0;
Content-type: multipart/mixed; boundary="--pgrdvfMkL3"
Message-Id: <20200502142032.C932B158B78@k008.k008jp7657.info>
Date: Sat,  2 May 2020 23:20:32 +0900 (JST)
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
Reply-To: alistaircurrie01@gmail.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

----pgrdvfMkL3
Content-type: text/html; charset="utf-8"
Content-Transfer-Encoding: 8bit

<div style="font-family: &quot;Times New Roman&quot;; font-size: medium;"><font face="Arial, Verdana"><span style="font-size: 13.3333px;">Attn: Dear</span></font></div><div style="font-family: &quot;Times New Roman&quot;; font-size: medium;"><font face="Arial, Verdana"><span style="font-size: 13.3333px;"><br></span></font></div><div style="font-family: &quot;Times New Roman&quot;; font-size: medium;"><font face="Arial, Verdana"><span style="font-size: 13.3333px;">I have a high net worth investor that has expressed interest in establishing</span></font></div><div style="font-family: &quot;Times New Roman&quot;; font-size: medium;"><font face="Arial, Verdana"><span style="font-size: 13.3333px;">a strategic partnership Business Alliance with you.</span></font></div><div style="font-family: &quot;Times New Roman&quot;; font-size: medium;"><font face="Arial, Verdana"><span style="font-size: 13.3333px;"><br></span></font></div><div style="font-family: &quot;Times New Roman&quot;; font-size
 : medium;"><font face="Arial, Verdana"><span style="font-size: 13.3333px;">Kindly respond back for more details</span></font></div><div style="font-family: &quot;Times New Roman&quot;; font-size: medium;"><font face="Arial, Verdana"><span style="font-size: 13.3333px;"><br></span></font></div><div style="font-family: &quot;Times New Roman&quot;; font-size: medium;"><font face="Arial, Verdana"><span style="font-size: 13.3333px;">Warm Regards,</span></font></div><div style="font-family: &quot;Times New Roman&quot;; font-size: medium;"><font face="Arial, Verdana"><span style="font-size: 13.3333px;">Alistair Currie</span></font></div>
----pgrdvfMkL3


----pgrdvfMkL3--
