Return-Path: <linux-erofs+bounces-2163-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB094D3EE75
	for <linux-erofs@archiver.kernel.org>; Thu, 22 Jan 2026 15:47:24 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dxlmy4Fy4z2xl0;
	Fri, 23 Jan 2026 02:47:14 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.218
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769096834;
	cv=none; b=E5I7HuTWktxaZ+ClIa4p6NlTJbUHj+StHO4jGsge+j2izuKd1gUFLamDFAaLJTfZXgEm6Ot+dMUBwGynexeBLxo87aXWMxU/KNGdOhFc18BCAH1HNprE0iGZYh2xDIx0OtmzQUTJgHyv1+jV5muqxbfSmzOU1EEMCSQYizhAi3NPqJ4wCaFXaVDxdbLQ7ZllNKCCrQJTqh/xNsrfDVOJw2lqewBfjkENaHOx7c5Z8DbVqRgCBOAI9i4XfuU6ebbhwv/Ezob9FUxoeRB7Xy9sdtHKmjcKS41C4rtcwsJYWiLQZu7neBbQPzMFgsqPcdl2zW9cSOXJ9tbGphJyH9XO5w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769096834; c=relaxed/relaxed;
	bh=IJqOVDMyH2cU6HZaQ6KGaq7L7r7sGB/NU+oSMo68sYk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sc2BL5Z+2UfAU+UH2B44Yoa+7vW0JVoIaQd1iS7CrKd/F77gcpt9Izy/UgS+4OLY1mh54zXbc4T9OGRnWvPZ5aw4qeJFiOnMGU2iyA+LlZxtfOHNJKCtwxpg3At14Sv5TQWzCDHcUiVKg9RcPy+v/NXtT2Y1KLd5ndjer3BbssMiePmNJ4vRrgfh63Tc2qFLMTUVFv9gzLhF6KRSGWUQSrtKUPdAxIoNFVfs1zE7ZCem7ACHPL0eRGw4zQ1zjkxKLBdMnNHHHbdctb8SVgfDEHxCEcFdFzVBpyPSa1FOsggOK0OUJchhxdOPUV8zuNrPCjLjFtGIu90PD7zxelhTYw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=aViTVgKb; dkim-atps=neutral; spf=pass (client-ip=113.46.200.218; helo=canpmsgout03.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=aViTVgKb;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.218; helo=canpmsgout03.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dxlms56JTz2yFm
	for <linux-erofs@lists.ozlabs.org>; Fri, 23 Jan 2026 02:47:08 +1100 (AEDT)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=IJqOVDMyH2cU6HZaQ6KGaq7L7r7sGB/NU+oSMo68sYk=;
	b=aViTVgKbU3p9F6fvfb/DRZ9GIhljQ3rKlHQMPA1II5YccTLm1l79Wl8RBcmkkhYNwMzHKxXz0
	9YV1Y0ow6kq2fONT0jz7uycW8blnvYaMxZYGGACdFOLs9cXkvJ3tWcEIwXSiiP4I/798eIXtO+j
	kCdEQvGGYPkM65v8oi6/oqU=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dxlhL4rkXzpSts;
	Thu, 22 Jan 2026 23:43:14 +0800 (CST)
Received: from kwepemr500015.china.huawei.com (unknown [7.202.195.162])
	by mail.maildlp.com (Postfix) with ESMTPS id BDF9B40567;
	Thu, 22 Jan 2026 23:47:02 +0800 (CST)
Received: from huawei.com (10.67.174.162) by kwepemr500015.china.huawei.com
 (7.202.195.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 22 Jan
 2026 23:47:02 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <hsiangkao@linux.alibaba.com>, <chao@kernel.org>, <brauner@kernel.org>
CC: <hch@lst.de>, <djwong@kernel.org>, <amir73il@gmail.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>,
	<linux-kernel@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH v17 01/10] fs: Export alloc_empty_backing_file
Date: Thu, 22 Jan 2026 15:33:57 +0000
Message-ID: <20260122153406.660073-2-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20260122153406.660073-1-lihongbo22@huawei.com>
References: <20260122153406.660073-1-lihongbo22@huawei.com>
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
Content-Type: text/plain
X-Originating-IP: [10.67.174.162]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500015.china.huawei.com (7.202.195.162)

There is no need to open nonexistent real files if backing files
couldn't be backed by real files (e.g., EROFS page cache sharing
doesn't need typical real files to open again).

Therefore, we export the alloc_empty_backing_file() helper, allowing
filesystems to dynamically set the backing file without real file
open. This is particularly useful for obtaining the correct @path
and @inode when calling file_user_path() and file_user_inode().

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Acked-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/file_table.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/file_table.c b/fs/file_table.c
index cd4a3db4659a..476edfe7d8f5 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -308,6 +308,7 @@ struct file *alloc_empty_backing_file(int flags, const struct cred *cred)
 	ff->file.f_mode |= FMODE_BACKING | FMODE_NOACCOUNT;
 	return &ff->file;
 }
+EXPORT_SYMBOL_GPL(alloc_empty_backing_file);
 
 /**
  * file_init_path - initialize a 'struct file' based on path
-- 
2.22.0


