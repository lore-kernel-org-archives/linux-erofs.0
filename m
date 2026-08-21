Return-Path: <linux-erofs+bounces-4279-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8B90C5DF87
	for <linux-erofs@archiver.kernel.org>; Fri, 21 Aug 2026 01:56:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hR3MV1RBBz2xcG;
	Fri, 21 Aug 2026 11:56:54 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::1035"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787277414;
	cv=none; b=hM4Vt56sm1OZd9jRQB4rJMoDmQbMzXMfGJAhhE7T/N4BJcwkRQi/Zf75wyiW3shL2TbNIhTjp+CADpJ0VlOJYewajOUriCoF7wtX7rY0dlfDGCsU5ery0X0O4ryDK8kg3SqEIfbcQoPoYoE7AHYn6ws5gMkH8TOM+fEbxXp0u4ZMlO/sDrb9s6vkw+9ePGE4/8MKuxks6RdlfLF+uY99wUr45aHdR8Qu2lwlJuqNqbebopwABfumkOsdsA0I7j1gGiJP3xh0A9daS6tm19fKQoI5K9FaIo61jlVeq7bjvXUwmlUzGaaiSKPhh9RiHOTfTEltm4e+S8vgAjrc7vstOA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787277414; c=relaxed/relaxed;
	bh=bs8jF4Er09DVcxm27jqwzMZ4oXMxXv5K/85mUgAOgYs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XW6wULsapUJteIon3nArUa0P40w3jHdAAofb959RmqeW65H/LGdB1i6GIodpeI/EmdkZhC+sLO+hQFcfdcWth6LaQmHyck8yMqgsHbSBSpnUGiDkXTqMmLKFCneFlCTLOVYbSLca7G1zOifp6aNVEsO9N1anAjgbemk7obH37jIAXPlGwxjJJTo2NVff18pRrMECM5VUFFy2TGHMSSM3BxvmshPX/HeCaM7Gd82rqabJ9tQwJ30Iz2AISnQVgfifijpY1uB3EPvITKTehKQ8MVWFU4FOC/KpDZWLGVZpLA7gPJT0R4eCnU+KnXJ828bsNDNyO/FUe7zLRKZf0pZi/A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=G6IawQ/0; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1035; helo=mail-pj1-x1035.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=G6IawQ/0;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1035; helo=mail-pj1-x1035.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hR3MS15hwz2xRs
	for <linux-erofs@lists.ozlabs.org>; Fri, 21 Aug 2026 11:56:51 +1000 (AEST)
Received: by mail-pj1-x1035.google.com with SMTP id 98e67ed59e1d1-38e3efab7e0so324182a91.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 18:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787277408; x=1787882208; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bs8jF4Er09DVcxm27jqwzMZ4oXMxXv5K/85mUgAOgYs=;
        b=G6IawQ/0ZbOpMcu6G27o/2C956pig3XX8HCXPVAr7l/T/XRa6Ca/Qil6qGA49gX8cH
         FMS5S8/Dl+GK/02v3CFdFK0HDtnXRXyk4RMfnmVD5LgItsIMj3/qanyFpx45MRdJo2eG
         iAYRjnMUvqKu5uQBrZGS1jXid/QcNST7oFIh8Nf5heaDyGRDdQdmh6kFzPb8mjjPN0d5
         kyGm0gLhJ9niRCGlSe8+fRnOM3Dvlm6ZgfXjbkeBtkScelNgxaFxR7LM+UNUXY1BA5UR
         us5Qx6phytvkABRDZMcsnTGFeiLONh58VKy4vQLU9E2l2e41IyMaAFyW477PjdAaGZNy
         DrvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787277408; x=1787882208;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bs8jF4Er09DVcxm27jqwzMZ4oXMxXv5K/85mUgAOgYs=;
        b=fiXSOJafNEtm3hCFyGSxBJwiIDqHvCC+7SpqyzxtEyKkXqokB6ZRsedF+cx3Ih/mdu
         BImzqXhMTsyx/6RB2tsSeiRWdPXCFhyll9nBdyJMQKqezGSNqKU5A63l9QxuRCwvLLzv
         +UHsURKxsJJbwaKjlAUSA+QYwqSJ3A3j1QBFOqvgV+WIQqLJj175FR6ylzKRkQ2Z4egX
         wSLqMrP2J3Ji22rn1m/V1UTO30t9Zjj9vVnWQWj+te5Ef2wsnQpwsVdgJeMVaYi/kUv+
         WzQQ/N9iWvixfjhs4hlvzeHx5fu3CXz0YaBvQHpuWaPXfRkENDVphmuWb3W4BmBecFkb
         B11A==
X-Forwarded-Encrypted: i=1; AHgh+RqPvM1BEJWUlChI8AY3lg72bkJgLRFOYTHVv77P+5/FJmAOF1eUCYNRY/I0F79vTF4jWeoG0p99hIXcgQ==@lists.ozlabs.org
X-Gm-Message-State: AFuF++liPBz7frCTwcRovl7uGrc3s35fEq3R7IHES2e/J4rCHOS1usU3
	8JDX0o3Pi05KfpP4tTF+XE6QiK8Y/Vui2OxSArFYYbEXBt9blDop+Cd9
X-Gm-Gg: AR+sD12tLPajCRNeNIq892KUXMklsUqkrI0IZlV366VxuYvvQrusT/p4202s5+I9suf
	Nyvzd06juSmthpWXEg/1/jEWlhIuo0EEhNjR7gtK49lphd7aEPg8RE2OhIHs9m5CUkcuGh/zeZB
	JZLSg4DEKhgdLW/wOfmDr82iwTpQonLcRG906B0KzVwEKh7etByLJ5BA8qrz6PCS0GejJ7lN1c6
	ix9cQNZjAPDCj1ZhHH12UZ7X4t+i1L9IBbmirwEIOiFwuiKPVn0flfSVYdzhPMJ4hANu8jM7qt0
	74no2+ReRYlhlwTLf2xQMrNjcjfylt0St5FG2lcJM6UdMc8M2zJlrm9JWvPsHQ185z8zWmGRhOQ
	DdJAnvmlzuLFS0OmVhg1nV7MIGTY7+V/kvY7/fTiEqi9gWPOj7Q/35dRPGmymH7MpjT34Po1KxZ
	ENf2HPiidzuEO9wuIbrjTIb2E5leq/188P7SpYexUNv0kRXMmr+bLNSLzJkAROgqfFKwBIOiPe
X-Received: by 2002:a17:90b:2e4b:b0:38f:de94:bf34 with SMTP id 98e67ed59e1d1-395c514b5cbmr2052462a91.10.1787277408052;
        Thu, 20 Aug 2026 18:56:48 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395c46b5e4dsm992355a91.6.2026.08.20.18.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 18:56:47 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>
Cc: Jingbo Xu <jefflexu@linux.alibaba.com>,
	zhanxusheng@xiaomi.com,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Zhan Xusheng <zhanxusheng1024@gmail.com>
Subject: [PATCH v2] erofs: support splice() in inode_share mode
Date: Fri, 21 Aug 2026 09:56:41 +0800
Message-ID: <20260821015641.1936276-1-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
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

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

erofs_ishare_fops routes everything that touches the page cache to the
backing file in ->private_data: read_iter clones the iocb onto it, mmap
does vma_set_file(), fadvise calls vfs_fadvise() on it.  splice_read was
left as filemap_splice_read(), which works on the user file's own mapping:
it does init_sync_kiocb(&iocb, in), and filemap_get_pages() then takes
iocb->ki_filp->f_mapping.

So splice() and sendfile() fill the per-inode page cache rather than the
shared one.  The content is the same either way, since erofs_fill_inode()
sets a_ops on that mapping too, which is why this went unnoticed.  Two
identical 8 MiB files under inode_share, reading one of them with splice(2)
alone, in pages:

  before   own 2048   shared 0
  after    own 0      shared 2048

"own" is cachestat(fd), which reports the file's own mapping; "shared" is
mmap()+mincore(), which erofs_ishare_mmap() redirects to the backing file.

Read through the backing file, as read_iter already does.

Link: https://lore.kernel.org/all/b7dc7192-d586-45a2-bc4a-b41dc681c9bb@linux.alibaba.com/
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
v1->v2:
- Retitled and dropped the Fixes tag: the sharing is best effort, so
  this is an enhancement rather than a fix.
- Added the measured before/after.
- Left file_accessed() alone, since it is a no-op under SB_NOATIME.
- An erofs-utils test is sent separately against experimental-tests.

v1: https://lore.kernel.org/all/20260820064441.1083470-1-zhanxusheng@xiaomi.com

 fs/erofs/ishare.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
index fa7d4112dec5..01dc53e9e3ad 100644
--- a/fs/erofs/ishare.c
+++ b/fs/erofs/ishare.c
@@ -148,6 +148,13 @@ static int erofs_ishare_mmap(struct file *file, struct vm_area_struct *vma)
 	return generic_file_readonly_mmap(file, vma);
 }
 
+static ssize_t erofs_ishare_splice_read(struct file *in, loff_t *ppos,
+					struct pipe_inode_info *pipe,
+					size_t len, unsigned int flags)
+{
+	return filemap_splice_read(in->private_data, ppos, pipe, len, flags);
+}
+
 static int erofs_ishare_fadvise(struct file *file, loff_t offset,
 				loff_t len, int advice)
 {
@@ -161,7 +168,7 @@ const struct file_operations erofs_ishare_fops = {
 	.mmap		= erofs_ishare_mmap,
 	.release	= erofs_ishare_file_release,
 	.get_unmapped_area = thp_get_unmapped_area,
-	.splice_read	= filemap_splice_read,
+	.splice_read	= erofs_ishare_splice_read,
 	.fadvise	= erofs_ishare_fadvise,
 };
 
-- 
2.43.0


