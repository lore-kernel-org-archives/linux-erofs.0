Return-Path: <linux-erofs+bounces-3910-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 947E4C4450A
	for <linux-erofs@archiver.kernel.org>; Thu, 16 Jul 2026 10:32:06 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h18VY0wtwz30BJ;
	Thu, 16 Jul 2026 20:32:05 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784197925;
	cv=none; b=TKcF24YRcDjk7wEbhsiY1/JxXV4yQXcvAFQVgXWsJ8FqIDPpS1GDvwM0YewycPsozZ1fLJ2HpPyT8tdBl3XJd/4HSkeo0gGqg37sM3naepUzy9TuPOYGv9buArGbP7qEX/dTs7xdQa1DyanbcL1YngOs5B69uAdCwVvwgsiTOSyyCKogjXA+41yL72A020tH4VCrqlIYpuia9Izz1Uo/Tsghezktqzfdj3NnM7hSRNEH9d6jhff5qAMKvtW/lvW5NfuQGFRzpGDwdm78NC3jFeaqhh3K7jwOSjphyFvl9m5S73JWnHLXSbwy7jzTcGfiXFTOgfymv4Yn0DLTlD7LWg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784197925; c=relaxed/relaxed;
	bh=9RuMIYaYxQ3aZE1J/C1CbAmhDK6Ryjd7CE/reIVD6Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=cgpWyQ1Du6EByqMwK15VJ3vUXyPYLFIIc/FQ5ylkdABXjfwpTasFhv8LpJfeMkkrDWvcQQAvkHDRGLeOzjvGvul1dkONNlplfdYHYjL2gZb1/I96smU3RwrybjesCsJjHPhpmJ62mFHjsEMzeov617QvgTmIzRSrtd9VwZeX02Aa5jtD4tN/+TXEMZV/PAvaBqd3/C3Ul5qIH7Im/EPHcmd4+zC6iHBscvk6XJuUxpKWNfLKXj+0RYqgLGodg9mn6UK1R2+xS01FQYmTEXIPAW053KaoR8S8RuT/0NStrgaSAPcjzhSmOQItK55m8WJ1cpn+KX0fN/gOlKiwO/dhCg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=BNt939Z+; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bP7oXDEV; dkim-atps=neutral; spf=permerror (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=BNt939Z+;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bP7oXDEV;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=permerror (SPF Permanent Error: Void lookup limit of 2 exceeded) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h18VW69bnz30B0
	for <linux-erofs@lists.ozlabs.org>; Thu, 16 Jul 2026 20:32:03 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784197920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9RuMIYaYxQ3aZE1J/C1CbAmhDK6Ryjd7CE/reIVD6Co=;
	b=BNt939Z+oGjBSHL4BCYT+oS+oPPqDBzFmusgT5vF570TUpPPe9khFYb4BBquCqKUXFTeCp
	4tLZbEojmWKz/pjs34KVHY6uCFTNgkdaNOC0Q/iieAXnCe0+ieycnQwTY5rgER5Dj/Qllj
	e8+mw7alrZlv47fBxjhEWi6VWcA3F+8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784197921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9RuMIYaYxQ3aZE1J/C1CbAmhDK6Ryjd7CE/reIVD6Co=;
	b=bP7oXDEVzX8G7GJWMgjhmanu5NjD8LhkX7GA3WCBxBnTGANS2m7/p4ez87GmiWahMUTvAM
	/CYh/igzZhBs6IZnnC1X2E/S7SiTmpbJMQNIp0sWUKgvtfB8dOBNnlFe866XxgUNKLqR67
	CxTAnxN9Rt9ETm046mZkgyl+dWAFR64=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-562-jrktmlciO6-DTPN_f8ZiAA-1; Thu,
 16 Jul 2026 06:31:57 -0400
X-MC-Unique: jrktmlciO6-DTPN_f8ZiAA-1
X-Mimecast-MFC-AGG-ID: jrktmlciO6-DTPN_f8ZiAA_1784197914
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3F07A18002C2;
	Thu, 16 Jul 2026 10:31:54 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.159])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1D1BE1956042;
	Thu, 16 Jul 2026 10:31:47 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Jens Axboe <axboe@kernel.dk>,
	Leon Romanovsky <leon@kernel.org>,
	Steve French <sfrench@samba.org>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Stefan Metzmacher <metze@samba.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v6 08/24] afs: Fix afs_edit_dir_remove() to get, not find, block 0
Date: Thu, 16 Jul 2026 11:30:07 +0100
Message-ID: <20260716103030.3065561-9-dhowells@redhat.com>
In-Reply-To: <20260716103030.3065561-1-dhowells@redhat.com>
References: <20260716103030.3065561-1-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: EADRudTRFTnIesM5QKvTqsZ1s-e7jSMcpCAmz5q5wQU_1784197914
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Fix afs_edit_dir_remove() to use afs_dir_get_block() to get block 0 rather
than afs_dir_find_block() as the latter caches the found block in the
afs_dir_iter and may[*] switch out the page it's on if another
afs_dir_find_block() is done.  This parallels what afs_edit_dir_add() does.

[*] There's more than one block per page.

Fixes: a5b5beebcf96 ("afs: Use the contained hashtable to search a directory")
Closes: https://sashiko.dev/#/patchset/20260706153408.1231650-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
cc: stable@vger.kernel.org
---
 fs/afs/dir_edit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/dir_edit.c b/fs/afs/dir_edit.c
index fd3aa9f97ce6..3ead36a07048 100644
--- a/fs/afs/dir_edit.c
+++ b/fs/afs/dir_edit.c
@@ -415,7 +415,7 @@ void afs_edit_dir_remove(struct afs_vnode *vnode,
 	if (!afs_dir_init_iter(&iter, name))
 		return;
 
-	meta = afs_dir_find_block(&iter, 0);
+	meta = afs_dir_get_block(&iter, 0);
 	if (!meta)
 		return;
 


