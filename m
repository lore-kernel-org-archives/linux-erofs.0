Return-Path: <linux-erofs+bounces-3465-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77C4CCD4F54
	for <linux-erofs@archiver.kernel.org>; Wed, 20 May 2026 04:00:52 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gKyWN14L0z2xrC;
	Wed, 20 May 2026 14:00:48 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=103.149.242.130
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1779249648;
	cv=none; b=nseUcLjKmfDoWpexPCKoCrbWHKViOvoxAHQB8ntDctFDg9lSCW1e2TEc5YdOrW70hqeTePDikcXa08Ytg0E3eao18CBdMeB+xLUXVp2hwgN364d6agMILnJx/hWcVv2QdZ7wH1gYNb6plOAYHEE8p2FqHMxxVa09xeQngzvDH12fYqknUT6LG4nCXR2Vzll1Ao68BRb5xrmKEj8AKB6lQn9gb2D6kYwOxmm/USGeD5RjIn4AI0PSVzKkTrHE2QA6mX+rymK9g3rnMsiq41j/7PxKmo1NGLei+txkIIc4J9SWrPpsAKbl5XFKEM+xc6xg4xmBX/GbiXGrMQXxyCvlCw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1779249648; c=relaxed/relaxed;
	bh=5n10d+29Mu0a/Szos0qxYnUsPnUlkjOlTKvqdnQDFh0=;
	h=Date:Mime-Version:Content-Type:From:Subject:To:Cc:Message-Id; b=KAhZqVhTLQAbk4Vr8RD1Gab/8ZtWk+nk2xm9pqegVFYjjXsrSymUjPBbfg+OyCA3ABVSn7uKNeCCT9COz3KVZac2DZzmggQwi+pMj3VA+Tbb6WqvcAejfk4C2OxlmT0YKS0XScdMT9niMhBsJMfVusPeHtqF3q+X5D5LegCN8T+NuJk/CLOPyCu9SPTNtt1jay00vI+WvpKUV5Gx3R+zzMSTc+8JWGBtXhnh17cLEkh8hDws2/sqJD2Dlb+nqXu/szMkPuWySzTAKpSvPtwtpccwFEQ6FZivv+JD3yKzr+yh931CICZXJaKFNsNfwU/xKC+ugu0WriboluU4+eifXw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; dkim=pass (2048-bit key; unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=ScQEfIxr; dkim-atps=neutral; spf=pass (client-ip=103.149.242.130; helo=lf-1-130.ptr.blmpb.com; envelope-from=zhujia.zj@bytedance.com; receiver=lists.ozlabs.org) smtp.mailfrom=bytedance.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=ScQEfIxr;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=bytedance.com (client-ip=103.149.242.130; helo=lf-1-130.ptr.blmpb.com; envelope-from=zhujia.zj@bytedance.com; receiver=lists.ozlabs.org)
Received: from lf-1-130.ptr.blmpb.com (lf-1-130.ptr.blmpb.com [103.149.242.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gKyWK6dGTz2yF7
	for <linux-erofs@lists.ozlabs.org>; Wed, 20 May 2026 14:00:44 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779248581; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=5n10d+29Mu0a/Szos0qxYnUsPnUlkjOlTKvqdnQDFh0=;
 b=ScQEfIxrVRTZyPZHPVhboXb197QrzXm1h0xITQpvZ4HbrVXTnV4aaCdoqQfVyROn/a02me
 NbGFLgIP74ffEDRhCATDLSJCoRUtT6P61jOyZPj9q2F78kehJ/FxGTzbtJnKnq9Dtx388b
 joXjJURwBlO5DdSM2wGcMhvuJg0PZaiC5w75FEdAhfnVLpsqd4MIDPhlHaaRTIQaBESf4m
 kt8qgN9mTCUMZs/ZeZPX4EGvJ5lhbzXkTzZtCfr9TUI3zCULuEQvVAd3nADSs+vyJ3hOpw
 ezcKSiKnLv/NROe69vKQTBzT2gJITQVBfazLoYu46Yc4QJedTfK14I+CbHpxtA==
Date: Wed, 20 May 2026 11:42:52 +0800
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
From: "Jia Zhu" <zhujia.zj@bytedance.com>
Subject: [PATCH] erofs: fix metabuf leak in shared xattr initialization
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
X-Lms-Return-Path: <lba+26a0d2dc3+c79b6a+lists.ozlabs.org+zhujia.zj@bytedance.com>
To: "Gao Xiang" <xiang@kernel.org>, "Chao Yu" <chao@kernel.org>
X-Original-From: Jia Zhu <zhujia.zj@bytedance.com>
Cc: <linux-erofs@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>, 
	"Yue Hu" <zbestahu@gmail.com>, "Jeffle Xu" <jefflexu@linux.alibaba.com>, 
	"Sandeep Dhavale" <dhavale@google.com>, 
	"Hongbo Li" <lihongbo22@huawei.com>, "Chunhai Guo" <guochunhai@vivo.com>, 
	"Amir Goldstein" <amir73il@gmail.com>, 
	"Gao Xiang" <hsiangkao@linux.alibaba.com>, 
	"Jia Zhu" <zhujia.zj@bytedance.com>
Message-Id: <20260520034252.40163-1-zhujia.zj@bytedance.com>
Content-Transfer-Encoding: 7bit

erofs_init_inode_xattrs() uses a local metabuf while reading the inline
xattr header and the shared xattr id array.

It currently drops that metabuf from some error paths and from the success
path, but the erofs_bread() failure while reading the shared xattr id array
goes straight to out_unlock.

This became observable when file-backed metadata reads started calling
rw_verify_area() before reusing or dropping the current metabuf.  Before
that, the read_mapping_folio() failure path already dropped the old metabuf
before returning an error.

Consolidate the local metabuf cleanup at out_unlock. erofs_put_metabuf()
is a no-op if no page has been acquired, and this keeps all paths after
taking EROFS_I_BL_XATTR_BIT covered by one cleanup site.

Fixes: 307210c262a2 ("erofs: verify metadata accesses for file-backed mounts")
Signed-off-by: Jia Zhu <zhujia.zj@bytedance.com>
---
 fs/erofs/xattr.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
index 41e311019a251..df7ea019526d7 100644
--- a/fs/erofs/xattr.c
+++ b/fs/erofs/xattr.c
@@ -89,13 +89,11 @@ static int erofs_init_inode_xattrs(struct inode *inode)
 	    vi->xattr_isize - sizeof(struct erofs_xattr_ibody_header)) {
 		erofs_err(sb, "invalid h_shared_count %u @ nid %llu",
 			  vi->xattr_shared_count, vi->nid);
-		erofs_put_metabuf(&buf);
 		ret = -EFSCORRUPTED;
 		goto out_unlock;
 	}
 	vi->xattr_shared_xattrs = kmalloc_objs(uint, vi->xattr_shared_count);
 	if (!vi->xattr_shared_xattrs) {
-		erofs_put_metabuf(&buf);
 		ret = -ENOMEM;
 		goto out_unlock;
 	}
@@ -112,12 +110,12 @@ static int erofs_init_inode_xattrs(struct inode *inode)
 		}
 		vi->xattr_shared_xattrs[i] = le32_to_cpu(*xattr_id);
 	}
-	erofs_put_metabuf(&buf);
 
 	/* paired with smp_mb() at the beginning of the function. */
 	smp_mb();
 	set_bit(EROFS_I_EA_INITED_BIT, &vi->flags);
 out_unlock:
+	erofs_put_metabuf(&buf);
 	clear_and_wake_up_bit(EROFS_I_BL_XATTR_BIT, &vi->flags);
 	return ret;
 }
-- 
2.39.5 (Apple Git-154)

