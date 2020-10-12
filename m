Return-Path: <SRS0=Po1J=DT=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43337C433E7
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2020 00:39:20 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4DC6F20756
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2020 00:39:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="dZZuyVms";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=aol.com header.i=@aol.com header.b="LWP+gbak"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DC6F20756
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4C8fv93gfVzDqs8
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2020 11:39:17 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1602463157;
	bh=EX4pvPD61hKa4uqBMZsKgouGJtmZcKosEHblPNh3bEk=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:
	 From;
	b=dZZuyVmswlSpvbbPx6SB9bUakArL0d4DEh5iBsZc+2luDgJjwgc9HYbkwzFQL7KAU
	 84T8o+/wlPgAbUaPs2yOApZn8UjoFz8c1y8lS/ZJmM/gs2yiQ4CAxtx4weLOziDE8L
	 WuB1UobEJjQhDAsLDu7UkPFISi7+PgOr3+Cvr1p4IVyfvycKrRx6nL3y/fOvcrQCmo
	 1LLw8GLCGA+LDgbD+LwC1a0yquwYNj9KrGLy7ISwaNBPhi9HMkfs4JzVnHR79DDmkX
	 Pba8tOFSMfzlFfKwJbL7fAKKtDlX6WhXcI1/6o3lHYEesbTxOraZmaJBRU5Ol9fmY4
	 EZrKMEqGeVY4Q==
Authentication-Results: lists.ozlabs.org;
 spf=pass (sender SPF authorized) smtp.mailfrom=aol.com
 (client-ip=98.137.64.84; helo=sonic305-21.consmr.mail.gq1.yahoo.com;
 envelope-from=hsiangkao@aol.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=aol.com header.i=@aol.com header.a=rsa-sha256
 header.s=a2048 header.b=LWP+gbak; dkim-atps=neutral
Received: from sonic305-21.consmr.mail.gq1.yahoo.com
 (sonic305-21.consmr.mail.gq1.yahoo.com [98.137.64.84])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4C8ftz1sG0zDqqD
 for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2020 11:39:05 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048;
 t=1602463142; bh=s+nu9RMXzt5lSGKWlRH7NpLvEXFQndkB2w0L2lZ5pO0=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject;
 b=LWP+gbakt/6ACbvqwWErjDqQii+fF93vLlI6wotOrqhh5qW+5yObgX3vbrk3zHAI3qaq2b4f+1e4otZMq3jMdRa16Npc5Cf4n+S0dZFum0cDsAj8JNxN65IcIAxvG/hyYO3U+LuwjS2yqCmyT8yU9C4XojTWk1ZeiUL+v30mSN0zWPLZ8QiLehJHIyhu//9nfLe/ePibqIgJiIylk1a6EpYZS0RMRZ7KjdiDIG2FwJ/onvp7xcofpkoe68jnWNHR5P8iHTCHHDp76XyziAJEgEmot7IEZ+fGoUbNO0YO18wGud6Rv6qUxT1LRZygtt95998Nw4et1yOjNL/T59rlhg==
X-YMail-OSG: Dz97OBsVM1kdXTDZ2KRYBRFsBxLrYXFrjlEf_Xy9ZTWPNV2cqtqtpKtjgDCOavo
 7ZEiNA4Iubpqjuhje6bUsOS82D07yAHDtsA6iOlkgNLOa9P3_aX8t1cCPo2UU3T24pDdaTG4XAvI
 WQskcRWJfLL_xwQFE0xN3Es4LD4PUNAzU7P4jdw4fob2xz3GGAOBvIKPdCjekI4SYdw3OBTqhRDE
 7g_m6L.rJJabvhqoUwzEb7dny13jW5bKv5xUvJUTwcBRiUNST.dYKap21vZDYGrgUmiXy8DnsCE3
 qY8ZmQ71UO5nOaTaiAdY8xxY6tokxiQJ00l04ZYv.83BVKNErsiPm9WxXxsMrG4rQyF3cvTE_BAo
 euSKzlEaBrrR_jaA.QbvH_LOLB4.ZOlhqgt56A.Q5cdDmVowHhww6JlJzBcuZuqxWVxqn7Szvv3m
 QPgrfKV5SNd_DyoIgXMf5bFTVLgYKxnwmH6m9s_LLuyJTeh3.TgR_CX0.XaSutYYFtJgiWuTiQlx
 rTVbSN1zFi6vSHDhX46SZ4KJsPIizqK2YYJ.2QR.cBIPVvVUsCfdHDQdgsKd_p9Vk2qYrtH_w4BV
 VdwW3vYTZSt7r0_TpGAfL4rmmUQMMsilerlbe1lDq4FvQ3EEeGOb.5NOP_dS6b9R40DOKun7j_JS
 BlTvT3RNXP77QMnDtWID47iaPCFeRCjuP.GTmfrtv_xcQb7yxbsXHnxAioyxQKpgGgl491YRba6c
 YIO67ExXMM28vr_tzr6S4N5m39uTVWC.BEN7e93obMPkVngPqsWW06v7FoVQxWFmvVnKvjejc8hQ
 VHwkVbBQxqg5aBlTPEH6lLnZo5izpA2eoANTFEdxUd2vrdV2lLcp67c5ZHOyN5bKiH5XGdRb9oLJ
 MjIOrffU42RzIy5l80gaXG0VdQWFxGxp0unNPxBGRp3_Vti.iB_yB2WEisBBRTVQAuYlTFfROxSC
 W2uVVXk4mSBl7pssQucUNfokFBIHLmQGTIgCbu0r6doX099zoT85YiDnEY9xKWpUlRo3MfHD5kPF
 b1SYBADmzTHzb5NZxwhhyEKCnVwYoFK4Vdz6nr0ux7RjhxgZN5YBFESxtgVArAw1atbFNQLZbTAq
 I4vCnbVOQ5WKA7q4PFO9FWywiUXwy1hPO5mR0aBhHwYMQL_15HtjVD82QOrMwO4U5RPwBrQhmPyx
 z4XwbwqJhUhhGxXhyrQ5644ko5tiIydKUvFzo853xfT3gaunL44rVa7skLmZINOR2mHciITIns9X
 gEZ.BZMmUWfdo5dj5lSdRBeMx98eTdq6YKENQPNF8oQFykqKj1FJrxejSPrantNGLgwxxE_p7w1T
 W4BZ6SyLnKFrPToh_JS7V8e.H6cA8rVlhIz0TMFKqmfS7.NfhOUVz1qEw5xh9ussa7wMC0VEl5Wf
 9Lme6yqxcaeDoVD1UU0wEAbQwvsawWHmAi5S.9RJf8DI3Q8OVxsB8F63.EhOuxEBDzRGBxaWxajZ
 txXF9aNA3AfC_OVdrbZtBLGulYShQYacijjkgYcRtC0qVAk28wEiiEnzxAL2Nv9uu5WdqwqdCpoL
 umda_v81RyQ--
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic305.consmr.mail.gq1.yahoo.com with HTTP; Mon, 12 Oct 2020 00:39:02 +0000
Received: by smtp404.mail.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA
 ID 6560d697440fc141bbc952eeeba38b6b; 
 Mon, 12 Oct 2020 00:39:00 +0000 (UTC)
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] AOSP: erofs-utils: update usage due to fs_config
Date: Mon, 12 Oct 2020 08:38:05 +0800
Message-Id: <20201012003805.4068-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20201012002227.1882-1-hsiangkao@aol.com>
References: <20201012002227.1882-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

After fs_config support is added, usage() should
be updated together as well.

Fixes: 8a9e8046f170 ("AOSP: erofs-utils: add fs_config support")
Cc: Li Guifu <bluce.lee@aliyun.com>
Signed-off-by: Gao Xiang <hsiangkao@aol.com>
---
v2: fix commit message expression.

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

