Return-Path: <SRS0=qwvC=OF=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D06C433EF
	for <linux-erofs@archiver.kernel.org>; Wed, 15 Sep 2021 09:29:30 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B631E61248
	for <linux-erofs@archiver.kernel.org>; Wed, 15 Sep 2021 09:29:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B631E61248
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4H8Zfw3R37z2yL7
	for <linux-erofs@archiver.kernel.org>; Wed, 15 Sep 2021 19:29:28 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=huawei.com (client-ip=45.249.212.187; helo=szxga01-in.huawei.com;
 envelope-from=guoxuenan@huawei.com; receiver=<UNKNOWN>)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4H8Zfr3bQSz2xrr
 for <linux-erofs@lists.ozlabs.org>; Wed, 15 Sep 2021 19:29:24 +1000 (AEST)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H8ZYR3ttfzblys;
 Wed, 15 Sep 2021 17:24:43 +0800 (CST)
Received: from kwepemm600004.china.huawei.com (7.193.23.242) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 17:28:49 +0800
Received: from huawei.com (10.175.101.6) by kwepemm600004.china.huawei.com
 (7.193.23.242) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Wed, 15 Sep
 2021 17:28:48 +0800
From: Guo Xuenan <guoxuenan@huawei.com>
To: <xiang@kernel.org>, <linux-erofs@lists.ozlabs.org>
Subject: [PATCH v3 5/5] dump.erofs: add -I options to dump the layout of a
 particular inode on disk
Date: Wed, 15 Sep 2021 17:35:37 +0800
Message-ID: <20210915093537.2579575-5-guoxuenan@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210915093537.2579575-1-guoxuenan@huawei.com>
References: <20210915093537.2579575-1-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600004.china.huawei.com (7.193.23.242)
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
Cc: mpiglet@outlook.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Wang Qi <mpiglet@outlook.com>

Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
Signed-off-by: Wang Qi <mpiglet@outlook.com>
---
 dump/main.c | 88 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 86 insertions(+), 2 deletions(-)

diff --git a/dump/main.c b/dump/main.c
index e2ceee3..34a17f9 100644
--- a/dump/main.c
+++ b/dump/main.c
@@ -21,8 +21,10 @@ struct dumpcfg {
 	bool print_superblock;
 	bool print_inode;
 	bool print_statistic;
+	bool print_inode_phy;
 	bool print_version;
 	u64 ino;
+	u64 ino_phy;
 };
 static struct dumpcfg dumpcfg;
 
@@ -92,6 +94,7 @@ static void usage(void)
 		"Dump erofs layout from IMAGE, and [options] are:\n"
 		"-s      print information about superblock\n"
 		"-i #    print target # inode info\n"
+		"-I #    print target # inode on-disk info\n"
 		"-S      print statistic information of the erofs-image\n"
 		"-V      print the version number of dump.erofs and exit.\n"
 		"--help  display this help and exit.\n",
@@ -107,7 +110,7 @@ static int dumpfs_parse_options_cfg(int argc, char **argv)
 	int opt;
 	u64 i;
 
-	while ((opt = getopt_long(argc, argv, "i:sSV",
+	while ((opt = getopt_long(argc, argv, "i:I:sSV",
 					long_options, NULL)) != -1) {
 		switch (opt) {
 		case 'i':
@@ -115,6 +118,11 @@ static int dumpfs_parse_options_cfg(int argc, char **argv)
 			dumpcfg.print_inode = true;
 			dumpcfg.ino = i;
 			break;
+		case 'I':
+			i = atoll(optarg);
+			dumpcfg.print_inode_phy = true;
+			dumpcfg.ino_phy = i;
+			break;
 		case 's':
 			dumpcfg.print_superblock = true;
 			break;
@@ -167,6 +175,7 @@ static int get_file_compressed_size(struct erofs_inode *inode,
 	}
 	return 0;
 }
+
 static int get_path_by_nid(erofs_nid_t nid, erofs_nid_t parent_nid,
 		erofs_nid_t target, char *path, unsigned int pos)
 {
@@ -249,6 +258,78 @@ static int get_path_by_nid(erofs_nid_t nid, erofs_nid_t parent_nid,
 	return -1;
 }
 
+static void dumpfs_print_inode_phy(void)
+{
+	int err;
+	erofs_nid_t nid = dumpcfg.ino_phy;
+	struct erofs_inode inode = {.nid = nid};
+	char path[PATH_MAX + 1] = {0};
+
+	err = erofs_read_inode_from_disk(&inode);
+	if (err < 0) {
+		erofs_err("read inode %lu from disk failed", nid);
+		return;
+	}
+
+	const erofs_off_t ibase = iloc(inode.nid);
+	const erofs_off_t pos = Z_EROFS_VLE_LEGACY_INDEX_ALIGN(
+			ibase + inode.inode_isize + inode.xattr_isize);
+	erofs_blk_t blocks = inode.u.i_blocks;
+	erofs_blk_t start = 0;
+	erofs_blk_t end = 0;
+	unsigned int extent_count;
+	struct erofs_map_blocks map = {
+		.index = UINT_MAX,
+		.m_la = 0,
+	};
+
+	fprintf(stdout, "Inode %lu on-disk info:\n", nid);
+	err = get_path_by_nid(sbi.root_nid, sbi.root_nid, nid, path, 0);
+	if (!err)
+		fprintf(stderr, "File path: %s\n", path);
+	else
+		erofs_err("path not found");
+	fprintf(stdout, "File size: %lu\n", inode.i_size);
+
+	switch (inode.datalayout) {
+	case EROFS_INODE_FLAT_INLINE:
+	case EROFS_INODE_FLAT_PLAIN:
+		if (inode.u.i_blkaddr == NULL_ADDR)
+			start = end = erofs_blknr(pos);
+		else {
+			start = inode.u.i_blkaddr;
+			end = start + BLK_ROUND_UP(inode.i_size) - 1;
+		}
+		fprintf(stdout, "Plain blknr: %u - %u\n", start, end);
+		break;
+
+	case EROFS_INODE_FLAT_COMPRESSION_LEGACY:
+	case EROFS_INODE_FLAT_COMPRESSION:
+		err = z_erofs_map_blocks_iter(&inode, &map, 0);
+		if (err)
+			erofs_err("get file blocks range failed");
+
+		start = erofs_blknr(map.m_pa);
+		end = start - 1 + blocks;
+		fprintf(stdout,
+				"Compressed blknr: %u - %u\n", start, end);
+		extent_count = 0;
+		map.m_la = 0;
+		while (map.m_la < inode.i_size) {
+			err = z_erofs_map_blocks_iter(&inode, &map,
+					EROFS_GET_BLOCKS_FIEMAP);
+			fprintf(stdout, "Extent %u:\n", extent_count++);
+			fprintf(stdout, "on-disk blkaddr/length: 0x%08lx/0x%04lx\n",
+					map.m_pa, map.m_plen);
+			fprintf(stdout, "logical offset/length:  0x%08lx/0x%04lx\n",
+					map.m_la, map.m_llen);
+			map.m_la += map.m_llen;
+		}
+
+		break;
+	}
+}
+
 static void dumpfs_print_inode(void)
 {
 	int err;
@@ -272,7 +353,7 @@ static void dumpfs_print_inode(void)
 		return;
 	}
 
-	fprintf(stdout, "Inode %lu info:\n", dumpcfg.ino);
+	fprintf(stdout, "Inode %lu on-disk info:\n", dumpcfg.ino);
 	err = get_path_by_nid(sbi.root_nid, sbi.root_nid, nid, path, 0);
 
 	fprintf(stdout, "File path:            %s\n",
@@ -653,6 +734,9 @@ int main(int argc, char **argv)
 	if (dumpcfg.print_inode)
 		dumpfs_print_inode();
 
+	if (dumpcfg.print_inode_phy)
+		dumpfs_print_inode_phy();
+
 exit:
 	erofs_exit_configure();
 	return err;
-- 
2.25.4

