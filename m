Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C404B606A321
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Nov 2026 12:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MZs3YopB
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQKtB3VqYz2ynW;
	Thu, 12 Nov 2026 23:47:46 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::62a"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794487666;
	cv=none; b=csDjSsK0xx0AS9THCDXjpB3rtjcU+iBZTeCd1ETAROLOrdPbzsGbz9eI6HCh9A9Jb0vHZEff++CPeHLGdfjmowl1pzBmzGusyqnIhXXb7gkuEHhHLQXGIpJMDdqzoW9Hy+O4uZDE7yS5w6mx9GdTO6+d0txznwx1CCjTkZ4oVqbYeae14pTiQ2VwZlwlHPACPD/b8o02ho1DLr2siC9TBCBVkK0bmH3Pse/Zx6Xu0qw8FmYVjnLBSRehIV6CULUgF5fZjS2MHhnemHXkJM1/ywkLbiV+4kFLi+R1QR6LLbN4tlPh4l3GUx0zT/NiEJifld7vCCjmAB8Mx6sB7PlwZw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794487666; c=relaxed/relaxed;
	bh=sqF2t9WInygrEF7LVcIFqHeGpV+E79jWrtRZFusepXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtosEk1fDDovvCLPmRV2O2jT9EfCNd/nQjKIx42ziUARNe+em+/XAwTRPpnp/oKn0U42aNeNM0s0WkTatBBVjt/I5snv4IBztwMFdLsoTHm409qH0PpF2yqMeuKRmzV3u4erZBwi+XVjZ5Zv7pmZGmJ7zLoWBHyRasIYZ6K4lVJNxLupVBA2pzApuOh8tDWWTe5acYjCmOjFXrUbFbWqUDAZLAqsJ6vmE9f+LgzW0VmUCMiWCnASh/6nRdyad94XfG3IPKL2CC5++9F/bR0MhMntLICr+cIWnTgy4bIZwJ//zBUXGZPmWsu0hpBff07HMDKCZ/EkxeTo4HVuK1VIEQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MZs3YopB; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::62a; helo=mail-pl1-x62a.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MZs3YopB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::62a; helo=mail-pl1-x62a.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQKt95Tqsz2xly
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 23:47:45 +1100 (AEDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-2ed1e9ae5a8so13817305ad.1
        for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 04:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794487663; x=1795092463; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sqF2t9WInygrEF7LVcIFqHeGpV+E79jWrtRZFusepXo=;
        b=MZs3YopBBq6UBr9p1yGXMY3Tx/sLesURA7m4fTx9NmyIrH10domOHQ8VPyecgG2s1E
         NrwiuMZFuXQT9mqmX41m0Dvh3z/ENXFOoGqjRzB+H5nXhKH+qfkV7ObEDUAo/DO7oY8W
         LlSldkl/hZ6ADnWWQG2v/TZ0PCMEPtnZrRiLdRho5t79KyEpC2ZKmIiFsk86H9kqly+5
         WC0BxNHE0A5iXlvI11gFdLni77aTpAsxgE8ew+mjGe7My6M6vHD6bTKBtFg4yZj53hdX
         myvDaFliNUqOygG3BMvcXk5OsRLUeCT3wSBzLxW4LoD6pPjTwHfBFVzx4kYS3w2VIPWm
         dNxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794487663; x=1795092463;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sqF2t9WInygrEF7LVcIFqHeGpV+E79jWrtRZFusepXo=;
        b=KLKOe4GWRHd5ZomQtNrjpuTUZW2CTbD1Za8nsmSxWm4My4TQDqoOvDp3qH3873oPx0
         MpK/zxEMx2Y2NOp4vxAv/IfgxzgLUhzYrp6/ajF09+ocacUklAD4VHr+3yDGjvp8FrfZ
         wUgR65cgGuBoyz8iU9+JuovCmYf7/QrJTnBxlj+zuS6yRCmTX72G7epl0SwLeOU6M4ri
         n5grVVBjry8tKQwdLCUwv7VKKlXN6yzKNacd6pQYInq7yGmuAAH4xhqnFR6VLk8vIe1b
         4u5ZXOje0uipj69qPB4hDA+llBqKsFmw94lx2GWPGBXd575Lw3fEIjVAxds4bNxx8uXC
         BuhQ==
X-Gm-Message-State: APuU4Z+7ld5+giyWaxSg1d68asbipTaqGX8/dxCJw5kiubYQb2X0GbJp
	cH280TQPgWr11wllVkVqDoyxeW7b7bRJ1Wr5X6Z8tVEuyIgCY77RF2vousxGYHhgR5s=
X-Gm-Gg: AYBFou2WFESf5OgQ9fMfST7uk2Sqg83i7C1L0yb+PxanbUbEBDF8lJRBfZFYcH612kH
	1g3Dd/rtj7BBPaI9YF/ipxm6Yhj+SgjqsH/Htzss1oeaauT6WZ8RlWrN4uu6KXtaAJ8PqgJSi2b
	DCgTjMmMzfxAqfAn51ER5d062+9i4Hh3KIjKMpq5SbDuxzJRA/8yv7ogD7Xl+DmItufpBtx7Zv8
	1FsD8ruLcBjva1LzOAtYX440g1HO0/Lzr24b4De5rEOs2i/AB/lLY4b+SS+jyQZgz+JxvVk6Kmh
	Gt3HRQJdemT8UP1ezCLm+tkLC0qqRh+/bOpOaWlYqHIUTBtZQ0/WadKVBiscBOqEPSsz9M8TNZW
	SjOK/I/pC8JErqFsCskHc1PIh1NKLqY8L4SZInSATyvr7HY6n823hvGt26VluVblCJF2/T4DatM
	9OSZNaHZGj13m+SY71jytDdDLeCjux1+NLBoFrcASOZxVD8lsGSSJBeDKxBuAKs9u3po7sweqrl
	+YP206ZqFH3Qt7Gri5ZQM0NOomIjqI1P7DQfudtS6040SNzYzX3tOKIoKKMEGqZhKOjOpC0wXD3
	jMwJYDATO0E6QBkYNp/6is0qAW3XA2xsAPvxz5RNmWco2JNL
X-Received: by 2002:a17:903:943:b0:2ed:4ea4:2dba with SMTP id d9443c01a7336-2edd73f8b01mr61751445ad.5.1794487663396;
        Thu, 12 Nov 2026 04:47:43 -0800 (PST)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6dd2225sm34189905ad.56.2026.11.12.04.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:47:43 -0800 (PST)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: Yifan Zhao <stopire@gmail.com>
Subject: [PATCH 2/8] erofs-utils: mkfs: fix incremental superblock stack overread
Date: Thu, 12 Nov 2026 20:47:19 +0800
Message-ID: <20261112124725.2774244-3-stopire@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112124725.2774244-1-stopire@gmail.com>
References: <20261112124725.2774244-1-stopire@gmail.com>
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
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Running mkfs.erofs --incremental on a base image with sb_extslots > 1
retains a superblock size larger than the 144-byte stack object in
erofs_writesb(). The final memcpy() reads past that object and writes
adjacent stack contents into the image.

Trigger path:
  main()
    erofs_mkfs_load_fs()
      erofs_read_superblock()  /* sb_size = 128 + sb_extslots * 16 */
    erofs_writesb()
      memcpy(..., &sb, sbi->sb_size)

Let's limit the source image sb size in incremental builds.

Fixes: c6903c7e32a1 ("erofs-utils: dump,fsck,fuse: support metadata compression")
Assisted-by: Codex:gpt-6-astra
Assisted-by: Claude Code:deepseek-v4.1-flash-1017
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/lib/super.c b/lib/super.c
index 5cb9016..694a3e9 100644
--- a/lib/super.c
+++ b/lib/super.c
@@ -515,6 +515,12 @@ int erofs_mkfs_load_fs(struct erofs_sb_info *sbi, unsigned int dsunit)
 		return err;
 	}
 
+	if (sbi->sb_size > sizeof(struct erofs_super_block)) {
+		erofs_err("unsupported superblock size %u for incremental builds",
+			  sbi->sb_size);
+		return -EOPNOTSUPP;
+	}
+
 	err = erofs_io_fstat(&sbi->bdev, &u.st);
 	if (!err && S_ISREG(u.st.st_mode))
 		u.startblk = DIV_ROUND_UP(u.st.st_size, erofs_blksiz(sbi));
-- 
2.56.0


