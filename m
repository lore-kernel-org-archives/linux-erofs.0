Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A09EAC433FE
	for <linux-erofs@archiver.kernel.org>; Fri, 21 Oct 2022 02:23:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4MtpDQ1P5Zz3dqc
	for <linux-erofs@archiver.kernel.org>; Fri, 21 Oct 2022 13:23:34 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1666319014;
	bh=XcnBacFtkvcakgxinsPtVgsUyh+z9XVNjaHmktAFVU4=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=YiPw45oV24vbaOIk10hfVJWSvbrX8fHYx6d2izqXEfP8zwDvz//fWsZp3sCUJGFI1
	 cTokncHLdSRvyNWjUGA/cnLRDpBYsxCFe0CownlFyNToJWqjEfjgGkdayj0YNagSmC
	 ABCZn/A4sYm6LgMVWWRerIvwNXsKmAUtN6KjEwrEOGOSnzJ5Yo50ZpGIe/xMZ2v5yX
	 OFbUiq7QWWWHkxYZiGP41hPUoXggdMj2DZtryVN6pHQxjhF4TEe+UKK4sxuSsdLeD9
	 JlTShLRnTD+0SRVPvO70QrZ1Uy/OTsg1wTqFXphUYj6Izv1aZYqUXsMoBNBblumf5v
	 4Sk/uR/X1nQhg==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=45.249.212.187; helo=szxga01-in.huawei.com; envelope-from=yangyingliang@huawei.com; receiver=<UNKNOWN>)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4MtpD10PVWz3cDb
	for <linux-erofs@lists.ozlabs.org>; Fri, 21 Oct 2022 13:23:12 +1100 (AEDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.56])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mtp7V36sMzpVfQ;
	Fri, 21 Oct 2022 10:19:18 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 10:22:38 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 21 Oct
 2022 10:22:37 +0800
To: <linux-kernel@vger.kernel.org>, <qemu-devel@nongnu.org>,
	<linux-f2fs-devel@lists.sourceforge.net>, <linux-erofs@lists.ozlabs.org>,
	<ocfs2-devel@oss.oracle.com>, <linux-mtd@lists.infradead.org>,
	<amd-gfx@lists.freedesktop.org>
Subject: [PATCH 02/11] kset: add null pointer check in kset_put()
Date: Fri, 21 Oct 2022 10:20:53 +0800
Message-ID: <20221021022102.2231464-3-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221021022102.2231464-1-yangyingliang@huawei.com>
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
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
From: Yang Yingliang via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Yang Yingliang <yangyingliang@huawei.com>
Cc: alexander.deucher@amd.com, richard@nod.at, mst@redhat.com, gregkh@linuxfoundation.org, somlo@cmu.edu, huangjianan@oppo.com, liushixin2@huawei.com, joseph.qi@linux.alibaba.com, luben.tuikov@amd.com, jlbec@evilplan.org, hsiangkao@linux.alibaba.com, rafael@kernel.org, jaegeuk@kernel.org, akpm@linux-foundation.org, mark@fasheh.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

kset_put() can be called from drivers, add null pointer
check to make it more robust.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 include/linux/kobject.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 57fb972fea05..e81de8ba41a2 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -195,7 +195,8 @@ static inline struct kset *kset_get(struct kset *k)
 
 static inline void kset_put(struct kset *k)
 {
-	kobject_put(&k->kobj);
+	if (k)
+		kobject_put(&k->kobj);
 }
 
 static inline const struct kobj_type *get_ktype(struct kobject *kobj)
-- 
2.25.1

