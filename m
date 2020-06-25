Return-Path: <SRS0=wQlo=AG=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B79CAC433E0
	for <linux-erofs@archiver.kernel.org>; Thu, 25 Jun 2020 05:20:27 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 65BED20789
	for <linux-erofs@archiver.kernel.org>; Thu, 25 Jun 2020 05:20:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="c0atvIpQ";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=aol.com header.i=@aol.com header.b="JZLYbqBt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 65BED20789
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 49spHs20TRzDqjl
	for <linux-erofs@archiver.kernel.org>; Thu, 25 Jun 2020 15:20:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1593062425;
	bh=D16MFASYnMEdGNYLvuNpaQsK5TLW66FEZnUsPDT46n0=;
	h=To:Subject:Date:References:List-Id:List-Unsubscribe:List-Archive:
	 List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=c0atvIpQP5DDAkBz0/M5ViXEC4apWPj/kT69EbTke69/Puy1EL/ZCp46ftpBApz38
	 oXwaSmc9anK53yPDGt+k/DVbPjSX2njQHpsdE5so1ybJF8XD4Kce4CznbipYvp4wPl
	 itoBE5Rvyobp4li4DqUrbnta/v8ad3RoXev+TGksPiitTmiNxj0Z24Rj9d49U5QN4m
	 o8RWHRxjdN/yDVV7YmQepSxTKn5vraq/QXvNCTshuK+/J4IA0fhPxmw6KM8DaoJj9I
	 eXkWgoFBiKKuXeh6TIyv6lybMQpyVhHMttTKJrTvAO6dJmpX1CY01MkIhEtdUrQT22
	 XfygATvPHRtQQ==
Authentication-Results: lists.ozlabs.org;
 spf=pass (sender SPF authorized) smtp.mailfrom=aol.com
 (client-ip=98.137.65.84; helo=sonic313-21.consmr.mail.gq1.yahoo.com;
 envelope-from=hsiangkao@aol.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=aol.com header.i=@aol.com header.a=rsa-sha256
 header.s=a2048 header.b=JZLYbqBt; dkim-atps=neutral
Received: from sonic313-21.consmr.mail.gq1.yahoo.com
 (sonic313-21.consmr.mail.gq1.yahoo.com [98.137.65.84])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 49spHc6wKGzDqgd
 for <linux-erofs@lists.ozlabs.org>; Thu, 25 Jun 2020 15:20:04 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048;
 t=1593062398; bh=nNbuaihPm9AroQRBhAhelCSNPjnrx2O1HLOA95a0Tpc=;
 h=From:To:Cc:Subject:Date:References:From:Subject;
 b=JZLYbqBtckbSqh99naE4PZDvlo/BBokQhph46/oaqGM5Fi6OACDHIs0q0yMmhPvrOrxOi8EvHKHxusufvhHfjg2rSXgdyjwyuOlwhzmLPcVDu9W/fNdYBVqgaCjP4/GJNsVEmblhS1SFqG0BeG7yIptPdix8ukt+F+eyy/Af3YBvQpPqE+/1diaeIO3W+oCYecVoPK9drKmkchMkjccjDzN5NIxniFu8iSaYTpFqXN8FS+L69k3Olw2lWHsIQDKl+nRc9o5Rpu0YPMurxASTZSQCECTYdTmaFFRK8WsieSieHv2l9yRgg7bFtpW8JspxfPA8iXDoI9wzJYBUEo6btw==
X-YMail-OSG: G2xB2kwVM1lGJZBr8SL9gjGkCVNgX1RfQcr10RSUT8npVu5HiA0byqQCBnG90EJ
 0A3MG0mqWo41.N8N_tK9z5uIe73bu5.1SOuq7gmDfGaAQkek5IvU2csHcqyGgwcSWVnQxJNBqxoB
 n7XF._gqnGj3PUdmlDzjdVyFNQC89TP0cstcYDhwaQCNAIZWqynq7hxjCfi8Yq0XzT4It.8YnREo
 awBE6K4rw9HCPj9Mrl.TYYgbwwcA9gKLoC5YL87M7Qb_zReGmbqnLwZv_jPC5DjbFkJtZYPlQl16
 fgfWq6zmVxhmy7AsgaLJdHp1naiPZkkcmQH071oFOzCpPKK4n6dnQrn5R5LrEGp_W6YbPexCuaqo
 MMTg7tkyPX1wglob.hh8KDV5SjDePuXFMyZBzLwkCuheXc_KOkcSKc.03z1aCP0CdExYCH891GdW
 AjqSRzIpfdmxoDVAb_mVNmhxznBlhteVIu1iefj8NqJyd3L3oum0NIY2Zl2_ekIlLg4mIKiXWboO
 GZwK9KnXHo8MT18KQ1gBfHcgxAZphiUCdOgBO3tYZ_kJcCuTDYPSnrrYydhWbXMyKDsLVbIAj33m
 iED6POCONZtI7cHfT1h26NW2Quf5IChtf.0pjaOBUUjx7TC79hqTlD979aVHade9hfkR8hLdWmZt
 F4LAp8cymGbQz1rLFWEnkzgIaBXvj3mU.a2glVRpBj_TXoNrJAQvQSwhAZm6rOu6RAEOM04uDXiC
 .ltP8AiVbntejVMZrqhi6w04IZKwSjIR_z4OR6i3gY3JjHOHt3WkuoT7GNPKfwvAEZ8dwxByAJSk
 J8.pS.HPMA9CK9ZCUnW8B7B85JzBTsNRI3HyW6FLoZfq3n5_BMF0EGjSn.UIkszKIrgu5lhKPeWh
 EA_5.1FSBbVJvLi47PDg5SQ1xNfeOlnOLlLkA_DLVyIbC4lLMvCUdU1KgQWMDHqqQDyyDgxB8N4p
 px4uzgNtEsuAiVpEeyTKhzKxbA4obf93CPQGD1IdSVhxkjYF__A9Nii6Yz6EKendnJ5ciUGa3xAw
 bJDYuL1xuKHWlLAN.CynwLXHn8TE6qEhfQOUVw6MzJa4BgswUwmCSn9ZSyMvWBAZv7aZoHxNuxL.
 .yWcA6jie.6yGcGdcf7RfKT5EYjNFbBacjvNbglhvVNGhNTP0MULavaa9xb8jBFruBme5igP2_F1
 JxYFkHqAMU7VBCqcWpJlVl2yzugsb9zBz0S_qdfmB.z_ZaWb8oEPtRHG3uDsJl5lPO7iCtXQdCLL
 zklMiUNBTGoQYWRCuPYlQL.SC_swGtv.1XclY3kVpKqqPfUL7s.pHucmQOw0EZ_C3WdcBBS_51hs
 mthXSfzxgGQC3sRhn3N8zWD5vyGZjtrvr_oN91ovJDkvwOOWvsP7XA1TECXNLc3QyQuBx8J06ETX
 BWaifbZ1yhAOfbkKnJ6zp.pq3R9x0
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic313.consmr.mail.gq1.yahoo.com with HTTP; Thu, 25 Jun 2020 05:19:58 +0000
Received: by smtp420.mail.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA
 ID 168749c4308c8b7d943811892a3c5e51; 
 Thu, 25 Jun 2020 05:19:57 +0000 (UTC)
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19.y] erofs: fix partially uninitialized misuse in
 z_erofs_onlinepage_fixup
Date: Thu, 25 Jun 2020 13:19:39 +0800
Message-Id: <20200625051939.32454-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20200625051939.32454-1-hsiangkao.ref@aol.com>
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
Cc: Hongyu Jin <hongyu.jin@unisoc.com>, linux-erofs@lists.ozlabs.org,
 LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Gao Xiang <hsiangkao@redhat.com>

commit 3c597282887fd55181578996dca52ce697d985a5 upstream.

Hongyu reported "id != index" in z_erofs_onlinepage_fixup() with
specific aarch64 environment easily, which wasn't shown before.

After digging into that, I found that high 32 bits of page->private
was set to 0xaaaaaaaa rather than 0 (due to z_erofs_onlinepage_init
behavior with specific compiler options). Actually we only use low
32 bits to keep the page information since page->private is only 4
bytes on most 32-bit platforms. However z_erofs_onlinepage_fixup()
uses the upper 32 bits by mistake.

Let's fix it now.

Reported-and-tested-by: Hongyu Jin <hongyu.jin@unisoc.com>
Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Cc: <stable@vger.kernel.org> # 4.19+
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Link: https://lore.kernel.org/r/20200618234349.22553-1-hsiangkao@aol.com
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
This fix has been merged into Linus's tree just now (today).
Since the patch could not directly be applied to 4.19, manually handle this.

 drivers/staging/erofs/unzip_vle.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.h b/drivers/staging/erofs/unzip_vle.h
index 684ff06fc7bf..630fd1f4f123 100644
--- a/drivers/staging/erofs/unzip_vle.h
+++ b/drivers/staging/erofs/unzip_vle.h
@@ -169,22 +169,22 @@ static inline void z_erofs_onlinepage_init(struct page *page)
 static inline void z_erofs_onlinepage_fixup(struct page *page,
 	uintptr_t index, bool down)
 {
-	unsigned long *p, o, v, id;
-repeat:
-	p = &page_private(page);
-	o = READ_ONCE(*p);
+	union z_erofs_onlinepage_converter u = { .v = &page_private(page) };
+	int orig, orig_index, val;
 
-	id = o >> Z_EROFS_ONLINEPAGE_INDEX_SHIFT;
-	if (id) {
+repeat:
+	orig = atomic_read(u.o);
+	orig_index = orig >> Z_EROFS_ONLINEPAGE_INDEX_SHIFT;
+	if (orig_index) {
 		if (!index)
 			return;
 
-		BUG_ON(id != index);
+		DBG_BUGON(orig_index != index);
 	}
 
-	v = (index << Z_EROFS_ONLINEPAGE_INDEX_SHIFT) |
-		((o & Z_EROFS_ONLINEPAGE_COUNT_MASK) + (unsigned)down);
-	if (cmpxchg(p, o, v) != o)
+	val = (index << Z_EROFS_ONLINEPAGE_INDEX_SHIFT) |
+		((orig & Z_EROFS_ONLINEPAGE_COUNT_MASK) + (unsigned int)down);
+	if (atomic_cmpxchg(u.o, orig, val) != orig)
 		goto repeat;
 }
 
-- 
2.24.0

