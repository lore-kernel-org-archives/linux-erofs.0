Return-Path: <linux-erofs+bounces-4679-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF43CCA600C
	for <linux-erofs@archiver.kernel.org>; Thu,  8 Oct 2026 15:37:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j0vJL5KXCz2yYK;
	Fri, 09 Oct 2026 02:37:38 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791473858;
	cv=none; b=Hjw9suKZOSHSzz8h3TsQCOwxZeXr0ShMdradtUN/pjwMON+mFDt4dHxmtTzOzt+TuW/d9Q5Mj44zWH5qvdfXDPz8bVy+f+sRt7aDtUNN1cor2VRZ8k0w9b00TPwxCuEP1L3/TazeZ7tPKQe/ASqZExchn62SqWYkHJW4Fg+na8zeTSzTzfPYfYHLy2rM2LO83mjbVxtegtiqe2iq0V+hI7ii55G408ktJFKIi5B0ecatt3JVPr5jRIuyqTiJvZ6QexnhmQPzEaYz7aHSCwtkZ7ktP54Kr/WmeZU1y7BOr5WOMjfqhE7o7eSWmN2s/4SWmL9kwXz6drA637NRsmC7iw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791473858; c=relaxed/relaxed;
	bh=q2vRo77bLcmiimJzYUxVrzyOeslFSyHDZgW/3tMMbLY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=CwsCh5WlMHRi8kQM4PHB4v8fZs/2XtFDF3/BhBjBYge38GjRRr0qL4G0JuLId1z+4V9KK0LPedZiWEcO36fcLEE462hucXfeW7oYCdSd1qLs/ZG0New1UhcbK6TTsM8lgjdiDm3Ji4FenC8VIWCPCoeSVR2zhpwN3jHYVxHZ+YZCpOjyG2EOuAjlFVc9WtJIvbreRfZyzZ6vEcVWLqOg4HAkuu7mZNDvIiwnC14Sq9uw6GrV0HpJ/xDxEiYylAcQz0llfKMpAUQ5Uqd2umXsR36/kPChmAKgqP580aCOws3SdEwl8bmZf66IkbYvVo6/DvXude4HySgabUDCstEqUw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=HHhUL6eD; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=devnull+sadmanf.meta.com@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=HHhUL6eD;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=devnull+sadmanf.meta.com@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j0vJK5MbHz2yMn
	for <linux-erofs@lists.ozlabs.org>; Fri, 09 Oct 2026 02:37:37 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A1E4A44044;
	Thu,  8 Oct 2026 15:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83983C2BCC7;
	Thu,  8 Oct 2026 15:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791473854;
	bh=BubYJH38unV8hXWszzJQrFOPQBmZQHcnr0GM1uf9www=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=HHhUL6eDMYuqMlByeVCw0McZBcK4imsApBWg6SmjOf/JqHFg9PbSVwDU8TxU1TKB7
	 ZOnr+7cksLoaZNiXM6BJxh6RYGZX78+br/wdq6sNi94Z8yvgizW8nX264xGA6qRdmg
	 TNsitzUjVgLSyBSRj788CHz01MWK20lHDZCnHQTK1zzSXDzIG1Drt9r6LzPLfNFTYn
	 sB3GQ3H3r5NnFnyuMPqFdkw4nQWZkfVYBXdE/lUgSihyRo+mwdKRKMPrfG67+lf4dq
	 RIwu1WsseLSDZ+ZyXuFV1w9Ywfp6sX88ogXoWs91m9blpEROimjiXr/6DMv/q7Vyim
	 Srx/QX8PKrseQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555C9CA600B;
	Thu,  8 Oct 2026 15:37:34 +0000 (UTC)
From: Sadman Fahmid via B4 Relay <devnull+sadmanf.meta.com@kernel.org>
Date: Thu, 08 Oct 2026 11:37:32 -0400
Subject: [PATCH] erofs-utils: tar: fix source path leak
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
Message-Id: <20261008-chunking-tar-srcpath-v1-v1-1-0d79d76a1593@meta.com>
X-B4-Tracking: v=1; b=H4sIALu4x2oC/x3NQQ6CMBCF4auQWTuxECXGqxgX0zK0E3VopkBIC
 He3uvwW7387FDbhAvdmB+NVikxa0Z4aCIk0MspQDZ3r+ta5G4a06Es04kyGxUKmOeHaohsH7j1
 drm70UNfZeJTtX348qz0VRm+kIf16k0kUPfOW6/+HdaY3HMcX7g2PwY8AAAA=
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org, jefflexu@linux.alibaba.com, 
 Sadman Fahmid <sadmanf@meta.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791473853; l=1125;
 i=sadmanf@meta.com; s=20261006; h=from:subject:message-id;
 bh=WbKflU4BUacdGyvko5EelvmAxg0hh/Mo+mElmyPInfw=;
 b=cYrFBGBHj7wbAKZvupATfm1OoFa0PO2VSydBO6mOp/yK5oC44JNNJeueq2Kz0qlZaML28AzdK
 Acuu7apVXBSCFNZycMuEW2dMO16sECZApgYQyBsxIkj0M3syPXdfezX
X-Developer-Key: i=sadmanf@meta.com; a=ed25519;
 pk=Pc/arXJpm1RPef8qImFuHROn1p3XNX5MWSUxjZWNTa4=
X-Endpoint-Received: by B4 Relay for sadmanf@meta.com/20261006 with
 auth_id=1125
X-Original-From: Sadman Fahmid <sadmanf@meta.com>
Reply-To: sadmanf@meta.com

From: Sadman Fahmid <sadmanf@meta.com>

Tar import leaks the previous `i_srcpath` allocation when updating
an existing directory or root inode. Free the old string before
assigning the new path.

Fixes: 95d315fd7958 ("erofs-utils: introduce tarerofs")
Signed-off-by: Sadman Fahmid <sadmanf@meta.com>
---
Tested with Clang 21 ASan/UBSan and LeakSanitizer enabled. A tar
containing explicit root and directory headers, a child file, and
repeated root/directory headers leaks 14 bytes on the baseline.
With this patch the import exits successfully without a leak report
and produces an identical EROFS image.
---
 lib/tar.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/tar.c b/lib/tar.c
index f24ad95..c99ce3c 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -1165,6 +1165,7 @@ new_inode:
 			inode->u.i_rdev = erofs_new_encode_dev(st.st_rdev);
 	}
 
+	free(inode->i_srcpath);
 	inode->i_srcpath = strdup(eh.path);
 	if (!inode->i_srcpath) {
 		ret = -ENOMEM;

---
base-commit: 50c29ee8d0f88fcec28d492d01eb7ca8715f5961
change-id: 20261008-chunking-tar-srcpath-v1-0fde6ba450fb

Best regards,
-- 
Sadman Fahmid <sadmanf@meta.com>



