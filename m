Return-Path: <SRS0=+gHo=AZ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 336CDC433E0
	for <linux-erofs@archiver.kernel.org>; Tue, 14 Jul 2020 01:23:22 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D23C3206F0
	for <linux-erofs@archiver.kernel.org>; Tue, 14 Jul 2020 01:23:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="kvw3FhY2";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=aol.com header.i=@aol.com header.b="ODio+wTg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D23C3206F0
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4B5N7W2mxYzDqYX
	for <linux-erofs@archiver.kernel.org>; Tue, 14 Jul 2020 11:23:19 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1594689799;
	bh=dlWH/cYkw9F1sjDwlOwRYXIHK1NfmvA3lDeTX2kwdU0=;
	h=Date:To:Subject:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=kvw3FhY2OA/ALON8O6GMToHSoOCF3RsB+Lt2PkSeejmGGkWV+B+2nwe+PD6DH4H2j
	 HfCA/COSQV5OCZgmDiZYedJFLcXYzZIcjruB7ogXZi1VnLvo6SRYAoeL4KMPUgxCbM
	 a7D0C6egiFqpP5YrLwIOhLs7phZ3YBIB13q91C+Qdtw3maft0fA6UaZ2kXx6J5W+P1
	 aIGOhHQCWLA9b+wyYzqPF4wJJYLyz7Qc0JHZEtPUcsQBI1l6eVOjghj101w80QnLU8
	 2fAlAEm/QoXfcsgW6Ws0Elv7Ts3pMNcRUiNatGO/YTMDRDXC2nRkNQBEa/2ZfcejmA
	 BQcqj8ngk4caA==
Authentication-Results: lists.ozlabs.org;
 spf=pass (sender SPF authorized) smtp.mailfrom=aol.com
 (client-ip=98.137.65.31; helo=sonic315-55.consmr.mail.gq1.yahoo.com;
 envelope-from=hsiangkao@aol.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=aol.com header.i=@aol.com header.a=rsa-sha256
 header.s=a2048 header.b=ODio+wTg; dkim-atps=neutral
Received: from sonic315-55.consmr.mail.gq1.yahoo.com
 (sonic315-55.consmr.mail.gq1.yahoo.com [98.137.65.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4B5N7K3D6GzDqLJ
 for <linux-erofs@lists.ozlabs.org>; Tue, 14 Jul 2020 11:23:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048;
 t=1594689773; bh=kSZ8A/K3JBp8LhqRTcQFI6Kag9kj97BCjG/6uEWAlZc=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From:Subject;
 b=ODio+wTgG8PN6r2cbOHOkXApXvS1xdIi6NXA4PImpbo92ezGIVt3qYUGr3XfmyJF+yz9QOZC7ctmV8OcDl1V5YodnuMr1ZFW0/rHZZBP33k6tRTFN9Zdzdpe11PIaQcCkGq5Vok7ibIRQqAxVpAxHF7k8qT4VeZduSu2Uam/W/O2J80rNGlI1JO8LwSWXlT2A4e4I0wcJgFX8cOqQlb9dmKvgIxk9BZxMVnKjvvY8LPhpVplhLBpbkqukIDPqUxBwEU0yQZsxf8qjXdA8Zr60JcYF65JxYf1BRA8DB5LoeU/b6ER96lnkGBNDGNBvBrHfJ5BbyGrdydPQ3ODolpAMg==
X-YMail-OSG: .wzDUJ0VM1mceQnxa9_yhOOOke64Dafy9Q9UDbMovPnBzGAmgBzLsOJ7LySXt5a
 9J3R9gX9oe_eAvBUo_B055.hPtrQKHHBimBiKNacZeirx8lMzsr8YJBmlNwgPsIUi3zuoOR8xMEh
 .xD86sEv2WRKPKgvI9IdWwr5suBNFi8ZFZYR_saqcru2b9BpMjZiHPlOhde2PpzD1CkGrkcv_rkT
 qrz2FY29v5MDLxPO7XAw6g5jOSwCJfhNBw4Wr4yavjFgsFbUVpvL9spTDdyjO6fWQOWQSr_sExdv
 xyth76vWEaYH6Ha2VNbOjdnOQzTH3jjgiKc.qx_JeiBSE3OtQA0SUw5CkMzX55wTJEgslA3ZELuU
 I4zajfP7.ITRLJpVvq_SzemDEB6Cx2FTN.6dPlqa_NNfll5opyWdhECoNI06Ba0_X.rIKk000kvb
 1f3v3U39bBgm8c9y4EUs1xlVkoB20_Xyx3rvVgN5h1rh1uPZnLguOLr2.Mia3xZMzJGVBE4tIYzN
 rP5amZ935LW3ov.pGZWs2fNa0BVStIy7nMIChTgC75q1BmlISgtEAT.8Mo5Q.CQ5QRgasnFUr429
 iW4cR9ZoAsAe6OnmF7Lb5.oZ_DXWInpjHSAbC.kiroM4jtSDjvgc8nqP8NuM7KI4BGjQXW121r94
 aGtsjEySM2LoEa2svcNlY.gIhZD7jOWOph4F38tqbre7ORBLhuCyK8S70kneBU6lHYJEVVIhhac.
 1BsZq2oLgZrTAsFLLzLUJsEu_TWxyDyjjrGX4IIz3g2MMeT.g3aqqcpunRXMNxT8Ax5uvG4hg5H0
 RHSXZ5rpdYM.4q077o8GTu2es118G3Duh0JlOcGVWbVj92BoSkWyVaCAzgo9PdwvXSZdgN9aLoVe
 W4CDO319FR_fZx2kSly6a08v9.p8SxbAyE27CDzgyEbeshWIf6goUofcGQ75lHyw.7B7ud4hH3YW
 eAogDELd2AZBbndnSFpF4oj27JCVmSckNAL972OqJceHhf4Zq6uHeo3UtflRq7pPNbhgItHuGN0L
 xj2fNssv4F6BaYMCnENMYwnB_EtpvHz4_m1R7blesOIm02bcdW.EK9nYDkHSjHoNTwCv9pIgZNZy
 kqM0lpLDkoDRZm_s5voyIMhHg065MosNVMU0iVsnqb.DkEngb2duuQTUGwVk.tky2h2EO2Nk1Rjh
 JI_yAxzmiNp2r9mW4E1zXPvGU04r3BXExwVkEO04Yd.ocJ_UQvoYUOnluZR8wGVN8So4jmhWp5cz
 KCr2q8eH9IoHQQF7nS55l572onKVaIgsMCU1I6a8sDf0Zn7DRyqDo0e2y9wH_5U8SqJH9djPq9CB
 XWxnwQO0HSxE1bGZBWCdaNzjzqZq428dy0QBJWplYEkPBMHnAp325Akn6tCdzp_y6_ZqF
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic315.consmr.mail.gq1.yahoo.com with HTTP; Tue, 14 Jul 2020 01:22:53 +0000
Received: by smtp416.mail.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA
 ID ccb2d8946b485b8111546e619c1c7f07; 
 Tue, 14 Jul 2020 01:22:51 +0000 (UTC)
Date: Tue, 14 Jul 2020 09:22:46 +0800
To: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: Re: [PATCH] erofs: Replace HTTP links with HTTPS ones
Message-ID: <20200714012244.GA18418@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20200713130944.34419-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713130944.34419-1-grandmaster@al2klimov.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mailer: WebService/1.1.16271 hermes_aol Apache-HttpAsyncClient/4.1.4
 (Java/11.0.7)
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
Cc: xiang@kernel.org, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Mon, Jul 13, 2020 at 03:09:44PM +0200, Alexander A. Klimov wrote:
> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.
> 
> Deterministic algorithm:
> For each file:
>   If not .svg:
>     For each line:
>       If doesn't contain `\bxmlns\b`:
>         For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
> 	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
>             If both the HTTP and HTTPS versions
>             return 200 OK and serve the same content:
>               Replace HTTP with HTTPS.
> 
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>

Looks good to me,
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>

(Will apply later with other potential patches...)

Thanks,
Gao Xiang
