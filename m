Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C898C3DA4A
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Aug 2024 03:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1724209428;
	bh=g3UC8MCDH65jmbtIfrgdCf8MM/22sFBxjuTWVjBcdgQ=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=cKLB81uyzHOXcq4nTMZRPz5yqTxzkjdV/ktVn7qZw0SUmlAkYHW3wrefNtVbxl0yZ
	 OLNwXDUqBmeAGyKv9AcBktMX1EFYdgifD1pzthZ4n6/PCNoUs0YuaoroqW0lXFmmWo
	 PJdehJJMIsMSGL3zBuHT67YQ4q/rm0eJmgTI2O57dpxxhajnAUY6g4jORB6dXniM2X
	 wpVk2uQph5pY38F8dzAbuCic5JDP5qxRsgZNOQpSVdV1qjDryJone5vuBVTWW07DQd
	 zjD4ECbGn5e7lfrc2w7jLKVyOzwmGShZMSaEHcEmiDikTpwWIjCKmvR1TRil3KCK93
	 tC1Oh2FLO/AOA==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4WpWPc12rPz2yLP
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Aug 2024 13:03:48 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=45.249.212.32
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=45.249.212.32; helo=szxga06-in.huawei.com; envelope-from=wozizhi@huawei.com; receiver=lists.ozlabs.org)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4WpWPX74tVz2xYk
	for <linux-erofs@lists.ozlabs.org>; Wed, 21 Aug 2024 13:03:44 +1000 (AEST)
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4WpW0v6Dsrz1xvKZ;
	Wed, 21 Aug 2024 10:45:51 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id 3E9D51A0188;
	Wed, 21 Aug 2024 10:47:46 +0800 (CST)
Received: from localhost.localdomain (10.175.104.67) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 21 Aug 2024 10:47:45 +0800
To: <netfs@lists.linux.dev>, <dhowells@redhat.com>, <jlayton@kernel.org>
Subject: [PATCH 7/8] cachefiles: Fix NULL pointer dereference in object->file
Date: Wed, 21 Aug 2024 10:43:00 +0800
Message-ID: <20240821024301.1058918-8-wozizhi@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240821024301.1058918-1-wozizhi@huawei.com>
References: <20240821024301.1058918-1-wozizhi@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.104.67]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemf100017.china.huawei.com (7.202.181.16)
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
From: Zizhi Wo via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Zizhi Wo <wozizhi@huawei.com>
Cc: yangerkun@huawei.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, hsiangkao@linux.alibaba.com, linux-erofs@lists.ozlabs.org, yukuai3@huawei.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

At present, the object->file has the NULL pointer dereference problem in
ondemand-mode. The root cause is that the allocated fd and object->file
lifetime are inconsistent, and the user-space invocation to anon_fd uses
object->file. Following is the process that triggers the issue:

	  [write fd]				[umount]
cachefiles_ondemand_fd_write_iter
				       fscache_cookie_state_machine
					 cachefiles_withdraw_cookie
  if (!file) return -ENOBUFS
					   cachefiles_clean_up_object
					     cachefiles_unmark_inode_in_use
					     fput(object->file)
					     object->file = NULL
  // file NULL pointer dereference!
  __cachefiles_write(..., file, ...)

Fix this issue by add an additional reference count to the object->file
before write/llseek, and decrement after it finished.

Fixes: c8383054506c ("cachefiles: notify the user daemon when looking up cookie")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 fs/cachefiles/interface.c |  3 +++
 fs/cachefiles/ondemand.c  | 30 ++++++++++++++++++++++++------
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/fs/cachefiles/interface.c b/fs/cachefiles/interface.c
index 35ba2117a6f6..d30127ead911 100644
--- a/fs/cachefiles/interface.c
+++ b/fs/cachefiles/interface.c
@@ -342,10 +342,13 @@ static void cachefiles_clean_up_object(struct cachefiles_object *object,
 	}
 
 	cachefiles_unmark_inode_in_use(object, object->file);
+
+	spin_lock(&object->lock);
 	if (object->file) {
 		fput(object->file);
 		object->file = NULL;
 	}
+	spin_unlock(&object->lock);
 }
 
 /*
diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
index 38ca6dce8ef2..fe3de9ad57bf 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -60,20 +60,26 @@ static ssize_t cachefiles_ondemand_fd_write_iter(struct kiocb *kiocb,
 {
 	struct cachefiles_object *object = kiocb->ki_filp->private_data;
 	struct cachefiles_cache *cache = object->volume->cache;
-	struct file *file = object->file;
+	struct file *file;
 	size_t len = iter->count, aligned_len = len;
 	loff_t pos = kiocb->ki_pos;
 	const struct cred *saved_cred;
 	int ret;
 
-	if (!file)
+	spin_lock(&object->lock);
+	file = object->file;
+	if (!file) {
+		spin_unlock(&object->lock);
 		return -ENOBUFS;
+	}
+	get_file(file);
+	spin_unlock(&object->lock);
 
 	cachefiles_begin_secure(cache, &saved_cred);
 	ret = __cachefiles_prepare_write(object, file, &pos, &aligned_len, len, true);
 	cachefiles_end_secure(cache, saved_cred);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	trace_cachefiles_ondemand_fd_write(object, file_inode(file), pos, len);
 	ret = __cachefiles_write(object, file, pos, iter, NULL, NULL);
@@ -82,6 +88,8 @@ static ssize_t cachefiles_ondemand_fd_write_iter(struct kiocb *kiocb,
 		kiocb->ki_pos += ret;
 	}
 
+out:
+	fput(file);
 	return ret;
 }
 
@@ -89,12 +97,22 @@ static loff_t cachefiles_ondemand_fd_llseek(struct file *filp, loff_t pos,
 					    int whence)
 {
 	struct cachefiles_object *object = filp->private_data;
-	struct file *file = object->file;
+	struct file *file;
+	loff_t ret;
 
-	if (!file)
+	spin_lock(&object->lock);
+	file = object->file;
+	if (!file) {
+		spin_unlock(&object->lock);
 		return -ENOBUFS;
+	}
+	get_file(file);
+	spin_unlock(&object->lock);
 
-	return vfs_llseek(file, pos, whence);
+	ret = vfs_llseek(file, pos, whence);
+	fput(file);
+
+	return ret;
 }
 
 static long cachefiles_ondemand_fd_ioctl(struct file *filp, unsigned int ioctl,
-- 
2.39.2

