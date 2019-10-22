Return-Path: <SRS0=kNa8=YP=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D2CCA9EA0
	for <linux-erofs@archiver.kernel.org>; Tue, 22 Oct 2019 04:17:33 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9AA302084B
	for <linux-erofs@archiver.kernel.org>; Tue, 22 Oct 2019 04:17:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9AA302084B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46y0bH5YX0zDqL9
	for <linux-erofs@archiver.kernel.org>; Tue, 22 Oct 2019 15:17:31 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=huawei.com (client-ip=45.249.212.190; helo=huawei.com;
 envelope-from=gaoxiang25@huawei.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=huawei.com
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46y0b93CngzDqJs
 for <linux-erofs@lists.ozlabs.org>; Tue, 22 Oct 2019 15:17:25 +1100 (AEDT)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 1282EF04FC61D9330E19
 for <linux-erofs@lists.ozlabs.org>; Tue, 22 Oct 2019 12:17:20 +0800 (CST)
Received: from architecture4.huawei.com (10.140.130.215) by smtp.huawei.com
 (10.3.19.203) with Microsoft SMTP Server (TLS) id 14.3.439.0; Tue, 22 Oct
 2019 12:17:09 +0800
From: Gao Xiang <gaoxiang25@huawei.com>
To: Li Guifu <bluce.liguifu@huawei.com>
Subject: [PATCH] erofs-utils: list available compressors for help command
Date: Tue, 22 Oct 2019 12:20:02 +0800
Message-ID: <20191022042002.61999-1-gaoxiang25@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.140.130.215]
X-CFilter-Loop: Reflected
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
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Users can get knowledge of supported compression
algorithms then.

Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
---
 include/erofs/compress.h |  2 ++
 lib/compressor.c         | 17 +++++++++++++++++
 mkfs/main.c              | 15 +++++++++++++++
 3 files changed, 34 insertions(+)

diff --git a/include/erofs/compress.h b/include/erofs/compress.h
index e0abb8f1c422..fa918732b532 100644
--- a/include/erofs/compress.h
+++ b/include/erofs/compress.h
@@ -21,5 +21,7 @@ int erofs_write_compressed_file(struct erofs_inode *inode);
 int z_erofs_compress_init(void);
 int z_erofs_compress_exit(void);
 
+const char *z_erofs_list_available_compressors(unsigned int i);
+
 #endif
 
diff --git a/lib/compressor.c b/lib/compressor.c
index 8cc2f438479b..c593c769d46f 100644
--- a/lib/compressor.c
+++ b/lib/compressor.c
@@ -36,6 +36,23 @@ int erofs_compress_destsize(struct erofs_compress *c,
 	return ret;
 }
 
+const char *z_erofs_list_available_compressors(unsigned int i)
+{
+	static const char *compressors[] = {
+#if LZ4_ENABLED
+#if LZ4HC_ENABLED
+		"lz4hc",
+#endif
+		"lz4",
+#endif
+		NULL,
+	};
+
+	if (i >= ARRAY_SIZE(compressors))
+		return NULL;
+	return compressors[i];
+}
+
 int erofs_compressor_init(struct erofs_compress *c,
 			  char *alg_name)
 {
diff --git a/mkfs/main.c b/mkfs/main.c
index 31cf1c2408d1..1161b3f0f7cc 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -29,6 +29,19 @@ static struct option long_options[] = {
 	{0, 0, 0, 0},
 };
 
+static void print_available_compressors(FILE *f, const char *delim)
+{
+	unsigned int i = 0;
+	const char *s;
+
+	while ((s = z_erofs_list_available_compressors(i)) != NULL) {
+		if (i++)
+			fputs(delim, f);
+		fputs(s, f);
+	}
+	fputc('\n', f);
+}
+
 static void usage(void)
 {
 	fprintf(stderr, "usage: [options] FILE DIRECTORY\n\n");
@@ -39,6 +52,8 @@ static void usage(void)
 	fprintf(stderr, " -EX[,...] X=extended options\n");
 	fprintf(stderr, " -T#       set a fixed UNIX timestamp # to all files\n");
 	fprintf(stderr, " --help    display this help and exit\n");
+	fprintf(stderr, "\nAvailable compressors are: ");
+	print_available_compressors(stderr, ", ");
 }
 
 static int parse_extended_opts(const char *opts)
-- 
2.17.1

