Return-Path: <linux-erofs+bounces-3224-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A532B1073CB6
	for <linux-erofs@archiver.kernel.org>; Wed,  8 Apr 2026 13:31:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4frP8p1nRNz2yDk;
	Wed, 08 Apr 2026 23:31:06 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775655066;
	cv=none; b=PqJlbNzsXsmWNA1gyH3SiXKbVrsxhv8j9xBIBQbDvV2Nx8FimAcERQJpI0570Ccy+Pnos62+ud9nqX9f76v2wDajF37m91vnGeTQwmJ5BXlBNEY9vzR3yqneN1wC2h1AW/0+ayayZ0CVlwUksQ7VdSSACWmN92xMUMwjZT93Hv5XxeQsKga1D/7XWrpwADEenBdJGw6tQ+P9J1WseShGBA/LCOMofZN0WEOlZpzKJ5lzEz/9S2Rr9YV6XKceqA670Uo6EiCNCx4Vs72ZUYzJCCOXLRvpgqzVdfFy5gU/OhjAhSHGg+pwLWnAXtpY5qZvH2zGBbdm3DJuRHyzuehXOw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775655066; c=relaxed/relaxed;
	bh=Lr80YW4Ev+30NTXEErpRgkc/cVojvScOv6Ic7nKQaZ4=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=jFno2kdG4dXyhHclGDlTOtfMaIKmfTFK2ZGsPv0wYp/1+s4Izy/lwm+Tev/oxKVisr7jX5qof34ZhFXJgTeNFGhIE9yiotWLaV47e7KmhF+1Vla+O3TuQ3oxkNFBHDM/YUE/HYussx08O5uA12i1aAk66MX7cEQtUoejSdXZqm1m/wa3dGSEB1jURVhQBaioDlXVE0YoIj3vhFpxiPL7CYUnFO5mcn0pFtw4bBp2zBi7sI/Nuy9OhEKsI2wlKUz8nqblcPSGJtNOpfqY2ykXTOYk6kxAM6O4xd3omVhD2IHHvqIKdD8h9ZMyYmAbQT7Fw7c+ceCc4pdCc7m/DZik7A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; dkim=pass (1024-bit key; unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZtaCFSz; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=gregkh@linuxfoundation.org; receiver=lists.ozlabs.org) smtp.mailfrom=linuxfoundation.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZtaCFSz;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linuxfoundation.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=gregkh@linuxfoundation.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4frP8n0RCsz2xc8
	for <linux-erofs@lists.ozlabs.org>; Wed, 08 Apr 2026 23:31:04 +1000 (AEST)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 04C31600CB;
	Wed,  8 Apr 2026 13:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6194BC19421;
	Wed,  8 Apr 2026 13:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775655061;
	bh=8w2wFbPmSiBJM2rOTB4NhKlUFWHdEa3fArpzoZMnJno=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=hZtaCFSzwxPUMaJDDQGG//NvaFPhJ9Rnp2/1lc8ye5uFFyUd7gKLTwNGLCZiKIgC3
	 FnbxujtWs2cMigHQu1LNJI4hpRUAoZlzgBwKZuHNgQ4LzgZsfPVnMRfSpRcP8vddW/
	 yQRcLIzTz133HFSXk38L9mNzZxEIa4+zr9qWIUTM=
Subject: Patch "erofs: fix PSI memstall accounting" has been added to the 6.1-stable tree
To: apanov@astralinux.ru,chao@kernel.org,gregkh@linuxfoundation.org,hsiangkao@linux.alibaba.com,linux-erofs@lists.ozlabs.org,max.kellermann@ionos.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Wed, 08 Apr 2026 15:30:51 +0200
In-Reply-To: <20260327043359.1121251-1-hsiangkao@linux.alibaba.com>
Message-ID: <2026040851-grip-nylon-91fb@gregkh>
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
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    erofs: fix PSI memstall accounting

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     erofs-fix-psi-memstall-accounting.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-230584-greg=kroah.com@vger.kernel.org Fri Mar 27 05:34:18 2026
From: Gao Xiang <hsiangkao@linux.alibaba.com>
Date: Fri, 27 Mar 2026 12:33:59 +0800
Subject: erofs: fix PSI memstall accounting
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-erofs@lists.ozlabs.org, Gao Xiang <hsiangkao@linux.alibaba.com>, Max Kellermann <max.kellermann@ionos.com>, Chao Yu <chao@kernel.org>, Alexey Panov <apanov@astralinux.ru>
Message-ID: <20260327043359.1121251-1-hsiangkao@linux.alibaba.com>

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit 1a2180f6859c73c674809f9f82e36c94084682ba upstream.

Max Kellermann recently reported psi_group_cpu.tasks[NR_MEMSTALL] is
incorrect in the 6.11.9 kernel.

The root cause appears to be that, since the problematic commit, bio
can be NULL, causing psi_memstall_leave() to be skipped in
z_erofs_submit_queue().

Reported-by: Max Kellermann <max.kellermann@ionos.com>
Closes: https://lore.kernel.org/r/CAKPOu+8tvSowiJADW2RuKyofL_CSkm_SuyZA7ME5vMLWmL6pqw@mail.gmail.com
Fixes: 9e2f9d34dd12 ("erofs: handle overlapped pclusters out of crafted images properly")
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20241127085236.3538334-1-hsiangkao@linux.alibaba.com
Signed-off-by: Alexey Panov <apanov@astralinux.ru>
Link: https://lore.kernel.org/r/20250304110558.8315-3-apanov@astralinux.ru
Link: https://lore.kernel.org/r/20250304110558.8315-1-apanov@astralinux.ru
[ Gao Xiang: re-address the previous Alexey's backport. ]
CVE: CVE-2024-47736
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/zdata.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1574,11 +1574,10 @@ drain_io:
 			move_to_bypass_jobqueue(pcl, qtail, owned_head);
 	} while (owned_head != Z_EROFS_PCLUSTER_TAIL);
 
-	if (bio) {
+	if (bio)
 		submit_bio(bio);
-		if (memstall)
-			psi_memstall_leave(&pflags);
-	}
+	if (memstall)
+		psi_memstall_leave(&pflags);
 
 	/*
 	 * although background is preferred, no one is pending for submission.


Patches currently in stable-queue which might be from hsiangkao@linux.alibaba.com are

queue-6.1/erofs-fix-psi-memstall-accounting.patch
queue-6.1/erofs-add-gfp_noio-in-the-bio-completion-if-needed.patch
queue-6.1/erofs-handle-overlapped-pclusters-out-of-crafted-images-properly.patch
queue-6.1/erofs-fix-the-slab-out-of-bounds-in-drop_buffers.patch

