Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7162BCE8E78
	for <linux-erofs@archiver.kernel.org>; Thu, 24 Oct 2024 14:06:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4XZ74V53Vwz3bdV
	for <linux-erofs@archiver.kernel.org>; Fri, 25 Oct 2024 01:06:18 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1729778776;
	cv=none; b=T/MacHi9FHE1VX4rnvTu59qeZuk6glZOE7HDOTuJJlbcV0J/ufxOIHTOG8UCcBM0Pfaw9DMDxJnQ/cH6jQaAct5Qqe8z/LQ2STPPwXdMk5R1hmaRI9xWvYpAG5VQ+SWrOEj1V1D4XTaVThG3pKdzUgv/TqE9hWFa89QqebwJNyX3vtanwdt8HubXo2YEC5c2Np+ZkoGgtMLoJpDAE/SLlgKXzvF0vVCij5uN4tkyzI/yoZMgzOSxXYFEXzTwsetSBb+fS+ssf6RbDZ4sV3gi3C2t0sFBoQ/pA07W/c2mGbdt9r/cgBkiQmIcMgyZ9qgDoDpEFV7UZB5QFVxJvyclew==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1729778776; c=relaxed/relaxed;
	bh=SueMPOdHep9t3PCuklU6bVWhougpE6WyFc4wdjmYJYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BUq1z8YUspX39viWNnutKDEuREvgW47ESC3Vw+PFlBdp3jlxmtx6a9A2ZH/LiK7ddpoxhLABwF9PflEX/cUQYCt7d7TVtIJJBrnliaBnBQB48eVCS9843VDW3OCT/OKhep9csxy/lqw7zOySXQc9SwUjJ6Ccz7Uk1rQAbhbTSVAyq5DTSBqSiDgUUqAA6oQUKYEYKzMvQaSJkgovq5VWhgghf4jVWv29bby0oo52G01HjxQ1vtPearA+VFpVkPajNJbnL0euf/jOHV0ULQOzy4TweZLg3yaDxJ7eQV/+cr1MjU33SjS6IBFEqoPy4xA5S4NXrVck+dczSSXsgktFHw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HHycd7oa; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HHycd7oa; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HHycd7oa;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HHycd7oa;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4XZ74R2v6Mz3blF
	for <linux-erofs@lists.ozlabs.org>; Fri, 25 Oct 2024 01:06:14 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729778771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SueMPOdHep9t3PCuklU6bVWhougpE6WyFc4wdjmYJYc=;
	b=HHycd7oaiR5IkV+odsZ8PANuVc0UBA44zU9ln/CUumPnW0vSgWyOnXSH0hM8whpwbshw3Z
	249h2F6RyH+sFkKVUyDcYHKGMdVUCeLkxkXt86WJnOocMq7hD/G8gfOnwM/BF7nJ/RoMtI
	mvAsVKbtVE6Bo8/NOmKPOVrtVXUZV1s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729778771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SueMPOdHep9t3PCuklU6bVWhougpE6WyFc4wdjmYJYc=;
	b=HHycd7oaiR5IkV+odsZ8PANuVc0UBA44zU9ln/CUumPnW0vSgWyOnXSH0hM8whpwbshw3Z
	249h2F6RyH+sFkKVUyDcYHKGMdVUCeLkxkXt86WJnOocMq7hD/G8gfOnwM/BF7nJ/RoMtI
	mvAsVKbtVE6Bo8/NOmKPOVrtVXUZV1s=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-220-69oGyEVANHudqYkVi238wQ-1; Thu,
 24 Oct 2024 10:06:07 -0400
X-MC-Unique: 69oGyEVANHudqYkVi238wQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0886E1955E75;
	Thu, 24 Oct 2024 14:06:03 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.231])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D2CAC30001A7;
	Thu, 24 Oct 2024 14:05:55 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Steve French <smfrench@gmail.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 01/27] netfs: Remove call to folio_index()
Date: Thu, 24 Oct 2024 15:04:59 +0100
Message-ID: <20241024140539.3828093-2-dhowells@redhat.com>
In-Reply-To: <20241024140539.3828093-1-dhowells@redhat.com>
References: <20241024140539.3828093-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
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
Cc: Dominique Martinet <asmadeus@codewreck.org>, David Howells <dhowells@redhat.com>, linux-mm@kvack.org, Marc Dionne <marc.dionne@auristor.com>, linux-afs@lists.infradead.org, Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org, Gao Xiang <hsiangkao@linux.alibaba.com>, Ilya Dryomov <idryomov@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Christian Brauner <brauner@kernel.org>, Tom Talpey <tom@talpey.com>, ceph-devel@vger.kernel.org, Eric Van Hensbergen <ericvh@kernel.org>, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, v9fs@lists.linux.dev, Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, netfs@lists.linux.dev, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Calling folio_index() is pointless overhead; directly dereferencing
folio->index is fine.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://lore.kernel.org/r/20241005182307.3190401-2-willy@infradead.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 include/trace/events/netfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index 69975c9c6823..bf511bca896e 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -450,7 +450,7 @@ TRACE_EVENT(netfs_folio,
 		    struct address_space *__m = READ_ONCE(folio->mapping);
 		    __entry->ino = __m ? __m->host->i_ino : 0;
 		    __entry->why = why;
-		    __entry->index = folio_index(folio);
+		    __entry->index = folio->index;
 		    __entry->nr = folio_nr_pages(folio);
 			   ),
 

