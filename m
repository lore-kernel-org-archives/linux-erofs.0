Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61EBAD149F4
	for <linux-erofs@archiver.kernel.org>; Fri, 25 Oct 2024 20:40:42 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4XZvn44Bncz3brB
	for <linux-erofs@archiver.kernel.org>; Sat, 26 Oct 2024 07:40:40 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1729888839;
	cv=none; b=lBX0iCkZlY1BymG9+eZ70fbiSAZN9VCl8yXD7236Wn2WHMzkmJPA8PiEAKh0bY6Vn3o529JveW2mm0sCZ7W7mPFn7RaHtFxuFSOgM1C/d8Z4WX+63hz/XXYx3Qaa5vbhyzyU+bgY1VRB3sv+Ud6IhjFGG3xTiV1VWJuNFKRGpxFHdh0NivbbUGWO885v8MyvjZvRsSG1HpSWgL8D02zL4caqdePvN7wOp2S5gc314XsISnUWxKg/tm2NnlSXY0bNa9MoZ+JBI+zKG2JZNLhQCsxf6wnXRB5ANONIu2G6k64rucGIZBXdMdSte4H/ntFkEL01WS1jBGF8ogFPnZyDeg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1729888839; c=relaxed/relaxed;
	bh=SueMPOdHep9t3PCuklU6bVWhougpE6WyFc4wdjmYJYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFvBkkFNexcaEzlLhjlZu6ehYGX/xYH8eeYZMZj4bZZjfK+b3heZwcGDywRlMluHA6U6pp63EQjR8G0yfBexzNbIofAT7YyGLyuf0DNYiihTDB5BQDiGiqaAYowSNhSenanLWnJdgmrBP2tSEld357PlSD5IrKTvYxpgVtdKM/YJSduMquZk8Nh9v5yUjYgx46A+w4MdSJs/mOzwqnxeOiBjJSG15hxFg3mA3TmfWocAEi0Wmm1+xXntwCxortywmYLFISisXC6s6X/oGvCHhrLGwKT+3z8aOFThXwsI3pdHEqiMWkgyTZQh6of4/vgKeOaet+ewMNrcxqTWX1U00g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=c3JqCMmc; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=c3JqCMmc; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=c3JqCMmc;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=c3JqCMmc;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4XZvn225k4z2xPZ
	for <linux-erofs@lists.ozlabs.org>; Sat, 26 Oct 2024 07:40:38 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729888835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SueMPOdHep9t3PCuklU6bVWhougpE6WyFc4wdjmYJYc=;
	b=c3JqCMmcp1tnliSUOU4TZ3QUf7nIm7wcjPqnVTqSNsM1orGIaVUAgpHbqjVqfrH5R4t1L9
	GCo7T/ZpRqD+SUSIchewpA3H84sAyeTXc9qS3IRjgsoXCfL7fTjlafL9anh6U9tcRR3BLy
	lFyM89ITOQxyiJ67SxbU+sxx71oRU0s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729888835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SueMPOdHep9t3PCuklU6bVWhougpE6WyFc4wdjmYJYc=;
	b=c3JqCMmcp1tnliSUOU4TZ3QUf7nIm7wcjPqnVTqSNsM1orGIaVUAgpHbqjVqfrH5R4t1L9
	GCo7T/ZpRqD+SUSIchewpA3H84sAyeTXc9qS3IRjgsoXCfL7fTjlafL9anh6U9tcRR3BLy
	lFyM89ITOQxyiJ67SxbU+sxx71oRU0s=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-134-uukyL2R_PNGmxVmD_0NbMA-1; Fri,
 25 Oct 2024 16:40:31 -0400
X-MC-Unique: uukyL2R_PNGmxVmD_0NbMA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C3DB31955F25;
	Fri, 25 Oct 2024 20:40:27 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.231])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 886E6196BB7D;
	Fri, 25 Oct 2024 20:40:21 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Steve French <smfrench@gmail.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v2 01/31] netfs: Remove call to folio_index()
Date: Fri, 25 Oct 2024 21:39:28 +0100
Message-ID: <20241025204008.4076565-2-dhowells@redhat.com>
In-Reply-To: <20241025204008.4076565-1-dhowells@redhat.com>
References: <20241025204008.4076565-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
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
 

