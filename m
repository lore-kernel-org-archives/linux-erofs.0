Return-Path: <SRS0=81ls=ID=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0690C433DB
	for <linux-erofs@archiver.kernel.org>; Fri,  5 Mar 2021 08:22:09 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4F90764D74
	for <linux-erofs@archiver.kernel.org>; Fri,  5 Mar 2021 08:22:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F90764D74
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4DsLLm052Xz3cGV
	for <linux-erofs@archiver.kernel.org>; Fri,  5 Mar 2021 19:22:08 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1614932528;
	bh=XW9yITYANNnTIcGl3pG9pq+M97yEdZtj0eRnPE06HfM=;
	h=To:Subject:Date:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=cCxnHuSu8rXLN4rifelhO9C/grFPomodyrYuNqjEP2s/ajaREsV2Sl1/fcWp2aS6F
	 V8bF4bmWWHPihQSts2/J3UcwzxVWMmW3Wr7Ls20MxhNIH7/bp+xP+8C1YbzuQxFAAu
	 N+aycn0RS4jDcz9vnKFufnCjCaQ7ZzTmR7jpFHNXEaVUBpL3QpBeUP+WubraNHYvrP
	 2mUCMOl4rVRC9YvPo0RyAqoysUyOfzXzEEtBA3Qla9BonLcth0derFUjvHoQHpJqdn
	 +ZF1hemLjlMW4xQ6CG4DKvO7SV/0SWVJa3WvqK+k4AGbWsxrvo++PqiH4dIPGXG4E7
	 3Np3XQ7yDXdIw==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=oppo.com (client-ip=40.107.131.59;
 helo=apc01-sg2-obe.outbound.protection.outlook.com;
 envelope-from=huangjianan@oppo.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=oppo.com header.i=@oppo.com header.a=rsa-sha256
 header.s=selector1 header.b=CeJJbfna; 
 dkim-atps=neutral
Received: from APC01-SG2-obe.outbound.protection.outlook.com
 (mail-eopbgr1310059.outbound.protection.outlook.com [40.107.131.59])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4DsLLg2ns2z30Qb
 for <linux-erofs@lists.ozlabs.org>; Fri,  5 Mar 2021 19:22:02 +1100 (AEDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kN3ObUWO3dFABRC5fgS+rPSGUi0PHQJJJ/lOswpYIuWWaDQ3wCZbwKgUkOj2ydvPedLAE8SR/+J2DmGj8+J6HEFkFuCpfGr+TFLDTztMnx5nSomOGMQ6ZTq6QlBFdEOU6edxmc+nw/pUUIKeg0L2dEKe73qKsfYXuD4Mfw5qtZtUd5BRIC8AZxjDBmP4VyPykfMaws5/HBAyBwSAtQixlW/AI52ATfpzyhSODWu13XpjcaMbNq0HjlXJxzJrc+kgL/YQ3Ris+ick9oQDRFShCzW6SFjk7g6ljEoGEBSNcVxpkXBQQkWI/5Gbx8NkyHm5wYXzaqm1upskSWScsrdbtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XW9yITYANNnTIcGl3pG9pq+M97yEdZtj0eRnPE06HfM=;
 b=ddUjXkvzgUNgWFC5Ms7SqHdxd5ClQMXmCmkmFrJcjye6+nV/MP3RzzbXUkfYNkT8LqLTjp6bx8CmPD8PCxAo316t+XbAH36X/15Ixel0985hMscbaMp7BQ2WVsJvD4ge4WOFEaDfdIEt6WMs9ZKSOI53eItS+HGB0SLn0N+sGIJFPY8Dt/XpGazDttswJEng90w/1wa2X4lSq45dStXcwkeMtG9UjXCg8p7nuM+ShikgDgkLFVAUvC8qD9rtzjP9FYXDq+tYg6gDttgLrENri1s/w3qoSyHzZ7wOZazqfG4riP0hSYWJ3xLefHNV/+PuQWWNSPd4n8g+kTw0tq4pgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
Authentication-Results: lists.ozlabs.org; dkim=none (message not signed)
 header.d=none;lists.ozlabs.org; dmarc=none action=none header.from=oppo.com;
Received: from SG2PR02MB4108.apcprd02.prod.outlook.com (2603:1096:4:96::19) by
 SG2PR02MB4021.apcprd02.prod.outlook.com (2603:1096:4:80::15) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.20; Fri, 5 Mar 2021 08:21:57 +0000
Received: from SG2PR02MB4108.apcprd02.prod.outlook.com
 ([fe80::1143:a7b7:6bd4:83b3]) by SG2PR02MB4108.apcprd02.prod.outlook.com
 ([fe80::1143:a7b7:6bd4:83b3%7]) with mapi id 15.20.3890.032; Fri, 5 Mar 2021
 08:21:57 +0000
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH v4 2/2] erofs: decompress in endio if possible
Date: Fri,  5 Mar 2021 16:21:42 +0800
Message-Id: <20210305082142.877265-1-huangjianan@oppo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [58.252.5.72]
X-ClientProxiedBy: HKAPR03CA0020.apcprd03.prod.outlook.com
 (2603:1096:203:c9::7) To SG2PR02MB4108.apcprd02.prod.outlook.com
 (2603:1096:4:96::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (58.252.5.72) by
 HKAPR03CA0020.apcprd03.prod.outlook.com (2603:1096:203:c9::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.13 via Frontend Transport; Fri, 5 Mar 2021 08:21:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22bd466d-ca83-40f3-45d4-08d8dfafbddb
X-MS-TrafficTypeDiagnostic: SG2PR02MB4021:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SG2PR02MB4021747181292B814A6FFEAAC3969@SG2PR02MB4021.apcprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 53ZshKKIRHFIk/BjYWaBqWwodSrK+iwE6Yn2uJB453ndmRie1WYP1d4OaDEw1xsDTS/j7Bzjr2yjnjKkottZBr2tvyGVQcm70q/kuf33P5X2MMPRJ9zDJVNo3fbTtmI61rACjPcLhU4x0C0rFbfbYMQLE8xAayakGtNuFLT4bonvg0r7eCXvcujN7q9J77PpNNK8UtXT495g+TEVv/Kdz9I61n/Oalw0mXjkw4VwYRGO5vnCvboAeV86X18HDTJXWAL7vXVzGLcIejRZPOA0HIGW1dvjkpOjTiHibMNGCPHcxGT2wKC1XF/5cOx+yv5f8XmTgKg3/POH5SCOcfkTwFxGWl86YoTyhNzIk2Ho4c1H8gx7JPG86JaPiZ8ie2uMC5d6WKoMXXwmLdIMXtK0QX7/5HqTfRlEiQCmWqJmif0PZEZf2/MtLHGJZJMe8sZyZVYKCJsjp5mPq7Fdk7GOjflbVBt7A8dNXEVYlb1oneCnzody8SiFuZs/bfGukT0BwNdOQXolNXpDM2pt1pU3UnHpaTanpJjCVRnhlFhdWjJhsMJSFxp44a528ZQBU9xcBt1e2B1iJO8edLTGjJ8OkrpkhCpv/hf9byrC6OP7XXA=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SG2PR02MB4108.apcprd02.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(4636009)(376002)(396003)(346002)(39860400002)(366004)(136003)(6512007)(26005)(83380400001)(2906002)(86362001)(8936002)(6506007)(1076003)(66476007)(69590400012)(8676002)(316002)(2616005)(5660300002)(956004)(6666004)(186003)(66946007)(36756003)(16526019)(478600001)(6916009)(6486002)(4326008)(66556008)(52116002)(11606007);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mbypNGnLlaZ9p+bvpgNEG4JdJtOF1X0bIrzDp3uJv0NZWFJxRGsije6Phhfl?=
 =?us-ascii?Q?NFmy4K61tj9hovSVYXJWfCL+aasP4ur+FalgqKQFRa7rCLdZ5iLWPluBoPtU?=
 =?us-ascii?Q?oWbhBKj8JDsAC3AAuKKc5DvSClZxt435G6HqQTLiDo5dl9JzVU+KIgRcUguQ?=
 =?us-ascii?Q?9wdnH3IgUPCsC7bRiRug5TWmn6RNnsz8gefkCUq6GGZhZuQPSSQTJVJnH/cL?=
 =?us-ascii?Q?Sw6RBh6nWNDhUZx2u6D7OFZoiqa8Yi7kwq2p8wYdtTvfUP31cxDwpEqhGhGV?=
 =?us-ascii?Q?5ZSzXDTmSw98W+HBEzvXgl6Ymn6htkjZvhxk2mSOTam14WJJj+KB80sFpgac?=
 =?us-ascii?Q?+4d+V6HQQMVSLTu5PBT9EDPxp5KpkFHzj7WU6jRrA9r9if943MI8mR2ftkHi?=
 =?us-ascii?Q?stv3BpnuzisBhivBPtZITMNKlLJtFgg9cEZNT77rfIRwCqH2FOkkXLBXlF2D?=
 =?us-ascii?Q?JJJseVN4KVhZaJr8mlfMJXehSjFA41Uv6vOHOuR9ZNQTSpGhe4pe6DSjzFf8?=
 =?us-ascii?Q?Fr78DRygG1lgtXFFcoemmeSodOoHRV15Dnm0aDM0S6dBKMKHjC1W1f7obYZF?=
 =?us-ascii?Q?8GRUMAB3TDg8QtL0ULASwCBPKPD79MR/4xNLXjSEQYxoS9GiAP+HXSOmo1LQ?=
 =?us-ascii?Q?jckWpwsKmck92Rs14PfreelWgb3m0InG+khBTNkRpwA0FghWVWbxlV/ZTaqY?=
 =?us-ascii?Q?L0YF3D8eIBqOnGp8a6YiT5/FP3CqDcgxxihjC9sWZPssf9AMCTQz5F3FGU5i?=
 =?us-ascii?Q?cOEdjjEolRjUmO+nYCzYVR/pgE5JEPQUwbg0UTFdBEdGaXSYeJtCGTDg8NsZ?=
 =?us-ascii?Q?udrhYyJlftERmMHxUqoLzMS17bgQFHJhHlx/wOFuHzXe1rqemRDYctmNSMl8?=
 =?us-ascii?Q?5IMofuwHVbv8t8TkjSmIY2BVXUFx+70aBJs2vyCYX/oZ2ZbfcIvbu9WNpYCU?=
 =?us-ascii?Q?zAQWjm0MJDmoJeWrPPluU/nBK2C623aH/bmLDSR++JkvGZOaSy4gT5Om2BJX?=
 =?us-ascii?Q?XSCJgwUtE8WO/bUwTiEQB0uK14e64mdkypN0ZbUC1pRXWHwwb0shweNDSFBR?=
 =?us-ascii?Q?liYP7pGr0cvKsu1nu6Lp6hxVJaGVZJeei2Vb35n+3I0hovYEqQjt5nGMr36X?=
 =?us-ascii?Q?vUbxd0hcA0CmqEYqrwsgNcvFFSeiMZGetkvspsc+OviQnYc9mtyRV6JVS6+H?=
 =?us-ascii?Q?Bk0c0bPybtC/qBJflEN88kHAm+HBK0WYsxvdl1tHC/2RnpctF5DW/pzAr0Xc?=
 =?us-ascii?Q?qrlUCFNzZ4YVo89yzDRFxSJzIoRFc2AkLV85IXNcPlTCmxTTYWnHdq8O7VZZ?=
 =?us-ascii?Q?hWqmYk+uazKksxi3kId+2l+C?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22bd466d-ca83-40f3-45d4-08d8dfafbddb
X-MS-Exchange-CrossTenant-AuthSource: SG2PR02MB4108.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2021 08:21:57.3288 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EWZ8wSS8udIj51Wwwm31UdIzR5V2MUDmUe6HRwisEJHvX+Z0TlX9YuXMl91YGdOoW0G5AETQWvzCD2a/hA7/6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR02MB4021
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
From: Huang Jianan via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Huang Jianan <huangjianan@oppo.com>
Cc: linux-kernel@vger.kernel.org, guoweichao@oppo.com, zhangshiming@oppo.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

z_erofs_decompressqueue_endio may not be executed in the atomic
context, for example, when dm-verity is turned on. In this scenario,
data can be decompressed directly to get rid of additional kworker
scheduling overhead. Also, it makes no sense to apply synchronous
decompression for such case.

Signed-off-by: Huang Jianan <huangjianan@oppo.com>
Signed-off-by: Guo Weichao <guoweichao@oppo.com>
---
 fs/erofs/internal.h |  3 +++
 fs/erofs/super.c    |  4 ++++
 fs/erofs/zdata.c    | 16 +++++++++++++---
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 67a7ec945686..b817cb85d67b 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -70,6 +70,9 @@ struct erofs_sb_info {
 
 	/* pseudo inode to manage cached pages */
 	struct inode *managed_cache;
+
+	/* decide whether to decompress synchronously */
+	bool readahead_sync_decompress;
 #endif	/* CONFIG_EROFS_FS_ZIP */
 	u32 blocks;
 	u32 meta_blkaddr;
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index d5a6b9b888a5..77819efe9b15 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -175,6 +175,10 @@ static int erofs_read_superblock(struct super_block *sb)
 	sbi->root_nid = le16_to_cpu(dsb->root_nid);
 	sbi->inos = le64_to_cpu(dsb->inos);
 
+#ifdef CONFIG_EROFS_FS_ZIP
+	sbi->readahead_sync_decompress = false;
+#endif
+
 	sbi->build_time = le64_to_cpu(dsb->build_time);
 	sbi->build_time_nsec = le32_to_cpu(dsb->build_time_nsec);
 
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 6cb356c4217b..c21447c42eb0 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -706,9 +706,12 @@ static int z_erofs_do_read_page(struct z_erofs_decompress_frontend *fe,
 	goto out;
 }
 
+static void z_erofs_decompressqueue_work(struct work_struct *work);
 static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 				       bool sync, int bios)
 {
+	struct erofs_sb_info *const sbi = EROFS_SB(io->sb);
+
 	/* wake up the caller thread for sync decompression */
 	if (sync) {
 		unsigned long flags;
@@ -720,8 +723,14 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 		return;
 	}
 
-	if (!atomic_add_return(bios, &io->pending_bios))
-		queue_work(z_erofs_workqueue, &io->u.work);
+	if (!atomic_add_return(bios, &io->pending_bios)) {
+		if (in_atomic() || irqs_disabled()) {
+			queue_work(z_erofs_workqueue, &io->u.work);
+			sbi->readahead_sync_decompress = true;
+		} else {
+			z_erofs_decompressqueue_work(&io->u.work);
+		}
+	}
 }
 
 static bool z_erofs_page_is_invalidated(struct page *page)
@@ -1333,7 +1342,8 @@ static void z_erofs_readahead(struct readahead_control *rac)
 	struct erofs_sb_info *const sbi = EROFS_I_SB(inode);
 
 	unsigned int nr_pages = readahead_count(rac);
-	bool sync = (nr_pages <= sbi->ctx.max_sync_decompress_pages);
+	bool sync = (sbi->readahead_sync_decompress &&
+			nr_pages <= sbi->ctx.max_sync_decompress_pages);
 	struct z_erofs_decompress_frontend f = DECOMPRESS_FRONTEND_INIT(inode);
 	struct page *page, *head = NULL;
 	LIST_HEAD(pagepool);
-- 
2.25.1

