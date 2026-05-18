Return-Path: <linux-erofs+bounces-3418-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9722CD343F
	for <linux-erofs@archiver.kernel.org>; Mon, 18 May 2026 05:58:19 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gJnCc02MZz3dRs;
	Mon, 18 May 2026 15:58:04 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=185.125.188.120
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1779083883;
	cv=none; b=Ls8Ti3oOKh3DAkuZeJyeVAyTCtk+X4ScmVuQQb3dC82IIqLKsrXRRV732rwuVF5kouNXA4Ikdp+2xghmbgnC3WPR4CtHydrxbY2cQHydEaX9fvGPLlbnr0r511pAepsVPJ3aJzwzRt1US7CKRDqTpnds6WZNZhOggyeJHVVzy4RKCN1NCEZcb44Vu46FpesC6MRzS+qdpr5t9Q/Iyau6h1zdTNZc26mVE4WBtiYF4J3yYT9NTC+kZnngPBjzEKfzHOUsoL57ykp/NvgfI/XVeZytaRx09mVqrPjS0MRDzdT8Khud+dXLyhkix2T5UXo7mwWG7hNS29kwejeTqPkldw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1779083883; c=relaxed/relaxed;
	bh=stgAR1NEBbGyaaiZGEXq86e5OVsrFCqAzFqL+sq8lb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGaBKQhEecTrKtPZ+9Y9krRFqvqvMAqUxUtcSidzGF3pG+OIhLt/vhDu8XY921ROjEdRzCPLglYdoT5I8bKoKLInhItDgoPszyLmbZAgOsjs4Y7KxpaXJerR3H5l8PL20gjaEn8sw7gTbETFF9GCaNq1NyBPrH3b8dmkr7eIrXgQ3DyCEosq5qbN8i+fBKhSEkyVDaD9yd7BjIvl/itwuTSLUutyzw6jEvidaISPlOF4EF0joltMAEZ5oiTpFUVXzoEsQTACEL/vY9Ig7NyNrNXGnkRxNfOHxipM+gLATak9aAb6yqZfwo2D1lamGb94S9RHMPp9mXOC2ptSEKNsFw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=Q/Vcf/YJ; dkim-atps=neutral; spf=pass (client-ip=185.125.188.120; helo=smtp-relay-canonical-0.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org) smtp.mailfrom=canonical.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=Q/Vcf/YJ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=canonical.com (client-ip=185.125.188.120; helo=smtp-relay-canonical-0.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org)
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gJnCb0pG8z3dSG
	for <linux-erofs@lists.ozlabs.org>; Mon, 18 May 2026 15:58:03 +1000 (AEST)
Received: from LT03 (dynamic-046-114-109-175.46.114.pool.telefonica.de [46.114.109.175])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 3DA0641794;
	Mon, 18 May 2026 05:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1779083874;
	bh=stgAR1NEBbGyaaiZGEXq86e5OVsrFCqAzFqL+sq8lb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=Q/Vcf/YJ9AV51SULH5PnLu3nSIijB0mcn836R22iDdjpT8Hw9dnYkJpf/6yAIHzK2
	 5KGzt48dfMCGY1IgM0hBzVO/Z7/ZiuzMu6Gih5PBIRreGpxoejC8Aq5CL1881pxUVr
	 OrNb0awef/ZkBa71AkPb4wTK6dm4tGHo7kWJT0y7JMRxoAYs9jRTvgN8Up0k5dT/6d
	 KGYChjwTBIkzjCwQIQR6ci+7soojFvTkBR1rgih4TjhclC/JAMEoYE8Ssuf6zM/6BI
	 /53aKK9VryODmMdTg6Ki1xfQtTDi/4UG8ivvKM0G/+gy5QtRB+4HHT4FG97eeOaPpy
	 momZW8B0SMOtqOZ6lyIeb9TDhHwDZR2EJcS2Ibw8zm6gY8PlBXjgdNY+x5B+3TPLj/
	 cQ0q5LRvkA7zMtdhnFeY2pyuY4k18pW1xiyMkpmYJ2xwHxyAP5R9J5ejLh8fY/C1fy
	 X5IaeRu6b2olINsHSWOUBcLJNjVHENLtQE6i+fTz8GG2OnGXJn62MaeLPMScwefEom
	 PMcDvmq2c8FWiW9xLsSU0AUvDwLouXF5TYDN7HXPVZFkXjvB7F3W+kjilHq8atCRZc
	 utrqdXocNzREq6ndztMb2y0bFx0ieDS7oVKNZDY72bTc9HikLMICUEIXaqT1Hqcodn
	 xLTKcHIdyHxHkxeTinCQkEyc=
From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
To: Tom Rini <trini@konsulko.com>
Cc: Simon Glass <sjg@chromium.org>,
	Huang Jianan <jnhuang95@gmail.com>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Tony Dinh <mibodhi@gmail.com>,
	=?UTF-8?q?Timo=20tp=20Prei=C3=9Fl?= <t.preissl@proton.me>,
	Francois Berder <fberder@outlook.fr>,
	Andrew Goodbody <andrew.goodbody@linaro.org>,
	Daniel Palmer <daniel@thingy.jp>,
	Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>,
	Sughosh Ganu <sughosh.ganu@arm.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Peng Fan <peng.fan@nxp.com>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	u-boot@lists.denx.de,
	linux-erofs@lists.ozlabs.org,
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Subject: [PATCH 5/9] fs: ext4: set inode timestamps on write
Date: Mon, 18 May 2026 07:57:24 +0200
Message-ID: <20260518055728.178507-6-heinrich.schuchardt@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260518055728.178507-1-heinrich.schuchardt@canonical.com>
References: <20260518055728.178507-1-heinrich.schuchardt@canonical.com>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the hardcoded zero timestamp in ext4fs_write() with the actual
current time obtained from the RTC when CONFIG_DM_RTC is enabled.

Per the ext2/3/4 specification (ext2 design document, section 4.2):
  i_mtime  last data modification time
  i_ctime  last inode change time (the 'c' stands for 'change', not
           'create'; this is not a creation timestamp)
  i_atime  last access time

All three fields are set to the same value since writing data modifies
both the file content (mtime) and the inode metadata (ctime), and any
write also constitutes an access (atime).  If no RTC is available, the
timestamp falls back to 2000-01-01 00:00:00 UTC, matching the FAT
write driver behaviour.

The ext4 i_crtime field (true file creation time, added in ext4) is
stored in the extra inode area beyond the base 128-byte inode and is
not modelled by struct ext2_inode, so it cannot be set here.

Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
---
 fs/ext4/ext4_write.c | 41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4_write.c b/fs/ext4/ext4_write.c
index 1abedcede72..c8a1ca63605 100644
--- a/fs/ext4/ext4_write.c
+++ b/fs/ext4/ext4_write.c
@@ -21,14 +21,47 @@
  */
 
 #include <blk.h>
+#include <dm/uclass.h>
 #include <log.h>
 #include <malloc.h>
 #include <memalign.h>
 #include <part.h>
+#include <rtc.h>
 #include <linux/stat.h>
 #include <div64.h>
 #include "ext4_common.h"
 
+/**
+ * define EXT4_TIMESTAMP_Y2K - 2000-01-01 00:00:00 UTC as a POSIX timestamp
+ *
+ * Used as a fallback timestamp when no RTC is available.
+ */
+#define EXT4_TIMESTAMP_Y2K	946684800
+
+/**
+ * ext4_current_timestamp() - get current time as a POSIX timestamp
+ *
+ * Returns the current time as seconds since the Unix epoch.
+ * Falls back to 2000-01-01 00:00:00 UTC if the RTC is unavailable,
+ * matching the behaviour of the FAT write driver.
+ */
+static time_t ext4_current_timestamp(void)
+{
+	if (CONFIG_IS_ENABLED(DM_RTC)) {
+		struct udevice *dev;
+		struct rtc_time tm;
+
+		uclass_first_device(UCLASS_RTC, &dev);
+		if (!dev)
+			goto fallback;
+		if (dm_rtc_get(dev, &tm))
+			goto fallback;
+		return rtc_mktime(&tm);
+	}
+fallback:
+	return EXT4_TIMESTAMP_Y2K;
+}
+
 static inline void ext4fs_sb_free_inodes_inc(struct ext2_sblock *sb)
 {
 	sb->free_inodes = cpu_to_le32(le32_to_cpu(sb->free_inodes) + 1);
@@ -854,7 +887,7 @@ int ext4fs_write(const char *fname, const char *buffer,
 	unsigned char *inode_buffer = NULL;
 	int parent_inodeno;
 	int inodeno;
-	time_t timestamp = 0;
+	time_t timestamp = ext4_current_timestamp();
 
 	uint64_t bytes_reqd_for_file;
 	unsigned int blks_reqd_for_file;
@@ -979,7 +1012,11 @@ int ext4fs_write(const char *fname, const char *buffer,
 	}
 	if (existing_file_inode)
 		free(existing_file_inode);
-	/* ToDo: Update correct time */
+	/*
+	 * Note: ext4 i_crtime (true creation time) lives in the extended
+	 * inode area beyond the base 128-byte inode and is not modelled
+	 * by struct ext2_inode, so it cannot be set here.
+	 */
 	file_inode->mtime = cpu_to_le32(timestamp);
 	file_inode->atime = cpu_to_le32(timestamp);
 	file_inode->ctime = cpu_to_le32(timestamp);
-- 
2.53.0


