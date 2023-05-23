Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95330C7EE23
	for <linux-erofs@archiver.kernel.org>; Tue, 23 May 2023 07:22:21 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4QQQkM5xsgz3cjW
	for <linux-erofs@archiver.kernel.org>; Tue, 23 May 2023 17:22:19 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1684826539;
	bh=VGixg05Db62qfddCFX/rPrwA4l7xmIo/aIxRW5Mn8l8=;
	h=To:Subject:Date:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:From;
	b=BV6n6O4aQseWZWOYQOq7LU/1CxIwk/wlI0vXSMZaW1nPhdJEs9F1O0S1k7epbaix7
	 StwpO6P4j0XMcHh+SPwEEwkAz11M4mlRt8Dw04qlc4ncJW7p4SLUSkNqeg6ikOoJR5
	 4m2E7GaFvmwmu4Z1eQSqad6ZvS/wVpHfpfY/ljH0BS45VTHor2kBgumWjcghmG76JW
	 7A4i4NikAmlg5WwGMCoV/VHLGi7oeUQLbReuyij/x6VRLKtT3VNLr9e4n26DVe7MSK
	 CFw4EQ8Z50dc8+hjd5Q7Bou0mqZ6DYVPSmSKFHCW/2j6vvoF/3DayMb4JamTK5S9Pc
	 Ax2OnYPexh4tQ==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=qq.com (client-ip=203.205.221.240; helo=out203-205-221-240.mail.qq.com; envelope-from=3064617854@qq.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=gIArOpX3;
	dkim-atps=neutral
X-Greylist: delayed 3628 seconds by postgrey-1.36 at boromir; Tue, 23 May 2023 17:22:11 AEST
Received: from out203-205-221-240.mail.qq.com (out203-205-221-240.mail.qq.com [203.205.221.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4QQQkC4Vnsz3bcF
	for <linux-erofs@lists.ozlabs.org>; Tue, 23 May 2023 17:22:06 +1000 (AEST)
X-QQ-XMAILINFO: M5XvDI2tTifrhf1KqFnyQjvr7qcQSqAYZ2BptP4DZ/SPj733bmp9ZIbhb43ZTs
	 zuOO+cP77CNt4BWMJv6KplcXShIJ8dm9QfRlXDS354a4mSpRJf+VmoY8+cAyoJJPfDc9qYiC802X4
	 TsQde+TpUWa6+IrWki9/kYhvcVa3LFz0NHU5uAdNqVhSFWWsD/PeponMgIdMWPLDbeLOLkr3aO/hY
	 RE9lyFhtnNyfa/BLZYRG6Dz57RyKriZf+cfItGYDnFQA8e+YbeEPJHapQz4SM1cNVW58w46OIBqrl
	 wr+Zug+VWR3BL4TmTMCae7hAJ3T3mCevehLSsOCL3itUDRalc/9BQ2hHXdiBHjsEdxfv+1bWucaGl
	 x4nH+4mkbH5lWzzjQr3IoLIaDDFmfmSazupY0WZmfYFWARE5p6JkU1pMzkU8qBm6fWTkHW+G2hOn0
	 2l4XfLur86MTtqk0abSSK1OTFdMfeICluAXB/PUOuuyrstrZ2PQuvKnF4jdbiHTksdZdgOrQi4FRc
	 pdRG7g6cVNRRQSa/DFbN9BdN3+FuoBkm0c+kVc3IPwwhkw/P+MFrJiks1cZPo7wUJjDJuGR7sD5i+
	 iapYzg1OTaE1CQMa3edKupLsP6H0DizOc5Ko70fInVFUH1vgtvciUlYlkrHS5vHG/JKFT7VFxrflv
	 av35oqupT4Pi+br48rSZ0dK+T7CsCuvbD/DsSMejAi6tqkOPEjltqNlmQ3MZOYUsZlDdkaJOGSNAN
	 8WeGuqBwgKTbfEQpNO8BohbgnXWnYSSauP9nm0dawKsiGsQO4al4WSSYrccvpeRE7Mzo11673W82/
	 hrZaoUJ6WJR0GvkF3MoPVHY8nYU7WVWpYd7erbTzeMnG+mn9mbZrhrGOdXz9ehMbfURjJhvR4xWmr
	 HKxa0hTWQZgfZ2QnFO8WJSXhIrUXLrZ5AS3HrZOoD9hXZ4P+3WLqGemX8tpcPtNZNDTC2/hPQw7zp
	 oiy4VdcYqY0CQfrakzGVTnqtijwt806tKtpPG1t6L2ND9Hi1aj
To: "=?utf-8?B?bGludXgtZXJvZnM=?=" <linux-erofs@lists.ozlabs.org>
Subject: =?utf-8?B?5byA5rqQ5LmL5aSP?=
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_646C5AAF_52386990_0A368C4D"
Content-Transfer-Encoding: 8Bit
Date: Tue, 23 May 2023 14:18:23 +0800
X-Priority: 3
Message-ID: <tencent_17F11CCBC449E7CFA55A1E057EB48FFFD006@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
X-QQ-mid: xmseza12-0t1684822703ty4c2f82y
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
From: =?utf-8?b?54uX5Y23IHZpYSBMaW51eC1lcm9mcw==?= <linux-erofs@lists.ozlabs.org>
Reply-To: =?utf-8?B?54uX5Y23?= <3064617854@qq.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

This is a multi-part message in MIME format.

------=_NextPart_646C5AAF_52386990_0A368C4D
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: base64

5oKo5aW977yM5oOz5LqG6Kej5LiA5LiLRVJPRlPmlofku7bns7vnu5/npL7ljLrnmoTlvIDm
upDkuYvlpI/pobnnm67vvIzmnInmsqHmnInkuqTmtYHnvqQ=

------=_NextPart_646C5AAF_52386990_0A368C4D
Content-Type: text/html;
	charset="utf-8"
Content-Transfer-Encoding: base64

PGRpdiBjbGFzcz0icW1ib3giPjxwIHN0eWxlPSJwYWRkaW5nLWxlZnQ6IDBweDsiPjxzcGFu
IHN0eWxlPSJmb250LWZhbWlseTogLWFwcGxlLXN5c3RlbSwgQmxpbmtNYWNTeXN0ZW1Gb250
LCAmcXVvdDtQaW5nRmFuZyBTQyZxdW90OywgJnF1b3Q7TWljcm9zb2Z0IFlhSGVpJnF1b3Q7
LCBzYW5zLXNlcmlmOyBmb250LXNpemU6IDEwLjVwdDsgbGluZS1oZWlnaHQ6IG5vcm1hbDsg
Y29sb3I6IHJnYig0NiwgNDgsIDUxKTsiPuaCqOWlve+8jOaDs+S6huino+S4gOS4izwvc3Bh
bj48c3BhbiBzdHlsZT0iZGlzcGxheTogaW5saW5lICFpbXBvcnRhbnQ7IGZvbnQtZmFtaWx5
OiAtYXBwbGUtc3lzdGVtLCBCbGlua01hY1N5c3RlbUZvbnQsICZxdW90O1BpbmdGYW5nIFND
JnF1b3Q7LCAmcXVvdDtNaWNyb3NvZnQgWWFIZWkmcXVvdDssIHNhbnMtc2VyaWY7IGZvbnQt
c2l6ZTogMTAuNXB0OyBsaW5lLWhlaWdodDogbm9ybWFsOyBjb2xvcjogcmdiKDQ2LCA0OCwg
NTEpOyI+RVJPRlPmlofku7bns7vnu5/npL7ljLrnmoTlvIDmupDkuYvlpI/pobnnm67vvIzm
nInmsqHmnInkuqTmtYHnvqQ8L3NwYW4+PC9wPjwvZGl2Pg==

------=_NextPart_646C5AAF_52386990_0A368C4D--

