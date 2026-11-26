Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F26E606A31C
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Nov 2026 12:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=raC4+VMI
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jZwCV75ngz2yMK;
	Thu, 26 Nov 2026 23:02:30 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::335"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795694550;
	cv=none; b=R4gLR9S8neSKbPSQYWRnrRvd6IEKn6mDUtgujqqTXTcDC736oSD+9sS2utGIB6b+73x1IcWt4rVZrR9bSOjvtoBQRFw1eB97F9mJvoqpc0ReapssZXP5zvYljLbeyvFoJa+h2CVyNXEOpDxNRgB5derhegPO22dWBUgSIbGY6p+Jay9TyxzkpgI5fH4kab7Ll/IKjykKD4vJIfI5aiYvnfvR/SVpv4ah9edkRW8sYBG5wAJ28iPeCKdGaFOrIVNiaXyaCO0/qbzNO+if+wx3soPIiMz68izLiDoZdYL3hj8fylHDv2uFyQ7A43wvEr+/lBGcv09pvxXB89/YNl7FoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795694550; c=relaxed/relaxed;
	bh=cXJNGLDak5lG+59bL3VVFAREwJfNpUtoIfRoy1/ycYU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X+4qfxXYCQzj2dtitCRxwPenS9MUuKqQH74jzuhEaW1xkw/ZGz4vKk98nRosCC6rujXi/gJA4PzfZVMh09rJuxkGXx939TxFHecaOyW7b9gFNzcXpK4sYJ7lY7yd/tcoI5Bx8+w7e+DVYLL7UEJ/vtIrmsIv0L0HS/3YFBIoDLk3EhR7XvJ242DfRd0r2HyDyZOYVf44GrFcNyXbYL1j8X5abecCbsA5BpUl0TUKc+d+ogZ/uQ+K30g90t4NfDiSY+K0pgQsfbx4CgBBoj6dbodrfD3kVWEOEC3BqYdQQH6bUpl04YsoY3wpbkAayoVW8pAME7rL9szHgkvPczTtzw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=raC4+VMI; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::335; helo=mail-wm1-x335.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=raC4+VMI;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::335; helo=mail-wm1-x335.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jZwCS6mL4z2yLH
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 23:02:27 +1100 (AEDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-4ba013938d7so65062125e9.2
        for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 04:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1795694544; x=1796299344; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cXJNGLDak5lG+59bL3VVFAREwJfNpUtoIfRoy1/ycYU=;
        b=raC4+VMIAR2jIgFpSODLiTjsyAnYpk1ma4P/SYZVy4wr0Rs1OLuuTBvFPY9ug4UatF
         xQcVx/19Gx8RQ77LTaVyQ3JvDryoiUBJTYlwyWefEoblMqiMPgnt1OypWUadXeAPNiK2
         wpe2r5levYwL1MhcR1haAuTts3W9gttRCWgo4RVQgcHWQSHMGv08y9TgJ1dD/FyT5WDf
         G+aYP36dld4QyROxsDgSTTdb3wEsbXhm5/9pj9+O4+a4hXGYULR1EOTm7Uf+YmZi1zCI
         3rb6JZGVqyM7nU6tjGnycAl3d7kmsS+cyljnswnZhRc++L3dTYubVxIEGQYsikeDglvr
         knZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795694544; x=1796299344;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cXJNGLDak5lG+59bL3VVFAREwJfNpUtoIfRoy1/ycYU=;
        b=HjhwABq1Qu10T8o7dtPdX7Ia9TVN/rXwOMgGgDjRy8m0rr4a1HIv/dm7tbWNLxzANN
         TcXtBODdRs7IBJyLtR2g/1XTQgq6g6ua8ogxMrTZqLCCpW/LKAuy7sbGn/Lxs8Asw0wm
         Ua5ipR/k5Sw+8wSm/7nYmn+W/tBs0NPjUYshc/zdsLtWc6ksms/i0GLlOvZUBKfKWMtv
         s3K3rEyCgUD/PGdunYwLJbv70SONLXClAf+uiuuf2X1JP8qVn0niRB1atnuTIj9473T/
         al/sQ0yXrfaFvwofgI1g4GCZfGUPvva5OMjCMxXzbcnE4PSQrtDBOG0j26ce0Akrw8wk
         rPyA==
X-Gm-Message-State: APuU4Z+ffxTT0Q/DGjRaIV8ZK/xpaYsrWqi8dMVvJM5FEn7EO9yDKBgD
	aULcA+bniQQO0biyQ13ZRFjlVnyuExJGBaG0zElbxEnnjsC9UgbyH/BxGDUjp02xbO7IxREZJuD
	xhg5lnxQ=
X-Gm-Gg: AZFdTZceZK+aj/+E3+ZdnhpuZho6/zIGRp5KRWVQVmPVPW7+55pw3i4QJuvnxMkeeeg
	fuayf7EzNwMzje+4eOh31q5P7fXa774sCXC8qkJZ4qQYO0oaqbCL99gJJ5XppbH9ZMHsaHYeID3
	xejOrUqQ03+EVgsHpgTiBMdssQdOLKOrYTOSn4Rfqyj93ZcvDl/56nwLXqmtFBRB2+Q3yyyctXE
	XI5wxkhryjSBrQ/qk+p+XJc+JG7dSufZwAmUqNh2G2eY8EPTSwKWPXvQnzLv3ymkBXESe2UqLLU
	PLbHGuAfz5tEKLwhnNEOyt4UZzTJdROOQToizQzprO5goygSzXvco4UKb2dpQZAprTlXJyIM8Hx
	v57GHHuj8pMBD8wdIQFeXgMa4vgu9jjrdWmrIm2p5C2z89yjYAeuW4c6tXigrXG5JYPgWN5MlN2
	IiKYZ+yI4PgJPUYwUaYVVl9oFPM3FbIh5k5vJ2jtc4wDoeYcxhsKrx7NDxIkIDjW8zQCos2OQ3W
	gXANsoT5fIx1w95g9Jd5Z4i0slf8LbDe58JkF9ltR8woAubXbYkhtQKEdfxPJ0Ndpf2t7YNNjlT
	uZoQGSHWYIzKfgwpX2HOXNmwNkG+V84jKRBU8Hg3hggrqnI2qwC4f0UNUkLhpCaBuSqy+ievnLE
	7z4r3D+iiYJp2SAo=
X-Received: by 2002:a05:600c:46cc:b0:4bb:69b3:2b42 with SMTP id 5b1f17b1804b1-4bb888277b3mr448258905e9.16.1795694544370;
        Thu, 26 Nov 2026 04:02:24 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:6060:1d3a:5489:cf84])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b7515sm819402455e9.13.2026.11.26.04.02.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Nov 2026 04:02:23 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v3 01/10] erofs-utils: lib: reject incremental builds with external devices
Date: Thu, 26 Nov 2026 13:02:12 +0100
Message-ID: <20261126120221.4384-1-xiang.gao@docker.com>
X-Mailer: git-send-email 2.54.0
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

Growing the primary device during an incremental build moves external
devices in the unified address space.  Inherited inodes still use the old
unified block addresses, so unchanged files can return wrong data after
the device table is updated.

Reject incremental builds of images with external devices for now.
Fix up inherited unified block addresses before allowing these builds.

Fixes: 54dd7ebd10b5 ("erofs-utils: mkfs: enable `--blobdev` for flat inode layouts")
Assisted-by: Codex:gpt-6.1-sol
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 lib/super.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/lib/super.c b/lib/super.c
index c6a9230..db8f23f 100644
--- a/lib/super.c
+++ b/lib/super.c
@@ -521,6 +521,18 @@ int erofs_mkfs_load_fs(struct erofs_sb_info *sbi, unsigned int dsunit)
 		return -EOPNOTSUPP;
 	}
 
+	/*
+	 * TODO: fix up unified block addresses in inherited inodes.
+	 *
+	 * Growing the primary device moves external devices in the unified
+	 * address space, while inherited inodes still use the old addresses.
+	 * Disable incremental builds with external devices for now.
+	 */
+	if (sbi->extra_devices) {
+		erofs_err("incremental builds with external devices are not supported");
+		return -EOPNOTSUPP;
+	}
+
 	err = erofs_io_fstat(&sbi->bdev, &u.st);
 	if (!err && S_ISREG(u.st.st_mode))
 		u.startblk = DIV_ROUND_UP(u.st.st_size, erofs_blksiz(sbi));
-- 
2.54.0 (Apple Git-157)


