Return-Path: <linux-erofs+bounces-4664-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DBD2CA5FFC
	for <linux-erofs@archiver.kernel.org>; Tue,  6 Oct 2026 18:04:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hzkg93B2Rz2yd7;
	Wed, 07 Oct 2026 05:04:53 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791309893;
	cv=none; b=b0X1E+8ASmae9cBWO2BfE6rQjiwXXj3AWt8hozIvVnoh31E9TgbaVtG01R4Yfzdl7BUBsUJ019BvNMbFmkL6MUkGooESuDSQkWIxaQDa4hXPRATBfCz4Bmt2zt8vjt4VxPVsmXfQ5u21z849XD+vXau2bPNQzwQab3D4+grEFHDeH5qC05iUVFONZ54hX+MhUHxeZNW9WFzPckMPeSTfYETeLZ4Q9AVpL8eNoSAT09OiK5/rhygwswQld2LU6tUQHbzspWqrfMPFJYDMJoiegVBLuiHcmn7lNIZ4SXgLayRSqJpl4LulwjbRxMCXkT7M5Njmsvv0jt3qyCmoU1SX0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791309893; c=relaxed/relaxed;
	bh=ZOEvOpuSjBIn5J4fLR3eGB12J6vd5JpKYCMFcpSp334=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fKDvFrhBqo3Jm9t78fDk6bRH3HUAenMpK8EwPsoge+a+j8yYslMVmW4MNdkHmYPSNXUb1oGuUYTFplNiULlsvi6w1nBMgplKovuDD3FFHqgBAhkWxjoQviWoJxLgdtlUml35HHIoexWdlKkuDfS236AcSowXi80uKFGfY/DykihxjR7S4pqzgJhJOqjjgKGtsQ99rs0t5kmpN0g80EoGGUVWeZonZcCEEt7cGet6cM8tEO6GNrD6ybJLzdJEE7KsjGleJgHxwr717lrj5M50vw9TYKmTc9UEpRv8dlrUNKH3FpZcLVbsYzdvkLgbfwne/q5OcJuzouwMHBZwgDaCeg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=EhidP2+N; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=devnull+sadmanf.meta.com@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=EhidP2+N;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=devnull+sadmanf.meta.com@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hzkg838pRz2yfD
	for <linux-erofs@lists.ozlabs.org>; Wed, 07 Oct 2026 05:04:52 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B34644504;
	Tue,  6 Oct 2026 18:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5D7C5C4AF64;
	Tue,  6 Oct 2026 18:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791309889;
	bh=IlHrFcv99Q2jpM6hO4SPqo39zet261Ph0v1qK5PNPec=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=EhidP2+NSd5c8ms6XvXTnMg6VdV2HHer0mhLidxlbSzsiaf+CTpB31dgOYVbBBVHN
	 lLiTx7EZm7lHfW7I6cWbIHRNNLhwrblY4Ry/D5YGPZka0LCKjKxfwCo+m7bERyW5O9
	 N0APHrqPeCBYPTGxomEiE8pihgBC49l1XteIJMEDhfrw7Q6Wa0U580umBvQaww/pmz
	 Fx8vrSaIML05jASbQHK/h3XSFDHR+oaaoWXQCS377iwZO6gLucgPeGNdaexljE+UWm
	 63YVFJfQMc0LYggn3DCwDJXtYgsB9qUVq9VTpWo5PK4nwPBeSkqB3IrwBdVni40J8J
	 ZKYYjtKRIBFJQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4764FCA5FFC;
	Tue,  6 Oct 2026 18:04:49 +0000 (UTC)
From: Sadman Fahmid via B4 Relay <devnull+sadmanf.meta.com@kernel.org>
Date: Tue, 06 Oct 2026 14:04:48 -0400
Subject: [PATCH RESEND 2/2] erofs-utils: lib: close source fd on early
 errors in erofs_mkfs_begin_nondirectory()
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261006-round1-v1-2-f46b13e11de5@meta.com>
References: <20261006-round1-v1-0-f46b13e11de5@meta.com>
In-Reply-To: <20261006-round1-v1-0-f46b13e11de5@meta.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
 Sadman Fahmid <sadmanf@meta.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791309888; l=1980;
 i=sadmanf@meta.com; s=20261006; h=from:subject:message-id;
 bh=rn2AYDk4gmNMAZ6KTROzM/iZXd90ZGk0DihnmePza4U=;
 b=Gk5IZRNu6v+G5DBuxx3rm09sZWx2dR6iizzPCzJ/FUeWsr/3qAZMVKkbdoHK6cpOgE79gLFlU
 QMZ0uu1fHbCCW9eHazq1U1o4Q81wdVMYTtj8TmoFy4/ZMkqpmGkGXOp
X-Developer-Key: i=sadmanf@meta.com; a=ed25519;
 pk=Pc/arXJpm1RPef8qImFuHROn1p3XNX5MWSUxjZWNTa4=
X-Endpoint-Received: by B4 Relay for sadmanf@meta.com/20261006 with
 auth_id=1125
X-Original-From: Sadman Fahmid <sadmanf@meta.com>
Reply-To: sadmanf@meta.com

From: Sadman Fahmid <sadmanf@meta.com>

If erofs_set_inode_fingerprint() or erofs_prepare_compressed_file()
fails, the source file descriptor opened just above is never closed
since the job carrying it is never queued.  Close it on those paths.

The diskbuf descriptor is left alone as it is owned by the diskbuf.

Signed-off-by: Sadman Fahmid <sadmanf@meta.com>

---
The erofs_begin_compressed_file() failure path is left as is: with
multi-threaded compression, z_erofs_mt_compress() may fail after some
segments have already been queued to workers that read from the fd,
so closing it there would be unsafe.
---
 lib/inode.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/lib/inode.c b/lib/inode.c
index ec96556..489c44e 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -2086,14 +2086,16 @@ static int erofs_mkfs_begin_nondirectory(const struct erofs_mkfs_btctx *btctx,
 
 		ret = erofs_set_inode_fingerprint(inode, ctx.fd, ctx.fpos);
 		if (ret < 0)
-			return ret;
+			goto err_close;
 
 		if (inode->datasource != EROFS_INODE_DATA_SOURCE_REBUILD_BLOB &&
 		    inode->sbi->available_compr_algs &&
 		    erofs_file_is_compressible(im, inode)) {
 			ctx.ictx = erofs_prepare_compressed_file(im, inode);
-			if (IS_ERR(ctx.ictx))
-				return PTR_ERR(ctx.ictx);
+			if (IS_ERR(ctx.ictx)) {
+				ret = PTR_ERR(ctx.ictx);
+				goto err_close;
+			}
 			erofs_bind_compressed_file_with_fd(ctx.ictx,
 							   ctx.fd, ctx.fpos);
 			ret = erofs_begin_compressed_file(ctx.ictx);
@@ -2103,6 +2105,12 @@ static int erofs_mkfs_begin_nondirectory(const struct erofs_mkfs_btctx *btctx,
 	}
 out:
 	return erofs_mkfs_go(btctx, EROFS_MKFS_JOB_NDIR, &ctx, sizeof(ctx));
+
+err_close:
+	/* the diskbuf fd is shared and released along with the diskbuf */
+	if (inode->datasource != EROFS_INODE_DATA_SOURCE_DISKBUF)
+		close(ctx.fd);
+	return ret;
 }
 
 static int erofs_mkfs_handle_inode(const struct erofs_mkfs_btctx *ctx,

-- 
2.53.0-Meta



