Return-Path: <SRS0=6Vom=HQ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B260BC433E0
	for <linux-erofs@archiver.kernel.org>; Sun, 14 Feb 2021 15:36:38 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DF3EC64DB1
	for <linux-erofs@archiver.kernel.org>; Sun, 14 Feb 2021 15:36:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF3EC64DB1
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Ddrtr419Wz30Gs
	for <linux-erofs@archiver.kernel.org>; Mon, 15 Feb 2021 02:36:36 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1613316996;
	bh=iGUWSVjtCeE0aFF1poN7M/2Gm5jK0qVU0NilAjAXGO8=;
	h=To:Subject:Date:References:List-Id:List-Unsubscribe:List-Archive:
	 List-Post:List-Help:List-Subscribe:From:Reply-To:From;
	b=jtA1f/65+Qe0hQFwtx36nK7ZACosNePeDxin2bjBZOS9dw3oECUA9QsYEGyC3z6xN
	 baV/3D2GbRJWGVIGpcotA2cLuJNT5ROTADAhz2rlSsGKrA/YOpm7ZR6z0b4nNFvwIC
	 JtffX+h3mt1lKzMmh+II5LCpG4h0K+avlUUcueH0YVlE6aT39G7MCABO2d8ovhsdCM
	 VNLdpIfz82I33wcaN4OWAK9YqJtIxI7BPaepOmPOF5bmN87IsGpyG9c/xJPS3m2J7O
	 +Gmh+Pzc5WbIcZ/e8Hnx+bjbODYbdsfloevxXgHKAWJ5gnJvZosz4yPR0pPk8zYcgo
	 MINZa07AdCEUA==
Authentication-Results: lists.ozlabs.org;
 spf=pass (sender SPF authorized) smtp.mailfrom=aol.com
 (client-ip=98.137.64.205; helo=sonic303-24.consmr.mail.gq1.yahoo.com;
 envelope-from=hsiangkao@aol.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=aol.com header.i=@aol.com header.a=rsa-sha256
 header.s=a2048 header.b=GuhjQEHO; dkim-atps=neutral
Received: from sonic303-24.consmr.mail.gq1.yahoo.com
 (sonic303-24.consmr.mail.gq1.yahoo.com [98.137.64.205])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Ddrtp00YXz2yRy
 for <linux-erofs@lists.ozlabs.org>; Mon, 15 Feb 2021 02:36:33 +1100 (AEDT)
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048;
 t=1613316988; bh=N7ZvrBpcLYWk+f+F3CblanhPU268g1L4BQ/7y3gMkHL=;
 h=X-Sonic-MF:From:To:Subject:Date:From:Subject;
 b=PZ9euCuCQZmDEs8bvxCvKO724Vrqiw9zmcDHt4YLKy7Hfk1s+6BosW9kClwfhnjiT/sP/aaHC5L7d3cL0KChXOm93rGZ64bZ9qmNfdhYmLB55aNkSgKpTBIRjJqcl8ERdGwmPkF095f8T1QVNK1PZZ27F2CprQEt3bs2Kb2PdS5vX8I/BiJM6zH6x9yM2vaXUBQivSWWPEScoIVzrHWS3KoDfdB0/62FFU+cWkgE++WpP0eU05w3MpAKzqjqRIq3QzfKjag1/BOdNFy1IuTUQceBsGgJR3QlY1CenPdMxBAITemVqhheoD4zokpzzSsAiOeuKIY2J6r/hTa4/L4NTg==
X-YMail-OSG: mJK_dksVM1mgJM9D11E1Axr.g6ELuX4KCYLwP0y03ylF_kn4yL_OuRxlj8qA3Y_
 SWrvT3tzH3GYlC1rmww.Gm00m9hejO.WstYlpx9MneZN8So9OowjU0ovHfMgr9hbc3tU8tS.YkG3
 QrWfm3JIAPNaUZXdufLy5ZQzlSKnRyFYFJfpAlAnKpjB3dyRCPlRiuOdLH8VIVdIfnSY51xrTPwq
 Xkc3Bnftp8_y8JSY4CmeKVyXj4m7J_C1XugM4uRBVRG0Gtyk.znX1dtHumUwMepX3yRyId2lJGCL
 XuVGW2E_GAARDJ7DztFn80g1bXHv3zbW0HJsOwx6cFF3dy9pih7tfLAWbPk8fv7qP_YQo3T6ag1A
 TqLRjhNec7q6V7WLqog5kExxgLbzggpN6OxuaAHhAiputqqMGyeB96NWpuSU6zpoStD1p5VdtwqN
 9C1XuPmi7ro2rVMSQ417fBQX.hAY..KYREjYb2jhGe0NSkO4BCDRlQWJfLNeLb9McmgFMSj9nqoT
 YCxyp2oZLo4PALAgcEACVe_13sLMdRjc.OTcHDsDjzH4Bxmtmd2oixt62cSzEtOGaHl2zfVYHknp
 CWZQWiC8hbrW2YMYB0WJKOqdwpYXEFvCK8ROmP2jsxjrb.5JeQ.FNJLKgDP2i0cfDwMu8WaxRhbA
 c16kES01E20FUIt6wix81873hFf3pYXTFL5VKxMXTuV1zsVf2VGo8yKU23at38nOaTlD9Iu1rP7d
 KfLE1lD_Dmq93tYsMIcP0vV6N8dXhQ7LjS2gvkXjOoGs5v7Z5tPkzTNv1nkHI7GkrKWzbyHyip3z
 TItXHCWNWGaZgiVW6dDsmKTvRD1G5..p1Zmc5w2EWba2uyanirJDNbDCeD3.Mi2awQVmOYYyPYN6
 8UKulkoq9eLmsovxfn_6J5cCdOy5QxyXflw.KGBfPVYO1Dq8e8jPNQ0y33r7jFXsgkZjlDzkGSr8
 fG7BX8YcP.WAlcr_wa9_KOZe_tzXiepPqHF6jSqFGMfcLigWxyVVlOqBYYStQV7n6Z8wUKxpV2Bo
 .YJY8tgd6kJbdZNFL.s_gImUksqqnHDQAcihKjhKjx6xPK.XL49SO3Yg5A3pc3NwlDi6jBKXZKO8
 l.TzFkOAOTzRcBItD8R5V5ukzi1mQiYkdncXGkaS6ZH424I0SDX2_NbHeTyBJfgk9ScMUGAkkq4n
 Ri166j6raJUscY8YuNMOS.UgGnSh_DTjvbB3.WSxV3AKi6lbLTGutT_2s0sa_.s4bDovj_J3THOM
 n1MRuPs0yLsxy70ZA3LF85HqahZBeLIkdBBnEK4e9PYUgarrr3A0aPWWfVvzuEFHrIhdGYM2iBNS
 azoCA6E2PgLbE6N2w0TkowZIIoVITW8UmxBv2cEQdTUp6wtkabMJIupFzpxf4XfYXRNfIBlgLHuA
 XTWgcFyRw2kOApUrcy.1Os48tWuraGAqmaU9OndVmNU0B6JSaxKKjONvvRjryIOxAa7Nw61WSprb
 0ny1ZoA6EbnWPyKLQQP0tlSZ5aKSyYF.toZdg6WWX6FexZ7jRjtV_w1lR1WJK9z6c2R8dL586u4y
 wrLS7AFCLmx8lzfuUkel3Eb38x2KAYhOFmPneo81qPn2ktGdSrkJvngvwlUS2iF4omCTnO4eYCYZ
 HKFDGjNSZGpBaLNhxF61AxsYUkEacqVvWsttpQ8RxkB3lx94hnLaOUi1MGyG.6xmfuenPEN7vmni
 PA_L0VYm13zKT1GDU.rBjsopZGlaTatyeouCWMTdiiNU7CBNuHzC1vbEy2voTxMV..6lMTXgcr9r
 4S.MJSpryU06OBJ9R2Bi3yiiC2C11L4FKgYb_BygBFgAwZt2ONVTF2OvazvPq5mEvXim2JBxY0sl
 oiqjgakr7iPx1TKi4yBfV7A1STDwYsPk35W4eXIq4O72yNMPKEQ8vFuD4l4R.Hb4NokJvKnimsdw
 9GGJTwnCwZ.qt8eLqdhfowM83NVo6jN4ebxzWNpTVjUWxHgCTb0HLkv_EBXsqN1FJMa00x04UTu.
 a2TUSLBZWVPMC1KEhVCSgGyy3BxhIY.GhfdTD0J_gvrpRZE9XGLZWLbZSezfSjFoWYum33X1YjHW
 jPH7IYQH0ZXHtpiyRcE9wUL8lGFGYRbcAVr0lcK3XH8JvNANJ7Lb60d.VEtypeYGsmNVxaEUgI3X
 26bZn_Ivo5qgSYVNBMGyOLO8DNwE5kgvVmOFSTmJqg9JMydmU7q3v.17WX6XXHjT2mffDLor1Yjx
 BxHIQm4heZ7lgFmZmv1l6CML22bGWSuzE3TwfkBvwqtvQRtBUW8BLSqGxnP4o1AmJs80_Z_u2e3z
 WTblPr42aKZR_dlYSfjv0CJ2_m6NxoJo43Dv9rhQkRH3umXYLECY8.3hYlfmuYfVXueqXgyKAzKF
 nGB.YbphW.65zsxRuXNbAqWeEGDdNQnzUdYyUDsgRgg62qbDAMueNJiWbUZLensNEtxPGZNNETTH
 Y5zZvtg.8WlxnnO4OwUXmJ4obWQL9gHkqOJ87Mu3ZWCec
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic303.consmr.mail.gq1.yahoo.com with HTTP; Sun, 14 Feb 2021 15:36:28 +0000
Received: by smtp405.mail.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA
 ID 07898efad2b17f635251aa7d04958857; 
 Sun, 14 Feb 2021 15:36:22 +0000 (UTC)
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH v2 1/2] erofs-utils: don't reuse full mapped buffer blocks
Date: Sun, 14 Feb 2021 23:35:48 +0800
Message-Id: <20210214153549.2454-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20210214153549.2454-1-hsiangkao.ref@aol.com>
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Gao Xiang <hsiangkao@aol.com>

Full mapped buffer blocks aren't the targets for reusing.

Fixes: 185b0bcdef4b ("erofs-utils: optimize buffer allocation logic")
Signed-off-by: Gao Xiang <hsiangkao@aol.com>
---
changes since v1:
 - update commit message since "erofs-utils: fix battach on full buffer blocks"
   has been considered in advance.

 lib/cache.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/cache.c b/lib/cache.c
index e3327c3f1586..6ae2b202e67b 100644
--- a/lib/cache.c
+++ b/lib/cache.c
@@ -155,8 +155,8 @@ static int erofs_bfind_for_attach(int type, erofs_off_t size,
 				  struct erofs_buffer_block **bbp)
 {
 	struct erofs_buffer_block *cur, *bb;
-	unsigned int used0, usedmax, used;
-	int used_before, ret;
+	unsigned int used0, used_before, usedmax, used;
+	int ret;
 
 	used0 = (size + required_ext) % EROFS_BLKSIZ + inline_ext;
 	/* inline data should be in the same fs block */
@@ -177,7 +177,7 @@ static int erofs_bfind_for_attach(int type, erofs_off_t size,
 
 	used_before = rounddown(EROFS_BLKSIZ -
 				(size + required_ext + inline_ext), alignsize);
-	do {
+	for (; used_before; --used_before) {
 		struct list_head *bt = mapped_buckets[type] + used_before;
 
 		if (list_empty(bt))
@@ -203,7 +203,7 @@ static int erofs_bfind_for_attach(int type, erofs_off_t size,
 		bb = cur;
 		usedmax = used;
 		break;
-	} while (--used_before > 0);
+	}
 
 skip_mapped:
 	/* try to start from the last mapped one, which can be expended */
-- 
2.24.0

