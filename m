Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF01606A31C
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Nov 2026 12:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=YAigSQ8S
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jZwCZ4yn3z2yQG;
	Thu, 26 Nov 2026 23:02:34 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::32f"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795694554;
	cv=none; b=S9GCAJfEi968iQ9F3dPT27hycf+eh4jVRCLaCOiG/rfHCfvMzuWkmS/ik/y8QvdQtkz+B280aaS7nuqqSlFnObKgmBxoBooEDLtDTjPnKBsa08lDGk4paU14RrMv9DQ1KUZbbcPta6rDdii/kg82zBp0t7XBGJKbPo76c63rvIaszs8O7CJmoEIAjydo2ILe9FYPGLCmN+XPknPJ4GevcTeWlaP143cSmNalBSLbuAkPPADMbo7G1VgsK5k74EQhfwiHQr9gQL05auTNQmJkq19jjxPf7G/v8zbkZob0JpaAq2gwoTYio8BnM+Ppb+7RwTha6wEBo0oV42i4EIv93w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795694554; c=relaxed/relaxed;
	bh=I1rOECvkaMqlnSKQdNGyDcT/0wDvx+3ualISvHfZ4qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYGeHIY0UgWTyXy+Nq2H0kImchzrxgxkD1EMrBEgeVOCeoneU01M01XcXvqzAI5dULcwBED/AekgO2V9AOGAzTp8+xAXrrJgXz5cQ3rau8SZwp16BtdoQvRrhysVyM8D1iXbIZ8TQ1NCDLEm9TJebRYHagJ5+dd6Quw2alGRFEpNTOshIIk0pmmzU5Qu6AWg/ROHGPdqWI5/IdRHLum2lPvTHzFUxzo8oUIucDl4q6NKDslSKBJCzpxlzDe3J1W3ZwijRSl2XDTAboOkRvgnHlCqMOEzFmSFbA6lAnM0uo5WKjH1fImLMs/jxIVyCB94On3FiVikSiqN04pEAAZYQg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=YAigSQ8S; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::32f; helo=mail-wm1-x32f.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=YAigSQ8S;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::32f; helo=mail-wm1-x32f.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jZwCY66fnz2yLY
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 23:02:33 +1100 (AEDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so89278765e9.1
        for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 04:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1795694550; x=1796299350; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I1rOECvkaMqlnSKQdNGyDcT/0wDvx+3ualISvHfZ4qQ=;
        b=YAigSQ8SouoLGfj+Xi1j8cs4HfqHUTTjuNNiHPC9FVkVbFqT8vd4bE0jR5jp2LCBr6
         6IyuxFSficHC/z4f7QtsfTtQJFaXBeFglhutfhQzrhDkhGTUo5kzZcUKacl51ovKBxQh
         NGd+OgM0xRaLF2Fo79XfimCqmcQy2YhuAL5XTJCmaRKbZXAyTPuADwG06S1ZcQgSyfeJ
         vMgFGwx7ENMu24ETnry+hk6hPnEiXhsAka+cIPY1C2XIX780xUKRPQZkPqHAuld6WyRc
         eeYPUHn1lind1aTAfgeNfHLuCe7qKKjjP5I5RtJp2XdnX+a56KiEzQeZDfhPstY57vHM
         IMgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795694550; x=1796299350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=I1rOECvkaMqlnSKQdNGyDcT/0wDvx+3ualISvHfZ4qQ=;
        b=zfh1hrEUtNsoRPcZK83QapzdJDJy5vTfdZvitqTA2It8qP0VBhURAaFLnQln5GBu9S
         B46MQ/uFzop2sAcWs69u+/CM1+q0OgbHwQz2ukY0YjMhnIHurlQONHEX07nu9SYDQKdc
         GCShURhgQb9VVKvu0j4hdBuMY3WqDKKk4dl41S9vdtYF7vqjWrZX6DXjK9I1WnM3AahV
         okPDYZCqNxObO46D6k7OS4X0sEMZfTpDqHJ6tqc3PjYPobS9XFHmbnD28Ogrr8RDHm16
         /sfoQ8NUz7vQ8U7k6gmNEe6qsfyF4IZ8mahlYKAS5RiGhi8zNViZpPPpjka+g4IrA5b2
         V22w==
X-Gm-Message-State: APuU4Z8ccGEHFTVh7+8Em2sN0WiJUvMAYY3jcPVOFYVgnhsXiuaRQwoF
	GlKJupBM/aCkcfFFNn1ZY1yCDaGOne/pQ9DMLxTpW53hp5hphvEl0lUOO00sNNXU3w1QtQ0hsQ0
	LAV4mxmw=
X-Gm-Gg: AZFdTZemK9IAZAKAzwa8HZyrldQIXZE9FDbFpceY9rADZepdJGugiNN+PiqbZay/J0+
	N5lp5+0oxILQrko6gTaxNG0Et9dneGCHu97zI6rXearlVFo6xDQZQbeWMBFpAk0AzE0T02wYKcZ
	WJhdVvHibY4EMGnDWhjcZNnggD0EvTpaeLPKbYZaA5EfLRp09QWODXgb0PQWa61rsYXeS7eMfai
	TfSF67R78IZcjc/e0xXhrDxsErP99G/z+6OsQ6H9YwQqCdZM68GRC1sqlTvxfcMzKkyRPbaz04k
	6B2ijA0Asj/5xbV/gpScNhIY70OE4rSk/eesJq8wW/c10+6wbPHraNit+OVgeMT3rSyx5olHdn6
	qCuw60fKZSmMfBaTyVkOE05gBN6EIqbQ6Llg88Wg9cE4artTJCN6+fgbaFr+d2EiBhP4fQYZOnx
	C6r1We8pCjrMzGLwA4kX6NCuxrkefI2/crWrQoj32ysMAOwmXlc7aBh+HqWQK80Q6dguDDWPJcs
	+GXK3v6tMxzOOP1yAQEDvSklO2KDuXFrvaKCWNXLF5QAxdm9NCIrkpP2ILzBKe0lzADqFK8kUGy
	h2vIO+N4fxNPc2mqSKFLPW9A7quY17kIOeGjyqAuGRndDPWpYwm8l/IHe/b/hz0u/XjT
X-Received: by 2002:a05:600c:5303:b0:4ba:4928:8aec with SMTP id 5b1f17b1804b1-4bb88807d7cmr395525245e9.9.1795694550423;
        Thu, 26 Nov 2026 04:02:30 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:6060:1d3a:5489:cf84])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b7515sm819402455e9.13.2026.11.26.04.02.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Nov 2026 04:02:30 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v3 05/10] erofs-utils: lib: preserve device table if initialization fails
Date: Thu, 26 Nov 2026 13:02:16 +0100
Message-ID: <20261126120221.4384-5-xiang.gao@docker.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261126120221.4384-1-xiang.gao@docker.com>
References: <20261126120221.4384-1-xiang.gao@docker.com>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

erofs_mkfs_init_devices() overwrites sbi->devs before allocating the
device-table buffer.  If either allocation fails, the existing device
array is lost.  The offset overflow path has the same problem.

Keep the new array local until initialization succeeds and free only
that array on failure.

Assisted-by: Codex:gpt-6.1-sol
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 lib/super.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/super.c b/lib/super.c
index 920d572..60b5b51 100644
--- a/lib/super.c
+++ b/lib/super.c
@@ -390,21 +390,21 @@ int erofs_superblock_csum_verify(struct erofs_sb_info *sbi)
 
 int erofs_mkfs_init_devices(struct erofs_sb_info *sbi, unsigned int devices)
 {
+	struct erofs_device_info *devs;
 	struct erofs_buffer_head *bh;
 	erofs_off_t slotoff;
 
 	if (!devices)
 		return 0;
 
-	sbi->devs = calloc(devices, sizeof(sbi->devs[0]));
-	if (!sbi->devs)
+	devs = calloc(devices, sizeof(devs[0]));
+	if (!devs)
 		return -ENOMEM;
 
 	bh = erofs_balloc(sbi->bmgr, DEVT,
 			  sizeof(struct erofs_deviceslot) * devices, 0);
 	if (IS_ERR(bh)) {
-		free(sbi->devs);
-		sbi->devs = NULL;
+		free(devs);
 		return PTR_ERR(bh);
 	}
 	erofs_mapbh(NULL, bh->block);
@@ -412,8 +412,7 @@ int erofs_mkfs_init_devices(struct erofs_sb_info *sbi, unsigned int devices)
 	/* the on-disk devt_slotoff is a 16-bit index */
 	if (slotoff > UINT16_MAX) {
 		erofs_bdrop(bh, true);
-		free(sbi->devs);
-		sbi->devs = NULL;
+		free(devs);
 		return -EOVERFLOW;
 	}
 	bh->op = &erofs_skip_write_bhops;
@@ -421,6 +420,7 @@ int erofs_mkfs_init_devices(struct erofs_sb_info *sbi, unsigned int devices)
 	sbi->devt_slotoff = slotoff;
 	sbi->extra_devices = devices;
 	erofs_sb_set_device_table(sbi);
+	sbi->devs = devs;
 	return 0;
 }
 
-- 
2.54.0 (Apple Git-157)


