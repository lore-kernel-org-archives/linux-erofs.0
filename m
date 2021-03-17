Return-Path: <SRS0=MNjO=IP=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 332B6C433E0
	for <linux-erofs@archiver.kernel.org>; Wed, 17 Mar 2021 03:55:18 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 65DB664F8F
	for <linux-erofs@archiver.kernel.org>; Wed, 17 Mar 2021 03:55:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 65DB664F8F
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4F0bsH738Sz2yRG
	for <linux-erofs@archiver.kernel.org>; Wed, 17 Mar 2021 14:55:15 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1615953316;
	bh=kqJO4Q4kN+3f6aD0Mwlm0t9x4Q5R34lVR01It6hUvX4=;
	h=To:Subject:Date:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=ov/Zx7H71/y5xKqL2eahUDj0ILchQjAfg9UxxjtZqNodLRFsLzLAxrb1DPGX8pPA0
	 7F4RsjaIGzrEDJ+et8VR3ouDX17kIqThdrFJKluzq9uVGmmI+PyTU8y/EGmHXsCyUQ
	 eh+Wv1nuMtnVj7rcxwd8BlWC6aWb7GIfRVD/1nxawqNSHZkB/mGF0B4bWdC7lW4Jku
	 T6Yp/i7s1JbRCGdf0xPRYs6MWyw0JqjY0tPShGLLup1U9kYMphpkZrWOQTE7TO2h6A
	 +95z1ZYn97gh5B+hcKFF+2o78h7LOyUSdSndFcGSuglsyhf2oUCA53ZavBpBpFwo3F
	 +IIW+/96ssgBg==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=oppo.com (client-ip=40.107.131.54;
 helo=apc01-sg2-obe.outbound.protection.outlook.com;
 envelope-from=huangjianan@oppo.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=oppo.com header.i=@oppo.com header.a=rsa-sha256
 header.s=selector1 header.b=VMI2UmTw; 
 dkim-atps=neutral
Received: from APC01-SG2-obe.outbound.protection.outlook.com
 (mail-eopbgr1310054.outbound.protection.outlook.com [40.107.131.54])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4F0bsF6MqBz2xZv
 for <linux-erofs@lists.ozlabs.org>; Wed, 17 Mar 2021 14:55:13 +1100 (AEDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h2xSh0G1i4r6HEGyzdP0bt95vTqqzB1vviay9SLgEiA/OWHj2RHMU9X1J/HtT73C50Cl1K2ih0qG3EH1aCj9rR8AWTr/QonvdQhWrL5ROYVcAOahaPXnQSg0ABbw3J4SrW2EmmNvmEu/1Gasd1+UAyvnJofoKbl0iYWPAcvXPRzybiDQkKIxaR3o7kjBgWK6chBzV5kGBZ2R25aS1ODHmj3DybdQPtwY1efQcxYmX9IPgriLBa74RpcSfPUI2XKhfArnreTpsic9k1pDA+k6e82Znp9j3fCNZfdh84h2A/u+paY1vV06IdY4jwpjSiq7Q8o1jJMS5XvrMrhvMxvHag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kqJO4Q4kN+3f6aD0Mwlm0t9x4Q5R34lVR01It6hUvX4=;
 b=icx8w3KtRYCZsUZ1OMh4Z3DZktCTTPACdh48EwknAsoJSKYPP9McJpItu5lAV0BKpguAxCOzG1cM1NeMUcYwjBfZ4FVleC3lKLNp8zgCosSlyTeY6Hf5R1oIPP2kRosf3XGMfNAl403Z1BfQ7pPfaRUH2xyypaE/Xein0Lzk/7ZDz/h8lyD1OBEw8nCxxippknsul+hD9oodDyjPSQYnIVhZe1UKMHKapqrw/my8LHTgt2ibYvp2h7Yv6LHgws+QW/iTKr8U108CmYUOZYuNqyaiRkFsE+TKdcTxzg7py6OxeFL0hKvJMSwTKlaUEbwaHt28o3Oq432KlU5pPnunQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
Authentication-Results: lists.ozlabs.org; dkim=none (message not signed)
 header.d=none;lists.ozlabs.org; dmarc=none action=none header.from=oppo.com;
Received: from SG2PR02MB4108.apcprd02.prod.outlook.com (2603:1096:4:96::19) by
 SG2PR02MB2986.apcprd02.prod.outlook.com (2603:1096:4:5e::14) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.31; Wed, 17 Mar 2021 03:54:59 +0000
Received: from SG2PR02MB4108.apcprd02.prod.outlook.com
 ([fe80::1143:a7b7:6bd4:83b3]) by SG2PR02MB4108.apcprd02.prod.outlook.com
 ([fe80::1143:a7b7:6bd4:83b3%7]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 03:54:59 +0000
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH 0/2] erofs: decompress in endio if possible
Date: Wed, 17 Mar 2021 11:54:46 +0800
Message-Id: <20210317035448.13921-1-huangjianan@oppo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [58.255.79.104]
X-ClientProxiedBy: HK2PR02CA0132.apcprd02.prod.outlook.com
 (2603:1096:202:16::16) To SG2PR02MB4108.apcprd02.prod.outlook.com
 (2603:1096:4:96::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (58.255.79.104) by
 HK2PR02CA0132.apcprd02.prod.outlook.com (2603:1096:202:16::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 03:54:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b85a7000-c493-4a31-37df-08d8e8f86f92
X-MS-TrafficTypeDiagnostic: SG2PR02MB2986:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SG2PR02MB2986F6F59F5824F77AE933F8C36A9@SG2PR02MB2986.apcprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5o8breVFlmcSc0BcfDLGvwrRUF5xgPa1z4bwFDPWT3TzcNWgdqJk8gKePl5qjfqFIlthTO/ROErqzFPZqZY5aj1GS1LYXAzb7rgk+TkbP35ATpb97HL1R06OLAqKevEPSK0SseheZtMfOX/y3jO5QiK4/Qwyni0TX4++uX8TRKHM7gApQsv7VaVqGjEmDlOiOr5NDX9Kp9aVWY4gA9YZSMhWOADUlb8gu0SOYy0FZ+gHjPEj037qOkgqnSjYTtqSz0HnFijv5vyVdrBfUYTfxjUrL5zUgxeW1nrVqSFmho6Q903vwmFz93nb24tFSyoGVEHMACXJ9vZU7zpnhSC87h4hRD/QbAP1RLteFabjuZp0z5kD62wS8oHx2Jl2t05F6ZaqEI7baAEaazZgT6VVbsPq31EcsS1p7c8176R9lOXJx2jgH5TxfuZaMKecx+aLkNJGGA6z6AT8j0qcppgPNOLxCJ434rNdCb55JSBZIK56zACBHG/mt+FPZYPrp3ypNYmt+T/u9dWYHNOhImEsgQ1fM6kG3sKU3kQF4txd2EHIl3XoZ2OmkustDWABQ+h1+pwUAyB2SDk9gi5ZG0vmG8jf0M6gjTyvnbZTNW8dEq6l+4oH9OiUMNr9c/ljBTvkAE5hhz8shdC6midNGaEIrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SG2PR02MB4108.apcprd02.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(4636009)(376002)(136003)(39860400002)(346002)(366004)(396003)(4744005)(478600001)(6506007)(186003)(6512007)(2906002)(6666004)(26005)(956004)(6486002)(83380400001)(8936002)(4326008)(16526019)(1076003)(316002)(66946007)(66476007)(6916009)(69590400012)(36756003)(66556008)(86362001)(5660300002)(8676002)(52116002)(2616005)(11606007);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JmwJ/5iZtmLw/9fRlqXIn8Lf8NPwrCH0NSP4FUlM/x8zA/DagSe8UqYuakhV?=
 =?us-ascii?Q?I5sw9ycGZEocXN4peAJFylGQV+tkOeYynhJbm8ugGQQhqvNdBREibd/i9pss?=
 =?us-ascii?Q?jwZzugrSqzq68yohlhFZUUnjgCJFWUyrqq/DDffurNBqi0R0MM40XaiScEJt?=
 =?us-ascii?Q?K1NQX4SxzwNzbp49LDfS9zYAz72LryV1wkqYbiQNSv14xKqP8PGUBhwv9CcM?=
 =?us-ascii?Q?6FD4rvMqLD3edZma4zFDEOG+GFkvc+VD88A48WpvLSwBwnCoF+uJ260DR0Nw?=
 =?us-ascii?Q?cLoLQmlHhT5KsmVh3sO9+ApC+acHXwQYvQqqfxR3F8M+Qqv8Z+6akSnaOZgC?=
 =?us-ascii?Q?Ne9K8APoeYg7bQSnDHBjuJnrq6Qiaf4mE6o3qZg3zlS8A9xLsKY0Cf/SJg7s?=
 =?us-ascii?Q?FOx2p2qQikzVBXYvCjfkJMDIKbvSmzagvgKKFRG/VtvggpQrRnXf80GALyJn?=
 =?us-ascii?Q?+lHmzcgtmmlcXyP4kbkPTMnwJZ2UWBNLuJLLsAVBZLH5ONGEuBzyth76k3O3?=
 =?us-ascii?Q?18rZHB6MruL2aZlygj/KXZGRLb6/hBaSH3voTvysv+CK+u7KOREIix6RAh3T?=
 =?us-ascii?Q?2Y+gXJOdBasqEcsBJo6Qyngo2MT+zInF4rE8WQ18lynmxSZs1dF0cRv1mhON?=
 =?us-ascii?Q?hYjTUzXqfFh6JVV207wtnDQyv+2XOYpWgZiIazRqzWIMJ+GmoZCLiQ/aUp3/?=
 =?us-ascii?Q?YvPpDXpUh/MIXpoYHst3jyCvsRueu4UB0hG/pTlfiPa+RyE/WKHqJhvTtmAj?=
 =?us-ascii?Q?ZiUD47ES310uuz7nQB3G/vf6wLi4qxhdWGJIPJJJdFroloLez+tY5XB9Tq4t?=
 =?us-ascii?Q?rOM7njqKPCLXYZxg0GAsUxe6okomvMHXvmowhrmA4OJl+WPwohgLilaf31YY?=
 =?us-ascii?Q?Ac2ZrrMispN1tOyAbjpGFYsYc3F2BPy8vfW4F9kpmSka89nn1fxjoQiCKwSp?=
 =?us-ascii?Q?bO8Z5/t76L5kZpjq6jQBRejPfsaPLcM1KF/u8suoMiGuNBxydXSkBetrI7OK?=
 =?us-ascii?Q?1mYEtd7Q1Rx2J5bY89f0PQHMMncBOYw/wUcIIwHxVwxbTp3M4s1+plHAhhFK?=
 =?us-ascii?Q?WxOeQqaP89i7kBG3F3SPETeDhnZ65YKg99Pea1ygskmPVnp1D0653Q6is+5R?=
 =?us-ascii?Q?J25J/RxRs0pXwTkYA4jiatqf3/fiLO0YJpCNXFxEGqZfAj0fPkMudl6eb2q9?=
 =?us-ascii?Q?Jkb9E870RKwR22Djc3Td4A1hm3DzKl1aXqdQRKlWoiOC+hM3uSG+8RVsteIp?=
 =?us-ascii?Q?SOCZ56xZ6ZZibvDendc572abjtVmKWwKeJMMK409tCNfEsBAwp4f6S+mnQiM?=
 =?us-ascii?Q?YtYjLdbxvDTZqhXu4sinSxN1?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b85a7000-c493-4a31-37df-08d8e8f86f92
X-MS-Exchange-CrossTenant-AuthSource: SG2PR02MB4108.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 03:54:59.6840 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d7YMXt17tds136gt5ClYDogt9geIuxqrDBEylSvnHeXMWtvdVjuuCpS3r0Dt7AspuwBSz0GH5T7Gl8whaYkkNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR02MB2986
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

This patch set was separated form erofs: decompress in endio if possible
since it does these things:
- combine dm-verity and erofs workqueue
- change policy of decompression in context of thread 

Huang Jianan (2):
  erofs: use workqueue decompression for atomic contexts only
  erofs: use sync decompression for atomic contexts only

 fs/erofs/internal.h |  2 ++
 fs/erofs/super.c    |  1 +
 fs/erofs/zdata.c    | 15 +++++++++++++--
 3 files changed, 16 insertions(+), 2 deletions(-)

-- 
2.25.1

