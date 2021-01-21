Return-Path: <SRS0=hezN=GY=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1436DC433DB
	for <linux-erofs@archiver.kernel.org>; Thu, 21 Jan 2021 16:32:43 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 48BC5206D8
	for <linux-erofs@archiver.kernel.org>; Thu, 21 Jan 2021 16:32:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48BC5206D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mail.scut.edu.cn
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4DM7Gc2nwlzDrRB
	for <linux-erofs@archiver.kernel.org>; Fri, 22 Jan 2021 03:32:40 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=mail.scut.edu.cn (client-ip=202.38.213.20; helo=mail.scut.edu.cn;
 envelope-from=sehuww@mail.scut.edu.cn; receiver=<UNKNOWN>)
Received: from mail.scut.edu.cn (stumail1.scut.edu.cn [202.38.213.20])
 by lists.ozlabs.org (Postfix) with ESMTP id 4DM7GP29jGzDrQ4
 for <linux-erofs@lists.ozlabs.org>; Fri, 22 Jan 2021 03:32:24 +1100 (AEDT)
Received: from DESKTOP-N4CECTO.huww98.cn (unknown [59.53.40.31])
 by front (Coremail) with SMTP id AWSowAAXH+N_rAlgZazbAQ--.55262S4;
 Fri, 22 Jan 2021 00:32:00 +0800 (CST)
From: Hu Weiwen <sehuww@mail.scut.edu.cn>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: fuse: fix random readlink error
Date: Fri, 22 Jan 2021 00:31:43 +0800
Message-Id: <20210121163143.9481-1-sehuww@mail.scut.edu.cn>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210121112702.GA2918836@xiangao.remote.csb>
References: <20210121112702.GA2918836@xiangao.remote.csb>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AWSowAAXH+N_rAlgZazbAQ--.55262S4
X-Coremail-Antispam: 1UD129KBjvJXoWrZF15uw45Jw17Jw13Wr45KFg_yoW8Jr4Upr
 s0kFW5Jr4ftry3Ar4fGFs8Wa4rGr97Wr1jk392ka1fZF17Jrn8ua4rGayqqryrAr48Cr4x
 JanrXFZY9F4UZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkq14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
 6F4UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4j6r
 4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
 I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
 4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_JwCF
 04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
 18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1lIxkGc2Ij64vI
 r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr
 1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
 0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUU89N7UUUUU==
X-CM-SenderInfo: qsqrljqqwxllyrt6zt1loo2ulxwovvfxof0/1tbiAQAHBlepTBDfZQARsJ
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

readlink should fill a **null terminated** string in buffer.

Also, read should return number of bytes remaining on EOF.

Link: https://lore.kernel.org/linux-erofs/20210121101233.GC6680@DESKTOP-N4CECTO.huww98.cn/
Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
---
 fuse/main.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fuse/main.c b/fuse/main.c
index c162912..bc1e496 100644
--- a/fuse/main.c
+++ b/fuse/main.c
@@ -71,6 +71,12 @@ static int erofsfuse_read(const char *path, char *buffer,
 	if (ret)
 		return ret;
 
+	if (offset >= vi.i_size)
+		return 0;
+
+	if (offset + size > vi.i_size)
+		size = vi.i_size - offset;
+
 	ret = erofs_pread(&vi, buffer, size, offset);
 	if (ret)
 		return ret;
@@ -79,10 +85,16 @@ static int erofsfuse_read(const char *path, char *buffer,
 
 static int erofsfuse_readlink(const char *path, char *buffer, size_t size)
 {
-	int ret = erofsfuse_read(path, buffer, size, 0, NULL);
+	int ret;
+	size_t path_len;
+
+	erofs_dbg("path:%s size=%zd", path, size);
+	ret = erofsfuse_read(path, buffer, size, 0, NULL);
 
 	if (ret < 0)
 		return ret;
+	path_len = min(size - 1, (size_t)ret);
+	buffer[path_len] = '\0';
 	return 0;
 }
 
-- 
2.30.0

