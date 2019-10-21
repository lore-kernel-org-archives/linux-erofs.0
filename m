Return-Path: <SRS0=zfPl=YO=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C79DCA9EAF
	for <linux-erofs@archiver.kernel.org>; Mon, 21 Oct 2019 18:36:01 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D8A3120684
	for <linux-erofs@archiver.kernel.org>; Mon, 21 Oct 2019 18:36:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="iG7oyWSQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8A3120684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=163.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46xlhG2pHTzDqFw
	for <linux-erofs@archiver.kernel.org>; Tue, 22 Oct 2019 05:35:58 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
 spf=pass (sender SPF authorized) smtp.mailfrom=163.com
 (client-ip=123.126.97.5; helo=mail-m975.mail.163.com;
 envelope-from=wylgf01@163.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=163.com header.i=@163.com header.b="iG7oyWSQ"; 
 dkim-atps=neutral
X-Greylist: delayed 934 seconds by postgrey-1.36 at bilbo;
 Tue, 22 Oct 2019 05:35:45 AEDT
Received: from mail-m975.mail.163.com (mail-m975.mail.163.com [123.126.97.5])
 by lists.ozlabs.org (Postfix) with ESMTP id 46xlh160tKzDqDb
 for <linux-erofs@lists.ozlabs.org>; Tue, 22 Oct 2019 05:35:44 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
 s=s110527; h=From:Subject:Date:Message-Id; bh=sREV3PuzMnWnHdOTYL
 K59h54GWLiSi9zW1hf3mHZfKA=; b=iG7oyWSQRFqzlIDxWNIj6UQQ/yKBzbFxjm
 EOkJ5wPfKVQxC8nWvFjFpkBqi5i9EdjOxjeBe8oHZpF8NwrwcNmsmJqbJurTqO91
 dB8Dbx3Q2qmVWMAVXuyufCqognHdSl2kCnOON7TrjU/uffXSpJvpoSsDSz2XdpPQ
 MLF7eFNoI=
Received: from localhost.localdomain (unknown [223.166.142.239])
 by smtp5 (Coremail) with SMTP id HdxpCgBHqZC89q1d3lhAHg--.14S2;
 Tue, 22 Oct 2019 02:19:56 +0800 (CST)
From: Li Guifu <wylgf01@163.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH v1] erofs-utils: introduce long parameter option
Date: Tue, 22 Oct 2019 02:19:23 +0800
Message-Id: <20191021181923.3773-1-wylgf01@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: HdxpCgBHqZC89q1d3lhAHg--.14S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cr4kGFy8uF1kur4fCF15Arb_yoW8AryxpF
 98AFn7Grs5Xry7J39xXw1vyFyfC397tF4UJrZrAa4UAFn3GrWDt3yktr9aqryIkFZFy3y5
 ZFWava4DWF47AFJanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jqhFxUUUUU=
X-Originating-IP: [223.166.142.239]
X-CM-SenderInfo: pz1owwiqr6il2tof0z/xtbBEQxVy1aD727gqQAAse
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Li Guifu <blucerlee@gmail.com>

Only --help|-h is uesed right now

Signed-off-by: Li Guifu <blucerlee@gmail.com>
---
 mkfs/main.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index 71c81f5..f62b065 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -13,6 +13,8 @@
 #include <limits.h>
 #include <libgen.h>
 #include <sys/stat.h>
+#include <getopt.h>
+
 #include "erofs/config.h"
 #include "erofs/print.h"
 #include "erofs/cache.h"
@@ -23,10 +25,16 @@
 
 #define EROFS_SUPER_END (EROFS_SUPER_OFFSET + sizeof(struct erofs_super_block))
 
+static struct option long_options[] = {
+	{"help", no_argument, 0, 'h'},
+	{0, 0, 0, 0},
+};
+
 static void usage(void)
 {
 	fprintf(stderr, "usage: [options] FILE DIRECTORY\n\n");
 	fprintf(stderr, "Generate erofs image from DIRECTORY to FILE, and [options] are:\n");
+	fprintf(stderr, " -h|--help print usage message then exit 0\n");
 	fprintf(stderr, " -zX[,Y]   X=compressor (Y=compression level, optional)\n");
 	fprintf(stderr, " -d#       set output message level to # (maximum 9)\n");
 	fprintf(stderr, " -x#       set xattr tolerance to # (< 0, disable xattrs; default 2)\n");
@@ -95,8 +103,10 @@ static int mkfs_parse_options_cfg(int argc, char *argv[])
 {
 	char *endptr;
 	int opt, i;
+	int option_index = 0;
 
-	while ((opt = getopt(argc, argv, "d:x:z:E:T:")) != -1) {
+	while((opt = getopt_long(argc, argv, "d:z:E:T:h", long_options,
+				 &option_index)) != -1) {
 		switch (opt) {
 		case 'z':
 			if (!optarg) {
@@ -146,6 +156,11 @@ static int mkfs_parse_options_cfg(int argc, char *argv[])
 			}
 			break;
 
+		case 'h':
+		case '?':
+			usage();
+			exit(0);
+
 		default: /* '?' */
 			return -EINVAL;
 		}
-- 
2.17.1

