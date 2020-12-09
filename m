Return-Path: <SRS0=sOyE=FN=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B1C5C4361B
	for <linux-erofs@archiver.kernel.org>; Wed,  9 Dec 2020 00:50:18 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8D853238E2
	for <linux-erofs@archiver.kernel.org>; Wed,  9 Dec 2020 00:50:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D853238E2
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4CrJP35l7YzDqlF
	for <linux-erofs@archiver.kernel.org>; Wed,  9 Dec 2020 11:50:15 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1607475015;
	bh=GZtue01dfqibLT4PGv87X3H0oMJgGPvH8+nACYVsxds=;
	h=To:Subject:Date:References:List-Id:List-Unsubscribe:List-Archive:
	 List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=SKZm8HhdXvXtDQ+iPVO0/iGYdIsCyohJmjhg5VUMD0ryLydXEdvrXKwMUW+W/mKKA
	 eLps9xXEnjE4hLjWD9TsSaXo6avKK9/7I91L229k3i0o3d+FED6yhQIf/fT9FbIAZi
	 Myw/um0eqNKx1ZasMTb0VXJQvN87IDoonD/UA0R5jzieEY6WgdbmI7rrbMWME4Ri9c
	 yJbybJjrUQx8B6AZPK18stFGeQy0c4Tl7OT6NVEXboZ203VNHFD7rhGmfG7HxJRTuo
	 bGajK8eIznF2MV2OsIqkaoRfVkvgejtiQt4ZJpBjDFv21h1um326HG2cx7q79Nn7HO
	 YpM3rbMwApC1A==
Authentication-Results: lists.ozlabs.org;
 spf=pass (sender SPF authorized) smtp.mailfrom=aol.com
 (client-ip=98.137.65.206; helo=sonic311-25.consmr.mail.gq1.yahoo.com;
 envelope-from=hsiangkao@aol.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=reject dis=none) header.from=aol.com
Received: from sonic311-25.consmr.mail.gq1.yahoo.com
 (sonic311-25.consmr.mail.gq1.yahoo.com [98.137.65.206])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4CrJNp4T8HzDqhD
 for <linux-erofs@lists.ozlabs.org>; Wed,  9 Dec 2020 11:49:57 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048;
 t=1607474992; bh=TOdef/xYGsRtFA2qwr5/eWMMHiOMyN50TTtc8sYdMF0=;
 h=From:To:Cc:Subject:Date:References:From:Subject;
 b=YTm9aW0V9tseKj4yd4gvBrQ9EZCZ2u9YTG6aKmgjl2M9JgC/mfseW+Ol15beAL2darvB8UZQFqvrhnrNaZ1iRNtUUPezzA7o88SnlwetYHqdjonTavUbghiBRT0inJwpK+Elgec0z9eZGi3MMK8V99G2kbJ5zPA54Ly/vI6GuEvIlWK4qK4PyOpwYe7qx8eyI7Hmpn+vtzxDC6x5vzXL30r52tM7G53R2E7vRNfsZ1IovHFw85jLG6FcJj+qEd4XX+q9TCyv/jdvXjaUYh/DIKEjgEzVxLvWz5J8zi65de95WESETKXED8UWD97H2b49uDsGMMOxPb0B1Hez41jfTA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048;
 t=1607474992; bh=R6IM6wrm4J9JtiY4hMjJUIi65YenudKOmAGgdcuIRt0=;
 h=From:To:Subject:Date:From:Subject;
 b=enjuFuP6ltr8pi/C/vecilF40NyPpStpQINXp9LE1rfR/0Z4VFx21APUya+pzRZkjKTJIkWXbCbxYbN71JVlKCF/jt+cxaDPwLTtmnKX/24A/c/UAH+TYMeJ5S2ZU/SMcBala3YfZrSpcDa9kv8OIhUeZtKe45imA6ntTB5jS4IcoP4aqSaplJxoFv6cbEp5RcAWoc/enpOzQdtQOmON2+vWdRHWgo9lGSlgGYlOX7m7ObYRnMJChyzWYM4sIxrhYBGSpSMVzLTIn1VRRzOOPfRO+ytGsgiAmsg9zfWKpJOG/ZosrH1veSkrJjzEfE0xSDpE+UpCdQhAM00UWhTitw==
X-YMail-OSG: z6hU0KMVM1mSfaMkUSbz46iY27lW80YeVlAErEKj3NGaD4lXADUUArHpU6ktDww
 dOw7jnQOzdCMW93FBCNCHoIgmn94KQcV4DhNsmqseREhZ81Oo4nU26i7GahXmtgVcB8BqHCkDWCa
 oWc6NfRptmO.N_pdUHUtL6wqSGEF5rLCkTHxudataArfnWGDlEpWMUomZOZhC2myvL_YyEFzFdNl
 xKz0g30uxKMxJB8JbkVAQNY1r8mq3qhZ83H1rkr.JBPMyuz3N7abUCas3hPJADyY2x1Z2xHyqX3q
 oqZzA9R_SUHTglqRDWg77yGcqI36NZuOXQXo9.H_ooaPlaqy9usbxvXz.4I1YX_t5T6pcv6gWCs_
 JwiDGZUFOauAcN5f7My1njL_TqHOjKEfERR_P8VqWhu8oYmGsjQbZFILZPv5vsvoLw16KWUIQIdy
 enUI04qqCsEGdsKU70bK0_9Y5AxrRoUb10.C_mxmcOj8L1xTM5sP.LNNN6cgcazyOL4eTD.zZp0p
 pm86cq38kgpgl1UCqP8PDTSzc42u1ZCFwOtgogerpN6ubG1951qrZnbETT6lc0PGqB56cVYVLme8
 7iQlaBGgl84NWOYQyqUF3JNv_FgeDtx3V.8s7Oe.lIb0VaQHpbWyKGJq519dvYoojU.8LI8KO4tN
 Ol.OHeOS9q9ZmJQ_EmnVVxcRubnXhOvKszmBiSdGlVxGvmru.Y32wV2ZirzEcVQCMpfZCHK1IZ2X
 w1aSPnZj6..SUv4iEwT9R44KRrcL2NZn1gEPjAEXuB8UXFwoMIzx7CJYVwkQDDFTWaibKYo0C_xr
 mvZ2_yFsoj_cR2cl5rfnqOOVRSJ41_qXbC7m319FKSFb_turYP67OV8rgyv9Jrzr6NqFxAnULaud
 6xUXXvYfFGTZzAS7PG7.OKc3tHhuJXmpC6gZgJSUE_ShdgA48Le7X9ySX6wW4hwckeyoOMwEX9pp
 MJHVjhGc7FViv5Gv3TOr0NnW2xwGENzk5eswp9BhylXsZ9pCAlsEG3l6YCfTNlWexpHDzp4U7tK3
 31CaEzRaXxsDpfpCRp4r7xQSoJpFJV5MqURsVNXEVBGY3NFEt6N31RY5g6_PWaLApvBU.gaelG5u
 IrUjD4AIt9TlY4m9yUs7tRCJEjVyv_QGhIsytvzQQkhRDDSRQR5igIEakW088H9m8sASg8jgi.wO
 sCXvjWwgPU5o9PIiP9qw267hg1PspQev6gpCQyX_4JWWV5sQ3PO41pHBQ_hVofex_KAWk7kRIzmn
 0RMNaRCB9NVUItGCOyGSAwbumXp6B0zw108GidBH4QFs6lyC3wZwwRxWcA7EO7nc5qdMvO_6ohbS
 0YZfkRNtdseuqrD_wDPRE6hbrnv8dJ.VqI5ynZZxoiZfmZm8O5eyVoq2M99d5q_whX2vVGlz2U0o
 ca5x.F6UGAQ4Oj0pM0I4bQRLTPsEwFe2vuEFsUbSWGPx04DE6zBhW_EJRIf6jdgp8GkOPnmh8fVI
 7cCYDJ8btX24AagiWbxcH0BwhztDTG3vGYoEVhuTVSDWKHs93dUuzzU9zOF0.AUtQCnZtaQhLGPh
 ARG3FTKMUx4OoB_9S58iXVaaDMCRk6UkBEgCVK3gER4j97zYKJPG_zOdDYRY_KRhdJ8ICzagsP_K
 H8UPfOYQqqjcSutgbM5vwD.AX42t2fSaNAxwYt.93sS.nikjQdQxcpqP8Ka2cq02DfvsAvywOd9n
 pR.G1MD_Px0.jPw6dwDYoA3zUj6XQZpSDan.Q4DASbhoX7V6.D_OFppKj2.X4glS3C8sl1CkpItt
 Rk18mT7_voNaKX56hp9ui2Ese4rAK2lBzj9rd3ZvnJpyd0hp5sFpAexawN0rL1cBtbfrR.sTI55g
 0xLloyLkK_H1zAgNcjMioVGU.pMQeCMEayiCK9KhHbZNmGMi3.wzkPdY2JgbJFDhunx7Pchf8Ymk
 78UFep1Xw8PraP4X07opS4LfnsFOyvIBIuozMlY1jB1xhQ99i_hJH5i3.RlTtL7DoRf2RxYR6NS4
 2YDUPzlCm0p2E_w3P8JI82tP3DUPrU3WhGdH.3_fGoKmtIcTyzQof9P7jKhr5oTgocCs2KtX23z9
 R.OFcSb3u2PKNsayrsQVFS1uIZNv8uV_0kiVsxlTeX0QztHTDsFTYwcH5N4yu1J.avmV0Uo8gn7F
 Z4skgfx.BozJoUGZtLWaq7CAaY5zPPk4UfSGEwMRKuKQEYKaoHIlp2HWkjrrgAzxGQAQ2ynWqXBA
 5IMxf.Qq2MgV0iJTH8NWq8mfny0r2S7MLPlKWYObdxv81lWjhU0rVCYCqsJrmQ1dWgLa.dujOmkN
 _EbjcaQ5lD2BMpghwLekMZ2ggoQqslcf4mtjna1Kh5zl5WWn1mFe8nWV1DXpG8FB15_WwcWkOrfy
 Wrajzz338VGo3uhf2we8YYJqV8vfNRPRYpxMlPcAhBq77yyCbpWhYDITvYjmP2nSZ40yKpRkNr9m
 xJTpCys5nb72hen3rGDQc5ys-
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic311.consmr.mail.gq1.yahoo.com with HTTP; Wed, 9 Dec 2020 00:49:52 +0000
Received: by smtp402.mail.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA
 ID c7554aaac129a93eff9fbc0231785c22; 
 Wed, 09 Dec 2020 00:49:46 +0000 (UTC)
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: mkfs: fix uuid.h location
Date: Wed,  9 Dec 2020 08:49:37 +0800
Message-Id: <20201209004937.1672-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20201209004937.1672-1-hsiangkao.ref@aol.com>
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
Cc: Karel Zak <kzak@redhat.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Gao Xiang <hsiangkao@aol.com>

As Karel reported [1], "The subdirectory in
    #include <uuid/uuid.h>

is unnecessary (or wrong), if you use
    PKG_CHECK_MODULES([libuuid], [uuid])

than it returns the subdirectory as -I, see

    $ pkg-config --cflags uuid
    -I/usr/include/uuid

so the correct way is
     #include <uuid.h>". Let's fix it now!

[1] https://lore.kernel.org/r/20201208100910.dqqh5cqihewkyetc@ws.net.home

Reported-by: Karel Zak <kzak@redhat.com>
Fixes: e023d47593ff ("erofs-utils: support 128-bit filesystem UUID")
Signed-off-by: Gao Xiang <hsiangkao@aol.com>
---
 mkfs/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index c63b27491a3f..abd48be0fa4f 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -24,7 +24,7 @@
 #include "erofs/exclude.h"
 
 #ifdef HAVE_LIBUUID
-#include <uuid/uuid.h>
+#include <uuid.h>
 #endif
 
 #define EROFS_SUPER_END (EROFS_SUPER_OFFSET + sizeof(struct erofs_super_block))
-- 
2.24.0

