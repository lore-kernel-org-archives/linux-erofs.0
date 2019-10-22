Return-Path: <SRS0=kNa8=YP=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46045CA9EA0
	for <linux-erofs@archiver.kernel.org>; Tue, 22 Oct 2019 17:25:58 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E40D320679
	for <linux-erofs@archiver.kernel.org>; Tue, 22 Oct 2019 17:25:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="OSp/Shmc";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=aol.com header.i=@aol.com header.b="Ua0HyvGC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E40D320679
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46yL4z4XDRzDqLk
	for <linux-erofs@archiver.kernel.org>; Wed, 23 Oct 2019 04:25:55 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1571765155;
	bh=2OHXoyh3v+DKkPU6LfwqVRIdWCL5AgKotOTiwDd7Pgc=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=OSp/ShmcQs0ndswM/GsztveQkV2EfALsp+x4Uj3scllPos2lhafCpcfDUCF9eOoRl
	 iSncYeibMDLsfLSYkTlkSOK/QGlASU3Qym4J2AtCFYMn8pObh4RikgGutpyga59Qdd
	 G6ECHy0f/WZ2Ttwh+ch6402DkVpO9pmvQZwXpl1yRLBIe0Q1GONOuvYqeUAvcgZwR+
	 yXyKD7SSrBE6aPxyjVGlWb26DXPA/gqbOGbbSHIHfSjqVa1Zz1mon6ncgd3RXW1JAj
	 wB6Vm61+B94qHCVwpEgoIaIhz/Nu4pGCitGKmYQ+4EED4TennAYslcJanUgqTUbTCe
	 67bx2c9fRksig==
Authentication-Results: lists.ozlabs.org;
 spf=pass (sender SPF authorized) smtp.mailfrom=aol.com
 (client-ip=77.238.179.188; helo=sonic313-21.consmr.mail.ir2.yahoo.com;
 envelope-from=hsiangkao@aol.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=aol.com header.i=@aol.com header.b="Ua0HyvGC"; 
 dkim-atps=neutral
Received: from sonic313-21.consmr.mail.ir2.yahoo.com
 (sonic313-21.consmr.mail.ir2.yahoo.com [77.238.179.188])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46yL4m56JDzDqL2
 for <linux-erofs@lists.ozlabs.org>; Wed, 23 Oct 2019 04:25:42 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048;
 t=1571765138; bh=g6PSgQDfMdsABgq0MKoAlB6bYzDq49AVr5T/12V4LWE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject;
 b=Ua0HyvGCPc6kvdfzz9V8ciByI5MZGiVCfh2axYMv5l23HY/KeyrNfEvgsPxQpy0zxbws5EJtcF01PvGxfXtzXWx5Saglm1a1lQ4qog4v+EqsZW+mNO5OA1bI/GpkxlZ8inmrlTJwwfljkhYBo2l0wIhpUlxpUtzixFe5+j+eg/RFylHVkhJ0QbNupLTXMdzzARw9lkDoPNIKnTNZyx+NQVHZf/v9cesVRETnoRwWO1AvQ8OfsN6jc25WVakvT7Cnpl7FoadP28nhDzUpmAVsh7BZpsUH66CuXnyilY3Xx9R3OhVoxmUNEE2OWl2KElvuUO04yJPS85q4daOgbxDdLQ==
X-YMail-OSG: HBnB8A0VM1nIq4I_C6Hk9AVM8gh3HKrg2FoCWw9Q5BtULOMBjID4qiX7BMQp7rw
 tNKsXONR4lV4OkY_hy6ibNPm73Fs2nYsSGQwOrKiCZ41Y2qpPy5wfAAAD3BDuze1peDbryv9jgbE
 DCnfqUvIekcFJSo6OCdub8Jh54xBeckCsTcgoLYYwXxHn0YtOFjOUOPxtjhMi7kr1u7W_PoUD8t7
 t5KSdIWLJAYlZq57bBUMEpm76sIDu.x2MLqji_w0HAsa_Rkwa8Xb6sbYuOe_wcYRDdXAs_9ASjuk
 A5OLZB_NDxxZ_noMj6vkKNVn2i0UfzpoSK9TZeSECFDz2wNm3QTqIChsmgeTd1CM._Mdp2Cbm3ur
 1ZezaMLKrxoobGA1IyhyG13eNcs1DC6G3Y0Mecs8Vq2AEA.XMmnXkg5KXhPDu0.j1bkmoa4xfP8Z
 OBy4FpXzEORLeLfnZ6o9tJTShvH.ZWde_x.Ft.hK23.dfOfz1_12Sdmyswic.XeRP2CvuTBuRlHt
 rOJn6lDKabeZdknGF543Otc5llH2Y5ksMStbD_Xwz3G90JWK5CSdU3b6OjKwp0kPY.EHUqbbU9fq
 XZhExRfSBdcrfQBTeSyCMyybj0O070iZIe.86Wi1aQkwzfXR2c3AZR95Sr4cjD_LMXxCWjBgNQUF
 ccgmVVkkgpETCvjif5.Gc1j.uUPISdvxnp7..TX5ixgIbaTlj1rRCkD9zGGE_JAC3THw.S.N5mqM
 EfKVcr3myaxXw_sqyWXMFjrwC4xuQr0_5gbbrFf1VNYpmmqyAVH6bPPf7WYDLqy6KxfO0qjbIr.y
 0QptZr1fkXa4sC157F4ORy1C_Zcd.E3nh9HGN.8ng8Z8L_RbjHrzjG6WybcAmjNfSqLZXcWMiktB
 2i7kCWd1iu6KyIsX4AIDCYMbySuhE0TwYZ.enkIIIrSEsKvwhmvt1bbPNf5jCrKz4rSidYQfzJJ_
 Rr4bth1tjsMp2JalxwlUWPPs0OR.pOnkNzjr1fis80hCOQeWiTPABWMw99kmLvLDvJ6t0P1.BKJC
 T81mBQP1B3voAwypULuSODK.9RXa4f2geqbvwbshV6o4sH4OfrMNkaXjvSIPVSh3sFbY4CVbT67a
 QXcQ2PGQkJ8RmJ..cZyYHcST9H9BwGla6f5C0JFg2_ddR7nKO6Q.o59kmb22GKVBEcDX65L1480N
 RV2h.5UunL3clXSmqNf8ZIfknHd_d65aSUE9tnt1BqkY9QP06hC.qSxbnnMdC6_Sd.ftDfV1lbpX
 X682SZ_YIBZYhccbsYqDL4EfcycfrcM2TqNZkv5FbaTlQtQg8Qoe.IC7B1YgiJlwTbCs96urL9rM
 HMr6oNNQxyuXvVtGmoWw8YmK1r8vdO2EvMyiaYY8HelxptK7l6TprUk7P19.8NQ--
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic313.consmr.mail.ir2.yahoo.com with HTTP; Tue, 22 Oct 2019 17:25:38 +0000
Received: by smtp425.mail.ir2.yahoo.com (Oath Hermes SMTP Server) with ESMTPA
 ID 9dc885be2c4e11bce2122c858167c403; 
 Tue, 22 Oct 2019 17:25:34 +0000 (UTC)
To: Li Guifu <bluce.liguifu@huawei.com>,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH v3] erofs-utils: introduce long parameter option
Date: Wed, 23 Oct 2019 01:25:18 +0800
Message-Id: <20191022172518.9020-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <e920ef02-6ec8-cce3-504d-2405b2178f08@gmail.com>
References: <e920ef02-6ec8-cce3-504d-2405b2178f08@gmail.com>
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
Cc: Miao Xie <miaoxie@huawei.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Li Guifu <blucerlee@gmail.com>

Only long option "--help" is valid now.

Signed-off-by: Li Guifu <blucerlee@gmail.com>
Tested-by: Li Guifu <blucerlee@gmail.com>
Signed-off-by: Gao Xiang <hsiangkao@aol.com>
---
changes since v2:
 - add getopt.h to AC_CHECK_HEADERS;

 configure.ac |  1 +
 mkfs/main.c  | 14 +++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 8c31cb7..4f88678 100644
--- a/configure.ac
+++ b/configure.ac
@@ -71,6 +71,7 @@ AC_ARG_VAR([LZ4_LIBS], [linker flags for lz4])
 AC_CHECK_HEADERS(m4_flatten([
 	dirent.h
 	fcntl.h
+	getopt.h
 	inttypes.h
 	linux/falloc.h
 	linux/fs.h
diff --git a/mkfs/main.c b/mkfs/main.c
index 71c81f5..31cf1c2 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -13,6 +13,7 @@
 #include <limits.h>
 #include <libgen.h>
 #include <sys/stat.h>
+#include <getopt.h>
 #include "erofs/config.h"
 #include "erofs/print.h"
 #include "erofs/cache.h"
@@ -23,6 +24,11 @@
 
 #define EROFS_SUPER_END (EROFS_SUPER_OFFSET + sizeof(struct erofs_super_block))
 
+static struct option long_options[] = {
+	{"help", no_argument, 0, 1},
+	{0, 0, 0, 0},
+};
+
 static void usage(void)
 {
 	fprintf(stderr, "usage: [options] FILE DIRECTORY\n\n");
@@ -32,6 +38,7 @@ static void usage(void)
 	fprintf(stderr, " -x#       set xattr tolerance to # (< 0, disable xattrs; default 2)\n");
 	fprintf(stderr, " -EX[,...] X=extended options\n");
 	fprintf(stderr, " -T#       set a fixed UNIX timestamp # to all files\n");
+	fprintf(stderr, " --help    display this help and exit\n");
 }
 
 static int parse_extended_opts(const char *opts)
@@ -96,7 +103,8 @@ static int mkfs_parse_options_cfg(int argc, char *argv[])
 	char *endptr;
 	int opt, i;
 
-	while ((opt = getopt(argc, argv, "d:x:z:E:T:")) != -1) {
+	while((opt = getopt_long(argc, argv, "d:x:z:E:T:",
+				 long_options, NULL)) != -1) {
 		switch (opt) {
 		case 'z':
 			if (!optarg) {
@@ -146,6 +154,10 @@ static int mkfs_parse_options_cfg(int argc, char *argv[])
 			}
 			break;
 
+		case 1:
+			usage();
+			exit(0);
+
 		default: /* '?' */
 			return -EINVAL;
 		}
-- 
2.17.1

