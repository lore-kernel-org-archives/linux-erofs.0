Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB4BFC6FD1D
	for <linux-erofs@archiver.kernel.org>; Tue,  4 Apr 2023 14:56:28 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4PrW6z2QsHz3cdT
	for <linux-erofs@archiver.kernel.org>; Wed,  5 Apr 2023 00:56:27 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hLefXS2T;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QjqZNHCO;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=aalbersh@redhat.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hLefXS2T;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QjqZNHCO;
	dkim-atps=neutral
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4PrW6K1Vl0z3chj
	for <linux-erofs@lists.ozlabs.org>; Wed,  5 Apr 2023 00:55:52 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680620150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WW1Er4PupDb0BosAfd03U+k3CW0R0JjVRop2pX5rde0=;
	b=hLefXS2TUiqbRTXKfs3LBLVDrx6iwocAcaYIZUbKcqbvrY2COlUg5GeZk/8Oui9GNIEXXN
	UI+wWBnufeUod5Z7N0zasB7J3S60HUvXNlEoNxb2U4AJw7Nz8GtcVsJzmKMi4Nx3Pkypin
	Q+Vk2VjdsFeu4gWuByU9L9R3n5M3sjI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680620151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WW1Er4PupDb0BosAfd03U+k3CW0R0JjVRop2pX5rde0=;
	b=QjqZNHCOviI4VTd7mWkGN0R79bVZG4Fui4zz4duYkNmQKVMyN7us9/u+L5KFnwagyK6BHn
	Y6tnGqtGFOrBW3yl7eVHrucQti7udSFA8TY1ukgOsJ9TmtsqWhd1f8c5Jqh/6/J2+7gOW2
	Gtw5fevnqItwE/mLSGmXB6OJy7+tTkE=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-3qA0PhAuNbCUABNOhUEEOg-1; Tue, 04 Apr 2023 10:55:48 -0400
X-MC-Unique: 3qA0PhAuNbCUABNOhUEEOg-1
Received: by mail-qt1-f199.google.com with SMTP id v10-20020a05622a130a00b003e4ee70e001so16130715qtk.6
        for <linux-erofs@lists.ozlabs.org>; Tue, 04 Apr 2023 07:55:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680620144;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WW1Er4PupDb0BosAfd03U+k3CW0R0JjVRop2pX5rde0=;
        b=qHSKSKGpSV/rk7NQLXfzK2giVdtdp2C5ZBiACCWlVwX2CV7p4Uii/50DUvQu5hi+vr
         q4oVrHSuSFHSJnmKCoavH6oProLb0ROcK8T16T2gxm37ugv4hQYaOS4Zze44n4RVnKLn
         HJrQvcyHp8eJDzyj+LUTbeheJF6SBFXjw7OgYdv2CfNzs2b14wtvsMC61bZ0LlQOIxia
         fBOsBUP9t+cfo/u2Q0PGfQW/Crdw5tCf7pvhbjTazSDopUlf6Ldobmq+ZfhwqfzUtIgW
         MlGzzfNN628ganMaaxNHpzpc1f8R4rNHB+ieELHaar2reT/JyeYNx+uS0UuNkliwt0CF
         KMCw==
X-Gm-Message-State: AAQBX9dCcZSDVggk9774wfygqTvskZXBDFYtWLug07lcuWLxlV8D+h4z
	YETjH7K6QotMob8XVh4UnSD4uqK2uN+04yQPz1XcVrc1lt870azOLaiKFzyHKoBjS7p8/zVhcLQ
	rxrrFvrh5WLesBXEY3uQ9glg=
X-Received: by 2002:ac8:5c84:0:b0:3bf:da69:8f74 with SMTP id r4-20020ac85c84000000b003bfda698f74mr3767028qta.39.1680620144605;
        Tue, 04 Apr 2023 07:55:44 -0700 (PDT)
X-Google-Smtp-Source: AKy350aLDs2V7JY0pZuUB09/Ptq0L7v7I2lb1rRcVAQ1NVCDKigQ1vtszHxXzaOscw9+3+n++r92jw==
X-Received: by 2002:ac8:5c84:0:b0:3bf:da69:8f74 with SMTP id r4-20020ac85c84000000b003bfda698f74mr3766987qta.39.1680620144232;
        Tue, 04 Apr 2023 07:55:44 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id j4-20020ac86644000000b003e6387431dcsm3296539qtp.7.2023.04.04.07.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 07:55:43 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: djwong@kernel.org,
	dchinner@redhat.com,
	ebiggers@kernel.org,
	hch@infradead.org,
	linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev
Subject: [PATCH v2 19/23] xfs: disable direct read path for fs-verity sealed files
Date: Tue,  4 Apr 2023 16:53:15 +0200
Message-Id: <20230404145319.2057051-20-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230404145319.2057051-1-aalbersh@redhat.com>
References: <20230404145319.2057051-1-aalbersh@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
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
Cc: linux-ext4@vger.kernel.org, agruenba@redhat.com, damien.lemoal@opensource.wdc.com, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, rpeterso@redhat.com, jth@kernel.org, linux-erofs@lists.ozlabs.org, Andrey Albershteyn <aalbersh@redhat.com>, linux-btrfs@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

The direct path is not supported on verity files. Attempts to use direct
I/O path on such files should fall back to buffered I/O path.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_file.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 947b5c436172..9e072e82f6c1 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -244,7 +244,8 @@ xfs_file_dax_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret = 0;
 
 	trace_xfs_file_dax_read(iocb, to);
@@ -297,10 +298,17 @@ xfs_file_read_iter(
 
 	if (IS_DAX(inode))
 		ret = xfs_file_dax_read(iocb, to);
-	else if (iocb->ki_flags & IOCB_DIRECT)
+	else if (iocb->ki_flags & IOCB_DIRECT && !fsverity_active(inode))
 		ret = xfs_file_dio_read(iocb, to);
-	else
+	else {
+		/*
+		 * In case fs-verity is enabled, we also fallback to the
+		 * buffered read from the direct read path. Therefore,
+		 * IOCB_DIRECT is set and need to be cleared
+		 */
+		iocb->ki_flags &= ~IOCB_DIRECT;
 		ret = xfs_file_buffered_read(iocb, to);
+	}
 
 	if (ret > 0)
 		XFS_STATS_ADD(mp, xs_read_bytes, ret);
-- 
2.38.4

