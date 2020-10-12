Return-Path: <SRS0=Po1J=DT=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 747A0C433DF
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2020 00:23:04 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 52C3A20756
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2020 00:23:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="PPYjnqr9";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=aol.com header.i=@aol.com header.b="A3hyUOIQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52C3A20756
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4C8fXP0pTmzDqs8
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2020 11:23:01 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1602462181;
	bh=9JI5Vzbyw82X04Levchs85hzWeAeeTPq/1fSq4ZNFiI=;
	h=To:Subject:Date:References:List-Id:List-Unsubscribe:List-Archive:
	 List-Post:List-Help:List-Subscribe:From:Reply-To:From;
	b=PPYjnqr9f/xiH8yq5VHpO8nKYniMv/pHLqL+oVlCps9ceVqiB8PeLBecMfC9W6LAG
	 ZTjN2HATV5koDPA0RbusaSNWNyBbGFhlYlnnJPlMbn0J1n72tJw2gKEoWg72p3S/+x
	 doUh1rG/bMbRWc9poOUWNYEMzKWVE6neGp6VF/rT+QRjGhFPbNBgSnOcTXj6Fqvw4Q
	 oSuHf8WZDRHFzLkkpv8UzOd8k7LlWEcScKv6Kbs8aDq7DpjRceZ+NJtF2oM3Q17boA
	 ZmwB4bEpPbpSD9UswuxFWVTzo593r5nsN2hMWlSX36QE+xfr4VQK7daDUszm2ds8Fs
	 uphTBE5hks34g==
Authentication-Results: lists.ozlabs.org;
 spf=pass (sender SPF authorized) smtp.mailfrom=aol.com
 (client-ip=98.137.69.83; helo=sonic314-20.consmr.mail.gq1.yahoo.com;
 envelope-from=hsiangkao@aol.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=aol.com header.i=@aol.com header.a=rsa-sha256
 header.s=a2048 header.b=A3hyUOIQ; dkim-atps=neutral
Received: from sonic314-20.consmr.mail.gq1.yahoo.com
 (sonic314-20.consmr.mail.gq1.yahoo.com [98.137.69.83])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4C8fXB5yqTzDqqD
 for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2020 11:22:48 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048;
 t=1602462164; bh=Ye/6Go7GuhNU7DvscsGE3NEtwCP4/51Rogf6dNHfAcw=;
 h=From:To:Cc:Subject:Date:References:From:Subject;
 b=A3hyUOIQmfq+/gebvITini4TPSeXm4/Uv58DOMhsA5r41uK5EzLQohAETaaZnHACrJTlpzsPOhI8ZDE3fkLMebHfxOszmG3EcFw04kGWqxN6Oz+6wk67AfS8TizbBTjrqC7AIUOjXmKy4q6LNB+FUo3iuPrhNInTN9CzJ0tFIEHoeVUw2atK4jYBPHv+hYHDvqL7286EZdLNa069Xsq7uxX7fMhhzHA/hUmt9WiqzYlQXPGAw4AMuCBxiAVoE4Hc48DIzCtiGC0pRqLNbXMBxb9jT9XDx2/ikwZYvEv6FYGZ4tef7cQBvVNxleycXYuNBwyhwqOiYegqPH6GOJscFA==
X-YMail-OSG: .JQ9ngwVM1m5I0Rwk84lCao76P77pmawi8prulVAiAeA.cKjIQSOEcJVXwfpCBb
 k4RDTD2gusqdbLTpm92Wg5R9o6fDJTImDVcpBM2mTYy9W5cTgO7QgZti72r8Mm2Wxc3zLEfr.qjk
 FqELUIDnNQZb2uo2oqbrx4EWCWp96U8tqDgfWsddSRg8j5GiOlPVLySmcCMGZhhcCBTGiNJohCk_
 qO7Qfew8U2yZdMjSfw19SwqeG129e34o84pfDfNPa7j72tZzfSAmEiiDSk2GxNwrmrTICQKrohcE
 IlSG9wqmEHEC.4wF583jj14tuEoh8RSz1j4C0ke8sJ4jVpiQhPVVZhb_oHK44oH9GzrwGoWhG.3l
 HBMVOGg6aL8TVsl7n1r7jeZdY_nCbL7rvFIrXypnta9BXxLfO7aXfGKsSnb3kwWdQYecvm_V6P5z
 IDrUgaSNE2H8Gi9QxcFnPvqwByQASawaqdugnsRySMYp6FdFDy7hP1pPUOWa33B8cDgvKizaoien
 1.xbo_qNFpSW3fQh7JSG7ljBJ0oUrAvma.ItkusXdfXYcVPJmxqwmvllUANAMnN7mFUL6rgn7wJv
 uVsF1HHm_wJ89ILhL_1t8GmQrlf8lr1Bwu7i25dEFji5U_urYsS1RMKAZhjdKs89HdLtlPHPs5Jo
 fyssP7RwOM8FIV3_Onl40zq_artxXfl8L8RKPh2MQ6MzArX.u1otq7vxB2a6fOs.R0n7aftWGfMM
 8PozYB2W5RroxwHZkDjlg0Jlg02F_BliDqkxl5mnSilI7B9_AI9K2yVD3N5JXnN6Y_iV8niV_Vjn
 QdHuGKjq2iGQi9yr2qScQJP_NuISjX6GZTTF.jhjk9vbaa6Ud33C90Ll7BitqFh.uLV9_tyoZk8D
 QsuwJ8awZDeT5ug.9LAqW63qa_7S0a.RWcm4iwMjSKsAPjFc_ij.Mu1L6s_X1kiBl4iGDF81Z4iD
 q94TIHbMwaYMaY3YkHaSGZd1Qqexha1xDFk8e2tl7EbWmI933oo8fVGPnFFH_YpgQMCfHh6u2zXZ
 GgKPqIt275A8_qIiVvgQo3wltdXKhh5.ZAcS08fCYtsbTvCzRk8nya7hfLhowARFKd.jF_k51ngJ
 IMFCtmOPiPHXtVYI.UUE.7P6etzhWUcswXt1WsbOAUN1zGGhY8G8xKiRDlIg_9xifuBue4GuDCQF
 dV.3BW8Z6BStZSQQOiWuwKhEP_TMO5oMqKWVpubTViZSUOhwfg2W4K0tKZUFQvaUJuaE8vhDEa6A
 al9MuvizIgofZLO_3ERSXv1jHuGV2gAZrHYb6oA5XNqnBHB9inHVT5gUhIpNtYV1UOWVZ1FjpyUk
 iUWJl6hzxDTPBlI_3rpiFLlognK2QNWSYHZKxxTTFo._6YMb7GT_pI71PhSOx_1NMOSKgP9Fkbko
 0o_S0N_2_vdC3.Y7Z_V3au3n3hXS5TPiKO0nLlNb_ROvxFgyy3CaA3VlW5bvGb3ouB2bqgIoDvZz
 AMG4mTLOxb4UhCEKEze6ImCNZRk02WPu4HGVHg0zKxeHl9picrJhl_u9nV2iD9GWUcuC_z6sfzA0
 dMY_T8lAX1Q--
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic314.consmr.mail.gq1.yahoo.com with HTTP; Mon, 12 Oct 2020 00:22:44 +0000
Received: by smtp401.mail.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA
 ID 86645acc1ffdeaabdf705b76912c56b5; 
 Mon, 12 Oct 2020 00:22:39 +0000 (UTC)
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] AOSP: erofs-utils: update usage due to fs_config
Date: Mon, 12 Oct 2020 08:22:27 +0800
Message-Id: <20201012002227.1882-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20201012002227.1882-1-hsiangkao.ref@aol.com>
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

After fs_config support is added, usage() is also needed
to be updated as well.

Fixes: 8a9e8046f170 ("AOSP: erofs-utils: add fs_config support")
Cc: Li Guifu <bluce.lee@aliyun.com>
Signed-off-by: Gao Xiang <hsiangkao@aol.com>
---
 mkfs/main.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index 191003409b2f..6dda9e399ad5 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -61,17 +61,23 @@ static void usage(void)
 {
 	fputs("usage: [options] FILE DIRECTORY\n\n"
 	      "Generate erofs image from DIRECTORY to FILE, and [options] are:\n"
-	      " -zX[,Y]           X=compressor (Y=compression level, optional)\n"
-	      " -d#               set output message level to # (maximum 9)\n"
-	      " -x#               set xattr tolerance to # (< 0, disable xattrs; default 2)\n"
-	      " -EX[,...]         X=extended options\n"
-	      " -T#               set a fixed UNIX timestamp # to all files\n"
-	      " --exclude-path=X  avoid including file X (X = exact literal path)\n"
-	      " --exclude-regex=X avoid including files that match X (X = regular expression)\n"
+	      " -zX[,Y]            X=compressor (Y=compression level, optional)\n"
+	      " -d#                set output message level to # (maximum 9)\n"
+	      " -x#                set xattr tolerance to # (< 0, disable xattrs; default 2)\n"
+	      " -EX[,...]          X=extended options\n"
+	      " -T#                set a fixed UNIX timestamp # to all files\n"
+	      " --exclude-path=X   avoid including file X (X = exact literal path)\n"
+	      " --exclude-regex=X  avoid including files that match X (X = regular expression)\n"
 #ifdef HAVE_LIBSELINUX
-	      " --file-contexts=X specify a file contexts file to setup selinux labels\n"
+	      " --file-contexts=X  specify a file contexts file to setup selinux labels\n"
+#endif
+	      " --help             display this help and exit\n"
+#ifdef WITH_ANDROID
+	      "\nwith following android-specific options:\n"
+	      " --mount-point=X    X=prefix of target fs path (default: /)\n"
+	      " --product-out=X    X=product_out directory\n"
+	      " --fs-config-file=X X=fs_config file\n"
 #endif
-	      " --help            display this help and exit\n"
 	      "\nAvailable compressors are: ", stderr);
 	print_available_compressors(stderr, ", ");
 }
-- 
2.24.0

