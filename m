Return-Path: <linux-erofs+bounces-4701-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C71FBCA9EDC
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2026 14:01:29 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3JzS0f03z30Wh;
	Tue, 13 Oct 2026 01:01:24 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=185.125.188.122
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791813684;
	cv=none; b=lK0+mj7qIgZKxagke/Oq6/RW+hED4AA6oDbt+f18R+UM0hb7LGBleCGtGaPp2+K+/JsFy1T5jpk2f/qeXzo1NBQUI1w50UPD0oV1qlw/TVlt06aHxGBPh0lDQfYqxxwUEw3SDq9a5fa5tsEwUp9Ry11s5LRPxiXjWSgiQYhlC7PT70amB+8sWjDdK/vZ4yt6KBTT6M+C3kZqaJUH8y0ecrPJKEc2Yb4w1uatVx2ikXV3pQtZx+MLj2yrvpmtIUvyKPzTQZ8agbjUR3YwzTPL4itxy+u2aIFGQFcbGZIC2O1p/NJkVaOOJpJzCYVPToPCmbZq8kCu3imNoqlOB4e1fg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791813684; c=relaxed/relaxed;
	bh=MuGF1x1+rJxSRSKdQHzryOc1MO1NkPUrc85yq6h43+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNakHtnC1C5f4rFXZVZQ0gGna6URWIFZSqe08z6BYPDJ3U7Ya+7rcoXn280qsULznj57vLQ3nPWLGiE0Qyl/BMgddN+opmZsCAyZpXQ5/EjsaV2vgWVoq1O635kTfh5NK2jU83OEj2mobrli3XNCKZUO/Ffv+nDgPfPnPTxTxAu9ojZKq9o+/etWzrj4bf3dWt3wmtcuGGq7IvyZX/wXL1+EkrIkmIYJdCV2YITjFW5cvxzF56+z3czS6GuoWbY69hF15Vtxlgu03cHvW+QhKRqWQ1ggXNgIumG02ej0gNpzLRAS0z6+lyzQifxTP+DE3kOVCvD6AKiO3mDq2FtS1w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=TAciNsH2; dkim-atps=neutral; spf=pass (client-ip=185.125.188.122; helo=smtp-relay-internal-0.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org) smtp.mailfrom=canonical.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=TAciNsH2;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=canonical.com (client-ip=185.125.188.122; helo=smtp-relay-internal-0.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3JzR2t3hz30Vs
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 01:01:23 +1100 (AEDT)
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id C55FF3F294
	for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 14:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1791813680;
	bh=MuGF1x1+rJxSRSKdQHzryOc1MO1NkPUrc85yq6h43+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=TAciNsH2hRKxpAdzogGLDguEqogRJcOSF/djbOQcn6ouf8b3pdOZIkuf8hSjkhVu4
	 TS9Nm1PWe35NPnpzSk9bnpDawhH9PNO7+Bfp2gbNDYKLD5+JYp8uSH88n+VASxG9/Y
	 VF5ijRv1kpNzS3BgFFP6Aqvj57RjeFR6IUn5tcpV3W0Y3GhfQM/k3iQOZccY3cWWct
	 6xZqXVl/vLUm1PVgepEoNvcz8mshkHQ+81oK/YpftCqMKkE/uwO/oaqp05iSsWOldz
	 Loo4IvVAeFXo1f6Sk+xSKeSjI9tFrEuYe1xsdiN/ATvqvueVX7cyIG76xSii4fahc9
	 jbnUGjOHJcYzVvO2Rc5Eo7epwqNscsYo9AmI42PqQBqkAW4jAbqv+3OnlDmniIM0fU
	 gzyx96lykhgIKPXZmuTOkA69QYz1PXTm7X9BOeEJgK9XMlRPbFCc3Zea8Aa3otVVhs
	 x/6dgylp3OlNvVT+G5wxwn03Cyf+2ohJ8PrQWFVKDqMMx7i0A2mbnCE8Y1KtYdp9pM
	 I1BKSiZvTtj5fykda/SIar+kk7y3LWD8PmKawBG4NxDc0h+frj7n7mQ9EmRf5K4Yja
	 2Yt3HapamXU4hcf8+Cq5hfENYfJKOAXx70KA2E7pgtIVzr9ZquLEM0j1KyPcrlt7Au
	 NEtMMJGDwcDT3DmpCvyTen8Y=
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a0228f4a1bso10926715e9.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 07:01:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791813680; x=1792418480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MuGF1x1+rJxSRSKdQHzryOc1MO1NkPUrc85yq6h43+4=;
        b=u1QWrp+tIMTBI4nwEMJywnqv1cudP4341j72MFrrVs9jDy0TOZ5WrGQmzJS+Si2HSM
         8VoH4jlIendi6tfE9GRAuiCdbXgCsNTjXCM5/LiNXqEQgAJ5bTfTR5+WMc0H5zUB043z
         F9oCxBC3a5cbn9W3RlptARl+ab8dOsgEAlKu9Fp2MuQJABOrAVepPnjITM++bgrpAG1v
         TwFlpyUz0U2fAM1rrKR6wBc6Jn4MJ24xJNbOe42YGtDgo/b5TT3uXYJcB+n0j9xQc5wd
         huG9T7kdsE5HKd9YCsfP52cnEXOhJzy6HpHz8Zwz65vMjK9SPhqk9/yRkbNIMxDSNo7O
         QUYA==
X-Forwarded-Encrypted: i=1; AKwUvByKm63S1QFBIP/2gAufBe7NlBHtFsI1KUmEgsepogQG5Z+aIFwrDCgtXTRp2ZasO3rFk+6D+5Di1/HHFA==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYIa5fYnRLu5hyJJTbY8djH3Nr4so5py4ajNrEuhB7yxSNzp04Sp
	Dela298il+YPDF6lZbGVNucxClCHmtJbsOV8u9MjvxOj1pwt7R7GFpVD+M2efip1WNYNgNjJkzW
	rvFI8SBWZcloDwDyY14mTed968V7zToN91jo4kh6fbmtYEZfiVdZBQ2GUuVTD/XRxznC6f612vo
	LSVFHM1Q==
X-Gm-Gg: AYBFou3VRpxxhS0pbYGdas8kcEtJXIO0beQyuB9v++WKvhnHH62R8jgBotnZFtSeZh6
	eFabiRpHaMu1rA6Ji1H1xogv80ZSGtiqExAy11HNvBakCD0Ufi6o0Cic23PKRL9SFUz1FmakMHb
	9+hd+ndSeKATquLMrWHsMdD1dedDcVHMZPnN0npzF9+fFd5CCowyUylcmh3K5+FEBvo2ckprZbg
	45y6SSfTmM/oZ6JSomzvM35Nwl3RwbAqwhaIVw4gNmm78U9AO/pg0k9MWyS8C0Zwd+A1As5qDrP
	xT+oxSRzSkyE2Ei/72yuFPAxS8+yjQMOs0nRbmDxwhx6x8o1PiVZcLnSlb8yFSPHD1wz8KE+rYJ
	sFaqZrCQuJGHTSDbGz8T9JTSzi25aSR3Qfxcw+hoZS2mYOAlGHutUVoI=
X-Received: by 2002:a05:600c:1909:b0:4a1:722a:d2a3 with SMTP id 5b1f17b1804b1-4a18e4a3f5amr206746575e9.23.1791813680033;
        Mon, 12 Oct 2026 07:01:20 -0700 (PDT)
X-Received: by 2002:a05:600c:1909:b0:4a1:722a:d2a3 with SMTP id 5b1f17b1804b1-4a18e4a3f5amr206745345e9.23.1791813679233;
        Mon, 12 Oct 2026 07:01:19 -0700 (PDT)
Received: from workstation5 ([2a02:908:1242:30e0:468d:767c:32e6:22fa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf15691sm284551015e9.6.2026.10.12.07.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 07:01:18 -0700 (PDT)
From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
To: Tom Rini <trini@konsulko.com>
Cc: Simon Glass <sjg@chromium.org>,
	Huang Jianan <jnhuang95@gmail.com>,
	Daniel Munic <v-dmunic@microsoft.com>,
	Tony Dinh <mibodhi@gmail.com>,
	Alexey Charkov <alchark@flipper.net>,
	Vincent Jardin <vjardin@free.fr>,
	joaomarcos.costa@bootlin.com,
	Aristo Chen <aristo.chen@canonical.com>,
	u-boot@lists.u-boot-project.org,
	linux-erofs@lists.ozlabs.org,
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Subject: [PATCH 5/9] fs: ext4: set inode timestamps on write
Date: Mon, 12 Oct 2026 16:00:44 +0200
Message-ID: <20261012140048.214059-6-heinrich.schuchardt@canonical.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261012140048.214059-1-heinrich.schuchardt@canonical.com>
References: <20261012140048.214059-1-heinrich.schuchardt@canonical.com>
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
 fs/ext4/ext4_write.c | 45 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4_write.c b/fs/ext4/ext4_write.c
index 2fba2197c19..0531190ddcd 100644
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
@@ -979,7 +1012,15 @@ int ext4fs_write(const char *fname, const char *buffer,
 	}
 	if (existing_file_inode)
 		free(existing_file_inode);
-	/* ToDo: Update correct time */
+	/*
+	 * mtime: last data modification time (ext2/3/4 spec 4.2)
+	 * ctime: last inode change time - NOT creation time despite the name
+	 * atime: last access time - set to now since we are writing data
+	 *
+	 * Note: ext4 i_crtime (true creation time) lives in the extended
+	 * inode area beyond the base 128-byte inode and is not modelled
+	 * by struct ext2_inode, so it cannot be set here.
+	 */
 	file_inode->mtime = cpu_to_le32(timestamp);
 	file_inode->atime = cpu_to_le32(timestamp);
 	file_inode->ctime = cpu_to_le32(timestamp);
-- 
2.55.0


