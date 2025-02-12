Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCFC7C02198
	for <linux-erofs@archiver.kernel.org>; Wed, 12 Feb 2025 19:16:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4YtSht6Bzdz3bnK
	for <linux-erofs@archiver.kernel.org>; Thu, 13 Feb 2025 06:16:14 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=47.90.199.11
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1739387772;
	cv=none; b=niJptLOuVyZOgp8rhB1nJMiU1Om69SMRWCWLc6J0NHY49Wk+jvqZs62mpfmeuQv243b2JFVgQ413+m/K30RhVpv5RSyqcnNhgS+u8dQH/q1rySVoWTbM7xo224LgKPqekDxSmhlm0EzQGaKnTBNeuqKE4FaIROl7yFRLMiloT3C5r4Zcp/Hb97YVGD9eQgJZxjRQ0IQkiY50ToI7nj1bmrFueRVMhIGJqQKcJKzmIY9OR97L1rjwtj2aVJggAOjxbrPJRRfgDQ35kPn/sJfGDIy/+xt9HHebrbolFAQqN9FraMOvlMs+Z4V4CnVcfUVcxRwbW0fBtxePInn8evJfzg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1739387772; c=relaxed/relaxed;
	bh=kFQJI6u47HQWfpZWMqBgzAxqvzzo88hw7u4+p7TMHTM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QLbxnLxtIYAEEURCCziNqAEYwA5RwgDVNeQCYavVOB4Xj4LAjx6HLx06TvkjVzdmEzJx36FJteRRRAvkdPD0aes+7CFN7TsSWsgD8V/fbkKqgTjmcaBmcA7cKy607kbVI99LLw3UPLVBu9WUT1kHqOpgoNR9u/eUDIH7Lf//1SFY0pPU8g91S7jDfhjIUTsK6t54OeN8GKLXeS9CzaU+DYceM1rZ9NI83excbT0jEm7Jubeq4PNMM2pE+ktFRgELvCMKvVT5G4wpd1tOW1fiiuJXSg6KfS9s0Xt8mZpByB4lPCvwAM7tiDC2f5j/pQfh0D63prxqFjv4vaTS6ePhUQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=THbY8cPn; dkim-atps=neutral; spf=pass (client-ip=47.90.199.11; helo=out199-11.us.a.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=THbY8cPn;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=47.90.199.11; helo=out199-11.us.a.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out199-11.us.a.mail.aliyun.com (out199-11.us.a.mail.aliyun.com [47.90.199.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4YtShp1xK5z30TM
	for <linux-erofs@lists.ozlabs.org>; Thu, 13 Feb 2025 06:16:08 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1739387752; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=kFQJI6u47HQWfpZWMqBgzAxqvzzo88hw7u4+p7TMHTM=;
	b=THbY8cPnL3jYoVrFEaP2d7nhPqOdJnXvxYmo3XR8oZeWhA3cs+Sx0JyXQSEFEY58zwQ+Bzjjx8Cb0ZQMuhAE+hvneY1XtfQCFjvmXEZuk6BKzWTUa9Db5cDEVQFnLQ6gtKZhuSz+EEFRQp/WFoQf3Jy7rc0Rf1PhX7rsbI7JYQU=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WPL-1b0_1739387746 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 13 Feb 2025 03:15:51 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: mkfs: reduce default dict size for LZMA
Date: Thu, 13 Feb 2025 03:15:45 +0800
Message-ID: <20250212191545.580768-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
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
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Change the default dictionary size to 4 times the pcluster size.
This will halve the LZMA internal dictionary size to a maximum of
4MiB per LZMA worker (one worker per CPU in the kernel implementation
unless the module parameter `lzma_streams=` is given.)

It has a very slight impact on the final image sizes, yet users can
always use `-zlzma,dictsize=` to specify a custom value.

  _________________________________________________________________________
 |______ Testset _____|_______ Vanilla _________|_________ After __________| Command Line
 |  CoreOS            |   741978112 (708 MiB)   |   742293504 (708 MiB)    | -zlzma,6 -Eall-fragments,fragdedupe=inode -C8192
 |                    |   687501312 (656 MiB)   |   687652864 (656 MiB)    | -zlzma,6 -Eall-fragments,fragdedupe=inode -C131072
 |____________________|__ 658485248 (628 MiB) __|__ 658698240 (629 MiB)  __| -zlzma,6 -Eall-fragments,fragdedupe=inode -C1048576
 |  Fedora KIWI       |  2974957568 (2838 MiB)  |  2977394688 (2840 MiB)   | -zlzma,6 -Eall-fragments,fragdedupe=inode -C8192
 |                    |  2684272640 (2560 MiB)  |  2686750720 (2563 MiB)   | -zlzma,6 -Eall-fragments,fragdedupe=inode -C131072
 |____________________|_ 2550800384 (2433 MiB) _|_ 2553278464 (2435 MiB) __| -zlzma,6 -Eall-fragments,fragdedupe=inode -C1048576
 |  AOSP system       |   432562176 (413 MiB)   |   432738304 (413 MiB)    | -zlzma,6 -Eall-fragments,fragdedupe=inode -C8192
 |  partition         |   393277440 (376 MiB)   |   393351168 (376 MiB)    | -zlzma,6 -Eall-fragments,fragdedupe=inode -C131072
 |____________________|__ 379260928 (362 MiB) __|__ 379285504 (362 MiB)  __| -zlzma,6 -Eall-fragments,fragdedupe=inode -C1048576

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/compressor_liblzma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/compressor_liblzma.c b/lib/compressor_liblzma.c
index d609a28..c4ba585 100644
--- a/lib/compressor_liblzma.c
+++ b/lib/compressor_liblzma.c
@@ -75,7 +75,7 @@ static int erofs_compressor_liblzma_setdictsize(struct erofs_compress *c,
 			dict_size = erofs_compressor_lzma.default_dictsize;
 		} else {
 			dict_size = min_t(u32, Z_EROFS_LZMA_MAX_DICT_SIZE,
-					  cfg.c_mkfs_pclustersize_max << 3);
+					  cfg.c_mkfs_pclustersize_max << 2);
 			if (dict_size < 32768)
 				dict_size = 32768;
 		}
-- 
2.43.5

